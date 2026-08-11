import flet as ft


class PosView(ft.Container):
    @property
    def page(self):
        try:
            return super().page
        except RuntimeError:
            return None
