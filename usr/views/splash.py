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
from typing import Optional

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


# Etapas del sync POS (pos_sync emite mensajes con el patrón "N <tabla> descargados").
# Refleja el orden real del flujo para que el % avance con cada paso.
_POS_STAGES = [
    ("Iniciando sincronizacion POS...", 6, "Conectando con el servidor…"),
    ("categorias (visibles en POS) descargadas", 12, "Sincronizando categorías…"),
    ("productos (para la venta) descargados", 18, "Sincronizando productos…"),
    ("platos_categorias descargados", 26, "Sincronizando categorías de platos…"),
    ("platos descargados", 34, "Sincronizando platos…"),
    ("plato_ingredientes descargados", 38, "Sincronizando ingredientes…"),
    ("plato_contornos descargados", 42, "Sincronizando contornos…"),
    ("pos_categorias descargados", 46, "Sincronizando categorías POS…"),
    ("pos_mesas descargados", 50, "Sincronizando mesas…"),
    ("pos_habitaciones descargados", 54, "Sincronizando habitaciones…"),
    ("pos_usuarios descargados", 58, "Sincronizando usuarios…"),
    ("pos_settings descargados", 62, "Sincronizando configuración…"),
    ("pos_comandas descargados", 74, "Sincronizando comandas…"),
    ("pos_ventas descargados", 80, "Sincronizando ventas…"),
    ("movimientos descargados", 88, "Sincronizando movimientos…"),
    ("Descarga POS completada", 95, "Aplicando cambios…"),
    ("Sincronizacion POS finalizada", 100, "¡Todo listo!"),
]


def _find_background_image(page=None, desktop_bg=None):
    """Devuelve el 'src' de la imagen de fondo (estática) a usar, o None.

    En móvil los assets se sirven desde el bundle y no hay archivo local que
    inspeccionar: se devuelve la imagen vertical fija (MOBILE_BACKGROUND).

    En escritorio se verifica que la imagen horizontal exista como archivo en
    'assets/' o 'assets_pos/', junto al módulo o en el directorio de trabajo,
    para no apuntar a un recurso inexistente (en ese caso se cae al fondo
    oscuro). El nombre puede pasarse por parámetro (desktop_bg), p. ej. para
    que el POS use su propio fondo desde 'assets_pos/'.
    """
    if page is not None:
        plat = getattr(page, "platform", None)
        if plat is not None and str(plat).lower() in ("android", "ios", "android_tv"):
            return MOBILE_BACKGROUND

    bg_name = desktop_bg or DESKTOP_BACKGROUND
    bases = set()
    here = os.path.dirname(os.path.abspath(__file__))
    for b in (os.path.join(here, "..", ".."), os.getcwd()):
        bases.add(os.path.abspath(b))
        for sub in ("assets", "assets_pos"):
            bases.add(os.path.abspath(os.path.join(b, sub)))
    for base in bases:
        if os.path.isfile(os.path.join(base, bg_name)):
            return bg_name
    return None


class LoadingSplash:
    """Splash a pantalla completa con fondo (imagen estática) y UI animada.

    No hereda de ft.Container para evitar bugs de centrado en Flet 0.86.
    Usa build() para crear un Container plano con layout que SÍ centra.
    """

    def __init__(self, page: ft.Page, title: str = "Control de Entradas y Salidas",
                 logo_src: str = "icono.png", stages: Optional[list] = None,
                 desktop_bg: Optional[str] = None):
        self._page = page
        self._stages = stages if stages is not None else _STAGES
        self._fondo_src = _find_background_image(page=page, desktop_bg=desktop_bg)

        self._logo = ft.Container(
            content=ft.Image(
                src=logo_src, width=84, height=84,
                fit=ft.BoxFit.CONTAIN,
                error_content=ft.Icon(ft.Icons.FACTORY_OUTLINED, size=48, color="#BB86FC"),
            ),
            width=96, height=96,
            bgcolor=ft.Colors.with_opacity(0.15, "#BB86FC"),
            border_radius=24,
            border=ft.Border.all(width=2, color="#BB86FC"),
            alignment=ft.Alignment.CENTER,
            clip_behavior=ft.ClipBehavior.ANTI_ALIAS,
        )

        self._ring = ft.ProgressRing(
            value=0.0,
            width=146, height=146, stroke_width=10,
            color="#BB86FC", bgcolor="#2A2A2A",
        )
        # Envolver el logo en un Container del mismo tamaño que el anillo (146x146)
        # y centrarlo con alignment=CENTER para que quede perfecto sobre el ring.
        logo_wrapper = ft.Container(
            content=self._logo,
            width=146,
            height=146,
            alignment=ft.Alignment.CENTER,
        )
        self._anillo = ft.Stack(
            controls=[self._ring, logo_wrapper],
            width=146, height=146,
            alignment=ft.Alignment.CENTER,
        )

        self._porcentaje = ft.Text("0%", size=20, weight="bold", color="#FFFFFF")
        self._paso = ft.Text("", size=13, color="#9E9E9E", text_align="center")
        self._etiqueta = ft.Text(
            "Abriendo la aplicación…", size=14, color="#BBBBBB", text_align="center"
        )

        columna = ft.Column([
            self._anillo,
            ft.Container(height=8),
            ft.Text(title, size=16, weight="bold", color="#FFFFFF"),
            ft.Container(height=18),
            self._porcentaje,
            ft.Container(height=6),
            self._etiqueta,
            self._paso,
        ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=2)

        tarjeta = ft.Container(
            content=columna,
            padding=ft.Padding.symmetric(horizontal=32, vertical=28),
            bgcolor=ft.Colors.with_opacity(0.55, "#0D0D0D"),
            border_radius=20,
            blur=ft.Blur(0, 0, ft.BlurTileMode.CLAMP),
            border=ft.Border.all(1, ft.Colors.with_opacity(0.25, "#FFFFFF")),
        )

        # Fondo (imagen estática) — se pone en el Container raíz via DecorationImage
        self._fondo_src = _find_background_image(page=page, desktop_bg=desktop_bg)

        # --- Arquitectura full-screen: sin tarjeta con borde, contenido directo ---
        # Root: Container expand con imagen de fondo
        # Content: Stack con 2 capas:
        #   1) oscurece (overlay oscuro full-screen)
        #   2) Column expand + MainAxisAlignment.CENTER + CrossAxisAlignment.CENTER -> contenido directo
        oscurece = ft.Container(
            expand=True,
            bgcolor=ft.Colors.with_opacity(0.35, "#000000"),
        )
        contenido_centrado = ft.Column(
            [columna],
            expand=True,
            alignment=ft.MainAxisAlignment.CENTER,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        )
        self._root = ft.Container(
            expand=True,
            bgcolor=DARK['bg'],
            image=ft.DecorationImage(src=self._fondo_src, fit=ft.BoxFit.COVER) if self._fondo_src else None,
            content=ft.Stack(
                controls=[oscurece, contenido_centrado],
                expand=True,
                fit=ft.StackFit.EXPAND,
            ),
        )

        # Referencias para compatibilidad con código existente (updater, etc.)
        self._stop_pulso = threading.Event()
        self._hilo_pulso = threading.Thread(target=self._pulso, daemon=True)
        self._hilo_pulso.start()

        self._stop_ring = threading.Event()
        self._cuadro = 0.0
        self._tiene_progreso = False
        self._ultimo_pct_paso = 0  # último % válido de paso "X/Y"
        self._hilo_ring = threading.Thread(target=self._anillo_idle, daemon=True)
        self._hilo_ring.start()

    @property
    def control(self) -> ft.Container:
        """Devuelve el Container raíz para añadir a la página: page.add(splash.control)"""
        return self._root

    # Alias para compatibilidad: page.add(splash) sigue funcionando si se usa __getattr__
    def __getattr__(self, name):
        return getattr(self._root, name)

    # -- anillo: gira sin progreso hasta que haya % real del sync -------------
    def _anillo_idle(self):
        sentido = 1.0
        while not self._stop_ring.is_set():
            if self._tiene_progreso:
                try:
                    self._ring.value = self._valor
                    self._porcentaje.value = f"{int(self._valor * 100)}%"
                    if self._page is not None:
                        self._page.update()
                except Exception:
                    pass
                time.sleep(0.1)
                continue
            pct_paso = self._pct_paso()
            if pct_paso is not None:
                v = pct_paso / 100.0
                try:
                    self._ring.value = v
                    self._porcentaje.value = f"{int(pct_paso)}%"
                    if self._page is not None:
                        self._page.update()
                except Exception:
                    pass
                time.sleep(0.1)
                continue
            # Fallback: último % de paso válido (ej. "3/5" = 60%) mientras no hay sync real
            if self._ultimo_pct_paso > 0:
                v = self._ultimo_pct_paso / 100.0
                try:
                    self._ring.value = v
                    self._porcentaje.value = f"{self._ultimo_pct_paso}%"
                    if self._page is not None:
                        self._page.update()
                except Exception:
                    pass
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
                self._porcentaje.value = f"{int(self._cuadro * 100)}%"
                if self._page is not None:
                    self._page.update()
            except Exception:
                pass
            time.sleep(0.04)

    # -- % derivado del paso humano "X/Y" (ej. '3/5') previo al sync ----------
    def _pct_paso(self):
        text = (self._paso.value or "").strip()
        if "/" in text:
            try:
                cur, total = text.split("/")
                total = int(total)
                cur = int(cur)
                if total > 0:
                    pct = max(0, min(100, round(cur / total * 100)))
                    self._ultimo_pct_paso = pct
                    return pct
            except (ValueError, TypeError):
                pass
        return None

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
        step_idx = 0
        for i, (sub, p, lbl) in enumerate(self._stages, start=1):
            if sub in (msg or ""):
                if lbl:
                    label = lbl
                if pct is None or p > pct:
                    pct = p
                    step_idx = i
        return pct, label, step_idx, len(self._stages)

    def set_progress(self, msg: str):
        """Actualiza anillo, % y etiqueta en función del mensaje del sync."""
        pct, label, step_idx, step_total = self._parse(msg)
        if pct is not None:
            autoval = pct / 100.0
            if autoval > self._valor:
                self._valor = autoval
            self._tiene_progreso = True
            if step_idx:
                self._paso.value = f"{step_idx}/{step_total}"
        if label:
            self._etiqueta.value = label
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