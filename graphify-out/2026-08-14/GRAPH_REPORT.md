# Graph Report - control-entradas-salidas  (2026-08-14)

## Corpus Check
- 273 files · ~338,587 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 4895 nodes · 10089 edges · 171 communities (141 shown, 30 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 475 edges (avg confidence: 0.53)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `16421d4f`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- get_db_adaptive
- pendientes_tab.dart
- ConfigPOSView
- ValidacionView
- receta_editor_screen.dart
- show_error_with_copy
- package:flutter_riverpod/flutter_riverpod.dart
- ComandaPedidoView
- stock_view.py
- producciones/data.py
- precargar_imagen_dialog.dart
- Historial de Cambios
- InventarioView
- app_launcher.py
- whatsapp_notifier.py
- drift_worker.js
- tables.dart
- models/__init__.py
- PaymentsManager
- POSSyncManager
- ajuste_auditoria_dialog.dart
- ControlEntradasSalidasApp
- movimiento_dialog.dart
- HistorialFacturasView
- printer.py
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- show_error
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
- productos_panel.dart
- c
- aM
- main_pos.py
- at
- b8
- get_sync_queue
- graphify reference: extra exports and benchmark
- DataClass
- 4. Módulos feature por feature
- temporales_repository.dart
- sync_engine.dart
- stock_screen.dart
- _NullStream
- $0
- my_application.cc
- requisiciones_repository.dart
- graphify reference: query, path, explain
- package:drift/drift.dart
- producciones_screen.dart
- descargo_dialog.dart
- temporales_dialog.dart
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- ConsumerStatefulWidget
- form_view.dart
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- bR
- ka
- Table
- validacion_repository.dart
- pagos_panel.dart
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- AppDelegate
- graphify.js
- get_cache_conn
- AGENTS.md
- validacion_screen.dart
- stock_repository.dart
- exportar_dialog.dart
- audit_view.dart
- win32_window.cpp
- FlutterWindow
- inventario_repository.dart
- Factura
- sync_service.dart
- comanda_view.py
- Win32Window
- wWinMain
- bandeja_screen.dart
- proveedor_dialog.dart
- pos/__init__.py
- lycoris-control
- manifest.json
- ce
- ComandasView
- historial_repository.dart
- MessageHandler
- app_config.dart
- factura_detalle_dialog.dart
- log_bridge.dart
- whatsapp_repository.dart
- cantidad_dialog.dart
- Control de Entradas y Salidas — App Flutter
- RegisterPlugins
- MainActivity.kt
- LaunchImage.imageset/README.md
- PagosPanelState
- app_shell.dart
- ConsumerState
- entrada_pendiente_card.dart
- dF
- registrar_movimiento
- launcher.py
- O
- package:flutter/material.dart
- base.py
- categoria_card.dart
- POSSyncIndicator
- app_theme.dart
- ValidacionDialog
- productos_tab.dart
- WebServer
- OCRHandler
- ._go_to_main
- por_fecha_tab.dart
- .get_venta_anulada_by_comanda
- stock/presentation/dialogs/historial_dialog.dart
- supabase_client.dart
- Settings
- entrada_card.dart
- app_database.dart
- FacturaPagosCompanion
- login_screen.dart
- facturas_tab.dart
- MovimientosCompanion
- ProduccionDetallesCompanion
- RecetaComponentesCompanion
- inventario_view.py
- RequisicionDetallesCompanion
- main.dart
- Producto
- String?

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 266 edges
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
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py

## Import Cycles
- None detected.

## Communities (171 total, 30 thin omitted)

### Community 0 - "get_db_adaptive"
Cohesion: 0.08
Nodes (50): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Existencia, Base, Producto, Base, build_detalle_row(), build_empty_state() (+42 more)

### Community 1 - "pendientes_tab.dart"
Cohesion: 0.03
Nodes (77): ../data/producciones_providers.dart, ../../data/producciones_repository.dart, dialogs/cancelar_produccion_dialog.dart, dialogs/delete_receta_dialog.dart, dialogs/descargo_dialog.dart, dedupeKey, incrementalById, incrementalColumn (+69 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (9): get_pos_sync_indicator(), ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora., Prueba la impresion en la impresora configurada. (+1 more)

### Community 3 - "ValidacionView"
Cohesion: 0.07
Nodes (10): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., schedule_load() (+2 more)

### Community 4 - "receta_editor_screen.dart"
Cohesion: 0.05
Nodes (41): productosActivosProvider, _agregarFilaVacia, _agregarProducto, _baseProducto, _baseSearchCtrl, build, _buscar, _cancelar (+33 more)

### Community 5 - "show_error_with_copy"
Cohesion: 0.18
Nodes (4): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), ValidacionFields

### Community 6 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.04
Nodes (49): ajuste_dialog.dart, categoria_card.dart, ../../../core/db/database_provider.dart, ../../../../core/db/schema/app_database.dart, ../../data/inventario_repository.dart, ../data/stock_repository.dart, toggle, watch (+41 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.08
Nodes (10): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Obtiene platos activos para mostrar en POS., Obtiene contornos activos para POS., Obtiene productos del POS: activos y marcados para la venta., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos. (+2 more)

### Community 8 - "stock_view.py"
Cohesion: 0.10
Nodes (18): Registra un callback que se ejecuta después de cada sync., register_sync_callback(), build_product_card(), build_stat_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial() (+10 more)

### Community 9 - "producciones/data.py"
Cohesion: 0.06
Nodes (28): Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene todas las recetas., Guarda una receta y retorna su ID., Elimina una receta y sus componentes., Obtiene los componentes de una receta., Reemplaza todos los componentes de una receta., Obtiene el historial de producciones., Guarda una producción y retorna su ID. (+20 more)

### Community 10 - "precargar_imagen_dialog.dart"
Cohesion: 0.08
Nodes (24): ../../data/ocr_service.dart, build, _conPrefijo, createState, dispose, _extrayendo, _facturaCtrl, _fechaCtrl (+16 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.10
Nodes (6): create_categoria_card_from_dict(), get_safe_colors(), create_categoria_header(), create_compra_lista_card(), InventarioView, Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 13 - "app_launcher.py"
Cohesion: 0.13
Nodes (17): _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico() (+9 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "drift_worker.js"
Cohesion: 0.01
Nodes (70): cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), dl(), e4(), ef() (+62 more)

### Community 16 - "tables.dart"
Cohesion: 0.02
Nodes (105): DateTimeColumn get, activo, actualizada, almacen, almacenPredeterminado, cantidad, cantidadAnterior, cantidadNueva (+97 more)

### Community 17 - "models/__init__.py"
Cohesion: 0.06
Nodes (20): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, MovimientoArchivo, Base (+12 more)

### Community 19 - "POSSyncManager"
Cohesion: 0.08
Nodes (10): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Obtiene timestamp del último sync., Asegura que las tablas de la cola existan (defensa ante arranques donde… (+2 more)

### Community 20 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (30): double get, AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _calcularDesdeTotal (+22 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.07
Nodes (20): ControlEntradasSalidasApp, Page, Imprime en el log (solo si TRACE_SWITCH=1) un marcador con delta de tiempo para…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager. (+12 more)

### Community 22 - "movimiento_dialog.dart"
Cohesion: 0.05
Nodes (41): _abrirCalculadora, _almacen, _almacenes, _campoPrincipal, _cantCtrl, _cantFocus, capitalize, _cargar (+33 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "printer.py"
Cohesion: 0.06
Nodes (48): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., configurar_impresora(), _escpos_ticket(), _find_printer_device(), _find_printer_device_auto() (+40 more)

### Community 25 - "RecetaEditor"
Cohesion: 0.06
Nodes (23): cancelar_produccion_dialog(), Confirma cancelación + revierte el stock del producto final., colors(), fmt_fecha(), Recorta ISO 'YYYY-MM-DDTHH:MM:SS...' a 'YYYY-MM-DD HH:MM'., theme(), build_historial_tab(), Tab Historial: lista de producciones con su estado (completado/cancelada). (+15 more)

### Community 26 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "SyncManager"
Cohesion: 0.06
Nodes (19): Obtiene movimientos que no han sido sincronizados., Obtiene facturas de la BD local., Tras subir una requisición local, actualiza su id local al id remoto para que…, Guarda timestamp del último sync., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str). (+11 more)

### Community 29 - "show_error"
Cohesion: 0.08
Nodes (38): Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., Mostrar mensaje de advertencia (naranja)., Mostrar mensaje informativo (azul)., show_error(), show_info(), show_success(), show_warning() (+30 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 31 - "VentasView"
Cohesion: 0.09
Nodes (7): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion')., VentasView

### Community 32 - "AuditView"
Cohesion: 0.13
Nodes (11): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+3 more)

### Community 33 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (34): archivarEnSupabase, clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db (+26 more)

### Community 34 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.22
Nodes (13): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), _get_app_dir(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica. (+5 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.08
Nodes (6): Ejecuta `handler` en el event loop de la página solo si la sesión web ya está…, run_when_connected(), Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "producciones_repository.dart"
Cohesion: 0.03
Nodes (59): almacen, almacenProduccionDefault, cancelarProduccion, cantidad, cantidadSugerida, cocineros, ComponenteInfo, contarComponentes (+51 more)

### Community 37 - "app_database.dart"
Cohesion: 0.01
Nodes (242): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends, class StockCheckpointData extends, class SyncMetadataData extends (+234 more)

### Community 38 - "LocalReplica"
Cohesion: 0.02
Nodes (89): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), init_local_db(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Limpia todos los movimientos. (+81 more)

### Community 39 - "a"
Cohesion: 0.05
Nodes (112): $1(), $2(), a(), a9(), aa(), aH(), aR(), aw() (+104 more)

### Community 41 - "validacion_dialog.dart"
Cohesion: 0.05
Nodes (39): proveedoresProvider, _aplicarPrefijo, _aplicarTemporal, build, _conPrefijo, createState, dispose, _escanearOcr (+31 more)

### Community 42 - "r"
Cohesion: 0.05
Nodes (62): $3(), $5(), aP(), az(), bB(), bd(), be(), bP() (+54 more)

### Community 43 - "productos_panel.dart"
Cohesion: 0.03
Nodes (69): ConsumerWidget, ../../../core/sync/sync_service.dart, ../../data/inventario_providers.dart, ../dialogs/movimiento_dialog.dart, inventarioRepoProvider, ComprasListaItem, categoriaId, categorias (+61 more)

### Community 44 - "c"
Cohesion: 0.04
Nodes (65): a0(), ac(), ai(), aj(), aO(), ba(), bt(), bx() (+57 more)

### Community 45 - "aM"
Cohesion: 0.11
Nodes (23): aM(), aV(), b6(), bf(), cU(), D(), d3(), fL() (+15 more)

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - "at"
Cohesion: 0.05
Nodes (60): aD(), aE(), aF(), ak(), an(), aQ(), at(), b3() (+52 more)

### Community 48 - "b8"
Cohesion: 0.11
Nodes (27): aB(), b0(), b2(), b8(), bC(), bI(), bj(), bs() (+19 more)

### Community 49 - "get_sync_queue"
Cohesion: 0.06
Nodes (57): DateTime, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.… (+49 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "DataClass"
Cohesion: 0.09
Nodes (40): Existencia, Categoria, ComprasListaCompanion, ComprasListaData, DataClass, DispositivoUsuarioCompanion, DispositivoUsuarioData, Existencia (+32 more)

### Community 52 - "4. Módulos feature por feature"
Cohesion: 0.06
Nodes (31): 0. Inventario de lo que existe hoy (auditoría), 1. Arquitectura objetivo (Flutter), 2.1 Esquema, 2.2 Cliente Supabase, 2.3 Repositorios, 2. Capa de datos, 3. Motor de sincronización, 4.10 Updater (`updater.py`) (+23 more)

### Community 53 - "temporales_repository.dart"
Cohesion: 0.11
Nodes (17): double?, createdAt, _db, eliminar, fecha, _fromRow, getTemporales, guardar (+9 more)

### Community 54 - "sync_engine.dart"
Cohesion: 0.04
Nodes (45): _catalogo, client, _db, def, _deleteMovimientoPorMatch, _descargarTabla, _downloadAllFromServer, fullSync (+37 more)

### Community 55 - "stock_screen.dart"
Cohesion: 0.05
Nodes (44): bool get, ../../data/stock_providers.dart, dialogs/existencias_dialog.dart, stockRepoProvider, _almacen, _almacenes, build, _buildFiltros (+36 more)

### Community 57 - "$0"
Cohesion: 0.05
Nodes (55): $0(), a5(), a6(), a7(), a8(), aL(), bh(), bZ() (+47 more)

### Community 58 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, fl_register_plugins(), main(), first_frame_cb(), my_application_activate(), my_application_class_init(), my_application_dispose(), my_application_init() (+14 more)

### Community 59 - "requisiciones_repository.dart"
Cohesion: 0.05
Nodes (37): _aplicarMoverStock, AuditStock, buscarProductos, cantidad, contarDetalles, crearAjusteStock, _db, destino (+29 more)

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - "package:drift/drift.dart"
Cohesion: 0.20
Nodes (10): db, main, main, package:control_entradas_salidas/core/db/database_provider.dart, package:control_entradas_salidas/core/db/schema/app_database.dart, package:control_entradas_salidas/core/router/app_shell.dart, package:control_entradas_salidas/core/sync/sync_service.dart, package:drift/drift.dart (+2 more)

### Community 62 - "producciones_screen.dart"
Cohesion: 0.05
Nodes (42): dialogs/exportar_dialog.dart, facturas_tab.dart, build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose, initState (+34 more)

### Community 63 - "descargo_dialog.dart"
Cohesion: 0.06
Nodes (37): actualizar, _actualizarStock, _almacen, almacenDefault, almacenes, build, _buildItemRow, _cant (+29 more)

### Community 64 - "temporales_dialog.dart"
Cohesion: 0.18
Nodes (11): ../data/temporales_repository.dart, ../data/validacion_providers.dart, TemporalData, createState, _fmtFecha, SeleccionTemporal, showTemporalesDialog, temporal (+3 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - "ConsumerStatefulWidget"
Cohesion: 0.03
Nodes (109): configuracion_repository.dart, ConsumerStatefulWidget, ../../../../core/state/theme_controller.dart, dart:html, ../../data/configuracion_providers.dart, ../../data/configuracion_repository.dart, ../dialogs/categoria_dialog.dart, ../dialogs/proveedor_dialog.dart (+101 more)

### Community 70 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 75 - "bR"
Cohesion: 0.07
Nodes (39): a1(), a2(), a3(), a4(), aX(), aY(), bg(), bN() (+31 more)

### Community 76 - "ka"
Cohesion: 0.12
Nodes (22): c2(), cw(), d1(), d2(), dr(), ds(), dY(), eX() (+14 more)

### Community 77 - "Table"
Cohesion: 0.09
Nodes (23): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+15 more)

### Community 78 - "validacion_repository.dart"
Cohesion: 0.06
Nodes (34): ../../../core/sync/sync_engine.dart, almacen, buscarProveedor, cantidad, cantidadAnterior, cantidadNueva, crearProveedor, _db (+26 more)

### Community 79 - "pagos_panel.dart"
Cohesion: 0.09
Nodes (22): _abrirPanel, _agregarBoton, _agregarPago, build, createState, dispose, _divisasMonto, _divisasTasa (+14 more)

### Community 83 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, AppDelegate, SceneDelegate, RunnerTests, FlutterAppDelegate, FlutterImplicitEngineBridge (+6 more)

### Community 85 - "get_cache_conn"
Cohesion: 0.16
Nodes (16): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+8 more)

### Community 87 - "validacion_screen.dart"
Cohesion: 0.08
Nodes (28): dialogs/precargar_imagen_dialog.dart, dialogs/temporales_dialog.dart, dialogs/validacion_dialog.dart, TemporalesRepository, temporalesProvider, temporalesRepoProvider, validacionRepoProvider, watch (+20 more)

### Community 88 - "stock_repository.dart"
Cohesion: 0.11
Nodes (18): _, @DriftDatabase, AppDatabase, agotado, ajustarExistencia, bajo, _db, filterProductos (+10 more)

### Community 89 - "exportar_dialog.dart"
Cohesion: 0.13
Nodes (15): _anioCtrl, build, createState, dispose, _exportando, _ExportarDialog, _ExportarDialogState, _fmtFecha (+7 more)

### Community 90 - "audit_view.dart"
Cohesion: 0.03
Nodes (66): AuditView, class, ../../data/requisiciones_providers.dart, ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, requisicionesRepoProvider, _aceptar, _cargarProducto (+58 more)

### Community 91 - "win32_window.cpp"
Cohesion: 0.17
Nodes (14): wchar_t, Scale(), Create, Destroy, SetQuitOnClose, Win32Window::Win32Window(), WindowClassRegistrar, class_registered_ (+6 more)

### Community 92 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM, FlutterWindow, flutter_controller_ (+6 more)

### Community 93 - "inventario_repository.dart"
Cohesion: 0.08
Nodes (25): categoriaColor, categoriaId, categoriaNombre, _db, deleteComprasLista, esPesable, getAllCategorias, getAllProductos (+17 more)

### Community 95 - "sync_service.dart"
Cohesion: 0.08
Nodes (27): ../db/database_provider.dart, ../db/schema/app_database.dart, Authenticated, _cargar, cerrarSesion, _db, nombre, pinHash (+19 more)

### Community 96 - "comanda_view.py"
Cohesion: 0.14
Nodes (21): _abrir_url(), actualizar_tasa(), convertir(), formatear_bs(), formatear_tasa(), get_diagnostico(), get_tasa(), obtener_tasa_bcv() (+13 more)

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

### Community 110 - "ce"
Cohesion: 0.11
Nodes (31): ce(), d5(), d6(), eK(), fm(), gac(), gb9(), gbz() (+23 more)

### Community 111 - "ComandasView"
Cohesion: 0.08
Nodes (7): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, MesasView

### Community 112 - "historial_repository.dart"
Cohesion: 0.08
Nodes (24): archivado, cantidad, countFacturas, _db, divisasUsd, efectivo, esPesable, factura (+16 more)

### Community 113 - "MessageHandler"
Cohesion: 0.38
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetThisFromHandle, MessageHandler (+2 more)

### Community 114 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 115 - "factura_detalle_dialog.dart"
Cohesion: 0.15
Nodes (14): ../data/historial_providers.dart, historialRepoProvider, FacturaDetalle, _exportar, build, createState, _FacturaDetalleDialog, _FacturaDetalleDialogState (+6 more)

### Community 116 - "log_bridge.dart"
Cohesion: 0.08
Nodes (23): dart:convert, dart:typed_data, _endpoint, flush, instance, LogBridge, _pending, push (+15 more)

### Community 117 - "whatsapp_repository.dart"
Cohesion: 0.07
Nodes (27): botUrl, countPending, _db, eliminar, _enviarDesdeCola, enviarImagen, _enviarImagenDirecto, enviarMensaje (+19 more)

### Community 118 - "cantidad_dialog.dart"
Cohesion: 0.05
Nodes (39): ../../data/requisiciones_repository.dart, RequisicionItem, _agregar, build, _calcularDesdeTotal, _calcularDesdeUnidades, _cantCtrl, _CantidadDialog (+31 more)

### Community 119 - "Control de Entradas y Salidas — App Flutter"
Cohesion: 0.40
Nodes (4): Control de Entradas y Salidas — App Flutter, Estado actual del esqueleto (Fase 0), Instrucciones, Pendientes (Fase 1 y siguientes)

### Community 123 - "PagosPanelState"
Cohesion: 0.27
Nodes (10): _LoteSelector, _LoteSelectorState, CategoriaCard, _CategoriaCardState, _StockText, _StockTextState, PagosPanel, PagosPanelState (+2 more)

### Community 128 - "app_shell.dart"
Cohesion: 0.05
Nodes (47): ../auth/session_controller.dart, dart:math, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/producciones/presentation/producciones_screen.dart, ../../features/requisiciones/presentation/requisiciones_screen.dart (+39 more)

### Community 129 - "ConsumerState"
Cohesion: 0.05
Nodes (43): ConsumerState, build, _buildKeypad, _CalculadoraDialog, _CalculadoraDialogState, _compute, createState, _display (+35 more)

### Community 130 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

### Community 131 - "dF"
Cohesion: 0.10
Nodes (23): aG(), c8(), cV(), d9(), dF(), dH(), ed(), ei() (+15 more)

### Community 132 - "registrar_movimiento"
Cohesion: 0.14
Nodes (15): Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync(), get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén. (+7 more)

### Community 133 - "launcher.py"
Cohesion: 0.19
Nodes (14): get_engine(), Alias de get_local_engine() para compatibilidad., Llamar desde main() antes de cualquier import de BD., set_db_path(), ensure_local_db(), Asegura que la BD local existe. Llamar después de set_db_path()., get_pos_sync_manager(), init_pos_sync_manager() (+6 more)

### Community 134 - "O"
Cohesion: 0.14
Nodes (16): $4(), au(), b1(), bK(), bw(), f2(), f3(), fg() (+8 more)

### Community 135 - "package:flutter/material.dart"
Cohesion: 0.03
Nodes (72): calculadora_button.dart, calculadora_dialog.dart, Color, _AppDrawer, _AppHeader, _DestinoPage, _NavBarMobile, build (+64 more)

### Community 136 - "base.py"
Cohesion: 0.06
Nodes (49): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Logger, check_connection(), get_base(), get_connection_status(), get_db(), get_local_db() (+41 more)

### Community 137 - "categoria_card.dart"
Cohesion: 0.20
Nodes (9): build, color, createState, nombre, _onEnter, onTap, _parseColor, _rotate (+1 more)

### Community 138 - "POSSyncIndicator"
Cohesion: 0.27
Nodes (3): POSSyncIndicator, Page, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 139 - "app_theme.dart"
Cohesion: 0.08
Nodes (24): app_colors.dart, accent, AppThemeData, base, buildAppTheme, buttonPadding, buttonShape, c (+16 more)

### Community 141 - "productos_tab.dart"
Cohesion: 0.05
Nodes (37): Categoria?, ColorScheme, ../dialogs/producto_dialog.dart, _activo, build, categoria, _CategoriaDialog, _CategoriaDialogState (+29 more)

### Community 143 - "OCRHandler"
Cohesion: 0.20
Nodes (8): check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text(), _get_long_path(), _notify_error(), OCRHandler

### Community 145 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 146 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 147 - "stock/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.22
Nodes (8): build, esPesable, _fmt, m, _MovimientoCard, showHistorialDialog, _tiposSalida, Set

### Community 148 - "supabase_client.dart"
Cohesion: 0.33
Nodes (5): ../config/app_config.dart, initialize, initializeSupabase, supabaseProvider, package:supabase_flutter/supabase_flutter.dart

### Community 149 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Settings

### Community 150 - "entrada_card.dart"
Cohesion: 0.25
Nodes (7): ../../data/historial_repository.dart, EntradaPorFecha, build, entrada, EntradaCard, _fmtHora, _pesoBadge

### Community 153 - "login_screen.dart"
Cohesion: 0.12
Nodes (16): ../../../core/auth/session_controller.dart, appDatabaseProvider, db, build, _confirmCtrl, createState, dispose, _error (+8 more)

### Community 154 - "facturas_tab.dart"
Cohesion: 0.13
Nodes (16): dialogs/factura_detalle_dialog.dart, facturasProvider, _abrirDetalle, build, _buildFiltros, createState, dispose, FacturasTab (+8 more)

### Community 158 - "inventario_view.py"
Cohesion: 0.08
Nodes (31): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Sistema centralizado de notificaciones para la aplicación. Proporciona…, Obtiene la página activa desde sys o desde la pila de llamadas. (+23 more)

### Community 164 - "main.dart"
Cohesion: 0.25
Nodes (7): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, features/calculadora/presentation/calculadora.dart, _forceIncludeCalculadora, main

## Knowledge Gaps
- **1606 isolated node(s):** `Config`, `XCTest`, `_db`, `nombre`, `pinHash` (+1601 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **30 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `get_db_adaptive`, `ConfigPOSView`, `ValidacionView`, `registrar_movimiento`, `show_error_with_copy`, `ComandaPedidoView`, `base.py`, `producciones/data.py`, `stock_view.py`, `InventarioView`, `app_launcher.py`, `ValidacionDialog`, `OCRHandler`, `._go_to_main`, `whatsapp_notifier.py`, `.get_venta_anulada_by_comanda`, `POSSyncManager`, `printer.py`, `RecetaEditor`, `SyncManager`, `show_error`, `inventario_view.py`, `VentasView`, `AuditView`, `POSLoginView`, `get_sync_queue`, `comanda_view.py`, `ComandasView`?**
  _High betweenness centrality (0.108) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `get_db_adaptive`, `registrar_movimiento`, `ComandaPedidoView`, `base.py`, `producciones/data.py`, `InventarioView`, `whatsapp_notifier.py`, `._go_to_main`, `.get_venta_anulada_by_comanda`, `POSSyncManager`, `printer.py`, `SyncManager`, `inventario_view.py`, `VentasView`, `RequisicionesView`, `POSLoginView`, `get_sync_queue`, `get_cache_conn`, `ComandasView`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Why does `AppDatabase` connect `stock_repository.dart` to `configuracion_repository.dart`, `producciones_repository.dart`, `app_database.dart`, `validacion_repository.dart`, `historial_repository.dart`, `package:drift/drift.dart`, `temporales_repository.dart`, `sync_engine.dart`, `whatsapp_repository.dart`, `login_screen.dart`, `requisiciones_repository.dart`, `inventario_repository.dart`, `sync_service.dart`?**
  _High betweenness centrality (0.019) - this node is a cross-community bridge._
- **Are the 72 inferred relationships involving `LocalReplica` (e.g. with `main()` and `archivar_en_supabase()`) actually correct?**
  _`LocalReplica` has 72 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._