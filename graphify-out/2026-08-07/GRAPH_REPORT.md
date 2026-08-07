# Graph Report - control-entradas-salidas  (2026-08-07)

## Corpus Check
- 129 files · ~157,801 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1679 nodes · 4217 edges · 109 communities (78 shown, 31 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 69 edges (avg confidence: 0.57)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `083e9926`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- HistorialFacturasView
- validacion_view.py
- ComandaPedidoView
- stock_view.py
- models/__init__.py
- ConfigPOSView
- producciones/dialogs.py
- LocalReplica
- RecetaEditor
- show_error
- InventarioView
- 📦 Control de Entradas y Salidas - Guía Técnica
- show_error
- get_db_adaptive
- RequisicionesView
- pos/data.py
- is_online
- ._download_all_from_server
- comanda_view.py
- ._download_all_from_server
- SyncQueue
- .get_venta_anulada_by_comanda
- What You Must Do When Invoked
- SyncManager
- Existencia
- What You Must Do When Invoked
- base.py
- POSSyncIndicator
- printer.py
- POSSyncManager
- database/__init__.py
- ValidacionView
- ._upload_pending_movimientos
- AuditView
- get_settings
- producciones/data.py
- inventario_view.py
- comprobar_y_aplicar_actualizaciones
- ._go_to_main
- app_launcher.py
- register_sync_callback
- .get_last_sync
- graphify reference: extra exports and benchmark
- .get_producto_by_id
- LoadingSplash
- .full_sync
- ._enqueue_comanda
- .delete_receta
- graphify reference: query, path, explain
- ProduccionesView
- main_pos.py
- ._enqueue_venta
- .aplicar_movimientos_venta
- .save_componentes
- VisualizeView
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- .set_pos_setting
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- install_opencode.sh
- _colors
- local_replica.py
- .get_recetas
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- show_agregar_producto_dialog
- views/config.py
- .delete_plato_categoria
- .get_requisiciones
- get_sync_manager
- StockView
- ConfiguracionView
- .verificar_pin
- ._load_categorias
- .get_productos_pos
- get_sync_queue
- guardar_requisicion
- tasa_cambio.py
- movimientos.py
- get_colors
- ._log
- get_safe_colors
- error_handler.py
- pos/__init__.py
- lycoris-control
- almacen_produccion_default
- .clear_categorias
- .clear_productos
- .get_componentes_by_receta
- .get_detalles_by_produccion
- .get_existencias
- .get_proveedor_by_nombre
- .migrate_proveedores_from_facturas
- .save_plato
- .save_plato_contornos
- .update_produccion_cantidad

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 211 edges
2. `get_local_conn()` - 177 edges
3. `show_error()` - 73 edges
4. `get_db_adaptive()` - 69 edges
5. `show_success()` - 67 edges
6. `ComandaPedidoView` - 56 edges
7. `ConfigPOSView` - 56 edges
8. `get_sync_queue()` - 55 edges
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

## Communities (109 total, 31 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (8): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, POSLoginView, MesasView, VentasView

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 3 - "validacion_view.py"
Cohesion: 0.13
Nodes (20): Container, Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), count_pending(), delete_from_queue(), format_validation_message() (+12 more)

### Community 5 - "stock_view.py"
Cohesion: 0.26
Nodes (9): build_product_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial(), get_stock_stats(), load_categories(), load_products() (+1 more)

### Community 6 - "models/__init__.py"
Cohesion: 0.06
Nodes (22): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, FacturaPago (+14 more)

### Community 7 - "ConfigPOSView"
Cohesion: 0.07
Nodes (13): Obtiene categorías POS independientes., Obtiene categorías de platos., Obtiene categorías visibles en el POS., get_pos_sync_indicator(), ConfigPOSView, Construye el contenido de la pestaña de impresora., Carga la configuracion del membrete y correlativo., Guarda la configuracion del membrete. (+5 more)

### Community 8 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (20): cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente., colors(), fmt_fecha() (+12 more)

### Community 9 - "LocalReplica"
Cohesion: 0.04
Nodes (33): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Tras subir una requisición local, actualiza su id local al id remoto para que… (+25 more)

### Community 10 - "RecetaEditor"
Cohesion: 0.18
Nodes (4): Editor de receta en pantalla completa., Selector de producto con buscador (estilo sección de componentes). Muestra un…, Llama control.update() solo si el control ya está añadido a la página., RecetaEditor

### Community 11 - "show_error"
Cohesion: 0.17
Nodes (7): ControlEntradasSalidasApp, Page, Recibe mensajes de progreso del SyncManager., Registra el callback de progreso en el SyncManager., Exception, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error()

### Community 12 - "InventarioView"
Cohesion: 0.10
Nodes (7): Obtiene todas las categorías de la BD local., get_safe_colors(), create_categoria_header(), create_compra_lista_card(), InventarioView, Lee datos de la BD local y retorna (items, colors)., Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 13 - "📦 Control de Entradas y Salidas - Guía Técnica"
Cohesion: 0.05
Nodes (40): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+32 more)

### Community 14 - "show_error"
Cohesion: 0.09
Nodes (30): FilePickerResultEvent, clear_notifications(), _get_colors(), _get_page(), Sistema centralizado de notificaciones para la aplicación. Proporciona…, Obtiene la página activa desde sys o desde la pila de llamadas., Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo). (+22 more)

### Community 15 - "get_db_adaptive"
Cohesion: 0.11
Nodes (36): get_db_adaptive(), Generator que proporciona una sesión SQLite local., build_detalle_row(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura. (+28 more)

### Community 16 - "RequisicionesView"
Cohesion: 0.10
Nodes (6): build_empty_state(), Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 17 - "pos/data.py"
Cohesion: 0.33
Nodes (5): get_existencia_producto(), get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario., Obtiene la existencia actual de un producto en un almacén.

### Community 18 - "is_online"
Cohesion: 0.17
Nodes (22): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, is_online() (+14 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.06
Nodes (15): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+7 more)

### Community 20 - "comanda_view.py"
Cohesion: 0.20
Nodes (12): _escpos_ticket(), _get_next_correlativo(), Genera los bytes ESC/POS para un ticket de comanda. Si correlativo es None se…, Obtiene el siguiente numero de correlativo y lo incrementa., convertir(), formatear_bs(), formatear_tasa(), get_tasa() (+4 more)

### Community 21 - "._download_all_from_server"
Cohesion: 0.07
Nodes (12): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Recalcula las existencias basándose en todos los movimientos. Si hay…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+4 more)

### Community 22 - "SyncQueue"
Cohesion: 0.12
Nodes (9): Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Maneja la cola de sincronización., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Agrega una operación a la cola de sync., SyncQueue (+1 more)

### Community 23 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero)., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 24 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 25 - "SyncManager"
Cohesion: 0.14
Nodes (5): Registra función a llamar con cada paso del sync (msg: str)., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado., SyncManager

### Community 26 - "Existencia"
Cohesion: 0.09
Nodes (11): Existencia, Base, Base, Requisicion, RequisicionDetalle, build_producto_item_row(), build_requisicion_card(), _c() (+3 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "base.py"
Cohesion: 0.14
Nodes (18): check_connection(), get_base(), get_connection_status(), get_db(), get_local_db(), get_local_session(), get_session(), get_session_local() (+10 more)

### Community 29 - "POSSyncIndicator"
Cohesion: 0.27
Nodes (3): POSSyncIndicator, Page, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 30 - "printer.py"
Cohesion: 0.12
Nodes (25): configurar_impresora(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_usb_out_endpoint(), imprimir_comanda() (+17 more)

### Community 32 - "database/__init__.py"
Cohesion: 0.14
Nodes (19): get_engine(), get_local_engine(), Obtiene el motor de la base de datos local SQLite. Recrea el motor si la ruta…, Alias de get_local_engine() para compatibilidad., Llamar desde main() antes de cualquier import de BD., set_db_path(), get_pos_sync_manager(), init_pos_sync_manager() (+11 more)

### Community 34 - "._upload_pending_movimientos"
Cohesion: 0.18
Nodes (6): Guarda un movimiento en la BD local., Obtiene movimientos que no han sido sincronizados., Marca un movimiento como sincronizado., Obtiene facturas de la BD local., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync()

### Community 36 - "get_settings"
Cohesion: 0.13
Nodes (12): BaseSettings, Config, get_settings(), Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Settings, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, get_db_path() (+4 more)

### Community 37 - "producciones/data.py"
Cohesion: 0.13
Nodes (20): Actualiza el estado de una producción y encola el cambio para sync., Guarda un detalle de producción., cancelar_produccion(), ejecutar_descargo(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones() (+12 more)

### Community 38 - "inventario_view.py"
Cohesion: 0.16
Nodes (18): Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., al_pasar_mouse(), create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), show_cantidad_dialog(), show_correccion_dialog() (+10 more)

### Community 39 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.22
Nodes (13): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), _get_app_dir(), Page, Directorio donde guardar datos mutables (.env, version.json, app_updates)., Lee UPDATE_URL desde .env. Busca en _get_app_dir() (y config/), y en… (+5 more)

### Community 40 - "._go_to_main"
Cohesion: 0.21
Nodes (6): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 41 - "app_launcher.py"
Cohesion: 0.21
Nodes (11): main(), Page, resource_path(), main(), mostrar_error_critico(), Page, ensure_local_db(), Asegura que la BD local existe. Llamar después de set_db_path(). (+3 more)

### Community 42 - "register_sync_callback"
Cohesion: 0.12
Nodes (9): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., Registra un callback que se ejecuta después de cada sync., register_sync_callback() (+1 more)

### Community 43 - ".get_last_sync"
Cohesion: 0.29
Nodes (3): Obtiene timestamp del último sync., Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Estado de conexión y sincronización.

### Community 44 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 45 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 46 - "LoadingSplash"
Cohesion: 0.11
Nodes (10): _find_background_image(), LoadingSplash, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5')., Marca el 100% y detiene las animaciones. (+2 more)

### Community 47 - ".full_sync"
Cohesion: 0.29
Nodes (3): Guarda timestamp del último sync., Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata.

### Community 48 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 50 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 51 - "ProduccionesView"
Cohesion: 0.13
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

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

### Community 57 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 58 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 59 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 61 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 65 - "_colors"
Cohesion: 0.30
Nodes (13): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog(), confirm_delete() (+5 more)

### Community 66 - "local_replica.py"
Cohesion: 0.15
Nodes (16): Connection, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no…, Inicializa tablas decache (no sync)., set_cache(), get_cache_conn() (+8 more)

### Community 71 - "show_agregar_producto_dialog"
Cohesion: 0.50
Nodes (3): Obtiene productos de la BD local., show_agregar_producto_dialog(), load_productos()

### Community 72 - "views/config.py"
Cohesion: 0.12
Nodes (16): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _get_comanda_header(), _get_configured_device(), get_correlativo_actual(), _get_header_size(), Lee el correlativo actual sin incrementarlo., Obtiene el tamaño del membrete: 'small', 'normal', 'large'. (+8 more)

### Community 75 - "get_sync_manager"
Cohesion: 0.18
Nodes (9): Logger, get_pending_movimientos_count(), get_sync_manager(), Obtiene el número de movimientos pendientes de sincronización., get_logger(), Módulo de logging centralizado para la aplicación. Proporciona logging a…, Obtiene un logger configurado con handlers para archivo y consola. Args: name:…, get_theme() (+1 more)

### Community 76 - "StockView"
Cohesion: 0.18
Nodes (3): Producto, Base, StockView

### Community 79 - "._load_categorias"
Cohesion: 0.16
Nodes (4): Obtiene platos activos para mostrar en POS., Obtiene contornos activos para POS., Categorias de platos (sin padre) excluyendo las de contornos., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 81 - "get_sync_queue"
Cohesion: 0.28
Nodes (12): get_sync_queue(), Obtiene instancia singleton de SyncQueue., save_categoria(), delete_logic(), trigger_sync(), save_producto(), build_proveedores_tab(), filter_proveedores() (+4 more)

### Community 82 - "guardar_requisicion"
Cohesion: 0.22
Nodes (11): _cantidad_unidad_item(), _encolar_requisicion_sync(), guardar_requisicion(), _nombre_detalle(), 1. Lee stock local desde SQLite. 2. Crea movimientos de salida (origen) y…, Devuelve (cantidad, unidad) efectivos del item. - Pesables: la cantidad es el…, Encola la requisición (y sus detalles) para subirla a Supabase y así poder…, Crea o actualiza una requisición y sus detalles. - Si `editando` se pasa, se… (+3 more)

### Community 83 - "tasa_cambio.py"
Cohesion: 0.29
Nodes (9): _abrir_url(), obtener_tasa_bcv(), _obtener_tasa_fallback(), _obtener_tasa_sitio_oficial(), Tasa de cambio USD -> Bs (bolivares) oficial del BCV. La tasa oficial la…, Respaldo: consulta la tasa USD en la API de bcv.today., Descarga una URL con User-Agent real y reintento sin verificar SSL., Consulta la tasa oficial del BCV (Bs por USD) desde el sitio oficial. Lanza… (+1 more)

### Community 84 - "movimientos.py"
Cohesion: 0.31
Nodes (8): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,…

### Community 85 - "get_colors"
Cohesion: 0.17
Nodes (13): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_colors(), Constantes de colores para el tema de la aplicación, Aplica el tema a un Container, Aplica el tema a un TextField (+5 more)

### Community 86 - "._log"
Cohesion: 0.16
Nodes (7): Print + notificar progreso visual., Inicia sincronización en segundo plano cada interval_seconds., Loop de sync en background., Procesa la cola de sync - sube pendientes y descarga cambios., Sube elementos de la cola a Supabase usando SQL directo., Notifica a todos los callbacks registrados., Verifica si hay conexión a la base de datos remota.

### Community 87 - "get_safe_colors"
Cohesion: 0.44
Nodes (4): build_stat_card(), get_color_mapping(), get_mapped_color(), get_safe_colors()

### Community 88 - "error_handler.py"
Cohesion: 0.29
Nodes (6): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), Page, Registrar la página activa para mostrar notificaciones., set_page()

### Community 99 - "almacen_produccion_default"
Cohesion: 0.40
Nodes (5): almacen_produccion_default(), load_componentes(), planificar_descargo(), Calcula los ingredientes a descargar. Para recetas compuestas usa los…, Almacén por defecto para la descarga de materia prima de una producción. Se lee…

## Knowledge Gaps
- **99 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+94 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **31 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `validacion_view.py`, `ComandaPedidoView`, `stock_view.py`, `ConfigPOSView`, `producciones/dialogs.py`, `RecetaEditor`, `InventarioView`, `show_error`, `get_db_adaptive`, `pos/data.py`, `is_online`, `._download_all_from_server`, `comanda_view.py`, `._download_all_from_server`, `SyncQueue`, `.get_venta_anulada_by_comanda`, `SyncManager`, `base.py`, `printer.py`, `POSSyncManager`, `database/__init__.py`, `ValidacionView`, `._upload_pending_movimientos`, `AuditView`, `get_settings`, `producciones/data.py`, `inventario_view.py`, `._go_to_main`, `app_launcher.py`, `.get_last_sync`, `.get_producto_by_id`, `.full_sync`, `._enqueue_comanda`, `.delete_receta`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `.set_pos_setting`, `_colors`, `local_replica.py`, `.get_recetas`, `show_agregar_producto_dialog`, `views/config.py`, `.delete_plato_categoria`, `.get_requisiciones`, `StockView`, `.verificar_pin`, `._load_categorias`, `.get_productos_pos`, `get_sync_queue`, `tasa_cambio.py`, `get_colors`, `.clear_categorias`, `.clear_productos`, `.get_componentes_by_receta`, `.get_detalles_by_produccion`, `.get_existencias`, `.get_proveedor_by_nombre`, `.migrate_proveedores_from_facturas`, `.save_plato`, `.save_plato_contornos`, `.update_produccion_cantidad`?**
  _High betweenness centrality (0.404) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `POSLoginView`, `validacion_view.py`, `ConfigPOSView`, `InventarioView`, `get_db_adaptive`, `RequisicionesView`, `is_online`, `._download_all_from_server`, `._download_all_from_server`, `SyncQueue`, `.get_venta_anulada_by_comanda`, `POSSyncManager`, `database/__init__.py`, `._upload_pending_movimientos`, `get_settings`, `producciones/data.py`, `inventario_view.py`, `._go_to_main`, `.get_last_sync`, `.get_producto_by_id`, `.full_sync`, `._enqueue_comanda`, `.delete_receta`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `.set_pos_setting`, `local_replica.py`, `.get_recetas`, `show_agregar_producto_dialog`, `views/config.py`, `.delete_plato_categoria`, `.get_requisiciones`, `.verificar_pin`, `._load_categorias`, `.get_productos_pos`, `.clear_categorias`, `.clear_productos`, `.get_componentes_by_receta`, `.get_detalles_by_produccion`, `.get_existencias`, `.get_proveedor_by_nombre`, `.migrate_proveedores_from_facturas`, `.save_plato`, `.save_plato_contornos`, `.update_produccion_cantidad`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `POSLoginView`, `LocalReplica`, `views/config.py`?**
  _High betweenness centrality (0.045) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _99 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05350140056022409 - nodes in this community are weakly interconnected._