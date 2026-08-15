import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/sync/sync_service.dart';

/// Repositorio de comandas y ventas del POS — porta la sección VENTAS/COMANDAS
/// de `LocalReplica` (cerrar_comanda, registrar_venta, anular_venta, etc.).
///
/// Las comandas/ventas se sincronizan por `sync_uuid` (no por id local):
/// cada mutación encola el row completo y el `PosSyncEngine` sube por uuid.
/// Las ventas generan movimientos tipo `venta`/`devolucion` (sincronizado=0)
/// que sube el sync general por `venta_sync_uuid`.
class PosVentasRepository {
  PosVentasRepository(this._db);

  final AppDatabase _db;

  static const Uuid _uuid = Uuid();

  // ---------------------------------------------------------------------
  // Comandas
  // ---------------------------------------------------------------------

  /// Guarda la comanda abierta de mesa/habitación (upsert por mesa/hab,
  /// réplica de `save_comanda`). Retorna el id de la comanda.
  Future<int> guardarComanda(
    int sesionId,
    List<Map<String, dynamic>> items,
    double total, {
    int? mesaId,
    int? habitacionId,
  }) async {
    final now = DateTime.now();
    final itemsJson = jsonEncode(items);
    PosComanda? existente;
    String? syncUuid;
    if (mesaId != null) {
      existente = await (_db.select(_db.posComandas)
            ..where((t) => t.mesaId.equals(mesaId) & t.estado.equals('abierta'))
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
    } else if (habitacionId != null) {
      existente = await (_db.select(_db.posComandas)
            ..where((t) =>
                t.habitacionId.equals(habitacionId) & t.estado.equals('abierta'))
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
    }
    int id;
    if (existente != null) {
      id = existente.id;
      syncUuid = existente.syncUuid;
      await (_db.update(_db.posComandas)..where((t) => t.id.equals(id)))
          .write(PosComandasCompanion(
        itemsJson: Value(itemsJson),
        total: Value(total),
        updatedAt: Value(now),
      ));
    } else {
      syncUuid = _uuid.v4();
      id = await _db.into(_db.posComandas).insert(
            PosComandasCompanion.insert(
              sesionId: sesionId,
              mesaId: Value(mesaId),
              habitacionId: Value(habitacionId),
              estado: const Value('abierta'),
              total: Value(total),
              itemsJson: Value(itemsJson),
              syncUuid: Value(syncUuid),
              createdAt: now,
            ),
          );
    }
    await _encolarComanda(id, syncUuid);
    return id;
  }

  Future<PosComanda?> getComanda(int id) =>
      (_db.select(_db.posComandas)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<PosComanda?> getComandaAbierta(
      {int? mesaId, int? habitacionId}) async {
    if (mesaId != null) {
      return (_db.select(_db.posComandas)
            ..where((t) => t.mesaId.equals(mesaId) & t.estado.equals('abierta'))
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
    }
    if (habitacionId != null) {
      return (_db.select(_db.posComandas)
            ..where((t) =>
                t.habitacionId.equals(habitacionId) & t.estado.equals('abierta'))
            ..orderBy([(t) => OrderingTerm.desc(t.id)])
            ..limit(1))
          .getSingleOrNull();
    }
    return null;
  }

  Future<List<PosComanda>> getComandasAbiertas() =>
      (_db.select(_db.posComandas)..where((t) => t.estado.equals('abierta')))
          .get();

  /// Ocupadas: set de mesa_id con comanda abierta.
  Future<Set<int>> getMesasOcupadas() async {
    final rows = await (_db.select(_db.posComandas)
          ..where((t) => t.estado.equals('abierta') & t.mesaId.isNotNull()))
        .get();
    return {for (final c in rows) c.mesaId!};
  }

  Future<Set<int>> getHabitacionesOcupadas() async {
    final rows = await (_db.select(_db.posComandas)
          ..where(
              (t) => t.estado.equals('abierta') & t.habitacionId.isNotNull()))
        .get();
    return {for (final c in rows) c.habitacionId!};
  }

  Future<void> cambiarEstadoComanda(int comandaId, String estado) async {
    final ahora = DateTime.now();
    await (_db.update(_db.posComandas)..where((t) => t.id.equals(comandaId)))
        .write(PosComandasCompanion(
          estado: Value(estado),
          updatedAt: Value(ahora),
        ));
    final c = await getComanda(comandaId);
    if (c != null) await _encolarComanda(comandaId, c.syncUuid);
  }

  /// Cierra la comanda tras cobrarla, réplica de `cerrar_comanda`.
  Future<void> cerrarComanda(int comandaId) =>
      cambiarEstadoComanda(comandaId, 'cerrada');

  /// Elimina comanda abierta y encola el borrado (con tombstone para que la
  /// descarga no la reintroduzca desde otro dispositivo).
  Future<void> eliminarComanda(int comandaId) async {
    final c = await getComanda(comandaId);
    await (_db.delete(_db.posComandas)..where((t) => t.id.equals(comandaId)))
        .go();
    final syncUuid = c?.syncUuid;
    if (syncUuid != null && syncUuid.isNotEmpty) {
      await _tombstone(syncUuid, 'pos_comandas');
      await addPending(_db,
          tableName: 'pos_comandas',
          operation: 'delete',
          data: {'sync_uuid': syncUuid});
    }
  }

  Future<void> _encolarComanda(int comandaId, String? syncUuid) async {
    final c = await (_db.select(_db.posComandas)
          ..where((t) => t.id.equals(comandaId)))
        .getSingleOrNull();
    if (c == null) return;
    await addPending(_db,
        tableName: 'pos_comandas',
        operation: 'upsert',
        data: {
          'sync_uuid': syncUuid ?? c.syncUuid,
          'sesion_id': c.sesionId,
          'mesa_id': c.mesaId,
          'habitacion_id': c.habitacionId,
          'estado': c.estado,
          'total': c.total,
          'items_json': c.itemsJson,
          'created_at': c.createdAt.toIso8601String(),
          'updated_at':
              c.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        });
  }

  // ---------------------------------------------------------------------
  // Ventas
  // ---------------------------------------------------------------------

  Future<int> siguienteCorrelativo() async {
    final q = await _db.customSelect(
      'SELECT COALESCE(MAX(correlativo), 0) AS max_corr FROM pos_ventas',
    ).getSingle();
    return q.read<int>('max_corr') + 1;
  }

  /// Réplica de `registrar_venta`: inserta la venta y encola el upsert.
  Future<int> registrarVenta(
    int correlativo,
    double total,
    List<Map<String, dynamic>> items, {
    int? comandaId,
    int? mesaId,
    int? habitacionId,
    int? usuarioId,
    int? sesionId,
    int? ventaAnulaId,
    double? tasaBs,
  }) async {
    final now = DateTime.now();
    final syncUuid = _uuid.v4();
    String? comandaSyncUuid;
    if (comandaId != null) {
      final c = await getComanda(comandaId);
      comandaSyncUuid = c?.syncUuid;
    }
    String? ventaAnulaSyncUuid;
    if (ventaAnulaId != null) {
      final v = await (_db.select(_db.posVentas)
            ..where((t) => t.id.equals(ventaAnulaId)))
          .getSingleOrNull();
      ventaAnulaSyncUuid = v?.syncUuid;
    }
    final ventaId = await _db.into(_db.posVentas).insert(
          PosVentasCompanion.insert(
            comandaId: Value(comandaId),
            correlativo: Value(correlativo),
            total: Value(total),
            itemsJson: Value(jsonEncode(items)),
            mesaId: Value(mesaId),
            habitacionId: Value(habitacionId),
            usuarioId: Value(usuarioId),
            sesionId: Value(sesionId),
            estado: const Value('vigente'),
            ventaAnulaId: Value(ventaAnulaId),
            tasaBs: Value(tasaBs),
            syncUuid: Value(syncUuid),
            comandaSyncUuid: Value(comandaSyncUuid),
            ventaAnulaSyncUuid: Value(ventaAnulaSyncUuid),
            createdAt: now,
            updatedAt: Value(now),
          ),
        );
    await _encolarVenta(ventaId, syncUuid);
    return ventaId;
  }

  /// Aplica los movimientos de venta (salida de mercancía + existencias),
  /// réplica de `aplicar_movimientos_venta`.
  Future<void> aplicarMovimientosVenta(
    int ventaId,
    List<Map<String, dynamic>> movimientos, {
    String? registradoPor,
  }) async {
    final venta = await (_db.select(_db.posVentas)
          ..where((t) => t.id.equals(ventaId)))
        .getSingleOrNull();
    final vsu = venta?.syncUuid ?? '';
    final now = DateTime.now();
    for (final mov in movimientos) {
      final productoId = mov['producto_id'] as int?;
      final cantidad = (mov['cantidad'] as num?)?.toDouble() ?? 0;
      final almacen = (mov['almacen'] as String?)?.trim() ?? 'principal';
      if (productoId == null || cantidad <= 0) continue;
      final ex = await (_db.select(_db.existencias)
            ..where((t) =>
                t.productoId.equals(productoId) & t.almacen.equals(almacen)))
          .getSingleOrNull();
      final cantAnterior = ex?.cantidad ?? 0;
      final cantNueva = cantAnterior - cantidad;
      var obs = 'Venta #$ventaId';
      if (mov['producto_nombre'] != null) obs += ' - ${mov['producto_nombre']}';
      if (cantNueva < 0) obs += ' [STOCK INSUFICIENTE]';
      await _db.into(_db.movimientos).insert(
            MovimientosCompanion.insert(
              productoId: productoId,
              ventaId: Value(ventaId),
              ventaSyncUuid: Value(vsu.isEmpty ? null : vsu),
              tipo: 'venta',
              cantidad: cantidad,
              cantidadAnterior: Value(cantAnterior),
              cantidadNueva: Value(cantNueva),
              pesoTotal: const Value(0),
              registradoPor: Value(registradoPor),
              observaciones: Value(obs),
              almacen: Value(almacen),
              fechaMovimiento: Value(now),
              createdAt: Value(now),
              sincronizado: const Value(0),
            ),
          );
      if (ex != null) {
        await (_db.update(_db.existencias)
              ..where((t) =>
                  t.productoId.equals(productoId) & t.almacen.equals(almacen)))
            .write(ExistenciasCompanion(cantidad: Value(cantNueva)));
      }
    }
  }

  /// Réplica de `anular_venta`: marca anulada y re-encola el upsert.
  Future<void> anularVenta(int ventaId,
      {String? anuladaPor, String motivo = 'Correccion'}) async {
    final now = DateTime.now();
    await (_db.update(_db.posVentas)..where((t) => t.id.equals(ventaId)))
        .write(PosVentasCompanion(
          estado: const Value('anulada'),
          motivoAnulacion: Value(motivo),
          anuladaPor: Value(anuladaPor),
          anuladaEn: Value(now),
          updatedAt: Value(now),
        ));
    await _encolarVenta(ventaId);
  }

  /// Réplica de `revertir_movimientos_venta`: devuelve stock (tipo 'devolucion').
  Future<void> revertirMovimientosVenta(int ventaId,
      {String? registradoPor}) async {
    final venta = await (_db.select(_db.posVentas)
          ..where((t) => t.id.equals(ventaId)))
        .getSingleOrNull();
    final vsu = venta?.syncUuid ?? '';
    final movs = await (_db.select(_db.movimientos)
          ..where((t) => t.ventaId.equals(ventaId) & t.tipo.equals('venta')))
        .get();
    final now = DateTime.now();
    for (final m in movs) {
      final almacen = m.almacen ?? 'principal';
      final cantidad = m.cantidad;
      if (cantidad <= 0) continue;
      final ex = await (_db.select(_db.existencias)
            ..where((t) =>
                t.productoId.equals(m.productoId) & t.almacen.equals(almacen)))
          .getSingleOrNull();
      final cantAnterior = ex?.cantidad ?? 0;
      final cantNueva = cantAnterior + cantidad;
      await _db.into(_db.movimientos).insert(
            MovimientosCompanion.insert(
              productoId: m.productoId,
              ventaId: Value(ventaId),
              ventaSyncUuid: Value(vsu.isEmpty ? null : vsu),
              tipo: 'devolucion',
              cantidad: cantidad,
              cantidadAnterior: Value(cantAnterior),
              cantidadNueva: Value(cantNueva),
              pesoTotal: const Value(0),
              registradoPor: Value(registradoPor),
              observaciones: Value('Devolucion venta #$ventaId'),
              almacen: Value(almacen),
              fechaMovimiento: Value(now),
              createdAt: Value(now),
              sincronizado: const Value(0),
            ),
          );
      if (ex != null) {
        await (_db.update(_db.existencias)
              ..where((t) =>
                  t.productoId.equals(m.productoId) & t.almacen.equals(almacen)))
            .write(ExistenciasCompanion(cantidad: Value(cantNueva)));
      }
    }
  }

  /// Elimina venta no impresa y sus movimientos, restaurando stock y
  /// encolando tombstone + delete (réplica `eliminar_venta_y_movimientos`).
  Future<void> eliminarVentaYMovimientos(int ventaId) async {
    final venta = await (_db.select(_db.posVentas)
          ..where((t) => t.id.equals(ventaId)))
        .getSingleOrNull();
    final syncUuid = venta?.syncUuid;
    final movs = await (_db.select(_db.movimientos)
          ..where((t) => t.ventaId.equals(ventaId)))
        .get();
    for (final m in movs) {
      final almacen = m.almacen ?? 'principal';
      await (_db.update(_db.existencias)
            ..where((t) =>
                t.productoId.equals(m.productoId) & t.almacen.equals(almacen)))
          .write(ExistenciasCompanion(cantidad: Value(m.cantidadAnterior)));
    }
    await (_db.delete(_db.movimientos)..where((t) => t.ventaId.equals(ventaId)))
        .go();
    await (_db.delete(_db.posVentas)..where((t) => t.id.equals(ventaId))).go();
    if (syncUuid != null && syncUuid.isNotEmpty) {
      await _tombstone(syncUuid, 'pos_ventas');
      for (final m in movs) {
        final mvsu = m.ventaSyncUuid;
        if (mvsu != null && mvsu.isNotEmpty) {
          await _tombstone(mvsu, 'movimientos');
        }
      }
      await addPending(_db,
          tableName: 'pos_ventas', operation: 'delete', data: {'sync_uuid': syncUuid});
    }
  }

  Future<List<PosVenta>> getVentas({int limit = 200}) {
    final q = _db.select(_db.posVentas)
      ..orderBy([(t) => OrderingTerm.desc(t.id)])
      ..limit(limit);
    return q.get();
  }

  Future<PosVenta?> getVenta(int id) =>
      (_db.select(_db.posVentas)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Mapa {id: correlativo} de las ventas indicadas.
  Future<Map<int, int>> getVentasCorrelativos(List<int> ids) async {
    if (ids.isEmpty) return {};
    final rows = await (_db.select(_db.posVentas)
          ..where((t) => t.id.isIn(ids)))
        .get();
    return {
      for (final v in rows)
        if (v.correlativo != null) v.id: v.correlativo!,
    };
  }

  /// Última venta anulada de una comanda (para saber si el próximo cobro
  /// es una corrección), réplica de `get_venta_anulada_by_comanda`.
  Future<PosVenta?> getVentaAnuladaPorComanda(int comandaId) {
    return (_db.select(_db.posVentas)
          ..where((t) =>
              t.comandaId.equals(comandaId) & t.estado.equals('anulada'))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Última venta cobrada que sigue vigente, réplica de `get_ultima_venta_vigente`.
  Future<PosVenta?> getUltimaVentaVigente() {
    return (_db.select(_db.posVentas)
          ..where((t) => t.estado.equals('vigente'))
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Reabre una comanda cerrada (para corrección/venta devuelta).
  Future<void> reabrirComanda(int comandaId) =>
      cambiarEstadoComanda(comandaId, 'abierta');

  Future<Producto?> getProductoById(int productoId) {
    return (_db.select(_db.productos)
          ..where((t) => t.id.equals(productoId)))
        .getSingleOrNull();
  }

  /// Ingredientes de un plato/contorno (con nombre del producto).
  Future<List<({int id, int platoId, int productoId, double cantidad, String unidad, String nombre})>>
      getPlatoIngredientes(int platoId) async {
    final rows = await (_db.select(_db.platoIngredientes)
          ..where((t) => t.platoId.equals(platoId)))
        .get();
    final nombres = <int, String>{};
    for (final r in rows) {
      final p = await getProductoById(r.productoId);
      nombres[r.productoId] = p?.nombre ?? 'Producto #${r.productoId}';
    }
    return [
      for (final r in rows)
        (
          id: r.id,
          platoId: r.platoId,
          productoId: r.productoId,
          cantidad: r.cantidad,
          unidad: r.unidad,
          nombre: nombres[r.productoId] ?? '?',
        ),
    ];
  }

  /// Resuelve cada item de la comanda a los productos de inventario a
  /// descontar (réplica de `resolver_movimientos_venta`):
  /// - Item en tabla `productos`: descuenta el producto mismo (almacén restaurante).
  /// - Plato/contorno con ingredientes: descuenta cada ingrediente x cantidad.
  /// - Plato/contorno sin ingredientes: NO genera movimiento.
  Future<List<Map<String, dynamic>>> resolverMovimientosVenta(
      List<Map<String, dynamic>> items) async {
    final acumulado = <(int, String), Map<String, dynamic>>{};

    void acumular(int productoId, String nombre, double cantidad, String almacen) {
      final key = (productoId, almacen);
      final m = acumulado.putIfAbsent(key, () => {
            'producto_id': productoId,
            'producto_nombre': nombre,
            'cantidad': 0.0,
            'almacen': almacen,
          });
      m['cantidad'] = (m['cantidad'] as double) + cantidad;
    }

    Future<void> acumularIngredientes(int platoId, double cant) async {
      final ing = await getPlatoIngredientes(platoId);
      for (final i in ing) {
        acumular(i.productoId, i.nombre, i.cantidad * cant, 'restaurante');
      }
    }

    for (final item in items) {
      final pid = item['id'] as int?;
      final cant = (item['cantidad'] as num?)?.toDouble() ?? 1;
      if (pid == null) continue;

      final tipo = (item['tipo'] as String? ?? '').toLowerCase();
      final prod = await getProductoById(pid);
      if (tipo == 'producto' || prod != null) {
        acumular(pid, prod?.nombre ?? 'Producto #$pid', cant, 'restaurante');
      } else {
        await acumularIngredientes(pid, cant);
      }

      final cids = <int>[
        ...?((item['contorno_ids'] as List?)?.cast<num>().map((n) => n.toInt())),
      ];
      for (final cid in cids) {
        await acumularIngredientes(cid, cant);
      }
    }
    return acumulado.values.toList();
  }

  /// Descargos de inventario de una venta (réplica de `get_movimientos_venta`).
  Future<List<Map<String, dynamic>>> getMovimientosVenta(int ventaId) async {
    final rows = await (_db.select(_db.movimientos)
          ..where((t) => t.ventaId.equals(ventaId) & t.tipo.equals('venta')))
        .get();
    final result = <Map<String, dynamic>>[];
    for (final m in rows) {
      final p = await getProductoById(m.productoId);
      result.add({
        'producto_id': m.productoId,
        'cantidad': m.cantidad,
        'almacen': m.almacen,
        'producto_nombre': p?.nombre ?? 'Producto #${m.productoId}',
      });
    }
    result.sort((a, b) =>
        (a['producto_nombre'] as String).compareTo(b['producto_nombre'] as String));
    return result;
  }

  Future<void> _encolarVenta(int ventaId, [String? syncUuid]) async {
    final v = await (_db.select(_db.posVentas)
          ..where((t) => t.id.equals(ventaId)))
        .getSingleOrNull();
    if (v == null) return;
    await addPending(_db,
        tableName: 'pos_ventas',
        operation: 'upsert',
        data: {
          'sync_uuid': syncUuid ?? v.syncUuid,
          'comanda_sync_uuid': v.comandaSyncUuid,
          'venta_anula_sync_uuid': v.ventaAnulaSyncUuid,
          'correlativo': v.correlativo,
          'total': v.total,
          'items_json': v.itemsJson,
          'mesa_id': v.mesaId,
          'habitacion_id': v.habitacionId,
          'usuario_id': v.usuarioId,
          'sesion_id': v.sesionId,
          'estado': v.estado,
          'motivo_anulacion': v.motivoAnulacion,
          'anulada_por': v.anuladaPor,
          'anulada_en': v.anuladaEn?.toIso8601String(),
          'tasa_bs': v.tasaBs,
          'created_at': v.createdAt.toIso8601String(),
          'updated_at':
              v.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        });
  }

  Future<void> _tombstone(String uuid, String tabla) async {
    await _db.into(_db.posSyncTombstones).insertOnConflictUpdate(
          PosSyncTombstonesCompanion.insert(
            uuid: uuid,
            tabla: Value(tabla),
            createdAt: Value(DateTime.now()),
          ),
        );
  }
}
