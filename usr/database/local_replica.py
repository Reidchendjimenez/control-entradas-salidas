"""
Réplica local SQLite para trabajo offline.
Almacena una copia de los datos de Supabase para acceso offline.
"""
import os
print(f"[LOCAL_REPLICA] Cargando módulo local_replica.py desde {os.path.abspath(__file__)}")
from datetime import datetime
from typing import Optional, List, Dict, Any
from usr.database.conn import get_local_conn
from config.config import get_settings

from usr.database.sync_queue import (
    SyncQueue,
)

def init_local_db():
    """Inicializa la base de datos local con todas las tablas.
    Usa los mismos nombres de tabla que SQLAlchemy para compatibilidad."""
    conn = get_local_conn()
    cursor = conn.cursor()
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS categorias (
            id INTEGER PRIMARY KEY,
            nombre TEXT NOT NULL,
            descripcion TEXT,
            imagen TEXT,
            color TEXT DEFAULT '#2196F3',
            activo INTEGER DEFAULT 1,
            visible_en_pos INTEGER DEFAULT 1,
            created_at TEXT,
            updated_at TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS proveedores (
            id INTEGER PRIMARY KEY,
            nombre TEXT NOT NULL UNIQUE,
            rif TEXT,
            telefono TEXT,
            email TEXT,
            direccion TEXT,
            contacto TEXT,
            observaciones TEXT,
            estado TEXT DEFAULT 'Activo',
            created_at TEXT
     )
     """)
    cursor.execute("""
         CREATE TABLE IF NOT EXISTS productos (
             id INTEGER PRIMARY KEY,
             nombre TEXT NOT NULL,
             codigo TEXT UNIQUE,
             descripcion TEXT,
             categoria_id INTEGER,
             es_pesable INTEGER DEFAULT 0,
             requiere_foto_peso INTEGER DEFAULT 0,
             peso_unitario REAL,
             precio_venta REAL DEFAULT 0,
             unidad_medida TEXT DEFAULT 'unidad',
             stock_actual REAL DEFAULT 0,
             stock_minimo REAL DEFAULT 0,
             activo INTEGER DEFAULT 1,
             created_at TEXT,
             updated_at TEXT,
             almacen_predeterminado TEXT DEFAULT 'principal',
             tipo TEXT DEFAULT 'ninguno'
         )
     """)
    
    # Migraciones para columnas agregadas posteriormente
    _migraciones = [
        ("productos", "tipo", "TEXT"),
        ("productos", "precio_venta", "REAL DEFAULT 0"),
        ("categorias", "visible_en_pos", "INTEGER DEFAULT 1"),
    ]
    for tabla, col, tipo in _migraciones:
        try:
            cursor.execute(f"ALTER TABLE {tabla} ADD COLUMN {col} {tipo}")
        except Exception:
            pass
        pass  # Ya existe
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS existencias (
            id INTEGER PRIMARY KEY,
            producto_id INTEGER NOT NULL,
            almacen TEXT NOT NULL,
            cantidad REAL DEFAULT 0,
            unidad TEXT DEFAULT 'unidad'
        )
    """)
    
    # Migración: eliminar duplicados en existencias y crear UNIQUE index
    cursor.execute("""
        DELETE FROM existencias WHERE id NOT IN (
            SELECT MIN(id) FROM existencias GROUP BY producto_id, almacen
        )
    """)
    cursor.execute("""
        CREATE UNIQUE INDEX IF NOT EXISTS idx_existencias_unique 
        ON existencias (producto_id, almacen)
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS movimientos (
            id INTEGER PRIMARY KEY,
            producto_id INTEGER NOT NULL,
            factura_id INTEGER,
            requisicion_id INTEGER,
            tipo TEXT NOT NULL,
            cantidad REAL NOT NULL,
            cantidad_anterior REAL DEFAULT 0,
            cantidad_nueva REAL DEFAULT 0,
            peso_total REAL DEFAULT 0,
            registrado_por TEXT,
            observaciones TEXT,
            almacen TEXT,
            fecha_movimiento TEXT,
            created_at TEXT,
            device_id TEXT,
            sincronizado INTEGER DEFAULT 0
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS facturas (
            id INTEGER PRIMARY KEY,
            numero_factura TEXT NOT NULL UNIQUE,
            proveedor TEXT,
            fecha_factura TEXT NOT NULL,
            fecha_recepcion TEXT,
            total_bruto REAL DEFAULT 0,
            total_impuestos REAL DEFAULT 0,
            total_neto REAL DEFAULT 0,
            estado TEXT DEFAULT 'Pendiente',
            observaciones TEXT,
            validada_por TEXT,
            fecha_validacion TEXT,
            created_at TEXT,
            updated_at TEXT
        )
    """)
    
    # Migración: agregar columna tipo_documento a facturas si no existe
    try:
        cursor.execute("ALTER TABLE facturas ADD COLUMN tipo_documento TEXT DEFAULT 'Factura'")
    except Exception:
        pass  # Ya existe
    
    # Tabla de pagos de facturas
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS factura_pagos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            factura_id INTEGER NOT NULL,
            tipo_pago TEXT NOT NULL,
            monto REAL NOT NULL,
            referencia TEXT,
            tasa_cambio REAL,
            fecha_pago TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (factura_id) REFERENCES facturas(id) ON DELETE CASCADE
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS requisiciones (
            id INTEGER PRIMARY KEY,
            numero TEXT NOT NULL UNIQUE,
            numero_secuencial INTEGER NOT NULL,
            origen TEXT NOT NULL,
            destino TEXT NOT NULL,
            estado TEXT DEFAULT 'pendiente',
            observaciones TEXT,
            creada_por TEXT,
            procesada_por TEXT,
            fecha_procesamiento TEXT,
            fecha_creacion TEXT,
            actualizada TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS requisicion_detalles (
            id INTEGER PRIMARY KEY,
            requisicion_id INTEGER NOT NULL,
            producto_id INTEGER,
            ingrediente TEXT NOT NULL,
            cantidad REAL NOT NULL,
            unidad TEXT DEFAULT 'unidad',
            cantidad_surtida REAL DEFAULT 0,
            verificado INTEGER DEFAULT 0
        )
    """)
    
    # Migración: agregar columna verificado a requisicion_detalles si no existe
    try:
        cursor.execute("ALTER TABLE requisicion_detalles ADD COLUMN verificado INTEGER DEFAULT 0")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE movimientos ADD COLUMN requisicion_id INTEGER")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE movimientos ADD COLUMN venta_id INTEGER")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE pos_ventas ADD COLUMN tasa_bs REAL")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE pos_comandas ADD COLUMN sync_uuid TEXT")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE pos_ventas ADD COLUMN sync_uuid TEXT")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE pos_ventas ADD COLUMN comanda_sync_uuid TEXT")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE pos_ventas ADD COLUMN venta_anula_sync_uuid TEXT")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE movimientos ADD COLUMN venta_sync_uuid TEXT")
    except Exception:
        pass  # Ya existe

    try:
        cursor.execute("ALTER TABLE movimientos_archivo ADD COLUMN requisicion_id INTEGER")
    except Exception:
        pass  # Ya existe

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS sync_metadata (
            key TEXT PRIMARY KEY,
            value TEXT,
            updated_at TEXT
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_sync_tombstones (
            uuid    TEXT PRIMARY KEY,
            tabla   TEXT,
            created_at TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS dispositivo_usuario (
            id          INTEGER PRIMARY KEY,
            nombre      TEXT    NOT NULL,
            pin_hash    TEXT,
            configurado_en TEXT NOT NULL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_usuarios (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre      TEXT    NOT NULL UNIQUE,
            pin_hash    TEXT,
            es_admin    INTEGER DEFAULT 0,
            activo      INTEGER DEFAULT 1,
            creado_en   TEXT NOT NULL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_mesas (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            numero      TEXT    NOT NULL UNIQUE,
            nombre      TEXT,
            zona        TEXT,
            activo      INTEGER DEFAULT 1,
            creado_en   TEXT NOT NULL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_habitaciones (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            numero      TEXT    NOT NULL UNIQUE,
            piso        TEXT,
            tipo        TEXT,
            activo      INTEGER DEFAULT 1,
            creado_en   TEXT NOT NULL
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_sesiones (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario_id  INTEGER NOT NULL,
            abierta_en  TEXT NOT NULL,
            cerrada_en  TEXT,
            FOREIGN KEY (usuario_id) REFERENCES pos_usuarios(id)
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_comandas (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            sesion_id   INTEGER NOT NULL,
            mesa_id     INTEGER,
            habitacion_id INTEGER,
            estado      TEXT DEFAULT 'abierta',
            total       REAL DEFAULT 0,
            items_json  TEXT,
            sync_uuid   TEXT,
            created_at  TEXT NOT NULL,
            updated_at  TEXT,
            FOREIGN KEY (sesion_id) REFERENCES pos_sesiones(id)
        )
     """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_settings (
            key         TEXT    NOT NULL,
            value       TEXT,
            PRIMARY KEY (key)
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS pos_ventas (
            id              INTEGER PRIMARY KEY AUTOINCREMENT,
            comanda_id      INTEGER NOT NULL,
            correlativo     INTEGER,
            total           REAL DEFAULT 0,
            items_json      TEXT,
            mesa_id         INTEGER,
            habitacion_id   INTEGER,
            usuario_id      INTEGER,
            sesion_id       INTEGER,
            estado          TEXT DEFAULT 'vigente',
            venta_anula_id  INTEGER,
            motivo_anulacion TEXT,
            anulada_por     TEXT,
            anulada_en      TEXT,
            tasa_bs         REAL,
            sync_uuid       TEXT,
            comanda_sync_uuid TEXT,
            venta_anula_sync_uuid TEXT,
            created_at      TEXT NOT NULL,
            updated_at      TEXT
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS compras_lista (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            producto_id INTEGER NOT NULL,
            created_at TEXT
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS movimientos_archivo (
            id INTEGER PRIMARY KEY,
            producto_id INTEGER NOT NULL,
            factura_id INTEGER,
            requisicion_id INTEGER,
            tipo TEXT NOT NULL,
            cantidad REAL NOT NULL,
            cantidad_anterior REAL DEFAULT 0,
            cantidad_nueva REAL DEFAULT 0,
            peso_total REAL DEFAULT 0,
            registrado_por TEXT,
            observaciones TEXT,
            almacen TEXT,
            fecha_movimiento TEXT,
            created_at TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS whatsapp_queue (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tipo TEXT NOT NULL,
            mensaje TEXT,
            imagen_base64 TEXT,
            imagen_path TEXT,
            estado TEXT DEFAULT 'pending',
            intentos INTEGER DEFAULT 0,
            max_intentos INTEGER DEFAULT 10,
            ultimo_error TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS recetas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            tipo TEXT NOT NULL,
            producto_base_id INTEGER,
            producto_final_id INTEGER,
            cantidad_producida REAL DEFAULT 1,
            activo INTEGER DEFAULT 1,
            created_at TEXT,
            updated_at TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS receta_componentes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            receta_id INTEGER NOT NULL,
            producto_id INTEGER NOT NULL,
            cantidad REAL NOT NULL,
            unidad TEXT DEFAULT 'unidad',
            tipo_componente TEXT NOT NULL,
            FOREIGN KEY (receta_id) REFERENCES recetas(id),
            FOREIGN KEY (producto_id) REFERENCES productos(id)
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS periodos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            periodo TEXT NOT NULL UNIQUE,
            fecha_apertura TEXT NOT NULL,
            registrado_por TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS stock_checkpoint (
            producto_id INTEGER NOT NULL,
            almacen TEXT NOT NULL,
            cantidad REAL DEFAULT 0,
            PRIMARY KEY (producto_id, almacen)
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS platos_categorias (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            color TEXT DEFAULT '#FF6F00',
            activo INTEGER DEFAULT 1,
            created_at TEXT,
            updated_at TEXT
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS platos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            categoria_id INTEGER NOT NULL,
            precio_venta REAL DEFAULT 0,
            activo INTEGER DEFAULT 1,
            created_at TEXT,
            updated_at TEXT,
            FOREIGN KEY (categoria_id) REFERENCES platos_categorias(id)
        )
    """)
    
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS plato_ingredientes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plato_id INTEGER NOT NULL,
            producto_id INTEGER NOT NULL,
            cantidad REAL NOT NULL,
            unidad TEXT DEFAULT 'unidad',
            FOREIGN KEY (plato_id) REFERENCES platos(id),
            FOREIGN KEY (producto_id) REFERENCES productos(id)
        )
    """)

    try:
        cursor.execute("ALTER TABLE platos ADD COLUMN es_contorno INTEGER DEFAULT 0")
    except Exception:
        pass

    try:
        cursor.execute("ALTER TABLE platos ADD COLUMN lleva_contornos INTEGER DEFAULT 0")
    except Exception:
        pass

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS plato_contornos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plato_id INTEGER NOT NULL,
            contorno_id INTEGER NOT NULL,
            max_seleccionar INTEGER DEFAULT 2,
            FOREIGN KEY (plato_id) REFERENCES platos(id),
            FOREIGN KEY (contorno_id) REFERENCES platos(id)
        )
    """)
    
    # Índices locales
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_local_tipo_fecha ON movimientos (tipo, fecha_movimiento DESC)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_local_producto ON movimientos (producto_id, fecha_movimiento DESC)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_local_factura ON movimientos (factura_id)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_local_venta ON movimientos (venta_id)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_local_sync ON movimientos (sincronizado)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_comanda_sync_uuid ON pos_comandas (sync_uuid)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_venta_sync_uuid ON pos_ventas (sync_uuid)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_archivo_tipo_fecha ON movimientos_archivo (tipo, fecha_movimiento DESC)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_archivo_producto ON movimientos_archivo (producto_id, fecha_movimiento DESC)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_mov_archivo_factura ON movimientos_archivo (factura_id)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_compras_lista_producto ON compras_lista (producto_id)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_periodos_periodo ON periodos (periodo DESC)")

    conn.commit()
    conn.close()

def _migrate_old_tables(conn):
    """Migra datos de tablas old (local_*) a tablas nuevas si existen datos en old."""
    cursor = conn.cursor()
    
    tables_map = [
        ('local_categorias', 'categorias'),
        ('local_productos', 'productos'),
        ('local_existencias', 'existencias'),
        ('local_movimientos', 'movimientos'),
        ('local_facturas', 'facturas'),
        ('local_requisiciones', 'requisiciones'),
    ]
    
    for old_table, new_table in tables_map:
        try:
            cursor.execute(f"SELECT COUNT(*) FROM {old_table}")
            old_count = cursor.fetchone()[0]
            cursor.execute(f"SELECT COUNT(*) FROM {new_table}")
            new_count = cursor.fetchone()[0]
            
            if old_count > 0 and new_count == 0:
                cursor.execute(f"INSERT OR IGNORE INTO {new_table} SELECT * FROM {old_table}")
                print(f"[MIGRATE] {old_table} -> {new_table}: {cursor.rowcount} registros")
        except Exception as e:
            pass
    
    _run_pos_migrations(cursor)
    conn.commit()

def _run_pos_migrations(cursor):
    """Migraciones automáticas para tablas POS."""
    import re
    migrations = [
        ("pos_usuarios", [("es_admin", "INTEGER DEFAULT 0")]),
    ]
    for table, columns in migrations:
        cursor.execute(f"PRAGMA table_info({table})")
        existing = {row[1] for row in cursor.fetchall()}
        for col_name, col_type in columns:
            if col_name not in existing:
                try:
                    cursor.execute(f"ALTER TABLE {table} ADD COLUMN {col_name} {col_type}")
                    print(f"[MIGRATE] Columna {col_name} agregada a {table}")
                except Exception as e:
                    print(f"[MIGRATE] Error agregando {col_name} a {table}: {e}")

class LocalReplica:
    """Clase para manejar la réplica local de datos."""
    
    @staticmethod
    def create_tables():
        """Crea todas las tablas locales."""
        init_local_db()
    
    # ==================== CATEGORÍAS ====================
    
    @staticmethod
    def clear_categorias() -> None:
        """Elimina todas las categorías de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM categorias")
        conn.commit()
        conn.close()
    
    @staticmethod
    def save_categorias(categorias: List[Dict]) -> None:
        """Guarda categorías en la base de datos local (upsert, no borra)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        for cat in categorias:
            cursor.execute("""
                INSERT OR REPLACE INTO categorias 
                (id, nombre, descripcion, imagen, color, activo, visible_en_pos, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                cat.get('id'), cat.get('nombre'), cat.get('descripcion'),
                cat.get('imagen'), cat.get('color', '#2196F3'),
                1 if cat.get('activo', True) else 0,
                1 if cat.get('visible_en_pos', True) else 0,
                cat.get('created_at'), cat.get('updated_at')
            ))
        
        conn.commit()
        conn.close()
    
    @staticmethod
    def get_categorias() -> List[Dict]:
        """Obtiene todas las categorías de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute("SELECT * FROM categorias WHERE activo = 1 ORDER BY nombre")
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]

    @staticmethod
    def get_categorias_pos() -> List[Dict]:
        """Obtiene categorías visibles en el POS."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM categorias WHERE activo = 1 AND visible_en_pos = 1 ORDER BY nombre")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_categoria(categoria_id: int) -> Optional[Dict]:
        """Obtiene una categoría por ID."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM categorias WHERE id = ?", (categoria_id,))
        row = cursor.fetchone()
        conn.close()
        return dict(row) if row else None
    
    # ==================== PROVEEDORES ====================
    
    @staticmethod
    def save_proveedores(proveedores: List[Dict]) -> None:
        """Guarda proveedores en la base de datos local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        for prov in proveedores:
            cursor.execute("""
                INSERT OR REPLACE INTO proveedores 
                (id, nombre, rif, telefono, email, direccion, contacto, observaciones, estado, created_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                prov.get('id'), prov.get('nombre'), prov.get('rif'),
                prov.get('telefono'), prov.get('email'), prov.get('direccion'),
                prov.get('contacto'), prov.get('observaciones'),
                prov.get('estado', 'Activo'), prov.get('created_at')
            ))
        
        conn.commit()
        conn.close()
    
    @staticmethod
    def get_proveedores(estado: str = None) -> List[Dict]:
        """Obtiene todos los proveedores de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        if estado:
            cursor.execute("SELECT * FROM proveedores WHERE estado = ? ORDER BY nombre", (estado,))
        else:
            cursor.execute("SELECT * FROM proveedores ORDER BY nombre")
        
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]
    
    @staticmethod
    def get_proveedor_by_nombre(nombre: str) -> Dict | None:
        """Obtiene un proveedor por su nombre."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute("SELECT * FROM proveedores WHERE nombre = ?", (nombre,))
        row = cursor.fetchone()
        conn.close()
        
        return dict(row) if row else None
    
    @staticmethod
    def migrate_proveedores_from_facturas() -> int:
        """Migra proveedores únicos de facturas a la tabla de proveedores."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute("SELECT DISTINCT proveedor FROM facturas WHERE proveedor IS NOT NULL AND proveedor != 'Varios'")
        rows = cursor.fetchall()
        
        count = 0
        for row in rows:
            nombre = row[0]
            try:
                cursor.execute("INSERT OR IGNORE INTO proveedores (nombre, estado) VALUES (?, 'Activo')", (nombre,))
                count += 1
            except:
                pass
        
        conn.commit()
        conn.close()
        return count
    
    # ==================== PRODUCTOS ====================
    
    @staticmethod
    def clear_productos() -> None:
        """Elimina todos los productos de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM productos")
        conn.commit()
        conn.close()
    
    @staticmethod
    def save_productos(productos: List[Dict]) -> None:
        """Guarda productos en la base de datos local (upsert, no borra)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        for prod in productos:
            cursor.execute("""
                INSERT OR REPLACE INTO productos 
                 (id, nombre, codigo, descripcion, categoria_id, es_pesable, 
                  requiere_foto_peso, peso_unitario, precio_venta, unidad_medida, stock_actual, 
                  stock_minimo, activo, created_at, updated_at, almacen_predeterminado, tipo)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                prod.get('id'), prod.get('nombre'), prod.get('codigo'),
                prod.get('descripcion'), prod.get('categoria_id'),
                1 if prod.get('es_pesable') else 0,
                1 if prod.get('requiere_foto_peso') else 0,
                prod.get('peso_unitario'), prod.get('precio_venta', 0),
                prod.get('unidad_medida', 'unidad'),
                prod.get('stock_actual', 0), prod.get('stock_minimo', 0),
                1 if prod.get('activo', True) else 0,
                prod.get('created_at'), prod.get('updated_at'),
                prod.get('almacen_predeterminado', 'principal'),
                prod.get('tipo', 'ninguno')
            ))
        
        conn.commit()
        conn.close()
    
    @staticmethod
    def get_productos(categoria_id: int = None) -> List[Dict]:
        """Obtiene productos de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        if categoria_id:
            cursor.execute(
                "SELECT * FROM productos WHERE activo = 1 AND categoria_id = ? ORDER BY nombre",
                (categoria_id,)
            )
        else:
            cursor.execute("SELECT * FROM productos WHERE activo = 1 ORDER BY nombre")
        
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]
    
    @staticmethod
    def get_productos_pos(categoria_id: int = None) -> List[Dict]:
        """Obtiene productos del POS: activos y marcados para la venta."""
        conn = get_local_conn()
        cursor = conn.cursor()
        if categoria_id:
            cursor.execute(
                "SELECT * FROM productos WHERE activo = 1 AND tipo = 'Productos para la venta' AND categoria_id = ? ORDER BY nombre",
                (categoria_id,)
            )
        else:
            cursor.execute("SELECT * FROM productos WHERE activo = 1 AND tipo = 'Productos para la venta' ORDER BY nombre")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_productos_insumo(categoria_id: int = None) -> List[Dict]:
        """Obtiene productos aptos como ingredientes: uso interno o insumos."""
        conn = get_local_conn()
        cursor = conn.cursor()
        if categoria_id:
            cursor.execute(
                "SELECT * FROM productos WHERE activo = 1 AND (tipo = 'Productos para uso interno' OR tipo = 'Insumos') AND categoria_id = ? ORDER BY nombre",
                (categoria_id,)
            )
        else:
            cursor.execute("SELECT * FROM productos WHERE activo = 1 AND (tipo = 'Productos para uso interno' OR tipo = 'Insumos') ORDER BY nombre")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_producto_by_id(producto_id: int) -> Optional[Dict]:
        """Obtiene un producto por ID."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute("SELECT * FROM productos WHERE id = ?", (producto_id,))
        row = cursor.fetchone()
        conn.close()
        
        return dict(row) if row else None
    
    # ==================== EXISTENCIAS ====================
    
    @staticmethod
    def dedupe_existencias_producto(producto_id: int) -> None:
        """Elimina duplicados de existencias para un producto específico.
        Conserva el registro con el id más alto (ajuste más reciente)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            DELETE FROM existencias
            WHERE producto_id = ? AND id NOT IN (
                SELECT MAX(id) FROM existencias
                WHERE producto_id = ?
                GROUP BY almacen
            )
        """, (producto_id, producto_id))
        conn.commit()
        conn.close()

    @staticmethod
    def save_existencias(existencias: List[Dict]) -> None:
        """Guarda existencias en la base de datos local."""
        if not existencias:
            return
            
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute("DELETE FROM existencias")
        
        for ext in existencias:
            almacen = ext.get('almacen')
            if not almacen:
                continue
                
            cursor.execute("""
                INSERT OR REPLACE INTO existencias 
                (id, producto_id, almacen, cantidad, unidad)
                VALUES (?, ?, ?, ?, ?)
            """, (
                ext.get('id'), ext.get('producto_id'), almacen,
                ext.get('cantidad', 0), ext.get('unidad', 'unidad')
            ))
        
        conn.commit()
        conn.close()
    
    @staticmethod
    def get_existencias(producto_id: int = None) -> List[Dict]:
        """Obtiene existencias de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        if producto_id:
            cursor.execute(
                "SELECT * FROM existencias WHERE producto_id = ?",
                (producto_id,)
            )
        else:
            cursor.execute("SELECT * FROM existencias")
        
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]
    
    @staticmethod
    def get_existencias_by_producto_almacen(producto_id: int, almacen: str) -> Optional[Dict]:
        """Obtiene existencia por producto y almacén."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute(
            "SELECT * FROM existencias WHERE producto_id = ? AND almacen = ?",
            (producto_id, almacen)
        )
        row = cursor.fetchone()
        conn.close()
        
        return dict(row) if row else None
    
    @staticmethod
    def update_existencia(producto_id: int, almacen: str, cantidad: float, unidad: str = None) -> None:
        """Actualiza la existencia existente o la crea si no existe (sin duplicar)."""
        conn = get_local_conn()
        cursor = conn.cursor()

        almacen = (almacen or "principal").strip()

        if unidad is None:
            cursor.execute("SELECT unidad FROM existencias WHERE producto_id = ? AND almacen = ?",
                         (producto_id, almacen))
            result = cursor.fetchone()
            unidad = result['unidad'] if result and result['unidad'] else 'unidad'
        
        cursor.execute("""
            UPDATE existencias SET cantidad = ?, unidad = ? 
            WHERE producto_id = ? AND almacen = ?
        """, (cantidad, unidad, producto_id, almacen))
        
        if cursor.rowcount == 0:
            cursor.execute("""
                INSERT INTO existencias (producto_id, almacen, cantidad, unidad)
                VALUES (?, ?, ?, ?)
            """, (producto_id, almacen, cantidad, unidad))
        
        conn.commit()
        conn.close()
    
    # ==================== MOVIMIENTOS ====================
    
    @staticmethod
    def save_movimiento(movimiento: Dict, skip_sync: bool = False) -> int:
        """Guarda un movimiento en la BD local."""
        from .sync_queue import get_sync_queue
        from .sync import get_sync_manager
        from config.config import get_settings
        
        conn = get_local_conn()
        cursor = conn.cursor()
        
        # Verificar duplicado antes de guardar
        producto_id = movimiento.get('producto_id')
        tipo = movimiento.get('tipo')
        cantidad = movimiento.get('cantidad')
        fecha = movimiento.get('fecha_movimiento')
        
        cursor.execute("""
            SELECT id FROM movimientos 
            WHERE producto_id = ? AND tipo = ? AND cantidad = ? AND almacen = ?
            AND fecha_movimiento >= datetime(?, '-5 seconds')
        """, (producto_id, tipo, cantidad, movimiento.get('almacen'), fecha))
        
        existing = cursor.fetchone()
        if existing:
            conn.close()
            print(f"[SYNC] Movimiento duplicado ignorado: {existing[0]}")
            return existing[0]
        
        settings = get_settings()
        device_id = settings.DEVICE_IDENTIFIER
        
        cursor.execute("""
            INSERT INTO movimientos 
            (producto_id, factura_id, requisicion_id, tipo, cantidad, cantidad_anterior, cantidad_nueva,
             peso_total, registrado_por, observaciones,
             almacen, fecha_movimiento, created_at, device_id, sincronizado)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            movimiento.get('producto_id'), movimiento.get('factura_id'),
            movimiento.get('requisicion_id'),
            movimiento.get('tipo'), movimiento.get('cantidad'),
            movimiento.get('cantidad_anterior', 0), movimiento.get('cantidad_nueva', 0),
            movimiento.get('peso_total', 0), movimiento.get('registrado_por'),
            movimiento.get('observaciones'), movimiento.get('almacen'),
            movimiento.get('fecha_movimiento'), datetime.now().isoformat(),
            device_id, 0
        ))
        
        last_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        movimiento['id'] = last_id
        return last_id
    
    @staticmethod
    def get_movimientos(producto_id: int = None, limit: int = 100) -> List[Dict]:
        """Obtiene movimientos de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        if producto_id:
            cursor.execute(
                "SELECT * FROM movimientos WHERE producto_id = ? ORDER BY fecha_movimiento DESC LIMIT ?",
                (producto_id, limit)
            )
        else:
            cursor.execute(
                "SELECT * FROM movimientos ORDER BY fecha_movimiento DESC LIMIT ?",
                (limit,)
            )
        
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]
    
    @staticmethod
    def get_movimientos_pendientes() -> List[Dict]:
        """Obtiene movimientos que no han sido sincronizados."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute(
            "SELECT * FROM movimientos WHERE sincronizado = 0 ORDER BY created_at"
        )
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]
    
    @staticmethod
    def mark_movimiento_sincronizado(movimiento_id: int) -> None:
        """Marca un movimiento como sincronizado."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute(
            "UPDATE movimientos SET sincronizado = 1 WHERE id = ?",
            (movimiento_id,)
        )
        
        conn.commit()
        conn.close()
    
    @staticmethod
    def clear_movimientos() -> None:
        """Limpia todos los movimientos."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM movimientos")
        conn.commit()
        conn.close()
    
    @staticmethod
    def save_movimientos(movimientos: List[Dict]) -> None:
        """Guarda múltiples movimientos (para sync desde servidor) con deduplicación."""
        if not movimientos:
            return
            
        conn = get_local_conn()
        cursor = conn.cursor()
        
        valid_keys = ['id', 'producto_id', 'factura_id', 'requisicion_id', 'venta_id', 'venta_sync_uuid', 'tipo', 'cantidad',
                      'cantidad_anterior', 'cantidad_nueva', 'peso_total',
                      'registrado_por', 'observaciones', 'almacen', 'fecha_movimiento',
                      'created_at', 'device_id']
        
        inserted_count = 0
        updated_count = 0
        
        for movimientos_chunk in [movimientos[i:i+100] for i in range(0, len(movimientos), 100)]:
            for mov in movimientos_chunk:
                mov_id = mov.get('id')
                producto_id = mov.get('producto_id')
                tipo = mov.get('tipo')
                cantidad = mov.get('cantidad')

                if producto_id is None or tipo is None:
                    continue
                if cantidad is None:
                    continue

                vsu = (mov.get('venta_sync_uuid') or '').strip()
                if vsu:
                    cursor.execute(
                        "SELECT uuid FROM pos_sync_tombstones WHERE uuid = ? AND tabla = 'movimientos'",
                        (vsu,))
                    if cursor.fetchone():
                        continue
                
                # Normalizar fecha para comparación (quitar timezone)
                fecha_raw = mov.get('fecha_movimiento')
                fecha_norm = None
                if fecha_raw and isinstance(fecha_raw, str):
                    fecha_norm = fecha_raw.replace('+00:00', '+00').replace('+00', '').replace('T', ' ')
                
                # Deduplicar por ID o por campos lógicos (sin fecha exacta)
                cursor.execute("""
                    SELECT id FROM movimientos 
                    WHERE id = ?
                """, (mov_id,))
                
                if cursor.fetchone():
                    updated_count += 1
                    continue

                if vsu:
                    cursor.execute("""
                        SELECT id FROM movimientos
                        WHERE venta_sync_uuid = ? AND tipo = ? AND producto_id = ?
                          AND COALESCE(almacen, '') = COALESCE(?, '')
                        LIMIT 1
                    """, (vsu, tipo, producto_id, mov.get('almacen')))
                    if cursor.fetchone():
                        updated_count += 1
                        continue
                
                values = [mov.get(k) for k in valid_keys]
                values.append(1)
                
                placeholders = ','.join(['?' for _ in valid_keys])
                placeholders += ',?'
                
                columns = ','.join(valid_keys) + ',sincronizado'
                
                cursor.execute(f"""
                    INSERT INTO movimientos ({columns})
                    VALUES ({placeholders})
                """, values)
                inserted_count += 1
        
        conn.commit()
        conn.close()
        
        print(f"[SYNC] Movimientos guardados: {inserted_count} nuevos, {updated_count} saltados")
    
    # ==================== FACTURAS ====================
    
    @staticmethod
    def save_facturas(facturas: List[Dict]) -> None:
        """Guarda facturas en la base de datos local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        for fac in facturas:
            cursor.execute("""
                INSERT OR REPLACE INTO facturas 
                (id, numero_factura, proveedor, fecha_factura, fecha_recepcion,
                 total_bruto, total_impuestos, total_neto, estado, observaciones,
                 validada_por, fecha_validacion, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                fac.get('id'), fac.get('numero_factura'), fac.get('proveedor'),
                fac.get('fecha_factura'), fac.get('fecha_recepcion'),
                fac.get('total_bruto', 0), fac.get('total_impuestos', 0),
                fac.get('total_neto', 0), fac.get('estado', 'Pendiente'),
                fac.get('observaciones'), fac.get('validada_por'),
                fac.get('fecha_validacion'), fac.get('created_at'),
                fac.get('updated_at')
            ))
        
        conn.commit()
        conn.close()
    
    @staticmethod
    def save_factura_pagos(pagos: List[Dict]) -> None:
        """Guarda pagos de facturas en la base de datos local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        for pago in pagos:
            cursor.execute("""
                INSERT OR REPLACE INTO factura_pagos 
                (id, factura_id, tipo_pago, monto, referencia, tasa_cambio, fecha_pago)
                VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (
                pago.get('id'), pago.get('factura_id'), pago.get('tipo_pago'),
                pago.get('monto', 0), pago.get('referencia'), pago.get('tasa_cambio'),
                pago.get('fecha_pago')
            ))
        
        conn.commit()
        conn.close()
    
    @staticmethod
    def get_facturas(estado: str = None) -> List[Dict]:
        """Obtiene facturas de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        if estado:
            cursor.execute(
                "SELECT * FROM facturas WHERE estado = ? ORDER BY fecha_factura DESC",
                (estado,)
            )
        else:
            cursor.execute("SELECT * FROM facturas ORDER BY fecha_factura DESC")
        
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]

    @staticmethod
    def get_next_entrada_correlativo() -> str:
        max_num = 0
        try:
            conn = get_local_conn()
            cursor = conn.cursor()
            cursor.execute("""
                SELECT numero_factura FROM facturas
                WHERE numero_factura LIKE 'EV-%'
                ORDER BY numero_factura DESC LIMIT 1
            """)
            row = cursor.fetchone()
            conn.close()
            if row:
                num_part = row[0].replace('EV-', '').strip()
                try:
                    max_num = int(num_part)
                except ValueError:
                    pass
        except Exception as ex:
            print(f"[WARN] Error leyendo correlativo local: {ex}")

        try:
            from usr.database.base import get_db_adaptive
            db = next(get_db_adaptive())
            try:
                from sqlalchemy import text
                rows = db.execute(text("""
                    SELECT numero_factura FROM facturas
                    WHERE numero_factura LIKE 'EV-%'
                    ORDER BY numero_factura DESC LIMIT 5
                """)).fetchall()
                for row in rows:
                    num_part = row[0].replace('EV-', '').strip()
                    try:
                        remote_num = int(num_part)
                        if remote_num > max_num:
                            max_num = remote_num
                    except ValueError:
                        pass
            finally:
                db.close()
        except Exception as ex:
            print(f"[WARN] Error leyendo correlativo remoto: {ex}")

        return f"EV-{max_num + 1:04d}"

    # ==================== REQUISICIONES ====================
    
    @staticmethod
    def save_requisiciones(requisiciones: List[Dict]) -> None:
        if not requisiciones:
            print("[SYNC-DEBUG] save_requisiciones: lista vacía, NO se tocó la tabla")
            return
            
        conn = get_local_conn()
        cursor = conn.cursor()
        
        for req in requisiciones:
            numero_sec = req.get('numero_secuencial')
            if numero_sec is None:
                numero_sec = 0
            
            cursor.execute("""
                INSERT OR REPLACE INTO requisiciones 
                (id, numero, numero_secuencial, origen, destino, estado,
                 observaciones, creada_por, procesada_por, fecha_procesamiento,
                 fecha_creacion, actualizada)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                req.get('id'), req.get('numero'), numero_sec,
                req.get('origen'), req.get('destino'), req.get('estado', 'pendiente'),
                req.get('observaciones'), req.get('creada_por'), req.get('procesada_por'),
                req.get('fecha_procesamiento'), req.get('fecha_creacion'),
                req.get('actualizada')
            ))
        
        conn.commit()
        conn.close()

    @staticmethod
    def save_requisicion_detalles(detalles: List[Dict]) -> None:
        """Guarda los detalles de las requisiciones (upsert).
        Incluye verificado para propagar cambios entre dispositivos."""
        if not detalles:
            return
        conn = get_local_conn()
        cursor = conn.cursor()
        req_ids = set(d.get('requisicion_id') for d in detalles if d.get('requisicion_id') is not None)
        if req_ids:
            placeholders = ','.join('?' * len(req_ids))
            cursor.execute(f"DELETE FROM requisicion_detalles WHERE requisicion_id IN ({placeholders})", list(req_ids))
        cursor.executemany("""
            INSERT INTO requisicion_detalles 
            (id, requisicion_id, producto_id, ingrediente, cantidad, unidad, cantidad_surtida, verificado)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON CONFLICT(id) DO UPDATE SET
                requisicion_id = excluded.requisicion_id,
                producto_id = excluded.producto_id,
                ingrediente = excluded.ingrediente,
                cantidad = excluded.cantidad,
                unidad = excluded.unidad,
                cantidad_surtida = excluded.cantidad_surtida,
                verificado = excluded.verificado
        """, [(
            d.get('id'), d.get('requisicion_id'), d.get('producto_id'),
            d.get('ingrediente'), d.get('cantidad'), d.get('unidad', 'unidad'),
            d.get('cantidad_surtida', 0), d.get('verificado', False)
        ) for d in detalles])
        conn.commit()
        conn.close()
    
    @staticmethod
    def remap_requisicion_id(local_id: int, remote_id: int) -> None:
        """Tras subir una requisición local, actualiza su id local al id remoto
        para que la descarga y la poda no la dupliquen ni la borren.
        Es seguro si se llama con un id local ya obsoleto (producto de una
        re-edición): en ese caso no hace nada."""
        if local_id == remote_id:
            return
        conn = get_local_conn()
        cursor = conn.cursor()
        # ¿Existe aún el registro local con el id local? (puede ya tener el remoto)
        existe = cursor.execute(
            "SELECT 1 FROM requisiciones WHERE id = ?", (local_id,)
        ).fetchone()
        if not existe:
            conn.close()
            return
        # Eliminar posible registro local obsoleto con el id remoto
        cursor.execute("DELETE FROM requisiciones WHERE id = ?", (remote_id,))
        cursor.execute(
            "UPDATE requisicion_detalles SET requisicion_id = ? WHERE requisicion_id = ?",
            (remote_id, local_id)
        )
        cursor.execute(
            "UPDATE requisiciones SET id = ? WHERE id = ?",
            (remote_id, local_id)
        )
        conn.commit()
        conn.close()
    
    @staticmethod
    def get_requisiciones() -> List[Dict]:
        """Obtiene requisiciones de la BD local."""
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute("SELECT * FROM requisiciones ORDER BY fecha_creacion DESC")
        rows = cursor.fetchall()
        conn.close()
        
        return [dict(row) for row in rows]
    
    # ==================== MÉTODOS DE CÁLCULO ====================
    
    @staticmethod
    def recalculate_existencias() -> None:
        """Recalcula las existencias basándose en todos los movimientos.
        
        Si hay checkpoints guardados (archivo previo), usa esos como base
        y solo recorre los movimientos activos (últimos 3 meses).
        Si no, recorre movimientos + movimientos_archivo (descarga inicial).
        """
        conn = get_local_conn()
        cursor = conn.cursor()
        
        cursor.execute("DELETE FROM existencias")
        
        # Cargar unidad_medida de todos los productos en un solo query
        cursor.execute("SELECT id, unidad_medida FROM productos")
        unidad_map = {row['id']: row['unidad_medida'] or 'unidad' for row in cursor.fetchall()}
        
        stock_por_producto_almacen = {}
        
        checkpoints = LocalReplica.get_checkpoints()
        if checkpoints:
            cursor.execute("""
                SELECT producto_id, almacen, tipo, cantidad_anterior, cantidad_nueva, id
                FROM movimientos
                ORDER BY id
            """)
            todos = cursor.fetchall()
            for mov in todos:
                producto_id = mov['producto_id']
                almacen = mov['almacen'] or 'principal'
                tipo = mov['tipo']
                cantidad_anterior = mov['cantidad_anterior']
                cantidad_nueva = mov['cantidad_nueva']
                
                if not producto_id:
                    continue
                
                unidad = unidad_map.get(producto_id, 'unidad')
                key = (producto_id, almacen)
                if key not in stock_por_producto_almacen:
                    stock_por_producto_almacen[key] = {
                        'cantidad': checkpoints.get(key, 0),
                        'unidad': unidad
                    }
                
                if tipo == 'ajuste':
                    if cantidad_nueva is not None:
                        stock_por_producto_almacen[key]['cantidad'] = cantidad_nueva
                else:
                    if cantidad_nueva is not None and cantidad_anterior is not None:
                        delta = cantidad_nueva - cantidad_anterior
                        stock_por_producto_almacen[key]['cantidad'] += delta
        else:
            cursor.execute("""
                SELECT producto_id, almacen, tipo, cantidad_anterior, cantidad_nueva, id
                FROM movimientos
                UNION ALL
                SELECT producto_id, almacen, tipo, cantidad_anterior, cantidad_nueva, id
                FROM movimientos_archivo
                ORDER BY id
            """)
            todos = cursor.fetchall()
            for mov in todos:
                producto_id = mov['producto_id']
                almacen = mov['almacen'] or 'principal'
                tipo = mov['tipo']
                cantidad_anterior = mov['cantidad_anterior']
                cantidad_nueva = mov['cantidad_nueva']
                
                if not producto_id:
                    continue
                
                unidad = unidad_map.get(producto_id, 'unidad')
                key = (producto_id, almacen)
                if key not in stock_por_producto_almacen:
                    stock_por_producto_almacen[key] = {'cantidad': 0, 'unidad': unidad}
                
                if tipo == 'ajuste':
                    if cantidad_nueva is not None:
                        stock_por_producto_almacen[key]['cantidad'] = cantidad_nueva
                else:
                    if cantidad_nueva is not None and cantidad_anterior is not None:
                        delta = cantidad_nueva - cantidad_anterior
                        stock_por_producto_almacen[key]['cantidad'] += delta
        
        for (producto_id, almacen), data in stock_por_producto_almacen.items():
            final_stock = round(data['cantidad'], 4) if data['cantidad'] is not None else 0
            
            if producto_id and almacen and final_stock is not None:
                if final_stock < 0:
                    print(f"[WARN] Stock negativo detectado: producto={producto_id}, almacen={almacen}, stock={final_stock}")
                
                cursor.execute("""
                    INSERT OR REPLACE INTO existencias (producto_id, almacen, cantidad, unidad)
                    VALUES (?, ?, ?, ?)
                """, (producto_id, almacen, final_stock, data['unidad']))
        
        conn.commit()
        conn.close()
    
    # ==================== MOVIMIENTOS ARCHIVO ====================

    @staticmethod
    def clear_movimientos_archivo() -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM movimientos_archivo")
        conn.commit()
        conn.close()

    @staticmethod
    def save_movimientos_archivo(movimientos: List[Dict]) -> None:
        if not movimientos:
            return
        conn = get_local_conn()
        cursor = conn.cursor()
        valid_keys = ['id', 'producto_id', 'factura_id', 'requisicion_id', 'tipo', 'cantidad',
                      'cantidad_anterior', 'cantidad_nueva', 'peso_total',
                      'registrado_por', 'observaciones', 'almacen', 'fecha_movimiento', 'created_at']
        inserted = 0
        for chunk in [movimientos[i:i+100] for i in range(0, len(movimientos), 100)]:
            for mov in chunk:
                mov_id = mov.get('id')
                cursor.execute("SELECT id FROM movimientos_archivo WHERE id = ?", (mov_id,))
                if cursor.fetchone():
                    continue
                values = [mov.get(k) for k in valid_keys]
                cols = ','.join(valid_keys)
                ph = ','.join(['?' for _ in valid_keys])
                cursor.execute(f"INSERT INTO movimientos_archivo ({cols}) VALUES ({ph})", values)
                inserted += 1
        conn.commit()
        conn.close()
        print(f"[SYNC] Movimientos archivo guardados: {inserted}")

    @staticmethod
    def get_movimientos_archivo(producto_id: int = None) -> List[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        if producto_id:
            cursor.execute(
                "SELECT * FROM movimientos_archivo WHERE producto_id = ? ORDER BY fecha_movimiento DESC",
                (producto_id,)
            )
        else:
            cursor.execute("SELECT * FROM movimientos_archivo ORDER BY fecha_movimiento DESC")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def insert_movimiento_archivo(mov: Dict) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT OR IGNORE INTO movimientos_archivo
            (id, producto_id, factura_id, requisicion_id, tipo, cantidad, cantidad_anterior, cantidad_nueva,
             peso_total, registrado_por, observaciones,
             almacen, fecha_movimiento, created_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            mov.get('id'), mov.get('producto_id'), mov.get('factura_id'), mov.get('requisicion_id'),
            mov.get('tipo'), mov.get('cantidad'), mov.get('cantidad_anterior', 0),
            mov.get('cantidad_nueva', 0), mov.get('peso_total', 0),
            mov.get('registrado_por'), mov.get('observaciones'),
            mov.get('almacen'), mov.get('fecha_movimiento'), mov.get('created_at')
        ))
        conn.commit()
        conn.close()

    @staticmethod
    def delete_movimiento_archivo_older_than(fecha_limite: str) -> int:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute(
            "DELETE FROM movimientos_archivo WHERE fecha_movimiento < ?",
            (fecha_limite,)
        )
        deleted = cursor.rowcount
        conn.commit()
        conn.close()
        return deleted

    # ==================== METADATOS DE SYNC ====================
    # Delegamos en sync_queue.py para mantener un solo source of truth
    
    def set_last_sync(key: str, timestamp: str = None) -> None:
        SyncQueue.set_last_sync(timestamp or datetime.now().isoformat())

    def get_last_sync(key: str) -> Optional[str]:
        return SyncQueue.get_last_sync()
    
    @staticmethod
    def get_usuario_dispositivo() -> dict | None:
        """Devuelve el usuario registrado en este dispositivo, o None."""
        import hashlib
        conn = get_local_conn()
        cursor = conn.cursor()
        try:
            cursor.execute("SELECT * FROM dispositivo_usuario LIMIT 1")
            row = cursor.fetchone()
        except Exception:
            # La tabla no existe: inicializar BD y reintentar
            conn.close()
            init_local_db()
            conn = get_local_conn()
            cursor = conn.cursor()
            cursor.execute("SELECT * FROM dispositivo_usuario LIMIT 1")
            row = cursor.fetchone()
        conn.close()
        return dict(row) if row else None
    
    @staticmethod
    def registrar_usuario_dispositivo(nombre: str, pin: str | None = None) -> None:
        """Registra el usuario de este dispositivo (solo una vez)."""
        import hashlib
        pin_hash = None
        if pin and pin.strip():
            pin_hash = hashlib.sha256(pin.strip().encode()).hexdigest()
        
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM dispositivo_usuario")
        cursor.execute(
            "INSERT INTO dispositivo_usuario (nombre, pin_hash, configurado_en) VALUES (?, ?, ?)",
            (nombre.strip(), pin_hash, datetime.now().isoformat())
        )
        conn.commit()
        conn.close()
    
    @staticmethod
    def verificar_pin(pin: str) -> bool:
        """Verifica el PIN del usuario."""
        import hashlib
        if not pin:
            return False
        
        pin_hash = hashlib.sha256(pin.encode()).hexdigest()
        
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT pin_hash FROM dispositivo_usuario LIMIT 1")
        row = cursor.fetchone()
        conn.close()
        
        return row and row['pin_hash'] == pin_hash
    
    @staticmethod
    def delete_orphaned_records(table_name: str, remote_ids: List[int], key_column: str = None) -> int:
        """
        Elimina registros locales que no están en la lista de IDs remotos
        y no están pendientes de sincronización en la cola.
        """
        import json

        conn = get_local_conn()
        cursor = conn.cursor()

        # DEBUG: verificar cuántos registros hay antes de podar
        if table_name == 'requisiciones':
            cursor.execute(f"SELECT COUNT(*) as cnt FROM {table_name}")
            debug_cnt = cursor.fetchone()['cnt']
            print(f"[SYNC-DEBUG] requisiciones antes de podar: {debug_cnt} registros, remote_ids={remote_ids}")

        # 1. Obtener valores clave de la cola de sync pendientes para esta tabla
        cursor.execute("SELECT data FROM sync_queue WHERE table_name = ? AND status = 'pending'", (table_name,))
        pending_rows = cursor.fetchall()

        pending_keys = []
        if key_column:
            for row in pending_rows:
                try:
                    p_data = json.loads(row[0])
                    if key_column in p_data:
                        pending_keys.append(p_data[key_column])
                except:
                    pass

        # Si el servidor devolvió 0 filas:
        #  - Tablas con creación local (productos, categorías, facturas, etc.):
        #    NO podamos, para no borrar datos locales no sincronados por un fallo
        #    transitorio de lectura.
        #  - 'requisiciones' es una tabla de SOLO DESCARGA: si ya no existen en el
        #    servidor, deben desaparecer también en local.
        if not remote_ids:
            if table_name != 'requisiciones':
                conn.close()
                return 0
            query = f"DELETE FROM {table_name} WHERE 1=1"
            params = []
        else:
            placeholders = ','.join(['?' for _ in remote_ids])
            query = f"DELETE FROM {table_name} WHERE id NOT IN ({placeholders})"
            params = list(remote_ids)

        if key_column and pending_keys:
            key_placeholders = ','.join(['?' for _ in pending_keys])
            query += f" AND {key_column} NOT IN ({key_placeholders})"
            params.extend(pending_keys)

        cursor.execute(query, params)
        deleted = cursor.rowcount

        # Caso especial para requisiciones: también eliminar detalles huérfanos
        if table_name == 'requisiciones':
            if remote_ids:
                dph = ','.join(['?' for _ in remote_ids])
                cursor.execute(f"DELETE FROM requisicion_detalles WHERE requisicion_id NOT IN ({dph})", list(remote_ids))
            else:
                cursor.execute("DELETE FROM requisicion_detalles WHERE requisicion_id NOT IN (SELECT id FROM requisiciones)")

        conn.commit()
        conn.close()

        if deleted > 0 or table_name == 'requisiciones':
            print(f"[SYNC] {deleted} registros huérfanos eliminados de la tabla local '{table_name}'")
        return deleted

    @staticmethod
    def eliminar_usuario_dispositivo() -> None:
        """Resetea el usuario (para cambio de operador)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM dispositivo_usuario")
        conn.commit()
        conn.close()

    # ==================== POS USUARIOS ====================

    @staticmethod
    def get_pos_usuarios(solo_activos: bool = True) -> List[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        if solo_activos:
            cursor.execute("SELECT * FROM pos_usuarios WHERE activo = 1 ORDER BY nombre")
        else:
            cursor.execute("SELECT * FROM pos_usuarios ORDER BY nombre")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_pos_usuario(usuario_id: int) -> Optional[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pos_usuarios WHERE id = ?", (usuario_id,))
        row = cursor.fetchone()
        conn.close()
        return dict(row) if row else None

    @staticmethod
    def crear_pos_usuario(nombre: str, pin: str | None = None, es_admin: bool = False) -> int:
        import hashlib
        pin_hash = None
        if pin and pin.strip():
            pin_hash = hashlib.sha256(pin.strip().encode()).hexdigest()
        conn = get_local_conn()
        cursor = conn.cursor()
        from datetime import datetime
        cursor.execute(
            "INSERT INTO pos_usuarios (nombre, pin_hash, es_admin, activo, creado_en) VALUES (?, ?, ?, 1, ?)",
            (nombre.strip(), pin_hash, 1 if es_admin else 0, datetime.now().isoformat())
        )
        uid = cursor.lastrowid
        conn.commit()
        conn.close()
        return uid

    @staticmethod
    def update_pos_usuario(usuario_id: int, nombre: str = None, pin: str = None, es_admin: bool = None, activo: bool = None) -> None:
        import hashlib
        conn = get_local_conn()
        cursor = conn.cursor()
        updates = []
        params = []
        if nombre is not None:
            updates.append("nombre = ?")
            params.append(nombre.strip())
        if pin is not None:
            if pin == "":
                updates.append("pin_hash = NULL")
            else:
                updates.append("pin_hash = ?")
                params.append(hashlib.sha256(pin.strip().encode()).hexdigest())
        if es_admin is not None:
            updates.append("es_admin = ?")
            params.append(1 if es_admin else 0)
        if activo is not None:
            updates.append("activo = ?")
            params.append(1 if activo else 0)
        if not updates:
            conn.close()
            return
        params.append(usuario_id)
        cursor.execute(f"UPDATE pos_usuarios SET {', '.join(updates)} WHERE id = ?", params)
        conn.commit()
        conn.close()

    @staticmethod
    def delete_pos_usuario(usuario_id: int) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM pos_usuarios WHERE id = ?", (usuario_id,))
        conn.commit()
        conn.close()

    @staticmethod
    def verificar_pos_pin(usuario_id: int, pin: str) -> bool:
        import hashlib
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT pin_hash FROM pos_usuarios WHERE id = ?", (usuario_id,))
        row = cursor.fetchone()
        conn.close()
        if not row or not row['pin_hash']:
            return False
        pin_hash = hashlib.sha256(pin.encode()).hexdigest()
        return row['pin_hash'] == pin_hash

    @staticmethod
    def abrir_pos_sesion(usuario_id: int) -> int:
        conn = get_local_conn()
        cursor = conn.cursor()
        from datetime import datetime
        cursor.execute(
            "INSERT INTO pos_sesiones (usuario_id, abierta_en) VALUES (?, ?)",
            (usuario_id, datetime.now().isoformat())
        )
        sid = cursor.lastrowid
        conn.commit()
        conn.close()
        return sid

    @staticmethod
    def cerrar_pos_sesion(sesion_id: int) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        from datetime import datetime
        cursor.execute(
            "UPDATE pos_sesiones SET cerrada_en = ? WHERE id = ?",
            (datetime.now().isoformat(), sesion_id)
        )
        conn.commit()
        conn.close()

    @staticmethod
    def get_pos_sesion_activa() -> Optional[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT s.*, u.nombre as usuario_nombre
            FROM pos_sesiones s
            JOIN pos_usuarios u ON u.id = s.usuario_id
            WHERE s.cerrada_en IS NULL
            ORDER BY s.abierta_en DESC
            LIMIT 1
        """)
        row = cursor.fetchone()
        conn.close()
        return dict(row) if row else None

    # ==================== POS MESAS ====================

    @staticmethod
    def get_pos_mesas(solo_activos: bool = False) -> List[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        if solo_activos:
            cursor.execute("SELECT * FROM pos_mesas WHERE activo = 1 ORDER BY zona, numero")
        else:
            cursor.execute("SELECT * FROM pos_mesas ORDER BY zona, numero")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def crear_pos_mesa(numero: str, nombre: str = None, zona: str = None) -> int:
        conn = get_local_conn()
        cursor = conn.cursor()
        from datetime import datetime
        cursor.execute(
            "INSERT INTO pos_mesas (numero, nombre, zona, activo, creado_en) VALUES (?, ?, ?, 1, ?)",
            (numero.strip(), nombre.strip() if nombre else None, zona.strip() if zona else None, datetime.now().isoformat())
        )
        mid = cursor.lastrowid
        conn.commit()
        conn.close()
        return mid

    @staticmethod
    def update_pos_mesa(mesa_id: int, numero: str = None, nombre: str = None, zona: str = None, activo: bool = None) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        updates = []
        params = []
        if numero is not None:
            updates.append("numero = ?")
            params.append(numero.strip())
        if nombre is not None:
            updates.append("nombre = ?")
            params.append(nombre.strip() if nombre else None)
        if zona is not None:
            updates.append("zona = ?")
            params.append(zona.strip() if zona else None)
        if activo is not None:
            updates.append("activo = ?")
            params.append(1 if activo else 0)
        if not updates:
            conn.close()
            return
        params.append(mesa_id)
        cursor.execute(f"UPDATE pos_mesas SET {', '.join(updates)} WHERE id = ?", params)
        conn.commit()
        conn.close()

    @staticmethod
    def delete_pos_mesa(mesa_id: int) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM pos_mesas WHERE id = ?", (mesa_id,))
        conn.commit()
        conn.close()

    # ==================== POS HABITACIONES ====================

    @staticmethod
    def get_pos_habitaciones(solo_activos: bool = False) -> List[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        if solo_activos:
            cursor.execute("SELECT * FROM pos_habitaciones WHERE activo = 1 ORDER BY piso, numero")
        else:
            cursor.execute("SELECT * FROM pos_habitaciones ORDER BY piso, numero")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_pos_habitacion_by_id(hab_id: int) -> Optional[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pos_habitaciones WHERE id = ?", (hab_id,))
        row = cursor.fetchone()
        conn.close()
        return dict(row) if row else None

    @staticmethod
    def get_habitaciones_ocupadas() -> set:
        """Retorna el set de habitacion_id que tienen comandas abiertas."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT DISTINCT habitacion_id FROM pos_comandas WHERE estado = 'abierta' AND habitacion_id IS NOT NULL")
        rows = cursor.fetchall()
        conn.close()
        return {int(r['habitacion_id']) for r in rows}

    @staticmethod
    def crear_pos_habitacion(numero: str, piso: str = None, tipo: str = None) -> int:
        conn = get_local_conn()
        cursor = conn.cursor()
        from datetime import datetime
        cursor.execute(
            "INSERT INTO pos_habitaciones (numero, piso, tipo, activo, creado_en) VALUES (?, ?, ?, 1, ?)",
            (numero.strip(), piso.strip() if piso else None, tipo.strip() if tipo else None, datetime.now().isoformat())
        )
        hid = cursor.lastrowid
        conn.commit()
        conn.close()
        return hid

    @staticmethod
    def update_pos_habitacion(hab_id: int, numero: str = None, piso: str = None, tipo: str = None, activo: bool = None) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        updates = []
        params = []
        if numero is not None:
            updates.append("numero = ?")
            params.append(numero.strip())
        if piso is not None:
            updates.append("piso = ?")
            params.append(piso.strip() if piso else None)
        if tipo is not None:
            updates.append("tipo = ?")
            params.append(tipo.strip() if tipo else None)
        if activo is not None:
            updates.append("activo = ?")
            params.append(1 if activo else 0)
        if not updates:
            conn.close()
            return
        params.append(hab_id)
        cursor.execute(f"UPDATE pos_habitaciones SET {', '.join(updates)} WHERE id = ?", params)
        conn.commit()
        conn.close()

    @staticmethod
    def delete_pos_habitacion(hab_id: int) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM pos_habitaciones WHERE id = ?", (hab_id,))
        conn.commit()
        conn.close()

    # ==================== COMANDAS ====================

    @staticmethod
    def save_comanda(sesion_id: int, items: list, total: float,
                     mesa_id: int = None, habitacion_id: int = None) -> int:
        """Guarda la comanda abierta de la mesa/habitacion (upsert).
        Si ya existe una comanda abierta para la mesa/habitacion, la actualiza;
        si no, crea una nueva. Retorna el id de la comanda."""
        import json
        import uuid
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        items_json = json.dumps(items, ensure_ascii=False, default=str)
        sync_uuid = None
        comanda_id = None
        if mesa_id is not None:
            cursor.execute(
                "SELECT id, sync_uuid FROM pos_comandas WHERE mesa_id = ? AND estado = 'abierta' ORDER BY id DESC LIMIT 1",
                (mesa_id,))
            row = cursor.fetchone()
            if row:
                comanda_id = row['id']
                sync_uuid = row['sync_uuid']
                cursor.execute(
                    "UPDATE pos_comandas SET items_json = ?, total = ?, updated_at = ? WHERE id = ?",
                    (items_json, total, now, comanda_id))
        elif habitacion_id is not None:
            cursor.execute(
                "SELECT id, sync_uuid FROM pos_comandas WHERE habitacion_id = ? AND estado = 'abierta' ORDER BY id DESC LIMIT 1",
                (habitacion_id,))
            row = cursor.fetchone()
            if row:
                comanda_id = row['id']
                sync_uuid = row['sync_uuid']
                cursor.execute(
                    "UPDATE pos_comandas SET items_json = ?, total = ?, updated_at = ? WHERE id = ?",
                    (items_json, total, now, comanda_id))
        if comanda_id is None:
            sync_uuid = uuid.uuid4().hex
            cursor.execute("""
                INSERT INTO pos_comandas (sesion_id, mesa_id, habitacion_id, estado, total, items_json, sync_uuid, created_at)
                VALUES (?, ?, ?, 'abierta', ?, ?, ?, ?)
            """, (sesion_id, mesa_id, habitacion_id, total, items_json, sync_uuid, now))
            comanda_id = cursor.lastrowid
        conn.commit()
        conn.close()
        try:
            LocalReplica._enqueue_comanda(comanda_id, sync_uuid)
        except Exception:
            pass
        return comanda_id

    @staticmethod
    def _enqueue_comanda(comanda_id: int, sync_uuid: str = None) -> None:
        """Encola una comanda para subirla a Supabase (sync POS)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pos_comandas WHERE id = ?", (comanda_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return
        d = dict(row)
        d['sync_uuid'] = sync_uuid or d.get('sync_uuid')
        from .sync_queue import get_sync_queue
        get_sync_queue().add_pending('pos_comandas', 'upsert', d)

    @staticmethod
    def get_comanda_abierta(mesa_id: int = None, habitacion_id: int = None) -> Optional[Dict]:
        """Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None."""
        import json
        conn = get_local_conn()
        cursor = conn.cursor()
        row = None
        if mesa_id is not None:
            cursor.execute(
                "SELECT * FROM pos_comandas WHERE mesa_id = ? AND estado = 'abierta' ORDER BY id DESC LIMIT 1",
                (mesa_id,))
            row = cursor.fetchone()
        elif habitacion_id is not None:
            cursor.execute(
                "SELECT * FROM pos_comandas WHERE habitacion_id = ? AND estado = 'abierta' ORDER BY id DESC LIMIT 1",
                (habitacion_id,))
            row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        d = dict(row)
        try:
            d['items'] = json.loads(d.get('items_json') or '[]')
        except Exception:
            d['items'] = []
        return d

    @staticmethod
    def get_mesas_ocupadas() -> set:
        """Retorna el set de mesa_id que tienen comandas abiertas."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT DISTINCT mesa_id FROM pos_comandas WHERE estado = 'abierta' AND mesa_id IS NOT NULL")
        rows = cursor.fetchall()
        conn.close()
        return {int(r['mesa_id']) for r in rows}

    @staticmethod
    def get_comandas_by_mesa(mesa_id: int, solo_abiertas: bool = True) -> List[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        if solo_abiertas:
            cursor.execute("""
                SELECT * FROM pos_comandas WHERE mesa_id = ? AND estado = 'abierta' ORDER BY created_at DESC
            """, (mesa_id,))
        else:
            cursor.execute("""
                SELECT * FROM pos_comandas WHERE mesa_id = ? ORDER BY created_at DESC
            """, (mesa_id,))
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_comandas_by_habitacion(hab_id: int, solo_abiertas: bool = True) -> List[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        if solo_abiertas:
            cursor.execute("""
                SELECT * FROM pos_comandas WHERE habitacion_id = ? AND estado = 'abierta' ORDER BY created_at DESC
            """, (hab_id,))
        else:
            cursor.execute("""
                SELECT * FROM pos_comandas WHERE habitacion_id = ? ORDER BY created_at DESC
            """, (hab_id,))
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def cerrar_comanda(comanda_id: int) -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        cursor.execute("UPDATE pos_comandas SET estado='cerrada', updated_at=? WHERE id=?", (now, comanda_id))
        conn.commit()
        conn.close()
        try:
            LocalReplica._enqueue_comanda(comanda_id)
        except Exception:
            pass

    @staticmethod
    def reabrir_comanda(comanda_id: int) -> None:
        """Reabre una comanda cerrada (para correccion/venta devuelta)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        cursor.execute("UPDATE pos_comandas SET estado='abierta', updated_at=? WHERE id=?", (now, comanda_id))
        conn.commit()
        conn.close()
        try:
            LocalReplica._enqueue_comanda(comanda_id)
        except Exception:
            pass

    # ==================== VENTAS (POS) ====================

    @staticmethod
    def registrar_venta(comanda_id: int, correlativo: int, total: float, items: list,
                        mesa_id: int = None, habitacion_id: int = None,
                        usuario_id: int = None, sesion_id: int = None,
                        venta_anula_id: int = None, tasa_bs: float = None) -> int:
        """Registra una venta cobrada. Retorna el id de la venta."""
        import json
        import uuid
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        items_json = json.dumps(items, ensure_ascii=False, default=str)
        sync_uuid = uuid.uuid4().hex
        comanda_sync_uuid = None
        if comanda_id:
            cursor.execute("SELECT sync_uuid FROM pos_comandas WHERE id = ?", (comanda_id,))
            crow = cursor.fetchone()
            if crow:
                comanda_sync_uuid = crow['sync_uuid']
        venta_anula_sync_uuid = None
        if venta_anula_id:
            cursor.execute("SELECT sync_uuid FROM pos_ventas WHERE id = ?", (venta_anula_id,))
            vrow = cursor.fetchone()
            if vrow:
                venta_anula_sync_uuid = vrow['sync_uuid']
        cursor.execute("""
            INSERT INTO pos_ventas
            (comanda_id, correlativo, total, items_json, mesa_id, habitacion_id,
             usuario_id, sesion_id, estado, venta_anula_id, tasa_bs,
             sync_uuid, comanda_sync_uuid, venta_anula_sync_uuid, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'vigente', ?, ?, ?, ?, ?, ?, ?)
        """, (comanda_id, correlativo, total, items_json, mesa_id, habitacion_id,
              usuario_id, sesion_id, venta_anula_id, tasa_bs,
              sync_uuid, comanda_sync_uuid, venta_anula_sync_uuid, now, now))
        venta_id = cursor.lastrowid
        conn.commit()
        conn.close()
        try:
            LocalReplica._enqueue_venta(venta_id, sync_uuid)
        except Exception:
            pass
        return venta_id

    @staticmethod
    def _enqueue_venta(venta_id: int, sync_uuid: str = None) -> None:
        """Encola una venta para subirla a Supabase (sync POS)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pos_ventas WHERE id = ?", (venta_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return
        d = dict(row)
        d['sync_uuid'] = sync_uuid or d.get('sync_uuid')
        from .sync_queue import get_sync_queue
        get_sync_queue().add_pending('pos_ventas', 'upsert', d)

    @staticmethod
    def anular_venta(venta_id: int, anulada_por: str = None, motivo: str = '') -> None:
        """Marca una venta como anulada (devuelta)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        cursor.execute("""
            UPDATE pos_ventas SET estado='anulada', motivo_anulacion=?, anulada_por=?, anulada_en=?, updated_at=?
            WHERE id=?
        """, (motivo or 'Correccion', anulada_por, now, now, venta_id))
        conn.commit()
        conn.close()
        try:
            LocalReplica._enqueue_venta(venta_id)
        except Exception:
            pass

    @staticmethod
    def eliminar_venta_y_movimientos(venta_id: int) -> None:
        """Elimina una venta no impresa y sus movimientos, restaurando el stock."""
        conn = get_local_conn()
        cursor = conn.cursor()
        sync_uuid = None
        cursor.execute("SELECT sync_uuid FROM pos_ventas WHERE id = ?", (venta_id,))
        row = cursor.fetchone()
        if row:
            sync_uuid = row['sync_uuid']
        cursor.execute("SELECT * FROM movimientos WHERE venta_id = ?", (venta_id,))
        movs = [dict(r) for r in cursor.fetchall()]
        for m in movs:
            if m.get('producto_id') and m.get('almacen'):
                cursor.execute(
                    "UPDATE existencias SET cantidad=? WHERE producto_id=? AND almacen=?",
                    (m.get('cantidad_anterior'), m['producto_id'], m['almacen']))
        cursor.execute("DELETE FROM movimientos WHERE venta_id = ?", (venta_id,))
        cursor.execute("DELETE FROM pos_ventas WHERE id = ?", (venta_id,))
        if sync_uuid:
            now = datetime.now().isoformat()
            cursor.execute(
                "INSERT OR IGNORE INTO pos_sync_tombstones (uuid, tabla, created_at) VALUES (?, 'pos_ventas', ?)",
                (sync_uuid, now))
            for m in movs:
                m_vsu = m.get('venta_sync_uuid')
                if m_vsu:
                    cursor.execute(
                        "INSERT OR IGNORE INTO pos_sync_tombstones (uuid, tabla, created_at) VALUES (?, 'movimientos', ?)",
                        (m_vsu, now))
        conn.commit()
        conn.close()
        if sync_uuid:
            try:
                from .sync_queue import get_sync_queue
                get_sync_queue().add_pending('pos_ventas', 'delete', {'sync_uuid': sync_uuid})
            except Exception:
                pass

    @staticmethod
    def get_venta_by_id(venta_id: int) -> Optional[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pos_ventas WHERE id = ?", (venta_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        d = dict(row)
        d['items'] = LocalReplica._parse_comanda_items(d.get('items_json'))
        return d

    @staticmethod
    def get_ventas(limit: int = 200) -> List[Dict]:
        """Historial de ventas (mas recientes primero)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pos_ventas ORDER BY id DESC LIMIT ?", (limit,))
        rows = cursor.fetchall()
        conn.close()
        ventas = []
        for r in rows:
            d = dict(r)
            d['items'] = LocalReplica._parse_comanda_items(d.get('items_json'))
            ventas.append(d)
        return ventas

    @staticmethod
    def get_ultima_venta_vigente() -> Optional[Dict]:
        """Ultima venta cobrada que sigue vigente (no anulada)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM pos_ventas WHERE estado = 'vigente' ORDER BY id DESC LIMIT 1
        """)
        row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        d = dict(row)
        d['items'] = LocalReplica._parse_comanda_items(d.get('items_json'))
        return d

    @staticmethod
    def get_venta_anulada_by_comanda(comanda_id: int) -> Optional[Dict]:
        """Ultima venta anulada de una comanda (para saber si el proximo cobro es una correccion)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM pos_ventas WHERE comanda_id = ? AND estado = 'anulada' ORDER BY id DESC LIMIT 1
        """, (comanda_id,))
        row = cursor.fetchone()
        conn.close()
        if not row:
            return None
        d = dict(row)
        d['items'] = LocalReplica._parse_comanda_items(d.get('items_json'))
        return d

    @staticmethod
    def _parse_comanda_items(items_json: str) -> list:
        import json
        try:
            return json.loads(items_json or '[]')
        except Exception:
            return []

    @staticmethod
    def save_comandas_sync(rows: list) -> int:
        """Aplica comandas descargadas de Supabase (upsert por sync_uuid).
        Retorna cuantas se insertaron o actualizaron."""
        conn = get_local_conn()
        cursor = conn.cursor()
        count = 0
        for c in rows:
            sync_uuid = (c.get('sync_uuid') or '').strip()
            if not sync_uuid:
                continue
            cursor.execute("SELECT id FROM pos_comandas WHERE sync_uuid = ?", (sync_uuid,))
            existing = cursor.fetchone()
            if existing:
                cursor.execute("""
                    UPDATE pos_comandas SET
                        sesion_id = ?, mesa_id = ?, habitacion_id = ?, estado = ?,
                        total = ?, items_json = ?, updated_at = ?
                    WHERE id = ?
                """, (
                    c.get('sesion_id'), c.get('mesa_id'), c.get('habitacion_id'),
                    c.get('estado', 'abierta'), c.get('total', 0), c.get('items_json'),
                    c.get('updated_at'), existing['id']
                ))
            else:
                cursor.execute("""
                    INSERT INTO pos_comandas
                        (sesion_id, mesa_id, habitacion_id, estado, total, items_json,
                         sync_uuid, created_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    c.get('sesion_id'), c.get('mesa_id'), c.get('habitacion_id'),
                    c.get('estado', 'abierta'), c.get('total', 0), c.get('items_json'),
                    sync_uuid, c.get('created_at'), c.get('updated_at')
                ))
            count += 1
        conn.commit()
        conn.close()
        return count

    @staticmethod
    def save_ventas_sync(rows: list) -> int:
        """Aplica ventas descargadas de Supabase (upsert por sync_uuid).

        Resuelve comanda_id y venta_anula_id locales desde los sync_uuid, y respeta
        last-writer-wins por updated_at para no pisar ediciones locales mas nuevas.
        """
        conn = get_local_conn()
        cursor = conn.cursor()
        count = 0
        for v in rows:
            sync_uuid = (v.get('sync_uuid') or '').strip()
            if not sync_uuid:
                continue
            cursor.execute("SELECT uuid FROM pos_sync_tombstones WHERE uuid = ? AND tabla = 'pos_ventas'", (sync_uuid,))
            if cursor.fetchone():
                continue
            comanda_id = None
            csync = (v.get('comanda_sync_uuid') or '').strip()
            if csync:
                cursor.execute("SELECT id FROM pos_comandas WHERE sync_uuid = ?", (csync,))
                r = cursor.fetchone()
                if r:
                    comanda_id = r['id']
            venta_anula_id = None
            vsync = (v.get('venta_anula_sync_uuid') or '').strip()
            if vsync:
                cursor.execute("SELECT id FROM pos_ventas WHERE sync_uuid = ?", (vsync,))
                r = cursor.fetchone()
                if r:
                    venta_anula_id = r['id']

            cursor.execute("SELECT id, updated_at FROM pos_ventas WHERE sync_uuid = ?", (sync_uuid,))
            existing = cursor.fetchone()
            if existing:
                if (existing['updated_at'] and v.get('updated_at')
                        and str(v['updated_at']) < str(existing['updated_at'])):
                    continue
                cursor.execute("""
                    UPDATE pos_ventas SET
                        comanda_id = ?, correlativo = ?, total = ?, items_json = ?,
                        mesa_id = ?, habitacion_id = ?, usuario_id = ?, sesion_id = ?,
                        estado = ?, venta_anula_id = ?, motivo_anulacion = ?,
                        anulada_por = ?, anulada_en = ?, tasa_bs = ?,
                        comanda_sync_uuid = ?, venta_anula_sync_uuid = ?, updated_at = ?
                    WHERE id = ?
                """, (
                    comanda_id, v.get('correlativo'), v.get('total', 0), v.get('items_json'),
                    v.get('mesa_id'), v.get('habitacion_id'), v.get('usuario_id'),
                    v.get('sesion_id'), v.get('estado', 'vigente'), venta_anula_id,
                    v.get('motivo_anulacion'), v.get('anulada_por'), v.get('anulada_en'),
                    v.get('tasa_bs'), csync, vsync, v.get('updated_at'), existing['id']
                ))
            else:
                cursor.execute("""
                    INSERT INTO pos_ventas
                        (comanda_id, correlativo, total, items_json, mesa_id, habitacion_id,
                         usuario_id, sesion_id, estado, venta_anula_id, motivo_anulacion,
                         anulada_por, anulada_en, tasa_bs, sync_uuid, comanda_sync_uuid,
                         venta_anula_sync_uuid, created_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    comanda_id, v.get('correlativo'), v.get('total', 0), v.get('items_json'),
                    v.get('mesa_id'), v.get('habitacion_id'), v.get('usuario_id'),
                    v.get('sesion_id'), v.get('estado', 'vigente'), venta_anula_id,
                    v.get('motivo_anulacion'), v.get('anulada_por'), v.get('anulada_en'),
                    v.get('tasa_bs'), sync_uuid, csync, vsync, v.get('created_at'),
                    v.get('updated_at')
                ))
            count += 1
        conn.commit()
        conn.close()
        return count

    @staticmethod
    def relink_ventas_movimientos() -> None:
        """Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            UPDATE movimientos SET venta_id = (
                SELECT pv.id FROM pos_ventas pv WHERE pv.sync_uuid = movimientos.venta_sync_uuid
            )
            WHERE venta_sync_uuid IS NOT NULL AND venta_sync_uuid != ''
        """)
        conn.commit()
        conn.close()

    @staticmethod
    def get_plato_ingredientes(plato_id: int) -> List[Dict]:
        """Ingredientes de un plato/contorno."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT pi.*, pr.nombre as producto_nombre
            FROM plato_ingredientes pi
            LEFT JOIN productos pr ON pi.producto_id = pr.id
            WHERE pi.plato_id = ?
            ORDER BY pr.nombre
        """, (plato_id,))
        rows = cursor.fetchall()
        conn.close()
        return [dict(r) for r in rows]

    @staticmethod
    def get_pos_mesa_by_id(mesa_id: int) -> Optional[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pos_mesas WHERE id = ?", (mesa_id,))
        row = cursor.fetchone()
        conn.close()
        return dict(row) if row else None

    @staticmethod
    def resolver_movimientos_venta(items: list) -> List[Dict]:
        """Resuelve cada item de la comanda a los productos de inventario a descontar.

        - Item tipo 'producto' (o en tabla productos): descuenta el producto mismo.
        - Item plato/contorno con ingredientes: descuenta cada ingrediente x cantidad.
        - Plato/contorno sin ingredientes asignados: NO genera movimiento (no descarga nada).
        - Contornos seleccionados de un plato tambien se resuelven via sus ingredientes.

        Retorna lista agrupada: {producto_id, producto_nombre, cantidad, almacen}
        """
        acumulado = {}
        for item in items:
            pid = item.get('id')
            cant = float(item.get('cantidad', 1) or 1)
            if not pid:
                continue

            if str(item.get('tipo') or '').lower() == 'producto':
                tipos = ['producto']
            else:
                prod = LocalReplica.get_producto_by_id(pid)
                tipos = ['producto'] if prod else ['plato']

            for t in tipos:
                if t == 'producto':
                    prod = LocalReplica.get_producto_by_id(pid)
                    if not prod:
                        continue
                    almacen = (prod.get('almacen_predeterminado') or 'principal').strip()
                    LocalReplica._acumular_mov(acumulado, pid, prod.get('nombre'), cant, almacen)
                else:
                    LocalReplica._acumular_ingredientes(acumulado, pid, cant)

            cids = list(item.get('contorno_ids') or [])
            for ci in (item.get('contornos_info') or []):
                if ci.get('id'):
                    cids.append(ci['id'])
            for cid in cids:
                LocalReplica._acumular_ingredientes(acumulado, cid, cant)

        return list(acumulado.values())

    @staticmethod
    def _acumular_ingredientes(acumulado: dict, plato_id: int, cant: float) -> None:
        ingredientes = LocalReplica.get_plato_ingredientes(plato_id)
        for ing in (ingredientes or []):
            prod = LocalReplica.get_producto_by_id(ing.get('producto_id'))
            if not prod:
                continue
            almacen = (prod.get('almacen_predeterminado') or 'principal').strip()
            LocalReplica._acumular_mov(
                acumulado, ing['producto_id'], prod.get('nombre'),
                float(ing.get('cantidad', 1) or 1) * cant, almacen)

    @staticmethod
    def _acumular_mov(acumulado: dict, producto_id: int, nombre: str, cantidad: float, almacen: str) -> None:
        key = (producto_id, almacen)
        if key not in acumulado:
            acumulado[key] = {'producto_id': producto_id, 'producto_nombre': nombre,
                              'cantidad': 0.0, 'almacen': almacen}
        acumulado[key]['cantidad'] += cantidad

    @staticmethod
    def _get_venta_sync_uuid(venta_id: int) -> str:
        """Sync_uuid de una venta (para el vinculo estable venta<->movimientos)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT sync_uuid FROM pos_ventas WHERE id = ?", (venta_id,))
        row = cursor.fetchone()
        conn.close()
        return row['sync_uuid'] if row and row['sync_uuid'] else ''

    @staticmethod
    def aplicar_movimientos_venta(venta_id: int, movimientos: List[Dict], registrado_por: str = None) -> None:
        """Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        venta_sync_uuid = LocalReplica._get_venta_sync_uuid(venta_id)
        for mov in movimientos:
            producto_id = mov.get('producto_id')
            cantidad = float(mov.get('cantidad', 0) or 0)
            almacen = (mov.get('almacen') or 'principal').strip()
            if not producto_id or cantidad <= 0:
                continue
            cursor.execute("SELECT cantidad FROM existencias WHERE producto_id = ? AND almacen = ?",
                           (producto_id, almacen))
            row = cursor.fetchone()
            cant_anterior = float(row['cantidad']) if row else 0.0
            cant_nueva = cant_anterior - cantidad
            if cant_nueva < 0:
                print(f"[WARN] Stock negativo por venta: producto={producto_id}, almacen={almacen}")
            obs = f"Venta #{venta_id}"
            if mov.get('producto_nombre'):
                obs += f" - {mov['producto_nombre']}"
            if cant_nueva < 0:
                obs += " [STOCK INSUFICIENTE]"
            cursor.execute("""
                INSERT INTO movimientos
                (producto_id, venta_id, venta_sync_uuid, tipo, cantidad, cantidad_anterior, cantidad_nueva,
                 peso_total, registrado_por, observaciones, almacen, fecha_movimiento, created_at, sincronizado)
                VALUES (?, ?, ?, 'venta', ?, ?, ?, 0, ?, ?, ?, ?, ?, 0)
            """, (producto_id, venta_id, venta_sync_uuid or None, cantidad, cant_anterior, cant_nueva,
                  registrado_por, obs, almacen, now, now))
            cursor.execute("""
                UPDATE existencias SET cantidad = ? WHERE producto_id = ? AND almacen = ?
            """, (cant_nueva, producto_id, almacen))
        conn.commit()
        conn.close()

    @staticmethod
    def revertir_movimientos_venta(venta_id: int, registrado_por: str = None) -> None:
        """Revierte la salida de mercancia de una venta anulada (tipo 'devolucion')."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        venta_sync_uuid = LocalReplica._get_venta_sync_uuid(venta_id)
        cursor.execute("SELECT * FROM movimientos WHERE venta_id = ? AND tipo = 'venta'", (venta_id,))
        movs = [dict(r) for r in cursor.fetchall()]
        for m in movs:
            producto_id = m.get('producto_id')
            almacen = (m.get('almacen') or 'principal').strip()
            cantidad = float(m.get('cantidad', 0) or 0)
            if not producto_id or cantidad <= 0:
                continue
            cursor.execute("SELECT cantidad FROM existencias WHERE producto_id = ? AND almacen = ?",
                           (producto_id, almacen))
            row = cursor.fetchone()
            cant_anterior = float(row['cantidad']) if row else 0.0
            cant_nueva = cant_anterior + cantidad
            obs = f"Devolucion venta #{venta_id}"
            cursor.execute("""
                INSERT INTO movimientos
                (producto_id, venta_id, venta_sync_uuid, tipo, cantidad, cantidad_anterior, cantidad_nueva,
                 peso_total, registrado_por, observaciones, almacen, fecha_movimiento, created_at, sincronizado)
                VALUES (?, ?, ?, 'devolucion', ?, ?, ?, 0, ?, ?, ?, ?, ?, 0)
            """, (producto_id, venta_id, venta_sync_uuid or None, cantidad, cant_anterior, cant_nueva,
                  registrado_por, obs, almacen, now, now))
            cursor.execute("""
                UPDATE existencias SET cantidad = ? WHERE producto_id = ? AND almacen = ?
            """, (cant_nueva, producto_id, almacen))
        conn.commit()
        conn.close()

    @staticmethod
    def get_pos_setting(key: str, default: str = None) -> str:
        """Obtiene un setting de POS (ej: printer_device)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT value FROM pos_settings WHERE key = ?", (key,))
        row = cursor.fetchone()
        conn.close()
        return row['value'] if row else default

    @staticmethod
    def get_tasa_cambio() -> Optional[float]:
        """Tasa de cambio guardada (Bs por USD). None si no hay ninguna."""
        val = LocalReplica.get_pos_setting('tasa_cambio')
        if val is None:
            return None
        try:
            return float(val)
        except Exception:
            return None

    @staticmethod
    def get_tasa_cambio_fecha() -> str:
        return LocalReplica.get_pos_setting('tasa_cambio_actualizada_en', '') or ''

    @staticmethod
    def set_tasa_cambio(tasa: float, sync: bool = False) -> None:
        """Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion."""
        from datetime import datetime
        LocalReplica.set_pos_setting('tasa_cambio', f"{float(tasa):.4f}", sync=sync)
        LocalReplica.set_pos_setting('tasa_cambio_actualizada_en',
                                     datetime.now().isoformat(timespec='seconds'), sync=sync)

    @staticmethod
    def set_pos_setting(key: str, value: str, sync: bool = True) -> None:
        """Guarda un setting de POS.
        Si sync=True, lo encola para subir a Supabase."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO pos_settings (key, value) VALUES (?, ?)
            ON CONFLICT(key) DO UPDATE SET value = excluded.value
        """, (key, value))
        conn.commit()
        conn.close()
        if sync:
            try:
                get_sync_queue().add_pending('pos_settings', 'upsert', {'key': key, 'value': value})
            except Exception:
                pass

    # ==================== RECETAS ====================

    @staticmethod
    def get_recetas(activo: bool = True) -> List[Dict]:
        """Obtiene todas las recetas."""
        conn = get_local_conn()
        cursor = conn.cursor()
        if activo:
            cursor.execute("SELECT * FROM recetas WHERE activo = 1 ORDER BY nombre")
        else:
            cursor.execute("SELECT * FROM recetas ORDER BY nombre")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def save_recetas(recetas: List[Dict]) -> None:
        """Guarda lista de recetas (bulk upsert para sync)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        for r in recetas:
            rid = r.get('id')
            if rid:
                cursor.execute("""
                    UPDATE recetas SET nombre=?, tipo=?, producto_base_id=?, producto_final_id=?,
                    cantidad_producida=?, activo=?, updated_at=?
                    WHERE id=?
                """, (
                    r.get('nombre'), r.get('tipo'),
                    r.get('producto_base_id'), r.get('producto_final_id'),
                    r.get('cantidad_producida', 1),
                    1 if r.get('activo', True) else 0,
                    r.get('updated_at', now), rid
                ))
            else:
                cursor.execute("""
                    INSERT INTO recetas (nombre, tipo, producto_base_id, producto_final_id,
                    cantidad_producida, activo, created_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    r.get('nombre'), r.get('tipo'),
                    r.get('producto_base_id'), r.get('producto_final_id'),
                    r.get('cantidad_producida', 1),
                    1 if r.get('activo', True) else 0,
                    r.get('created_at', now), r.get('updated_at', now)
                ))
        conn.commit()
        conn.close()

    @staticmethod
    def save_receta_componentes(componentes: List[Dict]) -> None:
        """Guarda lista de componentes de receta (bulk upsert para sync)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        for c in componentes:
            cid = c.get('id')
            if cid:
                cursor.execute("""
                    UPDATE receta_componentes SET receta_id=?, producto_id=?, cantidad=?,
                    unidad=?, tipo_componente=? WHERE id=?
                """, (
                    c.get('receta_id'), c.get('producto_id'), c.get('cantidad'),
                    c.get('unidad', 'unidad'), c.get('tipo_componente'), cid
                ))
            else:
                cursor.execute("""
                    INSERT INTO receta_componentes (receta_id, producto_id, cantidad, unidad, tipo_componente)
                    VALUES (?, ?, ?, ?, ?)
                """, (
                    c.get('receta_id'), c.get('producto_id'), c.get('cantidad'),
                    c.get('unidad', 'unidad'), c.get('tipo_componente')
                ))
        conn.commit()
        conn.close()

    @staticmethod
    def save_platos_categorias(categorias: List[Dict]) -> None:
        """Bulk upsert platos_categorias para sync."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        for cat in categorias:
            cid = cat.get('id')
            if cid and cursor.execute("SELECT id FROM platos_categorias WHERE id=?", (cid,)).fetchone():
                cursor.execute("""
                    UPDATE platos_categorias SET nombre=?, color=?, activo=?, updated_at=? WHERE id=?
                """, (cat.get('nombre'), cat.get('color', '#FF6F00'),
                      1 if cat.get('activo', True) else 0, cat.get('updated_at', now), cid))
            else:
                cursor.execute("""
                    INSERT INTO platos_categorias (id, nombre, color, activo, created_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?)
                """, (cid, cat.get('nombre'), cat.get('color', '#FF6F00'),
                      1 if cat.get('activo', True) else 0,
                      cat.get('created_at', now), cat.get('updated_at', now)))
        conn.commit()
        conn.close()

    @staticmethod
    def save_platos(platos: List[Dict]) -> None:
        """Bulk upsert platos para sync."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        for p in platos:
            pid = p.get('id')
            if pid and cursor.execute("SELECT id FROM platos WHERE id=?", (pid,)).fetchone():
                cursor.execute("""
                    UPDATE platos SET nombre=?, categoria_id=?, precio_venta=?, activo=?,
                    es_contorno=?, lleva_contornos=?, updated_at=? WHERE id=?
                """, (
                    p.get('nombre'), p.get('categoria_id'), float(p.get('precio_venta', 0)),
                    1 if p.get('activo', True) else 0,
                    1 if p.get('es_contorno', False) else 0,
                    1 if p.get('lleva_contornos', False) else 0,
                    p.get('updated_at', now), pid
                ))
            else:
                cursor.execute("""
                    INSERT INTO platos (id, nombre, categoria_id, precio_venta, activo,
                    es_contorno, lleva_contornos, created_at, updated_at)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    pid, p.get('nombre'), p.get('categoria_id'), float(p.get('precio_venta', 0)),
                    1 if p.get('activo', True) else 0,
                    1 if p.get('es_contorno', False) else 0,
                    1 if p.get('lleva_contornos', False) else 0,
                    p.get('created_at', now), p.get('updated_at', now)
                ))
        conn.commit()
        conn.close()

    @staticmethod
    def save_plato_ingredientes(ingredientes: List[Dict]) -> None:
        """Bulk upsert plato_ingredientes para sync."""
        conn = get_local_conn()
        cursor = conn.cursor()
        for ing in ingredientes:
            iid = ing.get('id')
            if iid and cursor.execute("SELECT id FROM plato_ingredientes WHERE id=?", (iid,)).fetchone():
                cursor.execute("""
                    UPDATE plato_ingredientes SET plato_id=?, producto_id=?, cantidad=?, unidad=? WHERE id=?
                """, (ing.get('plato_id'), ing.get('producto_id'),
                      float(ing.get('cantidad', 1)), ing.get('unidad', 'unidad'), iid))
            else:
                cursor.execute("""
                    INSERT INTO plato_ingredientes (id, plato_id, producto_id, cantidad, unidad)
                    VALUES (?, ?, ?, ?, ?)
                """, (iid, ing.get('plato_id'), ing.get('producto_id'),
                      float(ing.get('cantidad', 1)), ing.get('unidad', 'unidad')))
        conn.commit()
        conn.close()

    @staticmethod
    def save_plato_contornos_bulk(contornos: List[Dict]) -> None:
        """Bulk upsert plato_contornos para sync."""
        conn = get_local_conn()
        cursor = conn.cursor()
        for c in contornos:
            cid = c.get('id')
            if cid and cursor.execute("SELECT id FROM plato_contornos WHERE id=?", (cid,)).fetchone():
                cursor.execute("""
                    UPDATE plato_contornos SET plato_id=?, contorno_id=?, max_seleccionar=? WHERE id=?
                """, (c.get('plato_id'), c.get('contorno_id'), c.get('max_seleccionar', 2), cid))
            else:
                cursor.execute("""
                    INSERT INTO plato_contornos (id, plato_id, contorno_id, max_seleccionar)
                    VALUES (?, ?, ?, ?)
                """, (cid, c.get('plato_id'), c.get('contorno_id'), c.get('max_seleccionar', 2)))
        conn.commit()
        conn.close()

    @staticmethod
    def save_pos_mesas(mesas: List[Dict]) -> None:
        """Bulk upsert pos_mesas para sync."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        for m in mesas:
            mid = m.get('id')
            if mid and cursor.execute("SELECT id FROM pos_mesas WHERE id=?", (mid,)).fetchone():
                cursor.execute("""
                    UPDATE pos_mesas SET numero=?, nombre=?, zona=?, activo=? WHERE id=?
                """, (m.get('numero'), m.get('nombre'), m.get('zona'),
                      1 if m.get('activo', True) else 0, mid))
            else:
                cursor.execute("""
                    INSERT INTO pos_mesas (id, numero, nombre, zona, activo, creado_en)
                    VALUES (?, ?, ?, ?, ?, ?)
                """, (mid, m.get('numero'), m.get('nombre'), m.get('zona'),
                      1 if m.get('activo', True) else 0, m.get('creado_en', now)))
        conn.commit()
        conn.close()

    @staticmethod
    def save_pos_habitaciones(habitaciones: List[Dict]) -> None:
        """Bulk upsert pos_habitaciones para sync."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        for h in habitaciones:
            hid = h.get('id')
            if hid and cursor.execute("SELECT id FROM pos_habitaciones WHERE id=?", (hid,)).fetchone():
                cursor.execute("""
                    UPDATE pos_habitaciones SET numero=?, piso=?, tipo=?, activo=? WHERE id=?
                """, (h.get('numero'), h.get('piso'), h.get('tipo'),
                      1 if h.get('activo', True) else 0, hid))
            else:
                cursor.execute("""
                    INSERT INTO pos_habitaciones (id, numero, piso, tipo, activo, creado_en)
                    VALUES (?, ?, ?, ?, ?, ?)
                """, (hid, h.get('numero'), h.get('piso'), h.get('tipo'),
                      1 if h.get('activo', True) else 0, h.get('creado_en', now)))
        conn.commit()
        conn.close()

    @staticmethod
    def save_pos_usuarios(usuarios: List[Dict]) -> None:
        """Bulk upsert pos_usuarios para sync."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        for u in usuarios:
            uid = u.get('id')
            if uid and cursor.execute("SELECT id FROM pos_usuarios WHERE id=?", (uid,)).fetchone():
                cursor.execute("""
                    UPDATE pos_usuarios SET nombre=?, pin_hash=?, es_admin=?, activo=? WHERE id=?
                """, (u.get('nombre'), u.get('pin_hash'),
                      1 if u.get('es_admin', False) else 0,
                      1 if u.get('activo', True) else 0, uid))
            else:
                cursor.execute("""
                    INSERT INTO pos_usuarios (id, nombre, pin_hash, es_admin, activo, creado_en)
                    VALUES (?, ?, ?, ?, ?, ?)
                """, (uid, u.get('nombre'), u.get('pin_hash'),
                      1 if u.get('es_admin', False) else 0,
                      1 if u.get('activo', True) else 0, u.get('creado_en', now)))
        conn.commit()
        conn.close()

    @staticmethod
    def get_receta_by_id(receta_id: int) -> Optional[Dict]:
        """Obtiene una receta por ID."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM recetas WHERE id = ?", (receta_id,))
        row = cursor.fetchone()
        conn.close()
        return dict(row) if row else None

    @staticmethod
    def save_receta(receta: Dict) -> int:
        """Guarda una receta y retorna su ID."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        receta_id = receta.get('id')
        if receta_id:
            cursor.execute("""
                UPDATE recetas SET nombre=?, tipo=?, producto_base_id=?, producto_final_id=?,
                cantidad_producida=?, activo=?, updated_at=?
                WHERE id=?
            """, (
                receta.get('nombre'), receta.get('tipo'),
                receta.get('producto_base_id'), receta.get('producto_final_id'),
                receta.get('cantidad_producida', 1),
                1 if receta.get('activo', True) else 0,
                now, receta_id
            ))
        else:
            cursor.execute("""
                INSERT INTO recetas (nombre, tipo, producto_base_id, producto_final_id,
                cantidad_producida, activo, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                receta.get('nombre'), receta.get('tipo'),
                receta.get('producto_base_id'), receta.get('producto_final_id'),
                receta.get('cantidad_producida', 1),
                1 if receta.get('activo', True) else 0,
                now, now
            ))
            receta_id = cursor.lastrowid
        conn.commit()
        conn.close()
        return receta_id

    @staticmethod
    def delete_receta(receta_id: int) -> None:
        """Elimina una receta y sus componentes."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM receta_componentes WHERE receta_id = ?", (receta_id,))
        cursor.execute("DELETE FROM recetas WHERE id = ?", (receta_id,))
        conn.commit()
        conn.close()

    # ==================== PLATOS (tablas separadas de inventario) ====================

    @staticmethod
    def get_platos_categorias(solo_activas: bool = True) -> List[Dict]:
        """Obtiene categorías de platos."""
        conn = get_local_conn()
        cursor = conn.cursor()
        if solo_activas:
            cursor.execute("SELECT * FROM platos_categorias WHERE activo = 1 ORDER BY nombre")
        else:
            cursor.execute("SELECT * FROM platos_categorias ORDER BY nombre")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def save_plato_categoria(cat: Dict) -> int:
        """Crea o actualiza una categoría de plato."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        cid = cat.get('id')
        if cid:
            cursor.execute("""
                UPDATE platos_categorias SET nombre=?, color=?, activo=?, updated_at=? WHERE id=?
            """, (cat.get('nombre'), cat.get('color', '#FF6F00'),
                  1 if cat.get('activo', True) else 0, now, cid))
        else:
            cursor.execute("""
                INSERT INTO platos_categorias (nombre, color, activo, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?)
            """, (cat.get('nombre'), cat.get('color', '#FF6F00'),
                  1 if cat.get('activo', True) else 0, now, now))
            cid = cursor.lastrowid
        conn.commit()
        conn.close()
        return cid

    @staticmethod
    def delete_plato_categoria(cat_id: int) -> None:
        """Elimina una categoría de plato si no tiene platos."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM platos_categorias WHERE id = ?", (cat_id,))
        conn.commit()
        conn.close()

    @staticmethod
    def get_platos() -> List[Dict]:
        """Obtiene todos los platos con su categoría."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT p.id, p.nombre, p.categoria_id, p.precio_venta, p.activo, p.es_contorno, p.lleva_contornos,
                   pc.nombre as categoria_nombre, pc.color as categoria_color
            FROM platos p
            LEFT JOIN platos_categorias pc ON p.categoria_id = pc.id
            ORDER BY p.nombre
        """)
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_plato_with_ingredientes(plato_id: int) -> Optional[Dict]:
        """Obtiene un plato con sus ingredientes."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT p.id, p.nombre, p.categoria_id, p.precio_venta, p.activo, p.es_contorno, p.lleva_contornos,
                   pc.nombre as categoria_nombre, pc.color as categoria_color
            FROM platos p
            LEFT JOIN platos_categorias pc ON p.categoria_id = pc.id
            WHERE p.id = ?
        """, (plato_id,))
        row = cursor.fetchone()
        if not row:
            conn.close()
            return None
        plato = dict(row)
        cursor.execute("""
            SELECT pi.*, pr.nombre as producto_nombre, pr.tipo as producto_tipo
            FROM plato_ingredientes pi
            LEFT JOIN productos pr ON pi.producto_id = pr.id
            WHERE pi.plato_id = ?
            ORDER BY pr.nombre
        """, (plato_id,))
        plato['ingredientes'] = [dict(r) for r in cursor.fetchall()]

        cursor.execute("""
            SELECT pc.contorno_id, pc.max_seleccionar,
                   p.nombre as contorno_nombre, p.precio_venta as contorno_precio
            FROM plato_contornos pc
            INNER JOIN platos p ON pc.contorno_id = p.id
            WHERE pc.plato_id = ?
            ORDER BY p.nombre
        """, (plato_id,))
        plato['contornos'] = [dict(r) for r in cursor.fetchall()]

        conn.close()
        return plato

    @staticmethod
    def get_platos_pos() -> List[Dict]:
        """Obtiene platos activos para mostrar en POS."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT p.id, p.nombre, p.categoria_id, p.precio_venta, p.lleva_contornos,
                   pc.nombre as categoria_nombre, pc.color as categoria_color
            FROM platos p
            INNER JOIN platos_categorias pc ON p.categoria_id = pc.id AND pc.activo = 1
            WHERE p.activo = 1 AND (p.es_contorno IS NULL OR p.es_contorno = 0)
            ORDER BY pc.nombre, p.nombre
        """)
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def save_plato(plato: Dict, ingredientes: List[Dict]) -> int:
        """Crea o actualiza un plato y sus ingredientes."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        plato_id = plato.get('id')

        if plato_id:
            cursor.execute("""
                UPDATE platos SET nombre=?, categoria_id=?, precio_venta=?,
                activo=?, es_contorno=?, lleva_contornos=?, updated_at=? WHERE id=?
            """, (
                plato.get('nombre'), plato.get('categoria_id'),
                float(plato.get('precio_venta', 0)),
                1 if plato.get('activo', True) else 0,
                1 if plato.get('es_contorno', False) else 0,
                1 if plato.get('lleva_contornos', False) else 0, now, plato_id
            ))
        else:
            cursor.execute("""
                INSERT INTO platos (nombre, categoria_id, precio_venta, activo, es_contorno, lleva_contornos, created_at, updated_at)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                plato.get('nombre'), plato.get('categoria_id'),
                float(plato.get('precio_venta', 0)),
                1 if plato.get('activo', True) else 0,
                1 if plato.get('es_contorno', False) else 0,
                1 if plato.get('lleva_contornos', False) else 0, now, now
            ))
            plato_id = cursor.lastrowid

        cursor.execute("DELETE FROM plato_ingredientes WHERE plato_id = ?", (plato_id,))
        for ing in ingredientes:
            cursor.execute("""
                INSERT INTO plato_ingredientes (plato_id, producto_id, cantidad, unidad)
                VALUES (?, ?, ?, ?)
            """, (
                plato_id, ing.get('producto_id'), float(ing.get('cantidad', 1)),
                ing.get('unidad', 'unidad')
            ))

        conn.commit()
        conn.close()
        return plato_id

    @staticmethod
    def delete_plato(plato_id: int) -> None:
        """Elimina un plato y sus ingredientes."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM plato_ingredientes WHERE plato_id = ?", (plato_id,))
        cursor.execute("DELETE FROM plato_contornos WHERE plato_id = ? OR contorno_id = ?", (plato_id, plato_id))
        cursor.execute("DELETE FROM platos WHERE id = ?", (plato_id,))
        conn.commit()
        conn.close()

    # ==================== CONTORNOS ====================

    @staticmethod
    def get_contornos() -> List[Dict]:
        """Obtiene todos los contornos (platos con es_contorno=1)."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT p.id, p.nombre, p.categoria_id, p.precio_venta, p.activo, p.es_contorno,
                   pc.nombre as categoria_nombre, pc.color as categoria_color
            FROM platos p
            LEFT JOIN platos_categorias pc ON p.categoria_id = pc.id
            WHERE p.es_contorno = 1
            ORDER BY p.nombre
        """)
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_contornos_activos() -> List[Dict]:
        """Obtiene contornos activos para POS."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT p.id, p.nombre, p.precio_venta,
                   pc.nombre as categoria_nombre, pc.color as categoria_color
            FROM platos p
            INNER JOIN platos_categorias pc ON p.categoria_id = pc.id AND pc.activo = 1
            WHERE p.activo = 1 AND p.es_contorno = 1
            ORDER BY pc.nombre, p.nombre
        """)
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_plato_contornos(plato_id: int) -> List[Dict]:
        """Obtiene los contornos asignados a un plato."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT pc.id as relacion_id, pc.plato_id, pc.contorno_id, pc.max_seleccionar,
                   p.nombre as contorno_nombre, p.precio_venta as contorno_precio,
                   pc2.nombre as categoria_nombre, pc2.color as categoria_color
            FROM plato_contornos pc
            INNER JOIN platos p ON pc.contorno_id = p.id
            LEFT JOIN platos_categorias pc2 ON p.categoria_id = pc2.id
            WHERE pc.plato_id = ?
            ORDER BY p.nombre
        """, (plato_id,))
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def save_plato_contornos(plato_id: int, contorno_ids: List[int], max_seleccionar: int = 2) -> None:
        """Reemplaza los contornos asignados a un plato."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM plato_contornos WHERE plato_id = ?", (plato_id,))
        for cid in contorno_ids:
            cursor.execute("""
                INSERT INTO plato_contornos (plato_id, contorno_id, max_seleccionar)
                VALUES (?, ?, ?)
            """, (plato_id, cid, max_seleccionar))
        conn.commit()
        conn.close()

    # ==================== RECETA COMPONENTES ====================

    @staticmethod
    def get_componentes_by_receta(receta_id: int) -> List[Dict]:
        """Obtiene los componentes de una receta."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT rc.*, p.nombre as producto_nombre, p.tipo as producto_tipo
            FROM receta_componentes rc
            LEFT JOIN productos p ON rc.producto_id = p.id
            WHERE rc.receta_id = ?
            ORDER BY rc.tipo_componente, p.nombre
        """, (receta_id,))
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def save_componentes(receta_id: int, componentes: List[Dict]) -> None:
        """Reemplaza todos los componentes de una receta."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM receta_componentes WHERE receta_id = ?", (receta_id,))
        for comp in componentes:
            cursor.execute("""
                INSERT INTO receta_componentes (receta_id, producto_id, cantidad, unidad, tipo_componente)
                VALUES (?, ?, ?, ?, ?)
            """, (
                receta_id, comp.get('producto_id'), comp.get('cantidad'),
                comp.get('unidad', 'unidad'), comp.get('tipo_componente')
            ))
        conn.commit()
        conn.close()

    # ==================== PRODUCCIONES ====================

    @staticmethod
    def get_producciones(limit: int = 50) -> List[Dict]:
        """Obtiene el historial de producciones."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT p.*, r.nombre as receta_nombre, r.tipo as receta_tipo
            FROM producciones p
            LEFT JOIN recetas r ON p.receta_id = r.id
            ORDER BY p.fecha_produccion DESC
            LIMIT ?
        """, (limit,))
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def save_produccion(produccion: Dict) -> int:
        """Guarda una producción y retorna su ID."""
        conn = get_local_conn()
        cursor = conn.cursor()
        now = datetime.now().isoformat()
        cursor.execute("""
            INSERT INTO producciones (receta_id, cantidad, estado, usuario, observaciones, fecha_produccion, created_at)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """, (
            produccion.get('receta_id'), produccion.get('cantidad'),
            produccion.get('estado', 'completado'), produccion.get('usuario'),
            produccion.get('observaciones'), produccion.get('fecha_produccion', now), now
        ))
        prod_id = cursor.lastrowid
        conn.commit()
        conn.close()
        return prod_id

    @staticmethod
    def save_produccion_detalle(detalle: Dict) -> int:
        """Guarda un detalle de producción."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO produccion_detalles (produccion_id, producto_id, tipo, cantidad, unidad, movimiento_id)
            VALUES (?, ?, ?, ?, ?, ?)
        """, (
            detalle.get('produccion_id'), detalle.get('producto_id'),
            detalle.get('tipo'), detalle.get('cantidad'),
            detalle.get('unidad', 'unidad'), detalle.get('movimiento_id')
        ))
        det_id = cursor.lastrowid
        conn.commit()
        conn.close()
        return det_id

    @staticmethod
    def get_detalles_by_produccion(produccion_id: int) -> List[Dict]:
        """Obtiene los detalles de una producción."""
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT pd.*, p.nombre as producto_nombre
            FROM produccion_detalles pd
            LEFT JOIN productos p ON pd.producto_id = p.id
            WHERE pd.produccion_id = ?
            ORDER BY pd.tipo, p.nombre
        """, (produccion_id,))
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def get_periodos() -> List[Dict]:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM periodos ORDER BY periodo DESC")
        rows = cursor.fetchall()
        conn.close()
        return [dict(row) for row in rows]

    @staticmethod
    def crear_periodo(periodo: str, registrado_por: str = None) -> bool:
        conn = get_local_conn()
        cursor = conn.cursor()
        try:
            cursor.execute(
                "INSERT INTO periodos (periodo, fecha_apertura, registrado_por) VALUES (?, ?, ?)",
                (periodo, datetime.now().isoformat(), registrado_por or "sistema")
            )
            conn.commit()
            return True
        except Exception:
            return False
        finally:
            conn.close()

    @staticmethod
    def periodo_existe(periodo: str) -> bool:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT id FROM periodos WHERE periodo = ?", (periodo,))
        existe = cursor.fetchone() is not None
        conn.close()
        return existe

    @staticmethod
    def clear_periodos() -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM periodos")
        conn.commit()
        conn.close()

    # ==================== STOCK CHECKPOINT ====================

    @staticmethod
    def save_checkpoints() -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM stock_checkpoint")
        cursor.execute("""
            INSERT INTO stock_checkpoint (producto_id, almacen, cantidad)
            SELECT producto_id, almacen, cantidad FROM existencias
        """)
        conn.commit()
        conn.close()

    @staticmethod
    def get_checkpoints() -> Dict:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("SELECT producto_id, almacen, cantidad FROM stock_checkpoint")
        rows = cursor.fetchall()
        conn.close()
        return {(r['producto_id'], r['almacen']): r['cantidad'] for r in rows}

    @staticmethod
    def clear_checkpoints() -> None:
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM stock_checkpoint")
        conn.commit()
        conn.close()

    @staticmethod
    def save_stock_checkpoints(data: list) -> None:
        if not data:
            return
        conn = get_local_conn()
        cursor = conn.cursor()
        cursor.execute("DELETE FROM stock_checkpoint")
        for row in data:
            cursor.execute(
                "INSERT OR REPLACE INTO stock_checkpoint (producto_id, almacen, cantidad) VALUES (?, ?, ?)",
                (row.get('producto_id'), row.get('almacen'), row.get('cantidad', 0))
            )
        conn.commit()
        conn.close()


def ensure_local_db():
    """Asegura que la BD local existe. Llamar después de set_db_path()."""
    from usr.logger import get_logger
    logger = get_logger("local_replica")
    try:
        logger.info("Inicializando base de datos local...")
        init_local_db()
        logger.info("Base de datos local inicializada")
    except Exception as e:
        logger.error(f"Error al inicializar BD: {e}")
        raise
