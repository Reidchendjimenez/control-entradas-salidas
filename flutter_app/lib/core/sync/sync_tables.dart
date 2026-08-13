/// Descriptor de una tabla sincronizada: nombre en Supabase y en drift,
/// clave natural para dedupe (ej: `nombre` en categorias, `codigo` en productos).
class SyncTableDescriptor {
  final String serverTable;
  final String localTable;
  final String dedupeKey;

  const SyncTableDescriptor({
    required this.serverTable,
    required this.localTable,
    this.dedupeKey = '',
  });
}

/// Mapeo de las 15 tablas sincronizadas (sync.py `tables_to_sync`).
///
/// El orden importa: se insertan por FK (proveedores antes que productos,
/// facturas antes que movimientos, etc.) en la descarga masiva.
const List<SyncTableDescriptor> syncedTables = [
  SyncTableDescriptor(serverTable: 'categorias', localTable: 'categorias', dedupeKey: 'nombre'),
  SyncTableDescriptor(serverTable: 'productos', localTable: 'productos', dedupeKey: 'codigo'),
  SyncTableDescriptor(serverTable: 'proveedores', localTable: 'proveedores', dedupeKey: 'nombre'),
  SyncTableDescriptor(serverTable: 'existencias', localTable: 'existencias'),
  SyncTableDescriptor(serverTable: 'stock_checkpoint', localTable: 'stock_checkpoint', dedupeKey: 'producto_id'),
  SyncTableDescriptor(serverTable: 'periodos', localTable: 'periodos'),
  SyncTableDescriptor(serverTable: 'facturas', localTable: 'facturas', dedupeKey: 'numero_factura'),
  SyncTableDescriptor(serverTable: 'factura_pagos', localTable: 'factura_pagos'),
  SyncTableDescriptor(serverTable: 'requisiciones', localTable: 'requisiciones', dedupeKey: 'numero'),
  SyncTableDescriptor(serverTable: 'requisicion_detalles', localTable: 'requisicion_detalles'),
  SyncTableDescriptor(serverTable: 'recetas', localTable: 'recetas'),
  SyncTableDescriptor(serverTable: 'receta_componentes', localTable: 'receta_componentes'),
  SyncTableDescriptor(serverTable: 'producciones', localTable: 'producciones'),
  SyncTableDescriptor(serverTable: 'produccion_detalles', localTable: 'produccion_detalles'),
  SyncTableDescriptor(serverTable: 'movimientos', localTable: 'movimientos'),
  SyncTableDescriptor(serverTable: 'movimientos_archivo', localTable: 'movimientos_archivo'),
];