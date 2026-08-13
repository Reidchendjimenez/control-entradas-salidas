import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/schema/app_database.dart';
import '../config/app_config.dart';
import 'sync_tables.dart';

/// Motor de sincronización — puerto de `usr/database/sync.py` + `pos_sync.py`.
///
/// Flujo (`fullSync`):
/// 1. `_processOutbox()`: sube operaciones pendientes (cola sync_queue).
/// 2. `_uploadPendingMovimientos()`: sube movimientos con `sincronizado=0`,
///    resolviendo factura_id/requisicion_id locales → remotos.
/// 3. `_downloadAllFromServer()`: descarga las 15 tablas y hace upsert local.
///
/// Reglas heredadas que se conservan:
/// - movimientos con operación != delete NO se suben por outbox (se regeneran
///   por checkpoint, sync.py:666).
/// - tablas `pos_*` excluidas de la cola general (sync.py:668).
class SyncEngine {
  SyncEngine({required AppDatabase db, required this.client}) : _db = db;

  final AppDatabase _db;
  final SupabaseClient client;

  bool _running = false;

  /// Callbacks de progreso (equivalente a set_sync_progress_callback).
  void Function(String message)? onProgress;
  void Function()? onSyncComplete;

  void _log(String msg) => onProgress?.call(msg);

  // ---------------------------------------------------------------------
  // 1. Subida del outbox (sync_queue)
  // ---------------------------------------------------------------------

  Future<void> _processOutbox() async {
    final pending = await (_db.select(_db.syncQueue)
          ..where((t) => t.status.equals('pending')))
        .get();

    if (pending.isEmpty) {
      _log('No hay operaciones pendientes');
      return;
    }

    for (final item in pending) {
      try {
        final op = item.operation;
        final table = item.targetTable;

        // Movimientos no-eliminados no suben por outbox (se regeneran).
        if (table == 'movimientos' && op != 'delete') continue;

        // Tablas POS excluidas de esta cola.
        if (table.startsWith('pos_')) continue;

        final data = jsonDecode(item.data) as Map<String, dynamic>;

        switch (op) {
          case 'insert':
            await _upsertRemote(table, data);
          case 'update':
            await _upsertRemote(table, data);
          case 'delete':
            final id = data['id'];
            await client.from(table).delete().eq('id', id);
        }
        await (_db.delete(_db.syncQueue)..where((t) => t.id.equals(item.id))).go();
        _log('[$table] $op subido');
      } catch (e) {
        await (_db.update(_db.syncQueue)..where((t) => t.id.equals(item.id))).write(
          SyncQueueCompanion(
            retries: Value(item.retries + 1),
            lastError: Value(e.toString()),
          ),
        );
        _log('Error en outbox ${item.targetTable}/${item.operation}: $e');
      }
    }
  }

  Future<void> _upsertRemote(String table, Map<String, dynamic> data) async {
    final desc = syncedTables.firstWhere(
      (d) => d.serverTable == table,
      orElse: () => SyncTableDescriptor(serverTable: table, localTable: table),
    );
    final cleaned = Map<String, dynamic>.from(data)
      ..removeWhere((k, v) => v == null);

    if (desc.dedupeKey.isNotEmpty && cleaned.containsKey(desc.dedupeKey)) {
      // Buscar por clave natural: si existe, actualizar; si no, insertar.
      final existing = await client
          .from(table)
          .select('id')
          .eq(desc.dedupeKey, cleaned[desc.dedupeKey])
          .maybeSingle();
      if (existing != null && existing['id'] != null) {
        await client.from(table).update(cleaned).eq('id', existing['id']);
        return;
      }
    }
    if (cleaned.containsKey('id')) {
      cleaned.remove('id'); // deja que el server genere el id
    }
    await client.from(table).insert(cleaned);
  }

  // ---------------------------------------------------------------------
  // 2. Subida de movimientos pendientes
  // ---------------------------------------------------------------------

  Future<void> _uploadPendingMovimientos() async {
    final pending = await (_db.select(_db.movimientos)
          ..where((t) => t.sincronizado.equals(0)))
        .get();
    if (pending.isEmpty) {
      _log('No hay movimientos pendientes');
      return;
    }

    for (final mov in pending) {
      try {
        int? remoteFacturaId = await _resolveFacturaIdRemoto(mov.facturaId);
        int? remoteRequisicionId =
            await _resolveRequisicionIdRemoto(mov.requisicionId, mov.tipo);

        if (mov.requisicionId != null &&
            remoteRequisicionId == null &&
            (mov.tipo == 'tr_salida' || mov.tipo == 'tr_entrada')) {
          continue; // postergar
        }

        // Buscar coincidencia por campos clave.
        final match = await client
            .from('movimientos')
            .select('id')
            .eq('producto_id', mov.productoId)
            .eq('tipo', mov.tipo)
            .eq('cantidad', mov.cantidad)
            .eq('fecha_movimiento', mov.fechaMovimiento?.toUtc().toIso8601String() ?? '')
            .eq('almacen', mov.almacen ?? '')
            .maybeSingle();

        if (match != null) {
          final updates = <String, dynamic>{};
          if (remoteFacturaId != null) updates['factura_id'] = remoteFacturaId;
          if (remoteRequisicionId != null) updates['requisicion_id'] = remoteRequisicionId;
          if (mov.ventaSyncUuid != null) updates['venta_sync_uuid'] = mov.ventaSyncUuid;
          if (updates.isNotEmpty) {
            await client.from('movimientos').update(updates).eq('id', match['id']);
          }
        } else {
          await client.from('movimientos').insert({
            'producto_id': mov.productoId,
            'factura_id': remoteFacturaId,
            'requisicion_id': remoteRequisicionId ?? mov.requisicionId,
            'venta_sync_uuid': mov.ventaSyncUuid,
            'tipo': mov.tipo,
            'cantidad': mov.cantidad,
            'cantidad_anterior': mov.cantidadAnterior,
            'cantidad_nueva': mov.cantidadNueva,
            'peso_total': mov.pesoTotal,
            'registrado_por': mov.registradoPor,
            'observaciones': mov.observaciones,
            'almacen': mov.almacen,
            'fecha_movimiento':
                mov.fechaMovimiento?.toUtc().toIso8601String(),
          });
        }

        if (mov.facturaId != null && remoteFacturaId == null) continue;
        if (mov.requisicionId != null &&
            remoteRequisicionId == null &&
            (mov.tipo == 'tr_salida' || mov.tipo == 'tr_entrada')) {
          continue;
        }

        await (_db.update(_db.movimientos)..where((t) => t.id.equals(mov.id)))
            .write(const MovimientosCompanion(sincronizado: Value(1)));
        _log('Movimiento ${mov.id} sincronizado');
      } catch (e) {
        _log('Error subiendo movimiento ${mov.id}: $e');
      }
    }
  }

  Future<int?> _resolveFacturaIdRemoto(int? localFacturaId) async {
    if (localFacturaId == null) return null;
    final local = await (_db.select(_db.facturas)
          ..where((f) => f.id.equals(localFacturaId)))
        .getSingleOrNull();
    if (local == null || local.numeroFactura == null) return null;
    final remote = await client
        .from('facturas')
        .select('id')
        .eq('numero_factura', local.numeroFactura!)
        .maybeSingle();
    return remote?['id'] as int?;
  }

  Future<int?> _resolveRequisicionIdRemoto(int? localId, String tipo) async {
    if (localId == null) return null;
    if (tipo != 'tr_salida' && tipo != 'tr_entrada') return null;
    final local = await (_db.select(_db.requisiciones)
          ..where((r) => r.id.equals(localId)))
        .getSingleOrNull();
    if (local == null) return null;
    final remote = await client
        .from('requisiciones')
        .select('id')
        .eq('numero', local.numero)
        .maybeSingle();
    return remote?['id'] as int?;
  }

  // ---------------------------------------------------------------------
  // 3. Descarga masiva desde el servidor
  // ---------------------------------------------------------------------

  Future<void> _downloadAllFromServer() async {
    for (final desc in syncedTables) {
      try {
        final data = await client.from(desc.serverTable).select();
        final rows = (data as List).cast<Map<String, dynamic>>();
        if (rows.isEmpty) continue;

        // Los mapas de Supabase vienen con tipos Postgres; drift espera los
        // tipos SQLite (int/real/text). Normalizamos y agregamos a drift.
        await _upsertLocalBatch(desc, rows);
        _log('${rows.length} ${desc.serverTable} descargados');
      } catch (e) {
        _log('Error descargando ${desc.serverTable}: $e');
      }
    }
  }

  Future<void> _upsertLocalBatch(
    SyncTableDescriptor desc,
    List<Map<String, dynamic>> rows,
  ) async {
    await _db.transaction(() async {
      switch (desc.localTable) {
        case 'categorias':
          for (final r in rows) {
            await _db.into(_db.categorias).insertOnConflictUpdate(
              CategoriasCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                nombre: r['nombre'] as String,
                descripcion: Value(r['descripcion'] as String?),
                imagen: Value(r['imagen'] as String?),
                color: Value(r['color'] as String? ?? '#2196F3'),
                activo: Value((r['activo'] as bool?) == true ? 1 : (r['activo'] as num?)?.toInt() ?? 1),
                visibleEnPos: Value(
                    (r['visible_en_pos'] as bool?) == true ? 1 : (r['visible_en_pos'] as num?)?.toInt() ?? 1),
                createdAt: Value(_toDt(r['created_at'])),
                updatedAt: Value(_toDt(r['updated_at'])),
              ),
            );
          }
        case 'productos':
          for (final r in rows) {
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
        case 'proveedores':
          for (final r in rows) {
            await _db.into(_db.proveedores).insertOnConflictUpdate(
              ProveedoresCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                nombre: r['nombre'] as String,
                rif: Value(r['rif'] as String?),
                telefono: Value(r['telefono'] as String?),
                email: Value(r['email'] as String?),
                direccion: Value(r['direccion'] as String?),
                contacto: Value(r['contacto'] as String?),
                observaciones: Value(r['observaciones'] as String?),
                estado: Value(r['estado'] as String? ?? 'Activo'),
                createdAt: Value(_toDt(r['created_at'])),
              ),
            );
          }
        case 'existencias':
          for (final r in rows) {
            await _db.into(_db.existencias).insertOnConflictUpdate(
              ExistenciasCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                productoId: Value(_toInt(r['producto_id'])),
                almacen: r['almacen'] as String,
                cantidad: Value(_toDouble(r['cantidad']) ?? 0),
                unidad: Value(r['unidad'] as String? ?? 'unidad'),
              ),
            );
          }
        case 'movimientos':
          for (final r in rows) {
            await _db.into(_db.movimientos).insertOnConflictUpdate(
              MovimientosCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                productoId: _toInt(r['producto_id']) ?? 0,
                facturaId: Value(_toInt(r['factura_id'])),
                requisicionId: Value(_toInt(r['requisicion_id'])),
                ventaId: Value(_toInt(r['venta_id'])),
                ventaSyncUuid: Value(r['venta_sync_uuid'] as String?),
                tipo: r['tipo'] as String,
                cantidad: _toDouble(r['cantidad']) ?? 0,
                cantidadAnterior: Value(_toDouble(r['cantidad_anterior']) ?? 0),
                cantidadNueva: Value(_toDouble(r['cantidad_nueva']) ?? 0),
                pesoTotal: Value(_toDouble(r['peso_total']) ?? 0),
                registradoPor: Value(r['registrado_por'] as String?),
                observaciones: Value(r['observaciones'] as String?),
                almacen: Value(r['almacen'] as String?),
                fechaMovimiento: Value(_toDt(r['fecha_movimiento'])),
                createdAt: Value(_toDt(r['created_at'])),
              ),
            );
          }
        case 'facturas':
          for (final r in rows) {
            await _db.into(_db.facturas).insertOnConflictUpdate(
              FacturasCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                numeroFactura: Value(r['numero_factura'] as String?),
                tipoDocumento: Value(r['tipo_documento'] as String? ?? 'Factura'),
                proveedor: Value(r['proveedor'] as String?),
                fechaFactura: Value(_toDt(r['fecha_factura'])),
                fechaRecepcion: Value(_toDt(r['fecha_recepcion'])),
                totalBruto: Value(_toDouble(r['total_bruto']) ?? 0),
                totalImpuestos: Value(_toDouble(r['total_impuestos']) ?? 0),
                totalNeto: Value(_toDouble(r['total_neto']) ?? 0),
                estado: Value(r['estado'] as String? ?? 'Pendiente'),
                observaciones: Value(r['observaciones'] as String?),
                validadaPor: Value(r['validada_por'] as String?),
                fechaValidacion: Value(_toDt(r['fecha_validacion'])),
                createdAt: Value(_toDt(r['created_at'])),
                updatedAt: Value(_toDt(r['updated_at'])),
              ),
            );
          }
        case 'factura_pagos':
          for (final r in rows) {
            await _db.into(_db.facturaPagos).insertOnConflictUpdate(
              FacturaPagosCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                facturaId: _toInt(r['factura_id']) ?? 0,
                tipoPago: r['tipo_pago'] as String,
                monto: _toDouble(r['monto']) ?? 0,
                referencia: Value(r['referencia'] as String?),
                tasaCambio: Value(_toDouble(r['tasa_cambio'])),
                fechaPago: Value(_toDt(r['fecha_pago'])),
              ),
            );
          }
        case 'requisiciones':
          for (final r in rows) {
            await _db.into(_db.requisiciones).insertOnConflictUpdate(
              RequisicionesCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                numero: r['numero'] as String,
                numeroSecuencial: _toInt(r['numero_secuencial']) ?? 0,
                origen: r['origen'] as String,
                destino: r['destino'] as String,
                estado: Value(r['estado'] as String? ?? 'pendiente'),
                observaciones: Value(r['observaciones'] as String?),
                creadaPor: Value(r['creada_por'] as String?),
                procesadaPor: Value(r['procesada_por'] as String?),
                fechaProcesamiento: Value(_toDt(r['fecha_procesamiento'])),
                fechaCreacion: Value(_toDt(r['fecha_creacion'])),
                actualizada: Value(_toDt(r['actualizada'])),
              ),
            );
          }
        case 'requisicion_detalles':
          for (final r in rows) {
            await _db.into(_db.requisicionDetalles).insertOnConflictUpdate(
              RequisicionDetallesCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                requisicionId: _toInt(r['requisicion_id']) ?? 0,
                productoId: Value(_toInt(r['producto_id'])),
                ingrediente: r['ingrediente'] as String,
                cantidad: _toDouble(r['cantidad']) ?? 0,
                unidad: Value(r['unidad'] as String? ?? 'unidad'),
                cantidadSurtida: Value(_toDouble(r['cantidad_surtida']) ?? 0),
                verificado: Value(_toBoolInt(r['verificado'])),
              ),
            );
          }
        case 'stock_checkpoint':
          for (final r in rows) {
            await _db.into(_db.stockCheckpoint).insertOnConflictUpdate(
              StockCheckpointCompanion.insert(
                productoId: _toInt(r['producto_id']) ?? 0,
                almacen: r['almacen'] as String,
                cantidad: Value(_toDouble(r['cantidad']) ?? 0),
              ),
            );
          }
        case 'periodos':
          for (final r in rows) {
            await _db.into(_db.periodos).insertOnConflictUpdate(
              PeriodosCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                periodo: r['periodo'] as String,
                fechaApertura: r['fecha_apertura'] as String,
                registradoPor: Value(r['registrado_por'] as String?),
              ),
            );
          }
        case 'recetas':
          for (final r in rows) {
            await _db.into(_db.recetas).insertOnConflictUpdate(
              RecetasCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                nombre: r['nombre'] as String,
                tipo: r['tipo'] as String,
                productoBaseId: Value(_toInt(r['producto_base_id'])),
                productoFinalId: Value(_toInt(r['producto_final_id'])),
                cantidadProducida: Value(_toDouble(r['cantidad_producida']) ?? 1),
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                createdAt: Value(_toDt(r['created_at'])),
                updatedAt: Value(_toDt(r['updated_at'])),
              ),
            );
          }
        case 'receta_componentes':
          for (final r in rows) {
            await _db.into(_db.recetaComponentes).insertOnConflictUpdate(
              RecetaComponentesCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                recetaId: _toInt(r['receta_id']) ?? 0,
                productoId: _toInt(r['producto_id']) ?? 0,
                cantidad: _toDouble(r['cantidad']) ?? 0,
                unidad: Value(r['unidad'] as String? ?? 'unidad'),
                tipoComponente: r['tipo_componente'] as String,
                pesoVariable: Value(_toInt(r['peso_variable']) ?? 0),
              ),
            );
          }
        case 'producciones':
          for (final r in rows) {
            await _db.into(_db.producciones).insertOnConflictUpdate(
              ProduccionesCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                recetaId: _toInt(r['receta_id']) ?? 0,
                cantidad: _toDouble(r['cantidad']) ?? 0,
                estado: Value(r['estado'] as String? ?? 'completado'),
                usuario: Value(r['usuario'] as String?),
                observaciones: Value(r['observaciones'] as String?),
                cocineros: Value(r['cocineros'] as String?),
                fechaProduccion: Value(_toDt(r['fecha_produccion'])),
                createdAt: Value(_toDt(r['created_at'])),
              ),
            );
          }
        case 'produccion_detalles':
          for (final r in rows) {
            await _db.into(_db.produccionDetalles).insertOnConflictUpdate(
              ProduccionDetallesCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                produccionId: _toInt(r['produccion_id']) ?? 0,
                productoId: _toInt(r['producto_id']) ?? 0,
                tipo: r['tipo'] as String,
                cantidad: _toDouble(r['cantidad']) ?? 0,
                unidad: Value(r['unidad'] as String? ?? 'unidad'),
                movimientoId: Value(_toInt(r['movimiento_id'])),
              ),
            );
          }
        default:
          throw UnimplementedError('Tabla no mapeada: ${desc.localTable}');
      }
    });
  }

  // ---------------------------------------------------------------------
  // API pública
  // ---------------------------------------------------------------------

  Future<bool> fullSync() async {
    if (_running) return false;
    _running = true;
    try {
      await _processOutbox();
      await _uploadPendingMovimientos();
      await _downloadAllFromServer();
      await _setLastSync();
      _log('Sincronización completa finalizada');
      onSyncComplete?.call();
      return true;
    } catch (e) {
      _log('Error en sincronización: $e');
      return false;
    } finally {
      _running = false;
    }
  }

  Future<void> startBackgroundSync() async {
    Timer.periodic(
      const Duration(seconds: AppConfig.syncIntervalSeconds),
      (_) => fullSync(),
    );
  }

  Future<void> _setLastSync() async {
    await _db.into(_db.syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion.insert(
        key: 'last_sync_full',
        value: Value(DateTime.now().toIso8601String()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// Helpers de normalización de tipos Postgres → SQLite/drift
// ---------------------------------------------------------------------

DateTime? _toDt(Object? v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  if (v is String) {
    final parsed = DateTime.tryParse(v);
    return parsed?.toLocal();
  }
  return null;
}

int? _toInt(Object? v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is bool) return v ? 1 : 0;
  if (v is String) return int.tryParse(v);
  return null;
}

double? _toDouble(Object? v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is bool) return v ? 1 : 0;
  if (v is String) return double.tryParse(v);
  return null;
}

int _toBoolInt(Object? v, {int def = 0}) {
  if (v == null) return def;
  if (v is bool) return v ? 1 : 0;
  if (v is num) return v.toInt();
  return def;
}