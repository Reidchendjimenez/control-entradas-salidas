import flet as ft
from config.config import get_settings
from app.views import InventarioView, ValidacionView, StockView, ConfiguracionView

settings = get_settings()


class ControlEntradasSalidasApp:
    def __init__(self):
        self.page = None
        self.navigation_rail = None
        self.navigation_bar = None
        self.content_area = None
        self.current_view = None

        # No crear vistas aquí (se crearán por página en main)
        self.views = None

    def main(self, page: ft.Page):
        self.page = page
        self.page.title = settings.FLET_APP_NAME
        self.page.theme_mode = ft.ThemeMode.LIGHT
        self.page.padding = 0
        self.page.spacing = 0

        # Instanciar vistas por página (evita compartir estado entre clientes)
        self.views = {
            0: InventarioView(),
            1: ValidacionView(),
            2: StockView(),
            3: ConfiguracionView(),
        }

        # Configurar tema Material Design 3
        self._setup_theme()

        # Crear layout principal
        self._create_layout()

        # Mostrar vista inicial
        self._show_view(0)

        # Actualizar según tamaño de pantalla
        self._handle_resize()

        try:
            page.update()
        except Exception as ex:
            print("Warning: page.update failed in main():", ex)

    def _setup_theme(self):
        """Configurar tema Material Design 3"""
        self.page.theme = ft.Theme(
            color_scheme=ft.ColorScheme(
                primary="#6750A4",
                on_primary="#FFFFFF",
                primary_container="#EADDFF",
                on_primary_container="#21005D",
                secondary="#625B71",
                on_secondary="#FFFFFF",
                secondary_container="#E8DEF8",
                on_secondary_container="#1D192B",
                tertiary="#7D5260",
                on_tertiary="#FFFFFF",
                tertiary_container="#FFD8E4",
                on_tertiary_container="#31111D",
                error="#B3261E",
                on_error="#FFFFFF",
                error_container="#F9DEDC",
                on_error_container="#410E0B",
                background="#FFFBFE",
                on_background="#1C1B1F",
                surface="#FFFBFE",
                on_surface="#1C1B1F",
                surface_variant="#E7E0EC",
                on_surface_variant="#49454F",
                outline="#79747E",
                outline_variant="#C4C7C5",
                shadow="#000000",
                scrim="#000000",
                inverse_surface="#313033",
                on_inverse_surface="#F4EFF4",
                inverse_primary="#D0BCFF",
            ),
            use_material3=True,
        )

    def _create_layout(self):
        """Crear layout principal con navegación"""
        self.content_area = ft.Container(
            expand=True,
            padding=ft.padding.all(16),
            border_radius=ft.border_radius.all(12),
            bgcolor=ft.colors.WHITE,
        )

        # Crear NavigationRail (para pantallas grandes)
        self.navigation_rail = ft.NavigationRail(
            selected_index=0,
            label_type=ft.NavigationRailLabelType.ALL,
            min_width=80,
            min_extended_width=250,
            group_alignment=-0.9,
            destinations=[
                ft.NavigationRailDestination(
                    icon=ft.icons.INVENTORY,
                    selected_icon=ft.icons.INVENTORY,
                    label="INVENTARIO",
                ),
                ft.NavigationRailDestination(
                    icon=ft.icons.FACT_CHECK,
                    selected_icon=ft.icons.FACT_CHECK,
                    label="VALIDACIÓN",
                ),
                ft.NavigationRailDestination(
                    icon=ft.icons.STORAGE,
                    selected_icon=ft.icons.STORAGE,
                    label="STOCK",
                ),
                ft.NavigationRailDestination(
                    icon=ft.icons.SETTINGS,
                    selected_icon=ft.icons.SETTINGS,
                    label="CONFIGURACIÓN",
                ),
            ],
            on_change=self._on_navigation_change,
            bgcolor=ft.colors.WHITE,
            elevation=1,
        )

        # Crear NavigationBar (para móviles)
        self.navigation_bar = ft.NavigationBar(
            destinations=[
                ft.NavigationBarDestination(
                    icon=ft.icons.INVENTORY_OUTLINED,
                    selected_icon=ft.icons.INVENTORY,
                    label="INVENTARIO",
                ),
                ft.NavigationBarDestination(
                    icon=ft.icons.FACT_CHECK_OUTLINED,
                    selected_icon=ft.icons.FACT_CHECK,
                    label="VALIDACIÓN",
                ),
                ft.NavigationBarDestination(
                    icon=ft.icons.STORAGE_OUTLINED,
                    selected_icon=ft.icons.STORAGE,
                    label="STOCK",
                ),
                ft.NavigationBarDestination(
                    icon=ft.icons.SETTINGS_OUTLINED,
                    selected_icon=ft.icons.SETTINGS,
                    label="CONFIG",
                ),
            ],
            on_change=self._on_navigation_change,
            bgcolor=ft.colors.WHITE,
            elevation=2,
        )

        # Layout principal (inicialmente con NavigationRail)
        layout_row = ft.Row(
            [
                self.navigation_rail,
                ft.VerticalDivider(width=1),
                self.content_area,
            ],
            expand=True,
            spacing=0,
        )
        # Guardamos la fila para manipularla más tarde sin indexar page.controls[0] directamente
        self._layout_row = layout_row

        self.page.add(layout_row)

    def _handle_resize(self):
        """Manejar cambios de tamaño de pantalla"""
        def on_resize(e):
            try:
                if self.page.width < 600:
                    # Pantalla pequeña: usar NavigationBar
                    self._switch_to_mobile_layout()
                else:
                    # Pantalla grande: usar NavigationRail
                    self._switch_to_desktop_layout()
            except Exception as ex:
                print("Warning: error en on_resize:", ex)

        self.page.on_resized = on_resize
        # Llamada inicial protegida
        try:
            on_resize(None)
        except Exception as ex:
            print("Warning: on_resize initial call failed:", ex)

    def _switch_to_mobile_layout(self):
        """Cambiar a layout móvil (NavigationBar)"""
        try:
            # Ocultar navigation rail
            self.navigation_rail.visible = False
            # Reemplazar controles de la fila de layout de forma segura
            try:
                self._layout_row.controls = [self.content_area]
            except Exception as ex:
                print("Warning: failed to set layout_row.controls in mobile layout:", ex)
            # Asignar navigation_bar si no está ya asignado
            if self.page.navigation_bar is not self.navigation_bar:
                self.page.navigation_bar = self.navigation_bar
            # Actualizar página (protegido)
            try:
                self.page.update()
            except Exception as ex:
                print("Warning: page.update failed in _switch_to_mobile_layout():", ex)
        except Exception as ex:
            print("Warning: _switch_to_mobile_layout error:", ex)

    def _switch_to_desktop_layout(self):
        """Cambiar a layout desktop (NavigationRail)"""
        try:
            # Mostrar navigation rail
            self.navigation_rail.visible = True
            # Reconstruir controles de la fila
            try:
                self._layout_row.controls = [
                    self.navigation_rail,
                    ft.VerticalDivider(width=1),
                    self.content_area,
                ]
            except Exception as ex:
                print("Warning: failed to set layout_row.controls in desktop layout:", ex)
            # Remover navigation_bar si estaba asignado
            if self.page.navigation_bar is not None:
                try:
                    self.page.navigation_bar = None
                except Exception:
                    # Algunos backends pueden lanzar si ya es None; ignorar
                    pass
            # Actualizar página (protegido)
            try:
                self.page.update()
            except Exception as ex:
                print("Warning: page.update failed in _switch_to_desktop_layout():", ex)
        except Exception as ex:
            print("Warning: _switch_to_desktop_layout error:", ex)

    def _on_navigation_change(self, e):
        """Manejar cambio de navegación"""
        try:
            index = e.control.selected_index
            self._show_view(index)
        except Exception as ex:
            print("Warning: _on_navigation_change error:", ex)

    def _show_view(self, index: int):
        """Mostrar vista según índice"""
        try:
            # Intentar ocultar la vista actual si existe (protegido)
            if self.current_view:
                try:
                    self.current_view.visible = False
                except Exception:
                    # Puede que la vista ya no esté en el árbol; ignorar
                    pass

            view = self.views[index]
            # Asegurarnos de asignar el view como contenido del contenedor principal
            try:
                self.content_area.content = view
            except Exception as ex:
                print("Warning: failed to set content_area.content:", ex)
                # Intento alternativo: limpiar y asignar un Column conteniendo la vista
                try:
                    self.content_area.content = ft.Column([view], expand=True)
                except Exception as ex2:
                    print("Warning: fallback assign also failed:", ex2)

            # Marcar la vista actual y hacerla visible
            try:
                view.visible = True
                self.current_view = view
            except Exception:
                # ignorar errores de visibility
                self.current_view = view

            # Actualizar índice seleccionado (solo si corresponde)
            try:
                if getattr(self.navigation_rail, "visible", False):
                    self.navigation_rail.selected_index = index
            except Exception:
                pass
            try:
                if self.page.navigation_bar is not None:
                    self.page.navigation_bar.selected_index = index
            except Exception:
                pass

            # Actualizar la página
            try:
                self.page.update()
            except Exception as ex:
                print("Warning: page.update failed in _show_view():", ex)
        except Exception as ex:
            print("Warning: _show_view top-level error:", ex)


def _per_page_main(page: ft.Page):
    app = ControlEntradasSalidasApp()
    app.main(page)


if __name__ == "__main__":
    ft.app(target=_per_page_main, view=ft.AppView.WEB_BROWSER, port=settings.FLET_WEB_PORT)