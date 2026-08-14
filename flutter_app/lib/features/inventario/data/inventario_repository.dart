import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/sync/sync_service.dart';

/// Repositorio de inventario — porta `usr/views/inventario/*` y la parte de
/// datos de `movements.py`, `local_replica.py`.
///
/// Estrategia heredada: toda mutación escribe en drift y encola en el outbox;
/// el sync engine sube/descarga. Los movimientos se registran con
/// `sincronizado=0` y se suben por el flujo especial (no por outbox).
class InventarioRepository {
  InventarioRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------
  // Categorías
  // ---------------------------------------------------------------------

  Future<List<Categoria>> getAllCategorias() =>
      (_db.select(_db.categorias)..orderBy([(t) => OrderingTerm.asc(t.nombre)])).get();

  Stream<List<Categoria>> watchCategorias() =>
      (_db.select(_db.categorias)..orderBy([(t) => OrderingTerm.asc(t.nombre)])).watch();

  Future<int> insertCategoria({
    required String nombre,
    String? descripcion,
    String color = '#2196F3',
  }) async {
    final id = await _db.into(_db.categorias).insert(
          CategoriasCompanion.insert(
            nombre: nombre,
            descripcion: Value(descripcion),
            color: Value(color),
            activo: const Value(1),
            visibleEnPos: const Value(1),
            createdAt: Value(DateTime.now()),
          ),
          mode: InsertMode.replace,
        );
    await addPending(
      _db,
      tableName: 'categorias',
      operation: 'insert',
      data: {'nombre': nombre},
    );
    return id;
  }

  // ---------------------------------------------------------------------
  // Productos
  // ---------------------------------------------------------------------

  Future<List<Producto>> getAllProductos({String searchTerm = ''}) {
    final q = _db.select(_db.productos)
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    if (searchTerm.isNotEmpty) {
      q.where((t) => t.nombre.lower().contains(searchTerm.toLowerCase()));
    }
    return q.get();
  }

  Stream<List<Producto>> watchProductos({String searchTerm = ''}) {
    final q = _db.select(_db.productos)
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    if (searchTerm.isNotEmpty) {
      q.where((t) => t.nombre.lower().contains(searchTerm.toLowerCase()));
    }
    return q.watch();
  }

  Future<List<Producto>> getProductosByCategoria(int categoriaId) {
    final q = _db.select(_db.productos)
      ..where((t) => t.categoriaId.equals(categoriaId))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return q.get();
  }

  Future<List<Existencia>> getExistenciasByProducto(int productoId) {
    return (_db.select(_db.existencias)
          ..where((t) => t.productoId.equals(productoId)))
        .get();
  }

  Future<void> insertProducto({
    required String nombre,
    String? codigo,
    String? descripcion,
    int? categoriaId,
    double precioVenta = 0,
    String unidadMedida = 'unidad',
    double stockMinimo = 0,
    String tipo = 'ninguno',
    String almacenPredeterminado = 'principal',
    bool esPesable = false,
  }) async {
    await _db.into(_db.productos).insert(
          ProductosCompanion.insert(
            nombre: nombre,
            codigo: Value(codigo),
            descripcion: Value(descripcion),
            categoriaId: Value(categoriaId),
            precioVenta: Value(precioVenta),
            unidadMedida: Value(unidadMedida),
            stockMinimo: Value(stockMinimo),
            tipo: Value(tipo),
            almacenPredeterminado: Value(almacenPredeterminado),
            esPesable: Value(esPesable ? 1 : 0),
            activo: const Value(1),
            createdAt: Value(DateTime.now()),
          ),
          mode: InsertMode.replace,
        );
    await addPending(
      _db,
      tableName: 'productos',
      operation: 'insert',
      data: {'nombre': nombre},
    );
  }

  // ---------------------------------------------------------------------
  // Movimientos (porta registrar_movimiento de movements.py)
  // ---------------------------------------------------------------------

  /// Registra un movimiento y actualiza la existencia (offline-first).
  /// Devuelve `false` si el stock no alcanza (salidas/ajustes negativos).
  Future<bool> registrarMovimiento({
    required int productoId,
    required String tipo, // entrada, salida, ajuste, entrada_produccion
    required double cantidad,
    double pesoTotal = 0,
    String? almacen,
    String? observaciones,
    String registradoPor = 'sistema',
    bool esPesable = false,
    String unidadMedida = 'unidad',
  }) async {
    final almacenSel =
        (almacen ?? '').trim().isNotEmpty ? almacen!.trim() : 'principal';

    final existActual = await (_db.select(_db.existencias)
          ..where((t) => t.productoId.equals(productoId) & t.almacen.equals(almacenSel)))
        .getSingleOrNull();
    final cantAnterior = existActual?.cantidad ?? 0;

    // Si es pesable y hay peso, se mueve por peso (kg); si no, por cantidad.
    final esPorPeso = esPesable && pesoTotal > 0;
    final cantAMover = esPorPeso ? pesoTotal : cantidad;
    final unidad = esPesable ? 'kg' : unidadMedida;

    double cantNueva;
    if (tipo == 'entrada' || tipo == 'entrada_produccion' || tipo == 'ajuste') {
      cantNueva = cantAnterior + cantAMover;
    } else {
      if (cantAnterior < cantAMover) return false; // stock insuficiente
      cantNueva = cantAnterior - cantAMover;
    }

    await _db.into(_db.movimientos).insert(
          MovimientosCompanion.insert(
            productoId: productoId,
            tipo: tipo,
            cantidad: cantidad,
            cantidadAnterior: Value(cantAnterior),
            cantidadNueva: Value(cantNueva),
            pesoTotal: Value(pesoTotal),
            registradoPor: Value(registradoPor),
            observaciones: Value(observaciones ?? ''),
            almacen: Value(almacenSel),
            fechaMovimiento: Value(DateTime.now()),
            createdAt: Value(DateTime.now()),
            sincronizado: const Value(0),
          ),
        );

    await upsertExistencia(
      productoId: productoId,
      almacen: almacenSel,
      cantidad: cantNueva,
      unidad: unidad,
    );

    // El movimiento queda sincronizado=0 → lo sube _uploadPendingMovimientos.
    return true;
  }

  Future<void> upsertExistencia({
    required int productoId,
    required String almacen,
    required double cantidad,
    String unidad = 'unidad',
  }) {
    return _db.into(_db.existencias).insertOnConflictUpdate(
          ExistenciasCompanion.insert(
            productoId: Value(productoId),
            almacen: almacen,
            cantidad: Value(cantidad),
            unidad: Value(unidad),
          ),
        );
  }

  // ---------------------------------------------------------------------
  // Lista de compra (compras_lista) — porta usr/views/inventario/shopping_list.py
  // ---------------------------------------------------------------------

  Future<List<ComprasListaData>> getComprasLista() {
    return (_db.select(_db.comprasLista)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  /// Versión con join a Producto + Categoría para la UI de lista de compra.
  Future<List<ComprasListaItem>> getComprasListaConProductos() async {
    final rows = await (_db.select(_db.comprasLista)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    if (rows.isEmpty) return [];

    // Obtener productos relacionados
    final productoIds = rows.map((r) => r.productoId).whereType<int>().toSet();
    final productos = await (_db.select(_db.productos)
          ..where((t) => t.id.isIn(productoIds)))
        .get();

    // Mapa id -> producto
    final prodMap = {for (final p in productos) p.id: p};

    // Obtener categorías de esos productos
    final catIds = productos.map((p) => p.categoriaId).whereType<int>().toSet();
    final categorias = await (_db.select(_db.categorias)
          ..where((t) => t.id.isIn(catIds)))
        .get();
    final catMap = {for (final c in categorias) c.id: c};

    return rows.map((row) {
      final p = prodMap[row.productoId];
      final cat = p != null && p.categoriaId != null ? catMap[p.categoriaId] : null;
      if (p == null) return null;
      return ComprasListaItem(
        id: row.id,
        productoId: p.id,
        nombre: p.nombre,
        precioVenta: p.precioVenta,
        stockActual: p.stockActual,
        unidadMedida: p.unidadMedida,
        categoriaId: p.categoriaId ?? 0,
        categoriaNombre: cat?.nombre ?? '',
        categoriaColor: cat?.color ?? '#2196F3',
        esPesable: p.esPesable == 1,
      );
    }).whereType<ComprasListaItem>().toList();
  }

  Future<void> toggleComprasLista(int productoId) async {
    final exists = await (_db.select(_db.comprasLista)
          ..where((t) => t.productoId.equals(productoId)))
        .getSingleOrNull();
    if (exists != null) {
      await (_db.delete(_db.comprasLista)..where((t) => t.productoId.equals(productoId))).go();
    } else {
      await _db.into(_db.comprasLista).insert(
            ComprasListaCompanion.insert(
              productoId: productoId,
              createdAt: Value(DateTime.now()),
            ),
          );
    }
  }

  Future<void> deleteComprasLista(int productoId) {
    return (_db.delete(_db.comprasLista)..where((t) => t.productoId.equals(productoId))).go();
  }
}

/// Item para la UI de lista de compra (join Producto + Categoría).
class ComprasListaItem {
  ComprasListaItem({
    required this.id,
    required this.productoId,
    required this.nombre,
    required this.precioVenta,
    required this.stockActual,
    required this.unidadMedida,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.categoriaColor,
    required this.esPesable,
  });

  final int id;
  final int productoId;
  final String nombre;
  final double precioVenta;
  final double stockActual;
  final String unidadMedida;
  final int categoriaId;
  final String categoriaNombre;
  final String categoriaColor;
  final bool esPesable;
}