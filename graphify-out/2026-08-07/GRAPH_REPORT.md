# Graph Report - control-entradas-salidas  (2026-08-07)

## Corpus Check
- 128 files · ~126,448 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1644 nodes · 4150 edges · 87 communities (69 shown, 18 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 68 edges (avg confidence: 0.58)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `d2c3f4d2`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- HistorialFacturasView
- whatsapp_notifier.py
- ComandaPedidoView
- get_db_adaptive
- models/__init__.py
- ConfigPOSView
- producciones/dialogs.py
- LocalReplica
- RecetaEditor
- ._upload_pending_movimientos
- InventarioView
- 📦 Control de Entradas y Salidas - Guía Técnica
- show_error
- requisiciones_view.py
- RequisicionesView
- get_colors
- _colors
- ._download_all_from_server
- VisualizeView
- ._download_all_from_server
- comanda_view.py
- ._log
- What You Must Do When Invoked
- local_replica.py
- periodos.py
- What You Must Do When Invoked
- base.py
- POSSyncIndicator
- printer.py
- POSSyncManager
- get_sync_queue
- show_error
- .get_pos_setting
- AuditView
- get_settings
- .set_pos_setting
- pos/data.py
- comprobar_y_aplicar_actualizaciones
- ._go_to_main
- app_launcher.py
- VentasView
- ProduccionesView
- graphify reference: extra exports and benchmark
- .get_producto_by_id
- .get_last_sync
- .get_venta_anulada_by_comanda
- ._enqueue_comanda
- ValidacionView
- graphify reference: query, path, explain
- launcher.py
- main_pos.py
- ._enqueue_venta
- .aplicar_movimientos_venta
- .save_componentes
- ._load_categorias
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- producciones/data.py
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- install_opencode.sh
- .delete_receta
- register_sync_callback
- .get_recetas
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- movimientos.py
- ConfiguracionView
- _get_page
- .full_sync
- configuracion_view.py
- .get_usuario_dispositivo
- SyncManager
- pos/__init__.py
- lycoris-control

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 208 edges
2. `get_local_conn()` - 175 edges
3. `show_error()` - 72 edges
4. `get_db_adaptive()` - 69 edges
5. `show_success()` - 66 edges
6. `ComandaPedidoView` - 56 edges
7. `ConfigPOSView` - 56 edges
8. `get_sync_queue()` - 54 edges
9. `RequisicionesView` - 47 edges
10. `show_error_with_copy()` - 41 edges

## Surprising Connections (you probably didn't know these)
- `main()` --calls--> `get_settings()`  [EXTRACTED]
  usr/app_launcher.py → config/config.py
- `_get_remote_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/archive.py → config/config.py
- `get_local_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/base.py → config/config.py
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py

## Import Cycles
- None detected.

## Communities (87 total, 18 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.06
Nodes (7): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, POSLoginView, MesasView

### Community 1 - "show_error_with_copy"
Cohesion: 0.05
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 3 - "whatsapp_notifier.py"
Cohesion: 0.13
Nodes (20): Container, Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), count_pending(), delete_from_queue(), format_validation_message() (+12 more)

### Community 5 - "get_db_adaptive"
Cohesion: 0.10
Nodes (20): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Movimiento, Base, Producto, Base, build_product_card(), build_stat_card() (+12 more)

### Community 6 - "models/__init__.py"
Cohesion: 0.06
Nodes (20): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, FacturaPago (+12 more)

### Community 7 - "ConfigPOSView"
Cohesion: 0.07
Nodes (12): Obtiene categorías POS independientes., Obtiene categorías de platos., Obtiene categorías visibles en el POS., ConfigPOSView, Construye el contenido de la pestaña de impresora., Carga la configuracion del membrete y correlativo., Guarda la configuracion del membrete., Establece el correlativo inicial. (+4 more)

### Community 8 - "producciones/dialogs.py"
Cohesion: 0.16
Nodes (19): cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente., colors(), fmt_fecha() (+11 more)

### Community 9 - "LocalReplica"
Cohesion: 0.03
Nodes (47): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), LocalReplica, Obtiene todas las existencias de un producto (sumadas por almacén)., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Tras subir una requisición local, actualiza su id local al id remoto para que… (+39 more)

### Community 10 - "RecetaEditor"
Cohesion: 0.20
Nodes (3): Editor de receta en pantalla completa., Llama control.update() solo si el control ya está añadido a la página., RecetaEditor

### Community 11 - "._upload_pending_movimientos"
Cohesion: 0.18
Nodes (6): Guarda un movimiento en la BD local., Obtiene movimientos que no han sido sincronizados., Marca un movimiento como sincronizado., Obtiene facturas de la BD local., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync()

### Community 12 - "InventarioView"
Cohesion: 0.08
Nodes (13): Obtiene productos de la BD local., al_pasar_mouse(), create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color(), get_safe_colors(), create_categoria_header() (+5 more)

### Community 13 - "📦 Control de Entradas y Salidas - Guía Técnica"
Cohesion: 0.05
Nodes (40): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+32 more)

### Community 14 - "show_error"
Cohesion: 0.08
Nodes (42): FilePickerResultEvent, is_online(), Alias de check_connection() para compatibilidad., Obtiene existencia por producto y almacén., get_pending_movimientos_count(), get_sync_manager(), Obtiene el número de movimientos pendientes de sincronización., Sistema global de manejo y notificación de errores. Este módulo mantiene… (+34 more)

### Community 15 - "requisiciones_view.py"
Cohesion: 0.08
Nodes (47): Existencia, Base, build_detalle_row(), build_empty_state(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista. (+39 more)

### Community 16 - "RequisicionesView"
Cohesion: 0.05
Nodes (10): Base, Requisicion, RequisicionDetalle, RequisicionForm, RequisicionService, Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok). (+2 more)

### Community 17 - "get_colors"
Cohesion: 0.14
Nodes (17): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_colors(), get_theme(), Constantes de colores para el tema de la aplicación, Retorna diccionario de colores según el tema (+9 more)

### Community 18 - "_colors"
Cohesion: 0.25
Nodes (17): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog() (+9 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 21 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+5 more)

### Community 22 - "comanda_view.py"
Cohesion: 0.15
Nodes (19): _escpos_ticket(), _get_next_correlativo(), Genera los bytes ESC/POS para un ticket de comanda. Si correlativo es None se…, Obtiene el siguiente numero de correlativo y lo incrementa., _abrir_url(), convertir(), formatear_bs(), formatear_tasa() (+11 more)

### Community 23 - "._log"
Cohesion: 0.19
Nodes (6): Print + notificar progreso visual., Inicia sincronización en segundo plano cada interval_seconds., Loop de sync en background., Procesa la cola de sync - sube pendientes y descarga cambios., Sube elementos de la cola a Supabase usando SQL directo., Notifica a todos los callbacks registrados.

### Community 24 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 25 - "local_replica.py"
Cohesion: 0.14
Nodes (17): Connection, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no…, Inicializa tablas decache (no sync)., set_cache() (+9 more)

### Community 26 - "periodos.py"
Cohesion: 0.20
Nodes (18): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, _aperturar_periodo() (+10 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "base.py"
Cohesion: 0.15
Nodes (23): check_connection(), get_base(), get_connection_status(), get_db(), get_engine(), get_local_db(), get_local_engine(), get_local_session() (+15 more)

### Community 29 - "POSSyncIndicator"
Cohesion: 0.20
Nodes (7): get_pos_sync_manager(), get_pos_sync_indicator(), init_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 30 - "printer.py"
Cohesion: 0.09
Nodes (35): configurar_impresora(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_configured_device(), get_correlativo_actual() (+27 more)

### Community 32 - "get_sync_queue"
Cohesion: 0.09
Nodes (17): notify_sync_complete(), Notifica a todos los callbacks registrados., get_sync_queue(), Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Maneja la cola de sincronización., Limpia operaciones completadas antiguas. (+9 more)

### Community 33 - "show_error"
Cohesion: 0.17
Nodes (7): ControlEntradasSalidasApp, Page, Recibe mensajes de progreso del SyncManager., Registra el callback de progreso en el SyncManager., Exception, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error()

### Community 34 - ".get_pos_setting"
Cohesion: 0.22
Nodes (6): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _get_comanda_header(), _get_header_size(), Obtiene el tamaño del membrete: 'small', 'normal', 'large'., Obtiene la configuracion del membrete de comanda.

### Community 35 - "AuditView"
Cohesion: 0.21
Nodes (3): AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 36 - "get_settings"
Cohesion: 0.17
Nodes (9): BaseSettings, Config, get_settings(), Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Settings, get_db_path(), init_pos_sync_manager() (+1 more)

### Community 37 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 38 - "pos/data.py"
Cohesion: 0.33
Nodes (5): get_existencia_producto(), get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario., Obtiene la existencia actual de un producto en un almacén.

### Community 39 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.22
Nodes (13): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), _get_app_dir(), Page, Directorio donde guardar datos mutables (.env, version.json, app_updates)., Lee UPDATE_URL desde .env. Busca en _get_app_dir() (y config/), y en… (+5 more)

### Community 41 - "app_launcher.py"
Cohesion: 0.21
Nodes (11): main(), Page, resource_path(), main(), mostrar_error_critico(), Page, Llamar desde main() antes de cualquier import de BD., set_db_path() (+3 more)

### Community 43 - "ProduccionesView"
Cohesion: 0.14
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 44 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 45 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 46 - ".get_last_sync"
Cohesion: 0.29
Nodes (3): Obtiene timestamp del último sync., Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Estado de conexión y sincronización.

### Community 47 - ".get_venta_anulada_by_comanda"
Cohesion: 0.29
Nodes (3): Historial de ventas (mas recientes primero)., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 48 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 50 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 51 - "launcher.py"
Cohesion: 0.15
Nodes (16): Logger, ensure_local_db(), Asegura que la BD local existe. Llamar después de set_db_path()., get_logger(), Módulo de logging centralizado para la aplicación. Proporciona logging a…, Obtiene un logger configurado con handlers para archivo y consola. Args: name:…, main(), Page (+8 more)

### Community 52 - "main_pos.py"
Cohesion: 0.33
Nodes (5): main(), Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller., resource_path()

### Community 53 - "._enqueue_venta"
Cohesion: 0.33
Nodes (3): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta).

### Community 54 - ".aplicar_movimientos_venta"
Cohesion: 0.33
Nodes (3): Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 55 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 56 - "._load_categorias"
Cohesion: 0.20
Nodes (3): Obtiene platos activos para mostrar en POS., Obtiene contornos activos para POS., Categorias de platos (sin padre) excluyendo las de contornos.

### Community 57 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 58 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 59 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 61 - "producciones/data.py"
Cohesion: 0.12
Nodes (20): Actualiza el estado de una producción y encola el cambio para sync., Guarda un detalle de producción., cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_producciones() (+12 more)

### Community 66 - "register_sync_callback"
Cohesion: 0.14
Nodes (7): clear_all_callbacks(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Limpia todos los callbacks registrados., Registra un callback que se ejecuta después de cada sync., register_sync_callback(), unregister_sync_callback()

### Community 71 - "movimientos.py"
Cohesion: 0.24
Nodes (11): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+3 more)

### Community 73 - "_get_page"
Cohesion: 0.22
Nodes (10): Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Obtiene la página activa desde sys o desde la pila de llamadas., Mostrar banner persistente que requiere acción del usuario. Tipos: 'success',…, Limpiar todas las notificaciones activas. (+2 more)

### Community 74 - ".full_sync"
Cohesion: 0.22
Nodes (4): Guarda timestamp del último sync., Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Verifica si hay conexión a la base de datos remota.

### Community 75 - "configuracion_view.py"
Cohesion: 0.50
Nodes (5): build_proveedores_tab(), filter_proveedores(), load_proveedores(), render_proveedores(), show_proveedor_dialog()

### Community 76 - ".get_usuario_dispositivo"
Cohesion: 0.33
Nodes (4): init_local_db(), Devuelve el usuario registrado en este dispositivo, o None., Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Crea todas las tablas locales.

### Community 86 - "SyncManager"
Cohesion: 0.14
Nodes (5): Registra función a llamar con cada paso del sync (msg: str)., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado., SyncManager

## Knowledge Gaps
- **99 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+94 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **18 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `whatsapp_notifier.py`, `ComandaPedidoView`, `get_db_adaptive`, `ConfigPOSView`, `producciones/dialogs.py`, `RecetaEditor`, `._upload_pending_movimientos`, `InventarioView`, `show_error`, `requisiciones_view.py`, `get_colors`, `_colors`, `._download_all_from_server`, `._download_all_from_server`, `comanda_view.py`, `local_replica.py`, `periodos.py`, `base.py`, `printer.py`, `POSSyncManager`, `get_sync_queue`, `.get_pos_setting`, `AuditView`, `get_settings`, `.set_pos_setting`, `pos/data.py`, `._go_to_main`, `app_launcher.py`, `VentasView`, `.get_producto_by_id`, `.get_last_sync`, `.get_venta_anulada_by_comanda`, `._enqueue_comanda`, `ValidacionView`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `._load_categorias`, `producciones/data.py`, `.delete_receta`, `.get_recetas`, `.full_sync`, `configuracion_view.py`, `.get_usuario_dispositivo`, `SyncManager`?**
  _High betweenness centrality (0.414) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `POSLoginView`, `whatsapp_notifier.py`, `ConfigPOSView`, `._upload_pending_movimientos`, `InventarioView`, `show_error`, `requisiciones_view.py`, `RequisicionesView`, `._download_all_from_server`, `._download_all_from_server`, `local_replica.py`, `periodos.py`, `POSSyncManager`, `get_sync_queue`, `.get_pos_setting`, `get_settings`, `.set_pos_setting`, `._go_to_main`, `VentasView`, `.get_producto_by_id`, `.get_last_sync`, `.get_venta_anulada_by_comanda`, `._enqueue_comanda`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `._load_categorias`, `producciones/data.py`, `.delete_receta`, `.get_recetas`, `.full_sync`, `.get_usuario_dispositivo`?**
  _High betweenness centrality (0.075) - this node is a cross-community bridge._
- **Why does `SyncManager` connect `SyncManager` to `get_sync_queue`, `models/__init__.py`, `LocalReplica`, `.full_sync`, `._upload_pending_movimientos`, `show_error`, `.get_last_sync`, `._download_all_from_server`, `._log`, `base.py`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _99 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.06467661691542288 - nodes in this community are weakly interconnected._