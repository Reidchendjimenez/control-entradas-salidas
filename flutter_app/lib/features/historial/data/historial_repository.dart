import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';

/// Entrada (movimiento tipo `entrada`) con datos del producto para la card.
/// Porta el join `Movimiento + Producto` de `historial_facturas_view.py`.
class EntradaPorFecha {
  const EntradaPorFecha({
    required this.id,
    required this.productoId,
    required this.nombre,
    required this.unidad,
    required this.esPesable,
    required this.cantidad,
    required this.pesoTotal,
    required this.fecha,
  });

  final int id;
  final int productoId;
  final String nombre;
  final String unidad;
  final bool esPesable;
  final double cantidad;
  final double pesoTotal;
  final DateTime? fecha;

  String get cantidadTexto {
    if (esPesable && pesoTotal > 0) return '${pesoTotal.toStringAsFixed(3)} kg';
    return '${cantidad.toStringAsFixed(0)} $unidad';
  }
}

/// Item de detalle de una factura (movimiento activo o archivado).
class FacturaDetalleItem {
  const FacturaDetalleItem({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.pesoTotal,
    required this.archivado,
  });

  final int productoId;
  final String nombre;
  final double cantidad;
  final double pesoTotal;
  final bool archivado;

  String get cantidadTexto {
    if (pesoTotal > 0) return 'Cant: ${cantidad.toStringAsFixed(0)} | Peso: ${pesoTotal.toStringAsFixed(2)} kg';
    return 'Cant: ${cantidad.toStringAsFixed(0)}';
  }
}

/// Detalle completo de una factura (movimientos + archivados + pagos).
class FacturaDetalle {
  const FacturaDetalle({
    required this.factura,
    required this.items,
    required this.pagos,
  });

  final Factura factura;
  final List<FacturaDetalleItem> items;
  final List<FacturaPago> pagos;
}

/// Fila del libro de compras (export Excel).
class LibroComprasRow {
  const LibroComprasRow({
    required this.factura,
    required this.efectivo,
    required this.transferencia,
    required this.divisasUsd,
    required this.tasa,
  });

  final Factura factura;
  final double efectivo;
  final double transferencia;
  final double divisasUsd;
  final double? tasa;
}

/// Repositorio de historial de facturas — porta
/// `usr/views/historial_facturas_view.py`.
class HistorialRepository {
  HistorialRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------
  // Facturas
  // ---------------------------------------------------------------------

  /// Últimas 100 facturas, ordenadas por fecha desc. Filtros opcionales:
  /// rango de fecha (`desde`/`hasta`, hasta inclusive) y búsqueda por número
  /// o proveedor (en memoria, como el Flet).
  Future<List<Factura>> getFacturas({
    DateTime? desde,
    DateTime? hasta,
    String search = '',
  }) async {
    final q = _db.select(_db.facturas);
    if (desde != null) q.where((t) => t.fechaFactura.isBiggerOrEqualValue(desde));
    if (hasta != null) {
      final fin = hasta.add(const Duration(days: 1));
      q.where((t) => t.fechaFactura.isSmallerThanValue(fin));
    }
    q.orderBy([(t) => OrderingTerm.desc(t.fechaFactura)]);
    q.limit(100);

    final facturas = await q.get();
    final term = search.trim().toLowerCase();
    if (term.isEmpty) return facturas;

    return facturas.where((f) {
      final num = (f.numeroFactura ?? '').toLowerCase();
      final prov = (f.proveedor ?? '').toLowerCase();
      return num.contains(term) || prov.contains(term);
    }).toList();
  }

  /// Total de facturas (para el texto `N factura(s)`).
  Future<int> countFacturas({DateTime? desde, DateTime? hasta}) async {
    final q = _db.selectOnly(_db.facturas)..addColumns([_db.facturas.id.count()]);
    if (desde != null) q.where(_db.facturas.fechaFactura.isBiggerOrEqualValue(desde));
    if (hasta != null) {
      q.where(_db.facturas.fechaFactura.isSmallerThanValue(hasta.add(const Duration(days: 1))));
    }
    final row = await q.getSingle();
    return row.read(_db.facturas.id.count()) ?? 0;
  }

  // ---------------------------------------------------------------------
  // Entradas por fecha
  // ---------------------------------------------------------------------

  /// Movimientos tipo `entrada` en el rango `[ini, fin)`, con el producto,
  /// ordenados por fecha desc (límite 200, como el Flet).
  Future<List<EntradaPorFecha>> getEntradasPorFecha(DateTime ini, DateTime fin) async {
    final q = _db.select(_db.movimientos).join([
      innerJoin(_db.productos, _db.productos.id.equalsExp(_db.movimientos.productoId)),
    ]);
    q.where(_db.movimientos.tipo.equals('entrada'));
    q.where(_db.movimientos.fechaMovimiento.isBiggerOrEqualValue(ini));
    q.where(_db.movimientos.fechaMovimiento.isSmallerThanValue(fin));
    q.orderBy([OrderingTerm.desc(_db.movimientos.fechaMovimiento)]);
    q.limit(200);

    final rows = await q.get();
    return rows.map((r) {
      final m = r.readTable(_db.movimientos);
      final p = r.readTable(_db.productos);
      return EntradaPorFecha(
        id: m.id,
        productoId: m.productoId,
        nombre: p.nombre,
        unidad: p.unidadMedida,
        esPesable: p.esPesable == 1,
        cantidad: m.cantidad,
        pesoTotal: m.pesoTotal,
        fecha: m.fechaMovimiento,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------
  // Detalle de factura
  // ---------------------------------------------------------------------

  /// Movimientos (activos + archivados) y pagos de una factura.
  Future<FacturaDetalle> getFacturaDetalle(int facturaId) async {
    final factura = await (_db.select(_db.facturas)..where((t) => t.id.equals(facturaId)))
        .getSingle();

    // Movimientos activos con producto.
    final q = _db.select(_db.movimientos).join([
      innerJoin(_db.productos, _db.productos.id.equalsExp(_db.movimientos.productoId)),
    ]);
    q.where(_db.movimientos.facturaId.equals(facturaId));
    final activos = await q.get();
    final itemsActivos = activos.map((r) {
      final m = r.readTable(_db.movimientos);
      final p = r.readTable(_db.productos);
      return FacturaDetalleItem(
        productoId: m.productoId,
        nombre: p.nombre,
        cantidad: m.cantidad,
        pesoTotal: m.pesoTotal,
        archivado: false,
      );
    }).toList();

    // Movimientos archivados con producto.
    final qa = _db.select(_db.movimientosArchivo).join([
      innerJoin(_db.productos, _db.productos.id.equalsExp(_db.movimientosArchivo.productoId)),
    ]);
    qa.where(_db.movimientosArchivo.facturaId.equals(facturaId));
    final archivados = await qa.get();
    final itemsArchivados = archivados.map((r) {
      final m = r.readTable(_db.movimientosArchivo);
      final p = r.readTable(_db.productos);
      return FacturaDetalleItem(
        productoId: m.productoId,
        nombre: p.nombre,
        cantidad: m.cantidad,
        pesoTotal: m.pesoTotal,
        archivado: true,
      );
    }).toList();

    final pagos = await (_db.select(_db.facturaPagos)
          ..where((t) => t.facturaId.equals(facturaId)))
        .get();

    return FacturaDetalle(
      factura: factura,
      items: [...itemsActivos, ...itemsArchivados],
      pagos: pagos,
    );
  }

  // ---------------------------------------------------------------------
  // Export / Libro de compras
  // ---------------------------------------------------------------------

  /// Facturas validadas del mes, con pagos desglosados (porta
  /// `_exportar_excel`).
  Future<List<LibroComprasRow>> getLibroCompras(
    DateTime fechaInicio,
    DateTime fechaFin, {
    String? tipoDocumento,
  }) async {
    final q = _db.select(_db.facturas);
    q.where((t) => t.fechaFactura.isBiggerOrEqualValue(fechaInicio));
    q.where((t) => t.fechaFactura.isSmallerOrEqualValue(fechaFin));
    q.where((t) => t.estado.equals('Validada'));
    if (tipoDocumento != null && tipoDocumento.isNotEmpty) {
      q.where((t) => t.tipoDocumento.equals(tipoDocumento));
    }
    q.orderBy([(t) => OrderingTerm.asc(t.fechaFactura)]);

    final facturas = await q.get();
    final rows = <LibroComprasRow>[];

    for (final f in facturas) {
      final pagos = await (_db.select(_db.facturaPagos)
            ..where((t) => t.facturaId.equals(f.id)))
          .get();

      var efectivo = 0.0;
      var transferencia = 0.0;
      var divisasUsd = 0.0;
      double? tasa;
      for (final p in pagos) {
        switch (p.tipoPago) {
          case 'efectivo':
            efectivo = p.monto;
          case 'transferencia':
            transferencia = p.monto;
          case 'divisas':
            divisasUsd = p.monto;
            tasa = p.tasaCambio;
        }
      }
      rows.add(LibroComprasRow(
        factura: f,
        efectivo: efectivo,
        transferencia: transferencia,
        divisasUsd: divisasUsd,
        tasa: tasa,
      ));
    }
    return rows;
  }
}
