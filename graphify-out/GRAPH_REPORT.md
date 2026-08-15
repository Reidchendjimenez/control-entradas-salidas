# Graph Report - control-entradas-salidas  (2026-08-14)

## Corpus Check
- 278 files · ~365,750 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 5150 nodes · 10451 edges · 174 communities (147 shown, 27 thin omitted)
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
- get_colors
- receta_editor_screen.dart
- show_error_with_copy
- package:flutter_riverpod/flutter_riverpod.dart
- ComandaPedidoView
- pos_repository.dart
- producciones_screen.dart
- precargar_imagen_dialog.dart
- Historial de Cambios
- InventarioView
- pos_sync_engine.dart
- whatsapp_notifier.py
- drift_worker.js
- tables.dart
- models/__init__.py
- pos_ventas_repository.dart
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
- launcher.py
- configuracionRepoProvider
- producciones_repository.dart
- app_database.dart
- LocalReplica
- a
- POSLoginView
- validacion_dialog.dart
- r
- productos_panel.dart
- periodos.py
- aM
- main_pos.py
- at
- b8
- _colors
- graphify reference: extra exports and benchmark
- DataClass
- 4. Módulos feature por feature
- temporales_repository.dart
- sync_engine.dart
- stock_screen.dart
- _NullStream
- i
- my_application.cc
- requisiciones_repository.dart
- graphify reference: query, path, explain
- package:drift/drift.dart
- categoria_dialog.dart
- descargo_dialog.dart
- temporales_dialog.dart
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- producto_dialog.dart
- form_view.dart
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- c
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
- ConsumerState
- win32_window.cpp
- FlutterWindow
- inventario_repository.dart
- Factura
- sync_service.dart
- tasa_cambio.py
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
- configuracion_providers.dart
- app_shell.dart
- calculadora_dialog.dart
- entrada_pendiente_card.dart
- a7
- sistema_tab.dart
- visualizar_view.dart
- O
- package:flutter/material.dart
- base.py
- validacion_providers.dart
- proveedores_tab.dart
- app_theme.dart
- get_theme
- productos_tab.dart
- WebServer
- categorias_tab.dart
- MesasView
- por_fecha_tab.dart
- pos_screen.dart
- stock/presentation/dialogs/historial_dialog.dart
- ._show_view
- Settings
- entrada_card.dart
- app_database.dart
- FacturaPagosCompanion
- login_screen.dart
- facturas_tab.dart
- ei
- static const
- splash.py
- RequisicionForm
- RequisicionDetallesCompanion
- .arrancar_interfaz
- _migrate_old_tables
- ExistenciasCompanion
- pos_providers.dart
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
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `_sync_existencias_supabase_batch()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py
- `totalizar_requisicion()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py

## Import Cycles
- None detected.

## Communities (174 total, 27 thin omitted)

### Community 0 - "get_db_adaptive"
Cohesion: 0.04
Nodes (69): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Existencia, Base, Base, Requisicion, RequisicionDetalle, get_productos_activos() (+61 more)

### Community 1 - "pendientes_tab.dart"
Cohesion: 0.03
Nodes (70): ../data/producciones_providers.dart, ../../data/producciones_repository.dart, dialogs/cancelar_produccion_dialog.dart, dialogs/delete_receta_dialog.dart, dialogs/descargo_dialog.dart, dedupeKey, incrementalById, incrementalColumn (+62 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.05
Nodes (22): Obtiene categorías POS independientes., Obtiene categorías de platos., Obtiene categorías visibles en el POS., _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), listar_impresoras() (+14 more)

### Community 3 - "get_colors"
Cohesion: 0.04
Nodes (37): Logger, clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Ejecuta `handler` en el event loop de la página solo si la sesión web ya está…, Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, Registra un callback que se ejecuta después de cada sync., Elimina un callback registrado. (+29 more)

### Community 4 - "receta_editor_screen.dart"
Cohesion: 0.05
Nodes (41): productosActivosProvider, _agregarFilaVacia, _agregarProducto, _baseProducto, _baseSearchCtrl, build, _buscar, _cancelar (+33 more)

### Community 5 - "show_error_with_copy"
Cohesion: 0.05
Nodes (16): Obtiene todos los proveedores de la BD local., Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader() (+8 more)

### Community 6 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.04
Nodes (51): categoria_card.dart, ConsumerWidget, ../../../core/db/database_provider.dart, ../../../../core/db/schema/app_database.dart, ../../data/inventario_providers.dart, ../../data/inventario_repository.dart, toggle, watch (+43 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.08
Nodes (10): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Obtiene platos activos para mostrar en POS., Obtiene contornos activos para POS., Obtiene productos del POS: activos y marcados para la venta., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos. (+2 more)

### Community 8 - "pos_repository.dart"
Cohesion: 0.05
Nodes (36): abrirSesion, actualizarHabitacion, actualizarMesa, actualizarPlato, actualizarPosCategoria, actualizarUsuario, cerrarSesion, crearHabitacion (+28 more)

### Community 9 - "producciones_screen.dart"
Cohesion: 0.06
Nodes (31): _abrirEditor, build, _buildHeader, _cerrarEditor, createState, dispose, _editorAbierto, initState (+23 more)

### Community 10 - "precargar_imagen_dialog.dart"
Cohesion: 0.08
Nodes (24): ../../data/ocr_service.dart, build, _conPrefijo, createState, dispose, _extrayendo, _facturaCtrl, _fechaCtrl (+16 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.07
Nodes (9): Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene todas las categorías de la BD local., Obtiene un producto por ID., create_categoria_header(), create_compra_lista_card(), InventarioView, Lee caché local y (si hay conexión) consulta el servidor. Corre en hilo aparte…, Lee datos de la BD local y retorna (items, colors). (+1 more)

### Community 13 - "pos_sync_engine.dart"
Cohesion: 0.06
Nodes (30): client, _db, _descargarSettings, _descargarTabla, _downloadAllFromServer, _esTombstone, fullSync, _log (+22 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "drift_worker.js"
Cohesion: 0.01
Nodes (75): cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), dl(), e4(), ef() (+67 more)

### Community 16 - "tables.dart"
Cohesion: 0.01
Nodes (137): DateTimeColumn get, abiertaEn, activo, actualizada, almacen, almacenPredeterminado, anuladaEn, anuladaPor (+129 more)

### Community 17 - "models/__init__.py"
Cohesion: 0.06
Nodes (22): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, FacturaPago (+14 more)

### Community 18 - "pos_ventas_repository.dart"
Cohesion: 0.08
Nodes (24): anularVenta, aplicarMovimientosVenta, cambiarEstadoComanda, _db, eliminarComanda, eliminarVentaYMovimientos, _encolarComanda, _encolarVenta (+16 more)

### Community 19 - "POSSyncManager"
Cohesion: 0.13
Nodes (5): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 20 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (30): double get, AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _calcularDesdeTotal (+22 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.14
Nodes (5): ControlEntradasSalidasApp, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de…

### Community 22 - "movimiento_dialog.dart"
Cohesion: 0.04
Nodes (59): sessionProvider, AppShell, _submit, inventarioRepoProvider, showAgregarProductoDialog, _abrirCalculadora, _almacen, _almacenes (+51 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "printer.py"
Cohesion: 0.08
Nodes (34): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., configurar_impresora(), _escpos_ticket(), _find_printer_device(), _get_comanda_header(), _get_configured_device(), get_correlativo_actual() (+26 more)

### Community 25 - "RecetaEditor"
Cohesion: 0.06
Nodes (21): delete_receta_dialog(), colors(), fmt_fecha(), Recorta ISO 'YYYY-MM-DDTHH:MM:SS...' a 'YYYY-MM-DD HH:MM'., build_historial_tab(), Tab Historial: lista de producciones con su estado (completado/cancelada)., Construye el contenido del tab Historial., build_pendientes_tab() (+13 more)

### Community 26 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "SyncManager"
Cohesion: 0.08
Nodes (16): Guarda timestamp del último sync., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync. (+8 more)

### Community 29 - "show_error"
Cohesion: 0.04
Nodes (74): Obtiene existencia por producto y almacén., Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., Actualiza el estado de una producción y encola el cambio para sync., Exception, Sistema global de manejo y notificación de errores. Este módulo mantiene…, Muestra el error en consola Y en pantalla como SnackBar rojo., Banner persistente para errores de sincronización. (+66 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.12
Nodes (8): LoadingSplash, Container, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5')., Marca el 100% y detiene las animaciones.

### Community 32 - "AuditView"
Cohesion: 0.15
Nodes (9): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+1 more)

### Community 33 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (34): archivarEnSupabase, clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db (+26 more)

### Community 34 - "launcher.py"
Cohesion: 0.08
Nodes (30): Text, get_pos_sync_manager(), init_pos_sync_manager(), Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), Page, Registrar la página activa para mostrar notificaciones. (+22 more)

### Community 35 - "configuracionRepoProvider"
Cohesion: 0.12
Nodes (21): configuracionRepoProvider, _aperturando, _aperturarPeriodo, build, createState, _forzando, _forzarArchivo, _periodoActual (+13 more)

### Community 36 - "producciones_repository.dart"
Cohesion: 0.03
Nodes (59): almacen, almacenProduccionDefault, cancelarProduccion, cantidad, cantidadSugerida, cocineros, ComponenteInfo, contarComponentes (+51 more)

### Community 37 - "app_database.dart"
Cohesion: 0.01
Nodes (308): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class PlatoIngrediente extends, class PosSyncTombstone extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends (+300 more)

### Community 38 - "LocalReplica"
Cohesion: 0.02
Nodes (108): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene todas las existencias de un producto (sumadas por almacén)., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene movimientos de la BD local (con numero de documento de la factura si… (+100 more)

### Community 39 - "a"
Cohesion: 0.05
Nodes (112): $1(), $2(), a(), a9(), aa(), aH(), aR(), aw() (+104 more)

### Community 41 - "validacion_dialog.dart"
Cohesion: 0.06
Nodes (34): _aplicarPrefijo, build, _conPrefijo, createState, dispose, _escanearOcr, _facturaCtrl, _fecha (+26 more)

### Community 42 - "r"
Cohesion: 0.05
Nodes (60): $3(), $5(), az(), bB(), bd(), be(), bh(), bP() (+52 more)

### Community 43 - "productos_panel.dart"
Cohesion: 0.05
Nodes (43): ../dialogs/movimiento_dialog.dart, _buildHeader, _buildProductosDeCategoria, _categoria, createState, dispose, InventarioScreen, _InventarioScreenState (+35 more)

### Community 44 - "periodos.py"
Cohesion: 0.23
Nodes (18): archivar_movimientos(), Archiva en Supabase (si se puede) y siempre en local., Mostrar mensaje informativo (azul)., show_info(), _aperturar_periodo(), build_periodos_tab(), _do_aperturar(), _do_forzar_archivo() (+10 more)

### Community 45 - "aM"
Cohesion: 0.11
Nodes (23): aM(), aV(), b6(), bf(), cU(), D(), d3(), fL() (+15 more)

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - "at"
Cohesion: 0.05
Nodes (62): aD(), aE(), aF(), ak(), an(), aQ(), at(), b3() (+54 more)

### Community 48 - "b8"
Cohesion: 0.10
Nodes (30): aB(), b0(), b2(), b8(), bC(), bI(), bj(), bN() (+22 more)

### Community 49 - "_colors"
Cohesion: 0.10
Nodes (36): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog() (+28 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "DataClass"
Cohesion: 0.06
Nodes (67): Categoria?, Categoria, CategoriasCompanion, ComprasListaCompanion, ComprasListaData, DataClass, DispositivoUsuarioCompanion, DispositivoUsuarioData (+59 more)

### Community 52 - "4. Módulos feature por feature"
Cohesion: 0.06
Nodes (31): 0. Inventario de lo que existe hoy (auditoría), 1. Arquitectura objetivo (Flutter), 2.1 Esquema, 2.2 Cliente Supabase, 2.3 Repositorios, 2. Capa de datos, 3. Motor de sincronización, 4.10 Updater (`updater.py`) (+23 more)

### Community 53 - "temporales_repository.dart"
Cohesion: 0.11
Nodes (17): double?, createdAt, _db, eliminar, fecha, _fromRow, getTemporales, guardar (+9 more)

### Community 54 - "sync_engine.dart"
Cohesion: 0.04
Nodes (50): ../config/app_config.dart, initialize, initializeSupabase, supabaseProvider, _catalogo, client, _db, def (+42 more)

### Community 55 - "stock_screen.dart"
Cohesion: 0.04
Nodes (52): ajuste_dialog.dart, bool get, ../../data/stock_providers.dart, ../data/stock_repository.dart, dialogs/existencias_dialog.dart, stockRepoProvider, capitalize, esPesable (+44 more)

### Community 56 - "_NullStream"
Cohesion: 0.17
Nodes (6): _get_app_dir(), main(), _NullStream, Page, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…

### Community 57 - "i"
Cohesion: 0.05
Nodes (54): $0(), a0(), a5(), a6(), a8(), ac(), aL(), aO() (+46 more)

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

### Community 62 - "categoria_dialog.dart"
Cohesion: 0.05
Nodes (45): ../../data/configuracion_repository.dart, dialogs/exportar_dialog.dart, facturas_tab.dart, build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose (+37 more)

### Community 63 - "descargo_dialog.dart"
Cohesion: 0.05
Nodes (40): ConsumerStatefulWidget, actualizar, _actualizarStock, _almacen, almacenDefault, almacenes, build, _buildItemRow (+32 more)

### Community 64 - "temporales_dialog.dart"
Cohesion: 0.13
Nodes (16): ../data/temporales_repository.dart, ../data/validacion_providers.dart, TemporalData, temporalesRepoProvider, _eliminarTemporal, _guardar, build, createState (+8 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - "producto_dialog.dart"
Cohesion: 0.08
Nodes (25): _activo, _almacenPredeterminado, _cargarCodigoAuto, _categoriaId, _codigoAuto, _codigoCtrl, createState, _descripcionCtrl (+17 more)

### Community 70 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 75 - "c"
Cohesion: 0.04
Nodes (71): a1(), a2(), a3(), a4(), aj(), aP(), aX(), aY() (+63 more)

### Community 76 - "ka"
Cohesion: 0.13
Nodes (20): c2(), cw(), d1(), d2(), dr(), ds(), dY(), eX() (+12 more)

### Community 77 - "Table"
Cohesion: 0.06
Nodes (36): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+28 more)

### Community 78 - "validacion_repository.dart"
Cohesion: 0.06
Nodes (34): ../../../core/sync/sync_engine.dart, almacen, buscarProveedor, cantidad, cantidadAnterior, cantidadNueva, crearProveedor, _db (+26 more)

### Community 79 - "pagos_panel.dart"
Cohesion: 0.05
Nodes (41): _LoteSelector, _LoteSelectorState, build, CategoriaCard, _CategoriaCardState, color, createState, nombre (+33 more)

### Community 83 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, AppDelegate, SceneDelegate, RunnerTests, FlutterAppDelegate, FlutterImplicitEngineBridge (+6 more)

### Community 85 - "get_cache_conn"
Cohesion: 0.16
Nodes (16): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+8 more)

### Community 87 - "validacion_screen.dart"
Cohesion: 0.13
Nodes (16): dialogs/precargar_imagen_dialog.dart, dialogs/temporales_dialog.dart, dialogs/validacion_dialog.dart, temporalesProvider, _seccionTemporalesGuardados, _buildHeader, createState, dispose (+8 more)

### Community 88 - "stock_repository.dart"
Cohesion: 0.11
Nodes (18): _, @DriftDatabase, AppDatabase, agotado, ajustarExistencia, bajo, _db, filterProductos (+10 more)

### Community 89 - "exportar_dialog.dart"
Cohesion: 0.13
Nodes (15): _anioCtrl, build, createState, dispose, _exportando, _ExportarDialog, _ExportarDialogState, _fmtFecha (+7 more)

### Community 90 - "ConsumerState"
Cohesion: 0.03
Nodes (67): AuditView, class, ConsumerState, ../../data/requisiciones_providers.dart, ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, requisicionesRepoProvider, _aceptar (+59 more)

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

### Community 96 - "tasa_cambio.py"
Cohesion: 0.13
Nodes (19): _abrir_url(), actualizar_tasa(), convertir(), formatear_tasa(), get_diagnostico(), get_tasa(), obtener_tasa_bcv(), _obtener_tasa_fallback() (+11 more)

### Community 97 - "Win32Window"
Cohesion: 0.20
Nodes (14): OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, GetHandle, OnCreate (+6 more)

### Community 98 - "wWinMain"
Cohesion: 0.24
Nodes (9): wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), _In_, _In_opt_ (+1 more)

### Community 99 - "bandeja_screen.dart"
Cohesion: 0.12
Nodes (23): ../data/whatsapp_providers.dart, bandejaProvider, watch, whatsappPendientesProvider, whatsappRepoProvider, whatsappStatusProvider, WhatsappRepository, BandejaScreen (+15 more)

### Community 100 - "proveedor_dialog.dart"
Cohesion: 0.11
Nodes (19): build, _contactoCtrl, createState, _direccionCtrl, dispose, _emailCtrl, _estado, _guardando (+11 more)

### Community 109 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 110 - "ce"
Cohesion: 0.09
Nodes (37): ai(), ce(), d5(), d6(), eK(), fm(), fp(), gac() (+29 more)

### Community 111 - "ComandasView"
Cohesion: 0.11
Nodes (6): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView

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
Cohesion: 0.17
Nodes (11): _endpoint, flush, instance, LogBridge, _pending, push, start, _timer (+3 more)

### Community 117 - "whatsapp_repository.dart"
Cohesion: 0.06
Nodes (34): dart:convert, dart:typed_data, _apiKey, extractFactura, OcrService, parseFacturaText, botUrl, countPending (+26 more)

### Community 118 - "cantidad_dialog.dart"
Cohesion: 0.05
Nodes (39): ../../data/requisiciones_repository.dart, RequisicionItem, _agregar, build, _calcularDesdeTotal, _calcularDesdeUnidades, _cantCtrl, _CantidadDialog (+31 more)

### Community 119 - "Control de Entradas y Salidas — App Flutter"
Cohesion: 0.40
Nodes (4): Control de Entradas y Salidas — App Flutter, Estado actual del esqueleto (Fase 0), Instrucciones, Pendientes (Fase 1 y siguientes)

### Community 123 - "configuracion_providers.dart"
Cohesion: 0.18
Nodes (18): configuracion_repository.dart, themeControllerProvider, almacenesConfigProvider, almacenProduccionDefaultProvider, categoriasConfigProvider, periodosConfigProvider, permitirStockNegativoProvider, productosConfigProvider (+10 more)

### Community 128 - "app_shell.dart"
Cohesion: 0.05
Nodes (46): ../auth/session_controller.dart, dart:math, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/pos/data/pos_providers.dart, ../../features/pos/presentation/pos_screen.dart (+38 more)

### Community 129 - "calculadora_dialog.dart"
Cohesion: 0.08
Nodes (26): build, _buildKeypad, _CalculadoraDialog, _CalculadoraDialogState, _compute, createState, _display, _fmt (+18 more)

### Community 130 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

### Community 131 - "a7"
Cohesion: 0.09
Nodes (25): a7(), aG(), cV(), d7(), dF(), dH(), en(), eQ() (+17 more)

### Community 132 - "sistema_tab.dart"
Cohesion: 0.12
Nodes (17): ../../../../core/state/theme_controller.dart, ../../../core/sync/sync_service.dart, syncEngineProvider, _guardar, _confirmarCambioOperador, createState, _sectionCard, _showPinDialog (+9 more)

### Community 133 - "visualizar_view.dart"
Cohesion: 0.12
Nodes (17): dart:html, build, _cargando, _cargar, _compartirWhatsApp, _copiar, createState, _detalles (+9 more)

### Community 134 - "O"
Cohesion: 0.08
Nodes (27): $4(), au(), b1(), bK(), bw(), bZ(), c0(), ea() (+19 more)

### Community 135 - "package:flutter/material.dart"
Cohesion: 0.03
Nodes (59): calculadora_button.dart, calculadora_dialog.dart, Color, _AppDrawer, _AppHeader, _DestinoPage, _NavBarMobile, build (+51 more)

### Community 136 - "base.py"
Cohesion: 0.04
Nodes (75): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, DateTime, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, resource_path(), Script único para migrar datos POS existentes a Supabase. Agrega todos los…, main(), mostrar_error_critico() (+67 more)

### Community 137 - "validacion_providers.dart"
Cohesion: 0.14
Nodes (14): TemporalesRepository, proveedoresProvider, validacionRepoProvider, watch, ValidacionRepository, _aplicarTemporal, _onTipoDocumento, _seccionDoc (+6 more)

### Community 138 - "proveedores_tab.dart"
Cohesion: 0.18
Nodes (12): ../dialogs/proveedor_dialog.dart, proveedoresConfigProvider, _abrirDialogo, build, _buildHeader, createState, dispose, _eliminar (+4 more)

### Community 139 - "app_theme.dart"
Cohesion: 0.08
Nodes (24): app_colors.dart, accent, AppThemeData, base, buildAppTheme, buttonPadding, buttonShape, c (+16 more)

### Community 140 - "get_theme"
Cohesion: 0.15
Nodes (9): apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_theme(), Aplica el tema a un Container, Aplica el tema a un TextField, Aplica el tema a un ElevatedButton, Retorna diccionario de colores según el tema. Tema basado en: primario = negro,… (+1 more)

### Community 141 - "productos_tab.dart"
Cohesion: 0.07
Nodes (26): ColorScheme, ../dialogs/producto_dialog.dart, _almacen, _buildHeader, categoria, _categoriaId, _chip, createState (+18 more)

### Community 143 - "categorias_tab.dart"
Cohesion: 0.18
Nodes (11): ../../data/configuracion_providers.dart, ../dialogs/categoria_dialog.dart, _abrirDialogo, CategoriasTab, _CategoriasTabState, createState, dispose, _eliminar (+3 more)

### Community 145 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 146 - "pos_screen.dart"
Cohesion: 0.38
Nodes (9): ../data/pos_providers.dart, build, comandasAbiertasProvider, _fila, mesasProvider, platosProvider, PosScreen, usuariosProvider (+1 more)

### Community 147 - "stock/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.22
Nodes (8): build, esPesable, _fmt, m, _MovimientoCard, showHistorialDialog, _tiposSalida, Set

### Community 149 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Settings

### Community 150 - "entrada_card.dart"
Cohesion: 0.25
Nodes (7): ../../data/historial_repository.dart, EntradaPorFecha, build, entrada, EntradaCard, _fmtHora, _pesoBadge

### Community 152 - "FacturaPagosCompanion"
Cohesion: 0.20
Nodes (6): FacturaPago, FacturaPagosCompanion, ProduccionDetallesCompanion, RecetaComponentesCompanion, ProduccionDetalle, RecetaComponente

### Community 153 - "login_screen.dart"
Cohesion: 0.12
Nodes (16): ../../../core/auth/session_controller.dart, appDatabaseProvider, db, build, _confirmCtrl, createState, dispose, _error (+8 more)

### Community 154 - "facturas_tab.dart"
Cohesion: 0.13
Nodes (16): dialogs/factura_detalle_dialog.dart, facturasProvider, _abrirDetalle, build, _buildFiltros, createState, dispose, FacturasTab (+8 more)

### Community 155 - "ei"
Cohesion: 0.31
Nodes (9): c8(), d9(), ed(), ei(), eu(), gbi(), hi(), hj() (+1 more)

### Community 156 - "static const"
Cohesion: 0.33
Nodes (5): AppColors, dark, light, of, static const

### Community 157 - "splash.py"
Cohesion: 0.33
Nodes (4): _find_background_image(), Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Devuelve el 'src' de la imagen de fondo (estática) a usar, o None. En móvil los…

### Community 158 - "RequisicionForm"
Cohesion: 0.14
Nodes (5): build_producto_item_row(), build_requisicion_card(), _c(), RequisicionForm, RequisicionService

### Community 161 - "_migrate_old_tables"
Cohesion: 0.50
Nodes (4): _migrate_old_tables(), Migra datos de tablas old (local_*) a tablas nuevas si existen datos en old., Migraciones automáticas para tablas POS., _run_pos_migrations()

### Community 164 - "pos_providers.dart"
Cohesion: 0.11
Nodes (16): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, ../../../core/sync/pos_sync_engine.dart, dart:async, features/calculadora/presentation/calculadora.dart, client, engine (+8 more)

## Knowledge Gaps
- **1793 isolated node(s):** `Config`, `XCTest`, `_db`, `nombre`, `pinHash` (+1788 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **27 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `get_db_adaptive`, `ConfigPOSView`, `get_colors`, `show_error_with_copy`, `ComandaPedidoView`, `base.py`, `InventarioView`, `whatsapp_notifier.py`, `MesasView`, `POSSyncManager`, `printer.py`, `RecetaEditor`, `SyncManager`, `show_error`, `VentasView`, `AuditView`, `POSLoginView`, `periodos.py`, `_colors`, `tasa_cambio.py`, `ComandasView`?**
  _High betweenness centrality (0.098) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `get_db_adaptive`, `ConfigPOSView`, `show_error_with_copy`, `ComandaPedidoView`, `base.py`, `POSLoginView`, `InventarioView`, `periodos.py`, `whatsapp_notifier.py`, `POSSyncManager`, `get_cache_conn`, `printer.py`, `SyncManager`, `show_error`, `VentasView`?**
  _High betweenness centrality (0.026) - this node is a cross-community bridge._
- **Why does `AppDatabase` connect `stock_repository.dart` to `configuracion_repository.dart`, `producciones_repository.dart`, `app_database.dart`, `pos_repository.dart`, `pos_sync_engine.dart`, `validacion_repository.dart`, `historial_repository.dart`, `pos_ventas_repository.dart`, `package:drift/drift.dart`, `temporales_repository.dart`, `sync_engine.dart`, `whatsapp_repository.dart`, `login_screen.dart`, `requisiciones_repository.dart`, `inventario_repository.dart`, `sync_service.dart`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **Are the 72 inferred relationships involving `LocalReplica` (e.g. with `main()` and `archivar_en_supabase()`) actually correct?**
  _`LocalReplica` has 72 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._