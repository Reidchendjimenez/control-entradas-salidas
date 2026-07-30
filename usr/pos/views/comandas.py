"""
Vista de Comandas del POS.

Muestra dos puntos de entrada para comandas:
- Mesas (restaurante)
- Habitaciones (hotel)

Cada uno tiene su propia vista para gestionar comandas activas.
Aqui se desarrollara:
- Seleccion de mesa/habitacion especifica
- Creacion de comandas
- Agregar productos a la comanda
- Cerrar comanda y registrar venta
"""
import flet as ft


class ComandasView(ft.Container):
    def __init__(self, usuario: dict = None, sesion_id: int = None, on_logout=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 0
        self.usuario = usuario
        self.sesion_id = sesion_id
        self.on_logout = on_logout
        self._build_ui()

    def _build_ui(self):
        nombre = self.usuario.get('nombre', 'Cajero') if self.usuario else 'Cajero'
        iniciales = nombre[:2].upper() if nombre else "?"
        es_admin = bool(self.usuario.get('es_admin', 0)) if self.usuario else False
        avatar_color = "#FF9800" if es_admin else "#7C4DFF"

        avatar = ft.Container(
            content=ft.Text(
                iniciales,
                size=14,
                weight=ft.FontWeight.BOLD,
                color=ft.Colors.WHITE,
            ),
            width=36,
            height=36,
            bgcolor=avatar_color,
            border_radius=18,
            alignment=ft.alignment.center,
        )

        user_info = ft.Column(
            [
                ft.Text(nombre, size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                ft.Text(
                    f"Administrador" if es_admin else f"Cajero #{self.usuario.get('id', '?')}" if self.usuario else "",
                    size=11,
                    color="#FF9800" if es_admin else "#9E9E9E",
                ),
            ],
            spacing=1,
            tight=True,
        )

        btn_logout = ft.IconButton(
            icon=ft.Icons.LOGOUT_ROUNDED,
            icon_color="#EF5350",
            tooltip="Cerrar sesion",
            on_click=lambda _: self._cerrar_sesion(),
        )

        right_controls = []
        if es_admin:
            right_controls.append(
                ft.IconButton(
                    icon=ft.Icons.SETTINGS_ROUNDED,
                    icon_color="#FF9800",
                    tooltip="Configuracion",
                    on_click=lambda _: self._go_config(),
                )
            )
        right_controls.append(btn_logout)

        top_bar = ft.Container(
            content=ft.Row(
                [
                    ft.Row(
                        [avatar, user_info],
                        spacing=10,
                        vertical_alignment=ft.CrossAxisAlignment.CENTER,
                    ),
                    ft.Container(expand=True),
                    ft.Row(right_controls, spacing=0),
                ],
                alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                vertical_alignment=ft.CrossAxisAlignment.CENTER,
            ),
            bgcolor="#1E1E1E",
            border=ft.border.only(bottom=ft.BorderSide(1, "#3D3D3D")),
            padding=ft.padding.symmetric(horizontal=20, vertical=10),
        )

        header = ft.Container(
            content=ft.Column(
                [
                    ft.Text("Comandas", size=28, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    ft.Text("Seleccione el punto de entrada", size=14, color="#9E9E9E"),
                ],
                spacing=2,
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            ),
            padding=ft.padding.only(top=30, bottom=30),
            alignment=ft.alignment.center,
        )

        cards = ft.Row(
            [
                self._build_entry_card(
                    icon=ft.Icons.RESTAURANT_ROUNDED,
                    titulo="Mesas",
                    subtitulo="Area del restaurante",
                    color="#FF6B6B",
                    on_click=lambda _: self._go_mesas(),
                ),
                self._build_entry_card(
                    icon=ft.Icons.HOTEL_ROUNDED,
                    titulo="Habitaciones",
                    subtitulo="Servicio a la habitacion",
                    color="#4FC3F7",
                    on_click=lambda _: self._go_habitaciones(),
                ),
            ],
            alignment=ft.MainAxisAlignment.CENTER,
            spacing=30,
            wrap=True,
        )

        self.content = ft.Column(
            [top_bar, header, cards],
            expand=True,
            spacing=0,
        )

    def _build_entry_card(self, icon, titulo, subtitulo, color, on_click):
        return ft.Container(
            content=ft.Column(
                [
                    ft.Container(
                        content=ft.Icon(icon, size=70, color=color),
                        padding=30,
                        border_radius=60,
                        bgcolor=ft.Colors.with_opacity(0.15, color),
                    ),
                    ft.Container(height=20),
                    ft.Text(titulo, size=22, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    ft.Container(height=5),
                    ft.Text(subtitulo, size=13, color="#9E9E9E"),
                    ft.Container(height=20),
                    ft.Container(
                        content=ft.Row(
                            [
                                ft.Text("Entrar", size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                                ft.Icon(ft.Icons.ARROW_FORWARD_ROUNDED, size=18, color=ft.Colors.WHITE),
                            ],
                            spacing=8,
                            tight=True,
                        ),
                        bgcolor=color,
                        padding=ft.padding.symmetric(horizontal=20, vertical=10),
                        border_radius=20,
                    ),
                ],
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                spacing=0,
            ),
            width=260,
            height=320,
            bgcolor="#1E1E1E",
            border=ft.border.all(1, "#3D3D3D"),
            border_radius=15,
            padding=20,
            on_click=on_click,
            ink=True,
        )

    def _go_mesas(self):
        if self.page:
            from usr.pos.views.mesas import MesasView
            mesas_view = MesasView(
                usuario=self.usuario,
                sesion_id=self.sesion_id,
                on_logout=self.on_logout,
                on_back=lambda: self._volver_selector(),
            )
            self.page.clean()
            self.page.add(mesas_view)
            self.page.update()

    def _go_habitaciones(self):
        if self.page:
            from usr.pos.views.habitaciones import HabitacionesView
            hab_view = HabitacionesView(
                usuario=self.usuario,
                sesion_id=self.sesion_id,
                on_logout=self.on_logout,
                on_back=lambda: self._volver_selector(),
            )
            self.page.clean()
            self.page.add(hab_view)
            self.page.update()

    def _go_config(self):
        if self.page:
            from usr.pos.views.config import ConfigPOSView
            config_view = ConfigPOSView(
                usuario=self.usuario,
                sesion_id=self.sesion_id,
                on_logout=self.on_logout,
                on_back=lambda: self._volver_selector(),
            )
            self.page.clean()
            self.page.add(config_view)
            self.page.update()

    def _volver_selector(self):
        if self.page:
            from usr.pos.views.comandas import ComandasView
            selector = ComandasView(
                usuario=self.usuario,
                sesion_id=self.sesion_id,
                on_logout=self.on_logout,
            )
            self.page.clean()
            self.page.add(selector)
            self.page.update()

    def _cerrar_sesion(self):
        if self.sesion_id:
            try:
                from usr.database.local_replica import LocalReplica
                LocalReplica.cerrar_pos_sesion(self.sesion_id)
            except Exception:
                pass
        if self.on_logout:
            self.on_logout()
        elif self.page:
            from usr.pos.views.login import POSLoginView
            self.page.clean()
            self.page.add(POSLoginView(on_login=self._on_login_done))
            self.page.update()

    def _on_login_done(self, usuario, sesion_id):
        if self.page:
            from usr.pos.views.comandas import ComandasView
            self.page.clean()
            self.page.add(ComandasView(usuario=usuario, sesion_id=sesion_id))
            self.page.update()
