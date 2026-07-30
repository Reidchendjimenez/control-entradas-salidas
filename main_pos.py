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
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, relative_path)
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), relative_path)


_app_dir = os.path.dirname(os.path.abspath(__file__))
if _app_dir not in sys.path:
    sys.path.insert(0, _app_dir)

os.environ['LYCORIS_DB_PATH'] = os.path.join(_app_dir, "lycoris_local.db")

import flet as ft
import usr.pos.launcher


async def main(page: ft.Page) -> None:
    await usr.pos.launcher.main(page)


if __name__ == "__main__":
    ft.app(target=main, assets_dir=resource_path("assets"))
