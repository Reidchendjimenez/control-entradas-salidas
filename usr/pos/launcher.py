"""
Launcher simplificado para el POS.

NO incluye:
- Login de usuario
- Sincronización con Supabase
- Comprobación de actualizaciones

SÍ incluye:
- Apertura de la BD local compartida
- Configuración básica de la página
- Carga de la vista principal del POS
"""
import os
import asyncio
import flet as ft
from usr.logger import get_logger

logger = get_logger(__name__)


async def main(page: ft.Page):
    page.title = "Lycoris POS"
    page.favicon = "favicon.png"
    page.bgcolor = "#121212"
    page.theme_mode = ft.ThemeMode.DARK

    from usr.error_handler import set_page
    set_page(page)

    try:
        page.locale_configuration = ft.LocaleConfiguration(
            supported_locales=[ft.Locale("es")],
            current_locale=ft.Locale("es"),
        )
    except Exception:
        pass

    db_dir = "."
    try:
        platform = getattr(page, 'platform', None)
        if platform and str(platform) in ('android', 'ios', 'android_tv'):
            if hasattr(page, 'app_data_dir') and page.app_data_dir:
                db_dir = page.app_data_dir
    except Exception:
        pass

    db_path = os.path.abspath(os.path.join(db_dir, "lycoris_local.db"))
    os.environ['LYCORIS_DB_PATH'] = db_path

    from usr.database.conn import set_db_path
    try:
        set_db_path(db_path)
    except Exception as e:
        print(f"[POS] Error set_db_path: {e}")
        try:
            set_db_path("lycoris_local.db")
        except Exception:
            pass

    from usr.database.local_replica import ensure_local_db
    try:
        ensure_local_db()
    except Exception as e:
        print(f"[POS] Error ensure_local_db: {e}")

    # Sincronizar datos desde Supabase al iniciar POS
    try:
        from usr.database.sync import init_sync_manager, get_sync_manager
        from usr.database.base import get_engine
        init_sync_manager(get_engine)
        sm = get_sync_manager()
        if sm and sm.check_connection():
            sm.full_sync()
            print("[POS] Sync completado")
    except Exception as e:
        print(f"[POS] Error en sync: {e}")

    page.clean()
    from usr.pos.views.login import POSLoginView
    from usr.pos.views.comandas import ComandasView

    def on_login(usuario, sesion_id):
        comandas = ComandasView(usuario=usuario, sesion_id=sesion_id)
        page.clean()
        page.add(comandas)
        page.update()

    login_view = POSLoginView(on_login=on_login)
    page.add(login_view)
    page.update()
