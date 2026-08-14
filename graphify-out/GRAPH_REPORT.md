# Graph Report - control-entradas-salidas  (2026-08-14)

## Corpus Check
- 249 files · ~309,942 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 4337 nodes · 9244 edges · 168 communities (138 shown, 30 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 416 edges (avg confidence: 0.53)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f14af054`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- get_db_adaptive
- movimiento_dialog.dart
- ConfigPOSView
- audit_view.dart
- ProduccionesView
- producto_dialog.dart
- inventario_view.py
- ComandaPedidoView
- stock_view.py
- productos_tab.dart
- ._ensure_tables
- Historial de Cambios
- InventarioView
- show_error
- ValidacionView
- drift_worker.js
- tables.dart
- models/__init__.py
- .get_existencias_by_producto
- POSSyncManager
- ajuste_auditoria_dialog.dart
- ControlEntradasSalidasApp
- base.py
- HistorialFacturasView
- printer.py
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/data.py
- LoadingSplash
- VentasView
- AuditView
- configuracion_repository.dart
- launcher.py
- RequisicionesView
- PaymentsManager
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
- configuracion_screen.dart
- app_shell.dart
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
- categoria_dialog.dart
- ka
- Table
- validacion_repository.dart
- pagos_panel.dart
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- AppDelegate
- graphify.js
- conn.py
- AGENTS.md
- login_screen.dart
- stock_repository.dart
- exportar_dialog.dart
- visualizar_view.dart
- win32_window.cpp
- FlutterWindow
- inventario_repository.dart
- categoria_card.dart
- session_controller.dart
- ei
- Win32Window
- wWinMain
- at
- proveedor_dialog.dart
- pos/__init__.py
- lycoris-control
- manifest.json
- validacion_screen.dart
- ComandasView
- historial_repository.dart
- MessageHandler
- app_config.dart
- .get_venta_anulada_by_comanda
- log_bridge.dart
- form.py
- cantidad_dialog.dart
- Control de Entradas y Salidas — App Flutter
- RegisterPlugins
- MainActivity.kt
- LaunchImage.imageset/README.md
- UpdateCompanion
- package:flutter/material.dart
- ._log
- OCRHandler
- show_error_with_copy
- package:drift/drift.dart
- por_fecha_tab.dart
- ._download_all_from_server
- requisiciones/presentation/dialogs/historial_dialog.dart
- aM
- facturas_tab.dart
- ValidacionDialog
- app_theme.dart
- ._enqueue_venta
- proveedores_tab.dart
- WebServer
- VisualizeView
- ._enqueue_comanda
- notifications.py
- HabitacionesView
- MesasView
- .aplicar_movimientos_venta
- categories.py
- app_database.dart
- .set_pos_setting
- main.dart
- historial_providers.dart
- _ValidacionDialogState
- .delete_receta
- .get_recetas
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

## Communities (168 total, 30 thin omitted)

### Community 0 - "get_db_adaptive"
Cohesion: 0.06
Nodes (60): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Existencia, Base, get_productos_activos(), Obtiene todos los productos activos del inventario., Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors() (+52 more)

### Community 1 - "movimiento_dialog.dart"
Cohesion: 0.11
Nodes (16): dedupeKey, incrementalColumn, localTable, serverTable, syncedTables, SyncTableDescriptor, almacen, almacenes (+8 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.05
Nodes (14): Obtiene categorías POS independientes., Obtiene categorías visibles en el POS., get_pos_sync_indicator(), POSSyncIndicator, Page, Activa/desactiva la barra. Solo se muestra durante un sync manual., ConfigPOSView, Construye el contenido de la pestaña de impresora. (+6 more)

### Community 3 - "audit_view.dart"
Cohesion: 0.03
Nodes (65): AuditView, class, ../../data/requisiciones_providers.dart, ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, requisicionesRepoProvider, _aceptar, _cargarProducto (+57 more)

### Community 5 - "producto_dialog.dart"
Cohesion: 0.08
Nodes (24): _activo, _almacenPredeterminado, _cargarCodigoAuto, _categoriaId, _codigoAuto, _codigoCtrl, createState, _descripcionCtrl (+16 more)

### Community 6 - "inventario_view.py"
Cohesion: 0.06
Nodes (42): Logger, is_online(), Alias de check_connection() para compatibilidad., Obtiene existencia por producto y almacén., Guarda un movimiento en la BD local., clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas. (+34 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.11
Nodes (7): Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene contornos activos para POS., Obtiene productos del POS: activos y marcados para la venta., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.12
Nodes (16): build_product_card(), build_stat_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial(), get_stock_stats(), load_categories() (+8 more)

### Community 9 - "productos_tab.dart"
Cohesion: 0.03
Nodes (91): ColorScheme, configuracion_repository.dart, ConsumerState, ConsumerStatefulWidget, ../../../../core/state/theme_controller.dart, dart:html, ../../data/configuracion_repository.dart, ../dialogs/categoria_dialog.dart (+83 more)

### Community 10 - "._ensure_tables"
Cohesion: 0.12
Nodes (8): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Obtiene timestamp del último sync., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync., Estado de conexión y sincronización.

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.11
Nodes (5): get_safe_colors(), create_categoria_header(), create_compra_lista_card(), InventarioView, Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 13 - "show_error"
Cohesion: 0.10
Nodes (28): main(), Page, Obtiene un setting de POS (ej: printer_device)., Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., Mostrar mensaje de advertencia (naranja)., show_error(), show_success() (+20 more)

### Community 14 - "ValidacionView"
Cohesion: 0.06
Nodes (24): Control, Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, schedule_load(), Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, ValidacionView, BandejaWhatsAppView, _notify_error(), Container (+16 more)

### Community 15 - "drift_worker.js"
Cohesion: 0.01
Nodes (75): cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), e4(), eR(), eS() (+67 more)

### Community 16 - "tables.dart"
Cohesion: 0.02
Nodes (96): DateTimeColumn get, activo, actualizada, almacen, almacenPredeterminado, cantidad, cantidadAnterior, cantidadNueva (+88 more)

### Community 17 - "models/__init__.py"
Cohesion: 0.05
Nodes (27): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, FacturaPago (+19 more)

### Community 18 - ".get_existencias_by_producto"
Cohesion: 0.50
Nodes (3): Obtiene todas las existencias de un producto (sumadas por almacén)., Suma de existencias de un producto en todos los almacenes., stock_total_producto()

### Community 19 - "POSSyncManager"
Cohesion: 0.08
Nodes (12): Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync., Bulk upsert plato_ingredientes para sync., Bulk upsert plato_contornos para sync., Bulk upsert pos_mesas para sync. (+4 more)

### Community 20 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (30): double get, AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _calcularDesdeTotal (+22 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.07
Nodes (18): ControlEntradasSalidasApp, Page, Imprime en el log (solo si TRACE_SWITCH=1) un marcador con delta de tiempo para…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager. (+10 more)

### Community 22 - "base.py"
Cohesion: 0.05
Nodes (65): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, DateTime, _get_app_dir(), Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), Script único para migrar datos POS existentes a Supabase. Agrega todos los… (+57 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "printer.py"
Cohesion: 0.05
Nodes (66): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., configurar_impresora(), _escpos_ticket(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers() (+58 more)

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
Cohesion: 0.11
Nodes (8): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Registra función a llamar con cada paso del sync (msg: str)., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado., Procesa la cola de sync - sube pendientes y descarga cambios., Sube elementos de la cola a Supabase usando SQL directo., SyncManager

### Community 29 - "producciones/data.py"
Cohesion: 0.09
Nodes (40): cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones(), planificar_descargo() (+32 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 32 - "AuditView"
Cohesion: 0.13
Nodes (11): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+3 more)

### Community 33 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (33): archivarEnSupabase, clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db (+25 more)

### Community 34 - "launcher.py"
Cohesion: 0.10
Nodes (27): Text, get_pos_sync_manager(), init_pos_sync_manager(), Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), Page, Registrar la página activa para mostrar notificaciones. (+19 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.07
Nodes (7): Ejecuta `handler` en el event loop de la página solo si la sesión web ya está…, run_when_connected(), Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 37 - "app_database.dart"
Cohesion: 0.01
Nodes (221): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends, class StockCheckpointData extends, class SyncMetadataData extends (+213 more)

### Community 38 - "LocalReplica"
Cohesion: 0.03
Nodes (53): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Tras subir una requisición local, actualiza su id local al id remoto para que… (+45 more)

### Community 39 - "a"
Cohesion: 0.05
Nodes (107): $1(), a(), a1(), a4(), aa(), aH(), aR(), aw() (+99 more)

### Community 41 - "validacion_dialog.dart"
Cohesion: 0.06
Nodes (32): _aplicarPrefijo, build, createState, dispose, _escanearOcr, _extractOcrSpace, _facturaCtrl, _fecha (+24 more)

### Community 42 - "r"
Cohesion: 0.04
Nodes (77): $0(), $2(), $3(), $5(), a8(), a9(), ac(), aL() (+69 more)

### Community 43 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.03
Nodes (95): ajuste_dialog.dart, categoria_card.dart, ConsumerWidget, ../../../core/db/database_provider.dart, ../../../core/db/schema/app_database.dart, ../../data/inventario_providers.dart, ../../data/inventario_repository.dart, ../data/stock_repository.dart (+87 more)

### Community 44 - "c"
Cohesion: 0.04
Nodes (70): a2(), aE(), aj(), aX(), aY(), ba(), bg(), bY() (+62 more)

### Community 45 - "N"
Cohesion: 0.09
Nodes (37): ce(), d5(), d6(), dF(), eE(), eK(), fm(), gac() (+29 more)

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - "aQ"
Cohesion: 0.07
Nodes (42): a3(), ak(), an(), aQ(), b2(), b3(), b4(), b5() (+34 more)

### Community 48 - "i"
Cohesion: 0.08
Nodes (40): aB(), b0(), b8(), bC(), bI(), bj(), c5(), c6() (+32 more)

### Community 49 - "_colors"
Cohesion: 0.14
Nodes (19): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog(), confirm_delete() (+11 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "DataClass"
Cohesion: 0.17
Nodes (22): Insertable, Categoria, ComprasListaData, DataClass, DispositivoUsuarioData, Existencia, Factura, FacturaPago (+14 more)

### Community 52 - "4. Módulos feature por feature"
Cohesion: 0.06
Nodes (31): 0. Inventario de lo que existe hoy (auditoría), 1. Arquitectura objetivo (Flutter), 2.1 Esquema, 2.2 Cliente Supabase, 2.3 Repositorios, 2. Capa de datos, 3. Motor de sincronización, 4.10 Updater (`updater.py`) (+23 more)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.16
Nodes (6): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene una categoría por ID., Obtiene un producto por ID., Obtiene existencias de la BD local., Lee datos de la BD local y retorna (items, colors).

### Community 54 - "sync_engine.dart"
Cohesion: 0.05
Nodes (38): ../config/app_config.dart, initialize, initializeSupabase, supabaseProvider, client, _db, def, _deleteMovimientoPorMatch (+30 more)

### Community 55 - "stock_screen.dart"
Cohesion: 0.05
Nodes (44): bool get, ../../data/stock_providers.dart, dialogs/existencias_dialog.dart, stockRepoProvider, _almacen, _almacenes, build, _buildFiltros (+36 more)

### Community 57 - "a5"
Cohesion: 0.09
Nodes (31): a5(), a6(), a7(), c1(), c2(), cV(), d7(), e9() (+23 more)

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

### Community 62 - "configuracion_screen.dart"
Cohesion: 0.08
Nodes (27): ../../data/configuracion_providers.dart, dialogs/exportar_dialog.dart, facturas_tab.dart, build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose (+19 more)

### Community 63 - "app_shell.dart"
Cohesion: 0.05
Nodes (38): ../auth/session_controller.dart, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/requisiciones/presentation/requisiciones_screen.dart, ../../features/stock/presentation/stock_screen.dart, ../../features/validacion/presentation/validacion_screen.dart (+30 more)

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
Cohesion: 0.21
Nodes (20): archivar_en_supabase(), archivar_movimientos(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Mostrar mensaje informativo (azul)., show_info(), _aperturar_periodo(), build_periodos_tab() (+12 more)

### Community 70 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 75 - "categoria_dialog.dart"
Cohesion: 0.08
Nodes (22): AppColors, dark, light, of, _activo, build, categoria, _colorCtrl (+14 more)

### Community 76 - "ka"
Cohesion: 0.08
Nodes (31): ai(), aO(), bx(), cw(), d1(), d2(), dl(), dr() (+23 more)

### Community 77 - "Table"
Cohesion: 0.10
Nodes (21): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+13 more)

### Community 78 - "validacion_repository.dart"
Cohesion: 0.06
Nodes (31): almacen, buscarProveedor, cantidad, crearProveedor, _db, eliminarEntrada, esPesable, facturaId (+23 more)

### Community 79 - "pagos_panel.dart"
Cohesion: 0.09
Nodes (22): _abrirPanel, _agregarBoton, _agregarPago, build, createState, dispose, _divisasMonto, _divisasTasa (+14 more)

### Community 83 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, AppDelegate, SceneDelegate, RunnerTests, FlutterAppDelegate, FlutterImplicitEngineBridge (+6 more)

### Community 85 - "conn.py"
Cohesion: 0.10
Nodes (24): BaseSettings, _candidate_env_paths(), Config, Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Rutas candidatas para buscar .env en orden de prioridad., Settings, Connection (+16 more)

### Community 87 - "login_screen.dart"
Cohesion: 0.11
Nodes (19): ../../../core/auth/session_controller.dart, sessionProvider, appDatabaseProvider, db, build, _confirmCtrl, createState, dispose (+11 more)

### Community 88 - "stock_repository.dart"
Cohesion: 0.12
Nodes (15): agotado, ajustarExistencia, bajo, _db, filterProductos, getAlmacenes, getExistenciasMap, getExistenciasProducto (+7 more)

### Community 89 - "exportar_dialog.dart"
Cohesion: 0.06
Nodes (37): ../data/historial_providers.dart, ../../data/historial_repository.dart, historialRepoProvider, EntradaPorFecha, FacturaDetalle, _anioCtrl, build, createState (+29 more)

### Community 90 - "visualizar_view.dart"
Cohesion: 0.12
Nodes (17): build, _cargando, _cargar, _compartirWhatsApp, _copiar, createState, _detalles, _header (+9 more)

### Community 91 - "win32_window.cpp"
Cohesion: 0.17
Nodes (14): wchar_t, Scale(), Create, Destroy, SetQuitOnClose, Win32Window::Win32Window(), WindowClassRegistrar, class_registered_ (+6 more)

### Community 92 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM, FlutterWindow, flutter_controller_ (+6 more)

### Community 93 - "inventario_repository.dart"
Cohesion: 0.08
Nodes (25): categoriaColor, categoriaId, categoriaNombre, _db, deleteComprasLista, esPesable, getAllCategorias, getAllProductos (+17 more)

### Community 94 - "categoria_card.dart"
Cohesion: 0.14
Nodes (15): build, CategoriaCard, _CategoriaCardState, color, createState, nombre, _onEnter, onTap (+7 more)

### Community 95 - "session_controller.dart"
Cohesion: 0.09
Nodes (24): dart:convert, ../db/database_provider.dart, ../db/schema/app_database.dart, Authenticated, _cargar, cerrarSesion, _db, nombre (+16 more)

### Community 96 - "ei"
Cohesion: 0.18
Nodes (14): aG(), c8(), cD(), d9(), ed(), ei(), eu(), f8() (+6 more)

### Community 97 - "Win32Window"
Cohesion: 0.20
Nodes (14): OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, GetHandle, OnCreate (+6 more)

### Community 98 - "wWinMain"
Cohesion: 0.24
Nodes (9): wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), _In_, _In_opt_ (+1 more)

### Community 99 - "at"
Cohesion: 0.05
Nodes (46): a0(), aD(), aF(), at(), bL(), bt(), bU(), bV() (+38 more)

### Community 100 - "proveedor_dialog.dart"
Cohesion: 0.11
Nodes (19): build, _contactoCtrl, createState, _direccionCtrl, dispose, _emailCtrl, _estado, _guardando (+11 more)

### Community 109 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 110 - "validacion_screen.dart"
Cohesion: 0.12
Nodes (17): ../data/validacion_providers.dart, dialogs/validacion_dialog.dart, validacionRepoProvider, _onTipoDocumento, _validar, build, _buildHeader, createState (+9 more)

### Community 111 - "ComandasView"
Cohesion: 0.15
Nodes (5): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView

### Community 112 - "historial_repository.dart"
Cohesion: 0.08
Nodes (25): double?, archivado, cantidad, countFacturas, _db, divisasUsd, efectivo, esPesable (+17 more)

### Community 113 - "MessageHandler"
Cohesion: 0.38
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetThisFromHandle, MessageHandler (+2 more)

### Community 114 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 115 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 116 - "log_bridge.dart"
Cohesion: 0.15
Nodes (12): _endpoint, flush, instance, LogBridge, _pending, push, start, _timer (+4 more)

### Community 117 - "form.py"
Cohesion: 0.15
Nodes (3): _c(), RequisicionForm, RequisicionService

### Community 118 - "cantidad_dialog.dart"
Cohesion: 0.08
Nodes (24): RequisicionItem, _agregar, build, _calcularDesdeTotal, _calcularDesdeUnidades, _cantCtrl, _CantidadDialog, _CantidadDialogState (+16 more)

### Community 119 - "Control de Entradas y Salidas — App Flutter"
Cohesion: 0.40
Nodes (4): Control de Entradas y Salidas — App Flutter, Estado actual del esqueleto (Fase 0), Instrucciones, Pendientes (Fase 1 y siguientes)

### Community 123 - "UpdateCompanion"
Cohesion: 0.07
Nodes (28): Categoria?, Existencia, Factura, FacturaPago, ProduccionDetalle, Receta, RecetaComponente, RequisicionDetalle (+20 more)

### Community 128 - "package:flutter/material.dart"
Cohesion: 0.04
Nodes (46): Color, ../../data/validacion_repository.dart, _AppDrawer, _AppHeader, _DestinoPage, _NavBarMobile, _ColorPickerButton, _ProductoItemCard (+38 more)

### Community 129 - "._log"
Cohesion: 0.09
Nodes (11): Obtiene movimientos que no han sido sincronizados., Marca un movimiento como sincronizado., Obtiene facturas de la BD local., Guarda timestamp del último sync., Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Print + notificar progreso visual., Notifica a todos los callbacks registrados. (+3 more)

### Community 130 - "OCRHandler"
Cohesion: 0.20
Nodes (8): check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text(), _get_long_path(), _notify_error(), OCRHandler

### Community 131 - "show_error_with_copy"
Cohesion: 0.19
Nodes (4): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), ValidacionFields

### Community 132 - "package:drift/drift.dart"
Cohesion: 0.15
Nodes (13): _, @DriftDatabase, AppDatabase, db, main, main, package:control_entradas_salidas/core/db/database_provider.dart, package:control_entradas_salidas/core/db/schema/app_database.dart (+5 more)

### Community 133 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 134 - "._download_all_from_server"
Cohesion: 0.05
Nodes (17): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga. (+9 more)

### Community 135 - "requisiciones/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.08
Nodes (24): ../../data/requisiciones_repository.dart, almacenes, build, esPesable, filtrados, _fmt, m, movs (+16 more)

### Community 136 - "aM"
Cohesion: 0.13
Nodes (19): aM(), aV(), b6(), bf(), cU(), D(), dB(), dc() (+11 more)

### Community 137 - "facturas_tab.dart"
Cohesion: 0.13
Nodes (16): dialogs/factura_detalle_dialog.dart, facturasProvider, _abrirDetalle, build, _buildFiltros, createState, dispose, FacturasTab (+8 more)

### Community 139 - "app_theme.dart"
Cohesion: 0.15
Nodes (12): app_colors.dart, AppThemeData, buildAppTheme, c, color, colors, dark, inputDecoration (+4 more)

### Community 140 - "._enqueue_venta"
Cohesion: 0.33
Nodes (3): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta).

### Community 141 - "proveedores_tab.dart"
Cohesion: 0.18
Nodes (12): ../dialogs/proveedor_dialog.dart, proveedoresConfigProvider, _abrirDialogo, build, _buildHeader, createState, dispose, _eliminar (+4 more)

### Community 144 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 145 - "notifications.py"
Cohesion: 0.26
Nodes (11): clear_notifications(), _get_colors(), _get_page(), Sistema centralizado de notificaciones para la aplicación. Proporciona…, Obtiene la página activa desde sys o desde la pila de llamadas., Mostrar banner persistente que requiere acción del usuario. Tipos: 'success',…, Limpiar todas las notificaciones activas., Obtener colores del tema (soporta tema claro/oscuro). (+3 more)

### Community 149 - ".aplicar_movimientos_venta"
Cohesion: 0.33
Nodes (3): Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 150 - "categories.py"
Cohesion: 0.29
Nodes (5): Obtiene todas las categorías de la BD local., create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color()

### Community 152 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 153 - "main.dart"
Cohesion: 0.33
Nodes (5): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, main

### Community 154 - "historial_providers.dart"
Cohesion: 0.33
Nodes (5): ../../../core/sync/sync_service.dart, sync, watch, HistorialRepository, historial_repository.dart

### Community 155 - "_ValidacionDialogState"
Cohesion: 0.50
Nodes (4): proveedoresProvider, _seccionDoc, _ValidacionDialogState, _ValidacionDialog

## Knowledge Gaps
- **1190 isolated node(s):** `Config`, `XCTest`, `_db`, `nombre`, `pinHash` (+1185 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **30 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `get_db_adaptive`, `._log`, `ConfigPOSView`, `OCRHandler`, `show_error_with_copy`, `._download_all_from_server`, `ComandaPedidoView`, `inventario_view.py`, `stock_view.py`, `._ensure_tables`, `ValidacionDialog`, `._enqueue_venta`, `show_error`, `InventarioView`, `ValidacionView`, `._enqueue_comanda`, `.get_existencias_by_producto`, `POSSyncManager`, `HabitacionesView`, `.aplicar_movimientos_venta`, `base.py`, `categories.py`, `printer.py`, `.set_pos_setting`, `MesasView`, `RecetaEditor`, `SyncManager`, `.delete_receta`, `.get_recetas`, `VentasView`, `producciones/data.py`, `AuditView`, `POSLoginView`, `_colors`, `.get_producto_by_id`, `.save_componentes`, `periodos.py`, `ComandasView`, `.get_venta_anulada_by_comanda`?**
  _High betweenness centrality (0.126) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `get_db_adaptive`, `._log`, `ConfigPOSView`, `._download_all_from_server`, `ComandaPedidoView`, `inventario_view.py`, `._ensure_tables`, `._enqueue_venta`, `show_error`, `InventarioView`, `ValidacionView`, `._enqueue_comanda`, `.get_existencias_by_producto`, `POSSyncManager`, `.aplicar_movimientos_venta`, `base.py`, `categories.py`, `.set_pos_setting`, `.delete_receta`, `.get_recetas`, `VentasView`, `RequisicionesView`, `POSLoginView`, `.get_producto_by_id`, `.save_componentes`, `periodos.py`, `conn.py`, `.get_venta_anulada_by_comanda`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **Why does `Producto` connect `models/__init__.py` to `get_db_adaptive`, `inventario_view.py`, `stock_view.py`, `_colors`, `base.py`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._