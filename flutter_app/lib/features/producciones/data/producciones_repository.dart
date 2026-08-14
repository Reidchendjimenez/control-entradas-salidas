import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/sync/sync_service.dart';

/// Componente de receta con datos del producto para la UI.
/// Porta el join `receta_componentes + productos` de `get_componentes_by_receta`.
class ComponenteInfo {
  const ComponenteInfo({
    required this.id,
    required this.recetaId,
    required this.productoId,
    required this.cantidad,
    required this.unidad,
    required this.tipoComponente,
    required this.pesoVariable,
    this.nombre = '',
    this.esPesable = false,
  });

  final int id;
  final int recetaId;
  final int productoId;
  final double cantidad;
  final String unidad;
  final String tipoComponente;
  final int pesoVariable;
  final String nombre;
  final bool esPesable;
}

/// Ingrediente/RESULTADO a descargar en una producción pendiente.
class DescargoItem {
  const DescargoItem({
    required this.productoId,
    required this.nombre,
    required this.cantidadSugerida,
    required this.pesoVariable,
    required this.unidad,
    required this.esPesable,
    required this.almacen,
  });

  final int productoId;
  final String nombre;
  final double cantidadSugerida;
  final bool pesoVariable;
  final String unidad;
  final bool esPesable;
  final String almacen;

  String get unidadLabel => esPesable ? 'kg' : unidad;
}

/// Producto resultante de una producción (detalle tipo 'entrada').
class Producido {
  const Producido({
    required this.productoId,
    required this.nombre,
    required this.cantidad,
    required this.unidad,
  });

  final int productoId;
  final String nombre;
  final double cantidad;
  final String unidad;
}

/// Producción con el nombre de su receta para las cards.
class ProduccionInfo {
  const ProduccionInfo({
    required this.id,
    required this.recetaId,
    required this.cantidad,
    required this.estado,
    required this.usuario,
    required this.observaciones,
    required this.cocineros,
    required this.fechaProduccion,
    required this.recetaNombre,
    required this.recetaTipo,
  });

  final int id;
  final int recetaId;
  final double cantidad;
  final String estado;
  final String? usuario;
  final String? observaciones;
  final String? cocineros;
  final DateTime? fechaProduccion;
  final String recetaNombre;
  final String recetaTipo;

  factory ProduccionInfo.fromRows(Produccione p, String recetaNombre,
      String recetaTipo) {
    return ProduccionInfo(
      id: p.id,
      recetaId: p.recetaId,
      cantidad: p.cantidad,
      estado: p.estado,
      usuario: p.usuario,
      observaciones: p.observaciones,
      cocineros: p.cocineros,
      fechaProduccion: p.fechaProduccion,
      recetaNombre: recetaNombre.isEmpty ? '?' : recetaNombre,
      recetaTipo: recetaTipo,
    );
  }
}

/// Detalle de producción con el nombre del producto.
class DetalleInfo {
  const DetalleInfo({
    required this.id,
    required this.produccionId,
    required this.productoId,
    required this.tipo,
    required this.cantidad,
    required this.unidad,
    required this.movimientoId,
    required this.productoNombre,
  });

  final int id;
  final int produccionId;
  final int productoId;
  final String tipo;
  final double cantidad;
  final String unidad;
  final int? movimientoId;
  final String productoNombre;
}

/// Entrada para `saveReceta`.
class RecetaComponenteInput {
  const RecetaComponenteInput({
    required this.productoId,
    required this.cantidad,
    required this.tipoComponente,
    this.unidad = 'unidad',
    this.pesoVariable = 0,
  });

  final int productoId;
  final double cantidad;
  final String tipoComponente;
  final String unidad;
  final int pesoVariable;
}

/// Repositorio de producciones — porta `usr/views/producciones/data.py` +
/// `local_replica.py` (recetas, producciones, descargo). Sigue el patrón de
/// `InventarioRepository`/`RequisicionesRepository` (offline-first + outbox).
class ProduccionesRepository {
  ProduccionesRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------
  // Recetas
  // ---------------------------------------------------------------------

  Future<List<Receta>> getRecetas({bool activo = true}) {
    final q = _db.select(_db.recetas);
    if (activo) q.where((t) => t.activo.equals(1));
    q.orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return q.get();
  }

  Future<Receta?> getReceta(int id) {
    return (_db.select(_db.recetas)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<int> contarComponentes(int recetaId) async {
    final row = await (_db.selectOnly(_db.recetaComponentes)
          ..addColumns([_db.recetaComponentes.id.count()])
          ..where(_db.recetaComponentes.recetaId.equals(recetaId)))
        .getSingle();
    return row.read(_db.recetaComponentes.id.count()) ?? 0;
  }

  Future<int> contarTipoComponente(int recetaId, String tipo) async {
    final row = await (_db.selectOnly(_db.recetaComponentes)
          ..addColumns([_db.recetaComponentes.id.count()])
          ..where(_db.recetaComponentes.recetaId.equals(recetaId) &
              _db.recetaComponentes.tipoComponente.equals(tipo)))
        .getSingle();
    return row.read(_db.recetaComponentes.id.count()) ?? 0;
  }

  Future<int> contarPesoVariable(int recetaId) async {
    final row = await (_db.selectOnly(_db.recetaComponentes)
          ..addColumns([_db.recetaComponentes.id.count()])
          ..where(_db.recetaComponentes.recetaId.equals(recetaId) &
              _db.recetaComponentes.pesoVariable.equals(1)))
        .getSingle();
    return row.read(_db.recetaComponentes.id.count()) ?? 0;
  }

  /// Componentes con nombre y flag pesable (porta `get_componentes_by_receta`).
  Future<List<ComponenteInfo>> getComponentes(int recetaId) async {
    final rows = await (_db.select(_db.recetaComponentes).join([
      innerJoin(
        _db.productos,
        _db.productos.id.equalsExp(_db.recetaComponentes.productoId),
      ),
    ])..where(_db.recetaComponentes.recetaId.equals(recetaId))).get();
    return rows.map((r) {
      final c = r.readTable(_db.recetaComponentes);
      final p = r.readTable(_db.productos);
      return ComponenteInfo(
        id: c.id,
        recetaId: c.recetaId,
        productoId: c.productoId,
        cantidad: c.cantidad,
        unidad: c.unidad,
        tipoComponente: c.tipoComponente,
        pesoVariable: c.pesoVariable,
        nombre: p.nombre,
        esPesable: p.esPesable == 1,
      );
    }).toList();
  }

  /// Todos los componentes con nombre (para precargar counts sin N+1).
  Future<List<ComponenteInfo>> getAllComponentes() async {
    final rows = await (_db.select(_db.recetaComponentes).join([
      leftOuterJoin(
        _db.productos,
        _db.productos.id.equalsExp(_db.recetaComponentes.productoId),
      ),
    ])).get();
    return rows.map((r) {
      final c = r.readTable(_db.recetaComponentes);
      final p = r.readTableOrNull(_db.productos);
      return ComponenteInfo(
        id: c.id,
        recetaId: c.recetaId,
        productoId: c.productoId,
        cantidad: c.cantidad,
        unidad: c.unidad,
        tipoComponente: c.tipoComponente,
        pesoVariable: c.pesoVariable,
        nombre: p?.nombre ?? '',
        esPesable: p?.esPesable == 1,
      );
    }).toList();
  }

  /// Guarda receta + reemplaza componentes (porta `guardar_receta` +
  /// `save_receta` + `save_componentes`). Devuelve el id de la receta.
  Future<int> saveReceta({
    required String nombre,
    required String tipo,
    required double cantidadProducida,
    int? productoBaseId,
    int? productoFinalId,
    List<RecetaComponenteInput> componentes = const [],
    int? recetaId,
    int activo = 1,
  }) async {
    final now = DateTime.now();
    final id = await _db.transaction(() async {
      int rid;
      if (recetaId != null) {
        await (_db.update(_db.recetas)..where((t) => t.id.equals(recetaId)))
            .write(RecetasCompanion(
          nombre: Value(nombre),
          tipo: Value(tipo),
          productoBaseId: Value(productoBaseId),
          productoFinalId: Value(productoFinalId),
          cantidadProducida: Value(cantidadProducida),
          activo: Value(activo),
          updatedAt: Value(now),
        ));
        rid = recetaId;
      } else {
        rid = await _db.into(_db.recetas).insert(
              RecetasCompanion.insert(
                nombre: nombre,
                tipo: tipo,
                productoBaseId: Value(productoBaseId),
                productoFinalId: Value(productoFinalId),
                cantidadProducida: Value(cantidadProducida),
                activo: Value(activo),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
      }
      await (_db.delete(_db.recetaComponentes)
            ..where((t) => t.recetaId.equals(rid)))
          .go();
      for (final c in componentes) {
        await _db.into(_db.recetaComponentes).insert(
              RecetaComponentesCompanion.insert(
                recetaId: rid,
                productoId: c.productoId,
                cantidad: c.cantidad,
                unidad: Value(c.unidad.isEmpty ? 'unidad' : c.unidad),
                tipoComponente: c.tipoComponente,
                pesoVariable: Value(c.pesoVariable),
              ),
            );
      }
      return rid;
    });

    await addPending(
      _db,
      tableName: 'recetas',
      operation: 'insert',
      data: {
        'nombre': nombre,
        'tipo': tipo,
        'producto_base_id': productoBaseId,
        'producto_final_id': productoFinalId,
        'cantidad_producida': cantidadProducida,
        'activo': activo,
      },
    );
    await addPending(
      _db,
      tableName: 'receta_componentes',
      operation: 'delete',
      data: {'receta_id': id},
    );
    for (final c in componentes) {
      await addPending(
        _db,
        tableName: 'receta_componentes',
        operation: 'insert',
        data: {
          'receta_id': id,
          'producto_id': c.productoId,
          'cantidad': c.cantidad,
          'unidad': c.unidad.isEmpty ? 'unidad' : c.unidad,
          'tipo_componente': c.tipoComponente,
          'peso_variable': c.pesoVariable,
        },
      );
    }
    return id;
  }

  Future<void> eliminarReceta(int recetaId) async {
    await (_db.delete(_db.recetaComponentes)
          ..where((t) => t.recetaId.equals(recetaId)))
        .go();
    await (_db.delete(_db.recetas)..where((t) => t.id.equals(recetaId))).go();
    await addPending(_db,
        tableName: 'recetas', operation: 'delete', data: {'id': recetaId});
    await addPending(_db,
        tableName: 'receta_componentes',
        operation: 'delete',
        data: {'receta_id': recetaId});
  }

  // ---------------------------------------------------------------------
  // Productos y stock
  // ---------------------------------------------------------------------

  Future<List<Producto>> getProductosActivos({int limit = 500}) {
    return (_db.select(_db.productos)
          ..where((t) => t.activo.equals(1))
          ..orderBy([(t) => OrderingTerm.asc(t.nombre)])
          ..limit(limit))
        .get();
  }

  Future<Producto?> getProducto(int id) {
    return (_db.select(_db.productos)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<double> stockTotalProducto(int productoId) async {
    final rows = await (_db.select(_db.existencias)
          ..where((t) => t.productoId.equals(productoId)))
        .get();
    var total = 0.0;
    for (final e in rows) {
      total += e.cantidad;
    }
    return total;
  }

  /// Stock total (todos los almacenes) por producto, en una sola consulta.
  Future<Map<int, double>> stockTotalPorProducto() async {
    final rows = _db.selectOnly(_db.existencias)
      ..addColumns([
        _db.existencias.productoId,
        _db.existencias.cantidad.sum(),
      ])
      ..groupBy([_db.existencias.productoId]);
    final result = await rows.get();
    return {
      for (final r in result)
        r.read(_db.existencias.productoId)!
            .toInt(): (r.read(_db.existencias.cantidad.sum()) ?? 0),
    };
  }

  Future<double> getExistencia(int productoId, String almacen) async {
    final e = await (_db.select(_db.existencias)
          ..where((t) =>
              t.productoId.equals(productoId) & t.almacen.equals(almacen)))
        .getSingleOrNull();
    return e?.cantidad ?? 0;
  }

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

  Future<String> almacenProduccionDefault() async {
    try {
      final row = await _db
          .customSelect(
              "SELECT value FROM pos_settings WHERE key = 'almacen_produccion'")
          .getSingleOrNull();
      final v = row?.read<String>('value').trim();
      return (v == null || v.isEmpty) ? 'restaurante' : v;
    } catch (_) {
      return 'restaurante';
    }
  }

  // ---------------------------------------------------------------------
  // Producciones (lectura)
  // ---------------------------------------------------------------------

  /// Historial de producciones con nombre de receta, fecha desc, límite.
  Future<List<ProduccionInfo>> getProducciones({int limit = 50}) async {
    final rows = await (_db.select(_db.producciones).join([
      leftOuterJoin(_db.recetas, _db.recetas.id.equalsExp(_db.producciones.recetaId)),
    ])
          ..orderBy([OrderingTerm.desc(_db.producciones.fechaProduccion)])
          ..limit(limit))
        .get();
    return rows.map((r) {
      final p = r.readTable(_db.producciones);
      final rec = r.readTableOrNull(_db.recetas);
      return ProduccionInfo.fromRows(
        p,
        rec?.nombre ?? '',
        rec?.tipo ?? '',
      );
    }).toList();
  }

  /// Producciones de un estado (porta `load_pendientes`).
  Future<List<ProduccionInfo>> getProduccionesPorEstado(String estado) async {
    final all = await getProducciones(limit: 200);
    return all.where((p) => p.estado == estado).toList();
  }

  Future<ProduccionInfo?> getProduccion(int id) async {
    final rows = await (_db.select(_db.producciones).join([
      leftOuterJoin(_db.recetas, _db.recetas.id.equalsExp(_db.producciones.recetaId)),
    ])..where(_db.producciones.id.equals(id))).get();
    if (rows.isEmpty) return null;
    final r = rows.first;
    final p = r.readTable(_db.producciones);
    final rec = r.readTableOrNull(_db.recetas);
    return ProduccionInfo.fromRows(p, rec?.nombre ?? '', rec?.tipo ?? '');
  }

  /// Detalles de una producción con nombre de producto (porta
  /// `get_detalles_by_produccion`).
  Future<List<DetalleInfo>> getDetalles(int produccionId) async {
    final rows = await (_db.select(_db.produccionDetalles).join([
      leftOuterJoin(
        _db.productos,
        _db.productos.id.equalsExp(_db.produccionDetalles.productoId),
      ),
    ])..where(_db.produccionDetalles.produccionId.equals(produccionId))).get();
    return rows.map((r) {
      final d = r.readTable(_db.produccionDetalles);
      final p = r.readTableOrNull(_db.productos);
      return DetalleInfo(
        id: d.id,
        produccionId: d.produccionId,
        productoId: d.productoId,
        tipo: d.tipo,
        cantidad: d.cantidad,
        unidad: d.unidad,
        movimientoId: d.movimientoId,
        productoNombre: p?.nombre ?? '?',
      );
    }).toList();
  }

  /// Productos resultantes de una producción (detalles tipo 'entrada').
  Future<List<Producido>> productosProducidos(int produccionId) async {
    final detalles = await getDetalles(produccionId);
    return detalles
        .where((d) => d.tipo == 'entrada')
        .map((d) => Producido(
              productoId: d.productoId,
              nombre: d.productoNombre,
              cantidad: d.cantidad,
              unidad: d.unidad,
            ))
        .toList();
  }

  // ---------------------------------------------------------------------
  // Flujo de 2 etapas
  // ---------------------------------------------------------------------

  /// Etapa 1: registra `entrada_produccion` + producción pendiente + detalle.
  /// Si `produccionId` es no nulo, la entrada se VINCULA a ese lote y su
  /// cantidad pasa a ser la suma de todas las entradas (porta
  /// `registrar_produccion_pendiente`). Devuelve (produccion_id, movimiento_id).
  Future<({int? produccionId, int? movimientoId})>
      registrarProduccionPendiente({
    required Producto producto,
    required Receta receta,
    required double cantidad,
    double pesoTotal = 0,
    String? almacen,
    int? produccionId,
    String usuario = 'Sistema',
  }) async {
    final observaciones = produccionId == null
        ? "Producción pendiente - Receta '${receta.nombre}'"
        : "Entrada vinculada al lote #$produccionId - Receta '${receta.nombre}'";

    final movimientoId = await _registrarMovimiento(
      producto: producto,
      tipo: 'entrada_produccion',
      cantidad: cantidad,
      pesoTotal: pesoTotal,
      almacen: almacen,
      observaciones: observaciones,
      registradoPor: usuario,
    );
    if (movimientoId == null) return (produccionId: null, movimientoId: null);

    int pid;
    if (produccionId == null) {
      pid = await _insertProduccion(
        recetaId: receta.id,
        cantidad: cantidad,
        estado: 'pendiente',
        usuario: usuario,
        observaciones: observaciones,
        fechaProduccion: DateTime.now(),
      );
    } else {
      pid = produccionId;
      final entradas = (await getDetalles(pid)).where((d) => d.tipo == 'entrada');
      var total = cantidad;
      for (final d in entradas) {
        total += d.cantidad;
      }
      await _updateProduccionCantidad(pid, total);
    }

    await _insertProduccionDetalle(
      produccionId: pid,
      productoId: producto.id,
      tipo: 'entrada',
      cantidad: cantidad,
      unidad: (pesoTotal > 0 || producto.esPesable == 1)
          ? 'kg'
          : producto.unidadMedida,
      movimientoId: movimientoId,
    );

    return (produccionId: pid, movimientoId: movimientoId);
  }

  /// Calcula los ingredientes a descargar (porta `planificar_descargo`).
  /// Recetas compuestas → INGREDIENTEs; simples → producto_base.
  Future<List<DescargoItem>> planificarDescargo(
      ProduccionInfo produccion, Receta receta) async {
    final esCompuesta = receta.tipo == 'compuesta';
    final produccionCantidad = produccion.cantidad;
    final cantidadBase = receta.cantidadProducida <= 0
        ? 1.0
        : receta.cantidadProducida;
    final factor = produccionCantidad / cantidadBase;
    final almacenDescargo = await almacenProduccionDefault();

    final items = <DescargoItem>[];
    if (esCompuesta) {
      final componentes = await getComponentes(receta.id);
      for (final comp in componentes) {
        if (comp.tipoComponente != 'INGREDIENTE') continue;
        final prod = await getProducto(comp.productoId);
        if (prod == null) continue;
        items.add(DescargoItem(
          productoId: prod.id,
          nombre: prod.nombre,
          cantidadSugerida: comp.cantidad * factor,
          pesoVariable: false,
          unidad: comp.unidad.isEmpty ? prod.unidadMedida : comp.unidad,
          esPesable: prod.esPesable == 1,
          almacen: almacenDescargo,
        ));
      }
    } else if (receta.productoBaseId != null) {
      final prod = await getProducto(receta.productoBaseId!);
      if (prod != null) {
        final pesable = prod.esPesable == 1;
        items.add(DescargoItem(
          productoId: prod.id,
          nombre: prod.nombre,
          cantidadSugerida: pesable ? 0.0 : produccionCantidad,
          pesoVariable: pesable,
          unidad: pesable ? 'kg' : prod.unidadMedida,
          esPesable: pesable,
          almacen: almacenDescargo,
        ));
      }
    }
    return items;
  }

  /// Etapa 2: registra `salida_produccion` por cada ingrediente y marca
  /// completado (porta `ejecutar_descargo`). Devuelve (ok, errores).
  Future<(bool, List<String>)> ejecutarDescargo({
    required ProduccionInfo produccion,
    required Receta receta,
    required List<DescargoItem> items,
    String? cocineros,
    String usuario = 'Sistema',
  }) async {
    final errores = <String>[];

    for (final item in items) {
      final cantidad = item.cantidadSugerida;
      if (cantidad <= 0) continue;
      final prod = await getProducto(item.productoId);
      if (prod == null) {
        errores.add('Producto ${item.productoId} no encontrado');
        continue;
      }
      final esPesable = item.esPesable || prod.esPesable == 1;
      final pesoTotal = esPesable ? cantidad : 0.0;
      final almacen = item.almacen.isEmpty
          ? (prod.almacenPredeterminado.isEmpty
              ? 'principal'
              : prod.almacenPredeterminado)
          : item.almacen;

      final movId = await _registrarMovimiento(
        producto: prod,
        tipo: 'salida_produccion',
        cantidad: cantidad,
        pesoTotal: pesoTotal,
        almacen: almacen,
        observaciones:
            "Descargo Producción #${produccion.id} - ${receta.nombre}",
        registradoPor: usuario,
      );
      if (movId == null) {
        errores.add('Stock insuficiente para ${prod.nombre}');
        continue;
      }

      await _insertProduccionDetalle(
        produccionId: produccion.id,
        productoId: prod.id,
        tipo: 'salida',
        cantidad: cantidad,
        unidad: (esPesable && pesoTotal > 0)
            ? 'kg'
            : (item.unidad.isEmpty ? prod.unidadMedida : item.unidad),
        movimientoId: movId,
      );
    }

    if (errores.isNotEmpty) return (false, errores);

    await _updateProduccionEstado(
      produccion.id,
      'completado',
      observaciones:
          'Descargado por $usuario el ${_fechaTexto(DateTime.now())}',
      cocineros: cocineros,
    );
    return (true, <String>[]);
  }

  /// Revierte todas las entradas del lote y marca la producción cancelada
  /// (porta `cancelar_produccion`). Mantiene audit trail.
  Future<void> cancelarProduccion(
      ProduccionInfo produccion, Receta receta) async {
    final entradas =
        (await getDetalles(produccion.id)).where((d) => d.tipo == 'entrada');

    for (final entrada in entradas) {
      final prod = await getProducto(entrada.productoId);
      if (prod == null) continue;

      final cantidad = entrada.cantidad;
      final esPesable = prod.esPesable == 1;
      var pesoTotal = 0.0;
      var almacen = prod.almacenPredeterminado.isEmpty
          ? 'principal'
          : prod.almacenPredeterminado;

      if (entrada.movimientoId != null) {
        final mov = await (_db.select(_db.movimientos)
              ..where((t) => t.id.equals(entrada.movimientoId!)))
            .getSingleOrNull();
        if (mov != null) {
          if (esPesable) pesoTotal = mov.pesoTotal;
          if (mov.almacen != null && mov.almacen!.isNotEmpty) {
            almacen = mov.almacen!;
          }
        }
      }

      await _registrarMovimiento(
        producto: prod,
        tipo: 'salida_produccion',
        cantidad: cantidad,
        pesoTotal: pesoTotal,
        almacen: almacen,
        observaciones:
            "Cancelación Producción #${produccion.id} - ${receta.nombre}",
        registradoPor: 'Sistema',
      );
    }

    await _updateProduccionEstado(produccion.id, 'cancelada');
  }

  // ---------------------------------------------------------------------
  // Internos
  // ---------------------------------------------------------------------

  /// Registra un movimiento tipo producción + actualiza la existencia
  /// (porta `registrar_movimiento` de inventario/movements.py). Devuelve el
  /// id del movimiento, o `null` si el stock no alcanza (solo salidas).
  Future<int?> _registrarMovimiento({
    required Producto producto,
    required String tipo,
    required double cantidad,
    double pesoTotal = 0,
    String? almacen,
    String? observaciones,
    String registradoPor = 'Sistema',
  }) async {
    final almacenSel = (almacen ?? '').trim().isNotEmpty
        ? almacen!.trim()
        : 'principal';

    final existActual = await getExistencia(producto.id, almacenSel);
    final cantAnterior = existActual;

    final esPesable = producto.esPesable == 1;
    final esPorPeso = esPesable && pesoTotal > 0;
    final cantAMover = esPorPeso ? pesoTotal : cantidad;
    final unidad = esPesable ? 'kg' : producto.unidadMedida;

    double cantNueva;
    if (tipo == 'entrada' ||
        tipo == 'entrada_produccion' ||
        tipo == 'ajuste') {
      cantNueva = cantAnterior + cantAMover;
    } else {
      if (cantAnterior < cantAMover) return null;
      cantNueva = cantAnterior - cantAMover;
    }

    final movId = await _db.into(_db.movimientos).insert(
          MovimientosCompanion.insert(
            productoId: producto.id,
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

    await _db.into(_db.existencias).insertOnConflictUpdate(
      ExistenciasCompanion.insert(
        productoId: Value(producto.id),
        almacen: almacenSel,
        cantidad: Value(cantNueva),
        unidad: Value(unidad),
      ),
    );

    return movId;
  }

  Future<int> _insertProduccion({
    required int recetaId,
    required double cantidad,
    required String estado,
    required String usuario,
    required String observaciones,
    required DateTime fechaProduccion,
  }) async {
    final now = DateTime.now();
    final id = await _db.into(_db.producciones).insert(
          ProduccionesCompanion.insert(
            recetaId: recetaId,
            cantidad: cantidad,
            estado: Value(estado),
            usuario: Value(usuario),
            observaciones: Value(observaciones),
            fechaProduccion: Value(fechaProduccion),
            createdAt: Value(now),
          ),
        );
    await addPending(_db,
        tableName: 'producciones',
        operation: 'insert',
        data: {
          'receta_id': recetaId,
          'cantidad': cantidad,
          'estado': estado,
          'usuario': usuario,
          'observaciones': observaciones,
          'fecha_produccion': fechaProduccion.toIso8601String(),
        });
    return id;
  }

  Future<void> _updateProduccionCantidad(int id, double cantidad) async {
    await (_db.update(_db.producciones)..where((t) => t.id.equals(id)))
        .write(ProduccionesCompanion(cantidad: Value(cantidad)));
  }

  Future<void> _updateProduccionEstado(
    int id,
    String estado, {
    String? observaciones,
    String? cocineros,
  }) async {
    final p = await (_db.select(_db.producciones)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (p == null) return;

    await (_db.update(_db.producciones)..where((t) => t.id.equals(id)))
        .write(ProduccionesCompanion(
      estado: Value(estado),
      observaciones: Value(observaciones ?? p.observaciones),
      cocineros: Value(cocineros ?? p.cocineros),
    ));
    await addPending(_db,
        tableName: 'producciones',
        operation: 'insert',
        data: {
          'receta_id': p.recetaId,
          'cantidad': p.cantidad,
          'estado': estado,
          'usuario': p.usuario,
          'observaciones': observaciones ?? p.observaciones,
          'fecha_produccion': p.fechaProduccion?.toIso8601String(),
          'cocineros': cocineros ?? p.cocineros,
        });
  }

  Future<int> _insertProduccionDetalle({
    required int produccionId,
    required int productoId,
    required String tipo,
    required double cantidad,
    required String unidad,
    int? movimientoId,
  }) async {
    final id = await _db.into(_db.produccionDetalles).insert(
          ProduccionDetallesCompanion.insert(
            produccionId: produccionId,
            productoId: productoId,
            tipo: tipo,
            cantidad: cantidad,
            unidad: Value(unidad.isEmpty ? 'unidad' : unidad),
            movimientoId: Value(movimientoId),
          ),
        );
    await addPending(_db,
        tableName: 'produccion_detalles',
        operation: 'insert',
        data: {
          'produccion_id': produccionId,
          'producto_id': productoId,
          'tipo': tipo,
          'cantidad': cantidad,
          'unidad': unidad.isEmpty ? 'unidad' : unidad,
          'movimiento_id': movimientoId,
        });
    return id;
  }

  String _fechaTexto(DateTime dt) {
    String p(int v) => v.toString().padLeft(2, '0');
    return '${dt.year}-${p(dt.month)}-${p(dt.day)}T${p(dt.hour)}:${p(dt.minute)}:${p(dt.second)}';
  }
}
