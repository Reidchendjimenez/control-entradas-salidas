"""Pantalla de carga (splash) animada que se muestra durante la sincronización.

Escucha los mensajes de progreso del SyncManager (`set_sync_progress_callback`)
y traduce cada paso a un porcentaje y una etiqueta amigable.

El fondo es una imagen estática distinta según la orientación:
- Móvil (Android/iOS): imagen vertical.
- Escritorio: imagen horizontal.
"""
import os
import threading
import time

import flet as ft

from usr.theme import get_theme

DARK = get_theme(True)


# En móvil Flet sirve los assets desde el bundle (no hay archivo que inspeccionar),
# así que aquí se fijan los nombres exactos de las imágenes de fondo dentro de 'assets/'.
MOBILE_BACKGROUND = "fondo_vertical.jpeg"
DESKTOP_BACKGROUND = "fondo_horizontal.jpeg"


# Cada paso conocido del sync aporta un porcentaje mínimo acotado. El progreso
# es monótono: nunca baja lo ya alcanzado.
_STAGES = [
    ("Iniciando sincronización", 6, "Conectando con el servidor…"),
    ("requisiciones antes de podar", 8, "Verificando requisiciones…"),
    ("No hay movimientos", 12, "Subiendo tus cambios…"),
    ("Movimientos guardados", 16, "Organizando movimientos…"),
    ("categorias baixats", 22, "Sincronizando categorías…"),
    ("productos baixats", 34, "Sincronizando productos…"),
    ("proveedores baixats", 42, "Sincronizando proveedores…"),
    ("existencias baixats", 50, "Sincronizando existencias…"),
    ("movimientos baixats", 62, "Sincronizando movimientos…"),
    ("facturas baixats", 70, "Sincronizando facturas…"),
    ("stock_checkpoint baixats", 76, "Sincronizando stock…"),
    ("periodos baixats", 80, "Sincronizando periodos…"),
    ("requisiciones baixats", 84, "Sincronizando requisiciones…"),
    ("recetas baixats", 87, "Sincronizando recetas…"),
    ("producciones baixats", 90, "Sincronizando producciones…"),
    ("Descarga completada", 95, "Aplicando cambios…"),
    ("Sincronización completa finalizada", 100, "¡Todo listo!"),
]


def _find_background_image(page=None):
    """Devuelve el 'src' de la imagen de fondo (estática) a usar, o None.

    En móvil los assets se sirven desde el bundle y no hay archivo local que
    inspeccionar: se devuelve la imagen vertical fija (MOBILE_BACKGROUND).

    En escritorio se verifica que la imagen horizontal exista como archivo en
    'assets/', junto al módulo o en el directorio de trabajo, para no apuntar a
    un recurso inexistente (en ese caso se cae al fondo oscuro).
    """
    if page is not None:
        plat = getattr(page, "platform", None)
        if plat is not None and str(plat).lower() in ("android", "ios", "android_tv"):
            return MOBILE_BACKGROUND

    bases = set()
    here = os.path.dirname(os.path.abspath(__file__))
    for b in (os.path.join(here, "..", ".."), os.getcwd()):
        bases.add(os.path.abspath(b))
        bases.add(os.path.abspath(os.path.join(b, "assets")))
    for base in bases:
        if os.path.isfile(os.path.join(base, DESKTOP_BACKGROUND)):
            return DESKTOP_BACKGROUND
    return None


class LoadingSplash(ft.Container):
    """Splash a pantalla completa con fondo (imagen estática) y UI animada."""

    def __init__(self, page: ft.Page):
        super().__init__()
        self._page = page
        self.expand = True
        self.bgcolor = DARK['bg']
        self.alignment = ft.alignment.center
        self._valor = 0.0

        self._fondo_src = _find_background_image(page=page)

        self._logo = ft.Container(
            content=ft.Image(
                src="icono.png", width=84, height=84,
                fit=ft.ImageFit.CONTAIN,
                error_content=ft.Icon(ft.Icons.FACTORY_OUTLINED, size=48, color="#BB86FC"),
            ),
            width=96, height=96,
            bgcolor=ft.Colors.with_opacity(0.15, "#BB86FC"),
            border_radius=24,
            border=ft.border.all(2, "#BB86FC"),
            alignment=ft.alignment.center,
            clip_behavior=ft.ClipBehavior.ANTI_ALIAS,
        )

        self._ring = ft.ProgressRing(
            value=0.0,
            width=146, height=146, stroke_width=10,
            color="#BB86FC", bgcolor="#2A2A2A",
        )
        anillo = ft.Stack(
            controls=[self._ring, ft.Container(content=self._logo, alignment=ft.alignment.center)],
            width=146, height=146,
        )

        self._porcentaje = ft.Text("0%", size=20, weight="bold", color="#FFFFFF")
        self._paso = ft.Text("", size=13, color="#9E9E9E", text_align="center")
        self._etiqueta = ft.Text(
            "Abriendo la aplicación…", size=14, color="#BBBBBB", text_align="center"
        )

        self.content = ft.Column([
            anillo,
            ft.Container(height=8),
            ft.Text("Control de Entradas y Salidas", size=16, weight="bold", color="#FFFFFF"),
            ft.Container(height=18),
            self._porcentaje,
            ft.Container(height=6),
            self._etiqueta,
            self._paso,
        ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=2)

        # --- Capa vertical que centra el contenido en cualquier pantalla ----
        # Un Column con expand=True y 'alignment=ft.MainAxisAlignment.CENTER'
        # centra sus hijos verticalmente (su eje principal); el horizontal
        # lo da el horizontal_alignment del propio content. Esta es la razón
        # por la que antes quedaba pegado arriba.
        tarjeta = ft.Container(
            content=self.content,
            padding=ft.padding.symmetric(horizontal=32, vertical=28),
            bgcolor=ft.Colors.with_opacity(0.55, "#0D0D0D"),
            border_radius=20,
            blur=ft.Blur(0, 0, ft.BlurTileMode.CLAMP),
            border=ft.border.all(1, ft.Colors.with_opacity(0.25, "#FFFFFF")),
        )

        # --- Capa base: el fondo se pone en 'self.image' (propiedad del
        # Container) que cubre SIEMPRE todo el área del contenedor, con COVER.
        # (La versión previa usaba un ft.Image dentro del Stack y no llenaba).
        if self._fondo_src:
            self.image = ft.DecorationImage(
                src=self._fondo_src,
                fit=ft.ImageFit.COVER,
            )

        # Capa oscura translúcida encima del fondo + contenido centrado.
        oscurece = ft.Container(
            expand=True,
            bgcolor=ft.Colors.with_opacity(0.35, "#000000"),
        )
        tarjeta_central = ft.Container(
            content=tarjeta,
            expand=True,
            alignment=ft.alignment.center,
        )
        self.content = ft.Stack(
            controls=[oscurece, tarjeta_central],
            expand=True,
        )

        self._stop_pulso = threading.Event()
        self._hilo_pulso = threading.Thread(target=self._pulso, daemon=True)
        self._hilo_pulso.start()

        # Animación "idle" del anillo: mientras no haya progreso real del sync
        # (pre-login, esperando servidor), el anillo gira como indicador de carga.
        self._stop_ring = threading.Event()
        self._cuadro = 0.0
        self._tiene_progreso = False
        self._hilo_ring = threading.Thread(target=self._anillo_idle, daemon=True)
        self._hilo_ring.start()

    # -- anillo: gira sin progreso hasta que haya % real del sync -------------
    def _anillo_idle(self):
        sentido = 1.0
        while not self._stop_ring.is_set():
            if self._tiene_progreso:
                time.sleep(0.1)
                continue
            self._cuadro += (0.02 * sentido)
            if self._cuadro >= 0.9:
                self._cuadro = 0.9
                sentido = -1.0
            elif self._cuadro <= 0.08:
                self._cuadro = 0.08
                sentido = 1.0
            try:
                self._ring.value = self._cuadro
                if self._page is not None:
                    self._page.update()
            except Exception:
                pass
            time.sleep(0.04)

    # -- animación del logo (pulso de escala) --------------------------------
    def _pulso(self):
        escala = 1.0
        subir = True
        while not self._stop_pulso.is_set():
            try:
                self._logo.scale = ft.Scale(escala)
                self._logo.update()
            except Exception:
                pass
            if subir:
                escala = round(escala + 0.01, 3)
                if escala >= 1.04:
                    subir = False
            else:
                escala = round(escala - 0.01, 3)
                if escala <= 0.98:
                    subir = True
            time.sleep(0.06)

    # -- traducción del mensaje a progreso -----------------------------------
    def _parse(self, msg: str):
        pct = None
        label = None
        for sub, p, lbl in _STAGES:
            if sub in (msg or ""):
                if lbl:
                    label = lbl
                pct = p if pct is None else max(pct, p)
        return pct, label

    def set_progress(self, msg: str):
        """Actualiza anillo, % y etiqueta en función del mensaje del sync."""
        pct, label = self._parse(msg)
        if pct is not None:
            autoval = pct / 100.0
            if autoval > self._valor:
                self._valor = autoval
        if label:
            self._etiqueta.value = label
        self._tiene_progreso = True
        try:
            self._ring.value = self._valor
            self._porcentaje.value = f"{int(self._valor * 100)}%"
            if self._page is not None:
                self._page.update()
        except Exception:
            pass

    def set_status(self, text: str):
        """Actualiza solo la etiqueta de estado (para pasos fuera del sync)."""
        self._etiqueta.value = text
        try:
            if self._page is not None:
                self._page.update()
        except Exception:
            pass

    def set_step(self, text: str):
        """Actualiza el indicador de paso (ej. '3/5')."""
        self._paso.value = text
        try:
            if self._page is not None:
                self._page.update()
        except Exception:
            pass

    # Compatibilidad: el actualizador (updater) asigna 'status_text.value'/'color'.
    @property
    def step_text(self):
        return self._paso

    @property
    def status_text(self):
        return self._etiqueta

    def finish(self):
        """Marca el 100% y detiene las animaciones."""
        self.set_progress("Sincronización completa finalizada")
        self._stop_pulso.set()
        self._stop_ring.set()