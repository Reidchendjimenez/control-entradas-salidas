# Graph Report - control-entradas-salidas  (2026-08-12)

## Corpus Check
- 133 files · ~195,469 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1762 nodes · 4356 edges · 109 communities (69 shown, 40 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 77 edges (avg confidence: 0.58)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `89ba0d59`
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
- get_local_conn
- models/__init__.py
- LocalReplica
- inventario_view.py
- Historial de Cambios
- InventarioView
- stock_view.py
- whatsapp_notifier.py
- _colors
- printer.py
- get_colors
- ._download_all_from_server
- ._download_all_from_server
- show_success
- ControlEntradasSalidasApp
- periodos.py
- HistorialFacturasView
- producciones/dialogs.py
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/data.py
- LoadingSplash
- comanda_view.py
- AuditView
- ProduccionesView
- app_launcher.py
- RequisicionesView
- conn.py
- POSSyncManager
- launcher.py
- Requisicion
- ._confirmar_anulacion
- ConfiguracionView
- .get_pos_setting
- POSSyncIndicator
- comprobar_y_aplicar_actualizaciones
- RequisicionForm
- main_pos.py
- ._go_to_main
- ._ensure_tables
- ._on_sync_indicator_click
- graphify reference: extra exports and benchmark
- .full_sync
- Settings
- .get_producto_by_id
- .get_last_sync
- .get_venta_anulada_by_comanda
- _NullStream
- local_replica.py
- ._enqueue_comanda
- ._upload_pending_movimientos
- graphify reference: query, path, explain
- .save_componentes
- .set_pos_setting
- VisualizeView
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- init_local_db
- pos/data.py
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- graphify.js
- .delete_receta
- .get_productos
- .get_recetas
- AGENTS.md
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- .dedupe_existencias_producto
- .delete_pos_categoria
- .eliminar_usuario_dispositivo
- .get_categoria
- .get_componentes_by_receta
- .get_detalles_by_produccion
- .get_existencias
- .get_existencias_by_producto
- .get_habitaciones_ocupadas
- .get_mesas_ocupadas
- .get_platos
- .get_productos_insumo
- .get_productos_pos
- .get_recetas_que_producen
- .get_subcategorias_by_pos_categoria_padre
- .save_plato
- .update_produccion_estado
- .verificar_pin
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
9. `RequisicionesView` - 47 edges
10. `show_error_with_copy()` - 43 edges

## Surprising Connections (you probably didn't know these)
- `main()` --calls--> `get_settings()`  [EXTRACTED]
  usr/app_launcher.py → config/config.py
- `_get_remote_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/archive.py → config/config.py
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `totalizar_requisicion()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py

## Import Cycles
- None detected.

## Communities (109 total, 40 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (9): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView, MesasView (+1 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Obtiene categorías POS independientes., Obtiene categorías visibles en el POS., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora. (+2 more)

### Community 3 - "get_db_adaptive"
Cohesion: 0.09
Nodes (45): get_db_adaptive(), Generator que proporciona una sesión SQLite local., build_detalle_row(), build_empty_state(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista. (+37 more)

### Community 4 - "show_error"
Cohesion: 0.07
Nodes (42): Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., get_sync_manager(), Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync(), Exception (+34 more)

### Community 5 - "base.py"
Cohesion: 0.07
Nodes (41): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, check_connection(), get_base(), get_connection_status(), get_db(), get_engine() (+33 more)

### Community 6 - "ComandaPedidoView"
Cohesion: 0.10
Nodes (5): Obtiene contornos activos para POS., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 7 - "get_local_conn"
Cohesion: 0.04
Nodes (18): get_local_conn(), Devuelve la lista de almacenes existentes (valores únicos)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene requisiciones de la BD local., Registra el usuario de este dispositivo (solo una vez)., Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None., Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene platos activos para mostrar en POS. (+10 more)

### Community 8 - "models/__init__.py"
Cohesion: 0.06
Nodes (22): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, FacturaPago (+14 more)

### Community 9 - "LocalReplica"
Cohesion: 0.04
Nodes (18): LocalReplica, Tras subir una requisición local, actualiza su id local al id remoto para que…, Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para…, Elimina una venta no impresa y sus movimientos, restaurando el stock., Mapa {id: correlativo} de las ventas indicadas (una sola consulta)., Crea o actualiza una categoría POS independiente., Obtiene una receta por ID., Obtiene categorías de platos. (+10 more)

### Community 10 - "inventario_view.py"
Cohesion: 0.07
Nodes (26): Logger, clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., Registra un callback que se ejecuta después de cada sync. (+18 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (44): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+36 more)

### Community 12 - "InventarioView"
Cohesion: 0.08
Nodes (11): create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color(), get_safe_colors(), create_producto_item_from_dict(), create_categoria_header(), create_compra_lista_card() (+3 more)

### Community 13 - "stock_view.py"
Cohesion: 0.11
Nodes (16): Producto, Base, build_product_card(), build_stat_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial() (+8 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.12
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "_colors"
Cohesion: 0.18
Nodes (24): Cola de sincronización unificada para trabajo offline-first. Maneja: - Cola de…, _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog(), _update_color_preview(), add_to_overlay() (+16 more)

### Community 16 - "printer.py"
Cohesion: 0.09
Nodes (31): configurar_impresora(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_configured_device(), _get_usb_out_endpoint() (+23 more)

### Community 17 - "get_colors"
Cohesion: 0.11
Nodes (11): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Helper para obtener colores según el tema de la página, build_producto_item_row(), build_requisicion_card(), _c(), get_colors_safe(), build_ajuste_dialog() (+3 more)

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+5 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Recalcula las existencias basándose en todos los movimientos. Si hay…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 20 - "show_success"
Cohesion: 0.12
Nodes (19): Mostrar mensaje de éxito (verde)., Mostrar mensaje de advertencia (naranja)., show_success(), show_warning(), _build_almacen_produccion_dd(), _build_negativo_switch(), build_sistema_tab(), confirmar_cambio() (+11 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.10
Nodes (10): ControlEntradasSalidasApp, Page, Apunta las referencias globales al shell de la ruta activa., Construye la ft.View completa para un tab, con su propio shell., Recibe mensajes de progreso del SyncManager., Registra el callback de progreso en el SyncManager., NavigationBar inferior para móvil (persistente en la página)., Deriva page.views a partir de page.route (patrón oficial de Flet). (+2 more)

### Community 22 - "periodos.py"
Cohesion: 0.16
Nodes (25): archivar_en_supabase(), archivar_movimientos(), archivar_movimientos_local(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo… (+17 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "producciones/dialogs.py"
Cohesion: 0.16
Nodes (19): cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente., colors(), fmt_fecha() (+11 more)

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
Cohesion: 0.10
Nodes (9): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado., Notifica a todos los callbacks registrados., Inicia sincronización en segundo plano cada interval_seconds. (+1 more)

### Community 29 - "producciones/data.py"
Cohesion: 0.12
Nodes (23): almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones() (+15 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (11): _find_background_image(), LoadingSplash, Container, Page, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync). (+3 more)

### Community 31 - "comanda_view.py"
Cohesion: 0.13
Nodes (21): _escpos_ticket(), _get_next_correlativo(), imprimir_comanda(), Genera los bytes ESC/POS para un ticket de comanda. Si correlativo es None se…, Imprime una comanda en la impresora configurada o auto-detectada. Retorna True…, Obtiene el siguiente numero de correlativo y lo incrementa., _abrir_url(), convertir() (+13 more)

### Community 32 - "AuditView"
Cohesion: 0.15
Nodes (9): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+1 more)

### Community 33 - "ProduccionesView"
Cohesion: 0.14
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 34 - "app_launcher.py"
Cohesion: 0.13
Nodes (18): _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico() (+10 more)

### Community 36 - "conn.py"
Cohesion: 0.16
Nodes (17): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+9 more)

### Community 38 - "launcher.py"
Cohesion: 0.17
Nodes (17): ensure_local_db(), Asegura que la BD local existe. Llamar después de set_db_path()., get_pos_sync_manager(), init_pos_sync_manager(), main(), Page, Launcher para el POS con soporte de actualizaciones., _resource_path() (+9 more)

### Community 39 - "Requisicion"
Cohesion: 0.14
Nodes (4): Base, Requisicion, RequisicionDetalle, RequisicionService

### Community 40 - "._confirmar_anulacion"
Cohesion: 0.12
Nodes (6): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 42 - ".get_pos_setting"
Cohesion: 0.18
Nodes (9): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _get_comanda_header(), get_correlativo_actual(), _get_header_size(), Lee el correlativo actual sin incrementarlo., Obtiene el tamaño del membrete: 'small', 'normal', 'large'., Obtiene la configuracion del membrete de comanda. (+1 more)

### Community 43 - "POSSyncIndicator"
Cohesion: 0.21
Nodes (5): get_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 44 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.24
Nodes (11): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica., Lee UPDATE_URL. Prioridad: 1. Variable ya cargada en os.environ (config.config… (+3 more)

### Community 46 - "main_pos.py"
Cohesion: 0.22
Nodes (9): assets_dir_path(), _get_app_dir(), main(), Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller., Directorio de assets del POS. El favicon del navegador se sirve de…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:… (+1 more)

### Community 48 - "._ensure_tables"
Cohesion: 0.20
Nodes (5): Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync.

### Community 49 - "._on_sync_indicator_click"
Cohesion: 0.24
Nodes (3): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos.

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - ".full_sync"
Cohesion: 0.22
Nodes (4): Guarda timestamp del último sync., Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Verifica si hay conexión a la base de datos remota.

### Community 52 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Identificador único del dispositivo., Construye la URL de conexión a la base de datos de forma segura., Settings

### Community 53 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 54 - ".get_last_sync"
Cohesion: 0.29
Nodes (3): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 55 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 57 - "local_replica.py"
Cohesion: 0.33
Nodes (5): _migrate_old_tables(), Réplica local SQLite para trabajo offline. Almacena una copia de los datos de…, Migra datos de tablas old (local_*) a tablas nuevas si existen datos en old., Migraciones automáticas para tablas POS., _run_pos_migrations()

### Community 58 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 59 - "._upload_pending_movimientos"
Cohesion: 0.29
Nodes (3): Obtiene movimientos que no han sido sincronizados., Obtiene facturas de la BD local., Loop de sync en background.

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

### Community 69 - "init_local_db"
Cohesion: 0.50
Nodes (3): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Crea todas las tablas locales.

### Community 70 - "pos/data.py"
Cohesion: 0.50
Nodes (3): get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario.

## Knowledge Gaps
- **104 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+99 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **40 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `ConfigPOSView`, `get_db_adaptive`, `show_error`, `base.py`, `ComandaPedidoView`, `get_local_conn`, `inventario_view.py`, `InventarioView`, `stock_view.py`, `whatsapp_notifier.py`, `_colors`, `printer.py`, `get_colors`, `._download_all_from_server`, `._download_all_from_server`, `show_success`, `periodos.py`, `producciones/dialogs.py`, `RecetaEditor`, `SyncManager`, `producciones/data.py`, `comanda_view.py`, `AuditView`, `app_launcher.py`, `POSSyncManager`, `._confirmar_anulacion`, `.get_pos_setting`, `._go_to_main`, `.full_sync`, `.get_producto_by_id`, `.get_last_sync`, `.get_venta_anulada_by_comanda`, `local_replica.py`, `._enqueue_comanda`, `._upload_pending_movimientos`, `.save_componentes`, `.set_pos_setting`, `init_local_db`, `pos/data.py`, `.delete_receta`, `.get_productos`, `.get_recetas`, `.dedupe_existencias_producto`, `.delete_pos_categoria`, `.eliminar_usuario_dispositivo`, `.get_categoria`, `.get_componentes_by_receta`, `.get_detalles_by_produccion`, `.get_existencias`, `.get_existencias_by_producto`, `.get_habitaciones_ocupadas`, `.get_mesas_ocupadas`, `.get_platos`, `.get_productos_insumo`, `.get_productos_pos`, `.get_recetas_que_producen`, `.get_subcategorias_by_pos_categoria_padre`, `.save_plato`, `.update_produccion_estado`, `.verificar_pin`?**
  _High betweenness centrality (0.399) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `ConfigPOSView`, `get_db_adaptive`, `show_error`, `base.py`, `ComandaPedidoView`, `models/__init__.py`, `LocalReplica`, `inventario_view.py`, `InventarioView`, `whatsapp_notifier.py`, `_colors`, `._download_all_from_server`, `._download_all_from_server`, `periodos.py`, `conn.py`, `POSSyncManager`, `._confirmar_anulacion`, `.get_pos_setting`, `._go_to_main`, `._ensure_tables`, `._on_sync_indicator_click`, `.full_sync`, `.get_producto_by_id`, `.get_last_sync`, `.get_venta_anulada_by_comanda`, `local_replica.py`, `._enqueue_comanda`, `._upload_pending_movimientos`, `.save_componentes`, `.set_pos_setting`, `init_local_db`, `.delete_receta`, `.get_productos`, `.get_recetas`, `.dedupe_existencias_producto`, `.delete_pos_categoria`, `.eliminar_usuario_dispositivo`, `.get_categoria`, `.get_componentes_by_receta`, `.get_detalles_by_produccion`, `.get_existencias`, `.get_existencias_by_producto`, `.get_habitaciones_ocupadas`, `.get_mesas_ocupadas`, `.get_platos`, `.get_productos_insumo`, `.get_productos_pos`, `.get_recetas_que_producen`, `.get_subcategorias_by_pos_categoria_padre`, `.save_plato`, `.update_produccion_estado`, `.verificar_pin`?**
  _High betweenness centrality (0.082) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `POSLoginView`, `printer.py`, `.get_pos_setting`, `LocalReplica`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _104 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05172413793103448 - nodes in this community are weakly interconnected._