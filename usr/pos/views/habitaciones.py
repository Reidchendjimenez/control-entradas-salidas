import flet as ft
from usr.database.local_replica import LocalReplica

HAB_COLOR = "#26A69A"


class HabitacionesView(ft.Container):
    def __init__(self, usuario: dict = None, sesion_id: int = None, on_logout=None, on_back=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 0
        self.usuario = usuario
        self.sesion_id = sesion_id
        self.on_logout = on_logout
        self.on_back = on_back
        self._build_ui()
        self._load_habitaciones()

    def _build_ui(self):
        top_bar = self._build_top_bar(titulo="Habitaciones", on_back=self.on_back)
        self.grid = ft.GridView(
            expand=True, runs_count=5, max_extent=120,
            child_aspect_ratio=0.8, spacing=10, run_spacing=10,
            padding=20,
        )
        self.content = ft.Column([top_bar, self.grid], expand=True, spacing=0)

    def _load_habitaciones(self):
        self.grid.controls.clear()
        self.ocupadas = LocalReplica.get_habitaciones_ocupadas() or set()
        habs = LocalReplica.get_pos_habitaciones()
        if not habs:
            self.grid.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.HOTEL_ROUNDED, size=80, color="#9E9E9E"),
                    ft.Container(height=20),
                    ft.Text("No hay habitaciones registradas", size=18, color="#9E9E9E"),
                    ft.Text("Vaya a Configuracion > Habitaciones para agregar", size=14, color="#757575"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                alignment=ft.Alignment.CENTER, expand=True,
            ))
        else:
            for h in habs:
                self.grid.controls.append(self._build_card(h))
        if self.page:
            self.update()

    def _build_card(self, hab: dict):
        numero = hab.get('numero', '?')
        piso = hab.get('piso') or ''
        tipo = hab.get('tipo') or ''
        info = ' - '.join(filter(None, [piso, tipo]))
        ocupada = int(hab.get('id') or 0) in (self.ocupadas or set())
        color = "#EF5350" if ocupada else HAB_COLOR
        badge_text = "Ocupada" if ocupada else "Disponible"
        badge_color = "#EF5350" if ocupada else "#4CAF50"
        badge_bg = "#B71C1C" if ocupada else "#1B5E20"
        card = ft.Container(
            bgcolor="#1E1E1E",
            border_radius=12, padding=12,
            width=110, height=130,
            alignment=ft.Alignment.CENTER,
            border=ft.Border(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(
                blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3),
            ),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            animate_rotation=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            content=ft.Column(
                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                alignment=ft.MainAxisAlignment.CENTER,
                controls=[
                    ft.Container(
                        content=ft.Text(numero, size=20, weight="bold", color=ft.Colors.WHITE),
                        alignment=ft.Alignment.CENTER,
                        width=40, height=40,
                        bgcolor=color,
                        shape=ft.BoxShape.CIRCLE,
                        shadow=ft.BoxShadow(
                            blur_radius=8, color=ft.Colors.with_opacity(0.3, color), offset=ft.Offset(0, 3),
                        ),
                    ),
                    ft.Container(height=6),
                    ft.Container(
                        content=ft.Text(badge_text, size=9, weight="bold", color=badge_color),
                        bgcolor=badge_bg, border_radius=10,
                        padding=ft.Padding.symmetric(horizontal=8, vertical=2),
                    ),
                    ft.Container(height=2),
                    ft.Text(
                        info.upper() if info else f"HAB {numero}",
                        size=10, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER, max_lines=2,
                        overflow=ft.TextOverflow.ELLIPSIS,
                    ),
                ],
            ),
        )
        card.on_hover = lambda e, c=card, cl=color: self._on_hover(e, c, cl)
        card.on_click = lambda _, h=hab: self._go_comanda(h)
        return card

    def _go_comanda(self, habitacion):
        if self.page:
            from usr.pos.views.comanda_view import ComandaPedidoView
            v = ComandaPedidoView(
                usuario=self.usuario, sesion_id=self.sesion_id,
                habitacion=habitacion, on_logout=self.on_logout,
                on_back=lambda: self._volver_habitaciones(),
            )
            self.page.clean()
            self.page.add(v)
            self.page.update()

    def _volver_habitaciones(self):
        if self.page:
            from usr.pos.views.comandas import ComandasView
            c = ComandasView(usuario=self.usuario, sesion_id=self.sesion_id, on_logout=self.on_logout)
            self.page.clean()
            self.page.add(c)
            self.page.update()

    @staticmethod
    def _on_hover(e, card, color):
        if e.data == "true":
            card.scale = 1.05
            card.rotate = 0.02
            card.shadow = ft.BoxShadow(
                blur_radius=15, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 0),
            )
        else:
            card.scale = 1.0
            card.rotate = 0
            card.shadow = ft.BoxShadow(
                blur_radius=0, color=ft.Colors.with_opacity(0.1, color), offset=ft.Offset(0, 0),
            )
            card.animate = ft.Animation(300, ft.AnimationCurve.DECELERATE)
        card.update()

    def _build_top_bar(self, titulo: str, on_back=None):
        nombre = self.usuario.get('nombre', 'Cajero') if self.usuario else 'Cajero'
        iniciales = nombre[:2].upper() if nombre else "?"
        es_admin = bool(self.usuario.get('es_admin', 0)) if self.usuario else False
        avatar_color = "#FF9800" if es_admin else "#7C4DFF"
        avatar = ft.Container(
            content=ft.Text(iniciales, size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
            width=36, height=36, bgcolor=avatar_color, border_radius=18, alignment=ft.Alignment.CENTER,
        )
        user_info = ft.Column([
            ft.Text(nombre, size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
            ft.Text("Administrador" if es_admin else f"Cajero #{self.usuario.get('id', '?')}" if self.usuario else "", size=11, color="#FF9800" if es_admin else "#9E9E9E"),
        ], spacing=1, tight=True)
        left = []
        if on_back:
            left.append(ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE, tooltip="Volver", on_click=lambda _: on_back()))
        left.append(ft.Text(titulo, size=18, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE))
        return ft.Container(
            content=ft.Row([
                ft.Row(left, spacing=5, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                ft.Container(expand=True),
                ft.Row([avatar, user_info], spacing=10, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                ft.IconButton(icon=ft.Icons.LOGOUT_ROUNDED, icon_color="#EF5350", tooltip="Cerrar sesion", on_click=lambda _: self._cerrar_sesion()),
            ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN, vertical_alignment=ft.CrossAxisAlignment.CENTER),
            bgcolor="#1E1E1E", border=ft.Border(bottom=ft.BorderSide(1,"#3D3D3D")),
            padding=ft.Padding.symmetric(horizontal=20, vertical=10),
        )

    def _cerrar_sesion(self):
        if self.sesion_id:
            try:
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
