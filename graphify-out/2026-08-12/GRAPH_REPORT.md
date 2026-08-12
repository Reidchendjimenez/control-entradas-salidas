# Graph Report - control-entradas-salidas  (2026-08-12)

## Corpus Check
- 131 files · ~196,720 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1784 nodes · 4425 edges · 78 communities (62 shown, 16 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 77 edges (avg confidence: 0.58)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `72ed32b4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- ConfigPOSView
- get_db_adaptive
- show_error
- base.py
- ComandaPedidoView
- ._render_grid
- stock_view.py
- LocalReplica
- unregister_sync_callback
- Historial de Cambios
- InventarioView
- StockView
- whatsapp_notifier.py
- _colors
- comprobar_y_aplicar_actualizaciones
- get_colors
- ._download_all_from_server
- ._download_all_from_server
- movimientos.py
- ControlEntradasSalidasApp
- cards.py
- HistorialFacturasView
- POSSyncIndicator
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/data.py
- LoadingSplash
- comanda_view.py
- AuditView
- get_safe_colors
- app_launcher.py
- RequisicionesView
- sync_queue.py
- POSSyncManager
- set_page
- RequisicionForm
- usr/init_db.py
- printer.py
- launcher.py
- main_pos.py
- ._go_to_main
- graphify reference: extra exports and benchmark
- .get_producto_by_id
- ._ver_detalle
- _NullStream
- inventario_view.py
- ._confirmar_anulacion
- graphify reference: query, path, explain
- .save_componentes
- .set_pos_setting
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- pos/data.py
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- .delete_receta
- .get_recetas
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- models/__init__.py
- .get_existencias_by_producto
- pos/__init__.py
- lycoris-control

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 212 edges
2. `get_local_conn()` - 179 edges
3. `show_error()` - 72 edges
4. `get_db_adaptive()` - 69 edges
5. `show_success()` - 69 edges
6. `ConfigPOSView` - 61 edges
7. `ComandaPedidoView` - 60 edges
8. `get_sync_queue()` - 55 edges
9. `RequisicionesView` - 50 edges
10. `get_colors()` - 46 edges

## Surprising Connections (you probably didn't know these)
- `main()` --calls--> `get_settings()`  [EXTRACTED]
  usr/app_launcher.py → config/config.py
- `_get_remote_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/archive.py → config/config.py
- `get_local_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/base.py → config/config.py
- `_sync_existencias_supabase_batch()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py
- `totalizar_requisicion()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py

## Import Cycles
- None detected.

## Communities (78 total, 16 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (10): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView, Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para… (+2 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (11): Obtiene categorías POS independientes., Obtiene categorías visibles en el POS., get_pos_sync_indicator(), ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles. (+3 more)

### Community 3 - "get_db_adaptive"
Cohesion: 0.09
Nodes (48): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Constantes de colores para el tema de la aplicación, build_detalle_row(), build_empty_state(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt() (+40 more)

### Community 4 - "show_error"
Cohesion: 0.07
Nodes (41): get_sync_queue(), Obtiene instancia singleton de SyncQueue., Exception, Sistema global de manejo y notificación de errores. Este módulo mantiene…, Muestra el error en consola Y en pantalla como SnackBar rojo., Banner persistente para errores de sincronización., show_error(), show_sync_error() (+33 more)

### Community 5 - "base.py"
Cohesion: 0.06
Nodes (41): check_connection(), get_base(), get_connection_status(), get_db(), get_local_db(), get_local_engine(), get_local_session(), get_session() (+33 more)

### Community 7 - "._render_grid"
Cohesion: 0.16
Nodes (4): Obtiene contornos activos para POS., Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.26
Nodes (9): build_product_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial(), get_stock_stats(), load_categories(), load_products() (+1 more)

### Community 9 - "LocalReplica"
Cohesion: 0.03
Nodes (48): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene requisiciones de la BD local., Verifica el PIN del usuario. (+40 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (44): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+36 more)

### Community 12 - "InventarioView"
Cohesion: 0.06
Nodes (13): Obtiene todas las categorías de la BD local., Obtiene productos de la BD local., create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color(), create_categoria_header(), create_compra_lista_card() (+5 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.10
Nodes (20): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+12 more)

### Community 15 - "_colors"
Cohesion: 0.07
Nodes (55): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, Mostrar mensaje informativo (azul). (+47 more)

### Community 16 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.24
Nodes (11): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), Page, Comprueba, descarga e instala actualizaciones de código de forma dinámica., Lee UPDATE_URL desde .env. Busca en _get_app_dir() (y config/), _MEIPASS, y…, Bloqueante — corre en executor. (+3 more)

### Community 17 - "get_colors"
Cohesion: 0.14
Nodes (5): get_colors(), Helper para obtener colores según el tema de la página, get_colors_safe(), build_ajuste_dialog(), ValidacionView

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+5 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 20 - "movimientos.py"
Cohesion: 0.30
Nodes (9): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+1 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.08
Nodes (14): ControlEntradasSalidasApp, Page, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager., Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, apply_theme_to_button(), apply_theme_to_container() (+6 more)

### Community 22 - "cards.py"
Cohesion: 0.83
Nodes (3): build_producto_item_row(), build_requisicion_card(), _c()

### Community 23 - "HistorialFacturasView"
Cohesion: 0.13
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "POSSyncIndicator"
Cohesion: 0.27
Nodes (3): POSSyncIndicator, Page, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 25 - "RecetaEditor"
Cohesion: 0.06
Nodes (22): delete_receta_dialog(), colors(), fmt_fecha(), Recorta ISO 'YYYY-MM-DDTHH:MM:SS...' a 'YYYY-MM-DD HH:MM'., theme(), build_historial_tab(), Tab Historial: lista de producciones con su estado (completado/cancelada)., Construye el contenido del tab Historial. (+14 more)

### Community 26 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "SyncManager"
Cohesion: 0.06
Nodes (20): Obtiene movimientos que no han sido sincronizados., Marca un movimiento como sincronizado., Obtiene facturas de la BD local., Tras subir una requisición local, actualiza su id local al id remoto para que…, Guarda timestamp del último sync., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata. (+12 more)

### Community 29 - "producciones/data.py"
Cohesion: 0.13
Nodes (21): Actualiza el estado de una producción y encola el cambio para sync., Guarda un detalle de producción., cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta() (+13 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 31 - "comanda_view.py"
Cohesion: 0.16
Nodes (15): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _escpos_ticket(), _get_next_correlativo(), imprimir_comanda(), Genera los bytes ESC/POS para un ticket de comanda. Si correlativo es None se…, Imprime una comanda en la impresora configurada o auto-detectada. Retorna True…, Obtiene el siguiente numero de correlativo y lo incrementa., convertir() (+7 more)

### Community 33 - "get_safe_colors"
Cohesion: 0.40
Nodes (4): build_stat_card(), get_color_mapping(), get_mapped_color(), get_safe_colors()

### Community 34 - "app_launcher.py"
Cohesion: 0.12
Nodes (23): Logger, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, resource_path(), main(), mostrar_error_critico(), Page, check_connection_async(), get_engine() (+15 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.09
Nodes (5): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "sync_queue.py"
Cohesion: 0.10
Nodes (23): BaseSettings, _candidate_env_paths(), Config, Identificador único del dispositivo., Rutas candidatas para buscar .env en orden de prioridad., Construye la URL de conexión a la base de datos de forma segura., Settings, Connection (+15 more)

### Community 37 - "POSSyncManager"
Cohesion: 0.07
Nodes (14): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Obtiene timestamp del último sync. (+6 more)

### Community 38 - "set_page"
Cohesion: 0.33
Nodes (6): Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), Page, Registrar la página activa para mostrar notificaciones., set_page()

### Community 39 - "RequisicionForm"
Cohesion: 0.15
Nodes (3): _c(), RequisicionForm, RequisicionService

### Community 41 - "usr/init_db.py"
Cohesion: 0.15
Nodes (8): Elimina y recrea todas las tablas de la base de datos., reset_database(), Produccion, ProduccionDetalle, Base, Base, Receta, RecetaComponente

### Community 42 - "printer.py"
Cohesion: 0.07
Nodes (39): Obtiene un setting de POS (ej: printer_device)., configurar_impresora(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_comanda_header() (+31 more)

### Community 43 - "launcher.py"
Cohesion: 0.11
Nodes (24): Llamar desde main() antes de cualquier import de BD., set_db_path(), get_pos_sync_manager(), init_pos_sync_manager(), Sincronización bidireccional exclusiva para módulo POS. Solo maneja tablas POS:…, main(), Page, Launcher para el POS con soporte de actualizaciones. (+16 more)

### Community 46 - "main_pos.py"
Cohesion: 0.22
Nodes (9): assets_dir_path(), _get_app_dir(), main(), Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller., Directorio de assets del POS. El favicon del navegador se sirve de…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:… (+1 more)

### Community 47 - "._go_to_main"
Cohesion: 0.32
Nodes (3): Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., LoginView

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 55 - "._ver_detalle"
Cohesion: 0.15
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 56 - "_NullStream"
Cohesion: 0.17
Nodes (6): _get_app_dir(), main(), _NullStream, Page, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…

### Community 57 - "inventario_view.py"
Cohesion: 0.11
Nodes (25): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, _migrate_old_tables(), Réplica local SQLite para trabajo offline. Almacena una copia de los datos de…, Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Guarda un movimiento en la BD local. (+17 more)

### Community 58 - "._confirmar_anulacion"
Cohesion: 0.09
Nodes (9): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta)., Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias. (+1 more)

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 62 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 70 - "pos/data.py"
Cohesion: 0.33
Nodes (5): get_existencia_producto(), get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario., Obtiene la existencia actual de un producto en un almacén.

### Community 85 - "models/__init__.py"
Cohesion: 0.06
Nodes (17): Categoria, Base, CompraListaItem, Base, Existencia, Base, MovimientoArchivo, Base (+9 more)

### Community 90 - ".get_existencias_by_producto"
Cohesion: 0.50
Nodes (3): Obtiene todas las existencias de un producto (sumadas por almacén)., Suma de existencias de un producto en todos los almacenes., stock_total_producto()

## Knowledge Gaps
- **103 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+98 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **16 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `ConfigPOSView`, `get_db_adaptive`, `show_error`, `base.py`, `ComandaPedidoView`, `._render_grid`, `stock_view.py`, `InventarioView`, `StockView`, `whatsapp_notifier.py`, `_colors`, `get_colors`, `._download_all_from_server`, `._download_all_from_server`, `RecetaEditor`, `SyncManager`, `producciones/data.py`, `comanda_view.py`, `AuditView`, `app_launcher.py`, `POSSyncManager`, `printer.py`, `launcher.py`, `._go_to_main`, `.get_producto_by_id`, `._ver_detalle`, `inventario_view.py`, `._confirmar_anulacion`, `.save_componentes`, `.set_pos_setting`, `pos/data.py`, `.delete_receta`, `.get_recetas`, `.get_existencias_by_producto`?**
  _High betweenness centrality (0.396) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `POSLoginView`, `ConfigPOSView`, `get_db_adaptive`, `base.py`, `._render_grid`, `InventarioView`, `whatsapp_notifier.py`, `_colors`, `._download_all_from_server`, `._download_all_from_server`, `SyncManager`, `producciones/data.py`, `app_launcher.py`, `RequisicionesView`, `sync_queue.py`, `POSSyncManager`, `printer.py`, `launcher.py`, `._go_to_main`, `.get_producto_by_id`, `._ver_detalle`, `inventario_view.py`, `._confirmar_anulacion`, `.save_componentes`, `.set_pos_setting`, `.delete_receta`, `.get_recetas`, `.get_existencias_by_producto`?**
  _High betweenness centrality (0.076) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `POSLoginView`, `LocalReplica`, `printer.py`?**
  _High betweenness centrality (0.046) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _103 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05056179775280899 - nodes in this community are weakly interconnected._