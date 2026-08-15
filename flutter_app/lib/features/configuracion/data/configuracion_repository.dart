import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/sync/sync_service.dart';

/// Repositorio de configuración — porta `usr/views/configuracion/*`,
/// `usr/database/local_replica.py` (Periodos, LocalReplica), `usr/database/archive.py`.
class ConfiguracionRepository {
  ConfiguracionRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // Categorias
  // ---------------------------------------------------------------------------

  Future<List<Categoria>> getCategorias({bool soloActivos = true}) {
    final q = _db.select(_db.categorias);
    if (soloActivos) q.where((t) => t.activo.equals(1));
    q.orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return q.get();
  }

  Future<int> createCategoria(CategoriasCompanion data) async {
    final id = await _db.into(_db.categorias).insert(data);
    final c = await (_db.select(_db.categorias)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (c != null) {
      await addPending(_db, tableName: 'categorias', operation: 'insert', data: categoriaToSyncMap(c));
    }
    return id;
  }

  Future<int> updateCategoria(int id, CategoriasCompanion data) async {
    final res = await (_db.update(_db.categorias)..where((t) => t.id.equals(id))).write(data);
    final c = await (_db.select(_db.categorias)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (c != null) {
      await addPending(_db, tableName: 'categorias', operation: 'update', data: categoriaToSyncMap(c));
    }
    return res;
  }

  /// Soft-delete en el server (activo=0): borrar la categoría en remoto rompería
  /// la FK `productos.categoria_id`.
  Future<int> deleteCategoria(int id) async {
    final res = await (_db.delete(_db.categorias)..where((t) => t.id.equals(id))).go();
    await addPending(
      _db,
      tableName: 'categorias',
      operation: 'update',
      data: {'id': id, 'activo': false, 'updated_at': DateTime.now().toUtc().toIso8601String()},
    );
    return res;
  }

  // ---------------------------------------------------------------------------
  // Productos
  // ---------------------------------------------------------------------------

  Future<List<Producto>> getProductos({
    bool soloActivos = true,
    int? categoriaId,
    String? search,
  }) {
    final q = _db.select(_db.productos);
    if (soloActivos) q.where((t) => t.activo.equals(1));
    if (categoriaId != null) q.where((t) => t.categoriaId.equals(categoriaId));
    if (search != null && search.isNotEmpty) {
      final term = search.toLowerCase();
      q.where((t) => t.nombre.lower().contains(term));
    }
    q.orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return q.get();
  }

  /// Genera el siguiente código numérico (auto-incremental), igual que el
  /// modelo Flet: max(códigos numéricos) + 1, rellenado a >= 4 dígitos.
  Future<String> proximoCodigoProducto() async {
    final productos = await (_db.select(_db.productos)..where((t) => t.activo.equals(1))).get();
    final numericos = <int>[];
    for (final p in productos) {
      final c = (p.codigo ?? '').trim();
      final n = int.tryParse(c);
      if (n != null) numericos.add(n);
    }
    if (numericos.isEmpty) return '0001';
    final siguiente = numericos.reduce((a, b) => a > b ? a : b) + 1;
    var longitud = 4;
    for (final p in productos) {
      final c = (p.codigo ?? '').trim();
      if (int.tryParse(c) != null && c.length > longitud) longitud = c.length;
    }
    return siguiente.toString().padLeft(longitud, '0');
  }

  Future<int> createProducto(ProductosCompanion data) async {
    final id = await _db.into(_db.productos).insert(data);
    await _encolarProducto(id, 'insert');
    return id;
  }

  Future<int> updateProducto(int id, ProductosCompanion data) async {
    final res = await (_db.update(_db.productos)..where((t) => t.id.equals(id))).write(data);
    await _encolarProducto(id, 'update');
    return res;
  }

  /// Encola la creación/edición del producto con la fila completa y su id local
  /// (el server acepta id explícito y así no se rompe la FK de movimientos).
  Future<void> _encolarProducto(int id, String op) async {
    final p = await (_db.select(_db.productos)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (p == null) return;
    await addPending(_db, tableName: 'productos', operation: op, data: productoToSyncMap(p));
  }

  /// Borra local y desactiva en el server (`activo=0`): borrarlo en remoto
  /// rompería la FK de movimientos/existencias que lo referencian.
  Future<int> deleteProducto(int id) async {
    final p = await (_db.select(_db.productos)..where((t) => t.id.equals(id))).getSingleOrNull();
    final res = await (_db.delete(_db.productos)..where((t) => t.id.equals(id))).go();
    if (p != null) {
      final data = productoToSyncMap(p)..['activo'] = false;
      await addPending(_db, tableName: 'productos', operation: 'update', data: data);
    }
    return res;
  }

  // ---------------------------------------------------------------------------
  // Proveedores
  // ---------------------------------------------------------------------------

  Future<List<Proveedore>> getProveedores({String estado = 'Activo'}) {
    final q = _db.select(_db.proveedores)..where((t) => t.estado.equals(estado));
    q.orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return q.get();
  }

  Future<int> createProveedor(ProveedoresCompanion data) async {
    final id = await _db.into(_db.proveedores).insert(data);
    final p = await (_db.select(_db.proveedores)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (p != null) {
      await addPending(_db, tableName: 'proveedores', operation: 'insert', data: proveedorToSyncMap(p));
    }
    return id;
  }

  Future<int> updateProveedor(int id, ProveedoresCompanion data) async {
    final res = await (_db.update(_db.proveedores)..where((t) => t.id.equals(id))).write(data);
    final p = await (_db.select(_db.proveedores)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (p != null) {
      await addPending(_db, tableName: 'proveedores', operation: 'update', data: proveedorToSyncMap(p));
    }
    return res;
  }

  Future<int> deleteProveedor(int id) async {
    final res = await (_db.delete(_db.proveedores)..where((t) => t.id.equals(id))).go();
    await addPending(_db, tableName: 'proveedores', operation: 'delete', data: {'id': id});
    return res;
  }

  // ---------------------------------------------------------------------------
  // Periodos
  // ---------------------------------------------------------------------------

Future<List<Periodo>> getPeriodos() {
    return (_db.select(_db.periodos)..orderBy([(t) => OrderingTerm.desc(t.fechaApertura)])).get();
  }

  Future<bool> periodoExiste(String periodo) {
    return (_db.select(_db.periodos)..where((t) => t.periodo.equals(periodo))).getSingleOrNull().then((v) => v != null);
  }

  Future<int> crearPeriodo(String periodo, {String? registradoPor}) {
    return _db.into(_db.periodos).insert(
      PeriodosCompanion.insert(
        periodo: periodo,
        fechaApertura: DateTime.now().toIso8601String(),
        registradoPor: Value(registradoPor),
      ),
    );
  }

  Future<void> recalcularExistencias() async {
    // Borrar checkpoints y recalcular desde cero
    await _db.delete(_db.stockCheckpoint).go();
    await _recalcularExistenciasDesdeMovimientos();
  }

  Future<void> _recalcularExistenciasDesdeMovimientos() async {
    final movs = await (_db.select(_db.movimientos)
          ..where((t) => t.tipo.equals('entrada') | t.tipo.equals('salida') | t.tipo.equals('ajuste'))
          ..orderBy([(t) => OrderingTerm.asc(t.fechaMovimiento)]))
        .get();

    final Map<String, double> stock = {};
    for (final m in movs) {
      final key = '${m.productoId}|${m.almacen ?? 'principal'}';
      final signo = m.tipo == 'salida' ? -1.0 : 1.0;
      stock[key] = (stock[key] ?? 0) + (m.cantidad * signo);
    }

    await _db.batch((batch) {
      for (final entry in stock.entries) {
        final parts = entry.key.split('|');
        batch.insert(_db.existencias, ExistenciasCompanion(
          productoId: Value(int.parse(parts[0])),
          almacen: Value(parts[1]),
          cantidad: Value(entry.value),
          unidad: Value('unidad'),
        ), mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<void> clearCheckpoints() {
    return _db.delete(_db.stockCheckpoint).go();
  }

  // ---------------------------------------------------------------------------
  // Sistema / Ajustes POS
  // ---------------------------------------------------------------------------

  Future<String?> getPosSetting(String key, {String? def}) {
    return _db.customSelect("SELECT value FROM pos_settings WHERE key = '$key'")
        .getSingleOrNull()
        .then((r) => r?.read<String>('value') ?? def);
  }

  Future<void> setPosSetting(String key, String value) {
    return _db.customStatement("INSERT OR REPLACE INTO pos_settings (key, value) VALUES ('$key', '$value')");
  }

  Future<bool> getPermitirStockNegativo() async {
    final v = await getPosSetting('permitir_stock_negativo', def: '0');
    return v == '1';
  }

  Future<void> setPermitirStockNegativo(bool v) {
    return setPosSetting('permitir_stock_negativo', v ? '1' : '0');
  }

  Future<String> getAlmacenProduccionDefault() async {
    final v = await getPosSetting('almacen_produccion', def: 'restaurante');
    return v ?? 'restaurante';
  }

  Future<void> setAlmacenProduccionDefault(String almacen) {
    return setPosSetting('almacen_produccion', almacen);
  }

  Future<List<String>> getAlmacenes() async {
    final rows = await _db.customSelect('SELECT DISTINCT almacen FROM existencias WHERE almacen IS NOT NULL UNION SELECT DISTINCT almacen FROM movimientos WHERE almacen IS NOT NULL').get();
    return rows.map((r) => r.read<String>('almacen') as String).where((a) => a.isNotEmpty).toSet().toList();
  }

  // ---------------------------------------------------------------------------
  // Dispositivo / Usuario
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>?> getUsuarioDispositivo() {
    return _db.select(_db.dispositivoUsuario).getSingleOrNull()
        .then((u) => u != null ? {'id': u.id, 'nombre': u.nombre, 'pinHash': u.pinHash, 'configuradoEn': u.configuradoEn} : null);
  }

  Future<int> crearUsuarioDispositivo(DispositivoUsuarioCompanion data) {
    return _db.into(_db.dispositivoUsuario).insert(data);
  }

  Future<int> eliminarUsuarioDispositivo() {
    return _db.delete(_db.dispositivoUsuario).go();
  }

  Future<bool> verificarPin(String pin) async {
    final user = await getUsuarioDispositivo();
    if (user == null || user['pinHash'] == null) return true;
    // Simple hash check (en producción usar bcrypt/argon2)
    return user['pinHash'] == pin; // Placeholder
  }

  // ---------------------------------------------------------------------------
  // Archive / Periodos (funciones avanzadas)
  // ---------------------------------------------------------------------------

  /// Archiva movimientos > 3 meses activos y > 7 meses retención
  Future<(int archivados, int eliminados)> archivarMovimientos({int mesesActivos = 3, int mesesRetencion = 7}) async {
    final now = DateTime.now();
    final cutoffActivo = now.subtract(Duration(days: mesesActivos * 30));
    final cutoffRetencion = now.subtract(Duration(days: mesesRetencion * 30));

    final movs = await (_db.select(_db.movimientos)
          ..where((t) => t.fechaMovimiento.isSmallerThanValue(cutoffActivo))
          ..orderBy([(t) => OrderingTerm.asc(t.fechaMovimiento)]))
        .get();

    int archivados = 0, eliminados = 0;
    for (final m in movs) {
      final isOld = m.fechaMovimiento != null && m.fechaMovimiento!.isBefore(cutoffRetencion);
      if (isOld) {
        _db.delete(_db.movimientos).where((t) => t.id.equals(m.id));
        eliminados++;
      } else {
        // Mover a movimientos_archivo
        await _db.into(_db.movimientosArchivo).insertOnConflictUpdate(MovimientosArchivoCompanion.insert(
          id: Value(m.id),
          productoId: m.productoId,
          facturaId: Value(m.facturaId),
          requisicionId: Value(m.requisicionId),
          tipo: m.tipo,
          cantidad: m.cantidad,
          cantidadAnterior: Value(m.cantidadAnterior),
          cantidadNueva: Value(m.cantidadNueva),
          pesoTotal: Value(m.pesoTotal),
          registradoPor: Value(m.registradoPor),
          observaciones: Value(m.observaciones),
          almacen: Value(m.almacen),
          fechaMovimiento: Value(m.fechaMovimiento),
          createdAt: Value(m.createdAt),
        ));
        _db.delete(_db.movimientos).where((t) => t.id.equals(m.id));
        archivados++;
      }
    }
    return (archivados, eliminados);
  }

  Future<int> archivarEnSupabase({int mesesActivos = 3}) async {
    // Placeholder: delegar al SyncEngine / SyncService
    return 0;
  }

  Future<bool> testLocalConnection() async {
    try {
      await _db.customSelect('SELECT 1').getSingle();
      return true;
    } catch (_) {
      return false;
    }
  }
}