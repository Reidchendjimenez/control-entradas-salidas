import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/sync/sync_service.dart';

/// Entrada pendiente de validación: movimiento tipo `entrada` sin factura,
/// con datos del producto para la card (porta el join de
/// `validacion_view.py` + `Producto`).
class EntradaPendiente {
  const EntradaPendiente({
    required this.id,
    required this.productoId,
    required this.nombre,
    required this.unidad,
    required this.esPesable,
    required this.cantidad,
    required this.pesoTotal,
    required this.almacen,
    required this.fecha,
  });

  final int id;
  final int productoId;
  final String nombre;
  final String unidad;
  final bool esPesable;
  final double cantidad;
  final double pesoTotal;
  final String almacen;
  final DateTime? fecha;

  String get cantidadTexto {
    if (esPesable && pesoTotal > 0) return '${pesoTotal.toStringAsFixed(3)} kg';
    return '${cantidad.toStringAsFixed(0)} $unidad';
  }
}

/// Pago de una factura validada (porta el dict de `PaymentsManager`).
class PagoData {
  const PagoData({
    required this.tipo, // transferencia | efectivo | divisas
    required this.monto, // VES
    this.ref = '',
    this.tasa = 1,
  });

  final String tipo;
  final double monto;
  final String ref;
  final double tasa;
}

/// Resultado del procesamiento de validación (porta el dict que devuelve
/// `ValidacionService.procesar`).
class ResultadoValidacion {
  const ResultadoValidacion({
    required this.facturaId,
    required this.movimientosCount,
    required this.usuario,
  });

  final int facturaId;
  final int movimientosCount;
  final String usuario;
}

/// Repositorio de validación — porta `usr/views/validacion_view.py`,
/// `fields.py`, `payments.py` y `validacion/service.py`.
class ValidacionRepository {
  ValidacionRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------
  // Entradas pendientes
  // ---------------------------------------------------------------------

  /// Movimientos `entrada` sin factura, con el producto asociado, ordenados
  /// por fecha desc. Filtro opcional por nombre del producto.
  Future<List<EntradaPendiente>> getEntradasPendientes({String search = ''}) async {
    final rows = await _queryEntradas(search).get();
    return rows.map(_toEntrada).toList();
  }

  Stream<List<EntradaPendiente>> watchEntradasPendientes({String search = ''}) {
    return _queryEntradas(search).watch().map((rows) => rows.map(_toEntrada).toList());
  }

  JoinedSelectStatement<HasResultSet, dynamic> _queryEntradas(String search) {
    final q = _db.select(_db.movimientos).join([
      innerJoin(_db.productos, _db.productos.id.equalsExp(_db.movimientos.productoId)),
    ]);
    q.where(_db.movimientos.tipo.equals('entrada') & _db.movimientos.facturaId.isNull());
    final term = search.trim().toLowerCase();
    if (term.isNotEmpty) {
      q.where(_db.productos.nombre.lower().contains(term));
    }
    q.orderBy([OrderingTerm.desc(_db.movimientos.fechaMovimiento)]);
    return q;
  }

  EntradaPendiente _toEntrada(TypedResult r) {
    final m = r.readTable(_db.movimientos);
    final p = r.readTable(_db.productos);
    return EntradaPendiente(
      id: m.id,
      productoId: m.productoId,
      nombre: p.nombre,
      unidad: p.unidadMedida,
      esPesable: p.esPesable == 1,
      cantidad: m.cantidad,
      pesoTotal: m.pesoTotal,
      almacen: m.almacen ?? 'principal',
      fecha: m.fechaMovimiento,
    );
  }

  // ---------------------------------------------------------------------
  // Proveedores
  // ---------------------------------------------------------------------

  Future<List<Proveedore>> getProveedores({String estado = 'Activo'}) {
    return (_db.select(_db.proveedores)
          ..where((t) => t.estado.equals(estado))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)]))
        .get();
  }

  /// Busca proveedor por RIF o nombre (porta el bloque de service.py).
  Future<Proveedore?> buscarProveedor({String rif = '', String nombre = ''}) async {
    if (rif.isNotEmpty) {
      final p = await (_db.select(_db.proveedores)..where((t) => t.rif.equals(rif)))
          .getSingleOrNull();
      if (p != null) return p;
    }
    if (nombre.isNotEmpty) {
      return (_db.select(_db.proveedores)..where((t) => t.nombre.equals(nombre)))
          .getSingleOrNull();
    }
    return null;
  }

  /// Crea un proveedor nuevo y encola el insert (porta service.py + sync.py).
  Future<Proveedore> crearProveedor({
    required String nombre,
    String rif = '',
  }) async {
    final id = await _db.into(_db.proveedores).insert(
          ProveedoresCompanion.insert(
            nombre: nombre,
            rif: Value(rif.isEmpty ? null : rif),
            estado: const Value('Activo'),
            createdAt: Value(DateTime.now()),
          ),
        );
    await addPending(
      _db,
      tableName: 'proveedores',
      operation: 'insert',
      data: {'nombre': nombre, 'rif': rif, 'estado': 'Activo'},
    );
    return (await (_db.select(_db.proveedores)..where((t) => t.id.equals(id)))
        .getSingle());
  }

  /// Próximo correlativo de entrada `EV-####` (porta
  /// `LocalReplica.get_next_entrada_correlativo`).
  Future<String> getNextEntradaCorrelativo() async {
    final rows = await (_db.select(_db.facturas)
          ..where((t) => t.numeroFactura.like('EV-%'))
          ..orderBy([(t) => OrderingTerm.desc(t.numeroFactura)])
          ..limit(5))
        .get();
    var maxNum = 0;
    for (final r in rows) {
      final part = (r.numeroFactura ?? '').replaceFirst('EV-', '').trim();
      final n = int.tryParse(part);
      if (n != null && n > maxNum) maxNum = n;
    }
    return 'EV-${(maxNum + 1).toString().padLeft(4, '0')}';
  }

  // ---------------------------------------------------------------------
  // Procesar validación
  // ---------------------------------------------------------------------

  /// Procesa la validación de entradas seleccionadas (porta
  /// `ValidacionService.procesar`):
  /// 1. crea/vincula proveedor (si no es "Varios"),
  /// 2. crea la factura (o reusa la existente por número) + pagos,
  /// 3. vincula los movimientos a la factura y los marca `sincronizado=0`,
  /// 4. encola factura + pagos en el outbox.
  Future<ResultadoValidacion> procesar({
    required Set<int> selectedEntradas,
    required String proveedor,
    String rif = '',
    required String factura,
    double monto = 0,
    required DateTime fecha,
    String tipoDocumento = 'Factura',
    List<PagoData> pagos = const [],
    String usuario = 'Sistema',
  }) async {
    final db = _db;

    // 1. Proveedor (no aplica a "Varios (Entrada sin proveedor)").
    if (proveedor != 'Varios' && proveedor.isNotEmpty) {
      var prov = await buscarProveedor(rif: rif, nombre: proveedor);
      prov ??= await crearProveedor(nombre: proveedor, rif: rif);
    }

    final refFact = factura.trim().isEmpty
        ? 'EV-${_tsStamp()}'
        : factura.trim();

    // 2. Factura (reusa la existente por número o crea una nueva).
    final existente = await (db.select(db.facturas)
          ..where((t) => t.numeroFactura.equals(refFact)))
        .getSingleOrNull();

    int facturaId;
    if (existente != null) {
      facturaId = existente.id;
      await _vincularMovimientos(facturaId, selectedEntradas);
      await addPending(
        db,
        tableName: 'facturas',
        operation: 'update',
        data: {
          'numero_factura': refFact,
          'proveedor': proveedor,
          'tipo_documento': tipoDocumento,
          'total_bruto': monto,
          'total_neto': monto,
          'estado': 'Validada',
          'validada_por': usuario,
          'fecha_validacion': DateTime.now().toIso8601String(),
        },
      );
    } else {
      final now = DateTime.now();
      facturaId = await db.into(db.facturas).insert(
            FacturasCompanion.insert(
              numeroFactura: Value(refFact),
              tipoDocumento: Value(tipoDocumento),
              proveedor: Value(proveedor == 'Varios' ? null : proveedor),
              fechaFactura: Value(fecha),
              fechaRecepcion: Value(now),
              totalBruto: Value(monto),
              totalImpuestos: const Value(0),
              totalNeto: Value(monto),
              estado: const Value('Validada'),
              validadaPor: Value(usuario),
              fechaValidacion: Value(now),
              createdAt: Value(now),
            ),
          );
      await _vincularMovimientos(facturaId, selectedEntradas);
      await addPending(
        db,
        tableName: 'facturas',
        operation: 'insert',
        data: {
          'numero_factura': refFact,
          'proveedor': proveedor == 'Varios' ? null : proveedor,
          'tipo_documento': tipoDocumento,
          'fecha_factura': fecha.toIso8601String(),
          'fecha_recepcion': now.toIso8601String(),
          'total_bruto': monto,
          'total_impuestos': 0,
          'total_neto': monto,
          'estado': 'Validada',
          'validada_por': usuario,
          'fecha_validacion': now.toIso8601String(),
        },
      );
    }

    // 3. Pagos.
    for (final p in pagos) {
      if (p.monto <= 0) continue;
      final montoVes = p.tipo == 'divisas' ? p.monto * p.tasa : p.monto;
      await db.into(db.facturaPagos).insert(
            FacturaPagosCompanion.insert(
              facturaId: facturaId,
              tipoPago: p.tipo,
              monto: montoVes,
              referencia: Value(p.ref.isEmpty ? null : p.ref),
              tasaCambio: Value(p.tipo == 'divisas' ? p.tasa : null),
              fechaPago: Value(DateTime.now()),
            ),
          );
      await addPending(
        db,
        tableName: 'factura_pagos',
        operation: 'insert',
        data: {
          'factura_numero': refFact,
          'tipo_pago': p.tipo,
          'monto': montoVes,
          'referencia': p.ref.isEmpty ? null : p.ref,
          'tasa_cambio': p.tipo == 'divisas' ? p.tasa : null,
        },
      );
    }

    return ResultadoValidacion(
      facturaId: facturaId,
      movimientosCount: selectedEntradas.length,
      usuario: usuario,
    );
  }

  /// Vincula los movimientos a la factura y los marca `sincronizado=0` para
  /// que `_uploadPendingMovimientos` suba el `factura_id`.
  Future<void> _vincularMovimientos(int facturaId, Set<int> ids) async {
    if (ids.isEmpty) return;
    await (_db.update(_db.movimientos)..where((t) => t.id.isIn(ids))).write(
      MovimientosCompanion(
        facturaId: Value(facturaId),
        sincronizado: const Value(0),
      ),
    );
  }

  /// Elimina una entrada pendiente y encola el borrado en el outbox con los
  /// campos coincidentes (porta `_eliminar_entrada` de validacion_view.py).
  Future<void> eliminarEntrada(EntradaPendiente entrada) async {
    await (_db.delete(_db.movimientos)..where((t) => t.id.equals(entrada.id))).go();
    await addPending(
      _db,
      tableName: 'movimientos',
      operation: 'delete',
      data: {
        'producto_id': entrada.productoId,
        'tipo': 'entrada',
        'cantidad': entrada.cantidad,
        'fecha_movimiento': entrada.fecha?.toIso8601String(),
        'almacen': entrada.almacen,
      },
    );
  }

  // ---------------------------------------------------------------------
  // Internos
  // ---------------------------------------------------------------------

  String _tsStamp() {
    final now = DateTime.now();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${now.year}${p(now.month)}${p(now.day)}${p(now.hour)}${p(now.minute)}${p(now.second)}';
  }
}
