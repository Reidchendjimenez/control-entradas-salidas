"""
Launcher para el POS con soporte de actualizaciones.
"""
import os
import sys
import asyncio
import flet as ft
from usr.logger import get_logger

logger = get_logger(__name__)


def _resource_path(relative_path: str) -> str:
    if hasattr(sys, '_MEIPASS'):
        return os.path.join(sys._MEIPASS, relative_path)
    d = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    if os.path.basename(d) == 'app_updates':
        d = os.path.dirname(d)
    return os.path.abspath(os.path.join(d, relative_path))


async def main(page: ft.Page):
    page.title = "Lycoris POS"
    page.favicon = "favicon.png"
    page.bgcolor = "#121212"
    page.theme_mode = ft.ThemeMode.DARK
    page.assets_allow_override = True
    page.window.icon = _resource_path("assets/icono_azul.ico")

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

    from usr.updater import _get_app_dir
    app_dir = _get_app_dir()
    updates_dir = os.path.join(app_dir, "app_updates")

    # Mostrar pantalla de carga (misma implementación que el módulo de control)
    from usr.views.splash import LoadingSplash, _POS_STAGES
    loading = LoadingSplash(
        page,
        title="Lycoris POS",
        logo_src="icono_azul.png",
        stages=_POS_STAGES,
        desktop_bg="fondo_horizontal_rojo.jpeg",
    )
    step_text = loading.step_text
    status_text = loading.status_text
    page.add(loading)
    page.update()

    # Comprobar actualizaciones
    try:
        from usr.updater import comprobar_y_aplicar_actualizaciones
        await comprobar_y_aplicar_actualizaciones(page, status_text)
    except Exception as e_up:
        print(f"[POS] Error ejecutando actualizador: {e_up}")

    # Cargar código desde app_updates si existe
    if os.path.exists(updates_dir):
        status_text.value = "Aplicando actualizaciones..."
        status_text.update()
        sys.path.insert(0, updates_dir)
        updates_usr = os.path.join(updates_dir, "usr")
        if os.path.exists(updates_usr):
            import usr
            original_path = list(usr.__path__)
            usr.__path__ = [os.path.abspath(updates_usr)] + original_path
            for key in list(sys.modules.keys()):
                if key == "usr" or key.startswith("usr."):
                    sys.modules.pop(key, None)
            db_path = os.environ.get('LYCORIS_DB_PATH', 'lycoris_local.db')
            from usr.database.conn import set_db_path as _reset_db_path
            _reset_db_path(db_path)
            from usr.database.local_replica import ensure_local_db as _ensure_local_db_updates
            try:
                _ensure_local_db_updates()
            except Exception as e_eldu:
                print(f"[POS] Error ensure_local_db tras override: {e_eldu}")

    db_path = os.environ.get('LYCORIS_DB_PATH') or os.path.abspath(os.path.join(db_dir, "lycoris_local.db"))
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

    # Sincronizar datos POS desde Supabase (independiente del sync de inventario)
    try:
        from usr.database.base import get_engine
        from usr.database.pos_sync import init_pos_sync_manager, get_pos_sync_manager
        init_pos_sync_manager(get_engine)
        sm = get_pos_sync_manager()
        if sm:
            # El splash avanza con cada paso del sync (los _log de pos_sync
            # disparan el callback de progreso).
            sincprog = getattr(sm, 'set_sync_progress_callback', None)
            if sincprog and hasattr(loading, 'set_progress'):
                sincprog(loading.set_progress)
        if sm and sm.check_connection():
            try:
                # Correr el sync en un hilo (asyncio.to_thread): así el callback
                # de progreso se dispara sin bloquear el event loop de Flet y la
                # pantalla de carga puede refrescar el % en cada paso.
                await asyncio.to_thread(sm.full_sync)
                print("[POS] Sync completado")
            except Exception as e_full:
                import traceback as tb
                print(f"[POS] Error en full_sync: {e_full}")
                tb.print_exc()
        if sm:
            sm.start_background_sync(30)
            print("[POS] Sync en segundo plano cada 30s")
    except Exception as e:
        import traceback as tb
        print(f"[POS] Error en sync: {e}")
        tb.print_exc()

    # Barra de progreso global de sync (parte superior, visible en todas las pantallas)
    try:
        from usr.pos.sync_indicator import init_pos_sync_indicator
        pos_sync_indicator = init_pos_sync_indicator(page)
        pos_sync_indicator.register()
    except Exception as e:
        print(f"[POS] Error registrando barra de sync: {e}")

    # Actualizar la tasa de cambio BCV al arrancar, en segundo plano,
    # para que al abrir la comanda ya esté cargada la más reciente.
    try:
        import threading
        def _actualizar_tasa_inicio():
            from usr.pos.tasa_cambio import actualizar_tasa, get_diagnostico
            try:
                tasa, cambiada, _ = actualizar_tasa()
                print(f"[POS] Tasa al arranque: {tasa} (cambiada: {cambiada}) | {get_diagnostico()}")
            except Exception as ex:
                print(f"[POS] Error actualizando tasa al arranque: {ex}")
        threading.Thread(target=_actualizar_tasa_inicio, daemon=True).start()
        print("[POS] Actualizando tasa BCV al arranque...")
    except Exception as e:
        import traceback as tb
        print(f"[POS] Error lanzando actualizacion de tasa: {e}")
        tb.print_exc()

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
