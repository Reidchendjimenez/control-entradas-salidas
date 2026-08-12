# Graph Report - control-entradas-salidas  (2026-08-12)

## Corpus Check
- 133 files · ~198,365 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1798 nodes · 4468 edges · 109 communities (70 shown, 39 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.59)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `aff77658`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- ConfigPOSView
- requisiciones_view.py
- ._do_totalizar
- ProduccionesView
- producciones/data.py
- ComandaPedidoView
- stock_view.py
- show_success
- get_db_adaptive
- Historial de Cambios
- InventarioView
- schedule_load
- validacion_view.py
- Requisicion
- comprobar_y_aplicar_actualizaciones
- get_colors
- ._download_all_from_server
- ._download_all_from_server
- launcher.py
- ControlEntradasSalidasApp
- .full_sync
- HistorialFacturasView
- POSSyncIndicator
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/dialogs.py
- LoadingSplash
- movimientos.py
- AuditView
- BandejaWhatsAppView
- app_launcher.py
- RequisicionesView
- historial_facturas_view.py
- POSSyncManager
- get_local_conn
- .get_last_sync
- ._confirmar_anulacion
- views/config.py
- printer.py
- comanda_view.py
- VisualizeView
- .get_pos_setting
- main_pos.py
- ._go_to_main
- requisiciones/data.py
- _colors
- graphify reference: extra exports and benchmark
- SyncQueue
- is_online
- .get_producto_by_id
- show_error
- ._ver_detalle
- _NullStream
- ._log
- inventario_view.py
- RequisicionForm
- graphify reference: query, path, explain
- .save_componentes
- .clear_categorias
- LocalReplica
- get_settings
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- run_when_connected
- cards.py
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- .clear_productos
- .delete_receta
- .delete_pos_categoria
- .get_recetas
- .get_almacenes
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- .get_categorias
- graphify.js
- base.py
- AGENTS.md
- .get_detalles_by_produccion
- .delete_plato_categoria
- .get_movimientos_pendientes
- .get_existencias
- .get_platos
- .get_facturas
- .get_habitaciones_ocupadas
- .get_platos_categorias
- .get_platos_pos
- .save_movimiento
- .save_plato_contornos
- .save_pos_categoria
- .verificar_pin
- .get_requisiciones
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
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py

## Import Cycles
- None detected.

## Communities (109 total, 39 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (9): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView, MesasView (+1 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.05
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Obtiene categorías POS independientes., Obtiene categorías visibles en el POS., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora. (+2 more)

### Community 3 - "requisiciones_view.py"
Cohesion: 0.11
Nodes (25): build_detalle_row(), build_empty_state(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., buscar_productos() (+17 more)

### Community 5 - "ProduccionesView"
Cohesion: 0.12
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 6 - "producciones/data.py"
Cohesion: 0.16
Nodes (18): cancelar_produccion(), ejecutar_descargo(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones(), productos_producidos(), Capa de datos/negocio del módulo Producciones. Funciones puras (sin UI) que… (+10 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.08
Nodes (9): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Obtiene contornos activos para POS., Obtiene productos del POS: activos y marcados para la venta., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada. (+1 more)

### Community 8 - "stock_view.py"
Cohesion: 0.12
Nodes (16): Constantes de colores para el tema de la aplicación, build_product_card(), build_stat_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial(), get_stock_stats() (+8 more)

### Community 9 - "show_success"
Cohesion: 0.11
Nodes (21): Obtiene existencia por producto y almacén., Marca un movimiento como sincronizado., Obtiene productos de la BD local., Exception, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error(), Mostrar mensaje de éxito (verde)., show_success() (+13 more)

### Community 10 - "get_db_adaptive"
Cohesion: 0.09
Nodes (28): Script único para migrar datos POS existentes a Supabase. Agrega todos los…, get_connection_status(), get_db_adaptive(), get_local_session(), Retorna el estado de conexión (solo para indicador)., Generator que proporciona una sesión SQLite local., Alias de get_session() para compatibilidad., _migrate_old_tables() (+20 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.10
Nodes (6): get_safe_colors(), create_categoria_header(), create_compra_lista_card(), InventarioView, Lee datos de la BD local y retorna (items, colors)., Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 13 - "schedule_load"
Cohesion: 0.09
Nodes (9): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., schedule_load() (+1 more)

### Community 14 - "validacion_view.py"
Cohesion: 0.18
Nodes (17): Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, count_pending(), delete_from_queue(), format_validation_message(), _get_queue_conn(), get_queued_messages(), process_queue_now(), Módulo para enviar notificaciones a WhatsApp desde Python Uso el servidor… (+9 more)

### Community 15 - "Requisicion"
Cohesion: 0.14
Nodes (5): Base, Requisicion, RequisicionDetalle, load_requisiciones(), RequisicionService

### Community 16 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.22
Nodes (13): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), _get_app_dir(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica. (+5 more)

### Community 17 - "get_colors"
Cohesion: 0.14
Nodes (8): Registra un callback que se ejecuta después de cada sync., register_sync_callback(), Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Helper para obtener colores según el tema de la página, get_colors_safe(), build_ajuste_dialog(), ValidacionView

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync). (+5 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Recalcula las existencias basándose en todos los movimientos. Si hay…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync., Bulk upsert plato_ingredientes para sync. (+6 more)

### Community 20 - "launcher.py"
Cohesion: 0.25
Nodes (9): get_pos_sync_manager(), init_pos_sync_manager(), Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), main(), Page, Launcher para el POS con soporte de actualizaciones. (+1 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.07
Nodes (17): ControlEntradasSalidasApp, Page, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager., Cierra el menú de acciones (header móvil) SIN restaurar las acciones al header.…, Despliega en móvil las acciones del header de la vista actual en un…, Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de… (+9 more)

### Community 22 - ".full_sync"
Cohesion: 0.22
Nodes (4): Guarda timestamp del último sync., Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Verifica si hay conexión a la base de datos remota.

### Community 23 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "POSSyncIndicator"
Cohesion: 0.23
Nodes (6): get_pos_sync_indicator(), init_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

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
Cohesion: 0.13
Nodes (6): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Registra función a llamar con cada paso del sync (msg: str)., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado., SyncManager

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.14
Nodes (23): almacen_produccion_default(), load_componentes(), planificar_descargo(), Calcula los ingredientes a descargar. Para recetas compuestas usa los…, Almacén por defecto para la descarga de materia prima de una producción. Se lee…, cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog() (+15 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 31 - "movimientos.py"
Cohesion: 0.33
Nodes (9): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+1 more)

### Community 33 - "BandejaWhatsAppView"
Cohesion: 0.23
Nodes (4): Control, BandejaWhatsAppView, _notify_error(), Container

### Community 34 - "app_launcher.py"
Cohesion: 0.10
Nodes (28): Logger, _get_app_dir(), Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico(), Page (+20 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.11
Nodes (4): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "historial_facturas_view.py"
Cohesion: 0.15
Nodes (19): Connection, Path, get_db(), Generator que proporciona una sesión SQLite local. Esta es la única fuente de…, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+11 more)

### Community 38 - "get_local_conn"
Cohesion: 0.05
Nodes (17): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), Actualiza la existencia existente o la crea si no existe (sin duplicar)., Resetea el usuario (para cambio de operador)., Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para…, Elimina una venta no impresa y sus movimientos, restaurando el stock., Mapa {id: correlativo} de las ventas indicadas (una sola consulta). (+9 more)

### Community 39 - ".get_last_sync"
Cohesion: 0.29
Nodes (3): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 40 - "._confirmar_anulacion"
Cohesion: 0.10
Nodes (8): Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta)., Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 41 - "views/config.py"
Cohesion: 0.14
Nodes (14): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., configurar_impresora(), _get_next_correlativo(), Guarda el tamaño del membrete: 'small', 'normal', 'large'., Guarda el dispositivo de impresora configurado., Configura el dispositivo de impresora a usar., Obtiene el siguiente numero de correlativo y lo incrementa. (+6 more)

### Community 42 - "printer.py"
Cohesion: 0.13
Nodes (23): _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_configured_device(), _get_usb_out_endpoint(), imprimir_comanda() (+15 more)

### Community 43 - "comanda_view.py"
Cohesion: 0.12
Nodes (24): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _escpos_ticket(), Genera los bytes ESC/POS para un ticket de comanda. Si correlativo es None se…, _abrir_url(), actualizar_tasa(), convertir(), formatear_bs(), formatear_tasa() (+16 more)

### Community 44 - "VisualizeView"
Cohesion: 0.33
Nodes (3): get_detalles(), Construye el texto de la requisición para compartir por WhatsApp., VisualizeView

### Community 45 - ".get_pos_setting"
Cohesion: 0.22
Nodes (8): Obtiene un setting de POS (ej: printer_device)., _get_comanda_header(), get_correlativo_actual(), _get_header_size(), Lee el correlativo actual sin incrementarlo., Obtiene el tamaño del membrete: 'small', 'normal', 'large'., Obtiene la configuracion del membrete de comanda., Carga la configuracion del membrete y correlativo.

### Community 46 - "main_pos.py"
Cohesion: 0.22
Nodes (9): assets_dir_path(), _get_app_dir(), main(), Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller., Directorio de assets del POS. El favicon del navegador se sirve de…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:… (+1 more)

### Community 47 - "._go_to_main"
Cohesion: 0.21
Nodes (6): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 48 - "requisiciones/data.py"
Cohesion: 0.13
Nodes (20): Existencia, Base, Producto, Base, _cantidad_unidad_item(), crear_ajuste_stock(), _encolar_requisicion_sync(), get_requisicion_audit_data() (+12 more)

### Community 49 - "_colors"
Cohesion: 0.07
Nodes (52): main(), Page, archivar_movimientos(), Archiva en Supabase (si se puede) y siempre en local., _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria() (+44 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "SyncQueue"
Cohesion: 0.12
Nodes (11): Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Inicializa la tabla de cola., Asegura que las tablas de la cola existan (defensa ante arranques donde… (+3 more)

### Community 52 - "is_online"
Cohesion: 0.21
Nodes (10): archivar_en_supabase(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, check_connection(), is_online(), Verifica si hay conexión a internet (solo para indicador visual). No bloquea… (+2 more)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 54 - "show_error"
Cohesion: 0.10
Nodes (28): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Page, Sistema centralizado de notificaciones para la aplicación. Proporciona… (+20 more)

### Community 55 - "._ver_detalle"
Cohesion: 0.15
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 57 - "._log"
Cohesion: 0.19
Nodes (6): Print + notificar progreso visual., Notifica a todos los callbacks registrados., Inicia sincronización en segundo plano cada interval_seconds., Loop de sync en background., Procesa la cola de sync - sube pendientes y descarga cambios., Sube elementos de la cola a Supabase usando SQL directo.

### Community 58 - "inventario_view.py"
Cohesion: 0.35
Nodes (6): create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color(), create_producto_item_from_dict(), get_almacenes()

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 63 - "LocalReplica"
Cohesion: 0.05
Nodes (18): LocalReplica, Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Tras subir una requisición local, actualiza su id local al id remoto para que…, Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None., Retorna el set de mesa_id que tienen comandas abiertas., Obtiene una receta por ID., Crea o actualiza una categoría de plato. (+10 more)

### Community 64 - "get_settings"
Cohesion: 0.14
Nodes (10): BaseSettings, _candidate_env_paths(), Config, get_settings(), Identificador único del dispositivo., Rutas candidatas para buscar .env en orden de prioridad., Construye la URL de conexión a la base de datos de forma segura., Settings (+2 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 70 - "cards.py"
Cohesion: 0.83
Nodes (3): build_producto_item_row(), build_requisicion_card(), _c()

### Community 85 - "base.py"
Cohesion: 0.07
Nodes (24): get_base(), Base de datos - SQLite como única fuente de verdad. El sistema ahora funciona…, Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base (+16 more)

## Knowledge Gaps
- **105 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **39 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `ConfigPOSView`, `producciones/data.py`, `ComandaPedidoView`, `stock_view.py`, `show_success`, `get_db_adaptive`, `InventarioView`, `validacion_view.py`, `get_colors`, `._download_all_from_server`, `._download_all_from_server`, `.full_sync`, `RecetaEditor`, `SyncManager`, `producciones/dialogs.py`, `AuditView`, `BandejaWhatsAppView`, `app_launcher.py`, `POSSyncManager`, `get_local_conn`, `.get_last_sync`, `._confirmar_anulacion`, `views/config.py`, `printer.py`, `comanda_view.py`, `.get_pos_setting`, `._go_to_main`, `requisiciones/data.py`, `_colors`, `SyncQueue`, `is_online`, `.get_producto_by_id`, `show_error`, `._ver_detalle`, `inventario_view.py`, `.save_componentes`, `.clear_categorias`, `get_settings`, `.clear_productos`, `.delete_receta`, `.delete_pos_categoria`, `.get_recetas`, `.get_almacenes`, `.get_categorias`, `base.py`, `.get_detalles_by_produccion`, `.delete_plato_categoria`, `.get_movimientos_pendientes`, `.get_existencias`, `.get_platos`, `.get_facturas`, `.get_habitaciones_ocupadas`, `.get_platos_categorias`, `.get_platos_pos`, `.save_movimiento`, `.save_plato_contornos`, `.save_pos_categoria`, `.verificar_pin`, `.get_requisiciones`?**
  _High betweenness centrality (0.377) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `ConfigPOSView`, `requisiciones_view.py`, `ComandaPedidoView`, `show_success`, `get_db_adaptive`, `InventarioView`, `validacion_view.py`, `._download_all_from_server`, `._download_all_from_server`, `.full_sync`, `SyncManager`, `RequisicionesView`, `historial_facturas_view.py`, `POSSyncManager`, `.get_last_sync`, `._confirmar_anulacion`, `views/config.py`, `.get_pos_setting`, `._go_to_main`, `_colors`, `SyncQueue`, `is_online`, `.get_producto_by_id`, `._ver_detalle`, `inventario_view.py`, `.save_componentes`, `.clear_categorias`, `LocalReplica`, `get_settings`, `.clear_productos`, `.delete_receta`, `.delete_pos_categoria`, `.get_recetas`, `.get_almacenes`, `.get_categorias`, `base.py`, `.get_detalles_by_produccion`, `.delete_plato_categoria`, `.get_movimientos_pendientes`, `.get_existencias`, `.get_platos`, `.get_facturas`, `.get_habitaciones_ocupadas`, `.get_platos_categorias`, `.get_platos_pos`, `.save_movimiento`, `.save_plato_contornos`, `.save_pos_categoria`, `.verificar_pin`, `.get_requisiciones`?**
  _High betweenness centrality (0.074) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `POSLoginView`, `views/config.py`, `.get_pos_setting`, `LocalReplica`?**
  _High betweenness centrality (0.043) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _105 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05225718194254446 - nodes in this community are weakly interconnected._