"""
Barra de progreso global del POS.

Aparece en la parte superior de todas las pantallas del POS mientras se
realiza una sincronizacion con Supabase, replicando el comportamiento de la
barra de sync de la app principal (ProgressRing + texto de estado).
Vive en page.overlay para que page.clean() no la elimine al navegar.
"""
import threading
import time
from typing import Optional
import flet as ft


class POSSyncIndicator:
    def __init__(self, page: ft.Page):
        self.page = page
        self._bar = None
        self._hide_timer = None
        self._active = False

    def register(self):
        from usr.database.pos_sync import get_pos_sync_manager
        sm = get_pos_sync_manager()
        if sm:
            sm.set_sync_progress_callback(self._on_progress)

    def set_active(self, active: bool):
        """Activa/desactiva la barra. Solo se muestra durante un sync manual."""
        self._active = active
        if not active and self._bar is not None:
            self._bar.height = 0
            try:
                self.page.update()
            except Exception:
                pass

    def _ensure_bar(self):
        if self._bar is not None:
            return
        self._bar = ft.Container(
            height=0,
            visible=True,
            bgcolor="#2D2D2D",
            padding=ft.Padding.symmetric(horizontal=12, vertical=0),
            border_radius=ft.BorderRadius.all(8),
            margin=ft.Margin.only(left=8, right=8, top=4),
            content=ft.Row([
                ft.ProgressRing(width=14, height=14, stroke_width=2, color="#BB86FC"),
                ft.Text("", size=12, color="#BBBBBB", expand=True, no_wrap=False),
            ], spacing=8, alignment=ft.MainAxisAlignment.START),
        )
        self.page.overlay.append(self._bar)
        self.page.update()

    def _set_bar(self, height: int, spinner: bool, text: str, color: str, bg: str):
        self._ensure_bar()
        row = self._bar.content
        row.controls[0].visible = spinner
        row.controls[1].value = text
        row.controls[1].color = color
        self._bar.height = height
        self._bar.bgcolor = bg
        try:
            self.page.update()
        except Exception:
            pass

    def _hide_later(self, delay: float = 4):
        if self._hide_timer and self._hide_timer.is_alive():
            return
        def _hide():
            time.sleep(delay)
            try:
                if self._bar is not None:
                    self._bar.height = 0
                    self.page.update()
            except Exception:
                pass
        self._hide_timer = threading.Thread(target=_hide, daemon=True)
        self._hide_timer.start()

    def _on_progress(self, msg: str):
        if not self.page or not self._active:
            return
        is_error = 'Error' in msg
        is_done = msg.endswith('finalizada') or msg.endswith('completada') or msg.endswith('completado')
        is_start = 'Iniciando sincronizacion' in msg

        clean = msg.replace('[POS-SYNC] ', '').strip()

        if is_start:
            self._set_bar(30, True, clean, "#BBBBBB", "#2D2D2D")
        elif is_done:
            self._set_bar(30, False, f"✓ {clean}", "#4CAF50", "#1B3D1B")
            self._hide_later(4)
        elif is_error:
            self._set_bar(30, False, f"✗ {clean}", "#F44336", "#3D1B1B")
            self._hide_later(6)
        else:
            self._set_bar(30, True, clean, "#BBBBBB", "#2D2D2D")


_pos_sync_indicator_instance = None


def init_pos_sync_indicator(page: ft.Page) -> POSSyncIndicator:
    global _pos_sync_indicator_instance
    _pos_sync_indicator_instance = POSSyncIndicator(page)
    return _pos_sync_indicator_instance


def get_pos_sync_indicator() -> Optional[POSSyncIndicator]:
    return _pos_sync_indicator_instance
