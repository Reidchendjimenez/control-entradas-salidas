/// Descriptor de una tabla sincronizada: nombre en Supabase y en drift,
/// clave natural para dedupe (ej: `nombre` en categorias, `codigo` en productos).
class SyncTableDescriptor {
  final String serverTable;
  final String localTable;
  final String dedupeKey;

  /// Columna de cambio para la descarga incremental. Si es no nula y la tabla
  /// ya sincronizó alguna vez, se consulta `col >= last_sync` en vez de
  /// descargar la tabla completa (reduce egress de Supabase).
  ///
  /// Solo para tablas cuyos ids locales quedan alineados con los del server
  /// (catálogo re-mapeado al subir, o tablas solo-descarga): si el id local
  /// no coincidiera, re-descargar la fila propia crearía un duplicado.
  final String? incrementalColumn;

  /// Columna id para descarga incremental por `id > MAX(id) local`. Solo es
  /// válida en tablas de solo-descarga (nunca creadas localmente), donde los
  /// ids locales SIEMPRE son los del server (SERIAL monotónico). Para tablas
  /// creadas/insertadas localmente con id asignado por el server, el id local
  /// diverge y este criterio dejaría de ver filas nuevas.
  final String? incrementalById;

  const SyncTableDescriptor({
    required this.serverTable,
    required this.localTable,
    this.dedupeKey = '',
    this.incrementalColumn,
    this.incrementalById,
  });
}

/// Mapeo de las 15 tablas sincronizadas (sync.py `tables_to_sync`).
///
/// El orden importa: se insertan por FK (proveedores antes que productos,
/// facturas antes que movimientos, etc.) en la descarga masiva.
///
/// Estrategia de egress (cuota Supabase superada: full-download cada ciclo):
/// - `updated_at` (o `actualizada`): incremental por timestamp — solo filas
///   tocadas después del último sync. Seguro en catálogo (ids re-mapeados).
/// - `created_at`: incremental por timestamp en `movimientos` (append-only);
///   los ids locales se alinean con los del server al subir, así que la
///   re-descarga no duplica.
/// - `incrementalById`: tablas SOLO-descarga (existencias, requisicion_detalles,
///   periodos, movimientos_archivo): se baja `id > MAX(id)` local. Los ids
///   locales siempre coinciden con los del server, así que es seguro y barato.
/// - Sin incremental: tablas creadas localmente sin alineación de id
///   (proveedores, factura_pagos, receta_componentes, producciones,
///   produccion_detalles) o sin columna de cambio (stock_checkpoint). Son
///   pequeñas; el coste por ciclo es bajo.
const List<SyncTableDescriptor> syncedTables = [
  SyncTableDescriptor(serverTable: 'categorias', localTable: 'categorias', dedupeKey: 'nombre', incrementalColumn: 'updated_at'),
  SyncTableDescriptor(serverTable: 'productos', localTable: 'productos', dedupeKey: 'codigo', incrementalColumn: 'updated_at'),
  SyncTableDescriptor(serverTable: 'proveedores', localTable: 'proveedores', dedupeKey: 'nombre'),
  SyncTableDescriptor(serverTable: 'existencias', localTable: 'existencias', incrementalById: 'id'),
  SyncTableDescriptor(serverTable: 'stock_checkpoint', localTable: 'stock_checkpoint', dedupeKey: 'producto_id'),
  SyncTableDescriptor(serverTable: 'periodos', localTable: 'periodos', incrementalById: 'id'),
  SyncTableDescriptor(serverTable: 'facturas', localTable: 'facturas', dedupeKey: 'numero_factura', incrementalColumn: 'updated_at'),
  SyncTableDescriptor(serverTable: 'factura_pagos', localTable: 'factura_pagos'),
  SyncTableDescriptor(serverTable: 'requisiciones', localTable: 'requisiciones', dedupeKey: 'numero', incrementalColumn: 'actualizada'),
  SyncTableDescriptor(serverTable: 'requisicion_detalles', localTable: 'requisicion_detalles', incrementalById: 'id'),
  SyncTableDescriptor(serverTable: 'recetas', localTable: 'recetas', incrementalColumn: 'updated_at'),
  SyncTableDescriptor(serverTable: 'receta_componentes', localTable: 'receta_componentes'),
  SyncTableDescriptor(serverTable: 'producciones', localTable: 'producciones'),
  SyncTableDescriptor(serverTable: 'produccion_detalles', localTable: 'produccion_detalles'),
  SyncTableDescriptor(serverTable: 'movimientos', localTable: 'movimientos', incrementalColumn: 'created_at'),
  SyncTableDescriptor(serverTable: 'movimientos_archivo', localTable: 'movimientos_archivo', incrementalById: 'id'),
];
