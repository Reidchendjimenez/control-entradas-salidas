import 'package:drift/drift.dart';

import 'db_executor.dart';
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
      : super(executor ?? openDbExecutor());

  /// Base en memoria para tests.
  AppDatabase.forTesting(super.executor);

  /// Réplica de `LocalReplica.init_queue()` en sync_queue.py.
  @override
  int get schemaVersion => 9;

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
          if (from < 6) {
            // v5 → v6: turnos con caja (flujo de cajas/turnos): columnas de
            // monto inicial/final, sync_uuid y fechas en `pos_sesiones`.
            await m.addColumn(posSesiones, posSesiones.cajaInicial);
            await m.addColumn(posSesiones, posSesiones.cajaFinal);
            await m.addColumn(posSesiones, posSesiones.syncUuid);
            await m.addColumn(posSesiones, posSesiones.createdAt);
            await m.addColumn(posSesiones, posSesiones.updatedAt);
          }
          if (from < 7) {
            // v6 → v7: `updated_at` en catálogos POS chicos (mesas,
            // habitaciones, usuarios) para descarga incremental por cambios.
            await m.addColumn(posMesas, posMesas.updatedAt);
            await m.addColumn(posHabitaciones, posHabitaciones.updatedAt);
            await m.addColumn(posUsuarios, posUsuarios.updatedAt);
          }
          if (from < 8) {
            // v7 → v8: `es_desarrollador` en pos_usuarios: usuario que inicia
            // sesión sin aperturar turno/caja (desarrollo y diagnostico).
            await m.addColumn(posUsuarios, posUsuarios.esDesarrollador);
          }
          if (from < 9) {
            // v8 → v9: agrega UNIQUE(producto_id, almacen) a `existencias`.
            // Primero limpia duplicados (conserva el de mayor id) y luego
            // recrea la tabla con la constraint.
            await m.database.customStatement('''
              DELETE FROM existencias
              WHERE id NOT IN (
                SELECT MAX(id) FROM existencias
                GROUP BY producto_id, almacen
              )
            ''');
            await m.deleteTable('existencias');
            await m.createTable(existencias);
          }
        },
      );
}