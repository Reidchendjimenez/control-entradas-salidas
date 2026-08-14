# Graph Report - control-entradas-salidas  (2026-08-14)

## Corpus Check
- 240 files · ~306,228 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 4211 nodes · 9052 edges · 165 communities (134 shown, 31 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 416 edges (avg confidence: 0.53)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f14af054`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- get_db_adaptive
- buscador_productos_dialog.dart
- ConfigPOSView
- audit_view.dart
- ProduccionesView
- producto_dialog.dart
- show_error
- ComandaPedidoView
- stock_view.py
- productos_tab.dart
- ._ensure_tables
- Historial de Cambios
- InventarioView
- historial_facturas_view.py
- whatsapp_notifier.py
- drift_worker.js
- tables.dart
- models/__init__.py
- producciones/data.py
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
- producciones/dialogs.py
- LoadingSplash
- VentasView
- AuditView
- configuracion_repository.dart
- launcher.py
- RequisicionesView
- show_error_with_copy
- app_database.dart
- LocalReplica
- a
- POSLoginView
- validacion_dialog.dart
- r
- productos_panel.dart
- c
- N
- main_pos.py
- aQ
- i
- get_sync_queue
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
- ConsumerStatefulWidget
- app_shell.dart
- $0
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
- stock/presentation/dialogs/historial_dialog.dart
- visualizar_view.dart
- win32_window.cpp
- FlutterWindow
- inventario_repository.dart
- categoria_card.dart
- session_controller.dart
- dF
- Win32Window
- wWinMain
- at
- proveedor_dialog.dart
- pos/__init__.py
- lycoris-control
- manifest.json
- validacion_screen.dart
- ComandasView
- supabase_client.dart
- MessageHandler
- app_config.dart
- .get_venta_anulada_by_comanda
- log_bridge.dart
- get_colors
- cantidad_dialog.dart
- Control de Entradas y Salidas — App Flutter
- RegisterPlugins
- MainActivity.kt
- LaunchImage.imageset/README.md
- Categoria?
- package:flutter/material.dart
- _abrir_url
- ValidacionFields
- _migrate_old_tables
- AppDatabase
- ExistenciasCompanion
- ._download_all_from_server
- requisiciones/presentation/dialogs/historial_dialog.dart
- Movimiento
- ProduccionDetallesCompanion
- package:flutter_riverpod/flutter_riverpod.dart
- RecetaComponentesCompanion
- ._enqueue_venta
- entrada_pendiente_card.dart
- WebServer
- VisualizeView
- ._enqueue_comanda
- RequisicionDetallesCompanion
- PagosPanelState
- init_local_db
- .aplicar_movimientos_venta
- app_database.dart
- SyncQueue
- _ValidacionDialogState
- pos/data.py
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
- `_get_remote_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/archive.py → config/config.py
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `_sync_existencias_supabase_batch()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py

## Import Cycles
- None detected.

## Communities (165 total, 31 thin omitted)

### Community 0 - "get_db_adaptive"
Cohesion: 0.08
Nodes (51): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Existencia, Base, Producto, Base, build_detalle_row(), build_empty_state() (+43 more)

### Community 1 - "buscador_productos_dialog.dart"
Cohesion: 0.07
Nodes (27): class, dedupeKey, incrementalColumn, localTable, serverTable, syncedTables, SyncTableDescriptor, almacen (+19 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Obtiene categorías POS independientes., Obtiene categorías de platos., Obtiene categorías visibles en el POS., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles. (+2 more)

### Community 3 - "audit_view.dart"
Cohesion: 0.04
Nodes (55): AuditView, ../../data/requisiciones_providers.dart, ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, requisicionesRepoProvider, _aceptar, _cargarProducto, _cargarDisponible (+47 more)

### Community 4 - "ProduccionesView"
Cohesion: 0.12
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 5 - "producto_dialog.dart"
Cohesion: 0.08
Nodes (26): _activo, _almacenPredeterminado, _cargarCodigoAuto, _categoriaId, _codigoAuto, _codigoCtrl, createState, _descripcionCtrl (+18 more)

### Community 6 - "show_error"
Cohesion: 0.06
Nodes (61): is_online(), Alias de check_connection() para compatibilidad., Obtiene existencia por producto y almacén., get_pending_movimientos_count(), get_sync_manager(), Obtiene el número de movimientos pendientes de sincronización., Exception, Sistema global de manejo y notificación de errores. Este módulo mantiene… (+53 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.10
Nodes (5): Obtiene contornos activos para POS., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.09
Nodes (26): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+18 more)

### Community 9 - "productos_tab.dart"
Cohesion: 0.03
Nodes (89): ColorScheme, configuracion_repository.dart, ../../../../core/state/theme_controller.dart, ../../../core/sync/sync_service.dart, dart:html, ../../data/configuracion_providers.dart, ../../data/configuracion_repository.dart, ../dialogs/categoria_dialog.dart (+81 more)

### Community 10 - "._ensure_tables"
Cohesion: 0.12
Nodes (8): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Obtiene timestamp del último sync., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync., Estado de conexión y sincronización.

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.09
Nodes (10): create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color(), get_safe_colors(), create_categoria_header(), create_compra_lista_card(), InventarioView (+2 more)

### Community 13 - "historial_facturas_view.py"
Cohesion: 0.06
Nodes (18): Logger, clear_all_callbacks(), Manejo de callbacks de sincronización entre vistas., Ejecuta `handler` en el event loop de la página solo si la sesión web ya está…, Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, Registra un callback que se ejecuta después de cada sync., Elimina un callback registrado., Limpia todos los callbacks registrados. (+10 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "drift_worker.js"
Cohesion: 0.01
Nodes (76): bs(), cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), dB(), dc(), e4() (+68 more)

### Community 16 - "tables.dart"
Cohesion: 0.02
Nodes (96): DateTimeColumn get, activo, actualizada, almacen, almacenPredeterminado, cantidad, cantidadAnterior, cantidadNueva (+88 more)

### Community 17 - "models/__init__.py"
Cohesion: 0.06
Nodes (21): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, FacturaPago (+13 more)

### Community 18 - "producciones/data.py"
Cohesion: 0.12
Nodes (21): Actualiza el estado de una producción y encola el cambio para sync., Guarda un detalle de producción., ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones() (+13 more)

### Community 19 - "POSSyncManager"
Cohesion: 0.07
Nodes (14): Marca un movimiento como sincronizado., Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync., Bulk upsert plato_ingredientes para sync., Bulk upsert plato_contornos para sync. (+6 more)

### Community 20 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.06
Nodes (31): double?, double get, AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build (+23 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.09
Nodes (9): ControlEntradasSalidasApp, Page, Imprime en el log (solo si TRACE_SWITCH=1) un marcador con delta de tiempo para…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager. (+1 more)

### Community 22 - "base.py"
Cohesion: 0.07
Nodes (44): get_settings(), Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, resource_path(), Script único para migrar datos POS existentes a Supabase. Agrega todos los…, main(), mostrar_error_critico(), Page, check_connection() (+36 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "printer.py"
Cohesion: 0.06
Nodes (56): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., configurar_impresora(), _escpos_ticket(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers() (+48 more)

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
Cohesion: 0.08
Nodes (17): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado. (+9 more)

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (21): cancelar_produccion(), Revierte todas las entradas del lote y marca la producción como cancelada.…, cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente. (+13 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (11): _find_background_image(), LoadingSplash, Container, Page, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync). (+3 more)

### Community 32 - "AuditView"
Cohesion: 0.18
Nodes (3): AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 33 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (33): archivarEnSupabase, clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db (+25 more)

### Community 34 - "launcher.py"
Cohesion: 0.07
Nodes (35): Text, get_pos_sync_manager(), init_pos_sync_manager(), Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), main(), Page (+27 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.09
Nodes (6): Requisicion, Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "show_error_with_copy"
Cohesion: 0.17
Nodes (5): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), _notify_error(), PaymentsManager

### Community 37 - "app_database.dart"
Cohesion: 0.01
Nodes (221): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends, class StockCheckpointData extends, class SyncMetadataData extends (+213 more)

### Community 38 - "LocalReplica"
Cohesion: 0.02
Nodes (57): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene todas las existencias de un producto (sumadas por almacén)., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene movimientos de la BD local (con numero de documento de la factura si… (+49 more)

### Community 39 - "a"
Cohesion: 0.05
Nodes (109): $1(), $2(), a(), a1(), a4(), a9(), aa(), aH() (+101 more)

### Community 41 - "validacion_dialog.dart"
Cohesion: 0.06
Nodes (32): _aplicarPrefijo, build, createState, dispose, _escanearOcr, _extractOcrSpace, _facturaCtrl, _fecha (+24 more)

### Community 42 - "r"
Cohesion: 0.05
Nodes (62): $3(), $5(), ac(), az(), bB(), bd(), be(), bP() (+54 more)

### Community 43 - "productos_panel.dart"
Cohesion: 0.05
Nodes (47): ../../data/inventario_providers.dart, dialogs/agregar_producto_dialog.dart, inventarioRepoProvider, ComprasListaItem, categoriaId, categorias, codigoCtrl, esPesable (+39 more)

### Community 44 - "c"
Cohesion: 0.05
Nodes (59): a2(), aE(), aP(), aX(), aY(), ba(), bg(), bY() (+51 more)

### Community 45 - "N"
Cohesion: 0.05
Nodes (65): a3(), ai(), aM(), aV(), b6(), bf(), ce(), cU() (+57 more)

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - "aQ"
Cohesion: 0.08
Nodes (37): ak(), an(), aQ(), b2(), b3(), b4(), b5(), bC() (+29 more)

### Community 48 - "i"
Cohesion: 0.05
Nodes (55): a0(), aB(), aO(), b0(), b8(), bI(), bj(), bt() (+47 more)

### Community 49 - "get_sync_queue"
Cohesion: 0.11
Nodes (29): DateTime, Réplica local SQLite para trabajo offline. Almacena una copia de los datos de…, get_sync_queue(), Cola de sincronización unificada para trabajo offline-first. Maneja: - Cola de…, Obtiene instancia singleton de SyncQueue., _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile() (+21 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "DataClass"
Cohesion: 0.09
Nodes (39): Factura, FacturaPago, Insertable, Receta, UpdateCompanion, Categoria, ComprasListaCompanion, ComprasListaData (+31 more)

### Community 52 - "4. Módulos feature por feature"
Cohesion: 0.06
Nodes (31): 0. Inventario de lo que existe hoy (auditoría), 1. Arquitectura objetivo (Flutter), 2.1 Esquema, 2.2 Cliente Supabase, 2.3 Repositorios, 2. Capa de datos, 3. Motor de sincronización, 4.10 Updater (`updater.py`) (+23 more)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.16
Nodes (6): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene una categoría por ID., Obtiene un producto por ID., Obtiene existencias de la BD local., Lee datos de la BD local y retorna (items, colors).

### Community 54 - "sync_engine.dart"
Cohesion: 0.06
Nodes (33): client, _db, def, _deleteMovimientoPorMatch, _downloadAllFromServer, fullSync, _getLastFullSync, isOffline (+25 more)

### Community 55 - "stock_screen.dart"
Cohesion: 0.05
Nodes (45): bool get, ConsumerWidget, ../../data/stock_providers.dart, dialogs/existencias_dialog.dart, CategoriasGrid, ListaCompraItem, ProductoCard, RequisicionCard (+37 more)

### Community 56 - "_NullStream"
Cohesion: 0.17
Nodes (6): _get_app_dir(), main(), _NullStream, Page, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…

### Community 57 - "a5"
Cohesion: 0.08
Nodes (34): a5(), a6(), a7(), aj(), c1(), c2(), cP(), d7() (+26 more)

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

### Community 62 - "ConsumerStatefulWidget"
Cohesion: 0.11
Nodes (18): ConsumerStatefulWidget, build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose, initState, _tabController (+10 more)

### Community 63 - "app_shell.dart"
Cohesion: 0.04
Nodes (56): ../auth/session_controller.dart, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/requisiciones/presentation/requisiciones_screen.dart, ../../features/stock/presentation/stock_screen.dart, ../../features/validacion/presentation/validacion_screen.dart, sessionProvider (+48 more)

### Community 64 - "$0"
Cohesion: 0.10
Nodes (26): $0(), $4(), a8(), aL(), au(), b1(), bh(), c6() (+18 more)

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
Cohesion: 0.20
Nodes (20): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, _aperturar_periodo() (+12 more)

### Community 70 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 75 - "categoria_dialog.dart"
Cohesion: 0.07
Nodes (26): ConsumerState, AppColors, dark, light, of, _activo, build, categoria (+18 more)

### Community 76 - "ka"
Cohesion: 0.16
Nodes (17): cw(), d1(), d2(), dr(), ds(), dY(), eX(), eY() (+9 more)

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
Cohesion: 0.09
Nodes (25): BaseSettings, _candidate_env_paths(), Config, Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Rutas candidatas para buscar .env en orden de prioridad., Settings, Valores de BD empaquetados para builds compilados (Windows exe / Android APK).… (+17 more)

### Community 87 - "login_screen.dart"
Cohesion: 0.12
Nodes (16): ../../../core/auth/session_controller.dart, appDatabaseProvider, db, build, _confirmCtrl, createState, dispose, _error (+8 more)

### Community 88 - "stock_repository.dart"
Cohesion: 0.12
Nodes (16): agotado, ajustarExistencia, bajo, _db, filterProductos, getAlmacenes, getExistenciasMap, getExistenciasProducto (+8 more)

### Community 89 - "stock/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.22
Nodes (8): build, esPesable, _fmt, m, _MovimientoCard, showHistorialDialog, _tiposSalida, Set

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
Cohesion: 0.09
Nodes (20): Color, build, color, createState, nombre, _onEnter, onTap, _parseColor (+12 more)

### Community 95 - "session_controller.dart"
Cohesion: 0.09
Nodes (25): dart:convert, ../db/database_provider.dart, ../db/schema/app_database.dart, Authenticated, _cargar, cerrarSesion, _db, nombre (+17 more)

### Community 96 - "dF"
Cohesion: 0.08
Nodes (27): aG(), c8(), cD(), cV(), d9(), dF(), dH(), ed() (+19 more)

### Community 97 - "Win32Window"
Cohesion: 0.20
Nodes (14): OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, GetHandle, OnCreate (+6 more)

### Community 98 - "wWinMain"
Cohesion: 0.24
Nodes (9): wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), _In_, _In_opt_ (+1 more)

### Community 99 - "at"
Cohesion: 0.06
Nodes (38): aD(), aF(), at(), bL(), bU(), bV(), bw(), bZ() (+30 more)

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
Cohesion: 0.09
Nodes (7): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, MesasView

### Community 112 - "supabase_client.dart"
Cohesion: 0.33
Nodes (5): ../config/app_config.dart, initialize, initializeSupabase, supabaseProvider, package:supabase_flutter/supabase_flutter.dart

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
Cohesion: 0.11
Nodes (17): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, _endpoint, flush, instance, LogBridge (+9 more)

### Community 117 - "get_colors"
Cohesion: 0.06
Nodes (22): Base, RequisicionDetalle, Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_colors(), get_theme() (+14 more)

### Community 118 - "cantidad_dialog.dart"
Cohesion: 0.08
Nodes (24): RequisicionItem, _agregar, build, _calcularDesdeTotal, _calcularDesdeUnidades, _cantCtrl, _CantidadDialog, _CantidadDialogState (+16 more)

### Community 119 - "Control de Entradas y Salidas — App Flutter"
Cohesion: 0.40
Nodes (4): Control de Entradas y Salidas — App Flutter, Estado actual del esqueleto (Fase 0), Instrucciones, Pendientes (Fase 1 y siguientes)

### Community 128 - "package:flutter/material.dart"
Cohesion: 0.06
Nodes (29): app_colors.dart, AppThemeData, buildAppTheme, c, color, colors, dark, inputDecoration (+21 more)

### Community 129 - "_abrir_url"
Cohesion: 0.33
Nodes (6): _abrir_url(), _obtener_tasa_fallback(), _obtener_tasa_sitio_oficial(), Respaldo: consulta la tasa USD en la API de bcv.today., Descarga una URL con User-Agent real y reintento sin verificar SSL., Scrapea la tasa USD del sitio oficial del BCV (www.bcv.org.ve). El valor…

### Community 130 - "ValidacionFields"
Cohesion: 0.07
Nodes (10): check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text(), ValidacionDialog, ValidacionFields, _get_long_path() (+2 more)

### Community 131 - "_migrate_old_tables"
Cohesion: 0.50
Nodes (4): _migrate_old_tables(), Migra datos de tablas old (local_*) a tablas nuevas si existen datos en old., Migraciones automáticas para tablas POS., _run_pos_migrations()

### Community 132 - "AppDatabase"
Cohesion: 0.16
Nodes (12): _, @DriftDatabase, AppDatabase, db, main, main, package:control_entradas_salidas/core/db/database_provider.dart, package:control_entradas_salidas/core/db/schema/app_database.dart (+4 more)

### Community 134 - "._download_all_from_server"
Cohesion: 0.05
Nodes (17): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga. (+9 more)

### Community 135 - "requisiciones/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.13
Nodes (14): ../../data/requisiciones_repository.dart, almacenes, build, esPesable, filtrados, _fmt, m, movs (+6 more)

### Community 138 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.05
Nodes (41): ajuste_dialog.dart, categoria_card.dart, ../../../core/db/database_provider.dart, ../../../core/db/schema/app_database.dart, ../../data/inventario_repository.dart, ../data/stock_repository.dart, toggle, InventarioRepository (+33 more)

### Community 141 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

### Community 144 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 147 - "PagosPanelState"
Cohesion: 0.40
Nodes (6): CategoriaCard, _CategoriaCardState, PagosPanel, PagosPanelState, State, StatefulWidget

### Community 148 - "init_local_db"
Cohesion: 0.50
Nodes (3): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Crea todas las tablas locales.

### Community 149 - ".aplicar_movimientos_venta"
Cohesion: 0.33
Nodes (3): Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 152 - "SyncQueue"
Cohesion: 0.29
Nodes (4): Sincronización bidireccional exclusiva para módulo POS. Solo maneja tablas POS:…, Maneja la cola de sincronización., Inicializa la tabla de cola., SyncQueue

### Community 155 - "_ValidacionDialogState"
Cohesion: 0.50
Nodes (4): proveedoresProvider, _seccionDoc, _ValidacionDialogState, _ValidacionDialog

### Community 156 - "pos/data.py"
Cohesion: 0.33
Nodes (5): get_existencia_producto(), get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario., Obtiene la existencia actual de un producto en un almacén.

## Knowledge Gaps
- **1109 isolated node(s):** `Config`, `XCTest`, `_db`, `nombre`, `pinHash` (+1104 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **31 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `get_db_adaptive`, `ConfigPOSView`, `ValidacionFields`, `._download_all_from_server`, `ComandaPedidoView`, `show_error`, `stock_view.py`, `._ensure_tables`, `._enqueue_venta`, `InventarioView`, `historial_facturas_view.py`, `whatsapp_notifier.py`, `._enqueue_comanda`, `producciones/data.py`, `POSSyncManager`, `init_local_db`, `.aplicar_movimientos_venta`, `base.py`, `printer.py`, `SyncQueue`, `RecetaEditor`, `SyncManager`, `.delete_receta`, `.get_recetas`, `VentasView`, `pos/data.py`, `producciones/dialogs.py`, `AuditView`, `POSLoginView`, `get_sync_queue`, `.get_producto_by_id`, `.save_componentes`, `periodos.py`, `ComandasView`, `.get_venta_anulada_by_comanda`, `get_colors`?**
  _High betweenness centrality (0.113) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `get_db_adaptive`, `ConfigPOSView`, `._download_all_from_server`, `ComandaPedidoView`, `show_error`, `._ensure_tables`, `._enqueue_venta`, `InventarioView`, `whatsapp_notifier.py`, `._enqueue_comanda`, `producciones/data.py`, `POSSyncManager`, `init_local_db`, `.aplicar_movimientos_venta`, `base.py`, `printer.py`, `SyncQueue`, `SyncManager`, `.delete_receta`, `.get_recetas`, `VentasView`, `RequisicionesView`, `POSLoginView`, `get_sync_queue`, `.get_producto_by_id`, `.save_componentes`, `periodos.py`, `conn.py`, `.get_venta_anulada_by_comanda`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Why does `AppDatabase` connect `AppDatabase` to `configuracion_repository.dart`, `app_database.dart`, `validacion_repository.dart`, `sync_engine.dart`, `login_screen.dart`, `stock_repository.dart`, `requisiciones_repository.dart`, `inventario_repository.dart`, `session_controller.dart`?**
  _High betweenness centrality (0.016) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._