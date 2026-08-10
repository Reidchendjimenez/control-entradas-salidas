import os
import sys
import ssl
import certifi

os.environ['SSL_CERT_FILE'] = certifi.where()


def resource_path(relative_path: str) -> str:
    """Ruta a recursos empaquetados (assets, .env, etc.).

    - PyInstaller (Windows): sys._MEIPASS apunta a _internal/
    - Flet 0.86+ (Android): assets via __file__ / importlib.resources
    - Desarrollo: directorio del script
    """
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, relative_path)
    return os.path.join(os.path.dirname(os.path.abspath(__file__)), relative_path)


def _get_app_dir() -> str:
    """Directorio base de la app (escribible para BD, logs, app_updates).

    Prioridad:
    1. FLET_APP_STORAGE_DATA (Flet 0.86+ directorio de datos escribible)
    2. Directorio del ejecutable (PyInstaller onedir: dist/Lycoris/)
    3. Directorio del script (desarrollo)
    """
    for var in ("FLET_APP_STORAGE_DATA", "FLET_APP_STORAGE_TEMP"):
        p = os.getenv(var)
        if p:
            return p
    if getattr(sys, 'frozen', False):
        return os.path.dirname(sys.executable)
    return os.path.dirname(os.path.abspath(__file__))


# Directorio base de la app (escribible para BD, logs, app_updates)
_app_dir = _get_app_dir()
_updates_dir = os.path.join(_app_dir, "app_updates")
if os.path.exists(_updates_dir):
    sys.path.insert(0, _updates_dir)

# Ruta de la BD local (en directorio escribible)
os.environ['LYCORIS_DB_PATH'] = os.path.join(_app_dir, "lycoris_local.db")

import asyncio
import flet as ft
import usr.app_launcher

async def main(page: ft.Page) -> None:
    await usr.app_launcher.main(page)

if __name__ == "__main__":
    import flet as ft
    ft.run(main, assets_dir=resource_path("assets"), view=ft.AppView.WEB_BROWSER, port=8000, no_cdn=True, web_renderer=ft.WebRenderer.CANVAS_KIT)