# Graph Report - control-entradas-salidas  (2026-08-09)

## Corpus Check
- 132 files · ~192,708 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1733 nodes · 4344 edges · 93 communities (65 shown, 28 thin omitted)
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
- inventario_view.py
- models/__init__.py
- ConfigPOSView
- .get_productos
- get_local_conn
- _migrate_old_tables
- show_error
- InventarioView
- 📦 Control de Entradas y Salidas - Guía Técnica
- notifications.py
- requisiciones_view.py
- RequisicionesView
- Categoria
- periodos.py
- ._download_all_from_server
- .delete_plato_categoria
- ._download_all_from_server
- .delete_pos_categoria
- .get_venta_anulada_by_comanda
- What You Must Do When Invoked
- SyncManager
- .get_contornos
- What You Must Do When Invoked
- base.py
- .get_facturas
- printer.py
- POSSyncManager
- comanda_view.py
- get_colors
- .get_plato_contornos
- show_warning
- Settings
- producciones/data.py
- show_success
- comprobar_y_aplicar_actualizaciones
- ._go_to_main
- app_launcher.py
- stock_view.py
- show_error
- graphify reference: extra exports and benchmark
- LocalReplica
- LoadingSplash
- form.py
- ._enqueue_comanda
- .delete_receta
- graphify reference: query, path, explain
- .get_producciones
- main_pos.py
- ._enqueue_venta
- .aplicar_movimientos_venta
- .save_componentes
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- Requisicion
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- install_opencode.sh
- _colors
- conn.py
- .get_recetas
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- RecetaEditor
- views/config.py
- .get_producto_by_id
- _frozen_runtime_hook.py
- ConfiguracionView
- .verificar_pin
- .get_contornos_activos
- ._on_categoria_click
- get_db_adaptive
- historial_facturas_view.py
- pos/__init__.py
- lycoris-control
- .clear_categorias
- .get_platos
- .get_proveedor_by_nombre
- .save_plato_contornos

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 213 edges
2. `get_local_conn()` - 178 edges
3. `show_error()` - 73 edges
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
- `totalizar_requisicion()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py
- `_get_remote_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/archive.py → config/config.py

## Import Cycles
- None detected.

## Communities (93 total, 28 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (10): formatear_bs(), Formatea un monto en bolivares estilo venezolano: 1.234,56., ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, POSLoginView (+2 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 3 - "validacion_view.py"
Cohesion: 0.13
Nodes (20): Container, Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), count_pending(), delete_from_queue(), format_validation_message() (+12 more)

### Community 4 - "ComandaPedidoView"
Cohesion: 0.12
Nodes (4): formatear_tasa(), Tasa con 4 decimales, ej: 835,9482 Bs/$., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos.

### Community 5 - "inventario_view.py"
Cohesion: 0.20
Nodes (10): al_pasar_mouse(), create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color(), create_producto_item_from_dict(), get_almacenes(), create_categoria_header() (+2 more)

### Community 6 - "models/__init__.py"
Cohesion: 0.07
Nodes (20): Elimina y recrea todas las tablas de la base de datos., reset_database(), CompraListaItem, Base, Existencia, Base, MovimientoArchivo, Base (+12 more)

### Community 7 - "ConfigPOSView"
Cohesion: 0.07
Nodes (12): Obtiene categorías POS independientes., Obtiene categorías de platos., Obtiene categorías visibles en el POS., ConfigPOSView, Construye el contenido de la pestaña de impresora., Carga la configuracion del membrete y correlativo., Guarda la configuracion del membrete., Establece el correlativo inicial. (+4 more)

### Community 9 - "get_local_conn"
Cohesion: 0.04
Nodes (19): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), Obtiene movimientos de la BD local (con numero de documento de la factura si…, Resetea el usuario (para cambio de operador)., Retorna el set de habitacion_id que tienen comandas abiertas., Retorna el set de mesa_id que tienen comandas abiertas., Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para… (+11 more)

### Community 10 - "_migrate_old_tables"
Cohesion: 0.50
Nodes (4): _migrate_old_tables(), Migra datos de tablas old (local_*) a tablas nuevas si existen datos en old., Migraciones automáticas para tablas POS., _run_pos_migrations()

### Community 11 - "show_error"
Cohesion: 0.15
Nodes (8): ControlEntradasSalidasApp, Page, Recibe mensajes de progreso del SyncManager., Registra el callback de progreso en el SyncManager., Exception, Sistema global de manejo y notificación de errores. Este módulo mantiene…, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error()

### Community 13 - "📦 Control de Entradas y Salidas - Guía Técnica"
Cohesion: 0.05
Nodes (40): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+32 more)

### Community 14 - "notifications.py"
Cohesion: 0.19
Nodes (14): clear_notifications(), _get_colors(), _get_page(), Page, Sistema centralizado de notificaciones para la aplicación. Proporciona…, Obtiene la página activa desde sys o desde la pila de llamadas., Mostrar banner persistente que requiere acción del usuario. Tipos: 'success',…, Limpiar todas las notificaciones activas. (+6 more)

### Community 15 - "requisiciones_view.py"
Cohesion: 0.16
Nodes (17): build_detalle_row(), build_producto_busqueda_item(), get_detalles(), build_agregar_producto_dialog(), build_agregar_producto_req_dialog(), build_buscador_productos(), build_crear_vista(), build_detalles_dialog() (+9 more)

### Community 16 - "RequisicionesView"
Cohesion: 0.10
Nodes (5): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 18 - "periodos.py"
Cohesion: 0.21
Nodes (20): archivar_en_supabase(), archivar_movimientos(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Mostrar mensaje informativo (azul)., show_info(), _aperturar_periodo(), build_periodos_tab() (+12 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 21 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+5 more)

### Community 23 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero)., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 24 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 25 - "SyncManager"
Cohesion: 0.08
Nodes (19): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Fuerza una sincronización inmediata., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync. (+11 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "base.py"
Cohesion: 0.06
Nodes (47): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, _get_remote_engine(), guardar_periodo_en_supabase(), Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, check_connection(), get_base() (+39 more)

### Community 30 - "printer.py"
Cohesion: 0.09
Nodes (34): Obtiene un setting de POS (ej: printer_device)., _escpos_ticket(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_comanda_header() (+26 more)

### Community 31 - "POSSyncManager"
Cohesion: 0.11
Nodes (6): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Guarda timestamp del último sync., Obtiene timestamp del último sync., Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Estado de conexión y sincronización.

### Community 32 - "comanda_view.py"
Cohesion: 0.15
Nodes (18): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _abrir_url(), actualizar_tasa(), convertir(), get_diagnostico(), get_tasa(), obtener_tasa_bcv(), _obtener_tasa_fallback() (+10 more)

### Community 33 - "get_colors"
Cohesion: 0.18
Nodes (4): get_colors(), Helper para obtener colores según el tema de la página, get_colors_safe(), ValidacionView

### Community 35 - "show_warning"
Cohesion: 0.15
Nodes (5): Mostrar mensaje de advertencia (naranja)., show_warning(), AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 36 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Identificador único del dispositivo., Construye la URL de conexión a la base de datos de forma segura., Settings

### Community 37 - "producciones/data.py"
Cohesion: 0.05
Nodes (50): Devuelve la lista de almacenes existentes (valores únicos)., Actualiza el estado de una producción y encola el cambio para sync., Guarda un detalle de producción., almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle() (+42 more)

### Community 38 - "show_success"
Cohesion: 0.15
Nodes (18): Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., Mostrar mensaje de éxito (verde)., show_success(), get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén. (+10 more)

### Community 39 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.24
Nodes (11): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), Page, Comprueba, descarga e instala actualizaciones de código de forma dinámica., Lee UPDATE_URL desde .env. Busca en _get_app_dir() (y config/), _MEIPASS, y…, Bloqueante — corre en executor. (+3 more)

### Community 40 - "._go_to_main"
Cohesion: 0.18
Nodes (8): init_local_tables(), Inicializa las tablas en la base de datos local., init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 41 - "app_launcher.py"
Cohesion: 0.10
Nodes (31): Logger, _get_app_dir(), Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico(), Page (+23 more)

### Community 42 - "stock_view.py"
Cohesion: 0.06
Nodes (34): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., Registra un callback que se ejecuta después de cada sync., register_sync_callback() (+26 more)

### Community 43 - "show_error"
Cohesion: 0.22
Nodes (17): main(), Page, Mostrar mensaje de error (rojo)., show_error(), save_categoria(), _build_almacen_produccion_dd(), _build_negativo_switch(), build_sistema_tab() (+9 more)

### Community 44 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 45 - "LocalReplica"
Cohesion: 0.04
Nodes (19): LocalReplica, Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene movimientos que no han sido sincronizados., Tras subir una requisición local, actualiza su id local al id remoto para que…, Obtiene requisiciones de la BD local., Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None., Crea o actualiza una categoría POS independiente., Obtiene una receta por ID. (+11 more)

### Community 46 - "LoadingSplash"
Cohesion: 0.12
Nodes (9): _find_background_image(), LoadingSplash, Page, Splash a pantalla completa con fondo (imagen estática) y UI animada., Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5')., Marca el 100% y detiene las animaciones. (+1 more)

### Community 47 - "form.py"
Cohesion: 0.13
Nodes (6): build_producto_item_row(), build_requisicion_card(), _c(), _c(), RequisicionForm, RequisicionService

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

### Community 57 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 58 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 59 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 61 - "Requisicion"
Cohesion: 0.20
Nodes (7): Requisicion, build_empty_state(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., contar_detalles()

### Community 65 - "_colors"
Cohesion: 0.21
Nodes (22): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog(), confirm_delete() (+14 more)

### Community 66 - "conn.py"
Cohesion: 0.16
Nodes (17): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+9 more)

### Community 71 - "RecetaEditor"
Cohesion: 0.08
Nodes (7): Obtiene los componentes de una receta., Editor de receta en pantalla completa., Selector de producto con buscador (estilo sección de componentes). Muestra un…, Llama control.update() solo si el control ya está añadido a la página., RecetaEditor, _colors(), ProduccionesView

### Community 72 - "views/config.py"
Cohesion: 0.08
Nodes (19): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., get_pos_sync_manager(), Inicializa la tabla de cola., configurar_impresora(), Guarda el tamaño del membrete: 'small', 'normal', 'large'., Guarda el dispositivo de impresora configurado., Configura el dispositivo de impresora a usar. (+11 more)

### Community 73 - ".get_producto_by_id"
Cohesion: 0.16
Nodes (6): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene una categoría por ID., Obtiene un producto por ID., Obtiene existencias de la BD local., Lee datos de la BD local y retorna (items, colors).

### Community 80 - "._on_categoria_click"
Cohesion: 0.21
Nodes (5): Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Obtiene platos activos para mostrar en POS., Obtiene productos del POS: activos y marcados para la venta., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 82 - "get_db_adaptive"
Cohesion: 0.14
Nodes (26): get_db_adaptive(), Generator que proporciona una sesión SQLite local., get_productos_activos(), Obtiene todos los productos activos del inventario., buscar_productos(), _cantidad_unidad_item(), crear_ajuste_stock(), eliminar_requisicion() (+18 more)

### Community 85 - "historial_facturas_view.py"
Cohesion: 0.14
Nodes (13): get_pending_movimientos_count(), Obtiene el número de movimientos pendientes de sincronización., Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_theme(), Constantes de colores para el tema de la aplicación (+5 more)

## Knowledge Gaps
- **99 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+94 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **28 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `validacion_view.py`, `ComandaPedidoView`, `inventario_view.py`, `ConfigPOSView`, `.get_productos`, `get_local_conn`, `InventarioView`, `periodos.py`, `._download_all_from_server`, `.delete_plato_categoria`, `._download_all_from_server`, `.delete_pos_categoria`, `.get_venta_anulada_by_comanda`, `SyncManager`, `.get_contornos`, `base.py`, `.get_facturas`, `printer.py`, `POSSyncManager`, `comanda_view.py`, `get_colors`, `.get_plato_contornos`, `show_warning`, `producciones/data.py`, `show_success`, `._go_to_main`, `app_launcher.py`, `stock_view.py`, `show_error`, `._enqueue_comanda`, `.delete_receta`, `.get_producciones`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `_colors`, `.get_recetas`, `RecetaEditor`, `views/config.py`, `.get_producto_by_id`, `.verificar_pin`, `.get_contornos_activos`, `._on_categoria_click`, `get_db_adaptive`, `historial_facturas_view.py`, `.clear_categorias`, `.get_platos`, `.get_proveedor_by_nombre`, `.save_plato_contornos`?**
  _High betweenness centrality (0.432) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `validacion_view.py`, `inventario_view.py`, `ConfigPOSView`, `.get_productos`, `InventarioView`, `requisiciones_view.py`, `RequisicionesView`, `periodos.py`, `._download_all_from_server`, `.delete_plato_categoria`, `._download_all_from_server`, `.delete_pos_categoria`, `.get_venta_anulada_by_comanda`, `SyncManager`, `.get_contornos`, `base.py`, `.get_facturas`, `printer.py`, `POSSyncManager`, `.get_plato_contornos`, `producciones/data.py`, `show_success`, `._go_to_main`, `LocalReplica`, `._enqueue_comanda`, `.delete_receta`, `.get_producciones`, `._enqueue_venta`, `.aplicar_movimientos_venta`, `.save_componentes`, `conn.py`, `.get_recetas`, `RecetaEditor`, `views/config.py`, `.get_producto_by_id`, `.verificar_pin`, `.get_contornos_activos`, `._on_categoria_click`, `.clear_categorias`, `.get_platos`, `.get_proveedor_by_nombre`, `.save_plato_contornos`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._
- **Why does `SyncManager` connect `SyncManager` to `models/__init__.py`, `app_launcher.py`, `LocalReplica`, `._download_all_from_server`, `base.py`, `POSSyncManager`?**
  _High betweenness centrality (0.049) - this node is a cross-community bridge._
- **Are the 19 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 19 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _99 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05172413793103448 - nodes in this community are weakly interconnected._