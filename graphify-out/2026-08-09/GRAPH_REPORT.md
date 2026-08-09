# Graph Report - control-entradas-salidas  (2026-08-09)

## Corpus Check
- 132 files · ~192,585 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1732 nodes · 4344 edges · 110 communities (73 shown, 37 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 78 edges (avg confidence: 0.58)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `c85dc115`
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
- get_local_conn
- RecetaEditor
- ControlEntradasSalidasApp
- InventarioView
- 📦 Control de Entradas y Salidas - Guía Técnica
- show_error
- requisiciones_view.py
- RequisicionesView
- Producto
- periodos.py
- ._download_all_from_server
- comanda_view.py
- ._download_all_from_server
- SyncQueue
- .get_venta_anulada_by_comanda
- What You Must Do When Invoked
- SyncManager
- Requisicion
- What You Must Do When Invoked
- base.py
- POSSyncIndicator
- printer.py
- POSSyncManager
- launcher.py
- ValidacionView
- is_online
- AuditView
- Settings
- producciones/data.py
- inventario_view.py
- comprobar_y_aplicar_actualizaciones
- ._go_to_main
- app_launcher.py
- register_sync_callback
- sistema.py
- graphify reference: extra exports and benchmark
- LocalReplica
- LoadingSplash
- RequisicionForm
- ._enqueue_comanda
- .delete_receta
- graphify reference: query, path, explain
- ProduccionesView
- main_pos.py
- ._enqueue_venta
- .aplicar_movimientos_venta
- .save_componentes
- get_colors
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- ._load_requisiciones
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- install_opencode.sh
- get_sync_queue
- get_cache_conn
- .get_recetas
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- ProduccionesView
- views/config.py
- ._build_compras_lista_data
- VisualizeView
- _frozen_runtime_hook.py
- StockView
- ConfiguracionView
- .verificar_pin
- ._load_categorias
- ._on_categoria_click
- .eliminar_venta_y_movimientos
- get_db_adaptive
- .get_categorias
- movimientos.py
- historial_facturas_view.py
- .get_categorias_pos
- get_safe_colors
- error_handler.py
- .dedupe_existencias_producto
- pos/__init__.py
- lycoris-control
- .get_comanda_abierta
- .clear_categorias
- .clear_productos
- .get_mesas_ocupadas
- .get_detalles_by_produccion
- .get_platos
- .get_productos_insumo
- .migrate_proveedores_from_facturas
- .get_proveedor_by_nombre
- .save_plato_contornos
- .update_produccion_cantidad

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 213 edges
2. `get_local_conn()` - 178 edges
3. `show_error()` - 75 edges
4. `show_success()` - 71 edges
5. `get_db_adaptive()` - 69 edges
6. `ComandaPedidoView` - 56 edges
7. `ConfigPOSView` - 56 edges
8. `get_sync_queue()` - 55 edges
9. `RequisicionesView` - 47 edges
10. `show_error_with_copy()` - 43 edges

## Surprising Connections (you probably didn't know these)
- `main()` --calls--> `get_settings()`  [EXTRACTED]
  usr/app_launcher.py → config/config.py
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

## Communities (110 total, 37 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (8): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, POSLoginView, MesasView, VentasView

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 3 - "validacion_view.py"
Cohesion: 0.13
Nodes (20): Container, Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), count_pending(), delete_from_queue(), format_validation_message() (+12 more)

### Community 5 - "stock_view.py"
Cohesion: 0.30
Nodes (8): filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial(), get_stock_stats(), load_categories(), load_products(), load_warehouses()

### Community 6 - "models/__init__.py"
Cohesion: 0.08
Nodes (16): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, MovimientoArchivo, Base (+8 more)

### Community 7 - "ConfigPOSView"
Cohesion: 0.07
Nodes (12): Obtiene categorías POS independientes., Obtiene categorías de platos., get_pos_sync_indicator(), ConfigPOSView, Construye el contenido de la pestaña de impresora., Carga la configuracion del membrete y correlativo., Guarda la configuracion del membrete., Establece el correlativo inicial. (+4 more)

### Community 8 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (19): cancelar_produccion_dialog(), delete_receta_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., colors(), fmt_fecha(), Recorta ISO 'YYYY-MM-DDTHH:MM:SS...' a 'YYYY-MM-DD HH:MM'., build_historial_tab() (+11 more)

### Community 9 - "get_local_conn"
Cohesion: 0.05
Nodes (16): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), Devuelve la lista de almacenes existentes (valores únicos)., Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene facturas de la BD local., Resetea el usuario (para cambio de operador). (+8 more)

### Community 10 - "RecetaEditor"
Cohesion: 0.18
Nodes (4): Editor de receta en pantalla completa., Selector de producto con buscador (estilo sección de componentes). Muestra un…, Llama control.update() solo si el control ya está añadido a la página., RecetaEditor

### Community 11 - "ControlEntradasSalidasApp"
Cohesion: 0.18
Nodes (4): ControlEntradasSalidasApp, Page, Recibe mensajes de progreso del SyncManager., Registra el callback de progreso en el SyncManager.

### Community 12 - "InventarioView"
Cohesion: 0.11
Nodes (5): get_sync_manager(), create_categoria_header(), create_compra_lista_card(), InventarioView, Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 13 - "📦 Control de Entradas y Salidas - Guía Técnica"
Cohesion: 0.05
Nodes (40): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+32 more)

### Community 14 - "show_error"
Cohesion: 0.10
Nodes (23): clear_notifications(), _get_colors(), _get_page(), Sistema centralizado de notificaciones para la aplicación. Proporciona…, Obtiene la página activa desde sys o desde la pila de llamadas., Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., Mostrar mensaje de advertencia (naranja). (+15 more)

### Community 15 - "requisiciones_view.py"
Cohesion: 0.19
Nodes (19): build_detalle_row(), build_producto_busqueda_item(), get_almacenes(), get_detalles(), get_productos_activos(), build_agregar_producto_dialog(), build_agregar_producto_req_dialog(), build_buscador_productos() (+11 more)

### Community 16 - "RequisicionesView"
Cohesion: 0.10
Nodes (5): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 17 - "Producto"
Cohesion: 0.22
Nodes (7): Producto, Base, get_existencia_producto(), get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario., Obtiene la existencia actual de un producto en un almacén.

### Community 18 - "periodos.py"
Cohesion: 0.23
Nodes (17): archivar_en_supabase(), archivar_movimientos(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, _aperturar_periodo(), build_periodos_tab(), _do_aperturar(), _do_forzar_archivo() (+9 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Recalcula las existencias basándose en todos los movimientos. Si hay…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 20 - "comanda_view.py"
Cohesion: 0.11
Nodes (20): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _escpos_ticket(), _get_comanda_header(), get_correlativo_actual(), _get_header_size(), _get_next_correlativo(), Lee el correlativo actual sin incrementarlo. (+12 more)

### Community 21 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+5 more)

### Community 22 - "SyncQueue"
Cohesion: 0.10
Nodes (10): Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Maneja la cola de sincronización., Guarda timestamp del último sync., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Inicializa la tabla de cola. (+2 more)

### Community 23 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero)., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 24 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 25 - "SyncManager"
Cohesion: 0.08
Nodes (18): Marca un movimiento como sincronizado., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Fuerza una sincronización inmediata., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync. (+10 more)

### Community 26 - "Requisicion"
Cohesion: 0.17
Nodes (4): Base, Requisicion, RequisicionDetalle, RequisicionService

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "base.py"
Cohesion: 0.07
Nodes (37): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, _get_remote_engine(), guardar_periodo_en_supabase(), Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, check_connection(), get_base() (+29 more)

### Community 29 - "POSSyncIndicator"
Cohesion: 0.27
Nodes (3): POSSyncIndicator, Page, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 30 - "printer.py"
Cohesion: 0.13
Nodes (23): _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_configured_device(), _get_usb_out_endpoint(), imprimir_comanda() (+15 more)

### Community 31 - "POSSyncManager"
Cohesion: 0.13
Nodes (5): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene timestamp del último sync., Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Estado de conexión y sincronización.

### Community 32 - "launcher.py"
Cohesion: 0.13
Nodes (22): get_pos_sync_manager(), main(), Page, Launcher para el POS con soporte de actualizaciones., _resource_path(), init_pos_sync_indicator(), Barra de progreso global del POS. Aparece en la parte superior de todas las…, _abrir_url() (+14 more)

### Community 34 - "is_online"
Cohesion: 0.12
Nodes (11): is_online(), Alias de check_connection() para compatibilidad., Factura, FacturaPago, Base, Base, Proveedor, Base (+3 more)

### Community 36 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Identificador único del dispositivo., Construye la URL de conexión a la base de datos de forma segura., Settings

### Community 37 - "producciones/data.py"
Cohesion: 0.10
Nodes (28): Actualiza el estado de una producción y encola el cambio para sync., Guarda un detalle de producción., Obtiene un producto por ID., almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle() (+20 more)

### Community 38 - "inventario_view.py"
Cohesion: 0.13
Nodes (21): Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Guarda un movimiento en la BD local., al_pasar_mouse(), create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), show_agregar_producto_dialog() (+13 more)

### Community 39 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.24
Nodes (11): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), Page, Comprueba, descarga e instala actualizaciones de código de forma dinámica., Lee UPDATE_URL desde .env. Busca en _get_app_dir() (y config/), _MEIPASS, y…, Bloqueante — corre en executor. (+3 more)

### Community 40 - "._go_to_main"
Cohesion: 0.21
Nodes (6): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 41 - "app_launcher.py"
Cohesion: 0.10
Nodes (25): Logger, _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main() (+17 more)

### Community 42 - "register_sync_callback"
Cohesion: 0.12
Nodes (9): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., Registra un callback que se ejecuta después de cada sync., register_sync_callback() (+1 more)

### Community 43 - "sistema.py"
Cohesion: 0.29
Nodes (12): _build_almacen_produccion_dd(), _build_negativo_switch(), build_sistema_tab(), confirmar_cambio(), _do_test_supabase(), on_cambiar_operador(), on_verificar_pin_cambio(), Lanza la verificación de Supabase en un hilo (no bloquea la UI). (+4 more)

### Community 44 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 45 - "LocalReplica"
Cohesion: 0.05
Nodes (16): LocalReplica, Obtiene movimientos que no han sido sincronizados., Tras subir una requisición local, actualiza su id local al id remoto para que…, Obtiene requisiciones de la BD local., Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para…, Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion. (+8 more)

### Community 46 - "LoadingSplash"
Cohesion: 0.12
Nodes (9): _find_background_image(), LoadingSplash, Page, Splash a pantalla completa con fondo (imagen estática) y UI animada., Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5')., Marca el 100% y detiene las animaciones. (+1 more)

### Community 48 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 50 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 52 - "main_pos.py"
Cohesion: 0.22
Nodes (9): assets_dir_path(), _get_app_dir(), main(), Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller., Directorio de assets del POS. El favicon del navegador se sirve de…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:… (+1 more)

### Community 53 - "._enqueue_venta"
Cohesion: 0.33
Nodes (3): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta).

### Community 54 - ".aplicar_movimientos_venta"
Cohesion: 0.33
Nodes (3): Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 55 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 56 - "get_colors"
Cohesion: 0.23
Nodes (10): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Helper para obtener colores según el tema de la página, build_producto_item_row(), build_requisicion_card(), _c(), get_colors_safe(), build_ajuste_dialog() (+2 more)

### Community 57 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 58 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 59 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 61 - "._load_requisiciones"
Cohesion: 0.27
Nodes (6): build_empty_state(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., contar_detalles()

### Community 65 - "get_sync_queue"
Cohesion: 0.16
Nodes (29): get_sync_queue(), Cola de sincronización unificada para trabajo offline-first. Maneja: - Cola de…, Obtiene instancia singleton de SyncQueue., Exception, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error(), _create_categoria_card(), create_categoria_grid() (+21 more)

### Community 66 - "get_cache_conn"
Cohesion: 0.16
Nodes (16): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+8 more)

### Community 71 - "ProduccionesView"
Cohesion: 0.12
Nodes (5): Obtiene los componentes de una receta., Obtiene productos de la BD local., load_productos(), _colors(), ProduccionesView

### Community 72 - "views/config.py"
Cohesion: 0.19
Nodes (11): Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., configurar_impresora(), Guarda el tamaño del membrete: 'small', 'normal', 'large'., Guarda el dispositivo de impresora configurado., Configura el dispositivo de impresora a usar., Guarda la configuracion del membrete., Establece el valor inicial del correlativo., set_comanda_header() (+3 more)

### Community 73 - "._build_compras_lista_data"
Cohesion: 0.33
Nodes (3): Obtiene una categoría por ID., Obtiene existencias de la BD local., Lee datos de la BD local y retorna (items, colors).

### Community 80 - "._on_categoria_click"
Cohesion: 0.21
Nodes (5): Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Obtiene platos activos para mostrar en POS., Obtiene productos del POS: activos y marcados para la venta., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 82 - "get_db_adaptive"
Cohesion: 0.16
Nodes (22): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Existencia, Base, buscar_productos(), _cantidad_unidad_item(), crear_ajuste_stock(), eliminar_requisicion() (+14 more)

### Community 84 - "movimientos.py"
Cohesion: 0.36
Nodes (8): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,…

### Community 85 - "historial_facturas_view.py"
Cohesion: 0.16
Nodes (13): get_pending_movimientos_count(), Obtiene el número de movimientos pendientes de sincronización., apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_theme(), Constantes de colores para el tema de la aplicación, Retorna diccionario de colores según el tema (+5 more)

### Community 87 - "get_safe_colors"
Cohesion: 0.54
Nodes (4): build_stat_card(), get_color_mapping(), get_mapped_color(), get_safe_colors()

### Community 88 - "error_handler.py"
Cohesion: 0.29
Nodes (6): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), Page, Registrar la página activa para mostrar notificaciones., set_page()

## Knowledge Gaps
- **99 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+94 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `validacion_view.py`, `ComandaPedidoView`, `stock_view.py`, `ConfigPOSView`, `producciones/dialogs.py`, `get_local_conn`, `RecetaEditor`, `InventarioView`, `show_error`, `Producto`, `periodos.py`, `._download_all_from_server`, `comanda_view.py`, `._download_all_from_server`, `SyncQueue`, `.get_venta_anulada_by_comanda`, `SyncManager`, `base.py`, `printer.py`, `POSSyncManager`, `launcher.py`, `ValidacionView`, `AuditView`, `producciones/data.py`, `inventario_view.py`, `._go_to_main`, `app_launcher.py`, `sistema.py`, `._enqueue_comanda`, `.delete_receta`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `get_colors`, `get_sync_queue`, `.get_recetas`, `ProduccionesView`, `views/config.py`, `._build_compras_lista_data`, `StockView`, `.verificar_pin`, `._load_categorias`, `._on_categoria_click`, `.eliminar_venta_y_movimientos`, `get_db_adaptive`, `.get_categorias`, `historial_facturas_view.py`, `.get_categorias_pos`, `.dedupe_existencias_producto`, `.get_comanda_abierta`, `.clear_categorias`, `.clear_productos`, `.get_mesas_ocupadas`, `.get_detalles_by_produccion`, `.get_platos`, `.get_productos_insumo`, `.migrate_proveedores_from_facturas`, `.get_proveedor_by_nombre`, `.save_plato_contornos`, `.update_produccion_cantidad`?**
  _High betweenness centrality (0.433) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `validacion_view.py`, `ConfigPOSView`, `InventarioView`, `requisiciones_view.py`, `RequisicionesView`, `periodos.py`, `._download_all_from_server`, `comanda_view.py`, `._download_all_from_server`, `SyncQueue`, `.get_venta_anulada_by_comanda`, `SyncManager`, `base.py`, `POSSyncManager`, `is_online`, `producciones/data.py`, `inventario_view.py`, `._go_to_main`, `LocalReplica`, `._enqueue_comanda`, `.delete_receta`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `get_sync_queue`, `get_cache_conn`, `.get_recetas`, `ProduccionesView`, `views/config.py`, `._build_compras_lista_data`, `.verificar_pin`, `._load_categorias`, `._on_categoria_click`, `.eliminar_venta_y_movimientos`, `.get_categorias`, `.get_categorias_pos`, `.dedupe_existencias_producto`, `.get_comanda_abierta`, `.clear_categorias`, `.clear_productos`, `.get_mesas_ocupadas`, `.get_detalles_by_produccion`, `.get_platos`, `.get_productos_insumo`, `.migrate_proveedores_from_facturas`, `.get_proveedor_by_nombre`, `.save_plato_contornos`, `.update_produccion_cantidad`?**
  _High betweenness centrality (0.084) - this node is a cross-community bridge._
- **Why does `SyncManager` connect `SyncManager` to `models/__init__.py`, `app_launcher.py`, `InventarioView`, `LocalReplica`, `._download_all_from_server`, `SyncQueue`, `base.py`, `POSSyncManager`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Are the 19 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 19 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _99 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05393000573723465 - nodes in this community are weakly interconnected._