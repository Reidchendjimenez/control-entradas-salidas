import asyncio
import concurrent.futures
import inspect
import os
import time
from functools import partial
import flet as ft
from usr.logger import get_logger
from usr.error_handler import show_error
from usr.theme import get_theme

logger = get_logger(__name__)


class ControlEntradasSalidasApp:
    def __init__(self):
        self.page: ft.Page = None
        self.navigation_rail = None
        self.navigation_bar = None
        self.content_area = None
        self._view_stack = None
        self.current_view = None
        self.current_view_index = 0
        self.views = []
        self._layout_row = None
        self.settings = None
        self._switching_view = False
        self._pending_view = None  # Intención de naveg. encolada durante un barrido
        self._switch_start = 0.0
        self._SWITCH_TIMEOUT = 20.0  # s: recuperación si una carga se cuelga
        self._is_mobile_layout = False
        self._watchdog_task = None
        # Traza de depuración del flujo de cambio de vista. Actívale con
        # TRACE_SWITCH=1 para ver en el log en qué punto exacto se detiene.
        self._trace_enabled = os.environ.get("TRACE_SWITCH") == "1"
        self._trace_last = 0.0

    VIEW_META = {
        0: ("Inventario", "Gestión de existencias", ft.Icons.SHOPPING_CART_OUTLINED),
        1: ("Validación", "Vincular entradas a facturas", ft.Icons.CHECKLIST_OUTLINED),
        2: ("Stock", "Control e inventario de productos y pesaje", ft.Icons.WAREHOUSE_OUTLINED),
        3: ("Producciones", "Recetas y órdenes de producción", ft.Icons.FACTORY_OUTLINED),
        4: ("Requisiciones", "Gestión de traslados", ft.Icons.LOCAL_SHIPPING_OUTLINED),
        5: ("Historial", "Facturas y registro de entradas", ft.Icons.HISTORY_OUTLINED),
        6: ("Configuración", "Categorías y catálogo de productos", ft.Icons.SETTINGS_OUTLINED),
        7: ("Bandeja", "Mensajes y respuestas de WhatsApp", ft.Icons.MAIL_OUTLINED),
    }

    async def arrancar_interfaz(self, page: ft.Page, settings, vistas_cargadas):
        self.page = page
        self.settings = settings
        try:
            from usr.database.base import init_local_tables
            init_local_tables()

            from usr.views import InventarioView, ValidacionView, StockView, ProduccionesView, ConfiguracionView, HistorialFacturasView, RequisicionesView, BandejaWhatsAppView
            v_inv = InventarioView()
            v_val = ValidacionView()
            v_sto = StockView()
            v_pro = ProduccionesView()
            v_req = RequisicionesView()
            v_his = HistorialFacturasView()
            v_cfg = ConfiguracionView()
            v_ban = BandejaWhatsAppView()
            v_req.inventario_view = v_inv
            v_req.app_controller = self
            v_inv.app_controller = self
            v_val.app_controller = self
            v_cfg.app_controller = self

            self.views = [
                v_inv,    # 0
                v_val,    # 1
                v_sto,    # 2
                v_pro,    # 3
                v_req,    # 4
                v_his,    # 5
                v_cfg,    # 6
                v_ban,    # 7
            ]

            self.page.title = self.settings.FLET_APP_NAME
            self.page.theme_mode = ft.ThemeMode.DARK
            self.page.padding = 0
            self.page.spacing = 0
            self.page.expand = True

            self._setup_theme()
            self._create_layout()
            self._handle_responsive_layout(self.page.width)
            self._register_sync_callback()
            self._show_view(0)

            self.page.on_resized = self._on_page_resized
            self.page.update()
        except Exception as e:
            logger.error(f"Error crítico en arrancar_interfaz: {e}", exc_info=True)
            show_error("Error al iniciar la interfaz", e, "ControlEntradasSalidasApp.arrancar_interfaz")

    def _setup_theme(self):
        if not self.page:
            return
        self.page.theme = ft.Theme(color_scheme_seed=ft.Colors.DEEP_PURPLE_700, visual_density=ft.VisualDensity.COMFORTABLE, use_material3=True)
        self.page.bgcolor = get_theme(True)['bg']

    def _header_colors(self):
        is_dark = getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT
        c = get_theme(is_dark)
        return {
            'bg': c['header_bg'],
            'title': c['header_title'],
            'subtitle': c['header_subtitle'],
            'icon': c['header_icon'],
        }

    def _update_header(self, index: int):
        try:
            if not hasattr(self, 'app_header'):
                return
            meta = self.VIEW_META.get(index, ("", "", None))
            self.header_title.value = meta[0]
            self.header_subtitle.value = meta[1]
            if meta[2]:
                self.header_icon.name = meta[2]
            view = self.views[index] if self.views and 0 <= index < len(self.views) else None
            # Limpiar ambos contenedores: en móvil las acciones de la vista
            # anterior viven en _actions_bar_row y no deben mezclarse con las
            # nuevas de header_actions.
            self.header_actions.controls.clear()
            if hasattr(self, '_actions_bar_row') and self._actions_bar_row:
                self._actions_bar_row.controls.clear()
            if view and hasattr(view, 'get_header_actions'):
                try:
                    actions = view.get_header_actions()
                    self.header_actions.controls.extend(list(actions or []))
                except Exception as e:
                    logger.warning(f"get_header_actions de vista {index} falló: {e}")
            self._apply_header_actions_placement()
        except Exception as e:
            logger.error(f"Error en _update_header: {e}", exc_info=True)

    def _apply_header_actions_placement(self):
        """Coloca las acciones de la vista donde corresponde según el layout.

        Las acciones viven en self.header_actions (inline en escritorio) o en
        self._actions_bar_row (barra desplegable en móvil). Un control no puede
        tener dos padres a la vez, así que según el layout los movemos entre un
        lugar y otro.
        """
        try:
            # Recogemos las acciones del padre actual y reubicamos.
            acciones = list(self.header_actions.controls)
            if hasattr(self, '_actions_bar_row') and self._actions_bar_row:
                acciones.extend(self._actions_bar_row.controls)
            es_movil = bool(getattr(self, '_is_mobile_layout', False))
            self.header_actions.controls.clear()
            if hasattr(self, '_actions_bar_row') and self._actions_bar_row:
                self._actions_bar_row.controls.clear()
            if hasattr(self, 'actions_bar') and self.actions_bar:
                self.actions_bar.visible = False
            if es_movil:
                # En móvil las acciones van a la barra desplegable y se muestra
                # el botón toggle solo si hay acciones que desplegar.
                if hasattr(self, '_actions_bar_row') and self._actions_bar_row:
                    self._actions_bar_row.controls.extend(acciones)
                if hasattr(self, 'actions_toggle_button') and self.actions_toggle_button:
                    self.actions_toggle_button.visible = bool(acciones)
            else:
                self.header_actions.controls.extend(acciones)
                if hasattr(self, 'actions_toggle_button') and self.actions_toggle_button:
                    self.actions_toggle_button.visible = False
        except Exception as e:
            logger.debug(f"placement de acciones falló: {e}")

    def _toggle_actions_bar(self, e=None):
        """Muestra u oculta la barra de acciones bajo el encabezado (móvil).

        En móvil los botones de la vista actual (p.ej. Probar Bot / Reintentar
        todos de la Bandeja) no caben en el header, así que se mueven a esta
        barra y se despliegan al pulsar el botón toggle.
        """
        if self.page is None:
            return
        try:
            if hasattr(self, 'actions_bar') and self.actions_bar:
                self.actions_bar.visible = not self.actions_bar.visible
            try:
                self.page.update()
            except Exception:
                pass
        except Exception as ex:
            logger.debug(f"toggle actions bar falló: {ex}")

    def _toggle_theme(self, e=None):
        if not self.page:
            return
        try:
            is_dark = self.page.theme_mode != ft.ThemeMode.DARK
            self.page.theme_mode = ft.ThemeMode.DARK if is_dark else ft.ThemeMode.LIGHT
            c = get_theme(is_dark)
            self.page.bgcolor = c['bg']

            if hasattr(self, 'content_area') and self.content_area:
                self.content_area.bgcolor = c['surface']

            if hasattr(self, 'navigation_rail') and self.navigation_rail:
                self.navigation_rail.bgcolor = c['nav_bg']

            if hasattr(self, 'drawer_panel') and self.drawer_panel:
                self._refresh_drawer_style()
                self.drawer_panel.update()

            if hasattr(self, 'app_header') and self.app_header:
                hc = self._header_colors()
                self.app_header.bgcolor = hc['bg']
                self.header_title.color = hc['title']
                self.header_subtitle.color = hc['subtitle']
                self.header_icon.color = hc['icon']

            if self.current_view and hasattr(self.current_view, 'on_theme_change'):
                self.current_view.on_theme_change()

            if self.current_view_index is not None and hasattr(self, 'app_header'):
                self._update_header(self.current_view_index)

            self.page.update()
        except Exception as e:
            logger.error(f"Error en _toggle_theme: {e}", exc_info=True)
            show_error("Error al cambiar el tema", e, "ControlEntradasSalidasApp._toggle_theme")

    def _create_layout(self):
        try:
            self._layout_is_dark = getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT
            self._layout_dc = get_theme(self._layout_is_dark)
            # Las vistas se apilan en un Stack y el cambio es natural (sin
            # deslizamiento). Mientras una vista carga, se muestra un overlay
            # de carga encima del Stack para dar feedback inmediato al usuario.
            self._view_stack = ft.Stack(expand=True)

            self.loading_overlay = ft.Container(
                visible=False,
                expand=True,
                bgcolor=ft.Colors.with_opacity(0.55, ft.Colors.BLACK),
                alignment=ft.Alignment.CENTER,
                content=ft.Column([
                    ft.ProgressRing(width=38, height=38, stroke_width=3, color=self._layout_dc['accent']),
                    ft.Text("Cargando vista…", size=14, color=self._layout_dc['text_hint']),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER, expand=True, spacing=14),
            )

            # Drawer de navegación CUSTOM (overlay, lado izquierdo, pantalla
            # completa). Los drawers nativos (drawer/show_drawer y
            # end_drawer/show_end_drawer) timeoutean en este build de Flet
            # ("Timeout waiting for invoke method listener for View(...).show_*
            # drawer"), por lo que se construye a mano y se muestra alternando
            # .visible (sin tocar la API nativa rota).
            nav_items = [
                (ft.Icons.SHOPPING_CART_OUTLINED, "Inventario"),
                (ft.Icons.CHECKLIST_OUTLINED, "Validación"),
                (ft.Icons.WAREHOUSE_OUTLINED, "Stock"),
                (ft.Icons.FACTORY_OUTLINED, "Producciones"),
                (ft.Icons.LOCAL_SHIPPING_OUTLINED, "Requisiciones"),
                (ft.Icons.HISTORY_OUTLINED, "Historial"),
                (ft.Icons.SETTINGS_OUTLINED, "Ajustes"),
                (ft.Icons.MAIL_OUTLINED, "Bandeja"),
            ]
            is_dark = getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT
            dc = get_theme(is_dark)
            self._drawer_active_bg = dc['drawer_active_bg']
            self._drawer_active_fg = dc['drawer_active_fg']
            self._drawer_inactive_fg = dc['drawer_inactive_fg']
            self._drawer_on_surface = dc['drawer_on_surface']

            self.drawer_title = ft.Text(
                "Menú", size=22, weight=ft.FontWeight.BOLD, color=self._drawer_on_surface,
            )

            cur = self.current_view_index or 0
            self._drawer_items = []
            drawer_item_controls = []
            for i, (ic, lab) in enumerate(nav_items):
                sel = (i == cur)
                tile_icon = ft.Icon(ic, size=22, color=self._drawer_active_fg if sel else self._drawer_inactive_fg)
                tile_text = ft.Text(
                    lab, size=15,
                    color=self._drawer_active_fg if sel else self._drawer_inactive_fg,
                    weight=ft.FontWeight.W_600 if sel else ft.FontWeight.NORMAL,
                )
                tile = ft.Container(
                    bgcolor=self._drawer_active_bg if sel else None,
                    border_radius=ft.BorderRadius.all(12),
                    padding=ft.Padding.symmetric(horizontal=14, vertical=9),
                    animate=ft.Animation(150, ft.AnimationCurve.EASE_OUT),
                    animate_scale=ft.Animation(120, ft.AnimationCurve.EASE_OUT),
                    on_hover=lambda e, idx=i: self._on_drawer_tile_hover(e, idx),
                    on_click=partial(self._on_drawer_tile_click, i),
                    content=ft.Row([
                        tile_icon,
                        tile_text,
                    ], spacing=16, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                )
                self._drawer_items.append((tile, tile_icon, tile_text))
                drawer_item_controls.append(tile)

            self.drawer_panel = ft.Container(
                width=330,
                bgcolor=dc['drawer_bg'],
                border_radius=ft.BorderRadius.only(top_right=24, bottom_right=24),
                shadow=ft.BoxShadow(
                    blur_radius=24,
                    color=ft.Colors.with_opacity(0.35, ft.Colors.BLACK),
                    offset=ft.Offset(6, 0),
                ),
                padding=ft.Padding(top=28, bottom=12, left=8, right=8),
                content=ft.Column([
                    ft.Container(
                        content=self.drawer_title,
                        padding=ft.Padding(left=16, bottom=20, right=0, top=0),
                    ),
                    *drawer_item_controls,
                ], scroll=ft.ScrollMode.AUTO, spacing=4),
            )
            self.drawer_tiles = drawer_item_controls
            self.drawer_backdrop = ft.Container(
                expand=True,
                bgcolor=ft.Colors.with_opacity(0.45, ft.Colors.BLACK),
                on_click=lambda e: self._close_drawer(),
            )
            self.drawer_root = ft.Container(
                expand=True,
                visible=False,
                content=ft.Row(
                    [self.drawer_panel, self.drawer_backdrop],
                    spacing=0, vertical_alignment=ft.CrossAxisAlignment.STRETCH,
                ),
            )

            self.content_area = ft.Container(
                content=ft.Stack([self._view_stack, self.loading_overlay], expand=True),
                expand=True,
                bgcolor=get_theme(is_dark)['surface']
            )

            hc = self._header_colors()
            self.header_icon = ft.Icon(ft.Icons.SHOPPING_CART_OUTLINED, size=26, color=hc['icon'])
            self.header_title = ft.Text("", size=22, weight=ft.FontWeight.BOLD, color=hc['title'])
            self.header_subtitle = ft.Text("", size=12, color=hc['subtitle'])
            self.header_actions = ft.Row(
                spacing=4,
                alignment=ft.MainAxisAlignment.END,
                vertical_alignment=ft.CrossAxisAlignment.CENTER,
            )
            self.menu_button = ft.IconButton(
                icon=ft.Icons.MENU, tooltip="Abrir menú", on_click=self._open_drawer, visible=False,
            )
            # En móvil, los botones de acción que no caben en el header (p.ej.
            # los de la Bandeja) se mueven a una barra desplegable debajo del
            # encabezado. En escritorio se muestran inline en header_actions.
            self.actions_toggle_button = ft.IconButton(
                icon=ft.Icons.MORE_VERT, tooltip="Acciones de la vista",
                on_click=self._toggle_actions_bar, visible=False,
            )
            self._actions_bar_row = ft.Row(
                spacing=8,
                alignment=ft.MainAxisAlignment.END,
                vertical_alignment=ft.CrossAxisAlignment.CENTER,
            )
            self.actions_bar = ft.Container(
                content=self._actions_bar_row,
                bgcolor=hc['bg'],
                border_radius=ft.BorderRadius.all(14),
                padding=ft.Padding.symmetric(horizontal=16, vertical=8),
                visible=False,
            )
            self.header_right = ft.Row(
                [self.header_actions, self.actions_toggle_button],
                spacing=4, alignment=ft.MainAxisAlignment.END, vertical_alignment=ft.CrossAxisAlignment.CENTER,
            )
            # Separador flexible título/acciones; en móvil se desactiva para dar
            # todo el ancho a las acciones (que además se vuelven deslizables).
            self.header_spacer = ft.Container(expand=True)
            self.app_header = ft.Container(
                content=ft.Row([
                    self.menu_button,
                    self.header_icon,
                    ft.Column([self.header_title, self.header_subtitle], spacing=0),
                    self.header_spacer,
                    self.header_right,
                ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
                padding=ft.Padding.symmetric(horizontal=16, vertical=10),
                bgcolor=hc['bg'],
                border_radius=ft.BorderRadius.all(14),
            )

            self.navigation_rail = ft.NavigationRail(
                selected_index=0, extended=False, label_type=ft.NavigationRailLabelType.ALL, min_width=100, bgcolor=get_theme(is_dark)['nav_bg'],
                destinations=[
                    ft.NavigationRailDestination(icon=ft.Icons.SHOPPING_CART_OUTLINED, selected_icon=ft.Icons.SHOPPING_CART, label="Inventario"),
                    ft.NavigationRailDestination(icon=ft.Icons.CHECKLIST_OUTLINED, selected_icon=ft.Icons.CHECKLIST, label="Validación"),
                    ft.NavigationRailDestination(icon=ft.Icons.WAREHOUSE_OUTLINED, selected_icon=ft.Icons.WAREHOUSE, label="Stock"),
                    ft.NavigationRailDestination(icon=ft.Icons.FACTORY_OUTLINED, selected_icon=ft.Icons.FACTORY, label="Producciones"),
                    ft.NavigationRailDestination(icon=ft.Icons.LOCAL_SHIPPING_OUTLINED, selected_icon=ft.Icons.LOCAL_SHIPPING, label="Requisiciones"),
                    ft.NavigationRailDestination(icon=ft.Icons.HISTORY_OUTLINED, selected_icon=ft.Icons.HISTORY, label="Historial"),
                    ft.NavigationRailDestination(icon=ft.Icons.SETTINGS_OUTLINED, selected_icon=ft.Icons.SETTINGS, label="Ajustes"),
                    ft.NavigationRailDestination(icon=ft.Icons.MAIL_OUTLINED, selected_icon=ft.Icons.MAIL, label="Bandeja"),
                ], on_change=self._on_navigation_change,
            )

            self.navigation_bar = ft.NavigationBar(
                visible=False, bgcolor=ft.Colors.SURFACE_CONTAINER_HIGHEST,
                destinations=[
                    ft.NavigationBarDestination(icon=ft.Icons.SHOPPING_CART_OUTLINED, label="Inventario"),
                    ft.NavigationBarDestination(icon=ft.Icons.CHECKLIST_OUTLINED, label="Validar"),
                    ft.NavigationBarDestination(icon=ft.Icons.WAREHOUSE_OUTLINED, label="Stock"),
                    ft.NavigationBarDestination(icon=ft.Icons.MORE_VERT, label="Más"),
                ], on_change=self._on_navigation_change,
            )

            self.sync_status_bar = ft.Container(
                height=0, visible=True,
                bgcolor=self._layout_dc['card'],
                padding=ft.Padding.symmetric(horizontal=12, vertical=0),
                border_radius=ft.BorderRadius.all(8),
                content=ft.Row([
                    ft.ProgressRing(width=14, height=14, stroke_width=2, color=self._layout_dc['accent']),
                    ft.Text("", size=12, color=self._layout_dc['text_hint'], expand=True, no_wrap=False),
                ], spacing=8, alignment=ft.MainAxisAlignment.START),
            )

            self._layout_row = ft.SafeArea(content=ft.Column([
                self.app_header,
                self.actions_bar,
                ft.Row([self.navigation_rail, self.content_area], expand=True, spacing=0, vertical_alignment=ft.CrossAxisAlignment.STRETCH),
            ], spacing=8), expand=True)
            self._root_stack = ft.Stack([self._layout_row, self.drawer_root], expand=True)
            self.page.clean()
            self.page.padding = 5
            self._sync_safe = ft.SafeArea(
                content=self.sync_status_bar,
                avoid_intrusions_left=True, avoid_intrusions_top=True,
                avoid_intrusions_right=True, avoid_intrusions_bottom=False,
            )
            self.page.add(ft.Column([
                self._sync_safe,
                self._root_stack,
            ], spacing=4, expand=True))
        except Exception as e:
            logger.error(f"Error en _create_layout: {e}", exc_info=True)
            show_error("Error al crear el layout de la app", e, "ControlEntradasSalidasApp._create_layout")

    def _on_sync_progress(self, msg: str):
        """Recibe mensajes de progreso del SyncManager.

        Puede ejecutarse en un hilo nativo (el thread de sync), por lo que NO
        tocamos la UI aquí: solo reenviamos el trabajo al event loop con
        page.run_task (run_coroutine_threadsafe) para evitar condiciones de
        carrera con las animaciones de cambio de vista.
        """
        try:
            if not self.page or not hasattr(self, 'sync_status_bar'):
                return
            self.page.run_task(self._apply_sync_progress, msg)
        except Exception:
            pass

    async def _apply_sync_progress(self, msg: str):
        try:
            if not self.page or not hasattr(self, 'sync_status_bar'):
                return

            is_error = 'Error' in msg and 'Error en' not in msg
            is_done = msg.endswith('finalizada') or msg.endswith('completada') or msg.endswith('completado')
            is_start = msg.endswith('completa...')
            is_empty = 'No hay' in msg or '0 registros' in msg or '0 requisiciones' in msg

            dc = get_theme(getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT)

            bar = self.sync_status_bar
            text = bar.content.controls[1]
            spinner = bar.content.controls[0]

            clean = msg.replace('[SYNC] ', '').replace('[SYNC-DEBUG] ', '').strip()

            if is_start:
                bar.height = 30
                spinner.visible = True
                text.value = clean
                text.color = dc['text_hint']
                bar.bgcolor = dc['card']
            elif is_done:
                text.value = f"✓ {clean}"
                text.color = dc['success']
                spinner.visible = False
                bar.bgcolor = dc['green_50']
                # Auto-ocultar tras 4s, en el event loop (sin hilos nativos).
                asyncio.create_task(self._hide_sync_bar(4))
            elif is_error:
                text.value = f"✗ {clean}"
                text.color = dc['error']
                spinner.visible = False
                bar.bgcolor = dc['red_50']
                asyncio.create_task(self._hide_sync_bar(6))
            else:
                bar.height = 30
                spinner.visible = True
                text.value = clean
                text.color = dc['text_hint']
                bar.bgcolor = dc['card']

            if self.page:
                self.page.update()
        except Exception:
            pass

    async def _hide_sync_bar(self, delay: float = 4):
        try:
            await asyncio.sleep(delay)
            if self.page and hasattr(self, 'sync_status_bar'):
                self.sync_status_bar.height = 0
                self.page.update()
        except Exception:
            pass

    def _register_sync_callback(self):
        """Registra el callback de progreso en el SyncManager."""
        try:
            from usr.database.sync import get_sync_manager
            sync_mgr = get_sync_manager()
            if sync_mgr:
                sync_mgr.set_sync_progress_callback(self._on_sync_progress)
        except Exception as e:
            print(f"[APP] Error registrando callback sync: {e}")

    def _on_page_resized(self, e):
        if e and hasattr(e, 'width') and e.width is not None:
            self._handle_responsive_layout(e.width)
            if self.page:
                self.page.update()

    def _handle_responsive_layout(self, width):
        if width is None:
            width = 1024
        try:
            w = float(width)
        except (ValueError, TypeError):
            w = 1024

        if w < 700:
            # Móvil: barra de navegación inferior; sin rail ni drawer.
            self._is_mobile_layout = True
            self.navigation_rail.visible = False
            self.menu_button.visible = False
            self.page.navigation_bar = self.navigation_bar
            self.navigation_bar.visible = True
            self.content_area.border_radius = 0
            # En móvil las acciones del encabezado no caben (p.ej. los botones
            # de la Bandeja). No se muestran inline: se mueven a la barra
            # desplegable que aparece al pulsar el toggle (⋮).
            if hasattr(self, 'header_right') and self.header_right:
                try:
                    self.header_spacer.expand = True
                    self.header_right.expand = False
                    self.header_actions.expand = False
                    self.header_actions.scroll = None
                    self._apply_header_actions_placement()
                except Exception as ex:
                    logger.debug(f"header móvil no configurado: {ex}")
        else:
            # Escritorio: botón hamburguesa + drawer custom (lado izquierdo).
            self._is_mobile_layout = False
            self.navigation_rail.visible = False
            self.menu_button.visible = True
            self.page.navigation_bar = None
            self.navigation_bar.visible = False
            self.content_area.border_radius = ft.BorderRadius.only(top_left=20)
            if hasattr(self, 'header_right') and self.header_right:
                try:
                    self.header_spacer.expand = True
                    self.header_right.expand = False
                    self.header_actions.expand = False
                    self.header_actions.scroll = None
                    self._apply_header_actions_placement()
                except Exception as ex:
                    logger.debug(f"header escritorio no configurado: {ex}")

    def _open_drawer(self, e=None):
        if not hasattr(self, 'drawer_root'):
            return
        try:
            self._refresh_drawer_style()
            self.drawer_root.visible = True
            self.drawer_root.update()
        except Exception as ex:
            logger.error(f"Error al abrir el drawer: {ex}", exc_info=True)

    def _refresh_drawer_style(self):
        if not hasattr(self, 'drawer_panel'):
            return
        try:
            is_dark = getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT
            dc = get_theme(is_dark)
            self._drawer_active_bg = dc['drawer_active_bg']
            self._drawer_active_fg = dc['drawer_active_fg']
            self._drawer_inactive_fg = dc['drawer_inactive_fg']
            self._drawer_on_surface = dc['drawer_on_surface']
            self.drawer_panel.bgcolor = dc['drawer_bg']
            self.drawer_title.color = self._drawer_on_surface
            cur = self.current_view_index or 0
            for i in range(len(self._drawer_items)):
                self._apply_drawer_tile_style(i, (i == cur), hover=False)
        except Exception as ex:
            logger.error(f"Error al actualizar estilo del drawer: {ex}", exc_info=True)

    def _apply_drawer_tile_style(self, i, sel, hover=False):
        tile, tile_icon, tile_text = self._drawer_items[i]
        if hover:
            is_dark = getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT
            tile.bgcolor = ft.Colors.with_opacity(0.10, ft.Colors.WHITE) if is_dark else ft.Colors.with_opacity(0.08, ft.Colors.BLACK)
            return
        tile.bgcolor = self._drawer_active_bg if sel else None
        tile_icon.color = self._drawer_active_fg if sel else self._drawer_inactive_fg
        tile_text.color = self._drawer_active_fg if sel else self._drawer_inactive_fg
        tile_text.weight = ft.FontWeight.W_600 if sel else ft.FontWeight.NORMAL

    def _on_drawer_tile_hover(self, e, i):
        try:
            hovering = bool(e.data)
            sel = (i == (self.current_view_index or 0))
            self._apply_drawer_tile_style(i, sel, hover=hovering)
            self._drawer_items[i][0].update()
        except Exception as ex:
            logger.error(f"Error al procesar hover del drawer: {ex}", exc_info=True)

    async def _on_drawer_tile_click(self, i, e=None):
        try:
            tile = self._drawer_items[i][0]
            tile.scale = 0.96
            tile.update()
            await asyncio.sleep(0.10)
            tile.scale = 1.0
            tile.update()
        except Exception as ex:
            logger.error(f"Error en animación de click del drawer: {ex}", exc_info=True)
        self._select_drawer_item(i)

    def _close_drawer(self):
        try:
            if hasattr(self, 'drawer_root'):
                self.drawer_root.visible = False
                self.drawer_root.update()
        except Exception as ex:
            logger.error(f"Error al cerrar el drawer: {ex}", exc_info=True)

    def _select_drawer_item(self, idx):
        try:
            self._close_drawer()
            self.current_view_index = idx
            self._show_view(idx)
        except Exception as ex:
            logger.error(f"Error al seleccionar item del drawer: {ex}", exc_info=True)

    def _on_navigation_change(self, e):
        if self.page is None:
            return
        try:
            if isinstance(e.control, ft.NavigationBar):
                index = int(e.control.selected_index)
                if index == 3:
                    self._show_more_menu()
                    return
                self.current_view_index = index
                self._show_view(index)
                return

            if isinstance(e.control, ft.NavigationRail):
                selected_dest = e.control.destinations[e.control.selected_index]
                label = selected_dest.label
                mapping = {
                    "Inventario": 0,
                    "Validación": 1,
                    "Stock": 2,
                    "Producciones": 3,
                    "Requisiciones": 4,
                    "Historial": 5,
                    "Ajustes": 6,
                    "Bandeja": 7,
                }
                index = mapping.get(label)
                if index is None:
                    return
                self.current_view_index = index
                self._show_view(index)
        except Exception as e:
            logger.error(f"Error en _on_navigation_change: {e}", exc_info=True)
            show_error("Error al cambiar de vista", e, "ControlEntradasSalidasApp._on_navigation_change")

    def _show_more_menu(self):
        if self.page is None:
            return
        try:
            is_dark = self.page.theme_mode == ft.ThemeMode.DARK

            mc = get_theme(is_dark)
            surface = mc['more_surface']
            text_color = mc['text_primary']
            icon_color = mc['header_icon']

            def on_nav(e, idx):
                self._cerrar_more_menu_y_despues(lambda: self._show_view(idx))

            def _item(icon, label, onclick):
                return ft.Container(
                    content=ft.Row([
                        ft.Icon(icon, size=24, color=icon_color),
                        ft.Text(label, size=16, color=text_color),
                    ], spacing=15),
                    padding=ft.Padding.all(15),
                    bgcolor=surface,
                    on_click=onclick,
                )

            menu_content = ft.Column(spacing=0, controls=[
                _item(ft.Icons.FACTORY_OUTLINED, "Producciones", lambda e, i=3: on_nav(e, i)),
                _item(ft.Icons.LOCAL_SHIPPING_OUTLINED, "Requisiciones", lambda e, i=4: on_nav(e, i)),
                _item(ft.Icons.HISTORY_OUTLINED, "Historial", lambda e, i=5: on_nav(e, i)),
                _item(ft.Icons.SETTINGS_OUTLINED, "Ajustes", lambda e, i=6: on_nav(e, i)),
                _item(ft.Icons.MAIL_OUTLINED, "Bandeja", lambda e, i=7: on_nav(e, i)),
            ])

            # Reutilizar el BottomSheet: eliminar cualquier instancia previa del
            # overlay antes de agregar la nueva. Si se acumularan, cada menú abierto
            # dejaría una hoja sin montar en la página y la app se volvería lenta.
            for prev in [o for o in self.page.overlay if isinstance(o, ft.BottomSheet)]:
                prev.open = False
                self.page.overlay.remove(prev)

            self.bottom_sheet = ft.BottomSheet(
                content=ft.Container(
                    content=menu_content,
                    # Altura acotada para que el menú solo cubra la parte baja de la
                    # pantalla y no suba hasta arriba (6 filas cabrían en "fullscreen").
                    height=360,
                    padding=ft.Padding.only(bottom=20),
                    bgcolor=surface,
                ),
                show_drag_handle=True,
                bgcolor=surface,
                scrollable=True,
            )
            self.page.overlay.append(self.bottom_sheet)
            self.bottom_sheet.open = True
            self.page.update()
        except Exception as e:
            logger.error(f"Error en _show_more_menu: {e}", exc_info=True)
            show_error("Error al abrir el menú de más opciones", e, "ControlEntradasSalidasApp._show_more_menu")

    def _cerrar_more_menu_y_despues(self, accion):
        """Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la
        animación de cierre, para que el deslizamiento del panel y el fade de la
        vista (o el cambio de tema) no compitan entre sí en móvil.
        """
        try:
            if not hasattr(self, 'bottom_sheet') or self.bottom_sheet is None:
                accion()
                return
            self.bottom_sheet.open = False
            self.page.update()

            async def _ejecutar_despues():
                await asyncio.sleep(0.3)
                accion()

            try:
                self.page.run_task(_ejecutar_despues)
            except Exception:
                accion()
        except Exception as e:
            logger.error(f"Error cerrando el menú 'Más': {e}", exc_info=True)
            try:
                accion()
            except Exception:
                pass

    def _show_view(self, index: int):
        self._trace("_show_view ENTRADA", index)
        # Evitar solapar cambios de vista: si ya hay uno en curso, encolamos
        # la última intención y la procesamos al terminar (ocultar el overlay).
        if self._switching_view:
            self._pending_view = index
            self._trace(f"_show_view ENCOLADO (switching_view=True, pending={index})", index)
            return
        try:
            if not self.views or index < 0 or index >= len(self.views):
                keys = list(range(len(self.views))) if self.views else "None"
                self._view_stack.controls = [
                    ft.Container(
                        content=ft.Text(f"Error: Vista {index} no encontrada. Keys: {keys}", color=ft.Colors.RED),
                        alignment=ft.Alignment.CENTER, expand=True,
                    )
                ]
                self.page.update()
                return

            view = self.views[index]
            old = self.current_view

            # Misma vista que ya está montada y visible: no hacer nada (evita un
            # barrido redundante). Si la vista actual falló (_mounted=False), se
            # permite reintentarla tocándola de nuevo en lugar de ignorar el clic.
            if old is view and getattr(view, '_mounted', True):
                self._trace("_show_view SALIDA (misma vista ya montada)", index)
                return

            if self.navigation_bar:
                if index < 3:
                    self.navigation_bar.selected_index = index
                else:
                    self.navigation_bar.selected_index = 3

            self.current_view = view
            self.current_view_index = index
            self._switching_view = True
            self._switch_start = time.monotonic()
            self._trace(f"_show_view candado OK (old: {type(old).__name__ if old else 'None'})", index)

            # Señal inmediata de cambio: mostramos la ventana de carga antes de
            # cualquier montaje/carga para que el usuario lo perciba al instante.
            self._mostrar_loading()
            self._trace("overlay MOSTRADO", index)

            # Watchdog: si la carga de la vista se cuelga (p.ej. BD/red), forzamos
            # la recuperación de la navegación y ocultamos el overlay tras un
            # timeout, para que una vista lenta no bloquee todas las demás.
            self._switch_start = time.monotonic()
            try:
                # Se agendan en el loop ACTIVO (no usamos page.run_task porque
                # exige session.connection.loop, que puede ser None al inicio o
                # mientras el hilo websocket reanuda; eso dejaba vistas vacías).
                self._watchdog_task = asyncio.ensure_future(self._switching_watchdog())
            except Exception:
                pass
            self._trace(f"watchdog agendado (timeout={self._SWITCH_TIMEOUT}s)", index)

            # Preparar la vista: la agregamos al Stack UNA SOLA VEZ; en cambios
            # subsecuentes ya está montada (no se re-agrega ni se re-remueve,
            # porque re-montar controles en Flet es frágil y tras varios ciclos
            # dejaba de cargar el contenido). El cambio de vista es natural, sin
            # deslizamiento: solo la mostramos/ocultamos.
            if view not in self._view_stack.controls:
                self._view_stack.controls.append(view)
                if old is not None and old is not view:
                    old.expand = True
                self._trace(f"vista AGREGADA al Stack (len={len(self._view_stack.controls)})", index)
            else:
                self._trace(f"vista YA en el Stack (len={len(self._view_stack.controls)})", index)
            # Aseguramos visibilidad en CADA cambio: en el re-ingreso la vista
            # ya está en el Stack (no entra al bloque anterior) pero pudo haber
            # quedado oculta (visible=False) al navegar fuera de ella.
            view.visible = True
            view.expand = True
            # La vista activa siempre al 100% opaca: un kick de repintado previo
            # (ver _kick_repintado) puede dejarla en 0.999 y su restore puede no
            # haber llegado al cliente web.
            view.opacity = 1.0

            # Ocultamos la vista anterior de inmediato (cambio natural, sin slide).
            # Además del visible=False forzamos opacity=0.0 en la vista saliente:
            # en Flet web, la capa de la última vista del Stack (caso típico:
            # la Bandeja) queda pintada encima del resto aunque reciba
            # visible=False, tapando las demás vistas e interceptando los clics.
            # Anular su opacidad invalida esa capa en el cliente.
            if old is not None and old is not view and self._buscar_en_stack(old):
                old.visible = False
                old.opacity = 0.0

            # PUBLICAR EL ÁRBOL PRIMERO. El montaje se delega a _montar_y_cargar:
            # Flet dispara did_mount() automáticamente al publicar el árbol
            # (added_control.did_mount() en session.py), momento en que el control
            # ya está montado de verdad y did_mount puede tocar self.page/update
            # sin reentrancia ni _mounted=False.
            try:
                self.page.update()
            except Exception as e:
                logger.warning(f"page.update() parcial al mostrar vista {index}: {e}")
            self._trace("page.update() tras publicar árbol", index)

            # Refrescar el encabezado global (título + acciones de la vista).
            try:
                self._update_header(index)
                self._trace("_update_header OK", index)
            except Exception as e:
                logger.error(f"Error en _update_header({index}): {e}", exc_info=True)
                try:
                    show_error(f"Error al actualizar el encabezado ({index})", e, "ControlEntradasSalidasApp._update_header")
                except Exception:
                    pass

            if hasattr(view, '_update_connection_indicator'):
                try:
                    view._update_connection_indicator()
                except Exception:
                    pass
        except Exception as e:
            self._switching_view = False
            logger.error(f"Error en _show_view({index}): {e}", exc_info=True)
            show_error(f"Error al mostrar la vista {index}", e, "ControlEntradasSalidasApp._show_view")
            return

        # Montar (si falta), cargar los datos de la vista y, al terminar, ocultar
        # la ventana de carga. El candado _switching_view SIEMPRE se libera en el
        # finally, sin importar excepciones, para que la navegación nunca quede
        # bloqueada.
        try:
            asyncio.ensure_future(self._montar_y_cargar(index))
            self._trace(f"_montar_y_cargar AGENDADO (ensure_future)", index)
        except Exception:
            self._switching_view = False
            self._ocultar_loading()

    async def _montar_y_cargar(self, index: int):
        view = self.views[index] if self.views and 0 <= index < len(self.views) else None
        self._trace("_montar_y_cargar ENTRADA", index)
        try:
            if view is None:
                self._trace("_montar_y_cargar SALIDA (view=None)", index)
                return

            # El montaje ocurre DESPUÉS de publicar el árbol (page.update() en
            # _show_view): Flet ya invocó did_mount automáticamente. Si por un
            # fallo intermitente quedó _mounted=False, lo reintentamos aquí una
            # vez (los guards internos de cada vista hacen did_mount idempotente).
            if hasattr(view, 'did_mount') and not getattr(view, '_mounted', True):
                try:
                    self._trace(f"did_mount automático NO disparado; reintento manual (_mounted={getattr(view, '_mounted', None)})", index)
                    view.did_mount()
                except Exception as e:
                    logger.error(f"Reintento de did_mount para vista {index} falló: {e}", exc_info=True)

            if not getattr(view, '_mounted', True):
                logger.warning(f"Vista {index} no pudo montarse; se omite la carga de datos.")
                self._trace(f"vista NO montada (_mounted=False); SALIDA", index)
                await asyncio.sleep(0.12)
                return
            else:
                self._trace(f"vista MONTADA (_mounted=True)", index)

            if not hasattr(view, 'on_view_shown'):
                # Vista sin carga de datos: breve respiro para que el overlay sea
                # perceptible como feedback de cambio.
                self._trace("vista sin on_view_shown; SALIDA", index)
                await asyncio.sleep(0.12)
                return

            try:
                self._trace("llamando on_view_shown()", index)
                resultado = view.on_view_shown()
                self._trace(f"on_view_shown devolvió {'awaitable' if (resultado is not None and inspect.isawaitable(resultado)) else type(resultado).__name__}", index)
                if resultado is not None and inspect.isawaitable(resultado):
                    try:
                        await asyncio.wait_for(resultado, self._SWITCH_TIMEOUT)
                        self._trace("on_view_shown COMPLETÓ (await finalizado)", index)
                    except asyncio.TimeoutError:
                        logger.warning(f"Carga de vista {index} agotó el timeout ({self._SWITCH_TIMEOUT}s)")
                        self._trace(f"on_view_shown TIMEOUT ({self._SWITCH_TIMEOUT}s)", index)
                        try:
                            show_error(f"La vista {index} tardó demasiado en cargar", None, "ControlEntradasSalidasApp.on_view_shown")
                        except Exception:
                            pass
            except Exception as e:
                logger.error(f"on_view_shown de vista {index} falló: {e}", exc_info=True)
                self._trace(f"on_view_shown EXCEPCIÓN: {e}", index)
                try:
                    show_error(f"Error al cargar la vista {index}", e, "ControlEntradasSalidasApp.on_view_shown")
                except Exception:
                    pass
        except Exception:
            pass
        finally:
            self._ocultar_loading()
            self._trace("finally: _ocultar_loading()", index)
            # Flet web intermitente: reafirma la visibilidad y fuerza el
            # repintado de la vista activa por si la anterior quedó pintada
            # encima (p.ej. la Bandeja, capa más alta del Stack).
            self._kick_repintado()
            self._trace("finally: _kick_repintado()", index)
            self._switching_view = False
            self._trace("finally: candado LIBERADO", index)
            if self._watchdog_task is not None:
                try:
                    self._watchdog_task.cancel()
                except Exception:
                    pass
                self._watchdog_task = None
            # Procesar una intención de navegación pendiente (clic rápido).
            pending = self._pending_view
            self._pending_view = None
            if pending is not None and pending != self.current_view_index:
                self._trace(f"finally: procesando pending={pending}", index)
                try:
                    self._show_view(pending)
                except Exception:
                    pass

    async def _switching_watchdog(self):
        try:
            await asyncio.sleep(self._SWITCH_TIMEOUT)
        except asyncio.CancelledError:
            self._trace("watchdog CANCELADO (switch terminó a tiempo)", self.current_view_index)
            return
        # Solo intervienen si la conmutación sigue activa y arrancó hace el timeout.
        if getattr(self, '_switching_view', False) and \
           time.monotonic() - getattr(self, '_switch_start', 0) >= self._SWITCH_TIMEOUT:
            logger.warning("Watchdog: recuperando conmutación de vista bloqueada")
            self._trace(f"WATCHDOG: conmutación bloqueada; recuperando", self.current_view_index)
            try:
                self._ocultar_loading()
            except Exception:
                pass
            self._kick_repintado()
            self._switching_view = False
            self._watchdog_task = None
            pending = self._pending_view
            self._pending_view = None
            if pending is not None:
                try:
                    self._show_view(pending)
                except Exception:
                    pass

    def _trace(self, msg: str, index=None, delta_from=None):
        """Imprime en el log (solo si TRACE_SWITCH=1) un marcador con delta de
        tiempo para localizar en qué punto del flujo de cambio de vista se
        detiene o falla la ejecución."""
        if not self._trace_enabled:
            return
        now = time.monotonic()
        if delta_from is not None:
            d = f"{now - delta_from:6.3f}s"
        else:
            d = f"{now - self._trace_last:6.3f}s"
        self._trace_last = now
        name = self.VIEW_META.get(index, ("", "", None))[0] if index is not None else ""
        print(f"[SWITCH] {d} | idx={index} {name:14} | {msg}")

    def _mostrar_loading(self):
        try:
            if hasattr(self, 'loading_overlay') and self.page:
                self.loading_overlay.visible = True
                self.loading_overlay.opacity = 1.0
                self.page.update()
                self._trace(f"overlay MOSTRADO (visible={self.loading_overlay.visible}, opacity={self.loading_overlay.opacity})")
        except Exception:
            pass

    def _ocultar_loading(self):
        try:
            if hasattr(self, 'loading_overlay') and self.page:
                # Además del visible=False, anulamos la opacidad: en Flet web el
                # overlay (última capa del Stack, texto "Cargando vista…") quedaba
                # pintado encima de las vistas tras ocultarlo, tapándolas e
                # interceptando los clics. Invalida su capa en el cliente.
                self.loading_overlay.visible = False
                self.loading_overlay.opacity = 0.0
                self.page.update()
                self._trace(f"overlay OCULTO (visible={self.loading_overlay.visible}, opacity={self.loading_overlay.opacity})")
        except Exception as e:
            self._trace(f"overlay ocultado FALLÓ: {e}")

    def _kick_repintado(self):
        """Reenvía el estado autoritativo de visibilidad del Stack y fuerza el
        repintado de la vista activa.

        En Flet web, de forma intermitente, una vista oculta quedaba pintada
        sobre el resto (caso típico: la Bandeja, última capa del Stack, con sus
        textos 'No hay mensajes…' y el resumen de enviados/fallidos). O el
        cliente nunca recibió el visible=False (modelo desactualizado) o su capa
        quedó en caché. Aquí se reafirma la visibilidad Y la opacidad (visible
        solo a la activa; opacity=0 al resto, lo que invalida su capa y evita
        que intercepte clics) además de aplicar un cambio real (opacity) a la
        vista activa para que su capa se repinte y tape contenido residual.
        """
        try:
            if self.page is None or not hasattr(self, '_view_stack'):
                return
            cur = self.current_view
            # 1) Estado autoritativo: solo la vista activa visible y opaca.
            for v in list(self._view_stack.controls):
                try:
                    target = (v is cur)
                    if bool(v.visible) != target:
                        v.visible = target
                    if v is not cur:
                        v.opacity = 0.0
                except Exception:
                    continue
            # 2) El overlay de carga debe quedar oculto/transparente al final de
            #    cualquier conmutación, aunque un _ocultar_loading haya fallado.
            ov = getattr(self, 'loading_overlay', None)
            if ov is not None and ov.visible:
                try:
                    ov.visible = False
                    ov.opacity = 0.0
                except Exception:
                    pass
            # 3) Cambio real sobre la vista activa para invalidar su capa.
            if cur is not None:
                cur.opacity = 0.999 if getattr(cur, 'opacity', 1.0) != 0.999 else 1.0
            try:
                self.page.update()
            except Exception:
                pass
            self._trace(
                f"kick: overlay(visible={getattr(ov, 'visible', None)}, opacity={getattr(ov, 'opacity', None)}) | "
                f"cur(visible={getattr(cur, 'visible', None)}, opacity={getattr(cur, 'opacity', None)}), "
                f"ocultas={sum(1 for v in self._view_stack.controls if v is not cur and v.visible)}"
            )

            async def _restaurar_opacidad():
                await asyncio.sleep(0.06)
                try:
                    if cur is not None and getattr(cur, 'opacity', 1.0) != 1.0:
                        cur.opacity = 1.0
                    if self.page:
                        self.page.update()
                except Exception:
                    pass

            try:
                self.page.run_task(_restaurar_opacidad)
            except Exception:
                if cur is not None:
                    cur.opacity = 1.0
        except Exception as ex:
            logger.debug(f"kick_repintado falló: {ex}")

    def _buscar_en_stack(self, control) -> bool:
        try:
            return control in self._view_stack.controls
        except Exception:
            return False
