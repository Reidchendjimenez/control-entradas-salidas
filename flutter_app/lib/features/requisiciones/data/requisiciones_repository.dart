import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/sync/sync_service.dart';

/// Item de una requisición (usa una estructura libre como en Python,
/// donde los productos vienen de un buscador y el peso es opcional).
class RequisicionItem {
  const RequisicionItem({
    this.productoId,
    required this.ingrediente,
    required this.cantidad,
    this.unidad = 'unidad',
    this.peso,
    this.esPesable = false,
    this.verificado = 0,
  });

  final int? productoId;
  final String ingrediente;
  final double cantidad;
  final String unidad;
  final double? peso;
  final bool esPesable;
  final int verificado;

  /// Nombre de detalle equivalnte a `_nombre_detalle` de data.py.
  String get nombre => ingrediente.isEmpty ? 'Desconocido' : ingrediente;
}

/// Stock de un almacén en auditoría (porta los dicts `origen`/`destino` de
/// `get_requisicion_audit_data`).
class AuditStock {
  const AuditStock({
    required this.inicial,
    required this.trasladada,
    required this.final_,
  });

  final double inicial;
  final double trasladada;
  final double final_;
}

/// Item de auditoría de un detalle de requisición.
class AuditItem {
  AuditItem({
    required this.detalleId,
    this.productoId,
    required this.ingrediente,
    required this.verificado,
    required this.origen,
    required this.destino,
  });

  final int detalleId;
  final int? productoId;
  final String ingrediente;

  /// Verificado actual (se muta en la vista de auditoría antes de persistir).
  bool verificado;
  final AuditStock origen;
  final AuditStock destino;
}

/// Repositorio de requisiciones — porta `usr/views/requisiciones/data.py`
/// y `service.py`. Sigue el patrón de `InventarioRepository` (offline-first).
class RequisicionesRepository {
  RequisicionesRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------
  // Almacenes y productos
  // ---------------------------------------------------------------------

  /// Almacenes distintos de existencias, forzando "principal" y "restaurante"
  /// (equivalente a `get_almacenes` de data.py).
  Future<List<String>> getAlmacenes() async {
    final rows = _db.selectOnly(_db.existencias)
      ..addColumns([_db.existencias.almacen]);
    final data = await rows.get();
    final almacenes = {
      for (final r in data) r.read(_db.existencias.almacen) as String,
    };
    almacenes
      ..add('principal')
      ..add('restaurante');
    return almacenes.toList()..sort();
  }

  /// Productos activos ordenados por nombre.
  Future<List<Producto>> getProductosActivos({int limit = 200}) {
    final q = _db.select(_db.productos)
      ..where((t) => t.activo.equals(1))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])
      ..limit(limit);
    return q.get();
  }

  /// Búsqueda de productos activos (equivalente a `buscar_productos`).
  Future<List<Producto>> buscarProductos(String texto, {int limit = 30}) {
    final term = texto.toLowerCase();
    final q = _db.select(_db.productos)
      ..where((t) =>
          t.activo.equals(1) & t.nombre.lower().contains(term))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)])
      ..limit(limit);
    return q.get();
  }

  /// Producto por id (para saber si es pesable en auditoría).
  Future<Producto?> getProducto(int id) {
    return (_db.select(_db.productos)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Existencia de un producto en un almacén (0 si no existe).
  Future<double> getExistencia(int productoId, String almacen) async {
    final e = await (_db.select(_db.existencias)
          ..where((t) =>
              t.productoId.equals(productoId) & t.almacen.equals(almacen)))
        .getSingleOrNull();
    return e?.cantidad ?? 0;
  }

  // ---------------------------------------------------------------------
  // Requisiciones (lectura)
  // ---------------------------------------------------------------------

  /// Todas las requisiciones con su conteo de detalles, orden fecha desc.
  Future<List<Requisicione>> loadRequisiciones() {
    return (_db.select(_db.requisiciones)
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .get();
  }

  Stream<List<Requisicione>> watchRequisiciones() {
    return (_db.select(_db.requisiciones)
          ..orderBy([(t) => OrderingTerm.desc(t.fechaCreacion)]))
        .watch();
  }

  Future<int> contarDetalles(int requisicionId) async {
    final count = await (_db.selectOnly(_db.requisicionDetalles)
          ..addColumns([_db.requisicionDetalles.id.count()])
          ..where(_db.requisicionDetalles.requisicionId.equals(requisicionId)))
        .get();
    return count.first.read(_db.requisicionDetalles.id.count()) ?? 0;
  }

  Future<List<RequisicionDetalle>> getDetalles(int requisicionId) {
    return (_db.select(_db.requisicionDetalles)
          ..where((t) => t.requisicionId.equals(requisicionId))
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  // ---------------------------------------------------------------------
  // Crear / editar / eliminar
  // ---------------------------------------------------------------------

  /// Guarda una requisición nueva o edita una existente (porta
  /// `guardar_requisicion` de data.py). Devuelve el id de la requisición.
  ///
  /// - `editando`: actualiza la cabecera, borra y recrea los detalles.
  /// - `moverStock`: resta en origen y suma en destino al guardar (flujo
  ///   rápido). En el flujo normal (`estado='pendiente'`) es `false`.
  Future<int> guardarRequisicion({
    required String origen,
    required String destino,
    String? observaciones,
    List<RequisicionItem> detalles = const [],
    Requisicione? editando,
    String usuario = 'Admin',
    String estado = 'pendiente',
    bool moverStock = false,
  }) async {
    if (editando == null) {
      final numero = 'REQ-${_tsNow()}';
      final id = await _db.into(_db.requisiciones).insert(
            RequisicionesCompanion.insert(
              numero: numero,
              numeroSecuencial: 0,
              origen: origen,
              destino: destino,
              estado: Value(estado),
              observaciones: Value(observaciones),
              creadaPor: Value(usuario),
              fechaCreacion: Value(DateTime.now()),
              actualizada: Value(DateTime.now()),
            ),
          );
      for (final item in detalles) {
        await _insertDetalle(id, item);
      }
      await _encolarRequisicion(id);
      await _aplicarMoverStock(id, moverStock);
      return id;
    }

    // Edición: actualizar cabecera.
    await (_db.update(_db.requisiciones)..where((t) => t.id.equals(editando.id)))
        .write(RequisicionesCompanion(
          origen: Value(origen),
          destino: Value(destino),
          observaciones: Value(observaciones),
          actualizada: Value(DateTime.now()),
        ));

    // Borra detalles y los recrea (equivalente a edición en Python). El mapa
    // de verificado se conserva por (producto_id, ingrediente).
    final prevVer = <String, int>{};
    for (final d in await getDetalles(editando.id)) {
      prevVer['${d.productoId}|${d.ingrediente}'] = d.verificado;
    }
    await (_db.delete(_db.requisicionDetalles)
          ..where((t) => t.requisicionId.equals(editando.id)))
        .go();
    for (final item in detalles) {
      final key = '${item.productoId}|${item.ingrediente}';
      await _insertDetalle(
        editando.id,
        item,
        verificado: prevVer[key] ?? 0,
      );
    }
    await _encolarRequisicion(editando.id);
    await _aplicarMoverStock(editando.id, moverStock);
    return editando.id;
  }

  /// Elimina una requisición y encola el borrado en el outbox.
  Future<bool> eliminarRequisicion(int requisicionId) async {
    final req = await (_db.select(_db.requisiciones)
          ..where((t) => t.id.equals(requisicionId)))
        .getSingleOrNull();
    if (req == null) return false;
    await (_db.delete(_db.requisicionDetalles)
          ..where((t) => t.requisicionId.equals(requisicionId)))
        .go();
    await (_db.delete(_db.requisiciones)..where((t) => t.id.equals(requisicionId))).go();
    await addPending(
      _db,
      tableName: 'requisiciones',
      operation: 'delete',
      data: {'numero': req.numero},
    );
    return true;
  }

  // ---------------------------------------------------------------------
  // Auditoría (verificar + totalizar)
  // ---------------------------------------------------------------------

  /// Datos de auditoría: por cada detalle, stock inicial/trasladada/final
  /// de origen y destino (porta `get_requisicion_audit_data` de data.py).
  Future<List<AuditItem>> getAuditData(int requisicionId) async {
    final req = await (_db.select(_db.requisiciones)
          ..where((t) => t.id.equals(requisicionId)))
        .getSingleOrNull();
    if (req == null) return [];

    final detalles = await getDetalles(req.id);
    final items = <AuditItem>[];

    for (final d in detalles) {
      final sOrig = await getExistencia(d.productoId ?? -1, req.origen);
      final sDest = await getExistencia(d.productoId ?? -1, req.destino);
      final cant = d.cantidad;

      items.add(AuditItem(
        detalleId: d.id,
        productoId: d.productoId,
        ingrediente: d.ingrediente,
        verificado: d.verificado == 1,
        origen: AuditStock(
          inicial: sOrig,
          trasladada: cant,
          final_: sOrig - cant,
        ),
        destino: AuditStock(
          inicial: sDest,
          trasladada: cant,
          final_: sDest + cant,
        ),
      ));
    }
    return items;
  }

  /// Marca un detalle como verificado/no verificado y re-encola la requisición
  /// completa (porta `marcar_detalle_verificado`).
  Future<void> marcarDetalleVerificado(int detalleId, bool verificado) async {
    final detalle = await (_db.select(_db.requisicionDetalles)
          ..where((t) => t.id.equals(detalleId)))
        .getSingleOrNull();
    if (detalle == null) return;

    await (_db.update(_db.requisicionDetalles)
          ..where((t) => t.id.equals(detalleId)))
        .write(RequisicionDetallesCompanion(
          verificado: Value(verificado ? 1 : 0),
        ));
    await _encolarRequisicion(detalle.requisicionId);
  }

  /// Ajuste de stock para auditoría (porta `crear_ajuste_stock`).
  Future<void> crearAjusteStock({
    required int productoId,
    required String almacen,
    required double nuevaCantidad,
    required String motivo,
    String usuario = 'Admin',
    double? pesoTotal,
  }) async {
    final e = await (_db.select(_db.existencias)
          ..where((t) =>
              t.productoId.equals(productoId) & t.almacen.equals(almacen)))
        .getSingleOrNull();
    final actual = e?.cantidad ?? 0;
    final diff = nuevaCantidad - actual;

    await _db.into(_db.movimientos).insert(
          MovimientosCompanion.insert(
            productoId: productoId,
            tipo: 'ajuste',
            cantidad: diff,
            cantidadAnterior: Value(actual),
            cantidadNueva: Value(nuevaCantidad),
            pesoTotal: Value(pesoTotal ?? 0),
            registradoPor: Value(usuario),
            observaciones: Value('Ajuste auditoría: $motivo'),
            almacen: Value(almacen),
            fechaMovimiento: Value(DateTime.now()),
            sincronizado: const Value(0),
          ),
        );

    final producto = await (_db.select(_db.productos)
          ..where((t) => t.id.equals(productoId)))
        .getSingleOrNull();
    await _db.into(_db.existencias).insertOnConflictUpdate(
      ExistenciasCompanion.insert(
        productoId: Value(productoId),
        almacen: almacen,
        cantidad: Value(nuevaCantidad),
        unidad: Value(producto?.unidadMedida ?? 'unidad'),
      ),
    );
  }

  /// Totaliza (cierra) una requisición: registra los traslados `tr_salida` /
  /// `tr_entrada`, actualiza existencias y pone estado 'completada'.
  /// Porta `totalizar_requisicion` de data.py.
  ///
  /// Lanza [StateError] si la req ya fue totalizada o no tiene detalles.
  Future<void> totalizarRequisicion(int requisicionId,
      {String usuario = 'Admin'}) async {
    final req = await (_db.select(_db.requisiciones)
          ..where((t) => t.id.equals(requisicionId)))
        .getSingleOrNull();
    if (req == null) throw StateError('Requisición no encontrada');
    if (req.estado == 'completada') {
      throw StateError('La requisición ya fue totalizada');
    }

    // Ya tiene traslados registrados (detección por observación, como Python).
    final movimientosYa = await (_db.select(_db.movimientos)
          ..where((t) => t.observaciones.contains('req ${req.numero} →') |
              t.observaciones.contains('req ${req.numero} ←')))
        .get();
    if (movimientosYa.isNotEmpty) {
      throw StateError('La requisición ya tiene traslados registrados');
    }

    final detalles = await getDetalles(req.id);
    if (detalles.isEmpty) {
      throw StateError('La requisición no tiene detalles');
    }

    for (final d in detalles) {
      if (d.productoId == null) continue;

      final actualOrigen = await getExistencia(d.productoId!, req.origen);
      final actualDestino = await getExistencia(d.productoId!, req.destino);
      final cantOrigenNueva = (actualOrigen - d.cantidad).clamp(0.0, double.infinity);
      final cantDestinoNueva = actualDestino + d.cantidad;

      // Traslado de salida desde origen (cantidad negativa).
      await _db.into(_db.movimientos).insert(
            MovimientosCompanion.insert(
              productoId: d.productoId!,
              requisicionId: Value(req.id),
              tipo: 'tr_salida',
              cantidad: -d.cantidad,
              cantidadAnterior: Value(actualOrigen),
              cantidadNueva: Value(cantOrigenNueva),
              pesoTotal: const Value(0.0),
              registradoPor: Value(usuario),
              observaciones: Value('Traslado req ${req.numero} → ${req.destino}'),
              almacen: Value(req.origen),
              fechaMovimiento: Value(DateTime.now()),
              sincronizado: const Value(0),
            ),
          );

      // Traslado de entrada al destino (cantidad positiva).
      await _db.into(_db.movimientos).insert(
            MovimientosCompanion.insert(
              productoId: d.productoId!,
              requisicionId: Value(req.id),
              tipo: 'tr_entrada',
              cantidad: d.cantidad,
              cantidadAnterior: Value(actualDestino),
              cantidadNueva: Value(cantDestinoNueva),
              pesoTotal: const Value(0.0),
              registradoPor: Value(usuario),
              observaciones: Value('Traslado req ${req.numero} ← ${req.origen}'),
              almacen: Value(req.destino),
              fechaMovimiento: Value(DateTime.now()),
              sincronizado: const Value(0),
            ),
          );

      // Actualiza existencias origen y destino.
      await _db.into(_db.existencias).insertOnConflictUpdate(
        ExistenciasCompanion.insert(
          productoId: Value(d.productoId!),
          almacen: req.origen,
          cantidad: Value(cantOrigenNueva),
        ),
      );
      await _db.into(_db.existencias).insertOnConflictUpdate(
        ExistenciasCompanion.insert(
          productoId: Value(d.productoId!),
          almacen: req.destino,
          cantidad: Value(cantDestinoNueva),
        ),
      );
    }

    // Cierra la requisición.
    await (_db.update(_db.requisiciones)..where((t) => t.id.equals(req.id)))
        .write(RequisicionesCompanion(
          estado: const Value('completada'),
          procesadaPor: Value(usuario),
          fechaProcesamiento: Value(DateTime.now()),
          actualizada: Value(DateTime.now()),
        ));
    await _encolarRequisicion(req.id);
  }

  // ---------------------------------------------------------------------
  // Historial de movimientos (auditoría)
  // ---------------------------------------------------------------------

  Future<List<Movimiento>> getMovimientosProducto(int productoId,
      {int limit = 9999}) {
    return (_db.select(_db.movimientos)
          ..where((t) => t.productoId.equals(productoId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)])
          ..limit(limit))
        .get();
  }

  // ---------------------------------------------------------------------
  // Internos
  // ---------------------------------------------------------------------

  Future<void> _insertDetalle(int requisicionId, RequisicionItem item,
      {int verificado = 0}) {
    return _db.into(_db.requisicionDetalles).insert(
          RequisicionDetallesCompanion.insert(
            requisicionId: requisicionId,
            productoId: Value(item.productoId),
            ingrediente: item.nombre,
            cantidad: item.cantidad,
            unidad: Value(item.unidad),
            cantidadSurtida: const Value(0),
            verificado: Value(item.verificado != 0 ? 1 : verificado),
          ),
        );
  }

  /// Re-encola la requisición completa en el outbox. El `SyncEngine` sube la
  /// cabecera (resolviendo el id remoto por `numero`) y todos sus detalles,
  /// por lo que basta con enviar la fila completa de la cabecera.
  Future<void> _encolarRequisicion(int requisicionId) async {
    final req = await (_db.select(_db.requisiciones)
          ..where((t) => t.id.equals(requisicionId)))
        .getSingleOrNull();
    if (req == null) return;
    await addPending(
      _db,
      tableName: 'requisiciones',
      operation: 'upsert',
      data: requisicionToSyncMap(req),
    );
  }

  /// Aplica mover stock al crear (flujo rápido): resta en origen y suma en
  /// destino sin pasar por auditoría.
  Future<void> _aplicarMoverStock(int requisicionId, bool moverStock) async {
    if (!moverStock) return;
    final req = await (_db.select(_db.requisiciones)
          ..where((t) => t.id.equals(requisicionId)))
        .getSingleOrNull();
    if (req == null) return;

    for (final d in await getDetalles(req.id)) {
      if (d.productoId == null) continue;
      final actualOrigen = await getExistencia(d.productoId!, req.origen);
      final actualDestino = await getExistencia(d.productoId!, req.destino);

      await _db.into(_db.existencias).insertOnConflictUpdate(
        ExistenciasCompanion.insert(
          productoId: Value(d.productoId!),
          almacen: req.origen,
          cantidad:
              Value((actualOrigen - d.cantidad).clamp(0.0, double.infinity)),
        ),
      );
      await _db.into(_db.existencias).insertOnConflictUpdate(
        ExistenciasCompanion.insert(
          productoId: Value(d.productoId!),
          almacen: req.destino,
          cantidad: Value(actualDestino + d.cantidad),
        ),
      );
    }
  }

  String _tsNow() {
    final now = DateTime.now();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${now.year}${p(now.month)}${p(now.day)}${p(now.hour)}${p(now.minute)}${p(now.second)}';
  }
}