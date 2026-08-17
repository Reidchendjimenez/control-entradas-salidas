import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/sync/sync_service.dart';

/// Repositorio de datos del módulo POS — porta `LocalReplica` + el flujo de
/// datos de `usr/pos/views/config.py`.
///
/// Estrategia heredada: toda mutación escribe en drift y encola en el outbox
/// (sync_queue) con los nombres de columna remotos; el `PosSyncEngine` sube.
/// Las tablas `pos_*`/`platos_*` NO las procesa el motor de sync general.
class PosRepository {
  PosRepository(this._db);

  final AppDatabase _db;

  static const Uuid _uuid = Uuid();

  static String _pinHash(String pin) =>
      sha256.convert(utf8.encode(pin.trim())).toString();

  // ---------------------------------------------------------------------
  // Settings
  // ---------------------------------------------------------------------

  Future<String?> getSetting(String key) async {
    final row = await (_db.select(_db.posSettings)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  /// Réplica de `set_pos_setting`: guarda y (si sync) encola para Supabase.
  Future<void> setSetting(String key, String value, {bool sync = true}) async {
    await _db.into(_db.posSettings).insertOnConflictUpdate(
          PosSettingsCompanion.insert(key: key, value: Value(value)),
        );
    if (sync) {
      await addPending(_db,
          tableName: 'pos_settings',
          operation: 'upsert',
          data: {'key': key, 'value': value});
    }
  }

  // ---------------------------------------------------------------------
  // Sesiones / turnos / caja
  // ---------------------------------------------------------------------

  /// Abre un turno con caja en 0 (réplica de `abrir_turno`): crea la sesión,
  /// le asigna `sync_uuid` y la encola para subir a Supabase.
  Future<int> abrirSesion(int usuarioId) async {
    final now = DateTime.now();
    final syncUuid = _uuid.v4();
    final id = await _db.into(_db.posSesiones).insert(
          PosSesionesCompanion.insert(
            usuarioId: usuarioId,
            abiertaEn: now,
            cajaInicial: const Value(0),
            syncUuid: Value(syncUuid),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    await _encolarSesion(id, syncUuid);
    return id;
  }

  /// Cierra el turno: calcula la caja final automáticamente
  /// (`caja_inicial + ventas vigentes del turno`) y marca `cerrada_en`.
  /// Port de `cerrar_turno` (login.py).
  Future<void> cerrarSesion(int sesionId) async {
    final s = await (_db.select(_db.posSesiones)
          ..where((t) => t.id.equals(sesionId)))
        .getSingleOrNull();
    if (s == null) return;
    final now = DateTime.now();
    final caja = await _totalVigenteDeSesion(sesionId);
    await (_db.update(_db.posSesiones)..where((t) => t.id.equals(sesionId)))
        .write(PosSesionesCompanion(
          cerradaEn: Value(now),
          cajaFinal: Value(s.cajaInicial + caja),
          updatedAt: Value(now),
        ));
    await _encolarSesion(sesionId, s.syncUuid);
  }

  /// Suma de las ventas vigentes de un turno.
  Future<double> _totalVigenteDeSesion(int sesionId) async {
    final q = await _db.customSelect(
      'SELECT COALESCE(SUM(total), 0) AS total FROM pos_ventas '
      'WHERE sesion_id = ? AND estado = ?',
      variables: [
        Variable<int>(sesionId),
        const Variable<String>('vigente'),
      ],
    ).getSingle();
    return q.read<double>('total');
  }

  /// Última sesión abierta (sin `cerrada_en`), con nombre de usuario.
  Future<({PosSesione sesion, String? usuarioNombre})?> getSesionActiva() async {
    final rows = await (_db.select(_db.posSesiones)
          ..where((t) => t.cerradaEn.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.abiertaEn)])
          ..limit(1))
        .get();
    if (rows.isEmpty) return null;
    final s = rows.first;
    final u = await (_db.select(_db.posUsuarios)
          ..where((t) => t.id.equals(s.usuarioId)))
        .getSingleOrNull();
    return (sesion: s, usuarioNombre: u?.nombre);
  }

  /// Turnos (sesiones) con resumen de cierre, más recientes primero, paginados
  /// por id. `ventas`/`totalVentas` consideran solo ventas vigentes.
  Future<List<({PosSesione sesion, String? usuarioNombre, int ventas, double totalVentas})>>
      getSesiones({int limit = 50, int? beforeId}) async {
    var q = _db.select(_db.posSesiones)
      ..orderBy([(t) => OrderingTerm.desc(t.id)])
      ..limit(limit);
    if (beforeId != null) q.where((t) => t.id.isSmallerThanValue(beforeId));
    final sesiones = await q.get();

    final resumen = await _db.customSelect(
      'SELECT sesion_id, COUNT(*) AS ventas, COALESCE(SUM(total), 0) AS total_ventas '
      'FROM pos_ventas WHERE estado = ? GROUP BY sesion_id',
      variables: [const Variable<String>('vigente')],
    ).get();
    final resumenMap = <int, ({int ventas, double total})>{};
    for (final r in resumen) {
      resumenMap[r.read<int>('sesion_id')] = (
        ventas: r.read<int>('ventas'),
        total: r.read<double>('total_ventas'),
      );
    }

    final result = <({PosSesione sesion, String? usuarioNombre, int ventas, double totalVentas})>[];
    for (final s in sesiones) {
      final r = resumenMap[s.id] ?? (ventas: 0, total: 0.0);
      final u = await (_db.select(_db.posUsuarios)
            ..where((t) => t.id.equals(s.usuarioId)))
          .getSingleOrNull();
      result.add((
        sesion: s,
        usuarioNombre: u?.nombre,
        ventas: r.ventas,
        totalVentas: r.total,
      ));
    }
    return result;
  }

  Future<void> _encolarSesion(int sesionId, String? syncUuid) async {
    final s = await (_db.select(_db.posSesiones)
          ..where((t) => t.id.equals(sesionId)))
        .getSingleOrNull();
    if (s == null) return;
    await addPending(_db,
        tableName: 'pos_sesiones',
        operation: 'upsert',
        data: {
          'sync_uuid': syncUuid ?? s.syncUuid,
          'usuario_id': s.usuarioId,
          'abierta_en': s.abiertaEn.toIso8601String(),
          'cerrada_en': s.cerradaEn?.toIso8601String(),
          'caja_inicial': s.cajaInicial,
          'caja_final': s.cajaFinal,
          'created_at': s.createdAt?.toIso8601String() ?? s.abiertaEn.toIso8601String(),
          'updated_at':
              s.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        });
  }

  // ---------------------------------------------------------------------
  // Usuarios (PIN)
  // ---------------------------------------------------------------------

  Future<List<PosUsuario>> getUsuarios({bool soloActivos = true}) {
    final q = _db.select(_db.posUsuarios)
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    if (soloActivos) q.where((t) => t.activo.equals(1));
    return q.get();
  }

  Future<PosUsuario?> getUsuario(int usuarioId) =>
      (_db.select(_db.posUsuarios)..where((t) => t.id.equals(usuarioId)))
          .getSingleOrNull();

  Future<int> crearUsuario(String nombre,
      {String? pin, bool esAdmin = false}) async {
    final id = await _db.into(_db.posUsuarios).insert(
          PosUsuariosCompanion.insert(
            nombre: nombre.trim(),
            pinHash: Value(pin != null && pin.trim().isNotEmpty
                ? _pinHash(pin)
                : null),
            esAdmin: Value(esAdmin ? 1 : 0),
            activo: const Value(1),
            creadoEn: DateTime.now(),
          ),
        );
    await addPending(_db,
        tableName: 'pos_usuarios',
        operation: 'insert',
        data: {
          'id': id,
          'nombre': nombre.trim(),
          'pin_hash': pin != null && pin.trim().isNotEmpty ? _pinHash(pin) : null,
          'es_admin': esAdmin,
          'activo': true,
          'creado_en': DateTime.now().toIso8601String(),
        });
    return id;
  }

  Future<void> actualizarUsuario(
    int usuarioId, {
    String? nombre,
    String? pin,
    bool? esAdmin,
    bool? activo,
  }) async {
    final actual = await (_db.select(_db.posUsuarios)
          ..where((t) => t.id.equals(usuarioId)))
        .getSingleOrNull();
    if (actual == null) return;
    await (_db.update(_db.posUsuarios)..where((t) => t.id.equals(usuarioId)))
        .write(PosUsuariosCompanion(
          nombre: Value(nombre?.trim() ?? actual.nombre),
          pinHash: Value(pin == null
              ? actual.pinHash
              : pin.isEmpty
                  ? null
                  : _pinHash(pin)),
          esAdmin: Value(esAdmin == null ? actual.esAdmin : esAdmin ? 1 : 0),
          activo: Value(activo == null ? actual.activo : activo ? 1 : 0),
        ));
    await addPending(_db,
        tableName: 'pos_usuarios',
        operation: 'update',
        data: {
          'id': usuarioId,
          if (nombre != null) 'nombre': nombre.trim(),
          if (pin != null)
            'pin_hash': pin.isEmpty ? null : _pinHash(pin),
          if (esAdmin != null) 'es_admin': esAdmin,
          if (activo != null) 'activo': activo,
        });
  }

  Future<void> eliminarUsuario(int usuarioId) async {
    await (_db.delete(_db.posUsuarios)..where((t) => t.id.equals(usuarioId)))
        .go();
    await addPending(_db,
        tableName: 'pos_usuarios',
        operation: 'delete',
        data: {'id': usuarioId});
  }

  Future<bool> verificarPin(int usuarioId, String pin) async {
    final u = await (_db.select(_db.posUsuarios)
          ..where((t) => t.id.equals(usuarioId)))
        .getSingleOrNull();
    if (u == null || u.pinHash == null || u.pinHash!.isEmpty) return false;
    return u.pinHash == _pinHash(pin);
  }

  // ---------------------------------------------------------------------
  // Mesas
  // ---------------------------------------------------------------------

  Future<List<PosMesa>> getMesas({bool soloActivos = false}) {
    final q = _db.select(_db.posMesas)
      ..orderBy([
        (t) => OrderingTerm.asc(t.zona),
        (t) => OrderingTerm.asc(t.numero),
      ]);
    if (soloActivos) q.where((t) => t.activo.equals(1));
    return q.get();
  }

  Future<PosMesa?> getMesaById(int mesaId) =>
      (_db.select(_db.posMesas)..where((t) => t.id.equals(mesaId)))
          .getSingleOrNull();

  Future<int> crearMesa(String numero, {String? nombre, String? zona}) async {
    final id = await _db.into(_db.posMesas).insert(
          PosMesasCompanion.insert(
            numero: numero.trim(),
            nombre: Value(nombre?.trim()),
            zona: Value(zona?.trim()),
            activo: const Value(1),
            creadoEn: DateTime.now(),
          ),
        );
    await addPending(_db,
        tableName: 'pos_mesas',
        operation: 'insert',
        data: {
          'id': id,
          'numero': numero.trim(),
          'nombre': nombre?.trim(),
          'zona': zona?.trim(),
          'activo': true,
          'creado_en': DateTime.now().toIso8601String(),
        });
    return id;
  }

  Future<void> actualizarMesa(int mesaId,
      {String? numero, String? nombre, String? zona, bool? activo}) async {
    final actual = await (_db.select(_db.posMesas)
          ..where((t) => t.id.equals(mesaId)))
        .getSingleOrNull();
    if (actual == null) return;
    await (_db.update(_db.posMesas)..where((t) => t.id.equals(mesaId)))
        .write(PosMesasCompanion(
          numero: Value(numero?.trim() ?? actual.numero),
          nombre: Value(nombre?.trim() ?? actual.nombre),
          zona: Value(zona?.trim() ?? actual.zona),
          activo: Value(activo == null ? actual.activo : activo ? 1 : 0),
        ));
    await addPending(_db,
        tableName: 'pos_mesas',
        operation: 'update',
        data: {
          'id': mesaId,
          if (numero != null) 'numero': numero.trim(),
          if (nombre != null) 'nombre': nombre.trim(),
          if (zona != null) 'zona': zona.trim(),
          if (activo != null) 'activo': activo,
        });
  }

  Future<void> eliminarMesa(int mesaId) async {
    await (_db.delete(_db.posMesas)..where((t) => t.id.equals(mesaId))).go();
    await addPending(_db,
        tableName: 'pos_mesas', operation: 'delete', data: {'id': mesaId});
  }

  // ---------------------------------------------------------------------
  // Habitaciones
  // ---------------------------------------------------------------------

  Future<List<PosHabitacione>> getHabitaciones({bool soloActivos = false}) {
    final q = _db.select(_db.posHabitaciones)
      ..orderBy([(t) => OrderingTerm.asc(t.numero)]);
    if (soloActivos) q.where((t) => t.activo.equals(1));
    return q.get();
  }

  Future<PosHabitacione?> getHabitacionById(int habId) =>
      (_db.select(_db.posHabitaciones)..where((t) => t.id.equals(habId)))
          .getSingleOrNull();

  Future<int> crearHabitacion(String numero,
      {String? piso, String? tipo}) async {
    final id = await _db.into(_db.posHabitaciones).insert(
          PosHabitacionesCompanion.insert(
            numero: numero.trim(),
            piso: Value(piso?.trim()),
            tipo: Value(tipo?.trim()),
            activo: const Value(1),
            creadoEn: DateTime.now(),
          ),
        );
    await addPending(_db,
        tableName: 'pos_habitaciones',
        operation: 'insert',
        data: {
          'id': id,
          'numero': numero.trim(),
          'piso': piso?.trim(),
          'tipo': tipo?.trim(),
          'activo': true,
          'creado_en': DateTime.now().toIso8601String(),
        });
    return id;
  }

  Future<void> actualizarHabitacion(int habId,
      {String? numero, String? piso, String? tipo, bool? activo}) async {
    final actual = await (_db.select(_db.posHabitaciones)
          ..where((t) => t.id.equals(habId)))
        .getSingleOrNull();
    if (actual == null) return;
    await (_db.update(_db.posHabitaciones)..where((t) => t.id.equals(habId)))
        .write(PosHabitacionesCompanion(
          numero: Value(numero?.trim() ?? actual.numero),
          piso: Value(piso?.trim() ?? actual.piso),
          tipo: Value(tipo?.trim() ?? actual.tipo),
          activo: Value(activo == null ? actual.activo : activo ? 1 : 0),
        ));
    await addPending(_db,
        tableName: 'pos_habitaciones',
        operation: 'update',
        data: {
          'id': habId,
          if (numero != null) 'numero': numero.trim(),
          if (piso != null) 'piso': piso.trim(),
          if (tipo != null) 'tipo': tipo.trim(),
          if (activo != null) 'activo': activo,
        });
  }

  Future<void> eliminarHabitacion(int habId) async {
    await (_db.delete(_db.posHabitaciones)..where((t) => t.id.equals(habId)))
        .go();
    await addPending(_db,
        tableName: 'pos_habitaciones',
        operation: 'delete',
        data: {'id': habId});
  }

  // ---------------------------------------------------------------------
  // Categorías POS (pos_categorias)
  // ---------------------------------------------------------------------

  Future<List<PosCategoria>> getPosCategorias({bool soloActivas = false}) {
    final q = _db.select(_db.posCategorias)
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    if (soloActivas) q.where((t) => t.activo.equals(1));
    return q.get();
  }

  Future<int> crearPosCategoria(String nombre,
      {String color = '#FF6F00', String? icono}) async {
    final now = DateTime.now();
    final id = await _db.into(_db.posCategorias).insert(
          PosCategoriasCompanion.insert(
            nombre: nombre.trim(),
            color: Value(color),
            icono: Value(icono),
            activo: const Value(1),
            syncUuid: Value(_uuid.v4()),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    await addPending(_db,
        tableName: 'pos_categorias',
        operation: 'insert',
        data: {
          'id': id,
          'nombre': nombre.trim(),
          'color': color,
          'icono': icono,
          'activo': true,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });
    return id;
  }

  Future<void> actualizarPosCategoria(int catId, String nombre,
      {String? color, String? icono, bool? activo}) async {
    final now = DateTime.now();
    final actual = await (_db.select(_db.posCategorias)
          ..where((t) => t.id.equals(catId)))
        .getSingleOrNull();
    if (actual == null) return;
    await (_db.update(_db.posCategorias)..where((t) => t.id.equals(catId)))
        .write(PosCategoriasCompanion(
          nombre: Value(nombre.trim()),
          color: Value(color ?? actual.color),
          icono: Value(icono ?? actual.icono),
          activo: Value(activo == null ? actual.activo : activo ? 1 : 0),
          updatedAt: Value(now),
        ));
    await addPending(_db,
        tableName: 'pos_categorias',
        operation: 'update',
        data: {
          'id': catId,
          'nombre': nombre.trim(),
          'color': color,
          'icono': icono,
          if (activo != null) 'activo': activo,
          'updated_at': now.toIso8601String(),
        });
  }

  Future<void> eliminarPosCategoria(int catId) async {
    await (_db.delete(_db.posCategorias)..where((t) => t.id.equals(catId)))
        .go();
    await addPending(_db,
        tableName: 'pos_categorias', operation: 'delete', data: {'id': catId});
  }

  // ---------------------------------------------------------------------
  // Sub-categorías (platos_categorias)
  // ---------------------------------------------------------------------

  Future<List<PlatosCategoria>> getPlatosCategorias(
      {bool soloActivas = false}) {
    final q = _db.select(_db.platosCategorias)
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    if (soloActivas) q.where((t) => t.activo.equals(1));
    return q.get();
  }

  Future<int> guardarPlatoCategoria(
    String nombre, {
    int? id,
    String color = '#FF6F00',
    bool activo = true,
    int? categoriaPadreId,
    int? posCategoriaPadreId,
  }) async {
    final now = DateTime.now();
    final nuevoId = id ??
        await _db.into(_db.platosCategorias).insert(
              PlatosCategoriasCompanion.insert(
                nombre: nombre.trim(),
                color: Value(color),
                activo: Value(activo ? 1 : 0),
                categoriaPadreId: Value(categoriaPadreId),
                posCategoriaPadreId: Value(posCategoriaPadreId),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
    if (id != null) {
      await (_db.update(_db.platosCategorias)
            ..where((t) => t.id.equals(id)))
          .write(PlatosCategoriasCompanion(
        nombre: Value(nombre.trim()),
        color: Value(color),
        activo: Value(activo ? 1 : 0),
        categoriaPadreId: Value(categoriaPadreId),
        posCategoriaPadreId: Value(posCategoriaPadreId),
        updatedAt: Value(now),
      ));
    }
    await addPending(_db,
        tableName: 'platos_categorias',
        operation: 'update',
        data: {
          'id': nuevoId,
          'nombre': nombre.trim(),
          'color': color,
          'activo': activo,
          'categoria_padre_id': categoriaPadreId,
          'pos_categoria_padre_id': posCategoriaPadreId,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        });
    return nuevoId;
  }

  Future<void> eliminarPlatoCategoria(int catId) async {
    await (_db.delete(_db.platosCategorias)
          ..where((t) => t.id.equals(catId)))
        .go();
    await addPending(_db,
        tableName: 'platos_categorias',
        operation: 'delete',
        data: {'id': catId});
  }

  // ---------------------------------------------------------------------
  // Platos + ingredientes + contornos
  // ---------------------------------------------------------------------

  Future<List<Plato>> getPlatos({
    bool soloActivos = false,
    int? categoriaId,
    bool? esContorno,
  }) {
    final q = _db.select(_db.platos)
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    if (soloActivos) q.where((t) => t.activo.equals(1));
    if (categoriaId != null) q.where((t) => t.categoriaId.equals(categoriaId));
    if (esContorno != null) q.where((t) => t.esContorno.equals(esContorno ? 1 : 0));
    return q.get();
  }

  /// Platos activos que no son contornos, para la sección PLATOS del POS
  /// (port de `LocalReplica.get_platos_pos`).
  Future<List<Plato>> getPlatosPos() => getPlatos(soloActivos: true, esContorno: false);

  /// Contornos activos (platos con `es_contorno = 1`) para el POS
  /// (port de `LocalReplica.get_contornos_activos`).
  Future<List<Plato>> getContornosActivos() =>
      getPlatos(soloActivos: true, esContorno: true);

  /// Categorías de inventario visibles en el POS (activas + `visible_en_pos`)
  /// (port de `LocalReplica.get_categorias_pos`).
  Future<List<Categoria>> getCategoriasPos() {
    final q = _db.select(_db.categorias)
      ..where((t) => t.activo.equals(1) & t.visibleEnPos.equals(1))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return q.get();
  }

  /// Productos de venta activos (tipo `Productos para la venta`), opcional por
  /// categoría (port de `LocalReplica.get_productos_pos`).
  Future<List<Producto>> getProductosPos({int? categoriaId}) {
    final q = _db.select(_db.productos)
      ..where((t) => t.activo.equals(1) & t.tipo.equals('Productos para la venta'));
    if (categoriaId != null) q.where((t) => t.categoriaId.equals(categoriaId));
    q.orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    return q.get();
  }

  /// Sub-categorías (platos_categorias) hijas de una categoría de inventario o
  /// de una categoría POS (port de `get_subcategorias_by_*_padre`).
  Future<List<PlatosCategoria>> getSubcategorias({
    int? categoriaPadreId,
    int? posCategoriaPadreId,
  }) {
    final q = _db.select(_db.platosCategorias)
      ..where((t) => t.activo.equals(1))
      ..orderBy([(t) => OrderingTerm.asc(t.nombre)]);
    if (categoriaPadreId != null) {
      q.where((t) => t.categoriaPadreId.equals(categoriaPadreId));
    }
    if (posCategoriaPadreId != null) {
      q.where((t) => t.posCategoriaPadreId.equals(posCategoriaPadreId));
    }
    return q.get();
  }

  // ---------------------------------------------------------------------
  // Tasa de cambio (pos_settings: tasa_cambio / tasa_cambio_actualizada_en)
  // ---------------------------------------------------------------------

  Future<double> getTasaCambio() async {
    final v = await getSetting('tasa_cambio');
    return double.tryParse(v ?? '') ?? 0;
  }

  /// Stream reactivo de la tasa de cambio (emite ante cambios en pos_settings).
  Stream<double> watchTasaCambio() =>
      _db.select(_db.posSettings).watch().asyncMap((_) => getTasaCambio());

  Future<String> getTasaCambioFecha() async =>
      await getSetting('tasa_cambio_actualizada_en') ?? '';

  Future<void> setTasaCambio(double tasa, {bool sync = false}) async {
    await setSetting('tasa_cambio', tasa.toStringAsFixed(4), sync: sync);
    await setSetting('tasa_cambio_actualizada_en',
        DateTime.now().toIso8601String(), sync: sync);
  }

  Future<List<PlatoIngrediente>> getIngredientes(int platoId) =>
      (_db.select(_db.platoIngredientes)
            ..where((t) => t.platoId.equals(platoId)))
          .get();

  Future<List<PlatoContorno>> getContornos(int platoId) =>
      (_db.select(_db.platoContornos)..where((t) => t.platoId.equals(platoId)))
          .get();

  Future<int> crearPlato(
    String nombre, {
    required int categoriaId,
    double precioVenta = 0,
    bool esContorno = false,
    bool llevaContornos = false,
    List<({int productoId, double cantidad, String unidad})>? ingredientes,
    List<({int contornoId, int maxSeleccionar})>? contornos,
  }) async {
    final now = DateTime.now();
    final id = await _db.into(_db.platos).insert(
          PlatosCompanion.insert(
            nombre: nombre.trim(),
            categoriaId: categoriaId,
            precioVenta: Value(precioVenta),
            activo: const Value(1),
            esContorno: Value(esContorno ? 1 : 0),
            llevaContornos: Value(llevaContornos ? 1 : 0),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );
    await _reemplazarRelaciones(id, ingredientes: ingredientes, contornos: contornos);
    await _encolarPlato(id);
    return id;
  }

  Future<void> actualizarPlato(
    int platoId, {
    String? nombre,
    int? categoriaId,
    double? precioVenta,
    bool? activo,
    bool? esContorno,
    bool? llevaContornos,
    List<({int productoId, double cantidad, String unidad})>? ingredientes,
    List<({int contornoId, int maxSeleccionar})>? contornos,
  }) async {
    final actual = await (_db.select(_db.platos)
          ..where((t) => t.id.equals(platoId)))
        .getSingleOrNull();
    if (actual == null) return;
    await (_db.update(_db.platos)..where((t) => t.id.equals(platoId)))
        .write(PlatosCompanion(
          nombre: Value(nombre?.trim() ?? actual.nombre),
          categoriaId: Value(categoriaId ?? actual.categoriaId),
          precioVenta: Value(precioVenta ?? actual.precioVenta),
          activo: Value(activo == null ? actual.activo : activo ? 1 : 0),
          esContorno:
              Value(esContorno == null ? actual.esContorno : esContorno ? 1 : 0),
          llevaContornos: Value(
              llevaContornos == null ? actual.llevaContornos : llevaContornos ? 1 : 0),
          updatedAt: Value(DateTime.now()),
        ));
    if (ingredientes != null || contornos != null) {
      await _reemplazarRelaciones(platoId,
          ingredientes: ingredientes, contornos: contornos);
    }
    await _encolarPlato(platoId);
  }

  Future<void> _reemplazarRelaciones(
    int platoId, {
    List<({int productoId, double cantidad, String unidad})>? ingredientes,
    List<({int contornoId, int maxSeleccionar})>? contornos,
  }) async {
    if (ingredientes != null) {
      await (_db.delete(_db.platoIngredientes)
            ..where((t) => t.platoId.equals(platoId)))
          .go();
      for (final ing in ingredientes) {
        final iid = await _db.into(_db.platoIngredientes).insert(
              PlatoIngredientesCompanion.insert(
                platoId: platoId,
                productoId: ing.productoId,
                cantidad: ing.cantidad,
                unidad: Value(ing.unidad),
              ),
            );
        await addPending(_db,
            tableName: 'plato_ingredientes',
            operation: 'insert',
            data: {
              'id': iid,
              'plato_id': platoId,
              'producto_id': ing.productoId,
              'cantidad': ing.cantidad,
              'unidad': ing.unidad,
            });
      }
    }
    if (contornos != null) {
      await (_db.delete(_db.platoContornos)
            ..where((t) => t.platoId.equals(platoId)))
          .go();
      for (final c in contornos) {
        await _db.into(_db.platoContornos).insert(
              PlatoContornosCompanion.insert(
                platoId: platoId,
                contornoId: c.contornoId,
                maxSeleccionar: Value(c.maxSeleccionar),
              ),
            );
      }
    }
  }

  Future<void> _encolarPlato(int platoId) async {
    final p = await (_db.select(_db.platos)..where((t) => t.id.equals(platoId)))
        .getSingleOrNull();
    if (p == null) return;
    await addPending(_db,
        tableName: 'platos',
        operation: 'upsert',
        data: {
          'id': p.id,
          'nombre': p.nombre,
          'categoria_id': p.categoriaId,
          'precio_venta': p.precioVenta,
          'activo': p.activo == 1,
          'es_contorno': p.esContorno == 1,
          'lleva_contornos': p.llevaContornos == 1,
          'created_at': p.createdAt?.toIso8601String(),
          'updated_at':
              p.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        });
  }

  Future<void> eliminarPlato(int platoId) async {
    await (_db.delete(_db.platoIngredientes)
          ..where((t) => t.platoId.equals(platoId)))
        .go();
    await (_db.delete(_db.platoContornos)..where((t) => t.platoId.equals(platoId)))
        .go();
    await (_db.delete(_db.platos)..where((t) => t.id.equals(platoId))).go();
    await addPending(_db,
        tableName: 'platos', operation: 'delete', data: {'id': platoId});
  }
}
