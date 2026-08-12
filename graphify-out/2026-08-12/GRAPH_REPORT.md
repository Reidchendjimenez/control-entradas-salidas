# Graph Report - control-entradas-salidas  (2026-08-12)

## Corpus Check
- 133 files · ~197,633 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1790 nodes · 4430 edges · 113 communities (71 shown, 42 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 77 edges (avg confidence: 0.58)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `9bb6ff45`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- ConfigPOSView
- get_db_adaptive
- show_error
- local_replica.py
- ComandaPedidoView
- ._load_categorias
- stock_view.py
- LocalReplica
- unregister_sync_callback
- Historial de Cambios
- inventario_view.py
- StockView
- validacion_view.py
- _colors
- launcher.py
- ValidacionView
- ._download_all_from_server
- ._download_all_from_server
- movimientos.py
- ControlEntradasSalidasApp
- get_colors
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
- conn.py
- POSSyncManager
- get_local_conn
- form.py
- producciones/dialogs.py
- is_online
- printer.py
- tasa_cambio.py
- ProduccionesView
- views/config.py
- main_pos.py
- ._go_to_main
- requisiciones/data.py
- ConfiguracionView
- graphify reference: extra exports and benchmark
- SyncQueue
- get_sync_queue
- .get_producto_by_id
- notifications.py
- .get_venta_anulada_by_comanda
- _NullStream
- .mark_movimiento_sincronizado
- ._confirmar_anulacion
- requisiciones/components.py
- graphify reference: query, path, explain
- .save_componentes
- .set_pos_setting
- VisualizeView
- Settings
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- ._load_pos_categorias
- Producto
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- ._build_printer_tab
- .delete_receta
- ._enqueue_comanda
- .get_recetas
- .save_categorias
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- .get_platos_categorias
- graphify.js
- base.py
- AGENTS.md
- .delete_plato
- .delete_plato_categoria
- .eliminar_venta_y_movimientos
- .get_existencias_by_producto
- .get_categoria
- .get_facturas
- .get_habitaciones_ocupadas
- .get_platos
- .get_platos_pos
- .get_proveedores
- .get_receta_by_id
- .get_requisiciones
- .get_ventas_correlativos
- .migrate_proveedores_from_facturas
- pos/__init__.py
- lycoris-control
- .save_produccion
- .update_produccion_cantidad
- .update_produccion_estado
- .verificar_pin

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
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `_sync_existencias_supabase_batch()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/requisiciones/data.py → config/config.py

## Import Cycles
- None detected.

## Communities (113 total, 42 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (9): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView, MesasView (+1 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.05
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 3 - "get_db_adaptive"
Cohesion: 0.14
Nodes (24): get_db_adaptive(), Generator que proporciona una sesión SQLite local., build_detalle_row(), build_producto_busqueda_item(), buscar_productos(), eliminar_requisicion(), get_almacenes(), get_detalles() (+16 more)

### Community 4 - "show_error"
Cohesion: 0.12
Nodes (23): Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., Mostrar mensaje de advertencia (naranja)., Mostrar mensaje informativo (azul)., show_error(), show_info(), show_success(), show_warning() (+15 more)

### Community 5 - "local_replica.py"
Cohesion: 0.08
Nodes (27): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, get_connection_status(), get_db(), get_engine(), get_local_db(), get_local_engine() (+19 more)

### Community 7 - "._load_categorias"
Cohesion: 0.16
Nodes (4): Obtiene contornos activos para POS., Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.26
Nodes (9): build_product_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial(), get_stock_stats(), load_categories(), load_products() (+1 more)

### Community 9 - "LocalReplica"
Cohesion: 0.04
Nodes (18): LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None., Retorna el set de mesa_id que tienen comandas abiertas., Crea o actualiza una categoría POS independiente., Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Crea o actualiza una categoría de plato. (+10 more)

### Community 10 - "unregister_sync_callback"
Cohesion: 0.15
Nodes (7): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados., unregister_sync_callback()

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "inventario_view.py"
Cohesion: 0.05
Nodes (38): Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene productos de la BD local., get_pending_movimientos_count(), get_sync_manager(), Obtiene el número de movimientos pendientes de sincronización., Exception, Sistema global de manejo y notificación de errores. Este módulo mantiene… (+30 more)

### Community 13 - "StockView"
Cohesion: 0.14
Nodes (3): Elimina duplicados de existencias para un producto específico. Conserva el…, build_existencias_dialog(), StockView

### Community 14 - "validacion_view.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "_colors"
Cohesion: 0.17
Nodes (26): Cola de sincronización unificada para trabajo offline-first. Maneja: - Cola de…, Categoria, Base, _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog() (+18 more)

### Community 16 - "launcher.py"
Cohesion: 0.14
Nodes (21): Text, init_pos_sync_manager(), Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), main(), Page, Launcher para el POS con soporte de actualizaciones. (+13 more)

### Community 17 - "ValidacionView"
Cohesion: 0.16
Nodes (3): Registra un callback que se ejecuta después de cada sync., register_sync_callback(), ValidacionView

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (12): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+4 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 20 - "movimientos.py"
Cohesion: 0.29
Nodes (10): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+2 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.07
Nodes (19): ControlEntradasSalidasApp, Page, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager., Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, apply_theme_to_button(), apply_theme_to_container() (+11 more)

### Community 22 - "get_colors"
Cohesion: 0.19
Nodes (8): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Constantes de colores para el tema de la aplicación, Helper para obtener colores según el tema de la página, build_producto_item_row(), build_requisicion_card(), _c(), get_colors_safe()

### Community 23 - "HistorialFacturasView"
Cohesion: 0.13
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "POSSyncIndicator"
Cohesion: 0.21
Nodes (6): get_pos_sync_manager(), init_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

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
Nodes (17): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado. (+9 more)

### Community 29 - "producciones/data.py"
Cohesion: 0.12
Nodes (23): almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones() (+15 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.12
Nodes (8): LoadingSplash, Container, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5')., Marca el 100% y detiene las animaciones.

### Community 31 - "comanda_view.py"
Cohesion: 0.28
Nodes (8): convertir(), formatear_bs(), formatear_tasa(), get_tasa(), Tasa guardada; 0 si aun no se ha consultado ninguna., Convierte un monto en dolares a bolivares usando la tasa indicada (por defecto,…, Formatea un monto en bolivares estilo venezolano: 1.234,56., Tasa con 4 decimales, ej: 835,9482 Bs/$.

### Community 33 - "get_safe_colors"
Cohesion: 0.57
Nodes (4): build_stat_card(), get_color_mapping(), get_mapped_color(), get_safe_colors()

### Community 34 - "app_launcher.py"
Cohesion: 0.11
Nodes (23): Logger, _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main() (+15 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.10
Nodes (4): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "conn.py"
Cohesion: 0.15
Nodes (19): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+11 more)

### Community 37 - "POSSyncManager"
Cohesion: 0.11
Nodes (6): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Guarda timestamp del último sync., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 38 - "get_local_conn"
Cohesion: 0.04
Nodes (17): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene movimientos que no han sido sincronizados., Tras subir una requisición local, actualiza su id local al id remoto para que…, Resetea el usuario (para cambio de operador)., Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para… (+9 more)

### Community 40 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (19): cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente., colors(), fmt_fecha() (+11 more)

### Community 41 - "is_online"
Cohesion: 0.17
Nodes (23): archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo…, is_online() (+15 more)

### Community 42 - "printer.py"
Cohesion: 0.09
Nodes (30): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _escpos_ticket(), _find_printer_device(), _find_printer_device_auto(), _find_usb_printers(), _find_windows_printers(), _get_comanda_header() (+22 more)

### Community 43 - "tasa_cambio.py"
Cohesion: 0.21
Nodes (13): _abrir_url(), actualizar_tasa(), get_diagnostico(), obtener_tasa_bcv(), _obtener_tasa_fallback(), _obtener_tasa_sitio_oficial(), Tasa de cambio USD -> Bs (bolivares) oficial del BCV. La tasa oficial la…, Respaldo: consulta la tasa USD en la API de bcv.today. (+5 more)

### Community 44 - "ProduccionesView"
Cohesion: 0.12
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 45 - "views/config.py"
Cohesion: 0.10
Nodes (18): configurar_impresora(), _find_serial_printers(), _get_configured_device(), listar_impresoras(), Guarda el tamaño del membrete: 'small', 'normal', 'large'., Busca impresoras en puertos seriales disponibles., Lista todas las impresoras disponibles (USB + serial + Windows)., Obtiene el dispositivo de impresora configurado por el usuario. (+10 more)

### Community 46 - "main_pos.py"
Cohesion: 0.22
Nodes (9): assets_dir_path(), _get_app_dir(), main(), Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller., Directorio de assets del POS. El favicon del navegador se sirve de…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:… (+1 more)

### Community 47 - "._go_to_main"
Cohesion: 0.21
Nodes (6): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 48 - "requisiciones/data.py"
Cohesion: 0.17
Nodes (18): Existencia, Base, _cantidad_unidad_item(), crear_ajuste_stock(), _encolar_requisicion_sync(), get_requisicion_audit_data(), guardar_requisicion(), marcar_detalle_verificado() (+10 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "SyncQueue"
Cohesion: 0.15
Nodes (9): Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync. (+1 more)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 54 - "notifications.py"
Cohesion: 0.26
Nodes (11): clear_notifications(), _get_colors(), _get_page(), Sistema centralizado de notificaciones para la aplicación. Proporciona…, Obtiene la página activa desde sys o desde la pila de llamadas., Mostrar banner persistente que requiere acción del usuario. Tipos: 'success',…, Limpiar todas las notificaciones activas., Obtener colores del tema (soporta tema claro/oscuro). (+3 more)

### Community 55 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 57 - ".mark_movimiento_sincronizado"
Cohesion: 0.33
Nodes (4): Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync()

### Community 58 - "._confirmar_anulacion"
Cohesion: 0.12
Nodes (6): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 59 - "requisiciones/components.py"
Cohesion: 0.24
Nodes (7): build_empty_state(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., contar_detalles(), load_requisiciones()

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 62 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 64 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Identificador único del dispositivo., Construye la URL de conexión a la base de datos de forma segura., Settings

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 70 - "Producto"
Cohesion: 0.29
Nodes (5): Producto, Base, get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario.

### Community 75 - "._build_printer_tab"
Cohesion: 0.25
Nodes (5): Establece el valor inicial del correlativo., set_correlativo_inicial(), Construye el contenido de la pestaña de impresora., Establece el correlativo inicial., Prueba la impresion en la impresora configurada.

### Community 77 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 79 - ".save_categorias"
Cohesion: 0.33
Nodes (3): Guarda categorías en la base de datos local (upsert, no borra)., Obtiene todas las categorías de la BD local., Lee caché local y (si hay conexión) consulta el servidor. Corre en hilo aparte…

### Community 85 - "base.py"
Cohesion: 0.05
Nodes (27): get_base(), Base de datos - SQLite como única fuente de verdad. El sistema ahora funciona…, Elimina y recrea todas las tablas de la base de datos., reset_database(), CompraListaItem, Base, Factura, FacturaPago (+19 more)

## Knowledge Gaps
- **105 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **42 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `ConfigPOSView`, `show_error`, `local_replica.py`, `ComandaPedidoView`, `._load_categorias`, `stock_view.py`, `inventario_view.py`, `StockView`, `validacion_view.py`, `_colors`, `ValidacionView`, `._download_all_from_server`, `._download_all_from_server`, `get_colors`, `RecetaEditor`, `SyncManager`, `producciones/data.py`, `comanda_view.py`, `AuditView`, `app_launcher.py`, `POSSyncManager`, `get_local_conn`, `producciones/dialogs.py`, `is_online`, `printer.py`, `tasa_cambio.py`, `views/config.py`, `._go_to_main`, `requisiciones/data.py`, `SyncQueue`, `.get_producto_by_id`, `.get_venta_anulada_by_comanda`, `.mark_movimiento_sincronizado`, `._confirmar_anulacion`, `.save_componentes`, `.set_pos_setting`, `._load_pos_categorias`, `Producto`, `.delete_receta`, `._enqueue_comanda`, `.get_recetas`, `.save_categorias`, `.get_platos_categorias`, `base.py`, `.delete_plato`, `.delete_plato_categoria`, `.eliminar_venta_y_movimientos`, `.get_existencias_by_producto`, `.get_categoria`, `.get_facturas`, `.get_habitaciones_ocupadas`, `.get_platos`, `.get_platos_pos`, `.get_proveedores`, `.get_receta_by_id`, `.get_requisiciones`, `.get_ventas_correlativos`, `.migrate_proveedores_from_facturas`, `.save_produccion`, `.update_produccion_cantidad`, `.update_produccion_estado`, `.verificar_pin`?**
  _High betweenness centrality (0.385) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `get_db_adaptive`, `local_replica.py`, `._load_categorias`, `LocalReplica`, `inventario_view.py`, `StockView`, `validacion_view.py`, `_colors`, `._download_all_from_server`, `._download_all_from_server`, `SyncManager`, `RequisicionesView`, `conn.py`, `POSSyncManager`, `is_online`, `printer.py`, `._go_to_main`, `SyncQueue`, `.get_producto_by_id`, `.get_venta_anulada_by_comanda`, `.mark_movimiento_sincronizado`, `._confirmar_anulacion`, `.save_componentes`, `.set_pos_setting`, `._load_pos_categorias`, `.delete_receta`, `._enqueue_comanda`, `.get_recetas`, `.save_categorias`, `.get_platos_categorias`, `base.py`, `.delete_plato`, `.delete_plato_categoria`, `.eliminar_venta_y_movimientos`, `.get_existencias_by_producto`, `.get_categoria`, `.get_facturas`, `.get_habitaciones_ocupadas`, `.get_platos`, `.get_platos_pos`, `.get_proveedores`, `.get_receta_by_id`, `.get_requisiciones`, `.get_ventas_correlativos`, `.migrate_proveedores_from_facturas`, `.save_produccion`, `.update_produccion_cantidad`, `.update_produccion_estado`, `.verificar_pin`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Why does `RequisicionesView` connect `RequisicionesView` to `AuditView`, `app_launcher.py`, `get_db_adaptive`, `show_error`, `unregister_sync_callback`, `inventario_view.py`, `ProduccionesView`, `ControlEntradasSalidasApp`, `requisiciones/components.py`, `VisualizeView`?**
  _High betweenness centrality (0.041) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _105 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05198537095088819 - nodes in this community are weakly interconnected._