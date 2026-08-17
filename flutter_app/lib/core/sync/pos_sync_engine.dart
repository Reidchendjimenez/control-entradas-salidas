import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/schema/app_database.dart';
import 'sync_engine.dart';

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
  'pos_sesiones',
  'pos_comandas',
  'pos_ventas',
};

typedef _PosTableDesc = ({
  String serverTable,
  bool poda,
  String? dedupeKey,
  String? incrementalColumn,
});

const List<_PosTableDesc> _posTables = [
  // Catálogos con `updated_at`: descarga incremental (misma mejora que el
  // sync general, sync_engine.dart:594). Se podan con una consulta ligera de
  // ids cuando el ciclo es incremental.
  (serverTable: 'platos_categorias', poda: true, dedupeKey: 'nombre', incrementalColumn: 'updated_at'),
  (serverTable: 'platos', poda: true, dedupeKey: null, incrementalColumn: 'updated_at'),
  // Tablas chicas sin `updated_at` (hijas de plato): descarga completa.
  (serverTable: 'plato_ingredientes', poda: false, dedupeKey: null, incrementalColumn: null),
  (serverTable: 'plato_contornos', poda: false, dedupeKey: null, incrementalColumn: null),
  (serverTable: 'pos_categorias', poda: true, dedupeKey: 'nombre', incrementalColumn: 'updated_at'),
  (serverTable: 'pos_mesas', poda: true, dedupeKey: null, incrementalColumn: 'updated_at'),
  (serverTable: 'pos_habitaciones', poda: true, dedupeKey: null, incrementalColumn: 'updated_at'),
  (serverTable: 'pos_usuarios', poda: true, dedupeKey: null, incrementalColumn: 'updated_at'),
  (serverTable: 'pos_settings', poda: false, dedupeKey: null, incrementalColumn: null),
  // Turnos/reportes de cierre: incremental por `updated_at` (evita re-bajar
  // el historial de turnos cada ciclo).
  (serverTable: 'pos_sesiones', poda: false, dedupeKey: null, incrementalColumn: 'updated_at'),
  // Crecimiento en el tiempo: incremental por `updated_at` (evita re-bajar
  // todo el historial de comandas/ventas cada ciclo).
  (serverTable: 'pos_comandas', poda: false, dedupeKey: null, incrementalColumn: 'updated_at'),
  (serverTable: 'pos_ventas', poda: false, dedupeKey: null, incrementalColumn: 'updated_at'),
];

/// Motor de sincronización del módulo POS — puerto de `POSSyncManager` en
/// `usr/database/pos_sync.py`.
///
/// Diferencias con `SyncEngine` (el general):
/// - La subida de comandas/ventas se empareja por `sync_uuid` (los ids locales
///   no valen en otros dispositivos).
/// - Se excluyen de la cola general (`pos_*`), igual que en sync.py:668.
/// - Descarga las 11 tablas `pos_*`/`platos_*` con poda de huérfanos
///   (pos_sync.py `_download_all`) y además el subconjunto de catálogo que el
///   POS necesita para vender (categorías `visible_en_pos` + productos para la
///   venta, pos_sync.py:137-163).
/// - En el POS standalone (sin el módulo de inventario) sube también los
///   movimientos de stock de cada venta a través de un `SyncEngine` interno
///   (`pushPending`, solo subida: outbox no-pos + movimientos `sincronizado=0`).
///   En la app combinada este motor hace lo mismo sin duplicar trabajo: la
///   cola no-pos y los movimientos solo los procesa esta subida.
class PosSyncEngine {
  PosSyncEngine({required AppDatabase db, required this.client}) : _db = db;

  final AppDatabase _db;
  final SupabaseClient client;

  bool _running = false;
  Timer? _timer;
  void Function(String message)? onProgress;
  void Function()? onSyncComplete;

  /// Detalle completo del último error (para el diálogo de copiado).
  void Function(String detail)? onSyncError;

  /// Motor general interno, usado solo para subir movimientos/cola no-pos
  /// (`pushPending`, sin descarga).
  late final SyncEngine _general = SyncEngine(db: _db, client: client)
    ..onProgress = _log;

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
      await _general.pushPending();
      await _setLastPosSync();
      _log('Sincronización POS finalizada');
      onSyncComplete?.call();
      return true;
    } catch (e, st) {
      final detalle = '$e\n$st';
      _log('Error en sync POS: $e');
      onSyncError?.call(detalle);
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
        await _general.pushPending();
        await _setLastPosSync();
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
    // Subconjunto de catálogo de inventario que el POS necesita para vender.
    await _descargarCatalogoVenta();
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

  /// Subconjunto de catálogo que el POS muestra al vender (espejo de
  /// pos_sync.py:137-163): categorías de inventario con `visible_en_pos` y
  /// productos `tipo='Productos para la venta'`, ambos activos. Sin poda:
  /// el módulo de inventario gobierna el resto del catálogo.
  Future<void> _descargarCatalogoVenta() async {
    try {
      final cats = await _bajarPaginado(
        client.from('categorias')
            .select()
            .eq('activo', true)
            .eq('visible_en_pos', true),
      );
      for (final r in cats) {
        await _db.into(_db.categorias).insertOnConflictUpdate(
          CategoriasCompanion.insert(
            id: Value((r['id'] as num).toInt()),
            nombre: r['nombre'] as String,
            descripcion: Value(r['descripcion'] as String?),
            imagen: Value(r['imagen'] as String?),
            color: Value(r['color'] as String? ?? '#2196F3'),
            activo: Value(_toBoolInt(r['activo'], def: 1)),
            visibleEnPos: Value(_toBoolInt(r['visible_en_pos'], def: 1)),
            createdAt: Value(_toDt(r['created_at'])),
            updatedAt: Value(_toDt(r['updated_at'])),
          ),
        );
      }
      _log('${cats.length} categorías (visibles en POS) descargadas');
    } catch (e) {
      _log('Error descargando categorías: $e');
    }

    try {
      final prods = await _bajarPaginado(
        client.from('productos')
            .select()
            .eq('activo', true)
            .eq('tipo', 'Productos para la venta'),
      );
      for (final r in prods) {
        await _db.into(_db.productos).insertOnConflictUpdate(
          ProductosCompanion.insert(
            id: Value((r['id'] as num).toInt()),
            nombre: r['nombre'] as String,
            codigo: Value(r['codigo'] as String?),
            descripcion: Value(r['descripcion'] as String?),
            categoriaId: Value(_toInt(r['categoria_id'])),
            esPesable: Value(_toBoolInt(r['es_pesable'])),
            requiereFotoPeso: Value(_toBoolInt(r['requiere_foto_peso'])),
            pesoUnitario: Value(_toDouble(r['peso_unitario'])),
            precioVenta: Value(_toDouble(r['precio_venta']) ?? 0),
            unidadMedida: Value(r['unidad_medida'] as String? ?? 'unidad'),
            stockActual: Value(_toDouble(r['stock_actual']) ?? 0),
            stockMinimo: Value(_toDouble(r['stock_minimo']) ?? 0),
            activo: Value(_toBoolInt(r['activo'], def: 1)),
            tipo: Value(r['tipo'] as String? ?? 'ninguno'),
            almacenPredeterminado:
                Value(r['almacen_predeterminado'] as String? ?? 'principal'),
            createdAt: Value(_toDt(r['created_at'])),
            updatedAt: Value(_toDt(r['updated_at'])),
          ),
        );
      }
      _log('${prods.length} productos (para la venta) descargados');
    } catch (e) {
      _log('Error descargando productos: $e');
    }
  }

  /// Descarga paginada (Supabase REST: máx. 1000 filas/petición) de una
  /// consulta ordenada por id.
  Future<List<Map<String, dynamic>>> _bajarPaginado(
    PostgrestTransformBuilder<List<Map<String, dynamic>>> query,
  ) async {
    final q = query.order('id', ascending: true);
    final rows = <Map<String, dynamic>>[];
    const pageSize = 1000;
    var offset = 0;
    while (true) {
      final data = await q.range(offset, offset + pageSize - 1);
      final page = (data as List).cast<Map<String, dynamic>>();
      if (page.isEmpty) break;
      rows.addAll(page);
      offset += pageSize;
    }
    return rows;
  }

  Future<void> _descargarTabla(_PosTableDesc t) async {
    final table = t.serverTable;

    if (table == 'pos_settings') {
      await _descargarSettings();
      return;
    }

    // Misma mejora que el sync general (sync_engine.dart:594): cuando la
    // tabla ya tiene datos y `last_sync` existe, solo bajar las filas que
    // cambiaron desde entonces (`gte` sobre `updated_at`). Con full-download
    // en cada ciclo se re-baja todo el historial y se excede la cuota de
    // egress de Supabase.
    final lastPosSync = await _getLastPosSync();
    final localEmpty = await _isTableEmpty(table);
    final inc = t.incrementalColumn;

    final filtro = client.from(table).select();
    PostgrestTransformBuilder<List<Map<String, dynamic>>> q = filtro;
    var esCompleta = true;
    if (!localEmpty && lastPosSync != null && inc != null) {
      q = filtro.gte(inc, lastPosSync.toIso8601String());
      esCompleta = false;
    }
    q = q.order('id', ascending: true);

    // Supabase REST limita a 1000 filas por petición: paginar con `range`
    // para no perder datos históricos (p.ej. comandas/ventas viejas).
    final remoteIds = <int>[];
    const pageSize = 1000;
    var offset = 0;
    var total = 0;
    while (true) {
      final data = await q.range(offset, offset + pageSize - 1);
      final rows = (data as List).cast<Map<String, dynamic>>();
      if (rows.isEmpty) break;
      for (final r in rows) {
        final id = _toInt(r['id']);
        if (id != null) remoteIds.add(id);
        await _upsertFilaLocal(table, r);
      }
      total += rows.length;
      offset += pageSize;
    }
    if (total > 0) _log('$total $table descargados');

    // Podar huérfanos (delete_orphaned_records): solo si el server devolvió
    // filas; conserva lo pendiente de subir en la cola. En ciclos
    // incrementales `remoteIds` no es el set completo, así que se obtiene la
    // lista de ids remotos (consulta ligera, sin filas) para podar sin
    // eliminar filas vivas.
    if (t.poda) {
      final idsParaPoda = esCompleta ? remoteIds : await _fetchRemoteIds(table);
      if (idsParaPoda.isNotEmpty) {
        await _podarHuerfanos(table, idsParaPoda, t.dedupeKey);
      }
    }
  }

  /// Lista de ids remotos de una tabla (consulta ligera `select(id)` paginada).
  /// Se usa para podar en ciclos incrementales, donde el set de filas bajadas
  /// no es el completo.
  Future<List<int>> _fetchRemoteIds(String table) async {
    try {
      final ids = <int>[];
      final q = client.from(table).select('id').order('id', ascending: true);
      const pageSize = 1000;
      var offset = 0;
      while (true) {
        final data = await q.range(offset, offset + pageSize - 1);
        final rows = (data as List).cast<Map<String, dynamic>>();
        if (rows.isEmpty) break;
        for (final r in rows) {
          final id = _toInt(r['id']);
          if (id != null) ids.add(id);
        }
        offset += pageSize;
      }
      return ids;
    } catch (e) {
      _log('Error listando ids de $table: $e');
      return [];
    }
  }

  /// True si la tabla local no tiene filas (fuerza descarga completa la
  /// primera vez aunque exista `last_sync`).
  Future<bool> _isTableEmpty(String table) async {
    try {
      final q = await _db.customSelect(
        'SELECT EXISTS(SELECT 1 FROM $table) AS vacia',
      ).getSingle();
      return q.read<int>('vacia') == 0;
    } catch (_) {
      return false;
    }
  }

  Future<DateTime?> _getLastPosSync() async {
    try {
      final row = await (_db.select(_db.syncMetadata)
            ..where((t) => t.key.equals('pos_full_sync')))
          .getSingleOrNull();
      if (row == null || row.value == null) return null;
      final t = DateTime.tryParse(row.value!);
      // Margen de 10s hacia atrás: el `gte` es lexicográfico y la escritura de
      // `_setLastPosSync` cae en el mismo segundo (misma lógica que el sync
      // general); el upsert es idempotente.
      if (t != null) return t.subtract(const Duration(seconds: 10));
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _setLastPosSync() async {
    await _db.into(_db.syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion.insert(
        key: 'pos_full_sync',
        value: Value(DateTime.now().toUtc().toIso8601String()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Upsert local por id (tablas platos_*/pos_* de escritura directa).
  Future<void> _upsertFilaLocal(String table, Map<String, dynamic> r) async {
    final id = _toInt(r['id']);
    switch (table) {
      case 'pos_sesiones':
        await _upsertSesionLocal(r);
        return;
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
                updatedAt: Value(_toDt(r['updated_at'])),
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
                updatedAt: Value(_toDt(r['updated_at'])),
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
                updatedAt: Value(_toDt(r['updated_at'])),
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

  /// Upsert local de un turno por sync_uuid (last-writer-wins por updated_at,
  /// respetando tombstones).
  Future<void> _upsertSesionLocal(Map<String, dynamic> r) async {
    final su = (r['sync_uuid'] as String?)?.trim() ?? '';
    if (su.isEmpty) return;
    if (await _esTombstone(su, 'pos_sesiones')) return;
    final existing = await (_db.select(_db.posSesiones)
          ..where((t) => t.syncUuid.equals(su)))
        .getSingleOrNull();
    final upd = r['updated_at'] as String?;
    final localUpd = existing?.updatedAt?.toUtc().toIso8601String();
    if (existing != null &&
        upd != null &&
        localUpd != null &&
        upd.compareTo(localUpd) < 0) {
      return;
    }
    if (existing != null) {
      await (_db.update(_db.posSesiones)..where((t) => t.id.equals(existing.id)))
          .write(PosSesionesCompanion(
            usuarioId: Value(_toInt(r['usuario_id']) ?? 0),
            abiertaEn: Value(_toDt(r['abierta_en']) ?? DateTime.now()),
            cerradaEn: Value(_toDt(r['cerrada_en'])),
            cajaInicial: Value(_toDouble(r['caja_inicial']) ?? 0),
            cajaFinal: Value(_toDouble(r['caja_final'])),
            updatedAt: Value(_toDt(r['updated_at'])),
          ));
    } else {
      await _db.into(_db.posSesiones).insert(
            PosSesionesCompanion.insert(
              usuarioId: _toInt(r['usuario_id']) ?? 0,
              abiertaEn: _toDt(r['abierta_en']) ?? DateTime.now(),
              cerradaEn: Value(_toDt(r['cerrada_en'])),
              cajaInicial: Value(_toDouble(r['caja_inicial']) ?? 0),
              cajaFinal: Value(_toDouble(r['caja_final'])),
              syncUuid: Value(su),
              createdAt:
                  Value(_toDt(r['created_at']) ?? _toDt(r['abierta_en'])),
              updatedAt: Value(_toDt(r['updated_at'])),
            ),
          );
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
      case 'pos_sesiones':
        await _subirPorSyncUuid('pos_sesiones', data, op, ['usuario_id',
            'abierta_en', 'cerrada_en', 'caja_inicial', 'caja_final']);
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
