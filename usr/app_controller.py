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
        self.current_view = None
        self.current_view_index = 0
        self.views = []
        self.settings = None
        self._switching_view = False

        # Caché de rutas: una ft.View por tab (índice 0..7). Cada View contiene
        # su propio shell (raíl, barra de sync, área de contenido) y una única
        # vista pesada, de modo que la navegación nativa por page.views activa
        # las transiciones Material sin duplicar controles entre vistas.
        self._route_views = {}
        self._sync_bars = {}
        self._content_areas = {}

    _ROUTES = [
        "/inventario",      # 0
        "/validacion",      # 1
        "/stock",           # 2
        "/producciones",    # 3
        "/requisiciones",   # 4
        "/historial",       # 5
        "/ajustes",         # 6
        "/bandeja",         # 7
    ]

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
            self._register_sync_callback()

            self.page.on_route_change = self._on_route_change
            # Limpiar cualquier control residual de la fase de arranque (splash/login).
            self.page.clean()
            self.page.update()

            # Arrancar en la primera ruta: page.go() es asíncrono (push_route vía
            # create_task) y no garantiza montaje inmediato. Invocamos el handler
            # directamente para montar la vista inicial de forma síncrona.
            self._on_route_change(
                type('_RouteEvent', (), {'route': self._ROUTES[0]})()
            )
        except Exception as e:
            logger.error(f"Error crítico en arrancar_interfaz: {e}", exc_info=True)
            show_error("Error al iniciar la interfaz", e, "ControlEntradasSalidasApp.arrancar_interfaz")

    def _setup_theme(self):
        if not self.page:
            return
        # Transiciones nativas de ruta (Material). Se activan al navegar entre
        # las ft.View de page.views. cupertino: deslizamiento horizontal
        # (la vista nueva entra deslizándose desde la derecha), como el push
        # clásico de navegación; aplicado en todas las plataformas.
        self.page.theme = ft.Theme(
            color_scheme_seed=ft.Colors.DEEP_PURPLE_700,
            visual_density=ft.VisualDensity.COMFORTABLE,
            use_material3=True,
            page_transitions=ft.PageTransitionsTheme(
                android=ft.PageTransitionTheme.CUPERTINO,
                ios=ft.PageTransitionTheme.CUPERTINO,
                windows=ft.PageTransitionTheme.CUPERTINO,
                macos=ft.PageTransitionTheme.CUPERTINO,
                linux=ft.PageTransitionTheme.CUPERTINO,
            ),
        )
        self.page.bgcolor = '#1A1A1A'

    def _toggle_theme(self, e=None):
        if not self.page:
            return
        try:
            is_dark = self.page.theme_mode != ft.ThemeMode.DARK
            self.page.theme_mode = ft.ThemeMode.DARK if is_dark else ft.ThemeMode.LIGHT
            self.page.bgcolor = '#1A1A1A' if is_dark else '#F5F5F5'

            for route, area in self._content_areas.items():
                area.bgcolor = '#252525' if is_dark else '#FFFFFF'
            if self.navigation_bar:
                self.navigation_bar.bgcolor = ft.Colors.SURFACE_CONTAINER_HIGHEST

            if hasattr(self, 'theme_toggle') and self.theme_toggle:
                self.theme_toggle.icon = ft.Icons.LIGHT_MODE if is_dark else ft.Icons.DARK_MODE
                self.theme_toggle.icon_color = ft.Colors.AMBER if is_dark else ft.Colors.BLUE_GREY_700
                self.theme_toggle.tooltip = "Modo Claro" if is_dark else "Modo Oscuro"

            # Actualizar FAB de tema
            if hasattr(self, 'theme_fab') and self.theme_fab:
                self.theme_fab.icon = ft.Icons.LIGHT_MODE if is_dark else ft.Icons.DARK_MODE
                self.theme_fab.tooltip = "Modo Claro" if is_dark else "Modo Oscuro"

            if self.current_view and hasattr(self.current_view, 'on_theme_change'):
                self.current_view.on_theme_change()

            self.page.update()
        except Exception as e:
            logger.error(f"Error en _toggle_theme: {e}", exc_info=True)
            show_error("Error al cambiar el tema", e, "ControlEntradasSalidasApp._toggle_theme")

    def _create_layout(self):
        try:
            # NavigationBar persistente (fuera de page.views) con 8 destinos.
            # Los 3 primeros visibles; el 4º ("Más") abre BottomSheet con el resto.
            self.navigation_bar = ft.NavigationBar(
                bgcolor=ft.Colors.SURFACE_CONTAINER_HIGHEST,
                destinations=[
                    ft.NavigationBarDestination(icon=ft.Icons.SHOPPING_CART_OUTLINED, selected_icon=ft.Icons.SHOPPING_CART, label="Inventario"),
                    ft.NavigationBarDestination(icon=ft.Icons.CHECKLIST_OUTLINED, selected_icon=ft.Icons.CHECKLIST, label="Validación"),
                    ft.NavigationBarDestination(icon=ft.Icons.WAREHOUSE_OUTLINED, selected_icon=ft.Icons.WAREHOUSE, label="Stock"),
                    ft.NavigationBarDestination(icon=ft.Icons.MORE_HORIZ, selected_icon=ft.Icons.MORE_HORIZ, label="Más"),
                ],
                on_change=self._on_navigation_change,
            )
            self.page.navigation_bar = self.navigation_bar

            # FAB persistente para toggle de tema (fuera de page.views, no anima)
            self.theme_fab = ft.FloatingActionButton(
                icon=ft.Icons.LIGHT_MODE,
                tooltip="Cambiar tema",
                on_click=self._toggle_theme,
                bgcolor=ft.Colors.SURFACE_CONTAINER_HIGHEST,
                mini=True,
            )
            self.page.floating_action_button = self.theme_fab
            self.page.floating_action_button_location = ft.FloatingActionButtonLocation.END_FLOAT

            # Cada tab construye su propia ft.View (solo contenido + barra de sync).
            for index, route in enumerate(self._ROUTES):
                self._route_views[route] = self._build_route_view(index)

            self._sync_active_refs(self._ROUTES[0])
        except Exception as e:
            logger.error(f"Error en _create_layout: {e}", exc_info=True)
            show_error("Error al crear el layout de la app", e, "ControlEntradasSalidasApp._create_layout")

    def _sync_active_refs(self, route: str):
        """Apunta las referencias globales al shell de la ruta activa."""
        self.content_area = self._content_areas.get(route)
        self.sync_status_bar = self._sync_bars.get(route)

    def _build_route_view(self, index: int) -> ft.View:
        """Construye la ft.View para un tab (solo contenido + barra de sync)."""
        heavy_view = self.views[index]

        content_area = ft.Container(
            content=ft.Column([heavy_view], expand=True, spacing=0),
            expand=True,
            bgcolor='#1A1A1A',
        )

        sync_status_bar = ft.Container(
            height=0, visible=True,
            bgcolor='#2D2D2D',
            padding=ft.Padding.symmetric(horizontal=12, vertical=0),
            border_radius=ft.BorderRadius.all(8),
            content=ft.Row([
                ft.ProgressRing(width=14, height=14, stroke_width=2, color='#BB86FC'),
                ft.Text("", size=12, color='#BBBBBB', expand=True, no_wrap=False),
            ], spacing=8, alignment=ft.MainAxisAlignment.START),
        )

        sync_safe = ft.SafeArea(
            content=sync_status_bar,
            avoid_intrusions_left=True, avoid_intrusions_top=True,
            avoid_intrusions_right=True, avoid_intrusions_bottom=False,
        )

        route = self._ROUTES[index]
        self._content_areas[route] = content_area
        self._sync_bars[route] = sync_status_bar

        return ft.View(
            route=self._ROUTES[index],
            controls=[
                ft.Column([
                    sync_safe,
                    ft.SafeArea(content=content_area, expand=True),
                ], spacing=4, expand=True),
            ],
            padding=5,
            spacing=0,
            bgcolor='#121212',
        )

    def _on_sync_progress(self, msg: str):
        """Recibe mensajes de progreso del SyncManager."""
        try:
            if not self.page or not hasattr(self, 'sync_status_bar'):
                return

            is_error = 'Error' in msg and 'Error en' not in msg
            is_done = msg.endswith('finalizada') or msg.endswith('completada') or msg.endswith('completado')
            is_start = msg.endswith('completa...')
            is_empty = 'No hay' in msg or '0 registros' in msg or '0 requisiciones' in msg

            bars = list(dict.fromkeys(
                [self.sync_status_bar] + list(self._sync_bars.values())
            ))

            clean = msg.replace('[SYNC] ', '').replace('[SYNC-DEBUG] ', '').strip()

            for bar in bars:
                if not bar or not bar.content:
                    continue
                text = bar.content.controls[1]
                spinner = bar.content.controls[0]
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
                    import threading
                    threading.Thread(target=self._hide_sync_bar, args=(4,), daemon=True).start()
                elif is_error:
                    text.value = f"✗ {clean}"
                    text.color = '#F44336'
                    spinner.visible = False
                    bar.bgcolor = '#3D1B1B'
                    threading.Thread(target=self._hide_sync_bar, args=(6,), daemon=True).start()
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

    def _hide_sync_bar(self, delay: float = 4):
        import time
        time.sleep(delay)
        try:
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

    def _route_to_index(self, route: str) -> int:
        try:
            return self._ROUTES.index(route)
        except ValueError:
            return 0

    def _on_route_change(self, e):
        """Deriva page.views a partir de page.route (patrón oficial de Flet)."""
        if self.page is None:
            return
        try:
            route = getattr(e, 'route', None) or self.page.route or self._ROUTES[0]
            index = self._route_to_index(route)
            view_route = self._ROUTES[index]

            prev_view = self.current_view

            self._sync_active_refs(view_route)

            self.current_view_index = index
            self.current_view = self.views[index]

            if self.navigation_bar:
                self.navigation_bar.selected_index = index if index < 3 else 3

            # Las vistas pesadas arrancan con visible=False por diseño; al montarse
            # en el árbol activo deben marcarse visibles.
            heavy = self.views[index]
            heavy.visible = True

            # Apagar la vista anterior: sus monitores/callbacks comprueban
            # self.visible antes de forzar refrescos de página.
            if prev_view is not None and prev_view is not heavy:
                prev_view.visible = False

            # Cerrar cualquier BottomSheet abierto al cambiar de tab.
            for prev in [o for o in self.page.overlay if isinstance(o, ft.BottomSheet)]:
                prev.open = False
                self.page.overlay.remove(prev)

            target = self._route_views[view_route]

            # Sustituir la pila: un único View activo por ruta. El cliente
            # detecta el cambio de ruta y aplica la transición nativa del tema.
            self.page.views.clear()
            self.page.views.append(target)
            self.page.update()

            # Garantizar que la vista pesada está construida. El framework ya
            # llama did_mount al montar controles; este respaldo es idempotente
            # gracias al guard _mounted de cada vista.
            if hasattr(heavy, 'did_mount'):
                try:
                    heavy.did_mount()
                except Exception as em:
                    logger.warning(f"did_mount falló para vista {index}: {em}")

            if hasattr(heavy, '_update_connection_indicator'):
                try:
                    if hasattr(heavy, '_connection_indicator'):
                        heavy._update_connection_indicator()
                except Exception:
                    pass

            self.page.update()
        except Exception as ex:
            logger.error(f"Error en _on_route_change: {ex}", exc_info=True)
            show_error("Error al cambiar de vista", ex, "ControlEntradasSalidasApp._on_route_change")

    def _on_navigation_change(self, e):
        if self.page is None:
            return
        try:
            if isinstance(e.control, ft.NavigationBar):
                index = int(e.control.selected_index)
                if index == 3:  # "Más"
                    self._show_more_menu()
                    # Resetear el índice seleccionado al anterior tras abrir el menú
                    self.navigation_bar.selected_index = self.current_view_index if self.current_view_index < 3 else 0
                    self.page.update()
                    return
                self.page.go(self._ROUTES[index])
                return
        except Exception as e:
            logger.error(f"Error en _on_navigation_change: {e}", exc_info=True)
            show_error("Error al cambiar de vista", e, "ControlEntradasSalidasApp._on_navigation_change")

    def _show_view(self, index: int):
        """Compatibilidad: navega a la ruta del tab indicado."""
        if index < 0 or index >= len(self._ROUTES):
            return
        self.page.go(self._ROUTES[index])

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
                self.bottom_sheet.open = False
                self.page.update()
                self._toggle_theme()

            def on_nav(e, idx):
                self.bottom_sheet.open = False
                self.page.update()
                self._show_view(idx)

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
