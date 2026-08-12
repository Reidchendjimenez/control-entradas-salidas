"""
Manejo de callbacks de sincronización entre vistas.
"""
import asyncio
from typing import List, Callable

_sync_callbacks: List[Callable] = []


def run_when_connected(page, handler, *args, **kwargs):
    """Ejecuta `handler` en el event loop de la página solo si la sesión web ya
    está conectada.

    `Page.run_task` exige `page.session.connection.loop`; durante el arranque el
    sync puede notificar desde un hilo antes de que el cliente conecte y
    connection es None, lo que producía un AttributeError y dejaba la coroutine
    sin awaitear (RuntimeWarning).
    """
    if page is None:
        return None
    try:
        session = getattr(page, 'session', None)
        conn = getattr(session, 'connection', None) if session else None
        if conn is None or getattr(conn, 'loop', None) is None:
            return None
        return page.run_task(handler, *args, **kwargs)
    except Exception:
        return None


def schedule_load(coro_fn, *args, **kwargs):
    """Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna
    una Task awaitable (o None si no se pudo agendar).

    A diferencia de `Page.run_task`, NO depende de `page.session.connection.loop`
    (que puede estar temporalmente a None al inicio o mientras el hilo websocket
    reanuda), por lo que la vista se carga aunque la sesión aún no tenga
    connection. Debe invocarse desde el event loop (p.ej. dentro de
    `on_view_shown`, que corre agendada por el controlador).
    """
    try:
        return asyncio.ensure_future(coro_fn(*args, **kwargs))
    except Exception:
        return None


def register_sync_callback(callback: Callable):
    """Registra un callback que se ejecuta después de cada sync."""
    if callback not in _sync_callbacks:
        _sync_callbacks.append(callback)

def unregister_sync_callback(callback: Callable):
    """Elimina un callback registrado."""
    if callback in _sync_callbacks:
        _sync_callbacks.remove(callback)

def notify_sync_complete():
    """Notifica a todos los callbacks registrados."""
    import traceback
    if _sync_callbacks:  # Solo loguear si hay callbacks
        print(f"[SYNC CB] Notificando a {len(_sync_callbacks)} callbacks")
    for callback in _sync_callbacks:
        try:
            callback()
        except Exception as e:
            print(f"[SYNC CB] Error en callback: {e}")
            traceback.print_exc()

def clear_all_callbacks():
    """Limpia todos los callbacks registrados."""
    _sync_callbacks.clear()