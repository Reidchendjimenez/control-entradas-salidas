import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/schema/app_database.dart';

/// Tablas del módulo POS gestionadas por `PosSyncEngine` (port de `_POS_TABLES`
/// en `usr/database/pos_sync.py`). Las tablas `pos_*`/`platos_*` NO las procesa
/// el motor de sync general (ver `sync_engine.dart`).
const Set<String> posTableNames = {
  'platos_categorias',
  'platos',
  'plato_ingredientes',
  'plato_contornos',
  'pos_categorias',
  'pos_mesas',
  'pos_habitaciones',
  'pos_usuarios',
  'pos_settings',
  'pos_comandas',
  'pos_ventas',
};

typedef _PosTableDesc = ({
  String serverTable,
  bool poda,
  String? dedupeKey,
});

const List<_PosTableDesc> _posTables = [
  (serverTable: 'platos_categorias', poda: true, dedupeKey: 'nombre'),
  (serverTable: 'platos', poda: true, dedupeKey: null),
  (serverTable: 'plato_ingredientes', poda: false, dedupeKey: null),
  (serverTable: 'plato_contornos', poda: false, dedupeKey: null),
  (serverTable: 'pos_categorias', poda: true, dedupeKey: 'nombre'),
  (serverTable: 'pos_mesas', poda: true, dedupeKey: null),
  (serverTable: 'pos_habitaciones', poda: true, dedupeKey: null),
  (serverTable: 'pos_usuarios', poda: true, dedupeKey: null),
  (serverTable: 'pos_settings', poda: false, dedupeKey: null),
  (serverTable: 'pos_comandas', poda: false, dedupeKey: null),
  (serverTable: 'pos_ventas', poda: false, dedupeKey: null),
];

/// Motor de sincronización del módulo POS — puerto de `POSSyncManager` en
/// `usr/database/pos_sync.py`.
///
/// Diferencias con `SyncEngine` (el general):
/// - La subida de comandas/ventas se empareja por `sync_uuid` (los ids locales
///   no valen en otros dispositivos).
/// - Se excluyen de la cola general (`pos_*`), igual que en sync.py:668.
/// - Las categorías/productos para la venta y los movimientos los gestiona el
///   sync general (la app siempre lo ejecuta); aquí solo bajan las 11 tablas
///   `pos_*`/`platos_*` con poda de huérfanos (pos_sync.py `_download_all`).
/// - Los movimientos de venta/devolución también los sube el sync general
///   (ya inserta `venta_sync_uuid`), así que no se duplican aquí.
class PosSyncEngine {
  PosSyncEngine({required AppDatabase db, required this.client}) : _db = db;

  final AppDatabase _db;
  final SupabaseClient client;

  bool _running = false;
  Timer? _timer;
  void Function(String message)? onProgress;

  void _log(String msg) => onProgress?.call(msg);

  // ---------------------------------------------------------------------
  // Ciclo completo
  // ---------------------------------------------------------------------

  Future<bool> fullSync() async {
    if (_running) return false;
    _running = true;
    try {
      await _processOutbox();
      await _downloadAllFromServer();
      return true;
    } catch (e) {
      _log('Error en sync POS: $e');
      return false;
    } finally {
      _running = false;
    }
  }

  /// Réplica de `start_background_sync` (pos_sync.py): primer ciclo tras el
  /// intervalo (el arranque dispara el fullSync manual).
  void startBackgroundSync({int intervalSeconds = 30}) {
    _timer ??= Timer.periodic(Duration(seconds: intervalSeconds), (_) async {
      try {
        await _processOutbox();
        await _downloadAllFromServer();
      } catch (e) {
        _log('Error en sync loop POS: $e');
      }
    });
  }

  void stopBackgroundSync() {
    _timer?.cancel();
    _timer = null;
  }

  // ---------------------------------------------------------------------
  // Descarga (pos_sync.py `_download_all_from_server`)
  // ---------------------------------------------------------------------

  Future<void> _downloadAllFromServer() async {
    for (final t in _posTables) {
      try {
        await _descargarTabla(t);
      } catch (e) {
        _log('Error descargando ${t.serverTable}: $e');
      }
    }
    // Restaura movimientos.venta_id desde venta_sync_uuid (relink_ventas_movimientos).
    try {
      await _db.customStatement('''
        UPDATE movimientos SET venta_id = (
          SELECT pv.id FROM pos_ventas pv WHERE pv.sync_uuid = movimientos.venta_sync_uuid
        )
        WHERE venta_sync_uuid IS NOT NULL AND venta_sync_uuid != ''
      ''');
    } catch (e) {
      _log('Error relink ventas-movimientos: $e');
    }
  }

  Future<void> _descargarTabla(_PosTableDesc t) async {
    final table = t.serverTable;

    if (table == 'pos_settings') {
      await _descargarSettings();
      return;
    }

    // Descarga completa (tablas pequeñas). Las ventas/comandas se upsertan por
    // sync_uuid (los ids locales no coinciden entre dispositivos).
    final remoteIds = <int>[];
    final filtro = client.from(table).select();
    PostgrestTransformBuilder<List<Map<String, dynamic>>> q =
        filtro.order('id', ascending: true);
    const pageSize = 1000;
    var offset = 0;
    while (true) {
      final data = await q.range(offset, offset + pageSize - 1);
      final rows = (data as List).cast<Map<String, dynamic>>();
      if (rows.isEmpty) break;
      for (final r in rows) {
        final id = _toInt(r['id']);
        if (id != null) remoteIds.add(id);
        await _upsertFilaLocal(table, r);
      }
      offset += pageSize;
    }
    _log('$table descargado');

    // Podar huérfanos (delete_orphaned_records): solo si el server devolvió
    // filas; conserva lo pendiente de subir en la cola.
    if (t.poda && remoteIds.isNotEmpty) {
      await _podarHuerfanos(table, remoteIds, t.dedupeKey);
    }
  }

  /// Upsert local por id (tablas platos_*/pos_* de escritura directa).
  Future<void> _upsertFilaLocal(String table, Map<String, dynamic> r) async {
    final id = _toInt(r['id']);
    switch (table) {
      case 'platos_categorias':
        await _db.into(_db.platosCategorias).insertOnConflictUpdate(
              PlatosCategoriasCompanion.insert(
                id: Value(id ?? 0),
                nombre: (r['nombre'] as String?) ?? '',
                color: Value(r['color'] as String? ?? '#FF6F00'),
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                categoriaPadreId: Value(_toInt(r['categoria_padre_id'])),
                posCategoriaPadreId: Value(_toInt(r['pos_categoria_padre_id'])),
                createdAt: Value(_toDt(r['created_at'])),
                updatedAt: Value(_toDt(r['updated_at'])),
              ),
            );
      case 'platos':
        await _db.into(_db.platos).insertOnConflictUpdate(
              PlatosCompanion.insert(
                id: Value(id ?? 0),
                nombre: (r['nombre'] as String?) ?? '',
                categoriaId: _toInt(r['categoria_id']) ?? 0,
                precioVenta: Value(_toDouble(r['precio_venta']) ?? 0),
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                esContorno: Value(_toBoolInt(r['es_contorno'])),
                llevaContornos: Value(_toBoolInt(r['lleva_contornos'])),
                createdAt: Value(_toDt(r['created_at'])),
                updatedAt: Value(_toDt(r['updated_at'])),
              ),
            );
      case 'plato_ingredientes':
        await _db.into(_db.platoIngredientes).insertOnConflictUpdate(
              PlatoIngredientesCompanion.insert(
                id: Value(id ?? 0),
                platoId: _toInt(r['plato_id']) ?? 0,
                productoId: _toInt(r['producto_id']) ?? 0,
                cantidad: _toDouble(r['cantidad']) ?? 1,
                unidad: Value(r['unidad'] as String? ?? 'unidad'),
              ),
            );
      case 'plato_contornos':
        await _db.into(_db.platoContornos).insertOnConflictUpdate(
              PlatoContornosCompanion.insert(
                id: Value(id ?? 0),
                platoId: _toInt(r['plato_id']) ?? 0,
                contornoId: _toInt(r['contorno_id']) ?? 0,
                maxSeleccionar: Value(_toInt(r['max_seleccionar']) ?? 2),
              ),
            );
      case 'pos_categorias':
        await _db.into(_db.posCategorias).insertOnConflictUpdate(
              PosCategoriasCompanion.insert(
                id: Value(id ?? 0),
                nombre: (r['nombre'] as String?) ?? '',
                color: Value(r['color'] as String? ?? '#FF6F00'),
                icono: Value(r['icono'] as String?),
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                syncUuid: Value(r['sync_uuid'] as String?),
                createdAt: Value(_toDt(r['created_at'])),
                updatedAt: Value(_toDt(r['updated_at'])),
              ),
            );
      case 'pos_mesas':
        await _db.into(_db.posMesas).insertOnConflictUpdate(
              PosMesasCompanion.insert(
                id: Value(id ?? 0),
                numero: (r['numero'] as String?) ?? '',
                nombre: Value(r['nombre'] as String?),
                zona: Value(r['zona'] as String?),
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                creadoEn: _toDt(r['creado_en']) ?? DateTime.now(),
              ),
            );
      case 'pos_habitaciones':
        await _db.into(_db.posHabitaciones).insertOnConflictUpdate(
              PosHabitacionesCompanion.insert(
                id: Value(id ?? 0),
                numero: (r['numero'] as String?) ?? '',
                piso: Value(r['piso'] as String?),
                tipo: Value(r['tipo'] as String?),
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                creadoEn: _toDt(r['creado_en']) ?? DateTime.now(),
              ),
            );
      case 'pos_usuarios':
        await _db.into(_db.posUsuarios).insertOnConflictUpdate(
              PosUsuariosCompanion.insert(
                id: Value(id ?? 0),
                nombre: (r['nombre'] as String?) ?? '',
                pinHash: Value(r['pin_hash'] as String?),
                esAdmin: Value(_toBoolInt(r['es_admin'])),
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                creadoEn: _toDt(r['creado_en']) ?? DateTime.now(),
              ),
            );
      case 'pos_comandas':
        // Upsert por sync_uuid, respetando tombstones (save_comandas_sync).
        final su = (r['sync_uuid'] as String?)?.trim() ?? '';
        if (su.isEmpty) return;
        if (await _esTombstone(su, 'pos_comandas')) return;
        final existing = await (_db.select(_db.posComandas)
              ..where((t) => t.syncUuid.equals(su)))
            .getSingleOrNull();
        if (existing != null) {
          await (_db.update(_db.posComandas)..where((t) => t.id.equals(existing.id)))
              .write(PosComandasCompanion(
                sesionId: Value(_toInt(r['sesion_id']) ?? 0),
                mesaId: Value(_toInt(r['mesa_id'])),
                habitacionId: Value(_toInt(r['habitacion_id'])),
                estado: Value(r['estado'] as String? ?? 'abierta'),
                total: Value(_toDouble(r['total']) ?? 0),
                itemsJson: Value(r['items_json'] as String?),
                updatedAt: Value(_toDt(r['updated_at'])),
              ));
        } else {
          await _db.into(_db.posComandas).insert(
                PosComandasCompanion.insert(
                  sesionId: _toInt(r['sesion_id']) ?? 0,
                  mesaId: Value(_toInt(r['mesa_id'])),
                  habitacionId: Value(_toInt(r['habitacion_id'])),
                  estado: Value(r['estado'] as String? ?? 'abierta'),
                  total: Value(_toDouble(r['total']) ?? 0),
                  itemsJson: Value(r['items_json'] as String?),
                  syncUuid: Value(su),
                  createdAt: _toDt(r['created_at']) ?? DateTime.now(),
                  updatedAt: Value(_toDt(r['updated_at'])),
                ),
              );
        }
      case 'pos_ventas':
        // Upsert por sync_uuid con last-writer-wins por updated_at y resolución
        // de comanda_id/venta_anula_id (save_ventas_sync).
        final su = (r['sync_uuid'] as String?)?.trim() ?? '';
        if (su.isEmpty) return;
        if (await _esTombstone(su, 'pos_ventas')) return;
        final existing = await (_db.select(_db.posVentas)
              ..where((t) => t.syncUuid.equals(su)))
            .getSingleOrNull();
        final upd = r['updated_at'] as String?;
        final localUpd = existing?.updatedAt?.toUtc().toIso8601String();
        if (existing != null && upd != null && localUpd != null && upd.compareTo(localUpd) < 0) {
          return;
        }
        final comandaId = await _resolveComandaId(r['comanda_sync_uuid'] as String?);
        final ventaAnulaId = await _resolveVentaAnulaId(r['venta_anula_sync_uuid'] as String?);
        if (existing != null) {
          await (_db.update(_db.posVentas)..where((t) => t.id.equals(existing.id)))
              .write(PosVentasCompanion(
                comandaId: Value(comandaId),
                correlativo: Value(_toInt(r['correlativo'])),
                total: Value(_toDouble(r['total']) ?? 0),
                itemsJson: Value(r['items_json'] as String?),
                mesaId: Value(_toInt(r['mesa_id'])),
                habitacionId: Value(_toInt(r['habitacion_id'])),
                usuarioId: Value(_toInt(r['usuario_id'])),
                sesionId: Value(_toInt(r['sesion_id']) ?? 0),
                estado: Value(r['estado'] as String? ?? 'vigente'),
                ventaAnulaId: Value(ventaAnulaId),
                motivoAnulacion: Value(r['motivo_anulacion'] as String?),
                anuladaPor: Value(r['anulada_por'] as String?),
                anuladaEn: Value(_toDt(r['anulada_en'])),
                tasaBs: Value(_toDouble(r['tasa_bs'])),
                comandaSyncUuid: Value(r['comanda_sync_uuid'] as String?),
                ventaAnulaSyncUuid: Value(r['venta_anula_sync_uuid'] as String?),
                updatedAt: Value(_toDt(r['updated_at'])),
              ));
        } else {
          await _db.into(_db.posVentas).insert(
                PosVentasCompanion.insert(
                  comandaId: Value(comandaId),
                  correlativo: Value(_toInt(r['correlativo'])),
                  total: Value(_toDouble(r['total']) ?? 0),
                  itemsJson: Value(r['items_json'] as String?),
                  mesaId: Value(_toInt(r['mesa_id'])),
                  habitacionId: Value(_toInt(r['habitacion_id'])),
                  usuarioId: Value(_toInt(r['usuario_id'])),
                  sesionId: Value(_toInt(r['sesion_id']) ?? 0),
                  estado: Value(r['estado'] as String? ?? 'vigente'),
                  ventaAnulaId: Value(ventaAnulaId),
                  motivoAnulacion: Value(r['motivo_anulacion'] as String?),
                  anuladaPor: Value(r['anulada_por'] as String?),
                  anuladaEn: Value(_toDt(r['anulada_en'])),
                  tasaBs: Value(_toDouble(r['tasa_bs'])),
                  syncUuid: Value(su),
                  comandaSyncUuid: Value(r['comanda_sync_uuid'] as String?),
                  ventaAnulaSyncUuid: Value(r['venta_anula_sync_uuid'] as String?),
                  createdAt: _toDt(r['created_at']) ?? DateTime.now(),
                  updatedAt: Value(_toDt(r['updated_at'])),
                ),
              );
        }
    }
  }

  /// pos_settings: no sobrescribe claves pendientes de subir ni la tasa BCV
  /// (la local la obtiene de la API y puede estar más actualizada).
  Future<void> _descargarSettings() async {
    final pendingKeys = <String>{};
    final pendientes = await (_db.select(_db.syncQueue)
          ..where((t) => t.targetTable.equals('pos_settings') & t.status.equals('pending')))
        .get();
    for (final p in pendientes) {
      try {
        final data = jsonDecode(p.data) as Map<String, dynamic>;
        if (data['key'] != null) pendingKeys.add(data['key'].toString());
      } catch (_) {}
    }
    final filtro = client.from('pos_settings').select();
    final rows = (await filtro).cast<Map<String, dynamic>>();
    var count = 0;
    for (final r in rows) {
      final key = r['key'] as String?;
      if (key == null) continue;
      if (pendingKeys.contains(key)) continue;
      if (key == 'tasa_cambio' || key == 'tasa_cambio_actualizada_en') continue;
      await _db.into(_db.posSettings).insertOnConflictUpdate(
            PosSettingsCompanion.insert(
              key: key,
              value: Value(r['value'] as String?),
            ),
          );
      count++;
    }
    _log('$count pos_settings descargados');
  }

  Future<bool> _esTombstone(String su, String tabla) async {
    final t = await (_db.select(_db.posSyncTombstones)
          ..where((r) => r.uuid.equals(su) & r.tabla.equals(tabla)))
        .getSingleOrNull();
    return t != null;
  }

  Future<int?> _resolveComandaId(String? csync) async {
    if (csync == null || csync.trim().isEmpty) return null;
    final c = await (_db.select(_db.posComandas)
          ..where((t) => t.syncUuid.equals(csync.trim())))
        .getSingleOrNull();
    return c?.id;
  }

  Future<int?> _resolveVentaAnulaId(String? vsync) async {
    if (vsync == null || vsync.trim().isEmpty) return null;
    final v = await (_db.select(_db.posVentas)
          ..where((t) => t.syncUuid.equals(vsync.trim())))
        .getSingleOrNull();
    return v?.id;
  }

  /// Elimina locales que ya no existen en el server y no están pendientes de
  /// subir (delete_orphaned_records). Con dedupeKey se conserva además lo que
  /// tenga ese valor pendiente en la cola (creaciones locales en curso).
  Future<void> _podarHuerfanos(
    String table,
    List<int> remoteIds,
    String? dedupeKey,
  ) async {
    final pendientes = await (_db.select(_db.syncQueue)
          ..where((t) => t.targetTable.equals(table) & t.status.equals('pending')))
        .get();
    final pendingIds = <int>{};
    final pendingKeys = <String>{};
    for (final p in pendientes) {
      try {
        final data = jsonDecode(p.data) as Map<String, dynamic>;
        final pid = _toInt(data['id']);
        if (pid != null) pendingIds.add(pid);
        final k = data[dedupeKey];
        if (dedupeKey != null && k != null) pendingKeys.add(k.toString());
      } catch (_) {}
    }
    try {
      final idExpr = remoteIds.join(',');
      final excl = [
        'id NOT IN ($idExpr)',
        if (pendingIds.isNotEmpty) 'id NOT IN (${pendingIds.join(',')})',
      ].join(' AND ');
      final extra = (dedupeKey != null && pendingKeys.isNotEmpty)
          ? " AND $dedupeKey NOT IN ('${pendingKeys.join("','")}')"
          : '';
      await _db.customStatement('DELETE FROM $table WHERE $excl$extra');
    } catch (e) {
      _log('Error podando $table: $e');
    }
  }

  // ---------------------------------------------------------------------
  // Subida del outbox (pos_sync.py `_upload_to_remote`)
  // ---------------------------------------------------------------------

  Future<int> _processOutbox() async {
    final pending = await (_db.select(_db.syncQueue)
          ..where((t) => t.status.equals('pending') & t.targetTable.isIn(posTableNames)))
        .get();
    if (pending.isEmpty) return 0;

    var uploaded = 0;
    for (final item in pending) {
      try {
        final data = jsonDecode(item.data) as Map<String, dynamic>;
        final table = item.targetTable;
        final op = item.operation;
        await _uploadItem(table, data, op);
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(item.id)))
            .write(const SyncQueueCompanion(status: Value('completed')));
        uploaded++;
        _log('$table sincronizado');
      } catch (e) {
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(item.id)))
            .write(SyncQueueCompanion(
              status: const Value('failed'),
              retries: Value(item.retries + 1),
              lastError: Value(e.toString()),
            ));
        _log('Error subiendo ${item.targetTable}: $e');
      }
    }
    return uploaded;
  }

  Future<void> _uploadItem(String table, Map<String, dynamic> data, String op) async {
    switch (table) {
      case 'pos_comandas':
        await _subirPorSyncUuid('pos_comandas', data, op, ['sesion_id', 'mesa_id',
            'habitacion_id', 'estado', 'total', 'items_json']);
      case 'pos_ventas':
        await _subirPorSyncUuid('pos_ventas', data, op, ['comanda_sync_uuid',
            'venta_anula_sync_uuid', 'correlativo', 'total', 'items_json', 'mesa_id',
            'habitacion_id', 'usuario_id', 'sesion_id', 'estado', 'motivo_anulacion',
            'anulada_por', 'anulada_en', 'tasa_bs']);
      case 'pos_settings':
        final key = data['key']?.toString();
        if (key == null || key.isEmpty) return;
        final existing = await client
            .from('pos_settings')
            .select('key')
            .eq('key', key)
            .limit(1)
            .maybeSingle();
        final payload = {
          'key': key,
          'value': data['value']?.toString() ?? '',
        };
        if (existing != null) {
          await client.from('pos_settings').update(payload).eq('key', key);
        } else {
          await client.from('pos_settings').insert(payload);
        }
      case 'plato_ingredientes':
      case 'plato_contornos':
        // Pueden subirse sin id (nuevos); con id → upsert por id.
        await _upsertPorId(table, data, insertarSinId: true);
      default:
        await _upsertPorId(table, data, insertarSinId: false);
    }
  }

  /// Upsert remoto por id local (pos_sync.py: cada tabla hace SELECT por id y
  /// luego UPDATE/INSERT conservando el id).
  Future<void> _upsertPorId(
    String table,
    Map<String, dynamic> data, {
    required bool insertarSinId,
  }) async {
    final id = _toInt(data['id']);
    if (id == null && !insertarSinId) {
      await client.from(table).insert(data);
      return;
    }
    if (id != null) {
      final existing = await client
          .from(table)
          .select('id')
          .eq('id', id)
          .limit(1)
          .maybeSingle();
      if (existing != null) {
        final upd = Map<String, dynamic>.from(data)..remove('id');
        await client.from(table).update(upd).eq('id', id);
        return;
      }
    }
    await client.from(table).insert(data);
  }

  /// Comandas/ventas: upsert o borrado remoto emparejado por `sync_uuid`.
  Future<void> _subirPorSyncUuid(
    String table,
    Map<String, dynamic> data,
    String op,
    List<String> campos,
  ) async {
    final su = (data['sync_uuid']?.toString() ?? '').trim();
    if (su.isEmpty) throw ArgumentError('$table sin sync_uuid');

    if (op == 'delete') {
      await client.from(table).delete().eq('sync_uuid', su);
      return;
    }

    final existing = await client
        .from(table)
        .select('id')
        .eq('sync_uuid', su)
        .limit(1)
        .maybeSingle();

    final payload = <String, dynamic>{
      'sync_uuid': su,
      'created_at': data['created_at'] ?? data['updated_at'],
      'updated_at': data['updated_at'],
      for (final c in campos) c: data[c],
    };
    if (existing != null) {
      final upd = Map<String, dynamic>.from(payload)..remove('sync_uuid');
      await client.from(table).update(upd).eq('id', existing['id']);
    } else {
      await client.from(table).insert(payload);
    }
  }

  // ---------------------------------------------------------------------
  // Helpers de conversión
  // ---------------------------------------------------------------------

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static DateTime? _toDt(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  static int _toBoolInt(dynamic v, {int def = 0}) {
    if (v == null) return def;
    if (v is bool) return v ? 1 : 0;
    if (v is num) return v == 0 ? 0 : 1;
    return v.toString() == 'true' || v.toString() == '1' ? 1 : 0;
  }
}
