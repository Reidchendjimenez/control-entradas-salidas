# Graph Report - control-entradas-salidas  (2026-08-14)

## Corpus Check
- 266 files · ~322,459 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 4677 nodes · 9729 edges · 175 communities (150 shown, 25 thin omitted)
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 416 edges (avg confidence: 0.53)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `6d8095a3`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- requisiciones_view.py
- package:flutter/material.dart
- ConfigPOSView
- audit_view.dart
- receta_editor_screen.dart
- ConsumerState
- historial_facturas_view.py
- ComandaPedidoView
- get_db_adaptive
- producto_dialog.dart
- SyncQueue
- Historial de Cambios
- InventarioView
- show_error
- whatsapp_notifier.py
- drift_worker.js
- tables.dart
- models/__init__.py
- producciones/data.py
- POSSyncManager
- ajuste_auditoria_dialog.dart
- ControlEntradasSalidasApp
- database/__init__.py
- HistorialFacturasView
- printer.py
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/dialogs.py
- LoadingSplash
- VentasView
- AuditView
- configuracion_repository.dart
- comprobar_y_aplicar_actualizaciones
- RequisicionesView
- producciones_repository.dart
- app_database.dart
- LocalReplica
- a
- POSLoginView
- validacion_dialog.dart
- r
- package:flutter_riverpod/flutter_riverpod.dart
- c
- N
- main_pos.py
- aQ
- i
- _colors
- graphify reference: extra exports and benchmark
- DataClass
- 4. Módulos feature por feature
- .get_producto_by_id
- sync_engine.dart
- stock_screen.dart
- _NullStream
- a5
- my_application.cc
- requisiciones_repository.dart
- graphify reference: query, path, explain
- .save_componentes
- producciones_screen.dart
- descargo_dialog.dart
- O
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- periodos.py
- form_view.dart
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- tasa_cambio.py
- ka
- Table
- validacion_repository.dart
- pagos_panel.dart
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- AppDelegate
- graphify.js
- _get_storage_base
- AGENTS.md
- validacion_screen.dart
- stock_repository.dart
- por_fecha_tab.dart
- at
- win32_window.cpp
- FlutterWindow
- inventario_repository.dart
- receta_card.dart
- session_controller.dart
- ei
- Win32Window
- wWinMain
- bandeja_screen.dart
- proveedor_dialog.dart
- pos/__init__.py
- lycoris-control
- manifest.json
- $0
- ComandasView
- historial_repository.dart
- MessageHandler
- app_config.dart
- ProduccionesView
- log_bridge.dart
- whatsapp_repository.dart
- cantidad_dialog.dart
- Control de Entradas y Salidas — App Flutter
- RegisterPlugins
- MainActivity.kt
- LaunchImage.imageset/README.md
- Factura
- app_shell.dart
- base.py
- OCRHandler
- ja
- package:drift/drift.dart
- requisiciones_screen.dart
- ._download_all_from_server
- requisiciones/presentation/dialogs/historial_dialog.dart
- app_launcher.py
- facturas_tab.dart
- POSSyncIndicator
- app_theme.dart
- ._enqueue_venta
- show_error_with_copy
- WebServer
- categoria_card.dart
- exportar_dialog.dart
- PaymentsManager
- HabitacionesView
- MesasView
- factura_detalle_dialog.dart
- .aplicar_movimientos_venta
- get_colors
- app_database.dart
- .set_pos_setting
- login_screen.dart
- ValidacionDialog
- ._build_compras_lista_data
- ._go_to_main
- entrada_pendiente_card.dart
- entrada_card.dart
- .save_categorias
- .get_last_sync
- sync.py
- AppDatabase
- app_colors.dart
- .get_contornos_activos
- Producto
- String?

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 212 edges
2. `get_local_conn()` - 179 edges
3. `c()` - 108 edges
4. `a()` - 82 edges
5. `show_error()` - 73 edges
6. `j()` - 70 edges
7. `k()` - 69 edges
8. `get_db_adaptive()` - 69 edges
9. `show_success()` - 69 edges
10. `i()` - 68 edges

## Surprising Connections (you probably didn't know these)
- `_show_snackbar()` --references--> `icons`  [EXTRACTED]
  usr/notifications.py → flutter_app/web/manifest.json
- `main()` --calls--> `get_settings()`  [EXTRACTED]
  usr/app_launcher.py → config/config.py
- `_get_remote_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/archive.py → config/config.py
- `_sync_existencias_supabase_batch()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py
- `totalizar_requisicion()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py

## Import Cycles
- None detected.

## Communities (175 total, 25 thin omitted)

### Community 0 - "requisiciones_view.py"
Cohesion: 0.07
Nodes (47): Existencia, Base, build_detalle_row(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura. (+39 more)

### Community 1 - "package:flutter/material.dart"
Cohesion: 0.03
Nodes (80): ../data/producciones_providers.dart, ../../data/producciones_repository.dart, dialogs/cancelar_produccion_dialog.dart, dialogs/delete_receta_dialog.dart, dialogs/descargo_dialog.dart, dedupeKey, incrementalColumn, localTable (+72 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (11): Obtiene categorías POS independientes., Obtiene categorías visibles en el POS., get_sync_queue(), Obtiene instancia singleton de SyncQueue., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial. (+3 more)

### Community 3 - "audit_view.dart"
Cohesion: 0.03
Nodes (68): AuditView, class, ../../data/requisiciones_providers.dart, ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, requisicionesRepoProvider, _aceptar, _cargarProducto (+60 more)

### Community 4 - "receta_editor_screen.dart"
Cohesion: 0.05
Nodes (46): produccionesRepoProvider, productosActivosProvider, _cargar, _cargar, _agregarFilaVacia, _agregarProducto, _baseProducto, _baseSearchCtrl (+38 more)

### Community 5 - "ConsumerState"
Cohesion: 0.06
Nodes (34): Categoria?, ConsumerState, _activo, build, categoria, _CategoriaDialog, _CategoriaDialogState, _colorCtrl (+26 more)

### Community 6 - "historial_facturas_view.py"
Cohesion: 0.07
Nodes (23): Connection, Logger, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no…, Inicializa tablas decache (no sync)., set_cache() (+15 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.11
Nodes (3): ComandaPedidoView, Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "get_db_adaptive"
Cohesion: 0.08
Nodes (32): get_db_adaptive(), Generator que proporciona una sesión SQLite local., get_pending_movimientos_count(), Obtiene el número de movimientos pendientes de sincronización., get_productos_activos(), Obtiene todos los productos activos del inventario., _build_almacen_option(), build_historial_dialog() (+24 more)

### Community 9 - "producto_dialog.dart"
Cohesion: 0.02
Nodes (123): ColorScheme, configuracion_repository.dart, ../../../../core/state/theme_controller.dart, ../../../core/sync/sync_service.dart, dart:html, ../../data/configuracion_providers.dart, ../../data/configuracion_repository.dart, ../dialogs/categoria_dialog.dart (+115 more)

### Community 10 - "SyncQueue"
Cohesion: 0.15
Nodes (9): Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync. (+1 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.10
Nodes (6): create_categoria_card(), create_categoria_card_from_dict(), generar_color(), get_safe_colors(), create_producto_item_from_dict(), InventarioView

### Community 13 - "show_error"
Cohesion: 0.09
Nodes (41): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Page, Sistema centralizado de notificaciones para la aplicación. Proporciona… (+33 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "drift_worker.js"
Cohesion: 0.01
Nodes (70): bs(), cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), dl(), e4(), eR() (+62 more)

### Community 16 - "tables.dart"
Cohesion: 0.02
Nodes (102): DateTimeColumn get, activo, actualizada, almacen, almacenPredeterminado, cantidad, cantidadAnterior, cantidadNueva (+94 more)

### Community 17 - "models/__init__.py"
Cohesion: 0.07
Nodes (20): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, Base (+12 more)

### Community 18 - "producciones/data.py"
Cohesion: 0.13
Nodes (22): almacen_produccion_default(), ejecutar_descargo(), eliminar_receta(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones() (+14 more)

### Community 19 - "POSSyncManager"
Cohesion: 0.08
Nodes (12): Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync., Bulk upsert plato_ingredientes para sync., Bulk upsert plato_contornos para sync., Bulk upsert pos_mesas para sync. (+4 more)

### Community 20 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (30): double get, AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _calcularDesdeTotal (+22 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.07
Nodes (18): ControlEntradasSalidasApp, Page, Imprime en el log (solo si TRACE_SWITCH=1) un marcador con delta de tiempo para…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager. (+10 more)

### Community 22 - "database/__init__.py"
Cohesion: 0.15
Nodes (16): check_connection(), get_base(), get_connection_status(), get_local_db(), get_local_session(), get_session(), get_session_local(), Retorna el estado de conexión (solo para indicador). (+8 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "printer.py"
Cohesion: 0.06
Nodes (54): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., configurar_impresora(), _escpos_ticket(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers() (+46 more)

### Community 25 - "RecetaEditor"
Cohesion: 0.18
Nodes (4): Editor de receta en pantalla completa., Selector de producto con buscador (estilo sección de componentes). Muestra un…, Llama control.update() solo si el control ya está añadido a la página., RecetaEditor

### Community 26 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "SyncManager"
Cohesion: 0.06
Nodes (19): Obtiene movimientos que no han sido sincronizados., Obtiene facturas de la BD local., Tras subir una requisición local, actualiza su id local al id remoto para que…, Guarda timestamp del último sync., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str). (+11 more)

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (20): cancelar_produccion(), Revierte todas las entradas del lote y marca la producción como cancelada.…, cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente. (+12 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 32 - "AuditView"
Cohesion: 0.18
Nodes (3): AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 33 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (33): archivarEnSupabase, clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db (+25 more)

### Community 34 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.24
Nodes (11): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica., Lee UPDATE_URL. Prioridad: 1. Variable ya cargada en os.environ (config.config… (+3 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.06
Nodes (11): Base, Requisicion, RequisicionDetalle, build_empty_state(), load_requisiciones(), RequisicionService, Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista. (+3 more)

### Community 36 - "producciones_repository.dart"
Cohesion: 0.03
Nodes (59): almacen, almacenProduccionDefault, cancelarProduccion, cantidad, cantidadSugerida, cocineros, ComponenteInfo, contarComponentes (+51 more)

### Community 37 - "app_database.dart"
Cohesion: 0.01
Nodes (236): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends, class StockCheckpointData extends, class SyncMetadataData extends (+228 more)

### Community 38 - "LocalReplica"
Cohesion: 0.02
Nodes (62): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene todas las existencias de un producto (sumadas por almacén)., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene movimientos de la BD local (con numero de documento de la factura si… (+54 more)

### Community 39 - "a"
Cohesion: 0.05
Nodes (112): $1(), $2(), a(), a1(), a4(), a9(), aa(), aH() (+104 more)

### Community 41 - "validacion_dialog.dart"
Cohesion: 0.05
Nodes (39): proveedoresProvider, _aplicarPrefijo, build, createState, dispose, _escanearOcr, _extractOcrSpace, _facturaCtrl (+31 more)

### Community 42 - "r"
Cohesion: 0.04
Nodes (73): $3(), $5(), ac(), az(), b6(), bB(), bd(), bP() (+65 more)

### Community 43 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.02
Nodes (100): ajuste_dialog.dart, categoria_card.dart, ConsumerWidget, ../../../core/db/database_provider.dart, ../../../../core/db/schema/app_database.dart, ../../data/inventario_providers.dart, ../../data/inventario_repository.dart, ../data/stock_repository.dart (+92 more)

### Community 44 - "c"
Cohesion: 0.04
Nodes (63): a2(), aG(), aP(), aX(), aY(), ba(), bg(), bY() (+55 more)

### Community 45 - "N"
Cohesion: 0.08
Nodes (43): aM(), aV(), bf(), ce(), D(), d3(), d5(), eE() (+35 more)

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - "aQ"
Cohesion: 0.06
Nodes (47): a3(), ak(), an(), aQ(), b2(), b3(), b4(), b5() (+39 more)

### Community 48 - "i"
Cohesion: 0.09
Nodes (36): aB(), b0(), b8(), bI(), bj(), c5(), ch(), cT() (+28 more)

### Community 49 - "_colors"
Cohesion: 0.11
Nodes (27): Exception, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error(), _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog() (+19 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "DataClass"
Cohesion: 0.08
Nodes (44): Existencia, Insertable, Movimiento, RecetaComponente, RequisicionDetalle, UpdateCompanion, Categoria, ComprasListaCompanion (+36 more)

### Community 52 - "4. Módulos feature por feature"
Cohesion: 0.06
Nodes (31): 0. Inventario de lo que existe hoy (auditoría), 1. Arquitectura objetivo (Flutter), 2.1 Esquema, 2.2 Cliente Supabase, 2.3 Repositorios, 2. Capa de datos, 3. Motor de sincronización, 4.10 Updater (`updater.py`) (+23 more)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 54 - "sync_engine.dart"
Cohesion: 0.05
Nodes (38): ../config/app_config.dart, initialize, initializeSupabase, supabaseProvider, client, _db, def, _deleteMovimientoPorMatch (+30 more)

### Community 55 - "stock_screen.dart"
Cohesion: 0.05
Nodes (44): bool get, ../../data/stock_providers.dart, dialogs/existencias_dialog.dart, stockRepoProvider, _almacen, _almacenes, build, _buildFiltros (+36 more)

### Community 56 - "_NullStream"
Cohesion: 0.14
Nodes (8): _get_app_dir(), main(), _NullStream, Page, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path()

### Community 57 - "a5"
Cohesion: 0.06
Nodes (37): a0(), a5(), a6(), ai(), aO(), bx(), c1(), cV() (+29 more)

### Community 58 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, fl_register_plugins(), main(), first_frame_cb(), my_application_activate(), my_application_class_init(), my_application_dispose(), my_application_init() (+14 more)

### Community 59 - "requisiciones_repository.dart"
Cohesion: 0.05
Nodes (37): _aplicarMoverStock, AuditStock, buscarProductos, cantidad, contarDetalles, crearAjusteStock, _db, destino (+29 more)

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 62 - "producciones_screen.dart"
Cohesion: 0.05
Nodes (42): dialogs/exportar_dialog.dart, facturas_tab.dart, build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose, initState (+34 more)

### Community 63 - "descargo_dialog.dart"
Cohesion: 0.05
Nodes (40): ConsumerStatefulWidget, actualizar, _actualizarStock, _almacen, almacenDefault, almacenes, build, _buildItemRow (+32 more)

### Community 64 - "O"
Cohesion: 0.13
Nodes (16): $4(), au(), b1(), e0(), f2(), f3(), giI(), ha() (+8 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - "periodos.py"
Cohesion: 0.19
Nodes (20): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, _aperturar_periodo() (+12 more)

### Community 70 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 75 - "tasa_cambio.py"
Cohesion: 0.29
Nodes (9): _abrir_url(), obtener_tasa_bcv(), _obtener_tasa_fallback(), _obtener_tasa_sitio_oficial(), Tasa de cambio USD -> Bs (bolivares) oficial del BCV. La tasa oficial la…, Respaldo: consulta la tasa USD en la API de bcv.today., Descarga una URL con User-Agent real y reintento sin verificar SSL., Consulta la tasa oficial del BCV (Bs por USD) desde el sitio oficial. Lanza… (+1 more)

### Community 76 - "ka"
Cohesion: 0.16
Nodes (17): cw(), d1(), d2(), dr(), ds(), dY(), eX(), eY() (+9 more)

### Community 77 - "Table"
Cohesion: 0.09
Nodes (22): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+14 more)

### Community 78 - "validacion_repository.dart"
Cohesion: 0.06
Nodes (31): almacen, buscarProveedor, cantidad, crearProveedor, _db, eliminarEntrada, esPesable, facturaId (+23 more)

### Community 79 - "pagos_panel.dart"
Cohesion: 0.09
Nodes (22): _abrirPanel, _agregarBoton, _agregarPago, build, createState, dispose, _divisasMonto, _divisasTasa (+14 more)

### Community 83 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, AppDelegate, SceneDelegate, RunnerTests, FlutterAppDelegate, FlutterImplicitEngineBridge (+6 more)

### Community 85 - "_get_storage_base"
Cohesion: 0.14
Nodes (12): BaseSettings, _candidate_env_paths(), Config, Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Rutas candidatas para buscar .env en orden de prioridad., Settings, Path (+4 more)

### Community 87 - "validacion_screen.dart"
Cohesion: 0.12
Nodes (17): ../data/validacion_providers.dart, dialogs/validacion_dialog.dart, validacionRepoProvider, _onTipoDocumento, _validar, build, _buildHeader, createState (+9 more)

### Community 88 - "stock_repository.dart"
Cohesion: 0.12
Nodes (15): agotado, ajustarExistencia, bajo, _db, filterProductos, getAlmacenes, getExistenciasMap, getExistenciasProducto (+7 more)

### Community 89 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 90 - "at"
Cohesion: 0.07
Nodes (35): a7(), aj(), at(), bZ(), c0(), c2(), cP(), d7() (+27 more)

### Community 91 - "win32_window.cpp"
Cohesion: 0.17
Nodes (14): wchar_t, Scale(), Create, Destroy, SetQuitOnClose, Win32Window::Win32Window(), WindowClassRegistrar, class_registered_ (+6 more)

### Community 92 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM, FlutterWindow, flutter_controller_ (+6 more)

### Community 93 - "inventario_repository.dart"
Cohesion: 0.08
Nodes (25): categoriaColor, categoriaId, categoriaNombre, _db, deleteComprasLista, esPesable, getAllCategorias, getAllProductos (+17 more)

### Community 94 - "receta_card.dart"
Cohesion: 0.13
Nodes (14): _badge, build, _fmtCant, ingredientes, onDelete, onEdit, onTap, receta (+6 more)

### Community 95 - "session_controller.dart"
Cohesion: 0.09
Nodes (25): dart:convert, ../db/database_provider.dart, ../db/schema/app_database.dart, Authenticated, _cargar, cerrarSesion, _db, nombre (+17 more)

### Community 96 - "ei"
Cohesion: 0.27
Nodes (10): c8(), d9(), ed(), ei(), eu(), gbi(), hi(), hj() (+2 more)

### Community 97 - "Win32Window"
Cohesion: 0.20
Nodes (14): OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, GetHandle, OnCreate (+6 more)

### Community 98 - "wWinMain"
Cohesion: 0.24
Nodes (9): wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), _In_, _In_opt_ (+1 more)

### Community 99 - "bandeja_screen.dart"
Cohesion: 0.11
Nodes (24): ../data/whatsapp_providers.dart, bandejaProvider, watch, whatsappPendientesProvider, whatsappRepoProvider, whatsappStatusProvider, WhatsappRepository, BandejaScreen (+16 more)

### Community 100 - "proveedor_dialog.dart"
Cohesion: 0.11
Nodes (19): build, _contactoCtrl, createState, _direccionCtrl, dispose, _emailCtrl, _estado, _guardando (+11 more)

### Community 109 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 110 - "$0"
Cohesion: 0.12
Nodes (24): $0(), a8(), aL(), be(), bh(), c6(), d6(), e2() (+16 more)

### Community 111 - "ComandasView"
Cohesion: 0.17
Nodes (4): ComandasView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView

### Community 112 - "historial_repository.dart"
Cohesion: 0.08
Nodes (25): double?, archivado, cantidad, countFacturas, _db, divisasUsd, efectivo, esPesable (+17 more)

### Community 113 - "MessageHandler"
Cohesion: 0.38
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetThisFromHandle, MessageHandler (+2 more)

### Community 114 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 115 - "ProduccionesView"
Cohesion: 0.12
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 116 - "log_bridge.dart"
Cohesion: 0.11
Nodes (17): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, _endpoint, flush, instance, LogBridge (+9 more)

### Community 117 - "whatsapp_repository.dart"
Cohesion: 0.09
Nodes (21): botUrl, countPending, _db, eliminar, _enviarDesdeCola, enviarImagen, _enviarImagenDirecto, enviarMensaje (+13 more)

### Community 118 - "cantidad_dialog.dart"
Cohesion: 0.08
Nodes (24): RequisicionItem, _agregar, build, _calcularDesdeTotal, _calcularDesdeUnidades, _cantCtrl, _CantidadDialog, _CantidadDialogState (+16 more)

### Community 119 - "Control de Entradas y Salidas — App Flutter"
Cohesion: 0.40
Nodes (4): Control de Entradas y Salidas — App Flutter, Estado actual del esqueleto (Fase 0), Instrucciones, Pendientes (Fase 1 y siguientes)

### Community 123 - "Factura"
Cohesion: 0.20
Nodes (6): Factura, FacturaPago, ProduccionDetalle, FacturaPagosCompanion, FacturasCompanion, ProduccionDetallesCompanion

### Community 128 - "app_shell.dart"
Cohesion: 0.03
Nodes (80): ../auth/session_controller.dart, Color, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/producciones/presentation/producciones_screen.dart, ../../features/requisiciones/presentation/requisiciones_screen.dart (+72 more)

### Community 129 - "base.py"
Cohesion: 0.07
Nodes (37): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, DateTime, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, get_db(), get_local_engine(), is_online(), Base de datos - SQLite como única fuente de verdad. El sistema ahora funciona… (+29 more)

### Community 130 - "OCRHandler"
Cohesion: 0.20
Nodes (8): check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text(), _get_long_path(), _notify_error(), OCRHandler

### Community 131 - "ja"
Cohesion: 0.10
Nodes (22): aD(), aE(), aF(), bL(), bU(), bV(), cf(), ck() (+14 more)

### Community 132 - "package:drift/drift.dart"
Cohesion: 0.20
Nodes (10): db, main, main, package:control_entradas_salidas/core/db/database_provider.dart, package:control_entradas_salidas/core/db/schema/app_database.dart, package:control_entradas_salidas/core/router/app_shell.dart, package:control_entradas_salidas/core/sync/sync_service.dart, package:drift/drift.dart (+2 more)

### Community 133 - "requisiciones_screen.dart"
Cohesion: 0.14
Nodes (14): _abrir, build, _cerrar, createState, _eliminar, RequisicionesScreen, _RequisicionesScreenState, _vistaActiva (+6 more)

### Community 134 - "._download_all_from_server"
Cohesion: 0.06
Nodes (15): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Guarda lista de recetas (bulk upsert para sync). (+7 more)

### Community 135 - "requisiciones/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.08
Nodes (22): ../../data/requisiciones_repository.dart, almacenes, build, esPesable, filtrados, _fmt, m, movs (+14 more)

### Community 136 - "app_launcher.py"
Cohesion: 0.12
Nodes (27): main(), mostrar_error_critico(), Page, check_connection_async(), get_engine(), init_local_tables(), Inicializa las tablas en la base de datos local., Alias de get_local_engine() para compatibilidad. (+19 more)

### Community 137 - "facturas_tab.dart"
Cohesion: 0.13
Nodes (16): dialogs/factura_detalle_dialog.dart, facturasProvider, _abrirDetalle, build, _buildFiltros, createState, dispose, FacturasTab (+8 more)

### Community 138 - "POSSyncIndicator"
Cohesion: 0.17
Nodes (7): get_pos_sync_indicator(), init_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual., Fuerza sync con Supabase y recarga todos los datos POS.

### Community 139 - "app_theme.dart"
Cohesion: 0.15
Nodes (12): app_colors.dart, AppThemeData, buildAppTheme, c, color, colors, dark, inputDecoration (+4 more)

### Community 140 - "._enqueue_venta"
Cohesion: 0.33
Nodes (3): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta).

### Community 141 - "show_error_with_copy"
Cohesion: 0.19
Nodes (4): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), ValidacionFields

### Community 143 - "categoria_card.dart"
Cohesion: 0.13
Nodes (17): build, CategoriaCard, _CategoriaCardState, color, createState, nombre, _onEnter, onTap (+9 more)

### Community 144 - "exportar_dialog.dart"
Cohesion: 0.12
Nodes (16): _anioCtrl, build, createState, dispose, _exportando, _ExportarDialog, _ExportarDialogState, _fmtFecha (+8 more)

### Community 148 - "factura_detalle_dialog.dart"
Cohesion: 0.15
Nodes (14): ../data/historial_providers.dart, historialRepoProvider, FacturaDetalle, _exportar, build, createState, _FacturaDetalleDialog, _FacturaDetalleDialogState (+6 more)

### Community 149 - ".aplicar_movimientos_venta"
Cohesion: 0.33
Nodes (3): Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 150 - "get_colors"
Cohesion: 0.07
Nodes (14): Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, schedule_load(), Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Constantes de colores para el tema de la aplicación, Helper para obtener colores según el tema de la página, get_card_bg(), build_producto_item_row() (+6 more)

### Community 152 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 153 - "login_screen.dart"
Cohesion: 0.16
Nodes (13): ../../../core/auth/session_controller.dart, appDatabaseProvider, build, _confirmCtrl, createState, dispose, _error, _hayOperador (+5 more)

### Community 155 - "._build_compras_lista_data"
Cohesion: 0.25
Nodes (5): Obtiene existencias de la BD local., create_categoria_header(), create_compra_lista_card(), Lee datos de la BD local y retorna (items, colors)., Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 156 - "._go_to_main"
Cohesion: 0.24
Nodes (5): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Crea todas las tablas locales., LoginView

### Community 157 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

### Community 158 - "entrada_card.dart"
Cohesion: 0.25
Nodes (7): ../../data/historial_repository.dart, EntradaPorFecha, build, entrada, EntradaCard, _fmtHora, _pesoBadge

### Community 159 - ".save_categorias"
Cohesion: 0.33
Nodes (3): Guarda categorías en la base de datos local (upsert, no borra)., Obtiene todas las categorías de la BD local., Lee caché local y (si hay conexión) consulta el servidor. Corre en hilo aparte…

### Community 160 - ".get_last_sync"
Cohesion: 0.29
Nodes (3): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 161 - "sync.py"
Cohesion: 0.13
Nodes (10): Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., Recalcula las existencias basándose en todos los movimientos. Si hay…, notify_sync_complete(), Notifica a todos los callbacks registrados., Sincronización Bidireccional con SQLAlchemy - maneja conexión y offline para…, Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, Recalcula las existencias locales desde los movimientos. (+2 more)

### Community 162 - "AppDatabase"
Cohesion: 0.29
Nodes (6): _, @DriftDatabase, db, AppDatabase, return, schema/app_database.dart

### Community 163 - "app_colors.dart"
Cohesion: 0.33
Nodes (5): AppColors, dark, light, of, static const

### Community 164 - ".get_contornos_activos"
Cohesion: 0.33
Nodes (3): Obtiene categorías de platos., Obtiene contornos activos para POS., Categorias de platos (sin padre) excluyendo las de contornos.

## Knowledge Gaps
- **1448 isolated node(s):** `Config`, `XCTest`, `_db`, `nombre`, `pinHash` (+1443 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **25 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `requisiciones_view.py`, `base.py`, `ConfigPOSView`, `OCRHandler`, `._download_all_from_server`, `ComandaPedidoView`, `app_launcher.py`, `get_db_adaptive`, `SyncQueue`, `ValidacionDialog`, `._enqueue_venta`, `show_error`, `InventarioView`, `show_error_with_copy`, `whatsapp_notifier.py`, `HabitacionesView`, `POSSyncManager`, `MesasView`, `.aplicar_movimientos_venta`, `database/__init__.py`, `get_colors`, `printer.py`, `.set_pos_setting`, `producciones/data.py`, `._build_compras_lista_data`, `SyncManager`, `._go_to_main`, `producciones/dialogs.py`, `.save_categorias`, `.get_last_sync`, `sync.py`, `VentasView`, `AuditView`, `.get_contornos_activos`, `historial_facturas_view.py`, `POSLoginView`, `_colors`, `.get_producto_by_id`, `.save_componentes`, `periodos.py`, `tasa_cambio.py`, `ComandasView`, `RecetaEditor`?**
  _High betweenness centrality (0.133) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `requisiciones_view.py`, `base.py`, `ConfigPOSView`, `historial_facturas_view.py`, `._download_all_from_server`, `SyncQueue`, `._enqueue_venta`, `show_error`, `InventarioView`, `whatsapp_notifier.py`, `POSSyncManager`, `.aplicar_movimientos_venta`, `database/__init__.py`, `printer.py`, `.set_pos_setting`, `._build_compras_lista_data`, `SyncManager`, `._go_to_main`, `.save_categorias`, `VentasView`, `sync.py`, `.get_last_sync`, `RequisicionesView`, `.get_contornos_activos`, `POSLoginView`, `.get_producto_by_id`, `.save_componentes`, `periodos.py`, `_get_storage_base`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **Why does `POSLoginView` connect `POSLoginView` to `LocalReplica`, `ComandaPedidoView`, `app_launcher.py`, `show_error`, `ComandasView`, `HabitacionesView`, `MesasView`, `get_colors`, `printer.py`, `VentasView`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._