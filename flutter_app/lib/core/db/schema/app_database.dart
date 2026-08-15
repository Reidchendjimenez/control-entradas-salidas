import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

import 'tables.dart';

export 'tables.dart';

part 'app_database.g.dart';

/// Base de datos local (drift/SQLite) — réplica de `usr/database/local_replica.py`.
///
/// Cada tabla replica columnas con los mismos nombres que Supabase para que la
/// sincronización haga upsert 1:1 (ver `sync.py` `tables_to_sync`). Tipos:
/// INTEGER���bool (0/1), REAL para cantidades, TEXT para fechas ISO.
///
/// Nota: drift genera automáticamente el campo `id` de las tablas con
/// `integer().autoIncrement()`. Los upsert usan `REPLACE` vía `insertOnConflictUpdate`.
@DriftDatabase(tables: [
  Categorias,
  Productos,
  Proveedores,
  Existencias,
  Movimientos,
  MovimientosArchivo,
  Facturas,
  FacturaPagos,
  Requisiciones,
  RequisicionDetalles,
  StockCheckpoint,
  Periodos,
  Recetas,
  RecetaComponentes,
  Producciones,
  ProduccionDetalles,
  ComprasLista,
  SyncQueue,
  SyncMetadata,
  DispositivoUsuario,
  WhatsappQueue,
  Temporales,
  PosUsuarios,
  PosMesas,
  PosHabitaciones,
  PosSesiones,
  PosComandas,
  PosVentas,
  PosSettings,
  PosCategorias,
  PlatosCategorias,
  Platos,
  PlatoIngredientes,
  PlatoContornos,
  PosSyncTombstones,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() {
    if (kIsWeb) {
      return driftDatabase(
        name: 'control_entradas_salidas',
        // Assets WASM descargados en web/ (ver https://drift.simonbinder.eu/web/).
        web: DriftWebOptions(
          sqlite3Wasm: Uri.parse('sqlite3.wasm'),
          driftWorker: Uri.parse('drift_worker.js'),
        ),
      );
    }
    return driftDatabase(name: 'control_entradas_salidas');
  }

  /// Base en memoria para tests.
  AppDatabase.forTesting(super.executor);

  /// Réplica de `LocalReplica.init_queue()` en sync_queue.py.
  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 → v2: agrega whatsapp_queue (cola local de WhatsApp).
            await m.createAll();
          }
          if (from < 3) {
            // v2 → v3: repara `existencias` duplicadas. Cada upsert anterior
            // insertaba una fila nueva (no había UNIQUE en producto_id+almacen),
            // así que puede haber varias por (producto, almacén). Se conserva la
            // de mayor id (último estado) y se borran las demás.
            await m.database.customStatement('''
              DELETE FROM existencias
              WHERE id NOT IN (
                SELECT MAX(id) FROM existencias
                GROUP BY producto_id, almacen
              )
            ''');
          }
          if (from < 4) {
            // v3 → v4: agrega `temporales` (imágenes pre-cargadas de
            // Validación, solo local).
            await m.createTable(temporales);
          }
          if (from < 5) {
            // v4 → v5: agrega las tablas del módulo POS (pos_* y platos_*).
            // Sincronización por sync_uuid (ver pos_sync_engine.dart).
            await m.createAll();
          }
        },
      );
}