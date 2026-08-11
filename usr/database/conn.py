import os
import sys
import sqlite3
from pathlib import Path

_db_path: str | None = None

def _get_storage_base() -> Path:
    """Directorio base escribible para datos de la app (Flet 0.86+ / PyInstaller).

    Prioridad:
    1. LYCORIS_DB_PATH (ya seteado por main/main_pos)
    2. FLET_APP_STORAGE_DATA (Flet 0.86+ directorio de datos escribible)
    3. FLET_APP_STORAGE_TEMP (directorio temporal)
    3. Directorio del ejecutable (PyInstaller onedir: dist/Lycoris/)
    4. Directorio actual (fallback desarrollo)
    """
    # 1. Variable explícita ya seteada por main/main_pos
    env = os.getenv("LYCORIS_DB_PATH")
    if env:
        return Path(env).parent

    # 2. Flet 0.86+: directorio de datos de la app (escribible)
    for var in ("FLET_APP_STORAGE_DATA", "FLET_APP_STORAGE_TEMP", "FLET_APP_STORAGE_CACHE"):
        p = os.getenv(var)
        if p:
            return Path(p)

    # 3. PyInstaller frozen: directorio del exe (dist/Lycoris/)
    if getattr(sys, 'frozen', False):
        return Path(sys.executable).parent

    # 4. Desarrollo: directorio actual
    return Path(".")


def set_db_path(path: str) -> None:
    """Llamar desde main() antes de cualquier import de BD."""
    global _db_path

    prev = os.environ.get('LYCORIS_DB_PATH')
    os.environ['LYCORIS_DB_PATH'] = path

    parent = Path(path).parent

    # Intentar crear directorio
    try:
        parent.mkdir(parents=True, exist_ok=True)
    except (PermissionError, OSError):
        # Fallback a directorios alternativos escribibles
        alt_paths = [
            _get_storage_base(),
            Path("."),
        ]
        for alt in alt_paths:
            try:
                alt.mkdir(parents=True, exist_ok=True)
                path = str(alt / Path(path).name)
                break
            except Exception:
                continue

    _db_path = path

    # Si el path cambió, forzar recreación del engine local
    if prev != path:
        import usr.database.base as base_mod
        base_mod._local_engine = None
        base_mod._local_session_local = None


def get_db_path() -> str:
    env_path = os.environ.get('LYCORIS_DB_PATH')
    if env_path:
        return env_path
    if _db_path is None:
        # Fallback: almacenamiento base + nombre de archivo
        return str(_get_storage_base() / "lycoris_local.db")
    return _db_path


def get_local_conn() -> sqlite3.Connection:
    db_path = get_db_path()
    try:
        conn = sqlite3.connect(db_path, timeout=30)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA journal_mode=WAL")
        conn.execute("PRAGMA busy_timeout=30000")
        conn.execute("PRAGMA synchronous=NORMAL")
        return conn
    except sqlite3.OperationalError:
        # Si falla, intentamos la ruta relativa como último recurso
        fallback_path = str(_get_storage_base() / "lycoris_local.db")
        conn = sqlite3.connect(fallback_path, timeout=30)
        conn.row_factory = sqlite3.Row
        conn.execute("PRAGMA journal_mode=WAL")
        conn.execute("PRAGMA busy_timeout=30000")
        conn.execute("PRAGMA synchronous=NORMAL")
        return conn


# Cache path - usar directorio temporal escribible (Flet 0.86: FLET_APP_STORAGE_TEMP)
def _get_cache_path() -> Path:
    base = Path(os.getenv("FLET_APP_STORAGE_TEMP", ""))
    if not base or not base.exists():
        base = _get_storage_base()
    return base / ".control_cache.db"


def get_cache_conn() -> sqlite3.Connection:
    cache_path = _get_cache_path()
    try:
        cache_path.parent.mkdir(parents=True, exist_ok=True)
        conn = sqlite3.connect(str(cache_path))
        conn.row_factory = sqlite3.Row
        return conn
    except Exception:
        # Fallback: directorio de almacenamiento base
        fallback = _get_storage_base() / ".control_cache.db"
        fallback.parent.mkdir(parents=True, exist_ok=True)
        conn = sqlite3.connect(str(fallback))
        conn.row_factory = sqlite3.Row
        return conn