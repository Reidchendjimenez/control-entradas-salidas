from datetime import datetime, timedelta
from sqlalchemy import text
from usr.database.local_replica import LocalReplica
from usr.database.conn import get_local_conn
from usr.database.base import is_online


def _get_remote_engine():
    from sqlalchemy import create_engine
    from config.config import get_settings
    settings = get_settings()
    return create_engine(settings.DATABASE_URL)


def archivar_en_supabase(meses_activos: int = 3):
    """Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.
    Retorna cantidad de archivados. Lanza excepción si falla."""
    if not is_online():
        raise ConnectionError("No hay conexion a Internet para archivar en la nube")

    ahora = datetime.now()
    fecha_limite = (ahora - timedelta(days=meses_activos * 30)).isoformat()

    engine = _get_remote_engine()
    try:
        with engine.connect() as conn:
            for tbl in [
                "CREATE TABLE IF NOT EXISTS movimientos_archivo (id INTEGER PRIMARY KEY, producto_id INTEGER NOT NULL, factura_id INTEGER, requisicion_id INTEGER, tipo TEXT NOT NULL, cantidad REAL NOT NULL, cantidad_anterior REAL DEFAULT 0, cantidad_nueva REAL DEFAULT 0, peso_total REAL DEFAULT 0, registrado_por TEXT, observaciones TEXT, almacen TEXT, fecha_movimiento TEXT, created_at TEXT)",
                "CREATE TABLE IF NOT EXISTS stock_checkpoint (producto_id INTEGER NOT NULL, almacen TEXT NOT NULL, cantidad REAL DEFAULT 0, PRIMARY KEY (producto_id, almacen))",
            ]:
                conn.execute(text(tbl))
            try:
                conn.execute(text("ALTER TABLE movimientos_archivo ADD COLUMN requisicion_id INTEGER"))
                conn.commit()
            except Exception:
                conn.rollback()
            conn.execute(text("DELETE FROM stock_checkpoint"))
            existencias = LocalReplica.get_existencias()
            for ext in existencias:
                conn.execute(
                    text("INSERT INTO stock_checkpoint (producto_id, almacen, cantidad) VALUES (:p, :a, :c)"),
                    {'p': ext['producto_id'], 'a': ext['almacen'], 'c': ext.get('cantidad', 0)}
                )
            cols = "id, producto_id, factura_id, requisicion_id, tipo, cantidad, cantidad_anterior, cantidad_nueva, peso_total, registrado_por, observaciones, almacen, fecha_movimiento, created_at"
            result = conn.execute(text(f"""
                INSERT INTO movimientos_archivo ({cols})
                SELECT {cols} FROM movimientos
                WHERE fecha_movimiento < :limite AND factura_id IS NULL
            """), {'limite': fecha_limite})
            archivados = result.rowcount
            conn.execute(text("""
                DELETE FROM movimientos
                WHERE fecha_movimiento < :limite AND factura_id IS NULL
            """), {'limite': fecha_limite})
            conn.execute(text("""
                DELETE FROM movimientos_archivo
                WHERE fecha_movimiento < :limite
            """), {'limite': (ahora - timedelta(days=7 * 30)).isoformat()})
            conn.commit()
        print(f"[ARCHIVE] Supabase: {archivados} movimientos archivados")
        return archivados
    finally:
        engine.dispose()


def guardar_periodo_en_supabase(periodo: str, registrado_por: str = "sistema"):
    """Guarda el periodo aperturado en Supabase para que los demas dispositivos lo vean."""
    if not is_online():
        raise ConnectionError("No hay conexion para guardar el periodo en la nube")
    engine = _get_remote_engine()
    try:
        with engine.connect() as conn:
            conn.execute(text("""
                CREATE TABLE IF NOT EXISTS periodos (
                    id SERIAL PRIMARY KEY,
                    periodo TEXT NOT NULL UNIQUE,
                    fecha_apertura TEXT NOT NULL,
                    registrado_por TEXT
                )
            """))
            conn.execute(text(
                "INSERT INTO periodos (periodo, fecha_apertura, registrado_por) VALUES (:p, :f, :r) ON CONFLICT (periodo) DO UPDATE SET fecha_apertura = EXCLUDED.fecha_apertura"
            ), {'p': periodo, 'f': datetime.now().isoformat(), 'r': registrado_por})
            conn.commit()
    finally:
        engine.dispose()


def archivar_movimientos_local(meses_activos: int = 3, meses_retencion: int = 7):
    """Archiva movimientos en la BD local."""
    ahora = datetime.now()
    fecha_limite_principal = (ahora - timedelta(days=meses_activos * 30)).isoformat()
    fecha_limite_eliminar = (ahora - timedelta(days=meses_retencion * 30)).isoformat()

    conn = get_local_conn()
    cursor = conn.cursor()

    LocalReplica.save_checkpoints()

    cursor.execute("""
        SELECT * FROM movimientos 
        WHERE fecha_movimiento < ? AND factura_id IS NULL
        ORDER BY fecha_movimiento
    """, (fecha_limite_principal,))
    a_archivar = [dict(row) for row in cursor.fetchall()]

    archivados = 0
    for mov in a_archivar:
        cursor.execute("""
            INSERT OR IGNORE INTO movimientos_archivo
            (id, producto_id, factura_id, requisicion_id, tipo, cantidad, cantidad_anterior, cantidad_nueva,
             peso_total, registrado_por, observaciones, almacen, fecha_movimiento, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            mov.get('id'), mov.get('producto_id'), mov.get('factura_id'), mov.get('requisicion_id'),
            mov.get('tipo'), mov.get('cantidad'), mov.get('cantidad_anterior', 0),
            mov.get('cantidad_nueva', 0), mov.get('peso_total', 0),
            mov.get('registrado_por'), mov.get('observaciones'),
            mov.get('almacen'), mov.get('fecha_movimiento'), mov.get('created_at')
        ))
        cursor.execute("DELETE FROM movimientos WHERE id = ?", (mov['id'],))
        archivados += 1

    cursor.execute(
        "DELETE FROM movimientos_archivo WHERE fecha_movimiento < ?",
        (fecha_limite_eliminar,)
    )
    eliminados = cursor.rowcount

    conn.commit()
    conn.close()

    if archivados > 0 or eliminados > 0:
        print(f"[ARCHIVE] Local: {archivados} archivados, {eliminados} eliminados")

    return archivados, eliminados


def archivar_movimientos(meses_activos: int = 3, meses_retencion: int = 7):
    """Archiva en Supabase (si se puede) y siempre en local."""
    try:
        archivar_en_supabase(meses_activos)
    except Exception as e:
        print(f"[ARCHIVE] Supabase no disponible, solo archivo local: {e}")
    return archivar_movimientos_local(meses_activos, meses_retencion)
