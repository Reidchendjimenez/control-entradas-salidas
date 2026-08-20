import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';

/// Estadísticas de stock para la cabecera (Total / Bajo / Agotado).
class StockStats {
  const StockStats({
    this.total = 0,
    this.bajo = 0,
    this.agotado = 0,
  });

  final int total;
  final int bajo;
  final int agotado;
}

/// Repositorio de stock — porta `usr/views/stock/data.py` y la parte de
/// `ajustar_existencia` de movements.py.
class StockRepository {
  StockRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------
  // Datos maestros
  // ---------------------------------------------------------------------

  Future<List<Categoria>> loadCategorias() {
    return (_db.select(_db.categorias)..where((t) => t.activo.equals(1))).get();
  }

  /// Almacenes distintos de existencias (porta `load_warehouses`).
  Future<List<String>> getAlmacenes() async {
    final rows = _db.selectOnly(_db.existencias)
      ..addColumns([_db.existencias.almacen]);
    final data = await rows.get();
    return {
      for (final r in data) r.read(_db.existencias.almacen) as String,
    }.toList()
      ..sort();
  }

  Future<List<Producto>> loadProductos({int limit = 50}) {
    return (_db.select(_db.productos)
          ..where((t) => t.activo.equals(1))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)])
          ..limit(limit))
        .get();
  }

  Future<Map<int, Map<String, double>>> getExistenciasMap(
      List<int> productoIds) async {
    final result = <int, Map<String, double>>{};
    if (productoIds.isEmpty) return result;

    final rows = await (_db.select(_db.existencias)
          ..where((t) => t.productoId.isIn(productoIds)))
        .get();
    for (final e in rows) {
      final id = e.productoId ?? 0;
      result.putIfAbsent(id, () => {});
      result[id]![e.almacen] = e.cantidad;
    }
    return result;
  }

  Future<Map<int, double>> getStockTotal(List<int> productoIds) async {
    final map = await getExistenciasMap(productoIds);
    return {
      for (final e in map.entries)
        e.key: e.value.values.fold<double>(0, (a, b) => a + b),
    };
  }

  // ---------------------------------------------------------------------
  // Filtros (porta `filter_products_db` y `get_stock_stats`)
  // ---------------------------------------------------------------------

  /// Productos filtrados por búsqueda/categoría/almacén/estado de stock.
  Future<List<Producto>> filterProductos({
    String search = '',
    int? categoriaId,
    String? almacen,
    String? stockStatus, // null | 'low' | 'out'
    int limit = 50,
  }) async {
    final q = _db.select(_db.productos);

    q.where((t) {
      var w = t.activo.equals(1);
      if (search.isNotEmpty) {
        final term = search.toLowerCase();
        w = w & t.nombre.lower().contains(term);
      }
      if (categoriaId != null) {
        w = w & t.categoriaId.equals(categoriaId);
      }
      return w;
    });
    q.orderBy([(t) => OrderingTerm.asc(t.nombre)]);

    final productos = await q.get();

    if (almacen == null && stockStatus == null) {
      return productos.take(limit).toList();
    }

    final ids = [for (final p in productos) p.id];
    final existenciasMap = await getExistenciasMap(ids);
    final stockTotal = <int, double>{
      for (final e in existenciasMap.entries)
        e.key: e.value.values.fold<double>(0, (a, b) => a + b),
    };

    final result = <Producto>[];
    for (final p in productos) {
      final stock = stockTotal[p.id] ?? 0;
      if (almacen != null && (existenciasMap[p.id]?[almacen] ?? 0) <= 0) {
        continue;
      }
      if (stockStatus == 'out' && !(stock <= 0)) continue;
      if (stockStatus == 'low' &&
          !(stock > 0 &&
              stock <= (p.stockMinimo > 0 ? p.stockMinimo : double.infinity))) {
        continue;
      }
      result.add(p);
      if (result.length >= limit) break;
    }
    return result;
  }

  /// Estadísticas de stock desde la BD (porta `get_stock_stats`).
  Future<StockStats> getStockStats() async {
    final productos = await loadProductos(limit: 99999);
    final stockTotales = await getStockTotal([for (final p in productos) p.id]);

    var total = 0, bajo = 0, agotado = 0;
    for (final p in productos) {
      final stock = stockTotales[p.id] ?? 0;
      total++;
      if (stock <= 0) {
        agotado++;
      } else if (p.stockMinimo > 0 && stock <= p.stockMinimo) {
        bajo++;
      }
    }
    return StockStats(total: total, bajo: bajo, agotado: agotado);
  }

  // ---------------------------------------------------------------------
  // Detalle de producto
  // ---------------------------------------------------------------------

  Future<List<Existencia>> getExistenciasProducto(int productoId) {
    return (_db.select(_db.existencias)
          ..where((t) => t.productoId.equals(productoId))
          ..orderBy([(t) => OrderingTerm.asc(t.almacen)]))
        .get();
  }

  /// Historial de movimientos de un producto (porta `get_producto_historial`).
  Future<List<Movimiento>> getProductoHistorial(int productoId,
      {int limit = 100}) {
    return (_db.select(_db.movimientos)
          ..where((t) => t.productoId.equals(productoId))
          ..orderBy([(t) => OrderingTerm.desc(t.fechaMovimiento)])
          ..limit(limit))
        .get();
  }

  // ---------------------------------------------------------------------
  // Ajuste de stock (porta `ajustar_existencia` de movements.py)
  // ---------------------------------------------------------------------

  /// Ajusta la existencia de un producto/almaCén a la nueva cantidad física.
  /// Devuelve `true` si se creó movimiento. Si `nueva == actual`, no crea
  /// nada y devuelve `false`.
  Future<bool> ajustarExistencia({
    required int productoId,
    required String almacen,
    required double nuevaCantidad,
    String? motivo,
    String usuario = 'sistema',
  }) async {
    final rows = await (_db.select(_db.existencias)
          ..where((t) =>
              t.productoId.equals(productoId) & t.almacen.equals(almacen))
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .get();
    final e = rows.isEmpty ? null : rows.first;
    final actual = e?.cantidad ?? 0;

    if ((nuevaCantidad - actual).abs() < 1e-9) {
      return false; // Sin cambios, no se crea movimiento.
    }

    final producto = await (_db.select(_db.productos)
          ..where((t) => t.id.equals(productoId)))
        .getSingleOrNull();
    final esPesable = producto?.esPesable == 1;

    await _db.into(_db.movimientos).insert(
          MovimientosCompanion.insert(
            productoId: productoId,
            tipo: 'ajuste',
            cantidad: (nuevaCantidad - actual).abs(),
            cantidadAnterior: Value(actual),
            cantidadNueva: Value(nuevaCantidad),
            pesoTotal: Value(esPesable ? nuevaCantidad : 0.0),
            registradoPor: Value(usuario),
            observaciones: Value(motivo ?? ''),
            almacen: Value(almacen),
            fechaMovimiento: Value(DateTime.now()),
            createdAt: Value(DateTime.now()),
            sincronizado: const Value(0),
          ),
        );

    await (_db.delete(_db.existencias)
          ..where((t) =>
              t.productoId.equals(productoId) & t.almacen.equals(almacen)))
        .go();
    await _db.into(_db.existencias).insert(
          ExistenciasCompanion.insert(
            productoId: Value(productoId),
            almacen: almacen,
            cantidad: Value(nuevaCantidad),
            unidad: Value(producto?.unidadMedida ?? 'unidad'),
          ),
        );

    return true;
  }
}