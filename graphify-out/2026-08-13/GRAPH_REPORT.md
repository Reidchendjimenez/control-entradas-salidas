# Graph Report - control-entradas-salidas  (2026-08-13)

## Corpus Check
- 137 files · ~198,757 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1807 nodes · 4482 edges · 112 communities (72 shown, 40 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.59)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1ef87032`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ComandasView
- show_error_with_copy
- ConfigPOSView
- requisiciones_view.py
- POSLoginView
- ._go_to_main
- producciones/data.py
- ComandaPedidoView
- stock_view.py
- show_error
- ._ensure_tables
- Historial de Cambios
- InventarioView
- schedule_load
- validacion_view.py
- show_success
- comprobar_y_aplicar_actualizaciones
- get_colors
- ._download_all_from_server
- ._download_all_from_server
- launcher.py
- ControlEntradasSalidasApp
- get_sync_queue
- HistorialFacturasView
- VentasView
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/dialogs.py
- LoadingSplash
- ._enqueue_comanda
- AuditView
- periodos.py
- app_launcher.py
- RequisicionesView
- conn.py
- POSSyncManager
- get_local_conn
- get_db_adaptive
- ._enqueue_venta
- movimientos.py
- printer.py
- .aplicar_movimientos_venta
- .get_platos_categorias
- BandejaWhatsAppView
- main_pos.py
- .set_pos_setting
- init_local_db
- _colors
- graphify reference: extra exports and benchmark
- .get_existencias_by_producto_almacen
- .get_producto_by_id
- Requisicion
- .get_venta_anulada_by_comanda
- _NullStream
- .get_subcategorias_by_categoria_padre
- ConfiguracionView
- form.py
- graphify reference: query, path, explain
- .save_componentes
- run_when_connected
- LocalReplica
- Settings
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- theme.py
- .save_categorias
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- .dedupe_existencias_producto
- .delete_receta
- get_sync_manager
- .get_recetas
- .delete_plato_categoria
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- requisiciones/components.py
- graphify.js
- base.py
- AGENTS.md
- ._do_totalizar
- ._build_mensaje
- .delete_pos_categoria
- .eliminar_venta_y_movimientos
- .get_almacenes
- .get_comanda_abierta
- .get_mesas_ocupadas
- .get_platos_pos
- .get_productos_insumo
- .get_proveedor_by_nombre
- .get_requisiciones
- .get_ventas_correlativos
- .registrar_usuario_dispositivo
- .save_plato_contornos
- pos/__init__.py
- lycoris-control
- .save_pos_categoria
- .update_produccion_cantidad
- .verificar_pin

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 212 edges
2. `get_local_conn()` - 179 edges
3. `show_error()` - 73 edges
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
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `_sync_existencias_supabase_batch()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py

## Import Cycles
- None detected.

## Communities (112 total, 40 thin omitted)

### Community 0 - "ComandasView"
Cohesion: 0.09
Nodes (7): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, MesasView

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Crea o actualiza una categoría de plato., Obtiene categorías visibles en el POS., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora. (+2 more)

### Community 3 - "requisiciones_view.py"
Cohesion: 0.18
Nodes (19): build_detalle_row(), build_producto_busqueda_item(), get_almacenes(), get_detalles(), get_productos_activos(), build_agregar_producto_dialog(), build_agregar_producto_req_dialog(), build_buscador_productos() (+11 more)

### Community 6 - "producciones/data.py"
Cohesion: 0.10
Nodes (23): Obtiene los componentes de una receta., Guarda un detalle de producción., Obtiene productos de la BD local., cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes() (+15 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.10
Nodes (5): Obtiene contornos activos para POS., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.13
Nodes (13): build_product_card(), build_stat_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_stock_stats(), load_categories(), load_products() (+5 more)

### Community 9 - "show_error"
Cohesion: 0.13
Nodes (23): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Page, Sistema centralizado de notificaciones para la aplicación. Proporciona… (+15 more)

### Community 10 - "._ensure_tables"
Cohesion: 0.20
Nodes (5): Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync.

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.09
Nodes (9): create_categoria_card(), create_categoria_card_from_dict(), get_safe_colors(), create_producto_item_from_dict(), get_almacenes(), create_categoria_header(), create_compra_lista_card(), InventarioView (+1 more)

### Community 13 - "schedule_load"
Cohesion: 0.09
Nodes (9): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., schedule_load() (+1 more)

### Community 14 - "validacion_view.py"
Cohesion: 0.16
Nodes (17): Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, count_pending(), delete_from_queue(), format_validation_message(), _get_queue_conn(), get_queued_messages(), process_queue_now(), Módulo para enviar notificaciones a WhatsApp desde Python Uso el servidor… (+9 more)

### Community 15 - "show_success"
Cohesion: 0.15
Nodes (21): Mostrar mensaje de éxito (verde)., Mostrar mensaje de advertencia (naranja)., Mostrar mensaje informativo (azul)., show_info(), show_success(), show_warning(), _build_almacen_produccion_dd(), _build_negativo_switch() (+13 more)

### Community 16 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.24
Nodes (11): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica., Lee UPDATE_URL. Prioridad: 1. Variable ya cargada en os.environ (config.config… (+3 more)

### Community 17 - "get_colors"
Cohesion: 0.16
Nodes (6): Registra un callback que se ejecuta después de cada sync., register_sync_callback(), get_colors(), Helper para obtener colores según el tema de la página, get_colors_safe(), ValidacionView

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (12): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+4 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync., Bulk upsert plato_ingredientes para sync. (+5 more)

### Community 20 - "launcher.py"
Cohesion: 0.07
Nodes (33): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., get_pos_sync_manager(), main(), Page, Launcher para el POS con soporte de actualizaciones., _resource_path(), get_pos_sync_indicator(), init_pos_sync_indicator() (+25 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.07
Nodes (20): ControlEntradasSalidasApp, Page, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager., Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de… (+12 more)

### Community 22 - "get_sync_queue"
Cohesion: 0.08
Nodes (32): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, check_connection(), get_connection_status(), get_local_db(), get_local_engine(), get_local_session() (+24 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "VentasView"
Cohesion: 0.16
Nodes (3): formatear_bs(), Formatea un monto en bolivares estilo venezolano: 1.234,56., VentasView

### Community 25 - "RecetaEditor"
Cohesion: 0.08
Nodes (6): Editor de receta en pantalla completa., Selector de producto con buscador (estilo sección de componentes). Muestra un…, Llama control.update() solo si el control ya está añadido a la página., RecetaEditor, ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 26 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "SyncManager"
Cohesion: 0.07
Nodes (17): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado. (+9 more)

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.14
Nodes (22): productos_producidos(), Productos resultantes de una producción = detalles tipo 'entrada'. Retorna…, cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente. (+14 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 31 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 33 - "periodos.py"
Cohesion: 0.17
Nodes (22): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, Recalcula las existencias basándose en todos los movimientos. Si hay… (+14 more)

### Community 34 - "app_launcher.py"
Cohesion: 0.12
Nodes (23): Logger, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, resource_path(), main(), mostrar_error_critico(), Page, check_connection_async(), get_engine() (+15 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.10
Nodes (5): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "conn.py"
Cohesion: 0.15
Nodes (19): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+11 more)

### Community 37 - "POSSyncManager"
Cohesion: 0.11
Nodes (6): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Guarda timestamp del último sync., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 38 - "get_local_conn"
Cohesion: 0.04
Nodes (17): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene movimientos que no han sido sincronizados., Tras subir una requisición local, actualiza su id local al id remoto para que…, Resetea el usuario (para cambio de operador). (+9 more)

### Community 39 - "get_db_adaptive"
Cohesion: 0.13
Nodes (26): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Existencia, Base, get_productos_activos(), Obtiene todos los productos activos del inventario., buscar_productos(), _cantidad_unidad_item() (+18 more)

### Community 40 - "._enqueue_venta"
Cohesion: 0.33
Nodes (3): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta).

### Community 41 - "movimientos.py"
Cohesion: 0.22
Nodes (12): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+4 more)

### Community 42 - "printer.py"
Cohesion: 0.07
Nodes (45): Obtiene un setting de POS (ej: printer_device)., configurar_impresora(), _escpos_ticket(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers() (+37 more)

### Community 43 - ".aplicar_movimientos_venta"
Cohesion: 0.33
Nodes (3): Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 45 - "BandejaWhatsAppView"
Cohesion: 0.22
Nodes (4): Control, BandejaWhatsAppView, _notify_error(), Container

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 48 - "init_local_db"
Cohesion: 0.50
Nodes (3): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Crea todas las tablas locales.

### Community 49 - "_colors"
Cohesion: 0.19
Nodes (23): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog() (+15 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - ".get_existencias_by_producto_almacen"
Cohesion: 0.50
Nodes (3): Obtiene existencia por producto y almacén., get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén.

### Community 53 - ".get_producto_by_id"
Cohesion: 0.16
Nodes (6): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene una categoría por ID., Obtiene un producto por ID., Obtiene existencias de la BD local., Lee datos de la BD local y retorna (items, colors).

### Community 54 - "Requisicion"
Cohesion: 0.14
Nodes (5): Base, Requisicion, RequisicionDetalle, build_empty_state(), VisualizeView

### Community 55 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 56 - "_NullStream"
Cohesion: 0.17
Nodes (6): _get_app_dir(), main(), _NullStream, Page, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…

### Community 59 - "form.py"
Cohesion: 0.16
Nodes (3): _c(), RequisicionForm, RequisicionService

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 63 - "LocalReplica"
Cohesion: 0.04
Nodes (18): LocalReplica, Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene facturas de la BD local., Retorna el set de habitacion_id que tienen comandas abiertas., Obtiene todos los platos con su categoría., Crea o actualiza un plato y sus ingredientes., Elimina un plato y sus ingredientes., Obtiene todos los contornos (platos con es_contorno=1). (+10 more)

### Community 64 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Settings

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - "theme.py"
Cohesion: 0.29
Nodes (6): Constantes de colores para el tema de la aplicación, get_card_bg(), generar_color(), build_producto_item_row(), build_requisicion_card(), _c()

### Community 70 - ".save_categorias"
Cohesion: 0.33
Nodes (3): Guarda categorías en la base de datos local (upsert, no borra)., Obtiene todas las categorías de la BD local., Lee caché local y (si hay conexión) consulta el servidor. Corre en hilo aparte…

### Community 77 - "get_sync_manager"
Cohesion: 0.16
Nodes (14): is_online(), Alias de check_connection() para compatibilidad., Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., get_sync_manager(), Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync(), get_attr() (+6 more)

### Community 83 - "requisiciones/components.py"
Cohesion: 0.47
Nodes (5): build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., contar_detalles()

### Community 85 - "base.py"
Cohesion: 0.06
Nodes (28): get_base(), get_db(), Base de datos - SQLite como única fuente de verdad. El sistema ahora funciona…, Generator que proporciona una sesión SQLite local. Esta es la única fuente de…, Categoria, Base, CompraListaItem, Base (+20 more)

## Knowledge Gaps
- **105 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **40 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `ComandasView`, `show_error_with_copy`, `ConfigPOSView`, `POSLoginView`, `._go_to_main`, `producciones/data.py`, `ComandaPedidoView`, `stock_view.py`, `show_error`, `InventarioView`, `validacion_view.py`, `show_success`, `get_colors`, `._download_all_from_server`, `._download_all_from_server`, `launcher.py`, `get_sync_queue`, `VentasView`, `RecetaEditor`, `SyncManager`, `producciones/dialogs.py`, `._enqueue_comanda`, `AuditView`, `periodos.py`, `app_launcher.py`, `POSSyncManager`, `get_local_conn`, `get_db_adaptive`, `._enqueue_venta`, `printer.py`, `.aplicar_movimientos_venta`, `.get_platos_categorias`, `BandejaWhatsAppView`, `.set_pos_setting`, `init_local_db`, `_colors`, `.get_existencias_by_producto_almacen`, `.crear_pos_usuario`, `.get_producto_by_id`, `.get_venta_anulada_by_comanda`, `.get_subcategorias_by_categoria_padre`, `.save_componentes`, `.save_categorias`, `.dedupe_existencias_producto`, `.delete_receta`, `get_sync_manager`, `.get_recetas`, `.delete_plato_categoria`, `base.py`, `.delete_pos_categoria`, `.eliminar_venta_y_movimientos`, `.get_almacenes`, `.get_comanda_abierta`, `.get_mesas_ocupadas`, `.get_platos_pos`, `.get_productos_insumo`, `.get_proveedor_by_nombre`, `.get_requisiciones`, `.get_ventas_correlativos`, `.registrar_usuario_dispositivo`, `.save_plato_contornos`, `.save_pos_categoria`, `.update_produccion_cantidad`, `.verificar_pin`?**
  _High betweenness centrality (0.372) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `ComandasView`, `ConfigPOSView`, `requisiciones_view.py`, `._go_to_main`, `producciones/data.py`, `ComandaPedidoView`, `show_error`, `._ensure_tables`, `InventarioView`, `validacion_view.py`, `._download_all_from_server`, `._download_all_from_server`, `get_sync_queue`, `VentasView`, `SyncManager`, `._enqueue_comanda`, `periodos.py`, `RequisicionesView`, `conn.py`, `POSSyncManager`, `._enqueue_venta`, `printer.py`, `.aplicar_movimientos_venta`, `.get_platos_categorias`, `.set_pos_setting`, `init_local_db`, `.get_existencias_by_producto_almacen`, `.crear_pos_usuario`, `.get_producto_by_id`, `.get_venta_anulada_by_comanda`, `.get_subcategorias_by_categoria_padre`, `.save_componentes`, `LocalReplica`, `.save_categorias`, `.dedupe_existencias_producto`, `.delete_receta`, `get_sync_manager`, `.get_recetas`, `.delete_plato_categoria`, `base.py`, `.delete_pos_categoria`, `.eliminar_venta_y_movimientos`, `.get_almacenes`, `.get_comanda_abierta`, `.get_mesas_ocupadas`, `.get_platos_pos`, `.get_productos_insumo`, `.get_proveedor_by_nombre`, `.get_requisiciones`, `.get_ventas_correlativos`, `.registrar_usuario_dispositivo`, `.save_plato_contornos`, `.save_pos_categoria`, `.update_produccion_cantidad`, `.verificar_pin`?**
  _High betweenness centrality (0.096) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `ComandasView`, `printer.py`, `LocalReplica`?**
  _High betweenness centrality (0.044) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _105 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ComandasView` be split into smaller, more focused modules?**
  _Cohesion score 0.08687943262411348 - nodes in this community are weakly interconnected._