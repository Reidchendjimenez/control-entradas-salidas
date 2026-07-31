"""
Script único para migrar datos POS existentes a Supabase.
Agrega todos los datos locales de POS a la cola de sync
y fuerza la sincronización inmediata.

Ejecutar UNA SOLA VEZ:
    python migrar_pos_a_supabase.py
"""
import os
import sys
import json

_app_dir = os.path.dirname(os.path.abspath(__file__))
if _app_dir not in sys.path:
    sys.path.insert(0, _app_dir)

os.environ['LYCORIS_DB_PATH'] = os.path.join(_app_dir, "lycoris_local.db")

from usr.database.local_replica import LocalReplica
from usr.database.sync_queue import get_sync_queue
from usr.database.sync import get_sync_manager
from usr.database.base import get_engine

# 1. Agregar datos locales a la cola de sync
queue = get_sync_queue()
count = 0

for table_name, records_fn in [
    ('pos_mesas', lambda: LocalReplica.get_pos_mesas()),
    ('pos_habitaciones', lambda: LocalReplica.get_pos_habitaciones()),
    ('pos_usuarios', lambda: LocalReplica.get_pos_usuarios()),
    ('platos_categorias', lambda: LocalReplica.get_platos_categorias(solo_activas=False)),
]:
    for r in records_fn():
        queue.add_pending(table_name, 'upsert', r)
        count += 1

# Platos con sus ingredientes y contornos
from usr.database.conn import get_local_conn
conn = get_local_conn()
cursor = conn.cursor()

for p in LocalReplica.get_platos():
    queue.add_pending('platos', 'upsert', p)
    count += 1
    # Ingredientes de cada plato
    cursor.execute("SELECT * FROM plato_ingredientes WHERE plato_id = ?", (p['id'],))
    for ing in cursor.fetchall():
        queue.add_pending('plato_ingredientes', 'insert', dict(ing))
        count += 1
    # Contornos de cada plato
    cursor.execute("SELECT * FROM plato_contornos WHERE plato_id = ?", (p['id'],))
    for c in cursor.fetchall():
        queue.add_pending('plato_contornos', 'insert', dict(c))
        count += 1

conn.close()

print(f"✅ {count} registros agregados a la cola de sincronización")

# 2. Forzar sincronización inmediata
sync_mgr = get_sync_manager()
if sync_mgr is None:
    from usr.database.sync import init_sync_manager
    init_sync_manager(get_engine)
    sync_mgr = get_sync_manager()

print(f"Conectando con Supabase...")
online = sync_mgr.check_connection()
print(f"Online: {online}")

if online:
    print("Subiendo datos a Supabase...")
    sync_mgr.full_sync()
    print("✅ Sincronización completada")
else:
    print("⚠️  No hay conexión con Supabase. Los datos se subirán automaticamente")
    print("   cuando la aplicación se inicie con conexión a internet.")
    print(f"   Pendientes en cola: {count}")