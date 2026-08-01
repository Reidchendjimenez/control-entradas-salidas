"""
Sincronización bidireccional exclusiva para módulo POS.
Solo maneja tablas POS: platos, mesas, habitaciones, usuarios, settings.
Independiente del sync de inventario.
"""
import threading
import time
from datetime import datetime
from typing import Optional, List, Dict
from sqlalchemy import text
from config.config import get_settings

_POS_TABLES = [
    ('platos_categorias', 'platos_categorias'),
    ('platos', 'platos'),
    ('plato_ingredientes', 'plato_ingredientes'),
    ('plato_contornos', 'plato_contornos'),
    ('pos_mesas', 'pos_mesas'),
    ('pos_habitaciones', 'pos_habitaciones'),
    ('pos_usuarios', 'pos_usuarios'),
    ('pos_settings', 'pos_settings'),
    ('pos_comandas', 'pos_comandas'),
    ('pos_ventas', 'pos_ventas'),
]


class POSSyncManager:
    def __init__(self, engine_getter):
        self._engine_getter = engine_getter
        self.is_online = False
        self._on_connection_change = None
        self._sync_thread = None
        self._stop_event = threading.Event()
        self._background_sync_enabled = False
        self._on_sync_complete_callbacks = []
        self._on_sync_complete = None

    def _log(self, msg: str):
        print(f"[POS-SYNC] {msg}")

    def _create_remote_engine(self):
        from sqlalchemy import create_engine
        url = get_settings().DATABASE_URL
        if 'pg8000' in url:
            return create_engine(url, connect_args={'timeout': 15})
        return create_engine(url, connect_args={'connect_timeout': 15})

    def check_connection(self) -> bool:
        try:
            engine = self._engine_getter()
            if engine:
                with engine.connect() as conn:
                    conn.execute(text("SELECT 1"))
                if not self.is_online and self._on_connection_change:
                    self._on_connection_change(True)
                self.is_online = True
                return True
        except Exception:
            pass
        if self.is_online and self._on_connection_change:
            self._on_connection_change(False)
        self.is_online = False
        return False

    def set_sync_complete_callback(self, callback):
        self._on_sync_complete = callback

    def add_sync_callback(self, callback):
        if callback not in self._on_sync_complete_callbacks:
            self._on_sync_complete_callbacks.append(callback)

    def remove_sync_callback(self, callback):
        if callback in self._on_sync_complete_callbacks:
            self._on_sync_complete_callbacks.remove(callback)

    def _notify_sync_complete(self):
        for callback in self._on_sync_complete_callbacks:
            try:
                callback()
            except Exception as e:
                self._log(f"Error en callback: {e}")

    def _download_all_from_server(self) -> bool:
        from .local_replica import LocalReplica
        import json

        def serialize_value(val):
            if val is None:
                return None
            if isinstance(val, datetime):
                return val.isoformat()
            if isinstance(val, (int, float, str, bool)):
                return val
            return str(val)

        def dict_to_serializable(row_dict):
            return {k: serialize_value(v) for k, v in row_dict.items()}

        remote_engine = self._create_remote_engine()

        with remote_engine.connect() as conn:
            for migration in [
                "CREATE TABLE IF NOT EXISTS platos_categorias (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL, color TEXT DEFAULT '#FF6F00', activo INTEGER DEFAULT 1, created_at TEXT, updated_at TEXT)",
                "CREATE TABLE IF NOT EXISTS platos (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL, categoria_id INTEGER NOT NULL, precio_venta REAL DEFAULT 0, activo INTEGER DEFAULT 1, created_at TEXT, updated_at TEXT, es_contorno INTEGER DEFAULT 0, lleva_contornos INTEGER DEFAULT 0)",
                "CREATE TABLE IF NOT EXISTS plato_ingredientes (id SERIAL PRIMARY KEY, plato_id INTEGER NOT NULL, producto_id INTEGER NOT NULL, cantidad REAL NOT NULL, unidad TEXT DEFAULT 'unidad')",
                "CREATE TABLE IF NOT EXISTS plato_contornos (id SERIAL PRIMARY KEY, plato_id INTEGER NOT NULL, contorno_id INTEGER NOT NULL, max_seleccionar INTEGER DEFAULT 2)",
                "CREATE TABLE IF NOT EXISTS pos_mesas (id SERIAL PRIMARY KEY, numero TEXT NOT NULL, nombre TEXT, zona TEXT, activo INTEGER DEFAULT 1, creado_en TEXT NOT NULL)",
                "CREATE TABLE IF NOT EXISTS pos_habitaciones (id SERIAL PRIMARY KEY, numero TEXT NOT NULL, piso TEXT, tipo TEXT, activo INTEGER DEFAULT 1, creado_en TEXT NOT NULL)",
                "CREATE TABLE IF NOT EXISTS pos_usuarios (id SERIAL PRIMARY KEY, nombre TEXT NOT NULL, pin_hash TEXT, es_admin INTEGER DEFAULT 0, activo INTEGER DEFAULT 1, creado_en TEXT NOT NULL)",
                "CREATE TABLE IF NOT EXISTS pos_settings (key TEXT PRIMARY KEY, value TEXT)",
                "CREATE TABLE IF NOT EXISTS pos_comandas (id SERIAL PRIMARY KEY, sesion_id INTEGER, mesa_id INTEGER, habitacion_id INTEGER, estado TEXT DEFAULT 'abierta', total REAL DEFAULT 0, items_json TEXT, sync_uuid TEXT, created_at TEXT NOT NULL, updated_at TEXT)",
                "CREATE TABLE IF NOT EXISTS pos_ventas (id SERIAL PRIMARY KEY, comanda_id INTEGER, correlativo INTEGER, total REAL DEFAULT 0, items_json TEXT, mesa_id INTEGER, habitacion_id INTEGER, usuario_id INTEGER, sesion_id INTEGER, estado TEXT DEFAULT 'vigente', venta_anula_id INTEGER, motivo_anulacion TEXT, anulada_por TEXT, anulada_en TEXT, tasa_bs REAL, sync_uuid TEXT, comanda_sync_uuid TEXT, venta_anula_sync_uuid TEXT, created_at TEXT NOT NULL, updated_at TEXT)",
                "ALTER TABLE movimientos ADD COLUMN IF NOT EXISTS venta_sync_uuid TEXT",
                "CREATE INDEX IF NOT EXISTS idx_pos_comandas_sync_uuid ON pos_comandas (sync_uuid)",
                "CREATE INDEX IF NOT EXISTS idx_pos_ventas_sync_uuid ON pos_ventas (sync_uuid)",
            ]:
                try:
                    conn.execute(text(migration))
                    conn.commit()
                except Exception:
                    conn.rollback()

            # Categorias de inventario visibles en POS (no estan en _POS_TABLES,
            # pero el POS las necesita para mostrar productos). Descarga solo las
            # marcadas visible_en_pos=1 y activas; no poda (las demas las gestiona
            # el modulo de inventario si se abre despues).
            try:
                result = conn.execute(text(
                    "SELECT * FROM categorias WHERE activo = TRUE AND visible_en_pos = TRUE"
                ))
                rows = result.fetchall()
                data = [dict_to_serializable(dict(row._mapping)) for row in rows]
                LocalReplica.save_categorias(data)
                self._log(f"{len(data)} categorias (visibles en POS) descargadas")
            except Exception as e:
                self._log(f"Error descargando categorias: {e}")

            for local_table, server_table in _POS_TABLES:
                try:
                    result = conn.execute(text(f"SELECT * FROM {server_table}"))
                    rows = result.fetchall()
                    data = [dict_to_serializable(dict(row._mapping)) for row in rows]

                    remote_ids = [r['id'] for r in data if r.get('id') is not None]

                    if local_table == 'platos_categorias':
                        LocalReplica.save_platos_categorias(data)
                        LocalReplica.delete_orphaned_records('platos_categorias', remote_ids, 'nombre')
                    elif local_table == 'platos':
                        LocalReplica.save_platos(data)
                        LocalReplica.delete_orphaned_records('platos', remote_ids)
                    elif local_table == 'plato_ingredientes':
                        LocalReplica.save_plato_ingredientes(data)
                    elif local_table == 'plato_contornos':
                        LocalReplica.save_plato_contornos_bulk(data)
                    elif local_table == 'pos_mesas':
                        LocalReplica.save_pos_mesas(data)
                        LocalReplica.delete_orphaned_records('pos_mesas', remote_ids)
                    elif local_table == 'pos_habitaciones':
                        LocalReplica.save_pos_habitaciones(data)
                        LocalReplica.delete_orphaned_records('pos_habitaciones', remote_ids)
                    elif local_table == 'pos_usuarios':
                        LocalReplica.save_pos_usuarios(data)
                        LocalReplica.delete_orphaned_records('pos_usuarios', remote_ids)
                    elif local_table == 'pos_settings':
                        pending_keys = set()
                        try:
                            from usr.database.conn import get_local_conn
                            lconn = get_local_conn()
                            rows = lconn.execute(
                                "SELECT data FROM sync_queue WHERE table_name = 'pos_settings' AND status = 'pending'"
                            ).fetchall()
                            lconn.close()
                            for r in rows:
                                try:
                                    pending_keys.add(json.loads(r['data']).get('key'))
                                except Exception:
                                    pass
                        except Exception:
                            pass
                        for row in data:
                            if row.get('key') in pending_keys:
                                continue
                            LocalReplica.set_pos_setting(row['key'], row['value'], sync=False)
                    elif local_table == 'pos_comandas':
                        LocalReplica.save_comandas_sync(data)
                    elif local_table == 'pos_ventas':
                        LocalReplica.save_ventas_sync(data)

                    self._log(f"{len(data)} {local_table} descargados")
                except Exception as e:
                    self._log(f"Error descargando {local_table}: {e}")

            try:
                result = conn.execute(text("SELECT * FROM movimientos ORDER BY id"))
                rows = result.fetchall()
                data = [dict_to_serializable(dict(row._mapping)) for row in rows]
                LocalReplica.save_movimientos(data)
                LocalReplica.relink_ventas_movimientos()
                LocalReplica.recalculate_existencias()
                self._log(f"{len(data)} movimientos descargados")
            except Exception as e:
                self._log(f"Error descargando movimientos: {e}")

        remote_engine.dispose()
        self._log("Descarga POS completada")
        return True

    def _process_sync_queue(self):
        from .sync_queue import get_sync_queue
        queue = get_sync_queue()
        queue.init_queue()

        pending = queue.get_pending()
        pending = [p for p in pending if p.get('table_name') in {t[0] for t in _POS_TABLES}]

        if pending:
            remote_engine = self._create_remote_engine()
            try:
                uploaded = self._upload_to_remote(remote_engine, pending)
                self._log(f"{uploaded} operaciones POS subidas a Supabase")
                try:
                    movs = self._upload_pending_movimientos_venta(remote_engine)
                    self._log(f"{movs} movimientos de venta subidos a Supabase")
                except Exception as e_mov:
                    self._log(f"Error subiendo movimientos de venta: {e_mov}")
            except Exception as e:
                self._log(f"Error subiendo POS: {e}")
            finally:
                remote_engine.dispose()

        queue.set_last_sync(datetime.now().isoformat())

    def _upload_to_remote(self, remote_engine, pending_items) -> int:
        import json
        from .sync_queue import get_sync_queue
        queue = get_sync_queue()
        uploaded = 0

        with remote_engine.connect() as conn:
            for item in pending_items:
                table = None
                try:
                    data = json.loads(item['data'])
                    table = item['table_name']
                    op = item['operation']

                    if table == 'platos_categorias':
                        cid = data.get('id')
                        vals = {
                            'id': cid,
                            'nombre': data.get('nombre', ''),
                            'color': data.get('color', '#FF6F00'),
                            'activo': 1 if data.get('activo', True) else 0,
                            'created_at': data.get('created_at', data.get('updated_at')),
                            'updated_at': data.get('updated_at'),
                        }
                        exists = cid and conn.execute(
                            text("SELECT id FROM platos_categorias WHERE id = :id"), {'id': cid}
                        ).fetchone()
                        if exists:
                            cols = ", ".join([f"{k} = :{k}" for k in ['nombre','color','activo','updated_at']])
                            conn.execute(text(f"UPDATE platos_categorias SET {cols} WHERE id = :id"), vals)
                        else:
                            cols = ", ".join(vals.keys())
                            ph = ", ".join([f":{k}" for k in vals.keys()])
                            conn.execute(text(f"INSERT INTO platos_categorias ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    elif table == 'platos':
                        pid = data.get('id')
                        vals = {
                            'id': pid,
                            'nombre': data.get('nombre', ''),
                            'categoria_id': data.get('categoria_id'),
                            'precio_venta': float(data.get('precio_venta', 0)),
                            'activo': 1 if data.get('activo', True) else 0,
                            'es_contorno': 1 if data.get('es_contorno', False) else 0,
                            'lleva_contornos': 1 if data.get('lleva_contornos', False) else 0,
                            'created_at': data.get('created_at', data.get('updated_at')),
                            'updated_at': data.get('updated_at'),
                        }
                        exists = pid and conn.execute(
                            text("SELECT id FROM platos WHERE id = :id"), {'id': pid}
                        ).fetchone()
                        if exists:
                            cols = ", ".join([f"{k} = :{k}" for k in ['nombre','categoria_id','precio_venta','activo','es_contorno','lleva_contornos','updated_at']])
                            conn.execute(text(f"UPDATE platos SET {cols} WHERE id = :id"), vals)
                        else:
                            cols = ", ".join(vals.keys())
                            ph = ", ".join([f":{k}" for k in vals.keys()])
                            conn.execute(text(f"INSERT INTO platos ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    elif table == 'plato_ingredientes':
                        iid = data.get('id')
                        vals = {
                            'plato_id': data.get('plato_id'),
                            'producto_id': data.get('producto_id'),
                            'cantidad': float(data.get('cantidad', 1)),
                            'unidad': data.get('unidad', 'unidad'),
                        }
                        if iid:
                            cols = ", ".join([f"{k} = :{k}" for k in vals.keys()])
                            conn.execute(text(f"UPDATE plato_ingredientes SET {cols} WHERE id = :id"), vals | {'id': iid})
                        else:
                            cols = ", ".join(vals.keys())
                            ph = ", ".join([f":{k}" for k in vals.keys()])
                            conn.execute(text(f"INSERT INTO plato_ingredientes ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    elif table == 'plato_contornos':
                        pcid = data.get('id')
                        vals = {
                            'plato_id': data.get('plato_id'),
                            'contorno_id': data.get('contorno_id'),
                            'max_seleccionar': data.get('max_seleccionar', 2),
                        }
                        if pcid:
                            cols = ", ".join([f"{k} = :{k}" for k in vals.keys()])
                            conn.execute(text(f"UPDATE plato_contornos SET {cols} WHERE id = :id"), vals | {'id': pcid})
                        else:
                            cols = ", ".join(vals.keys())
                            ph = ", ".join([f":{k}" for k in vals.keys()])
                            conn.execute(text(f"INSERT INTO plato_contornos ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    elif table == 'pos_mesas':
                        mid = data.get('id')
                        vals = {
                            'id': mid,
                            'numero': data.get('numero', ''),
                            'nombre': data.get('nombre'),
                            'zona': data.get('zona'),
                            'activo': 1 if data.get('activo', True) else 0,
                            'creado_en': data.get('creado_en', datetime.now().isoformat()),
                        }
                        exists = mid and conn.execute(
                            text("SELECT id FROM pos_mesas WHERE id = :id"), {'id': mid}
                        ).fetchone()
                        if exists:
                            cols = ", ".join([f"{k} = :{k}" for k in ['numero','nombre','zona','activo']])
                            conn.execute(text(f"UPDATE pos_mesas SET {cols} WHERE id = :id"), vals)
                        else:
                            cols = ", ".join(vals.keys())
                            ph = ", ".join([f":{k}" for k in vals.keys()])
                            conn.execute(text(f"INSERT INTO pos_mesas ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    elif table == 'pos_habitaciones':
                        hid = data.get('id')
                        vals = {
                            'id': hid,
                            'numero': data.get('numero', ''),
                            'piso': data.get('piso'),
                            'tipo': data.get('tipo'),
                            'activo': 1 if data.get('activo', True) else 0,
                            'creado_en': data.get('creado_en', datetime.now().isoformat()),
                        }
                        exists = hid and conn.execute(
                            text("SELECT id FROM pos_habitaciones WHERE id = :id"), {'id': hid}
                        ).fetchone()
                        if exists:
                            cols = ", ".join([f"{k} = :{k}" for k in ['numero','piso','tipo','activo']])
                            conn.execute(text(f"UPDATE pos_habitaciones SET {cols} WHERE id = :id"), vals)
                        else:
                            cols = ", ".join(vals.keys())
                            ph = ", ".join([f":{k}" for k in vals.keys()])
                            conn.execute(text(f"INSERT INTO pos_habitaciones ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    elif table == 'pos_usuarios':
                        uid = data.get('id')
                        vals = {
                            'id': uid,
                            'nombre': data.get('nombre', ''),
                            'pin_hash': data.get('pin_hash'),
                            'es_admin': 1 if data.get('es_admin', False) else 0,
                            'activo': 1 if data.get('activo', True) else 0,
                            'creado_en': data.get('creado_en', datetime.now().isoformat()),
                        }
                        exists = uid and conn.execute(
                            text("SELECT id FROM pos_usuarios WHERE id = :id"), {'id': uid}
                        ).fetchone()
                        if exists:
                            cols = ", ".join([f"{k} = :{k}" for k in ['nombre','pin_hash','es_admin','activo']])
                            conn.execute(text(f"UPDATE pos_usuarios SET {cols} WHERE id = :id"), vals)
                        else:
                            cols = ", ".join(vals.keys())
                            ph = ", ".join([f":{k}" for k in vals.keys()])
                            conn.execute(text(f"INSERT INTO pos_usuarios ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    elif table == 'pos_settings':
                        key = data.get('key')
                        if not key:
                            continue
                        vals = {'key': key, 'value': data.get('value', '')}
                        exists = conn.execute(
                            text("SELECT key FROM pos_settings WHERE key = :k"), {'k': key}
                        ).fetchone()
                        if exists:
                            conn.execute(text("UPDATE pos_settings SET value = :value WHERE key = :key"), vals)
                        else:
                            conn.execute(text("INSERT INTO pos_settings (key, value) VALUES (:key, :value)"), vals)
                        conn.commit()

                    elif table == 'pos_comandas':
                        su = (data.get('sync_uuid') or '').strip()
                        if not su:
                            raise ValueError("pos_comandas sin sync_uuid")
                        if op == 'delete':
                            conn.execute(text("DELETE FROM pos_comandas WHERE sync_uuid = :su"), {'su': su})
                            conn.commit()
                        else:
                            vals = {
                                'sync_uuid': su,
                                'sesion_id': data.get('sesion_id'),
                                'mesa_id': data.get('mesa_id'),
                                'habitacion_id': data.get('habitacion_id'),
                                'estado': data.get('estado', 'abierta'),
                                'total': float(data.get('total', 0) or 0),
                                'items_json': data.get('items_json'),
                                'created_at': data.get('created_at', data.get('updated_at')),
                                'updated_at': data.get('updated_at'),
                            }
                            exists = conn.execute(
                                text("SELECT id FROM pos_comandas WHERE sync_uuid = :su"), {'su': su}
                            ).fetchone()
                            if exists:
                                cols = ", ".join([f"{k} = :{k}" for k in ['sesion_id','mesa_id','habitacion_id','estado','total','items_json','updated_at']])
                                conn.execute(text(f"UPDATE pos_comandas SET {cols} WHERE sync_uuid = :sync_uuid"), vals)
                            else:
                                cols = ", ".join(vals.keys())
                                ph = ", ".join([f":{k}" for k in vals.keys()])
                                conn.execute(text(f"INSERT INTO pos_comandas ({cols}) VALUES ({ph})"), vals)
                            conn.commit()

                    elif table == 'pos_ventas':
                        su = (data.get('sync_uuid') or '').strip()
                        if not su:
                            raise ValueError("pos_ventas sin sync_uuid")
                        if op == 'delete':
                            conn.execute(text("DELETE FROM pos_ventas WHERE sync_uuid = :su"), {'su': su})
                            conn.commit()
                        else:
                            vals = {
                                'sync_uuid': su,
                                'comanda_sync_uuid': (data.get('comanda_sync_uuid') or '').strip() or None,
                                'venta_anula_sync_uuid': (data.get('venta_anula_sync_uuid') or '').strip() or None,
                                'correlativo': data.get('correlativo'),
                                'total': float(data.get('total', 0) or 0),
                                'items_json': data.get('items_json'),
                                'mesa_id': data.get('mesa_id'),
                                'habitacion_id': data.get('habitacion_id'),
                                'usuario_id': data.get('usuario_id'),
                                'sesion_id': data.get('sesion_id'),
                                'estado': data.get('estado', 'vigente'),
                                'motivo_anulacion': data.get('motivo_anulacion'),
                                'anulada_por': data.get('anulada_por'),
                                'anulada_en': data.get('anulada_en'),
                                'tasa_bs': data.get('tasa_bs'),
                                'created_at': data.get('created_at', data.get('updated_at')),
                                'updated_at': data.get('updated_at'),
                            }
                            exists = conn.execute(
                                text("SELECT id FROM pos_ventas WHERE sync_uuid = :su"), {'su': su}
                            ).fetchone()
                            if exists:
                                cols = ", ".join([f"{k} = :{k}" for k in ['comanda_sync_uuid','venta_anula_sync_uuid','correlativo','total','items_json','mesa_id','habitacion_id','usuario_id','sesion_id','estado','motivo_anulacion','anulada_por','anulada_en','tasa_bs','updated_at']])
                                conn.execute(text(f"UPDATE pos_ventas SET {cols} WHERE sync_uuid = :sync_uuid"), vals)
                            else:
                                cols = ", ".join(vals.keys())
                                ph = ", ".join([f":{k}" for k in vals.keys()])
                                conn.execute(text(f"INSERT INTO pos_ventas ({cols}) VALUES ({ph})"), vals)
                            conn.commit()

                    queue.mark_completed(item['id'])
                    uploaded += 1
                    self._log(f"{table} sincronizado")
                except Exception as e:
                    try:
                        conn.rollback()
                    except Exception:
                        pass
                    queue.mark_failed(item['id'], str(e))
                    self._log(f"Error subiendo {table}: {e}")
        return uploaded

    def _upload_pending_movimientos_venta(self, remote_engine) -> int:
        """Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.

        La venta se enlaza por venta_sync_uuid (los ids locales no son validos en otros
        dispositivos). El matching evita duplicados si el sync principal ya los subio.
        """
        from usr.database.conn import get_local_conn
        from .local_replica import LocalReplica

        local = get_local_conn()
        cursor = local.cursor()
        cursor.execute("""
            SELECT * FROM movimientos
            WHERE sincronizado = 0 AND tipo IN ('venta', 'devolucion')
            ORDER BY id
        """)
        rows = [dict(r) for r in cursor.fetchall()]
        if not rows:
            local.close()
            return 0

        uploaded = 0
        with remote_engine.connect() as conn:
            for m in rows:
                try:
                    vsu = (m.get('venta_sync_uuid') or '').strip()
                    existing = None
                    if vsu:
                        existing = conn.execute(text("""
                            SELECT id FROM movimientos
                            WHERE venta_sync_uuid = :vsu AND tipo = :t AND producto_id = :p
                              AND COALESCE(almacen, '') = COALESCE(:a, '')
                            LIMIT 1
                        """), {'vsu': vsu, 't': m.get('tipo'), 'p': m.get('producto_id'), 'a': m.get('almacen')}).fetchone()
                    if not existing:
                        existing = conn.execute(text("""
                            SELECT id FROM movimientos
                            WHERE producto_id = :p AND tipo = :t AND cantidad = :c
                              AND fecha_movimiento = :f AND COALESCE(almacen, '') = COALESCE(:a, '')
                            LIMIT 1
                        """), {
                            'p': m.get('producto_id'), 't': m.get('tipo'), 'c': m.get('cantidad'),
                            'f': m.get('fecha_movimiento'), 'a': m.get('almacen'),
                        }).fetchone()

                    vals = {
                        'producto_id': m.get('producto_id'),
                        'factura_id': None,
                        'requisicion_id': None,
                        'venta_sync_uuid': vsu or None,
                        'tipo': m.get('tipo'),
                        'cantidad': m.get('cantidad'),
                        'cantidad_anterior': m.get('cantidad_anterior', 0),
                        'cantidad_nueva': m.get('cantidad_nueva', 0),
                        'peso_total': m.get('peso_total', 0),
                        'registrado_por': m.get('registrado_por'),
                        'observaciones': m.get('observaciones'),
                        'almacen': m.get('almacen'),
                        'fecha_movimiento': m.get('fecha_movimiento'),
                        'created_at': m.get('created_at'),
                        'device_id': m.get('device_id'),
                    }
                    if existing:
                        cols = ", ".join([f"{k} = :{k}" for k in vals.keys()])
                        conn.execute(text(f"UPDATE movimientos SET {cols} WHERE id = :id"), vals | {'id': existing[0]})
                        conn.commit()
                    else:
                        cols = ", ".join(vals.keys())
                        ph = ", ".join([f":{k}" for k in vals.keys()])
                        conn.execute(text(f"INSERT INTO movimientos ({cols}) VALUES ({ph})"), vals)
                        conn.commit()

                    LocalReplica.mark_movimiento_sincronizado(m['id'])
                    uploaded += 1
                except Exception as e:
                    try:
                        conn.rollback()
                    except Exception:
                        pass
                    self._log(f"Error subiendo movimiento venta {m.get('id')}: {e}")
        local.close()
        return uploaded

    def full_sync(self) -> bool:
        from .local_replica import LocalReplica
        if not self.check_connection():
            self._log("Sin conexion, usando datos locales")
            return False
        self._log("Iniciando sincronizacion POS...")
        try:
            self._process_sync_queue()
            self._download_all_from_server()
            LocalReplica.set_last_sync("pos_full_sync", datetime.now().isoformat())
            self._log("Sincronizacion POS finalizada")
            ok = True
        except Exception as e:
            self._log(f"Error en sincronizacion POS: {e}")
            import traceback
            traceback.print_exc()
            ok = False
        if ok and self._on_sync_complete:
            try:
                self._on_sync_complete()
            except Exception as e:
                self._log(f"Error en callback: {e}")
        self._notify_sync_complete()
        return ok

    def force_sync_now(self) -> bool:
        return self.full_sync()

    def get_connection_status(self) -> dict:
        from .sync_queue import SyncQueue
        pending = SyncQueue.get_pending(limit=100)
        pos_pending = [p for p in pending if p.get('table_name') in {t[0] for t in _POS_TABLES}]
        last = SyncQueue.get_last_sync()
        return {
            "online": self.is_online,
            "pending_count": len(pos_pending),
            "last_sync": last,
            "background_enabled": self._background_sync_enabled,
        }

    def start_background_sync(self, interval_seconds: int = 30):
        if self._sync_thread and self._sync_thread.is_alive():
            return
        self._stop_event.clear()
        self._background_sync_enabled = True
        self._sync_thread = threading.Thread(
            target=self._background_sync_loop,
            args=(interval_seconds,),
            daemon=True,
        )
        self._sync_thread.start()
        self._log(f"Sync POS en segundo plano iniciado (intervalo: {interval_seconds}s)")

    def stop_background_sync(self):
        self._stop_event.set()
        self._background_sync_enabled = False
        if self._sync_thread:
            self._sync_thread.join(timeout=2)
        self._log("Sync POS en segundo plano detenido")

    def _background_sync_loop(self, interval):
        while not self._stop_event.is_set():
            try:
                if self.check_connection():
                    self._process_sync_queue()
                    self._download_all_from_server()
                    self._notify_sync_complete()
            except Exception as e:
                self._log(f"Error en sync loop: {e}")
            self._stop_event.wait(interval)


_pos_sync_manager_instance = None


def init_pos_sync_manager(engine_getter) -> POSSyncManager:
    global _pos_sync_manager_instance
    _pos_sync_manager_instance = POSSyncManager(engine_getter)
    return _pos_sync_manager_instance


def get_pos_sync_manager() -> Optional[POSSyncManager]:
    return _pos_sync_manager_instance
