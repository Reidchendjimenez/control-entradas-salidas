# Graph Report - control-entradas-salidas  (2026-08-13)

## Corpus Check
- 137 files · ~200,520 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1808 nodes · 4491 edges · 104 communities (67 shown, 37 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.59)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b015b2ba`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- requisiciones_view.py
- show_error_with_copy
- ConfigPOSView
- requisiciones/data.py
- ProduccionesView
- ._go_to_main
- producciones/data.py
- ComandaPedidoView
- get_db_adaptive
- ValidacionView
- SyncQueue
- Historial de Cambios
- InventarioView
- get_colors
- whatsapp_notifier.py
- notifications.py
- comprobar_y_aplicar_actualizaciones
- models/__init__.py
- ._download_all_from_server
- ._download_all_from_server
- comanda_view.py
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
- ._confirmar_anulacion
- AuditView
- get_local_conn
- launcher.py
- RequisicionesView
- sync_queue.py
- POSSyncManager
- LocalReplica
- get_sync_queue
- POSLoginView
- Requisicion
- .get_contornos
- POSSyncIndicator
- ._build_compras_lista_data
- run_when_connected
- main_pos.py
- .set_pos_setting
- Receta
- show_error
- graphify reference: extra exports and benchmark
- RequisicionForm
- .get_platos
- .get_producto_by_id
- categories.py
- ._ver_detalle
- _NullStream
- Factura
- FacturaPago
- .get_almacenes
- graphify reference: query, path, explain
- .save_componentes
- app_launcher.py
- .get_componentes_by_receta
- local_replica.py
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- inventario_view.py
- .save_categorias
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- .get_habitaciones_ocupadas
- .delete_receta
- .get_movimientos
- .get_recetas
- show_agregar_producto_dialog
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- .get_receta_by_id
- graphify.js
- usr/init_db.py
- AGENTS.md
- .update_existencia
- .get_ventas_correlativos
- .save_plato_categoria
- .save_produccion_detalle
- .migrate_proveedores_from_facturas
- .delete_plato
- .delete_plato_categoria
- .get_categoria
- pos/__init__.py
- lycoris-control
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
10. `get_colors()` - 45 edges

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

## Communities (104 total, 37 thin omitted)

### Community 0 - "requisiciones_view.py"
Cohesion: 0.11
Nodes (27): build_detalle_row(), build_empty_state(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., contar_detalles() (+19 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Obtiene categorías POS independientes., Obtiene categorías de platos., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora. (+2 more)

### Community 3 - "requisiciones/data.py"
Cohesion: 0.17
Nodes (18): Existencia, Base, _cantidad_unidad_item(), crear_ajuste_stock(), _encolar_requisicion_sync(), get_requisicion_audit_data(), guardar_requisicion(), marcar_detalle_verificado() (+10 more)

### Community 4 - "ProduccionesView"
Cohesion: 0.12
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 5 - "._go_to_main"
Cohesion: 0.21
Nodes (6): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 6 - "producciones/data.py"
Cohesion: 0.18
Nodes (16): cancelar_produccion(), ejecutar_descargo(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones(), Capa de datos/negocio del módulo Producciones. Funciones puras (sin UI) que…, Etapa 1: registra entrada_produccion + producción pendiente + detalle. Si… (+8 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.09
Nodes (8): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Obtiene productos del POS: activos y marcados para la venta., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "get_db_adaptive"
Cohesion: 0.07
Nodes (27): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Elimina duplicados de existencias para un producto específico. Conserva el…, Producto, Base, get_existencia_producto(), get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de… (+19 more)

### Community 9 - "ValidacionView"
Cohesion: 0.13
Nodes (3): Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, schedule_load(), ValidacionView

### Community 10 - "SyncQueue"
Cohesion: 0.10
Nodes (12): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Obtiene timestamp del último sync., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes. (+4 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 13 - "get_colors"
Cohesion: 0.09
Nodes (23): clear_all_callbacks(), Manejo de callbacks de sincronización entre vistas., Registra un callback que se ejecuta después de cada sync., Elimina un callback registrado., Limpia todos los callbacks registrados., register_sync_callback(), unregister_sync_callback(), get_pending_movimientos_count() (+15 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "notifications.py"
Cohesion: 0.17
Nodes (15): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Page, Sistema centralizado de notificaciones para la aplicación. Proporciona… (+7 more)

### Community 16 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.22
Nodes (13): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), _get_app_dir(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica. (+5 more)

### Community 17 - "models/__init__.py"
Cohesion: 0.14
Nodes (8): Categoria, Base, CompraListaItem, Base, MovimientoArchivo, Base, Proveedor, Base

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (12): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync)., Guarda lista de detalles de producción (bulk upsert para sync). (+4 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync. (+6 more)

### Community 20 - "comanda_view.py"
Cohesion: 0.12
Nodes (22): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _escpos_ticket(), _get_next_correlativo(), imprimir_comanda(), Genera los bytes ESC/POS para un ticket de comanda. Si correlativo es None se…, Imprime una comanda en la impresora configurada o auto-detectada. Retorna True…, Obtiene el siguiente numero de correlativo y lo incrementa., _abrir_url() (+14 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.06
Nodes (25): ControlEntradasSalidasApp, Page, Imprime en el log (solo si TRACE_SWITCH=1) un marcador con delta de tiempo para…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager. (+17 more)

### Community 22 - "base.py"
Cohesion: 0.18
Nodes (18): check_connection(), get_base(), get_connection_status(), get_db(), get_local_db(), get_local_engine(), get_local_session(), get_session() (+10 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "printer.py"
Cohesion: 0.07
Nodes (39): Obtiene un setting de POS (ej: printer_device)., configurar_impresora(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_comanda_header() (+31 more)

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
Nodes (16): Guarda timestamp del último sync., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync. (+8 more)

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.13
Nodes (25): almacen_produccion_default(), load_componentes(), planificar_descargo(), productos_producidos(), Calcula los ingredientes a descargar. Para recetas compuestas usa los…, Almacén por defecto para la descarga de materia prima de una producción. Se lee…, Productos resultantes de una producción = detalles tipo 'entrada'. Retorna…, cancelar_produccion_dialog() (+17 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.12
Nodes (8): LoadingSplash, Container, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5')., Marca el 100% y detiene las animaciones.

### Community 31 - "._confirmar_anulacion"
Cohesion: 0.10
Nodes (8): Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta)., Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 32 - "AuditView"
Cohesion: 0.15
Nodes (9): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+1 more)

### Community 33 - "get_local_conn"
Cohesion: 0.04
Nodes (18): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), Obtiene todas las existencias de un producto (sumadas por almacén)., Marca un movimiento como sincronizado., Obtiene facturas de la BD local., Tras subir una requisición local, actualiza su id local al id remoto para que…, Obtiene requisiciones de la BD local. (+10 more)

### Community 34 - "launcher.py"
Cohesion: 0.13
Nodes (23): Logger, get_engine(), Alias de get_local_engine() para compatibilidad., Llamar desde main() antes de cualquier import de BD., set_db_path(), ensure_local_db(), Asegura que la BD local existe. Llamar después de set_db_path()., get_pos_sync_manager() (+15 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.08
Nodes (5): load_requisiciones(), Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "sync_queue.py"
Cohesion: 0.18
Nodes (16): Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no…, Inicializa tablas decache (no sync)., set_cache() (+8 more)

### Community 38 - "LocalReplica"
Cohesion: 0.04
Nodes (19): LocalReplica, Obtiene movimientos que no han sido sincronizados., Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para…, Elimina una venta no impresa y sus movimientos, restaurando el stock., Elimina una categoría POS si no tiene sub-categorias., Obtiene un plato con sus ingredientes., Obtiene platos activos para mostrar en POS., Crea o actualiza un plato y sus ingredientes. (+11 more)

### Community 39 - "get_sync_queue"
Cohesion: 0.17
Nodes (12): Script único para migrar datos POS existentes a Supabase. Agrega todos los…, notify_sync_complete(), Notifica a todos los callbacks registrados., get_sync_manager(), get_sync_queue(), Obtiene instancia singleton de SyncQueue., Sincronización Bidireccional con SQLAlchemy - maneja conexión y offline para…, Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se… (+4 more)

### Community 40 - "POSLoginView"
Cohesion: 0.05
Nodes (9): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView, MesasView (+1 more)

### Community 41 - "Requisicion"
Cohesion: 0.18
Nodes (4): Base, Requisicion, RequisicionDetalle, RequisicionService

### Community 43 - "POSSyncIndicator"
Cohesion: 0.21
Nodes (5): get_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 44 - "._build_compras_lista_data"
Cohesion: 0.29
Nodes (4): create_categoria_header(), create_compra_lista_card(), Lee datos de la BD local y retorna (items, colors)., Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 48 - "Receta"
Cohesion: 0.40
Nodes (3): Base, Receta, RecetaComponente

### Community 49 - "show_error"
Cohesion: 0.05
Nodes (72): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, Mostrar mensaje de éxito (verde). (+64 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 54 - "categories.py"
Cohesion: 0.40
Nodes (4): create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color()

### Community 55 - "._ver_detalle"
Cohesion: 0.15
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 62 - "app_launcher.py"
Cohesion: 0.14
Nodes (17): _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico() (+9 more)

### Community 64 - "local_replica.py"
Cohesion: 0.11
Nodes (15): BaseSettings, _candidate_env_paths(), Config, get_settings(), Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Rutas candidatas para buscar .env en orden de prioridad., Settings (+7 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - "inventario_view.py"
Cohesion: 0.19
Nodes (15): is_online(), Alias de check_connection() para compatibilidad., Obtiene existencia por producto y almacén., Guarda un movimiento en la BD local., show_cantidad_dialog(), show_correccion_dialog(), get_attr(), ajustar_existencia() (+7 more)

### Community 70 - ".save_categorias"
Cohesion: 0.33
Nodes (3): Guarda categorías en la base de datos local (upsert, no borra)., Obtiene todas las categorías de la BD local., Lee caché local y (si hay conexión) consulta el servidor. Corre en hilo aparte…

### Community 79 - "show_agregar_producto_dialog"
Cohesion: 0.50
Nodes (3): Obtiene productos de la BD local., show_agregar_producto_dialog(), load_productos()

### Community 85 - "usr/init_db.py"
Cohesion: 0.24
Nodes (5): Elimina y recrea todas las tablas de la base de datos., reset_database(), Produccion, ProduccionDetalle, Base

## Knowledge Gaps
- **105 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `show_error_with_copy`, `ConfigPOSView`, `requisiciones/data.py`, `._go_to_main`, `producciones/data.py`, `ComandaPedidoView`, `get_db_adaptive`, `ValidacionView`, `SyncQueue`, `InventarioView`, `get_colors`, `whatsapp_notifier.py`, `._download_all_from_server`, `._download_all_from_server`, `comanda_view.py`, `base.py`, `printer.py`, `RecetaEditor`, `SyncManager`, `producciones/dialogs.py`, `._confirmar_anulacion`, `AuditView`, `get_local_conn`, `launcher.py`, `POSSyncManager`, `get_sync_queue`, `POSLoginView`, `.get_contornos`, `.set_pos_setting`, `show_error`, `.get_platos`, `.get_producto_by_id`, `._ver_detalle`, `.get_almacenes`, `.save_componentes`, `app_launcher.py`, `.get_componentes_by_receta`, `local_replica.py`, `inventario_view.py`, `.save_categorias`, `.get_habitaciones_ocupadas`, `.delete_receta`, `.get_movimientos`, `.get_recetas`, `show_agregar_producto_dialog`, `.get_receta_by_id`, `.update_existencia`, `.get_ventas_correlativos`, `.save_plato_categoria`, `.save_produccion_detalle`, `.migrate_proveedores_from_facturas`, `.delete_plato`, `.delete_plato_categoria`, `.get_categoria`, `.verificar_pin`?**
  _High betweenness centrality (0.384) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `requisiciones_view.py`, `ConfigPOSView`, `._go_to_main`, `ComandaPedidoView`, `get_db_adaptive`, `SyncQueue`, `InventarioView`, `whatsapp_notifier.py`, `._download_all_from_server`, `._download_all_from_server`, `printer.py`, `SyncManager`, `._confirmar_anulacion`, `RequisicionesView`, `sync_queue.py`, `POSSyncManager`, `LocalReplica`, `get_sync_queue`, `POSLoginView`, `.get_contornos`, `._build_compras_lista_data`, `.set_pos_setting`, `show_error`, `.get_platos`, `.get_producto_by_id`, `._ver_detalle`, `.get_almacenes`, `.save_componentes`, `.get_componentes_by_receta`, `local_replica.py`, `inventario_view.py`, `.save_categorias`, `.get_habitaciones_ocupadas`, `.delete_receta`, `.get_movimientos`, `.get_recetas`, `show_agregar_producto_dialog`, `.get_receta_by_id`, `.update_existencia`, `.get_ventas_correlativos`, `.save_plato_categoria`, `.save_produccion_detalle`, `.migrate_proveedores_from_facturas`, `.delete_plato`, `.delete_plato_categoria`, `.get_categoria`, `.verificar_pin`?**
  _High betweenness centrality (0.089) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `POSLoginView`, `printer.py`, `LocalReplica`?**
  _High betweenness centrality (0.046) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _105 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `requisiciones_view.py` be split into smaller, more focused modules?**
  _Cohesion score 0.10975609756097561 - nodes in this community are weakly interconnected._