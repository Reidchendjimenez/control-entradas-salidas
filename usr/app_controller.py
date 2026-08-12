import asyncio
import concurrent.futures
import time
import flet as ft
from usr.logger import get_logger
from usr.error_handler import show_error

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
        self.page.bgcolor = '#1A1A1A'

    def _header_colors(self):
        is_dark = getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT
        return {
            'bg': '#1E1E1E' if is_dark else '#FFFFFF',
            'title': '#FFFFFF' if is_dark else '#1A1A1A',
            'subtitle': '#AAAAAA' if is_dark else '#666666',
            'icon': '#BB86FC' if is_dark else '#6200EE',
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
            self.header_actions.controls.clear()
            if view and hasattr(view, 'get_header_actions'):
                try:
                    actions = view.get_header_actions()
                    self.header_actions.controls.extend(list(actions or []))
                except Exception as e:
                    logger.warning(f"get_header_actions de vista {index} falló: {e}")
        except Exception as e:
            logger.error(f"Error en _update_header: {e}", exc_info=True)

    def _toggle_theme(self, e=None):
        if not self.page:
            return
        try:
            is_dark = self.page.theme_mode != ft.ThemeMode.DARK
            self.page.theme_mode = ft.ThemeMode.DARK if is_dark else ft.ThemeMode.LIGHT
            self.page.bgcolor = '#1A1A1A' if is_dark else '#F5F5F5'

            if hasattr(self, 'content_area') and self.content_area:
                self.content_area.bgcolor = '#252525' if is_dark else '#FFFFFF'

            if hasattr(self, 'navigation_rail') and self.navigation_rail:
                self.navigation_rail.bgcolor = '#1E1E1E' if is_dark else '#F3E5F5'

            if hasattr(self, 'drawer_panel') and self.drawer_panel:
                self.drawer_panel.bgcolor = '#1E1E1E' if is_dark else '#FFFFFF'
                self.drawer_panel.update()

            if hasattr(self, 'theme_toggle') and self.theme_toggle:
                self.theme_toggle.icon = ft.Icons.LIGHT_MODE if is_dark else ft.Icons.DARK_MODE
                self.theme_toggle.icon_color = ft.Colors.AMBER if is_dark else ft.Colors.BLUE_GREY_700
                self.theme_toggle.tooltip = "Modo Claro" if is_dark else "Modo Oscuro"

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
                    ft.ProgressRing(width=38, height=38, stroke_width=3, color='#BB86FC'),
                    ft.Text("Cargando vista…", size=14, color='#E0E0E0'),
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
            self.drawer_panel = ft.Container(
                width=320,
                bgcolor='#1E1E1E' if is_dark else '#FFFFFF',
                padding=ft.Padding(top=24, bottom=16, left=8, right=8),
                content=ft.Column([
                    ft.Container(
                        content=ft.Text("Menú", size=20, weight=ft.FontWeight.BOLD,
                                        color='#FFFFFF' if is_dark else '#1A1A1A'),
                        padding=ft.Padding(left=16, bottom=16, right=0, top=0),
                    ),
                ] + [
                    ft.ListTile(
                        leading=ft.Icon(ic, color='#BB86FC' if i == (self.current_view_index or 0) else None),
                        title=ft.Text(lab, color='#E0E0E0' if is_dark else '#1A1A1A'),
                        selected=(i == (self.current_view_index or 0)),
                        on_click=lambda e, idx=i: self._select_drawer_item(idx),
                    ) for i, (ic, lab) in enumerate(nav_items)
                ], scroll=ft.ScrollMode.AUTO, spacing=2),
            )
            self.drawer_tiles = self.drawer_panel.content.controls[1:]
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
                bgcolor='#1A1A1A'
            )

            self.theme_toggle = ft.IconButton(icon=ft.Icons.LIGHT_MODE, tooltip="Modo Claro", on_click=self._toggle_theme, icon_color=ft.Colors.AMBER)

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
            self.header_right = ft.Row(
                [self.header_actions, self.theme_toggle],
                spacing=4, alignment=ft.MainAxisAlignment.END, vertical_alignment=ft.CrossAxisAlignment.CENTER,
            )
            self.app_header = ft.Container(
                content=ft.Row([
                    self.menu_button,
                    self.header_icon,
                    ft.Column([self.header_title, self.header_subtitle], spacing=0),
                    ft.Container(expand=True),
                    self.header_right,
                ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
                padding=ft.Padding.symmetric(horizontal=16, vertical=10),
                bgcolor=hc['bg'],
                border_radius=ft.BorderRadius.all(14),
            )

            self.navigation_rail = ft.NavigationRail(
                selected_index=0, extended=False, label_type=ft.NavigationRailLabelType.ALL, min_width=100, bgcolor='#1E1E1E',
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
                bgcolor='#2D2D2D',
                padding=ft.Padding.symmetric(horizontal=12, vertical=0),
                border_radius=ft.BorderRadius.all(8),
                content=ft.Row([
                    ft.ProgressRing(width=14, height=14, stroke_width=2, color='#BB86FC'),
                    ft.Text("", size=12, color='#BBBBBB', expand=True, no_wrap=False),
                ], spacing=8, alignment=ft.MainAxisAlignment.START),
            )

            self._layout_row = ft.SafeArea(content=ft.Column([
                self.app_header,
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

            bar = self.sync_status_bar
            text = bar.content.controls[1]
            spinner = bar.content.controls[0]

            clean = msg.replace('[SYNC] ', '').replace('[SYNC-DEBUG] ', '').strip()

            if is_start:
                bar.height = 30
                spinner.visible = True
                text.value = clean
                text.color = '#BBBBBB'
                bar.bgcolor = '#2D2D2D'
            elif is_done:
                text.value = f"✓ {clean}"
                text.color = '#4CAF50'
                spinner.visible = False
                bar.bgcolor = '#1B3D1B'
                # Auto-ocultar tras 4s, en el event loop (sin hilos nativos).
                asyncio.create_task(self._hide_sync_bar(4))
            elif is_error:
                text.value = f"✗ {clean}"
                text.color = '#F44336'
                spinner.visible = False
                bar.bgcolor = '#3D1B1B'
                asyncio.create_task(self._hide_sync_bar(6))
            else:
                bar.height = 30
                spinner.visible = True
                text.value = clean
                text.color = '#BBBBBB'
                bar.bgcolor = '#2D2D2D'

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
            self.navigation_rail.visible = False
            self.menu_button.visible = False
            self.page.navigation_bar = self.navigation_bar
            self.navigation_bar.visible = True
            self.content_area.border_radius = 0
        else:
            # Escritorio: botón hamburguesa + drawer custom (lado izquierdo).
            self.navigation_rail.visible = False
            self.menu_button.visible = True
            self.page.navigation_bar = None
            self.navigation_bar.visible = False
            self.content_area.border_radius = ft.BorderRadius.only(top_left=20)

    def _open_drawer(self, e=None):
        if not hasattr(self, 'drawer_root'):
            return
        try:
            cur = self.current_view_index or 0
            is_dark = getattr(self.page, 'theme_mode', None) != ft.ThemeMode.LIGHT
            for i, tile in enumerate(self.drawer_tiles):
                sel = (i == cur)
                tile.selected = sel
                tile.leading.color = '#BB86FC' if sel else None
                tile.title.color = '#FFFFFF' if sel else ('#E0E0E0' if is_dark else '#1A1A1A')
                tile.update()
            self.drawer_root.visible = True
            self.drawer_root.update()
        except Exception as ex:
            logger.error(f"Error al abrir el drawer: {ex}", exc_info=True)

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
            opciones = [("factory", "Producciones", 3), ("assignment", "Requisiciones", 4), ("history", "Historial", 5), ("settings", "Ajustes", 6), ("mail", "Bandeja", 7)]

            is_dark = self.page.theme_mode == ft.ThemeMode.DARK
            theme_icon = ft.Icons.LIGHT_MODE if is_dark else ft.Icons.DARK_MODE
            theme_label = "Modo Claro" if is_dark else "Modo Oscuro"

            surface = '#1E1E1E' if is_dark else '#FFFFFF'
            text_color = '#FFFFFF' if is_dark else '#1A1A1A'
            icon_color = '#BB86FC' if is_dark else '#6200EE'
            item_border = '#3D3D3D' if is_dark else '#E0E0E0'

            def on_toggle_theme(e):
                self._cerrar_more_menu_y_despues(self._toggle_theme)

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
                ft.Container(
                    content=ft.Row([ft.Icon(theme_icon, size=24, color=icon_color), ft.Text(theme_label, size=16, color=text_color)], spacing=15),
                    padding=ft.Padding.all(15),
                    bgcolor=surface,
                    on_click=on_toggle_theme,
                ),
                ft.Container(height=1, bgcolor=item_border),
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
        # Evitar solapar cambios de vista: si ya hay uno en curso, encolamos
        # la última intención y la procesamos al terminar (ocultar el overlay).
        if self._switching_view:
            self._pending_view = index
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

            # Misma vista: nada que hacer (evita un barrido redundante).
            if old is view:
                return

            if self.navigation_bar:
                if index < 3:
                    self.navigation_bar.selected_index = index
                else:
                    self.navigation_bar.selected_index = 3

            self.current_view = view
            self.current_view_index = index
            self._switching_view = True

            # Señal inmediata de cambio: mostramos la ventana de carga antes de
            # cualquier montaje/carga para que el usuario lo perciba al instante.
            self._mostrar_loading()

            # Watchdog: si la carga de la vista se cuelga (p.ej. BD/red), forzamos
            # la recuperación de la navegación y ocultamos el overlay tras un
            # timeout, para que una vista lenta no bloquee todas las demás.
            self._switch_start = time.monotonic()
            try:
                self.page.run_task(self._switching_watchdog)
            except Exception:
                pass

            # Preparar la vista: la agregamos al Stack UNA SOLA VEZ; en cambios
            # subsecuentes ya está montada (no se re-agrega ni se re-remueve,
            # porque re-montar controles en Flet es frágil y tras varios ciclos
            # dejaba de cargar el contenido). El cambio de vista es natural, sin
            # deslizamiento: solo la mostramos/ocultamos.
            if view not in self._view_stack.controls:
                self._view_stack.controls.append(view)
                if old is not None and old is not view:
                    old.expand = True
            # Aseguramos visibilidad en CADA cambio: en el re-ingreso la vista
            # ya está en el Stack (no entra al bloque anterior) pero pudo haber
            # quedado oculta (visible=False) al navegar fuera de ella.
            view.visible = True
            view.expand = True

            # Ocultamos la vista anterior de inmediato (cambio natural, sin slide).
            if old is not None and old is not view and self._buscar_en_stack(old):
                old.visible = False

            try:
                self.page.update()
            except Exception as e:
                logger.warning(f"page.update() parcial al montar vista {index}: {e}")

            # Post-montaje: construir/inicializar la vista.
            if hasattr(view, 'did_mount'):
                try:
                    view.did_mount()
                except Exception as e:
                    logger.error(f"did_mount falló para vista {index}: {e}", exc_info=True)
                    try:
                        show_error(f"Error al montar la vista {index}", e, "ControlEntradasSalidasApp.did_mount")
                    except Exception:
                        pass

            # Refrescar el encabezado global (título + acciones de la vista).
            try:
                self._update_header(index)
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

        # Cargar los datos de la vista y, al terminar, ocultar la ventana de
        # carga. Si on_view_shown devuelve el futuro de la carga asíncrona,
        # esperamos a que finalice para no ocultar el overlay antes de tiempo.
        async def _cargar_y_ocultar():
            try:
                if hasattr(view, 'on_view_shown') and getattr(view, '_mounted', True):
                    try:
                        resultado = view.on_view_shown()
                        if resultado is not None:
                            try:
                                if isinstance(resultado, concurrent.futures.Future):
                                    await asyncio.wait_for(asyncio.wrap_future(resultado), self._SWITCH_TIMEOUT)
                                else:
                                    await asyncio.wait_for(resultado, self._SWITCH_TIMEOUT)
                            except asyncio.TimeoutError:
                                logger.warning(f"Carga de vista {index} agotó el timeout ({self._SWITCH_TIMEOUT}s)")
                                try:
                                    show_error(f"La vista {index} tardó demasiado en cargar", None, "ControlEntradasSalidasApp.on_view_shown")
                                except Exception:
                                    pass
                    except Exception as e:
                        logger.error(f"on_view_shown de vista {index} falló: {e}", exc_info=True)
                        try:
                            show_error(f"Error al cargar la vista {index}", e, "ControlEntradasSalidasApp.on_view_shown")
                        except Exception:
                            pass
                elif hasattr(view, 'on_view_shown'):
                    logger.warning(f"Vista {index} no pudo montarse; se omite la carga de datos.")
                else:
                    # Vista sin carga de datos: breve respiro para que el
                    # overlay sea perceptible como feedback de cambio.
                    await asyncio.sleep(0.12)
            except Exception:
                pass
            finally:
                self._ocultar_loading()
                self._switching_view = False
                # Procesar una intención de navegación pendiente (clic rápido).
                pending = self._pending_view
                if pending is not None and pending != self.current_view_index:
                    self._pending_view = None
                    try:
                        self._show_view(pending)
                    except Exception:
                        pass
                elif pending is not None:
                    self._pending_view = None
        try:
            self.page.run_task(_cargar_y_ocultar)
        except Exception:
            self._switching_view = False
            self._ocultar_loading()

    async def _switching_watchdog(self):
        await asyncio.sleep(self._SWITCH_TIMEOUT)
        # Solo intervienen si la conmutación sigue activa y arrancó hace el timeout.
        if getattr(self, '_switching_view', False) and \
           time.monotonic() - getattr(self, '_switch_start', 0) >= self._SWITCH_TIMEOUT:
            logger.warning("Watchdog: recuperando conmutación de vista bloqueada")
            try:
                self._ocultar_loading()
            except Exception:
                pass
            self._switching_view = False
            pending = self._pending_view
            self._pending_view = None
            if pending is not None:
                try:
                    self._show_view(pending)
                except Exception:
                    pass

    def _mostrar_loading(self):
        try:
            if hasattr(self, 'loading_overlay') and self.page:
                self.loading_overlay.visible = True
                self.page.update()
        except Exception:
            pass

    def _ocultar_loading(self):
        try:
            if hasattr(self, 'loading_overlay') and self.page:
                self.loading_overlay.visible = False
                self.page.update()
        except Exception:
            pass

    def _buscar_en_stack(self, control) -> bool:
        try:
            return control in self._view_stack.controls
        except Exception:
            return False
