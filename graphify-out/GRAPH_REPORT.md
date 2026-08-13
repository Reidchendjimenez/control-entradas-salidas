# Graph Report - control-entradas-salidas  (2026-08-13)

## Corpus Check
- 137 files · ~198,796 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1806 nodes · 4479 edges · 104 communities (72 shown, 32 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.59)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e716a44c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- POSLoginView
- show_error_with_copy
- ConfigPOSView
- requisiciones_view.py
- ProduccionesView
- ._go_to_main
- producciones/data.py
- ComandaPedidoView
- stock_view.py
- notifications.py
- SyncQueue
- Historial de Cambios
- InventarioView
- get_sync_manager
- whatsapp_notifier.py
- show_error
- comprobar_y_aplicar_actualizaciones
- get_colors
- ._download_all_from_server
- ._download_all_from_server
- comanda_view.py
- ControlEntradasSalidasApp
- database/__init__.py
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
- periodos.py
- app_launcher.py
- RequisicionesView
- conn.py
- POSSyncManager
- LocalReplica
- requisiciones/data.py
- OCRHandler
- PaymentsManager
- views/config.py
- POSSyncIndicator
- ValidacionDialog
- configuracion_view.py
- main_pos.py
- .set_pos_setting
- check_connection
- _colors
- graphify reference: extra exports and benchmark
- ._refresh_compras_lista
- recetas_view.py
- .get_producto_by_id
- VisualizeView
- ._ver_detalle
- _NullStream
- .get_subcategorias_by_categoria_padre
- ConfiguracionView
- RequisicionForm
- graphify reference: query, path, explain
- .save_componentes
- run_when_connected
- get_local_conn
- local_replica.py
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- get_db_adaptive
- .get_categorias
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- configurar_impresora
- .delete_receta
- ajustar_existencia
- .get_recetas
- .get_productos
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- .eliminar_usuario_dispositivo
- graphify.js
- base.py
- AGENTS.md
- .get_componentes_by_receta
- .get_contornos
- .delete_pos_categoria
- .get_producciones
- .migrate_proveedores_from_facturas
- .save_plato
- .get_platos_pos
- pos/__init__.py
- lycoris-control
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
- `get_local_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/base.py → config/config.py
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py

## Import Cycles
- None detected.

## Communities (104 total, 32 thin omitted)

### Community 0 - "POSLoginView"
Cohesion: 0.05
Nodes (10): Retorna el set de mesa_id que tienen comandas abiertas., ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView, POSLoginView (+2 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.17
Nodes (4): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), ValidacionFields

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (12): Obtiene categorías POS independientes., Obtiene categorías visibles en el POS., get_sync_queue(), Obtiene instancia singleton de SyncQueue., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial. (+4 more)

### Community 3 - "requisiciones_view.py"
Cohesion: 0.10
Nodes (23): build_detalle_row(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura., buscar_productos(), contar_detalles() (+15 more)

### Community 4 - "ProduccionesView"
Cohesion: 0.11
Nodes (5): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Orquestador del módulo Producciones. Delega la lógica a submódulos: -…, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 5 - "._go_to_main"
Cohesion: 0.21
Nodes (7): init_local_tables(), Inicializa las tablas en la base de datos local., init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Crea todas las tablas locales., LoginView

### Community 6 - "producciones/data.py"
Cohesion: 0.16
Nodes (18): cancelar_produccion(), ejecutar_descargo(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones(), productos_producidos(), Capa de datos/negocio del módulo Producciones. Funciones puras (sin UI) que… (+10 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.10
Nodes (5): Obtiene contornos activos para POS., ComandaPedidoView, Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.09
Nodes (25): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+17 more)

### Community 9 - "notifications.py"
Cohesion: 0.17
Nodes (15): Sistema global de manejo y notificación de errores. Este módulo mantiene…, Banner persistente para errores de sincronización., show_sync_error(), clear_notifications(), _get_colors(), _get_page(), Page, Sistema centralizado de notificaciones para la aplicación. Proporciona… (+7 more)

### Community 10 - "SyncQueue"
Cohesion: 0.15
Nodes (9): Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync. (+1 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 13 - "get_sync_manager"
Cohesion: 0.08
Nodes (19): is_online(), Alias de check_connection() para compatibilidad., clear_all_callbacks(), Manejo de callbacks de sincronización entre vistas., Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, Registra un callback que se ejecuta después de cada sync., Elimina un callback registrado., Limpia todos los callbacks registrados. (+11 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "show_error"
Cohesion: 0.14
Nodes (25): Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., Mostrar mensaje de advertencia (naranja)., Mostrar mensaje informativo (azul)., Función interna para mostrar SnackBar. Args: action_text: Texto para botón de…, show_error(), show_info(), _show_snackbar() (+17 more)

### Community 16 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.22
Nodes (13): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), _get_app_dir(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica. (+5 more)

### Community 17 - "get_colors"
Cohesion: 0.13
Nodes (9): Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Constantes de colores para el tema de la aplicación, Helper para obtener colores según el tema de la página, build_producto_item_row(), build_requisicion_card(), _c(), _c() (+1 more)

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (12): Limpia todos los movimientos., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Recalcula las existencias basándose en todos los movimientos. Si hay…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+4 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.06
Nodes (15): Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+7 more)

### Community 20 - "comanda_view.py"
Cohesion: 0.13
Nodes (22): Tasa de cambio guardada (Bs por USD). None si no hay ninguna., _abrir_url(), actualizar_tasa(), convertir(), formatear_bs(), formatear_tasa(), get_diagnostico(), get_tasa() (+14 more)

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.06
Nodes (24): ControlEntradasSalidasApp, Page, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager., Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de… (+16 more)

### Community 22 - "database/__init__.py"
Cohesion: 0.10
Nodes (25): Script único para migrar datos POS existentes a Supabase. Agrega todos los…, get_base(), get_db(), get_local_db(), get_local_engine(), get_local_session(), get_session(), get_session_local() (+17 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "printer.py"
Cohesion: 0.14
Nodes (21): _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers(), _find_windows_printers(), _get_usb_out_endpoint(), imprimir_comanda(), listar_impresoras() (+13 more)

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
Cohesion: 0.07
Nodes (17): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado. (+9 more)

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (18): almacen_produccion_default(), load_componentes(), planificar_descargo(), Calcula los ingredientes a descargar. Para recetas compuestas usa los…, Almacén por defecto para la descarga de materia prima de una producción. Se lee…, cancelar_produccion_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y… (+10 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.12
Nodes (8): LoadingSplash, Container, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync., Actualiza solo la etiqueta de estado (para pasos fuera del sync)., Actualiza el indicador de paso (ej. '3/5')., Marca el 100% y detiene las animaciones.

### Community 31 - "._confirmar_anulacion"
Cohesion: 0.09
Nodes (9): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta)., Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias. (+1 more)

### Community 32 - "AuditView"
Cohesion: 0.18
Nodes (3): AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 33 - "periodos.py"
Cohesion: 0.18
Nodes (22): archivar_en_supabase(), archivar_movimientos(), archivar_movimientos_local(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo… (+14 more)

### Community 34 - "app_launcher.py"
Cohesion: 0.13
Nodes (24): Logger, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, resource_path(), main(), mostrar_error_critico(), Page, get_engine(), Alias de get_local_engine() para compatibilidad. (+16 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.09
Nodes (8): build_empty_state(), load_requisiciones(), _colors(), Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "conn.py"
Cohesion: 0.16
Nodes (17): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+9 more)

### Community 37 - "POSSyncManager"
Cohesion: 0.11
Nodes (6): POSSyncManager, Sube movimientos de venta/devolucion pendientes (sincronizado=0) y los marca.…, Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Guarda timestamp del último sync., Obtiene timestamp del último sync., Estado de conexión y sincronización.

### Community 38 - "LocalReplica"
Cohesion: 0.04
Nodes (20): LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene facturas de la BD local., Obtiene requisiciones de la BD local., Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None., Elimina una venta no impresa y sus movimientos, restaurando el stock., Mapa {id: correlativo} de las ventas indicadas (una sola consulta). (+12 more)

### Community 39 - "requisiciones/data.py"
Cohesion: 0.15
Nodes (20): Existencia, Base, _cantidad_unidad_item(), crear_ajuste_stock(), eliminar_requisicion(), _encolar_requisicion_sync(), get_requisicion_audit_data(), guardar_requisicion() (+12 more)

### Community 40 - "OCRHandler"
Cohesion: 0.20
Nodes (8): check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text(), _get_long_path(), _notify_error(), OCRHandler

### Community 42 - "views/config.py"
Cohesion: 0.11
Nodes (20): Obtiene un setting de POS (ej: printer_device)., _escpos_ticket(), _get_comanda_header(), _get_configured_device(), get_correlativo_actual(), _get_header_size(), _get_next_correlativo(), Lee el correlativo actual sin incrementarlo. (+12 more)

### Community 43 - "POSSyncIndicator"
Cohesion: 0.20
Nodes (6): get_pos_sync_manager(), get_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 45 - "configuracion_view.py"
Cohesion: 0.27
Nodes (8): Categoria, Base, build_proveedores_tab(), filter_proveedores(), load_proveedores(), render_proveedores(), save_proveedor(), show_proveedor_dialog()

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 48 - "check_connection"
Cohesion: 0.33
Nodes (6): check_connection(), check_connection_async(), get_connection_status(), Retorna el estado de conexión (solo para indicador)., Verifica si hay conexión a internet (solo para indicador visual). No bloquea…, Versión async de check_connection: corre en un hilo para no bloquear el event…

### Community 49 - "_colors"
Cohesion: 0.26
Nodes (15): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog() (+7 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "._refresh_compras_lista"
Cohesion: 0.47
Nodes (3): create_categoria_header(), create_compra_lista_card(), Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 52 - "recetas_view.py"
Cohesion: 0.47
Nodes (5): delete_receta_dialog(), _build_card(), Tab Recetas: lista de recetas con cards + FAB para crear/editar., Re-renderiza una lista existente (útil tras refresh). on_edit(receta): callback…, render_recetas()

### Community 53 - ".get_producto_by_id"
Cohesion: 0.16
Nodes (6): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene una categoría por ID., Obtiene un producto por ID., Obtiene existencias de la BD local., Lee datos de la BD local y retorna (items, colors).

### Community 54 - "VisualizeView"
Cohesion: 0.29
Nodes (3): get_detalles(), Construye el texto de la requisición para compartir por WhatsApp., VisualizeView

### Community 55 - "._ver_detalle"
Cohesion: 0.15
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 56 - "_NullStream"
Cohesion: 0.17
Nodes (6): _get_app_dir(), main(), _NullStream, Page, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…

### Community 58 - "ConfiguracionView"
Cohesion: 0.16
Nodes (4): create_producto_item(), show_producto_dialog(), ConfiguracionView, Cargar datos en background con progress ring

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 63 - "get_local_conn"
Cohesion: 0.04
Nodes (19): get_local_conn(), Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene movimientos que no han sido sincronizados., Tras subir una requisición local, actualiza su id local al id remoto para que…, Registra el usuario de este dispositivo (solo una vez)., Retorna el set de habitacion_id que tienen comandas abiertas., Elimina una comanda (debe estar abierta/sin cobrar) y encola el borrado para…, Obtiene categorías de platos. (+11 more)

### Community 64 - "local_replica.py"
Cohesion: 0.12
Nodes (13): BaseSettings, Config, get_settings(), Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Settings, Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, _migrate_old_tables() (+5 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - "get_db_adaptive"
Cohesion: 0.17
Nodes (15): get_db_adaptive(), Generator que proporciona una sesión SQLite local., get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario., create_categoria_card(), create_categoria_card_from_dict(), get_card_bg() (+7 more)

### Community 75 - "configurar_impresora"
Cohesion: 0.50
Nodes (4): configurar_impresora(), Guarda el dispositivo de impresora configurado., Configura el dispositivo de impresora a usar., _set_configured_device()

### Community 77 - "ajustar_existencia"
Cohesion: 0.17
Nodes (8): Obtiene existencia por producto y almacén., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén., ajustar_existencia(), Ajusta el stock de un producto en un almacén al conteo físico real. Registra un…

### Community 85 - "base.py"
Cohesion: 0.07
Nodes (22): Base de datos - SQLite como única fuente de verdad. El sistema ahora funciona…, CompraListaItem, Base, Factura, Base, MovimientoArchivo, Base, Movimiento (+14 more)

## Knowledge Gaps
- **105 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **32 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `POSLoginView`, `show_error_with_copy`, `ConfigPOSView`, `._go_to_main`, `producciones/data.py`, `ComandaPedidoView`, `stock_view.py`, `SyncQueue`, `InventarioView`, `get_sync_manager`, `whatsapp_notifier.py`, `show_error`, `get_colors`, `._download_all_from_server`, `._download_all_from_server`, `comanda_view.py`, `database/__init__.py`, `printer.py`, `RecetaEditor`, `SyncManager`, `producciones/dialogs.py`, `._confirmar_anulacion`, `AuditView`, `periodos.py`, `app_launcher.py`, `POSSyncManager`, `requisiciones/data.py`, `OCRHandler`, `views/config.py`, `configuracion_view.py`, `.set_pos_setting`, `_colors`, `.get_producto_by_id`, `._ver_detalle`, `.get_subcategorias_by_categoria_padre`, `.save_componentes`, `get_local_conn`, `local_replica.py`, `get_db_adaptive`, `.get_categorias`, `.delete_receta`, `ajustar_existencia`, `.get_recetas`, `.get_productos`, `.eliminar_usuario_dispositivo`, `base.py`, `.get_componentes_by_receta`, `.get_contornos`, `.delete_pos_categoria`, `.get_producciones`, `.migrate_proveedores_from_facturas`, `.save_plato`, `.get_platos_pos`, `.update_produccion_cantidad`, `.verificar_pin`?**
  _High betweenness centrality (0.373) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `POSLoginView`, `ConfigPOSView`, `requisiciones_view.py`, `._go_to_main`, `ComandaPedidoView`, `SyncQueue`, `InventarioView`, `get_sync_manager`, `whatsapp_notifier.py`, `show_error`, `._download_all_from_server`, `._download_all_from_server`, `database/__init__.py`, `SyncManager`, `._confirmar_anulacion`, `periodos.py`, `RequisicionesView`, `conn.py`, `POSSyncManager`, `LocalReplica`, `views/config.py`, `.set_pos_setting`, `.get_producto_by_id`, `._ver_detalle`, `.get_subcategorias_by_categoria_padre`, `.save_componentes`, `local_replica.py`, `get_db_adaptive`, `.get_categorias`, `.delete_receta`, `ajustar_existencia`, `.get_recetas`, `.get_productos`, `.eliminar_usuario_dispositivo`, `.get_componentes_by_receta`, `.get_contornos`, `.delete_pos_categoria`, `.get_producciones`, `.migrate_proveedores_from_facturas`, `.save_plato`, `.get_platos_pos`, `.update_produccion_cantidad`, `.verificar_pin`?**
  _High betweenness centrality (0.092) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `POSLoginView`, `views/config.py`, `LocalReplica`?**
  _High betweenness centrality (0.045) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _105 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `POSLoginView` be split into smaller, more focused modules?**
  _Cohesion score 0.05041797283176593 - nodes in this community are weakly interconnected._