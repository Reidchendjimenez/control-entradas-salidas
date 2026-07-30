"""
Vista post-login del POS.

Redirige al usuario a la pantalla de Comandas
(mesas / habitaciones) una vez autenticado.
"""
import flet as ft


class POSHomeView(ft.Container):
    def __init__(self, usuario: dict = None, sesion_id: int = None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 0
        self.usuario = usuario
        self.sesion_id = sesion_id

        if self.page:
            self._redirect_to_comandas()
        else:
            self._build_placeholder()

    def _build_placeholder(self):
        self.content = ft.Container(
            content=ft.Text("Redirigiendo...", color=ft.Colors.WHITE),
            alignment=ft.alignment.center,
            expand=True,
        )

    def _redirect_to_comandas(self):
        from usr.pos.views.comandas import ComandasView
        comandas = ComandasView(
            usuario=self.usuario,
            sesion_id=self.sesion_id,
        )
        self.page.clean()
        self.page.add(comandas)
        self.page.update()
