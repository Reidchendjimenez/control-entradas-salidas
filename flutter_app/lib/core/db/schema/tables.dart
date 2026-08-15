import 'package:drift/drift.dart';

/// Definiciones de tablas — réplica de `usr/database/local_replica.py`.
///
/// Cada tabla replica columnas con los mismos nombres que Supabase para que la
/// sincronización haga upsert 1:1 (ver `sync.py` `tables_to_sync`). Tipos:
/// INTEGER���bool (0/1), REAL para cantidades, TEXT para fechas ISO.
///
/// Nota: drift genera automáticamente el campo `id` de las tablas con
/// `integer().autoIncrement()`. Los upsert usan `REPLACE` vía `insertOnConflictUpdate`.

class Categorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 100).unique()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get imagen => text().nullable()();
  TextColumn get color => text().withDefault(const Constant('#2196F3'))();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  IntColumn get visibleEnPos => integer().named('visible_en_pos').withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Productos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 200)();
  TextColumn get codigo => text().withLength(max: 50).unique().nullable()();
  TextColumn get descripcion => text().nullable()();
  IntColumn get categoriaId => integer().named('categoria_id').nullable()();
  IntColumn get esPesable => integer().named('es_pesable').withDefault(const Constant(0))();
  IntColumn get requiereFotoPeso => integer().named('requiere_foto_peso').withDefault(const Constant(0))();
  RealColumn get pesoUnitario => real().named('peso_unitario').nullable()();
  RealColumn get precioVenta => real().named('precio_venta').withDefault(const Constant(0))();
  TextColumn get unidadMedida => text().named('unidad_medida').withDefault(const Constant('unidad'))();
  RealColumn get stockActual => real().named('stock_actual').withDefault(const Constant(0))();
  RealColumn get stockMinimo => real().named('stock_minimo').withDefault(const Constant(0))();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  TextColumn get tipo => text().withDefault(const Constant('ninguno'))();
  TextColumn get almacenPredeterminado => text().named('almacen_predeterminado').withDefault(const Constant('principal'))();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Proveedores extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 200).unique()();
  TextColumn get rif => text().withLength(max: 50).nullable()();
  TextColumn get telefono => text().withLength(max: 50).nullable()();
  TextColumn get email => text().withLength(max: 100).nullable()();
  TextColumn get direccion => text().nullable()();
  TextColumn get contacto => text().withLength(max: 100).nullable()();
  TextColumn get observaciones => text().nullable()();
  TextColumn get estado => text().withDefault(const Constant('Activo'))();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Existencias extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productoId => integer().named('producto_id').nullable()();
  TextColumn get almacen => text()();
  RealColumn get cantidad => real().withDefault(const Constant(0))();
  TextColumn get unidad => text().withDefault(const Constant('unidad'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Movimientos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productoId => integer().named('producto_id')();
  IntColumn get facturaId => integer().named('factura_id').nullable()();
  IntColumn get requisicionId => integer().named('requisicion_id').nullable()();
  IntColumn get ventaId => integer().named('venta_id').nullable()();
  TextColumn get ventaSyncUuid => text().named('venta_sync_uuid').nullable()();
  TextColumn get tipo => text().withLength(max: 30)();
  RealColumn get cantidad => real()();
  RealColumn get cantidadAnterior => real().named('cantidad_anterior').withDefault(const Constant(0))();
  RealColumn get cantidadNueva => real().named('cantidad_nueva').withDefault(const Constant(0))();
  RealColumn get pesoTotal => real().named('peso_total').withDefault(const Constant(0))();
  TextColumn get registradoPor => text().named('registrado_por').nullable()();
  TextColumn get observaciones => text().nullable()();
  TextColumn get almacen => text().nullable()();
  DateTimeColumn get fechaMovimiento => dateTime().named('fecha_movimiento').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  IntColumn get sincronizado => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class MovimientosArchivo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productoId => integer().named('producto_id')();
  IntColumn get facturaId => integer().named('factura_id').nullable()();
  IntColumn get requisicionId => integer().named('requisicion_id').nullable()();
  TextColumn get tipo => text().withLength(max: 30)();
  RealColumn get cantidad => real()();
  RealColumn get cantidadAnterior => real().named('cantidad_anterior').withDefault(const Constant(0))();
  RealColumn get cantidadNueva => real().named('cantidad_nueva').withDefault(const Constant(0))();
  RealColumn get pesoTotal => real().named('peso_total').withDefault(const Constant(0))();
  TextColumn get registradoPor => text().named('registrado_por').nullable()();
  TextColumn get observaciones => text().nullable()();
  TextColumn get almacen => text().nullable()();
  DateTimeColumn get fechaMovimiento => dateTime().named('fecha_movimiento').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Facturas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numeroFactura => text().named('numero_factura').withLength(max: 50).nullable()();
  TextColumn get tipoDocumento => text().named('tipo_documento').withDefault(const Constant('Factura'))();
  TextColumn get proveedor => text().withLength(max: 200).nullable()();
  DateTimeColumn get fechaFactura => dateTime().named('fecha_factura').nullable()();
  DateTimeColumn get fechaRecepcion => dateTime().named('fecha_recepcion').nullable()();
  RealColumn get totalBruto => real().named('total_bruto').withDefault(const Constant(0))();
  RealColumn get totalImpuestos => real().named('total_impuestos').withDefault(const Constant(0))();
  RealColumn get totalNeto => real().named('total_neto').withDefault(const Constant(0))();
  TextColumn get estado => text().withDefault(const Constant('Pendiente'))();
  TextColumn get observaciones => text().nullable()();
  TextColumn get validadaPor => text().named('validada_por').nullable()();
  DateTimeColumn get fechaValidacion => dateTime().named('fecha_validacion').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class FacturaPagos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get facturaId => integer().named('factura_id')();
  TextColumn get tipoPago => text().named('tipo_pago').withLength(max: 50)();
  RealColumn get monto => real()();
  TextColumn get referencia => text().withLength(max: 100).nullable()();
  RealColumn get tasaCambio => real().named('tasa_cambio').nullable()();
  DateTimeColumn get fechaPago => dateTime().named('fecha_pago').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Requisiciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numero => text().withLength(max: 50).unique()();
  IntColumn get numeroSecuencial => integer().named('numero_secuencial')();
  TextColumn get origen => text().withLength(max: 50)();
  TextColumn get destino => text().withLength(max: 50)();
  TextColumn get estado => text().withDefault(const Constant('pendiente'))();
  TextColumn get observaciones => text().nullable()();
  TextColumn get creadaPor => text().named('creada_por').nullable()();
  TextColumn get procesadaPor => text().named('procesada_por').nullable()();
  DateTimeColumn get fechaProcesamiento => dateTime().named('fecha_procesamiento').nullable()();
  DateTimeColumn get fechaCreacion => dateTime().named('fecha_creacion').nullable()();
  DateTimeColumn get actualizada => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RequisicionDetalles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get requisicionId => integer().named('requisicion_id')();
  IntColumn get productoId => integer().named('producto_id').nullable()();
  TextColumn get ingrediente => text().withLength(max: 200)();
  RealColumn get cantidad => real()();
  TextColumn get unidad => text().withDefault(const Constant('unidad'))();
  RealColumn get cantidadSurtida => real().named('cantidad_surtida').withDefault(const Constant(0))();
  IntColumn get verificado => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class StockCheckpoint extends Table {
  IntColumn get productoId => integer().named('producto_id')();
  TextColumn get almacen => text()();
  RealColumn get cantidad => real().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {productoId, almacen};
}

class Periodos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get periodo => text().unique()();
  TextColumn get fechaApertura => text().named('fecha_apertura')();
  TextColumn get registradoPor => text().named('registrado_por').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Recetas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text().withLength(min: 1, max: 200)();
  TextColumn get tipo => text().withLength(max: 20)();
  IntColumn get productoBaseId => integer().named('producto_base_id').nullable()();
  IntColumn get productoFinalId => integer().named('producto_final_id').nullable()();
  RealColumn get cantidadProducida => real().named('cantidad_producida').withDefault(const Constant(1))();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RecetaComponentes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recetaId => integer().named('receta_id')();
  IntColumn get productoId => integer().named('producto_id')();
  RealColumn get cantidad => real()();
  TextColumn get unidad => text().withDefault(const Constant('unidad'))();
  TextColumn get tipoComponente => text().named('tipo_componente').withLength(max: 20)();
  IntColumn get pesoVariable => integer().named('peso_variable').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Producciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recetaId => integer().named('receta_id')();
  RealColumn get cantidad => real()();
  TextColumn get estado => text().withDefault(const Constant('completado'))();
  TextColumn get usuario => text().nullable()();
  TextColumn get observaciones => text().nullable()();
  DateTimeColumn get fechaProduccion => dateTime().named('fecha_produccion').nullable()();
  TextColumn get cocineros => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ProduccionDetalles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get produccionId => integer().named('produccion_id')();
  IntColumn get productoId => integer().named('producto_id')();
  TextColumn get tipo => text().withLength(max: 10)();
  RealColumn get cantidad => real()();
  TextColumn get unidad => text().withDefault(const Constant('unidad'))();
  IntColumn get movimientoId => integer().named('movimiento_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ComprasLista extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get productoId => integer().named('producto_id')();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetTable => text().named('table_name')();
  TextColumn get operation => text()();
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  IntColumn get retries => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().named('last_error').nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncMetadata extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

class DispositivoUsuario extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get pinHash => text().named('pin_hash').nullable()();
  DateTimeColumn get configuradoEn => dateTime().named('configurado_en')();

  @override
  Set<Column> get primaryKey => {id};
}

/// Cola local de mensajes de WhatsApp — réplica de
/// `usr/database/local_replica.py` (`whatsapp_queue`). Es solo local (outbox):
/// NO se sincroniza con Supabase; se envía por HTTP al bot.
class WhatsappQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tipo => text().withDefault(const Constant('text'))();
  TextColumn get mensaje => text().nullable()();
  TextColumn get imagenBase64 => text().named('imagen_base64').nullable()();
  TextColumn get imagenPath => text().named('imagen_path').nullable()();
  TextColumn get estado => text().withDefault(const Constant('pending'))();
  IntColumn get intentos => integer().withDefault(const Constant(0))();
  IntColumn get maxIntentos =>
      integer().named('max_intentos').withDefault(const Constant(10))();
  TextColumn get ultimoError => text().named('ultimo_error').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Imágenes temporales de la vista de Validación (solo local, NO se
/// sincronizan con Supabase). El usuario pre-carga una imagen, se extraen sus
/// datos por OCR, y al validar elige cuál usar (o pega una nueva). Se borran
/// al ser usadas o manualmente.
class Temporales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get imagenB64 => text().named('imagen_b64').nullable()();
  TextColumn get tipoDocumento => text().named('tipo_documento').nullable()();
  TextColumn get nroFactura => text().named('nro_factura').nullable()();
  TextColumn get proveedor => text().nullable()();
  RealColumn get monto => real().nullable()();
  DateTimeColumn get fecha => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column> get primaryKey => {id};
}

// ============================================================================
// MÓDULO POS — réplica de `usr/database/local_replica.py`. Estas tablas son
// locales; se sincronizan con Supabase por `sync_uuid` (no por id local), ver
// `usr/database/pos_sync.py` y el port en `lib/core/sync/pos_sync_engine.dart`.
// ============================================================================

class PosUsuarios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get pinHash => text().named('pin_hash').nullable()();
  IntColumn get esAdmin => integer().named('es_admin').withDefault(const Constant(0))();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  DateTimeColumn get creadoEn => dateTime().named('creado_en')();

  @override
  Set<Column> get primaryKey => {id};
}

class PosMesas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numero => text()();
  TextColumn get nombre => text().nullable()();
  TextColumn get zona => text().nullable()();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  DateTimeColumn get creadoEn => dateTime().named('creado_en')();

  @override
  Set<Column> get primaryKey => {id};
}

class PosHabitaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get numero => text()();
  TextColumn get piso => text().nullable()();
  TextColumn get tipo => text().nullable()();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  DateTimeColumn get creadoEn => dateTime().named('creado_en')();

  @override
  Set<Column> get primaryKey => {id};
}

class PosSesiones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get usuarioId => integer().named('usuario_id')();
  DateTimeColumn get abiertaEn => dateTime().named('abierta_en')();
  DateTimeColumn get cerradaEn => dateTime().named('cerrada_en').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PosComandas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sesionId => integer().named('sesion_id')();
  IntColumn get mesaId => integer().named('mesa_id').nullable()();
  IntColumn get habitacionId => integer().named('habitacion_id').nullable()();
  TextColumn get estado => text().withDefault(const Constant('abierta'))();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get itemsJson => text().named('items_json').nullable()();
  TextColumn get syncUuid => text().named('sync_uuid').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PosVentas extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get comandaId => integer().named('comanda_id').nullable()();
  IntColumn get correlativo => integer().nullable()();
  RealColumn get total => real().withDefault(const Constant(0))();
  TextColumn get itemsJson => text().named('items_json').nullable()();
  IntColumn get mesaId => integer().named('mesa_id').nullable()();
  IntColumn get habitacionId => integer().named('habitacion_id').nullable()();
  IntColumn get usuarioId => integer().named('usuario_id').nullable()();
  IntColumn get sesionId => integer().named('sesion_id').nullable()();
  TextColumn get estado => text().withDefault(const Constant('vigente'))();
  IntColumn get ventaAnulaId => integer().named('venta_anula_id').nullable()();
  TextColumn get motivoAnulacion => text().named('motivo_anulacion').nullable()();
  TextColumn get anuladaPor => text().named('anulada_por').nullable()();
  DateTimeColumn get anuladaEn => dateTime().named('anulada_en').nullable()();
  RealColumn get tasaBs => real().named('tasa_bs').nullable()();
  TextColumn get syncUuid => text().named('sync_uuid').nullable()();
  TextColumn get comandaSyncUuid => text().named('comanda_sync_uuid').nullable()();
  TextColumn get ventaAnulaSyncUuid => text().named('venta_anula_sync_uuid').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PosSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}

class PosCategorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get color => text().withDefault(const Constant('#FF6F00'))();
  TextColumn get icono => text().nullable()();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  TextColumn get syncUuid => text().named('sync_uuid').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PlatosCategorias extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get color => text().withDefault(const Constant('#FF6F00'))();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  IntColumn get categoriaPadreId => integer().named('categoria_padre_id').nullable()();
  IntColumn get posCategoriaPadreId => integer().named('pos_categoria_padre_id').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Platos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  IntColumn get categoriaId => integer().named('categoria_id')();
  RealColumn get precioVenta => real().named('precio_venta').withDefault(const Constant(0))();
  IntColumn get activo => integer().withDefault(const Constant(1))();
  IntColumn get esContorno => integer().named('es_contorno').withDefault(const Constant(0))();
  IntColumn get llevaContornos => integer().named('lleva_contornos').withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PlatoIngredientes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get platoId => integer().named('plato_id')();
  IntColumn get productoId => integer().named('producto_id')();
  RealColumn get cantidad => real()();
  TextColumn get unidad => text().withDefault(const Constant('unidad'))();

  @override
  Set<Column> get primaryKey => {id};
}

class PlatoContornos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get platoId => integer().named('plato_id')();
  IntColumn get contornoId => integer().named('contorno_id')();
  IntColumn get maxSeleccionar => integer().named('max_seleccionar').withDefault(const Constant(2))();

  @override
  Set<Column> get primaryKey => {id};
}

class PosSyncTombstones extends Table {
  TextColumn get uuid => text()();
  TextColumn get tabla => text().nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {uuid};
}