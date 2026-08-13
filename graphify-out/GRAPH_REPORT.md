# Graph Report - control-entradas-salidas  (2026-08-13)

## Corpus Check
- 133 files · ~198,379 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1803 nodes · 4470 edges · 112 communities (75 shown, 37 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.59)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `049063bd`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- ConfigPOSView
- requisiciones_view.py
- show_error
- ._go_to_main
- .get_existencias_by_producto
- ComandaPedidoView
- get_db_adaptive
- inventario_view.py
- SyncQueue
- Historial de Cambios
- InventarioView
- validacion_view.py
- whatsapp_notifier.py
- requisiciones/data.py
- ConfiguracionView
- get_colors
- ._download_all_from_server
- ._download_all_from_server
- launcher.py
- ControlEntradasSalidasApp
- base.py
- HistorialFacturasView
- POSSyncIndicator
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/data.py
- LoadingSplash
- ._enqueue_comanda
- AuditView
- ._log
- app_launcher.py
- RequisicionesView
- historial_facturas_view.py
- POSSyncManager
- get_local_conn
- pos/data.py
- ._confirmar_anulacion
- movimientos.py
- printer.py
- comanda_view.py
- test_imprimir
- .get_pos_setting
- main_pos.py
- views/config.py
- .get_productos
- _colors
- graphify reference: extra exports and benchmark
- ._build_compras_lista_data
- periodos.py
- .resolver_movimientos_venta
- error_handler.py
- ._ver_detalle
- _NullStream
- .get_componentes_by_receta
- .full_sync
- form.py
- graphify reference: query, path, explain
- .save_componentes
- Settings
- LocalReplica
- local_replica.py
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- .get_last_sync
- run_when_connected
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- app_controller.py
- .delete_receta
- .mark_movimiento_sincronizado
- .get_recetas
- .get_almacenes
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- .save_categorias
- graphify.js
- models/__init__.py
- AGENTS.md
- .get_detalles_by_produccion
- _get_configured_device
- categories.py
- .delete_plato
- .delete_plato_categoria
- .delete_pos_categoria
- .get_categoria
- .get_comanda_abierta
- .get_contornos
- .get_habitaciones_ocupadas
- .get_platos
- .get_proveedor_by_nombre
- .get_recetas_que_producen
- .get_requisiciones
- pos/__init__.py
- lycoris-control
- .save_plato
- .save_plato_contornos
- .update_produccion_estado

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

## Communities (112 total, 37 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (9): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView, MesasView (+1 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.05
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.09
Nodes (6): Obtiene categorías POS independientes., get_sync_queue(), Obtiene instancia singleton de SyncQueue., get_pos_sync_indicator(), ConfigPOSView, Fuerza sync con Supabase y recarga todos los datos POS.

### Community 3 - "requisiciones_view.py"
Cohesion: 0.11
Nodes (27): build_detalle_row(), build_empty_state(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., contar_detalles() (+19 more)

### Community 4 - "show_error"
Cohesion: 0.16
Nodes (26): Sistema centralizado de notificaciones para la aplicación. Proporciona…, Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., Mostrar mensaje de advertencia (naranja)., Mostrar mensaje informativo (azul)., Función interna para mostrar SnackBar. Args: action_text: Texto para botón de…, show_error(), show_info() (+18 more)

### Community 5 - "._go_to_main"
Cohesion: 0.21
Nodes (6): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Registra el usuario de este dispositivo (solo una vez)., Crea todas las tablas locales., LoginView

### Community 6 - ".get_existencias_by_producto"
Cohesion: 0.50
Nodes (3): Obtiene todas las existencias de un producto (sumadas por almacén)., Suma de existencias de un producto en todos los almacenes., stock_total_producto()

### Community 7 - "ComandaPedidoView"
Cohesion: 0.10
Nodes (5): Obtiene contornos activos para POS., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "get_db_adaptive"
Cohesion: 0.10
Nodes (20): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Elimina duplicados de existencias para un producto específico. Conserva el…, Producto, Base, build_product_card(), build_stat_card(), filter_products_db() (+12 more)

### Community 9 - "inventario_view.py"
Cohesion: 0.17
Nodes (16): Obtiene existencia por producto y almacén., get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén., Constantes de colores para el tema de la aplicación, show_agregar_producto_dialog(), show_cantidad_dialog(), show_correccion_dialog(), get_attr() (+8 more)

### Community 10 - "SyncQueue"
Cohesion: 0.13
Nodes (10): Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Inicializa la tabla de cola., Asegura que las tablas de la cola existan (defensa ante arranques donde… (+2 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.14
Nodes (3): get_sync_manager(), get_safe_colors(), InventarioView

### Community 13 - "validacion_view.py"
Cohesion: 0.10
Nodes (12): is_online(), Alias de check_connection() para compatibilidad., clear_all_callbacks(), Manejo de callbacks de sincronización entre vistas., Registra un callback que se ejecuta después de cada sync., Elimina un callback registrado., Limpia todos los callbacks registrados., register_sync_callback() (+4 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.08
Nodes (23): Control, Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, schedule_load(), Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending() (+15 more)

### Community 15 - "requisiciones/data.py"
Cohesion: 0.11
Nodes (24): Existencia, Base, Base, RequisicionDetalle, buscar_productos(), _cantidad_unidad_item(), crear_ajuste_stock(), eliminar_requisicion() (+16 more)

### Community 17 - "get_colors"
Cohesion: 0.15
Nodes (5): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Helper para obtener colores según el tema de la página, get_colors_safe(), ValidacionView

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (12): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Recalcula las existencias basándose en todos los movimientos. Si hay…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+4 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 20 - "launcher.py"
Cohesion: 0.11
Nodes (26): Text, ensure_local_db(), Asegura que la BD local existe. Llamar después de set_db_path()., main(), Page, Launcher para el POS con soporte de actualizaciones., _resource_path(), init_pos_sync_indicator() (+18 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.08
Nodes (16): ControlEntradasSalidasApp, Page, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager., Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de…, apply_theme_to_button() (+8 more)

### Community 22 - "base.py"
Cohesion: 0.14
Nodes (21): check_connection(), get_base(), get_connection_status(), get_db(), get_local_db(), get_local_engine(), get_local_session(), get_session() (+13 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "POSSyncIndicator"
Cohesion: 0.21
Nodes (4): POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

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
Cohesion: 0.13
Nodes (6): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Registra función a llamar con cada paso del sync (msg: str)., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado., SyncManager

### Community 29 - "producciones/data.py"
Cohesion: 0.09
Nodes (42): Obtiene un producto por ID., almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta() (+34 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 31 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 32 - "AuditView"
Cohesion: 0.18
Nodes (3): AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 33 - "._log"
Cohesion: 0.19
Nodes (6): Print + notificar progreso visual., Notifica a todos los callbacks registrados., Inicia sincronización en segundo plano cada interval_seconds., Loop de sync en background., Procesa la cola de sync - sube pendientes y descarga cambios., Sube elementos de la cola a Supabase usando SQL directo.

### Community 34 - "app_launcher.py"
Cohesion: 0.13
Nodes (18): _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico() (+10 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.08
Nodes (6): Requisicion, Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "historial_facturas_view.py"
Cohesion: 0.13
Nodes (21): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+13 more)

### Community 38 - "get_local_conn"
Cohesion: 0.04
Nodes (17): get_local_conn(), Obtiene facturas de la BD local., Verifica el PIN del usuario., Resetea el usuario (para cambio de operador)., Retorna el set de mesa_id que tienen comandas abiertas., Obtiene sub-categorias (platos_categorias) de una categoria POS., Crea o actualiza una categoría de plato., Obtiene un plato con sus ingredientes. (+9 more)

### Community 39 - "pos/data.py"
Cohesion: 0.50
Nodes (3): get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario.

### Community 40 - "._confirmar_anulacion"
Cohesion: 0.12
Nodes (6): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 41 - "movimientos.py"
Cohesion: 0.27
Nodes (10): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+2 more)

### Community 42 - "printer.py"
Cohesion: 0.15
Nodes (19): _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_usb_out_endpoint(), imprimir_comanda(), listar_impresoras() (+11 more)

### Community 43 - "comanda_view.py"
Cohesion: 0.16
Nodes (17): _escpos_ticket(), Genera los bytes ESC/POS para un ticket de comanda. Si correlativo es None se…, _abrir_url(), convertir(), formatear_bs(), formatear_tasa(), get_tasa(), _obtener_tasa_fallback() (+9 more)

### Community 44 - "test_imprimir"
Cohesion: 0.20
Nodes (7): Imprime una pagina de prueba para verificar la impresora., Establece el valor inicial del correlativo., set_correlativo_inicial(), test_imprimir(), Construye el contenido de la pestaña de impresora., Establece el correlativo inicial., Prueba la impresion en la impresora configurada.

### Community 45 - ".get_pos_setting"
Cohesion: 0.18
Nodes (9): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _get_comanda_header(), get_correlativo_actual(), _get_header_size(), Lee el correlativo actual sin incrementarlo., Obtiene el tamaño del membrete: 'small', 'normal', 'large'., Obtiene la configuracion del membrete de comanda. (+1 more)

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - "views/config.py"
Cohesion: 0.16
Nodes (12): Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., configurar_impresora(), _get_next_correlativo(), Guarda el tamaño del membrete: 'small', 'normal', 'large'., Guarda el dispositivo de impresora configurado., Configura el dispositivo de impresora a usar., Obtiene el siguiente numero de correlativo y lo incrementa., Guarda la configuracion del membrete. (+4 more)

### Community 49 - "_colors"
Cohesion: 0.17
Nodes (26): Cola de sincronización unificada para trabajo offline-first. Maneja: - Cola de…, Exception, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error(), _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), show_categoria_dialog() (+18 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "._build_compras_lista_data"
Cohesion: 0.29
Nodes (4): create_categoria_header(), create_compra_lista_card(), Lee datos de la BD local y retorna (items, colors)., Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 52 - "periodos.py"
Cohesion: 0.18
Nodes (22): archivar_en_supabase(), archivar_movimientos(), archivar_movimientos_local(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo… (+14 more)

### Community 54 - "error_handler.py"
Cohesion: 0.15
Nodes (14): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Page, Obtiene la página activa desde sys o desde la pila de llamadas. (+6 more)

### Community 55 - "._ver_detalle"
Cohesion: 0.15
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 58 - ".full_sync"
Cohesion: 0.22
Nodes (4): Guarda timestamp del último sync., Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Verifica si hay conexión a la base de datos remota.

### Community 59 - "form.py"
Cohesion: 0.13
Nodes (6): build_producto_item_row(), build_requisicion_card(), _c(), _c(), RequisicionForm, RequisicionService

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 62 - "Settings"
Cohesion: 0.25
Nodes (5): BaseSettings, Config, Identificador único del dispositivo., Construye la URL de conexión a la base de datos de forma segura., Settings

### Community 63 - "LocalReplica"
Cohesion: 0.04
Nodes (19): LocalReplica, Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene movimientos que no han sido sincronizados., Tras subir una requisición local, actualiza su id local al id remoto para que…, Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para…, Elimina una venta no impresa y sus movimientos, restaurando el stock., Mapa {id: correlativo} de las ventas indicadas (una sola consulta). (+11 more)

### Community 64 - "local_replica.py"
Cohesion: 0.13
Nodes (14): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, _migrate_old_tables(), Réplica local SQLite para trabajo offline. Almacena una copia de los datos de…, Migra datos de tablas old (local_*) a tablas nuevas si existen datos en old., Migraciones automáticas para tablas POS., _run_pos_migrations() (+6 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - ".get_last_sync"
Cohesion: 0.29
Nodes (3): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 75 - "app_controller.py"
Cohesion: 0.40
Nodes (4): Logger, get_logger(), Módulo de logging centralizado para la aplicación. Proporciona logging a…, Obtiene un logger configurado con handlers para archivo y consola. Args: name:…

### Community 77 - ".mark_movimiento_sincronizado"
Cohesion: 0.33
Nodes (4): Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync()

### Community 83 - ".save_categorias"
Cohesion: 0.33
Nodes (3): Guarda categorías en la base de datos local (upsert, no borra)., Obtiene todas las categorías de la BD local., Lee caché local y (si hay conexión) consulta el servidor. Corre en hilo aparte…

### Community 85 - "models/__init__.py"
Cohesion: 0.06
Nodes (20): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, Factura, FacturaPago (+12 more)

### Community 88 - "_get_configured_device"
Cohesion: 0.33
Nodes (4): _get_configured_device(), Obtiene el dispositivo de impresora configurado por el usuario., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora.

### Community 89 - "categories.py"
Cohesion: 0.40
Nodes (4): create_categoria_card(), create_categoria_card_from_dict(), get_card_bg(), generar_color()

## Knowledge Gaps
- **105 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `ConfigPOSView`, `show_error`, `._go_to_main`, `.get_existencias_by_producto`, `ComandaPedidoView`, `get_db_adaptive`, `inventario_view.py`, `SyncQueue`, `InventarioView`, `validacion_view.py`, `whatsapp_notifier.py`, `requisiciones/data.py`, `get_colors`, `._download_all_from_server`, `._download_all_from_server`, `base.py`, `RecetaEditor`, `SyncManager`, `producciones/data.py`, `._enqueue_comanda`, `AuditView`, `app_launcher.py`, `POSSyncManager`, `get_local_conn`, `pos/data.py`, `._confirmar_anulacion`, `printer.py`, `comanda_view.py`, `.get_pos_setting`, `views/config.py`, `.get_productos`, `_colors`, `periodos.py`, `.resolver_movimientos_venta`, `._ver_detalle`, `.get_componentes_by_receta`, `.full_sync`, `.save_componentes`, `local_replica.py`, `.get_last_sync`, `.delete_receta`, `.mark_movimiento_sincronizado`, `.get_recetas`, `.get_almacenes`, `.save_categorias`, `.get_detalles_by_produccion`, `.delete_plato`, `.delete_plato_categoria`, `.delete_pos_categoria`, `.get_categoria`, `.get_comanda_abierta`, `.get_contornos`, `.get_habitaciones_ocupadas`, `.get_platos`, `.get_proveedor_by_nombre`, `.get_recetas_que_producen`, `.get_requisiciones`, `.save_plato`, `.save_plato_contornos`, `.update_produccion_estado`?**
  _High betweenness centrality (0.377) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `ConfigPOSView`, `requisiciones_view.py`, `._go_to_main`, `.get_existencias_by_producto`, `ComandaPedidoView`, `get_db_adaptive`, `inventario_view.py`, `SyncQueue`, `InventarioView`, `validacion_view.py`, `whatsapp_notifier.py`, `._download_all_from_server`, `._download_all_from_server`, `base.py`, `SyncManager`, `producciones/data.py`, `._enqueue_comanda`, `RequisicionesView`, `historial_facturas_view.py`, `POSSyncManager`, `._confirmar_anulacion`, `.get_pos_setting`, `views/config.py`, `.get_productos`, `_colors`, `._build_compras_lista_data`, `periodos.py`, `.resolver_movimientos_venta`, `._ver_detalle`, `.get_componentes_by_receta`, `.full_sync`, `.save_componentes`, `LocalReplica`, `local_replica.py`, `.get_last_sync`, `.delete_receta`, `.mark_movimiento_sincronizado`, `.get_recetas`, `.get_almacenes`, `.save_categorias`, `.get_detalles_by_produccion`, `.delete_plato`, `.delete_plato_categoria`, `.delete_pos_categoria`, `.get_categoria`, `.get_comanda_abierta`, `.get_contornos`, `.get_habitaciones_ocupadas`, `.get_platos`, `.get_proveedor_by_nombre`, `.get_recetas_que_producen`, `.get_requisiciones`, `.save_plato`, `.save_plato_contornos`, `.update_produccion_estado`?**
  _High betweenness centrality (0.095) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `POSLoginView`, `test_imprimir`, `.get_pos_setting`, `views/config.py`, `_get_configured_device`, `LocalReplica`?**
  _High betweenness centrality (0.045) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _105 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05225718194254446 - nodes in this community are weakly interconnected._