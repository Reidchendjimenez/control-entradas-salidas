"""
Entry point alternativo para el modulo POS (Point of Sale).

Este main abre SOLO el sistema de ventas, sin login, sin sync,
sin actualizaciones. Comparte la BD local con el sistema principal
de inventario.

Uso:
    python main_pos.py
    o compilar por separado como "Lycoris POS.exe"
"""
import os
import sys
import ssl
import certifi

os.environ['SSL_CERT_FILE'] = certifi.where()


def resource_path(relative_path: str) -> str:
    """Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller."""
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, relative_path)
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), relative_path)


def assets_dir_path() -> str:
    """Directorio de assets del POS.

    El favicon del navegador se sirve de assets_dir/favicon.png (el HTML de Flet
    apunta fijo a /favicon.png). Para que el POS tenga su propio icono azul
    (distinto del modulo de control de inventario) usamos una carpeta dedicada.
    """
    return resource_path("assets_pos")


_app_dir = os.path.dirname(os.path.abspath(__file__))
_updates_dir = os.path.join(_app_dir, "app_updates")
if os.path.exists(_updates_dir):
    sys.path.insert(0, _updates_dir)
if _app_dir not in sys.path:
    sys.path.insert(0, _app_dir)

os.environ['LYCORIS_DB_PATH'] = os.path.join(_app_dir, "lycoris_local.db")

import flet as ft
import usr.pos.launcher


async def main(page: ft.Page) -> None:
    await usr.pos.launcher.main(page)


if __name__ == "__main__":
    ft.app(target=main, assets_dir=assets_dir_path())
