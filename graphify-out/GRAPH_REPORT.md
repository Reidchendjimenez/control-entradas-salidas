# Graph Report - control-entradas-salidas  (2026-08-10)

## Corpus Check
- 132 files · ~193,505 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1734 nodes · 4324 edges · 114 communities (73 shown, 41 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 77 edges (avg confidence: 0.58)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `ff6f3201`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- HistorialFacturasView
- validacion_view.py
- ComandaPedidoView
- .get_pos_setting
- .get_producto_by_id
- ConfigPOSView
- get_colors
- get_local_conn
- producciones/data.py
- show_error
- InventarioView
- Historial de Cambios
- launcher.py
- SyncQueue
- RequisicionesView
- get_db_adaptive
- get_sync_queue
- ._download_all_from_server
- SyncManager
- ._download_all_from_server
- ProduccionesView
- show_error
- What You Must Do When Invoked
- printer.py
- periodos.py
- What You Must Do When Invoked
- base.py
- notifications.py
- ._go_to_main
- POSSyncManager
- error_handler.py
- models/__init__.py
- get_settings
- show_warning
- .clear_productos
- producciones/dialogs.py
- usr/init_db.py
- Requisicion
- views/config.py
- requisiciones/data.py
- Receta
- _colors
- graphify reference: extra exports and benchmark
- LocalReplica
- LoadingSplash
- get_sync_manager
- app_launcher.py
- .get_facturas
- graphify reference: query, path, explain
- .save_componentes
- main_pos.py
- ._confirmar_anulacion
- movimientos.py
- .get_categorias_pos
- historial_facturas_view.py
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- app_controller.py
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- install_opencode.sh
- RequisicionService
- Factura
- .get_recetas
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- RecetaEditor
- VisualizeView
- comanda_view.py
- _frozen_runtime_hook.py
- inventario_view.py
- ._build_compras_lista_data
- show_agregar_producto_dialog
- .get_venta_anulada_by_comanda
- .delete_receta
- register_sync_callback
- Movimiento
- Proveedor
- .dedupe_existencias_producto
- requisiciones_view.py
- .delete_plato_categoria
- ._enqueue_comanda
- .get_contornos
- .eliminar_usuario_dispositivo
- pos/__init__.py
- lycoris-control
- .get_existencias_by_producto
- .delete_plato
- .get_habitaciones_ocupadas
- ._load_categorias
- .get_proveedores
- .get_movimientos
- .get_platos_categorias
- .save_produccion_detalle
- .get_productos_insumo
- .get_proveedor_by_nombre
- .get_subcategorias_by_categoria_padre
- .migrate_proveedores_from_facturas
- .save_plato_contornos
- .update_produccion_cantidad
- .update_produccion_estado
- RequisicionForm

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
- `get_local_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/base.py → config/config.py
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py

## Import Cycles
- None detected.

## Communities (114 total, 41 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (9): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView, MesasView (+1 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 3 - "validacion_view.py"
Cohesion: 0.06
Nodes (29): Container, Control, clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados. (+21 more)

### Community 4 - "ComandaPedidoView"
Cohesion: 0.10
Nodes (6): Obtiene platos activos para mostrar en POS., Obtiene contornos activos para POS., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 5 - ".get_pos_setting"
Cohesion: 0.13
Nodes (16): Obtiene un setting de POS (ej: printer_device)., _escpos_ticket(), _get_comanda_header(), _get_configured_device(), get_correlativo_actual(), _get_header_size(), _get_next_correlativo(), Lee el correlativo actual sin incrementarlo. (+8 more)

### Community 6 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 7 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Obtiene categorías POS independientes., get_pos_sync_indicator(), ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora. (+2 more)

### Community 8 - "get_colors"
Cohesion: 0.15
Nodes (17): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_colors(), get_theme(), Constantes de colores para el tema de la aplicación, Retorna diccionario de colores según el tema (+9 more)

### Community 9 - "get_local_conn"
Cohesion: 0.05
Nodes (15): get_local_conn(), Obtiene movimientos que no han sido sincronizados., Verifica el PIN del usuario., Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para…, Elimina una venta no impresa y sus movimientos, restaurando el stock., Crea o actualiza una categoría POS independiente., Elimina una categoría POS si no tiene sub-categorias., Obtiene sub-categorias (platos_categorias) de una categoria POS. (+7 more)

### Community 10 - "producciones/data.py"
Cohesion: 0.11
Nodes (26): almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones() (+18 more)

### Community 11 - "show_error"
Cohesion: 0.17
Nodes (7): ControlEntradasSalidasApp, Page, Recibe mensajes de progreso del SyncManager., Registra el callback de progreso en el SyncManager., Exception, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error()

### Community 13 - "Historial de Cambios"
Cohesion: 0.05
Nodes (43): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+35 more)

### Community 14 - "launcher.py"
Cohesion: 0.13
Nodes (14): get_pos_sync_manager(), init_pos_sync_manager(), Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), main(), Page, Launcher para el POS con soporte de actualizaciones. (+6 more)

### Community 15 - "SyncQueue"
Cohesion: 0.11
Nodes (10): Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Maneja la cola de sincronización., Guarda timestamp del último sync., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Agrega una operación a la cola de sync. (+2 more)

### Community 16 - "RequisicionesView"
Cohesion: 0.09
Nodes (5): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 17 - "get_db_adaptive"
Cohesion: 0.10
Nodes (18): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Producto, Base, get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario., build_product_card() (+10 more)

### Community 18 - "get_sync_queue"
Cohesion: 0.14
Nodes (23): _migrate_old_tables(), Réplica local SQLite para trabajo offline. Almacena una copia de los datos de…, Migra datos de tablas old (local_*) a tablas nuevas si existen datos en old., Migraciones automáticas para tablas POS., _run_pos_migrations(), get_sync_queue(), init_sync_storage(), Cola de sincronización unificada para trabajo offline-first. Maneja: - Cola de… (+15 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Recalcula las existencias basándose en todos los movimientos. Si hay…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 20 - "SyncManager"
Cohesion: 0.08
Nodes (18): Marca un movimiento como sincronizado., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Fuerza una sincronización inmediata., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync. (+10 more)

### Community 21 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+5 more)

### Community 23 - "show_error"
Cohesion: 0.17
Nodes (19): main(), Page, Devuelve la lista de almacenes existentes (valores únicos)., Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., show_error(), show_success(), _build_almacen_produccion_dd() (+11 more)

### Community 24 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 25 - "printer.py"
Cohesion: 0.14
Nodes (21): _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_usb_out_endpoint(), imprimir_comanda(), listar_impresoras() (+13 more)

### Community 26 - "periodos.py"
Cohesion: 0.16
Nodes (25): archivar_en_supabase(), archivar_movimientos(), archivar_movimientos_local(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo… (+17 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "base.py"
Cohesion: 0.14
Nodes (24): Script único para migrar datos POS existentes a Supabase. Agrega todos los…, check_connection(), get_base(), get_connection_status(), get_db(), get_engine(), get_local_db(), get_local_engine() (+16 more)

### Community 29 - "notifications.py"
Cohesion: 0.26
Nodes (11): clear_notifications(), _get_colors(), _get_page(), Sistema centralizado de notificaciones para la aplicación. Proporciona…, Obtiene la página activa desde sys o desde la pila de llamadas., Mostrar banner persistente que requiere acción del usuario. Tipos: 'success',…, Limpiar todas las notificaciones activas., Obtener colores del tema (soporta tema claro/oscuro). (+3 more)

### Community 30 - "._go_to_main"
Cohesion: 0.21
Nodes (6): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 31 - "POSSyncManager"
Cohesion: 0.13
Nodes (5): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene timestamp del último sync., Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Estado de conexión y sincronización.

### Community 32 - "error_handler.py"
Cohesion: 0.40
Nodes (4): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Page, Registrar la página activa para mostrar notificaciones., set_page()

### Community 33 - "models/__init__.py"
Cohesion: 0.14
Nodes (8): Categoria, Base, CompraListaItem, Base, FacturaPago, Base, MovimientoArchivo, Base

### Community 34 - "get_settings"
Cohesion: 0.09
Nodes (16): BaseSettings, Config, get_settings(), Identificador único del dispositivo., Construye la URL de conexión a la base de datos de forma segura., Settings, Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Guarda un movimiento en la BD local. (+8 more)

### Community 35 - "show_warning"
Cohesion: 0.16
Nodes (5): Mostrar mensaje de advertencia (naranja)., show_warning(), AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 37 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (19): cancelar_produccion_dialog(), delete_receta_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., colors(), fmt_fecha(), Recorta ISO 'YYYY-MM-DDTHH:MM:SS...' a 'YYYY-MM-DD HH:MM'., build_historial_tab() (+11 more)

### Community 38 - "usr/init_db.py"
Cohesion: 0.24
Nodes (5): Elimina y recrea todas las tablas de la base de datos., reset_database(), Produccion, ProduccionDetalle, Base

### Community 39 - "Requisicion"
Cohesion: 0.27
Nodes (3): Base, Requisicion, RequisicionDetalle

### Community 40 - "views/config.py"
Cohesion: 0.16
Nodes (12): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., configurar_impresora(), Guarda el tamaño del membrete: 'small', 'normal', 'large'., Guarda el dispositivo de impresora configurado., Configura el dispositivo de impresora a usar., Guarda la configuracion del membrete., Establece el valor inicial del correlativo. (+4 more)

### Community 41 - "requisiciones/data.py"
Cohesion: 0.13
Nodes (22): Existencia, Base, buscar_productos(), _cantidad_unidad_item(), crear_ajuste_stock(), eliminar_requisicion(), _encolar_requisicion_sync(), get_requisicion_audit_data() (+14 more)

### Community 42 - "Receta"
Cohesion: 0.40
Nodes (3): Base, Receta, RecetaComponente

### Community 43 - "_colors"
Cohesion: 0.17
Nodes (12): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), confirm_delete(), _colors() (+4 more)

### Community 44 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 45 - "LocalReplica"
Cohesion: 0.05
Nodes (16): LocalReplica, Tras subir una requisición local, actualiza su id local al id remoto para que…, Obtiene requisiciones de la BD local., Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None., Retorna el set de mesa_id que tienen comandas abiertas., Mapa {id: correlativo} de las ventas indicadas (una sola consulta)., Obtiene todos los platos con su categoría., Crea o actualiza un plato y sus ingredientes. (+8 more)

### Community 46 - "LoadingSplash"
Cohesion: 0.11
Nodes (10): _find_background_image(), LoadingSplash, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada., Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5'). (+2 more)

### Community 47 - "get_sync_manager"
Cohesion: 0.15
Nodes (16): is_online(), Alias de check_connection() para compatibilidad., Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., get_sync_manager(), get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén., show_cantidad_dialog() (+8 more)

### Community 48 - "app_launcher.py"
Cohesion: 0.11
Nodes (24): _get_app_dir(), Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), Text, main(), mostrar_error_critico(), Page (+16 more)

### Community 50 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 51 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 52 - "main_pos.py"
Cohesion: 0.22
Nodes (9): assets_dir_path(), _get_app_dir(), main(), Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller., Directorio de assets del POS. El favicon del navegador se sirve de…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:… (+1 more)

### Community 53 - "._confirmar_anulacion"
Cohesion: 0.12
Nodes (6): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 54 - "movimientos.py"
Cohesion: 0.27
Nodes (10): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+2 more)

### Community 56 - "historial_facturas_view.py"
Cohesion: 0.17
Nodes (17): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+9 more)

### Community 57 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 58 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 59 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 61 - "app_controller.py"
Cohesion: 0.40
Nodes (4): Logger, get_logger(), Módulo de logging centralizado para la aplicación. Proporciona logging a…, Obtiene un logger configurado con handlers para archivo y consola. Args: name:…

### Community 71 - "RecetaEditor"
Cohesion: 0.18
Nodes (4): Editor de receta en pantalla completa., Selector de producto con buscador (estilo sección de componentes). Muestra un…, Llama control.update() solo si el control ya está añadido a la página., RecetaEditor

### Community 72 - "VisualizeView"
Cohesion: 0.33
Nodes (3): get_detalles(), Construye el texto de la requisición para compartir por WhatsApp., VisualizeView

### Community 74 - "comanda_view.py"
Cohesion: 0.14
Nodes (20): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _abrir_url(), actualizar_tasa(), convertir(), formatear_tasa(), get_diagnostico(), get_tasa(), obtener_tasa_bcv() (+12 more)

### Community 76 - "inventario_view.py"
Cohesion: 0.35
Nodes (6): create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color(), create_producto_item_from_dict(), get_almacenes()

### Community 77 - "._build_compras_lista_data"
Cohesion: 0.33
Nodes (4): create_categoria_header(), create_compra_lista_card(), Lee datos de la BD local y retorna (items, colors)., Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 78 - "show_agregar_producto_dialog"
Cohesion: 0.50
Nodes (3): Obtiene productos de la BD local., show_agregar_producto_dialog(), load_productos()

### Community 79 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 81 - "register_sync_callback"
Cohesion: 0.29
Nodes (6): Registra un callback que se ejecuta después de cada sync., register_sync_callback(), build_stat_card(), get_color_mapping(), get_mapped_color(), get_safe_colors()

### Community 85 - "requisiciones_view.py"
Cohesion: 0.15
Nodes (24): build_detalle_row(), build_empty_state(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., contar_detalles() (+16 more)

### Community 87 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

## Knowledge Gaps
- **102 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+97 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **41 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `validacion_view.py`, `ComandaPedidoView`, `.get_pos_setting`, `.get_producto_by_id`, `ConfigPOSView`, `get_colors`, `get_local_conn`, `producciones/data.py`, `InventarioView`, `SyncQueue`, `get_db_adaptive`, `get_sync_queue`, `._download_all_from_server`, `SyncManager`, `._download_all_from_server`, `show_error`, `printer.py`, `periodos.py`, `base.py`, `._go_to_main`, `POSSyncManager`, `get_settings`, `show_warning`, `.clear_productos`, `producciones/dialogs.py`, `views/config.py`, `requisiciones/data.py`, `_colors`, `get_sync_manager`, `app_launcher.py`, `.get_facturas`, `.save_componentes`, `._confirmar_anulacion`, `.get_categorias_pos`, `.get_recetas`, `RecetaEditor`, `comanda_view.py`, `inventario_view.py`, `show_agregar_producto_dialog`, `.get_venta_anulada_by_comanda`, `.delete_receta`, `.dedupe_existencias_producto`, `.delete_plato_categoria`, `._enqueue_comanda`, `.get_contornos`, `.eliminar_usuario_dispositivo`, `.get_existencias_by_producto`, `.delete_plato`, `.get_habitaciones_ocupadas`, `._load_categorias`, `.get_proveedores`, `.get_movimientos`, `.get_platos_categorias`, `.save_produccion_detalle`, `.get_productos_insumo`, `.get_proveedor_by_nombre`, `.get_subcategorias_by_categoria_padre`, `.migrate_proveedores_from_facturas`, `.save_plato_contornos`, `.update_produccion_cantidad`, `.update_produccion_estado`?**
  _High betweenness centrality (0.396) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `validacion_view.py`, `ComandaPedidoView`, `.get_pos_setting`, `.get_producto_by_id`, `ConfigPOSView`, `InventarioView`, `SyncQueue`, `RequisicionesView`, `get_sync_queue`, `._download_all_from_server`, `SyncManager`, `._download_all_from_server`, `show_error`, `periodos.py`, `base.py`, `._go_to_main`, `POSSyncManager`, `get_settings`, `.clear_productos`, `views/config.py`, `LocalReplica`, `get_sync_manager`, `.get_facturas`, `.save_componentes`, `._confirmar_anulacion`, `.get_categorias_pos`, `historial_facturas_view.py`, `.get_recetas`, `inventario_view.py`, `._build_compras_lista_data`, `show_agregar_producto_dialog`, `.get_venta_anulada_by_comanda`, `.delete_receta`, `.dedupe_existencias_producto`, `requisiciones_view.py`, `.delete_plato_categoria`, `._enqueue_comanda`, `.get_contornos`, `.eliminar_usuario_dispositivo`, `.get_existencias_by_producto`, `.delete_plato`, `.get_habitaciones_ocupadas`, `._load_categorias`, `.get_proveedores`, `.get_movimientos`, `.get_platos_categorias`, `.save_produccion_detalle`, `.get_productos_insumo`, `.get_proveedor_by_nombre`, `.get_subcategorias_by_categoria_padre`, `.migrate_proveedores_from_facturas`, `.save_plato_contornos`, `.update_produccion_cantidad`, `.update_produccion_estado`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Why does `ComandaPedidoView` connect `ComandaPedidoView` to `POSLoginView`, `comanda_view.py`, `LocalReplica`, `._confirmar_anulacion`, `show_error`?**
  _High betweenness centrality (0.058) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _102 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05239240844693932 - nodes in this community are weakly interconnected._