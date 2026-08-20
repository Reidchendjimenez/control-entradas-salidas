import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../db/schema/app_database.dart';
import '../config/app_config.dart';
import '../utils/file_logger.dart';
import 'pos_sync_engine.dart';
import 'realtime/realtime_source.dart';
import 'sync_service.dart';
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
  SyncEngine({
    required AppDatabase db,
    required this.client,
    RealtimeSource? realtime,
  })  : _db = db,
        _realtime = realtime;

  final AppDatabase _db;
  final SupabaseClient client;
  final RealtimeSource? _realtime;

  bool _running = false;

  /// Suscripciones activas de Realtime (para dispose).
  final List<StreamSubscription<RealtimeEvent>> _realtimeSubs = [];

  /// Callbacks de progreso (equivalente a set_sync_progress_callback).
  void Function(String message)? onProgress;
  void Function()? onSyncComplete;

  /// Callback con el detalle completo del error (para mostrarlo al usuario).
  void Function(String detail)? onSyncError;

  void _log(String msg) {
    logToFile(msg);
    onProgress?.call(msg);
  }

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

        // Tablas del módulo POS (pos_*/platos_*) gestionadas por PosSyncEngine.
        if (posTableNames.contains(table)) continue;

        final data = jsonDecode(item.data) as Map<String, dynamic>;

        switch (op) {
          case 'insert':
            if (table == 'factura_pagos') {
              await _upsertFacturaPago(data);
            } else if (table == 'requisiciones') {
              await _upsertRequisicion(data);
            } else {
              await _upsertRemote(table, data, 'insert');
            }
          case 'update':
            if (table == 'factura_pagos') {
              await _upsertFacturaPago(data);
            } else if (table == 'requisiciones') {
              await _upsertRequisicion(data);
            } else {
              await _upsertRemote(table, data, 'update');
            }
          case 'upsert':
            if (table == 'requisiciones') {
              await _upsertRequisicion(data);
            } else {
              await _upsertRemote(table, data, 'upsert');
            }
          case 'delete':
            if (table == 'movimientos') {
              await _deleteMovimientoPorMatch(data);
            } else if (table == 'requisiciones') {
              await _deleteRequisicion(data);
            } else {
              final id = data['id'];
              await client.from(table).delete().eq('id', id);
            }
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

  /// Inserta un pago de factura resolviendo `factura_numero` → `factura_id`
  /// remoto (réplica de `sync.py` caso `factura_pagos`).
  Future<void> _upsertFacturaPago(Map<String, dynamic> data) async {
    final numFac = data['factura_numero'] as String?;
    if (numFac == null || numFac.isEmpty) {
      throw StateError('factura_numero requerido para factura_pagos');
    }
    final remote = await client
        .from('facturas')
        .select('id')
        .eq('numero_factura', numFac)
        .maybeSingle();
    if (remote == null || remote['id'] == null) {
      throw StateError('Factura $numFac no encontrada en el servidor');
    }
    await client.from('factura_pagos').insert({
      'factura_id': remote['id'],
      'tipo_pago': data['tipo_pago'],
      'monto': data['monto'],
      'referencia': data['referencia'],
      'tasa_cambio': data['tasa_cambio'],
    });
  }

  /// Sube una requisición completa (cabecera + detalles) resolviendo el id
  /// remoto por `numero` (réplica de `sync.py` caso `requisiciones`).
  ///
  /// A diferencia de las tablas de catálogo, los `requisicion_detalles` hijos
  /// referencian a la requisición por su id remoto, así que aquí se resuelve
  /// primero la cabecera y luego se (re)suben los detalles con ese id. Es
  /// idempotente: borra los detalles remotos de la requisición y vuelve a
  /// insertar los locales, así ediciones sucesivas no duplican.
  Future<void> _upsertRequisicion(Map<String, dynamic> data) async {
    final numero = data['numero'] as String?;
    if (numero == null || numero.isEmpty) {
      throw StateError('numero requerido para sincronizar requisiciones');
    }
    final cleaned = Map<String, dynamic>.from(data)
      ..removeWhere((k, v) => v == null || k == 'id');

    final existing = await client
        .from('requisiciones')
        .select('id')
        .eq('numero', numero)
        .maybeSingle();
    int serverId;
    if (existing != null && existing['id'] != null) {
      await client.from('requisiciones').update(cleaned).eq('id', existing['id']);
      serverId = (existing['id'] as num).toInt();
    } else {
      final inserted =
          await client.from('requisiciones').insert(cleaned).select('id').single();
      serverId = (inserted['id'] as num).toInt();
    }

    // Detalles: borra los remotos y reinserta los locales (con id remoto).
    await client
        .from('requisicion_detalles')
        .delete()
        .eq('requisicion_id', serverId);
    final localId = data['id'];
    final detalles = await (_db.select(_db.requisicionDetalles)
          ..where((t) => t.requisicionId.equals(localId)))
        .get();
    for (final d in detalles) {
      await client.from('requisicion_detalles').insert({
        'requisicion_id': serverId,
        'producto_id': d.productoId,
        'ingrediente': d.ingrediente,
        'cantidad': d.cantidad,
        'unidad': d.unidad,
        'cantidad_surtida': d.cantidadSurtida,
        // 0/1 (integer): el server lo acepta tanto para columnas integer
        // como boolean ('0'/'1' son cast válidos a boolean en Postgres).
        'verificado': d.verificado,
      });
    }
  }

  /// Elimina una requisición remota (y sus detalles) por `numero` (réplica de
  /// `sync.py` caso `requisiciones` delete).
  Future<void> _deleteRequisicion(Map<String, dynamic> data) async {
    final numero = data['numero'] as String?;
    if (numero == null || numero.isEmpty) return;
    final existing = await client
        .from('requisiciones')
        .select('id')
        .eq('numero', numero)
        .maybeSingle();
    if (existing == null || existing['id'] == null) return;
    final serverId = (existing['id'] as num).toInt();
    await client
        .from('requisicion_detalles')
        .delete()
        .eq('requisicion_id', serverId);
    await client.from('requisiciones').delete().eq('id', serverId);
  }

  /// Elimina un movimiento remoto por campos coincidentes (ID local != remoto,
  /// réplica de `sync.py` caso `movimientos` delete).
  ///
  /// La fecha se normaliza a UTC al segundo porque el server guarda
  /// `fecha_movimiento` normalizada (ver `_uploadPendingMovimientos`); si no se
  /// normalizara, el `.eq` nunca coincidía y el borrado se reportaba subido sin
  /// eliminar nada. Se hace match progresivo: primero con el detalle exacto
  /// (incluye cantidad_anterior/nueva), luego solo con la fecha, y por último
  /// sin fecha, para cubrir filas que el server haya mergeado.
  Future<void> _deleteMovimientoPorMatch(Map<String, dynamic> data) async {
    final fechaNorm = data['fecha_movimiento'] is String
        ? toSecondUtcIsoString(DateTime.tryParse(data['fecha_movimiento'] as String))
        : null;

    Future<List<Map<String, dynamic>>> buscar(Map<String, Object?> extra) async {
      var q = client.from('movimientos').select(
          'id,cantidad_anterior,cantidad_nueva,fecha_movimiento');
      for (final e in {
        'producto_id': data['producto_id'],
        'tipo': data['tipo'],
        'almacen': data['almacen'],
        'cantidad': data['cantidad'],
      }.entries) {
        if (e.value != null) q = q.eq(e.key, e.value!);
      }
      for (final e in extra.entries) {
        if (e.value != null) q = q.eq(e.key, e.value!);
      }
      return q.limit(20);
    }

    var rows = await buscar({
      if (fechaNorm != null) 'fecha_movimiento': fechaNorm,
      'cantidad_anterior': data['cantidad_anterior'],
      'cantidad_nueva': data['cantidad_nueva'],
    });
    if (rows.isEmpty && fechaNorm != null) {
      rows = await buscar({'fecha_movimiento': fechaNorm});
    }
    if (rows.isEmpty) {
      rows = await buscar(const {});
    }
    for (final r in rows) {
      await client.from('movimientos').delete().eq('id', r['id']);
    }
  }

  /// Tablas de catálogo creadas offline y referenciadas por hijos (FK). Al
  /// subirlas, el server asigna el id (evita colisiones entre dispositivos) y
  /// se re-mapea el id local en todas las tablas que lo referencian.
  static const _catalogo = {'categorias', 'productos', 'proveedores'};

  Future<void> _upsertRemote(String table, Map<String, dynamic> data, String op) async {
    if (_catalogo.contains(table)) {
      await _subirCatalogoRow(table, data);
      return;
    }

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
        cleaned.remove('id');
        await client.from(table).update(cleaned).eq('id', existing['id']);
        return;
      }
    }

    if (op == 'update') {
      // Edición de una fila que ya existe en el server: actualizar por id.
      final id = cleaned['id'];
      if (id == null) throw StateError('update de $table sin id');
      final updated = await client.from(table).update(cleaned).eq('id', id).select('id');
      if (updated.isEmpty) {
        // No existe aún (se creó local y se editó antes de subir): insertar.
        await client.from(table).insert(cleaned);
      }
      return;
    }

    // Insert: sin id local, el server asigna el id (estas tablas no tienen
    // hijos que referencien el id local o se resuelven por clave natural).
    final sinId = Map<String, dynamic>.from(cleaned)..remove('id');
    await client.from(table).insert(sinId);
  }

  /// Sube una fila de catálogo (categoría/producto/proveedor): si el server ya
  /// la tiene por id o por clave natural, actualiza; si no, inserta sin id local
  /// y re-mapea el id en las tablas hijas (evita colisiones multi-dispositivo).
  Future<void> _subirCatalogoRow(String table, Map<String, dynamic> data) async {
    if (table == 'productos' && data['categoria_id'] != null) {
      await _garantizarCategoriaRemota(data['categoria_id'] as int);
    }
    final localId = data['id'];
    final upd = Map<String, dynamic>.from(data)..remove('id');

    if (localId != null) {
      final porId = await client
          .from(table)
          .select('id')
          .eq('id', localId)
          .maybeSingle();
      if (porId != null) {
        await client.from(table).update(upd).eq('id', localId);
        return;
      }
    }

    final desc = syncedTables.firstWhere(
      (d) => d.serverTable == table,
      orElse: () => SyncTableDescriptor(serverTable: table, localTable: table),
    );
    if (desc.dedupeKey.isNotEmpty && data.containsKey(desc.dedupeKey)) {
      final existing = await client
          .from(table)
          .select('id')
          .eq(desc.dedupeKey, data[desc.dedupeKey])
          .maybeSingle();
      if (existing != null && existing['id'] != null) {
        final remoteId = (existing['id'] as num).toInt();
        if (localId != null && remoteId != localId) {
          await _remapearLocal(table, localId, remoteId);
        }
        await client.from(table).update(upd).eq('id', remoteId);
        return;
      }
    }

    await _insertarPadre(table: table, data: data, localId: localId);
  }

  /// Inserta la fila sin id local (el server asigna `nextval`) y re-mapea el
  /// id local en las tablas hijas.
  Future<void> _insertarPadre({
    required String table,
    required Map<String, dynamic> data,
    required int? localId,
  }) async {
    final sinId = Map<String, dynamic>.from(data)..remove('id');
    final inserted = await client.from(table).insert(sinId).select();
    if (inserted.isEmpty) throw StateError('insert de $table sin fila devuelta');
    final remoteId = (inserted.first['id'] as num).toInt();
    if (localId != null && remoteId != localId) {
      await _remapearLocal(table, localId, remoteId);
    }
  }

  /// Re-mapea un id local a su id remoto en todas las tablas que lo referencian
  /// (SQLite no ejecuta FKs, así que el orden no importa).
  Future<void> _remapearLocal(String table, int from, int to) async {
    Future<void> upd(String sql) async {
      try {
        await _db.customStatement(sql, [to, from]);
      } catch (e) {
        _log('Remapeo $sql ($from->$to) falló: $e');
      }
    }

    if (table == 'categorias') {
      await upd('UPDATE productos SET categoria_id = ? WHERE categoria_id = ?');
    } else if (table == 'productos') {
      await upd('UPDATE productos SET id = ? WHERE id = ?');
      await upd('UPDATE movimientos SET producto_id = ? WHERE producto_id = ?');
      await upd('UPDATE movimientos_archivo SET producto_id = ? WHERE producto_id = ?');
      await upd('UPDATE existencias SET producto_id = ? WHERE producto_id = ?');
      await upd('UPDATE stock_checkpoint SET producto_id = ? WHERE producto_id = ?');
      await upd('UPDATE compras_lista SET producto_id = ? WHERE producto_id = ?');
      await upd('UPDATE requisicion_detalles SET producto_id = ? WHERE producto_id = ?');
      await upd('UPDATE recetas SET producto_base_id = ? WHERE producto_base_id = ?');
      await upd('UPDATE recetas SET producto_final_id = ? WHERE producto_final_id = ?');
      await upd('UPDATE receta_componentes SET producto_id = ? WHERE producto_id = ?');
      await upd('UPDATE produccion_detalles SET producto_id = ? WHERE producto_id = ?');
      _log('Producto $from re-mapeado a $to');
    }
    // proveedores: no tienen tablas hijas → sin remapeo.
  }

  // ---------------------------------------------------------------------
  // 2. Subida de movimientos pendientes
  // ---------------------------------------------------------------------

  /// Sube el producto referenciado por un movimiento si el server no lo tiene
  /// aún (el outbox pudo no haber subido la creación, o se creó antes del fix).
  /// El server asigna el id y se re-mapea (ver `_subirCatalogoRow`).
  Future<void> _garantizarProductoRemoto(int productoId) async {
    final exists = await client
        .from('productos')
        .select('id')
        .eq('id', productoId)
        .maybeSingle();
    if (exists != null) return;

    final local = await (_db.select(_db.productos)
          ..where((t) => t.id.equals(productoId)))
        .getSingleOrNull();
    if (local == null) return;
    if (local.categoriaId != null) {
      await _garantizarCategoriaRemota(local.categoriaId!);
    }
    await _subirCatalogoRow('productos', productoToSyncMap(local));
  }

  /// Sube la categoría de un producto si el server no la tiene (misma lógica
  /// de auto-curado para no romper `productos.categoria_id`).
  Future<void> _garantizarCategoriaRemota(int categoriaId) async {
    final exists = await client
        .from('categorias')
        .select('id')
        .eq('id', categoriaId)
        .maybeSingle();
    if (exists != null) return;

    final local = await (_db.select(_db.categorias)
          ..where((t) => t.id.equals(categoriaId)))
        .getSingleOrNull();
    if (local == null) return;
    await _subirCatalogoRow('categorias', categoriaToSyncMap(local));
  }

  /// Sube filas del catálogo local (categorías, productos, proveedores) que el
  /// server no tiene. Cubre datos creados antes de que la creación encolara, o
  /// cuyo encolado quedó huérfano. El server asigna el id y se re-mapea.
  Future<void> _subirCatalogoLocalFaltante() async {
    // Comprobaciones en paralelo (Future.wait): cada fila es independiente.
    // El orden por tipo se conserva (categorías → productos → proveedores)
    // porque un producto puede auto-curar su categoría; dentro de cada tipo
    // todas las peticiones van a la vez, recortando la latencia del ciclo.
    final categorias = await _db.select(_db.categorias).get();
    await Future.wait(categorias.map((c) async {
      try {
        final exists = await client
            .from('categorias')
            .select('id')
            .eq('id', c.id)
            .maybeSingle();
        if (exists == null) {
          await _subirCatalogoRow('categorias', categoriaToSyncMap(c));
        }
      } catch (e) {
        _log('Error subiendo categoría ${c.id}: $e');
      }
    }));

    final productos = await _db.select(_db.productos).get();
    await Future.wait(productos.map((p) async {
      try {
        final exists = await client
            .from('productos')
            .select('id')
            .eq('id', p.id)
            .maybeSingle();
        if (exists == null) {
          if (p.categoriaId != null) await _garantizarCategoriaRemota(p.categoriaId!);
          await _subirCatalogoRow('productos', productoToSyncMap(p));
        }
      } catch (e) {
        _log('Error subiendo producto ${p.id}: $e');
      }
    }));

    final proveedores = await _db.select(_db.proveedores).get();
    await Future.wait(proveedores.map((p) async {
      try {
        final exists = await client
            .from('proveedores')
            .select('id')
            .eq('id', p.id)
            .maybeSingle();
        if (exists == null) {
          await _subirCatalogoRow('proveedores', proveedorToSyncMap(p));
        }
      } catch (e) {
        _log('Error subiendo proveedor ${p.id}: $e');
      }
    }));
  }

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
        // Auto-curado de FK: si el producto referenciado no existe en el
        // server (ej. creado localmente antes de que el outbox lo subiera),
        // se sube primero. Puede re-mapear el id del producto, así que se
        // re-lee el movimiento para usar el id remoto vigente.
        await _garantizarProductoRemoto(mov.productoId);
        final actual = await (_db.select(_db.movimientos)
              ..where((t) => t.id.equals(mov.id)))
            .getSingleOrNull();
        final productoId = actual?.productoId ?? mov.productoId;
        // Id local vigente: se alinea con el del server al subir (abajo), para
        // que la descarga incremental por `created_at` no reintroduzca la fila.
        var localId = mov.id;

        int? remoteFacturaId = await _resolveFacturaIdRemoto(mov.facturaId);
        int? remoteRequisicionId =
            await _resolveRequisicionIdRemoto(mov.requisicionId, mov.tipo);

        if (mov.requisicionId != null &&
            remoteRequisicionId == null &&
            (mov.tipo == 'tr_salida' || mov.tipo == 'tr_entrada')) {
          continue; // postergar
        }

        // Buscar coincidencia por campos clave. La fecha se compara por
        // ventana del mismo segundo: el server puede guardarla sin
        // microsegundos, así que el match exacto duplicaba filas.
        Map<String, dynamic>? match;
        if (mov.fechaMovimiento != null) {
          final target = mov.fechaMovimiento!.toUtc();
          final start = DateTime.utc(target.year, target.month, target.day,
              target.hour, target.minute, target.second);
          final rows = await client
              .from('movimientos')
              .select('id,fecha_movimiento')
              .eq('producto_id', productoId)
              .eq('tipo', mov.tipo)
              .eq('cantidad', mov.cantidad)
              .gte('fecha_movimiento', start.toIso8601String())
              .lt('fecha_movimiento', start.add(const Duration(seconds: 1)).toIso8601String())
              .eq('almacen', mov.almacen ?? '')
              .limit(5);
            PostgrestMap? best;
            var bestDelta = const Duration(seconds: 1);
            for (final r in rows) {
              final dt = _toDt(r['fecha_movimiento']);
              if (dt == null) continue;
              final delta = dt.toUtc().difference(target).abs();
              if (delta < bestDelta) {
                bestDelta = delta;
                best = r;
              }
            }
            match = best;
        }
        if (match != null) {
          final updates = <String, dynamic>{};
          if (remoteFacturaId != null) updates['factura_id'] = remoteFacturaId;
          if (remoteRequisicionId != null) updates['requisicion_id'] = remoteRequisicionId;
          if (mov.ventaSyncUuid != null) updates['venta_sync_uuid'] = mov.ventaSyncUuid;
          if (updates.isNotEmpty) {
            await client.from('movimientos').update(updates).eq('id', match['id']);
          }
          // Alinear id local con el del server (misma fila ya subida en un
          // ciclo anterior con la factura/requisición sin resolver).
          final remoteId = _toInt(match['id']);
          if (remoteId != null && remoteId != localId) {
            await (_db.update(_db.movimientos)..where((t) => t.id.equals(localId)))
                .write(MovimientosCompanion(id: Value(remoteId)));
            localId = remoteId;
          }
        } else {
          final ins = await client.from('movimientos').insert({
            'producto_id': productoId,
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
            // Fecha normalizada sin microsegundos para match consistente.
            'fecha_movimiento': _toSecondUtc(mov.fechaMovimiento)?.toIso8601String(),
          }).select('id').single();
          final remoteId = _toInt(ins['id']);
          if (remoteId != null && remoteId != localId) {
            await (_db.update(_db.movimientos)..where((t) => t.id.equals(localId)))
                .write(MovimientosCompanion(id: Value(remoteId)));
            localId = remoteId;
          }
        }

        if (mov.facturaId != null && remoteFacturaId == null) continue;
        if (mov.requisicionId != null &&
            remoteRequisicionId == null &&
            (mov.tipo == 'tr_salida' || mov.tipo == 'tr_entrada')) {
          continue;
        }

        await (_db.update(_db.movimientos)..where((t) => t.id.equals(localId)))
            .write(const MovimientosCompanion(sincronizado: Value(1)));
        _log('Movimiento $localId sincronizado');
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
    final lastSync = await _getLastFullSync();

    // Descarga las tablas en paralelo (Future.wait): el HTTP es el cuello de
    // botella y las tablas son independientes (SQLite no aplica FKs), así que
    // bajar 16 tablas una a una en serie alargaba el ciclo 10-20s. Las
    // escrituras se serializan solas en la única conexión de drift.
    await Future.wait(syncedTables.map((desc) => _descargarTabla(desc, lastSync)));
  }

  Future<void> _descargarTabla(
    SyncTableDescriptor desc,
    DateTime? lastSync,
  ) async {
    try {
      // Descarga incremental cuando la tabla ya sincronizó y tiene columna
      // de cambio: reduce egress (movimientos/productos grandes no se vuelven
      // a descargar completos cada ciclo).
      final inc = desc.incrementalColumn;
      final incById = desc.incrementalById;
      // `select()` devuelve PostgrestFilterBuilder (tiene `or`); los métodos
      // `order`/`range` viven en PostgrestTransformBuilder (superclase), así
      // que se usa una variable filtro y se pasa a la de transformación.
      final filtro = client.from(desc.serverTable).select();
      PostgrestTransformBuilder<List<Map<String, dynamic>>> q = filtro;
      final localEmpty = await _isTableEmpty(desc.localTable);
      // Incremental: solo las filas que cambiaron desde el último sync
      // (reducir egress: con full-download cada ciclo se excedió la cuota
      // de Supabase, 254%). Incluye `is.null` para capturar filas creadas
      // desde la web que no setean la columna de timestamp.
      if (!localEmpty && lastSync != null && inc != null) {
        final ts = lastSync.toIso8601String();
        q = filtro.or('${inc}.is.null,${inc}.gte.$ts');
      } else if (!localEmpty && incById != null) {
        final maxId = await _maxLocalId(desc.localTable);
        if (maxId != null) q = filtro.gt(incById, maxId);
      }
      // Orden estable para paginar sin solapamientos/omisiones (todas las
      // tablas sincronizadas tienen `id`, salvo stock_checkpoint).
      if (desc.localTable != 'stock_checkpoint') {
        q = q.order('id');
      }

      // Supabase REST limita a 1000 filas por petición: paginar con `range`
      // para no perder datos históricos (p.ej. movimientos de facturas
      // antiguas, que quedaban sin vincular en el detalle).
      const pageSize = 1000;
      var offset = 0;
      var total = 0;
      while (true) {
        final data = await q.range(offset, offset + pageSize - 1);
        final rows = (data as List).cast<Map<String, dynamic>>();
        if (rows.isEmpty) break;
        await upsertLocalBatch(desc, rows);
        total += rows.length;
        offset += pageSize;
      }
      if (total > 0) _log('$total ${desc.serverTable} descargados');

      // Prune: eliminar filas locales que ya no existen en el server.
      if (desc.pruneDeletes && !localEmpty) {
        await _pruneDeletedRows(desc);
      }
    } catch (e) {
      _log('Error descargando ${desc.serverTable}: $e');
    }
  }

  /// Elimina filas locales que ya no existen en Supabase (detecta deletes
  /// hechos desde otros dispositivos). Solo se ejecuta en tablas con
  /// `pruneDeletes: true` (ids server-assigned).
  Future<void> _pruneDeletedRows(SyncTableDescriptor desc) async {
    try {
      // 1. Obtener IDs pendientes en outbox (no borrar filas que aún no se
      //    han subido al server).
      final pendingOps = await (_db.select(_db.syncQueue)
            ..where((t) =>
                t.targetTable.equals(desc.serverTable) &
                t.status.equals('pending')))
          .get();
      final pendingIds = <int>{};
      for (final op in pendingOps) {
        try {
          final data = jsonDecode(op.data) as Map<String, dynamic>;
          final id = data['id'];
          if (id is num) pendingIds.add(id.toInt());
        } catch (_) {}
      }

      // 2. Obtener todos los IDs del server (paginados).
      final serverIds = <int>{};
      var offset = 0;
      while (true) {
        final data = await client
            .from(desc.serverTable)
            .select('id')
            .order('id')
            .range(offset, offset + 999);
        final rows = (data as List).cast<Map<String, dynamic>>();
        if (rows.isEmpty) break;
        for (final r in rows) {
          serverIds.add((r['id'] as num).toInt());
        }
        offset += rows.length;
      }

      if (serverIds.isEmpty) return;

      // 3. Obtener IDs locales.
      final localRows = await _db.customSelect(
        'SELECT id FROM ${desc.localTable}',
      ).get();
      final localIds = localRows.map((r) => r.read<int>('id')!).toSet();

      // 4. Borrar locales que no están en el server (y no están pendientes).
      final toDelete = localIds.difference(serverIds).difference(pendingIds);
      if (toDelete.isEmpty) return;

      // Usar IN (...) con lista plana paraDELETE masivo.
      final placeholders = List.filled(toDelete.length, '?').join(',');
      await _db.customStatement(
        'DELETE FROM ${desc.localTable} WHERE id IN ($placeholders)',
        toDelete.toList(),
      );
      _log('[${desc.localTable}] ${toDelete.length} filas eliminadas (prune)');
    } catch (e) {
      _log('Error en prune ${desc.localTable}: $e');
    }
  }

  /// True si la tabla local no tiene filas. Se usa para forzar una descarga
  /// completa la primera vez, aunque ya exista `last_sync` (p.ej. tablas que
  /// nunca se poblaron por `updated_at` NULL en el servidor).
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

  /// Máximo id local de una tabla de solo-descarga. Como esos ids SIEMPRE son
  /// los del server (SERIAL monotónico), `id > MAX(id)` trae exactamente las
  /// filas nuevas sin re-descargar el historial.
  Future<int?> _maxLocalId(String table) async {
    try {
      final q = await _db.customSelect(
        'SELECT COALESCE(MAX(id),0) AS max_id FROM $table',
      ).getSingle();
      return q.read<int>('max_id');
    } catch (_) {
      return null;
    }
  }

  Future<DateTime?> _getLastFullSync() async {
    try {
      final row = await (_db.select(_db.syncMetadata)
            ..where((t) => t.key.equals('last_sync_full')))
          .getSingleOrNull();
      if (row == null || row.value == null) return null;
      final t = DateTime.tryParse(row.value!);
      // Margen de 10s hacia atrás: las columnas son TEXT con ISO (a veces
      // `+00:00` vs `Z`); el `gte` es lexicográfico y la escritura cae en el
      // mismo segundo que `_setLastSync`. Re-bajar el límite cubre filas en
      // ese límite (el upsert es idempotente, re-descargar 10s es barato).
      if (t != null) return t.subtract(const Duration(seconds: 10));
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> upsertLocalBatch(
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
                activo: Value(_toBoolInt(r['activo'], def: 1)),
                visibleEnPos: Value(_toBoolInt(r['visible_en_pos'], def: 1)),
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
          // Deduplica por (producto_id, almacen) quedándose con el id más alto
          // (último estado) para no reintroducir filas duplicadas del servidor.
          final porClave = <(int?, String), Map<String, dynamic>>{};
          for (final r in rows) {
            final clave = (_toInt(r['producto_id']), r['almacen'] as String);
            final prev = porClave[clave];
            if (prev == null ||
                (_toInt(r['id']) ?? 0) > (_toInt(prev['id']) ?? 0)) {
              porClave[clave] = r;
            }
          }
          for (final r in porClave.values) {
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
          // Descarga incremental por `created_at` (ids locales alineados al
          // server al subir); aquí solo se insertan/upsertan las filas nuevas.
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
                sincronizado: const Value(1),
              ),
            );
          }
        case 'movimientos_archivo':
          for (final r in rows) {
            await _db.into(_db.movimientosArchivo).insertOnConflictUpdate(
              MovimientosArchivoCompanion.insert(
                id: Value((r['id'] as num).toInt()),
                productoId: _toInt(r['producto_id']) ?? 0,
                facturaId: Value(_toInt(r['factura_id'])),
                requisicionId: Value(_toInt(r['requisicion_id'])),
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
      await _subirCatalogoLocalFaltante();
      await _uploadPendingMovimientos();
      await _downloadAllFromServer();
      await _setLastSync();
      _log('Sincronización completa finalizada');
      onSyncComplete?.call();
      return true;
    } catch (e, st) {
      final detalle = '$e\n$st';
      _log('Error en sincronización: $e');
      onSyncError?.call(detalle);
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

  /// Sube de inmediato las operaciones pendientes (outbox + movimientos
  /// con `sincronizado=0`), sin descargar. Réplica de movements.py:
  /// tras registrar un movimiento, intenta syncar al momento si hay
  /// conexión; si falla, queda pendiente para el siguiente ciclo.
  Future<void> pushPending() async {
    if (_running) return;
    _running = true;
    try {
      await _processOutbox();
      await _uploadPendingMovimientos();
    } catch (e, st) {
      final detalle = '$e\n$st';
      _log('Error en push pendientes: $e');
      onSyncError?.call(detalle);
    } finally {
      _running = false;
    }
  }

  Future<void> _setLastSync() async {
    await _db.into(_db.syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion.insert(
        key: 'last_sync_full',
        // UTC: las columnas remotas (timestamptz) devuelven UTC; guardar local
        // rompería el `gte` en la descarga incremental.
        value: Value(DateTime.now().toUtc().toIso8601String()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Estado de modo offline forzado.
  bool _offlineMode = false;

  bool get isOffline => _offlineMode;

  void setOfflineMode(bool v) {
    _offlineMode = v;
  }

  // ---------------------------------------------------------------------
  // Realtime: escuchar cambios remotos en tiempo real
  // ---------------------------------------------------------------------

  /// Inicia suscripciones Realtime para todas las tablas sincronizadas.
  ///
  /// Cuando otro dispositivo escribe en Supabase, el evento llega por
  /// WebSocket y se aplica localmente vía upsert, sin esperar el timer
  /// de polling. Esto permite que el teléfono 2 vea lo que creó el
  /// teléfono 1 inmediatamente.
  void startRealtime() {
    if (_realtime == null) return;
    for (final desc in syncedTables) {
      final sub = _realtime!.watchTable(desc.serverTable).listen(
        (event) => _handleRealtimeEvent(desc, event),
      );
      _realtimeSubs.add(sub);
    }
    _log('Realtime activo para ${syncedTables.length} tablas');
  }

  /// Detiene las suscripciones Realtime.
  void stopRealtime() {
    for (final sub in _realtimeSubs) {
      sub.cancel();
    }
    _realtimeSubs.clear();
  }

  /// Procesa un evento Realtime: aplica el cambio localmente vía upsert.
  Future<void> _handleRealtimeEvent(
    SyncTableDescriptor desc,
    RealtimeEvent event,
  ) async {
    try {
      // DELETE: borrar la fila local si existe.
      if (event.operation == RealtimeOperation.delete) {
        final id = event.row['id'];
        if (id != null) {
          await _db.customStatement(
            'DELETE FROM ${desc.localTable} WHERE id = ?',
            [(id as num).toInt()],
          );
        }
        return;
      }

      // INSERT / UPDATE: upsert local con la misma lógica de descarga.
      await upsertLocalBatch(desc, [event.row]);
    } catch (e) {
      _log('Error en realtime ${desc.serverTable}: $e');
    }
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

/// Trunca la fecha a UTC al segundo (sin microsegundos), para que el match
/// en el server sea estable (el server puede guardar sin microsegundos).
DateTime? _toSecondUtc(DateTime? v) {
  if (v == null) return null;
  final u = v.toUtc();
  return DateTime.utc(
      u.year, u.month, u.day, u.hour, u.minute, u.second);
}

/// Versión pública de `_toSecondUtc` como ISO string, para que el outbox de
/// borrado de movimientos normalice la fecha igual que la subida.
String? toSecondUtcIsoString(DateTime? v) => _toSecondUtc(v)?.toIso8601String();

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