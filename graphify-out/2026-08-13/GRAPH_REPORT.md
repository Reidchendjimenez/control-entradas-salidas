# Graph Report - control-entradas-salidas  (2026-08-13)

## Corpus Check
- 133 files · ~198,469 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1806 nodes · 4477 edges · 104 communities (68 shown, 36 thin omitted)
- Extraction: 98% EXTRACTED · 2% INFERRED · 0% AMBIGUOUS · INFERRED: 80 edges (avg confidence: 0.59)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e8310908`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- ComandasView
- show_error_with_copy
- ConfigPOSView
- get_db_adaptive
- POSLoginView
- ._go_to_main
- producciones/data.py
- ComandaPedidoView
- stock_view.py
- show_error
- SyncQueue
- Historial de Cambios
- InventarioView
- unregister_sync_callback
- whatsapp_notifier.py
- ProduccionesView
- comprobar_y_aplicar_actualizaciones
- get_colors
- ._download_all_from_server
- ._download_all_from_server
- POSSyncIndicator
- ControlEntradasSalidasApp
- base.py
- HistorialFacturasView
- VentasView
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/dialogs.py
- LoadingSplash
- ._enqueue_comanda
- show_warning
- MesasView
- app_launcher.py
- RequisicionesView
- conn.py
- POSSyncManager
- LocalReplica
- pos/data.py
- ._enqueue_venta
- movimientos.py
- printer.py
- .aplicar_movimientos_venta
- .get_contornos_activos
- reset_database
- main_pos.py
- .set_pos_setting
- .get_usuario_dispositivo
- get_sync_queue
- graphify reference: extra exports and benchmark
- .get_existencias_by_producto_almacen
- .get_producto_by_id
- launcher.py
- .get_venta_anulada_by_comanda
- _NullStream
- ._on_categoria_click
- .get_productos
- RequisicionForm
- graphify reference: query, path, explain
- .save_componentes
- .clear_productos
- get_local_conn
- get_settings
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- .get_last_sync
- .save_produccion_detalle
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- .dedupe_existencias_producto
- .delete_receta
- ajustar_existencia
- .get_recetas
- .delete_plato_categoria
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- .get_categoria
- graphify.js
- models/__init__.py
- AGENTS.md
- .get_componentes_by_receta
- .get_existencias
- .get_movimientos
- .get_plato_contornos
- .get_receta_by_id
- .get_recetas_que_producen
- .migrate_proveedores_from_facturas
- .update_existencia
- pos/__init__.py
- lycoris-control
- .update_produccion_estado

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

## Communities (104 total, 36 thin omitted)

### Community 0 - "ComandasView"
Cohesion: 0.12
Nodes (4): ComandasView, HabitacionesView, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Obtiene categorías POS independientes., Obtiene categorías visibles en el POS., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora. (+2 more)

### Community 3 - "get_db_adaptive"
Cohesion: 0.09
Nodes (45): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Constantes de colores para el tema de la aplicación, build_detalle_row(), build_producto_busqueda_item(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista. (+37 more)

### Community 4 - "POSLoginView"
Cohesion: 0.15
Nodes (4): Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, PosView, POSLoginView, Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…

### Community 6 - "producciones/data.py"
Cohesion: 0.12
Nodes (23): almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta(), load_producciones() (+15 more)

### Community 7 - "ComandaPedidoView"
Cohesion: 0.11
Nodes (3): ComandaPedidoView, Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.10
Nodes (19): Registra un callback que se ejecuta después de cada sync., register_sync_callback(), Producto, Base, build_product_card(), build_stat_card(), filter_products_db(), get_existencias_map() (+11 more)

### Community 9 - "show_error"
Cohesion: 0.08
Nodes (40): Logger, get_sync_manager(), Exception, Sistema global de manejo y notificación de errores. Este módulo mantiene…, Muestra el error en consola Y en pantalla como SnackBar rojo., show_error(), get_logger(), Módulo de logging centralizado para la aplicación. Proporciona logging a… (+32 more)

### Community 10 - "SyncQueue"
Cohesion: 0.12
Nodes (10): Marca operación como completada., Maneja la cola de sincronización., Marca operación como fallida., Obtiene estado de la cola., Guarda timestamp del último sync., Limpia operaciones completadas antiguas., Obtiene número de operaciones pendientes., Asegura que las tablas de la cola existan (defensa ante arranques donde… (+2 more)

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "InventarioView"
Cohesion: 0.09
Nodes (7): Obtiene todas las categorías de la BD local., get_safe_colors(), create_categoria_header(), create_compra_lista_card(), InventarioView, Lee datos de la BD local y retorna (items, colors)., Recarga datos y reconstruye la lista de compras con un ListView fresco.

### Community 13 - "unregister_sync_callback"
Cohesion: 0.18
Nodes (5): clear_all_callbacks(), Manejo de callbacks de sincronización entre vistas., Elimina un callback registrado., Limpia todos los callbacks registrados., unregister_sync_callback()

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.08
Nodes (23): Control, Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, schedule_load(), Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending() (+15 more)

### Community 15 - "ProduccionesView"
Cohesion: 0.12
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 16 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.22
Nodes (13): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), _get_app_dir(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica. (+5 more)

### Community 17 - "get_colors"
Cohesion: 0.14
Nodes (9): get_colors(), Helper para obtener colores según el tema de la página, build_producto_item_row(), build_requisicion_card(), _c(), _c(), get_colors_safe(), build_ajuste_dialog() (+1 more)

### Community 18 - "._download_all_from_server"
Cohesion: 0.07
Nodes (13): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Guarda lista de recetas (bulk upsert para sync)., Guarda lista de componentes de receta (bulk upsert para sync)., Guarda lista de producciones (bulk upsert para sync). (+5 more)

### Community 19 - "._download_all_from_server"
Cohesion: 0.07
Nodes (14): Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga., Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync. (+6 more)

### Community 20 - "POSSyncIndicator"
Cohesion: 0.20
Nodes (7): get_pos_sync_manager(), get_pos_sync_indicator(), init_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.07
Nodes (17): ControlEntradasSalidasApp, Page, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager., Cierra el BottomSheet del menú 'Más' y ejecuta `accion` tras la animación de…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado… (+9 more)

### Community 22 - "base.py"
Cohesion: 0.08
Nodes (32): check_connection(), check_connection_async(), get_base(), get_connection_status(), get_db(), get_local_db(), get_local_engine(), get_local_session() (+24 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.15
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

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
Cohesion: 0.09
Nodes (15): Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata., Registra función a llamar con cada paso del sync (msg: str)., Print + notificar progreso visual., Registra función a llamar cada vez que termina un sync., Registra un callback que se ejecuta cuando termina un sync., Elimina un callback registrado. (+7 more)

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (19): cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente., colors(), fmt_fecha() (+11 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 31 - "._enqueue_comanda"
Cohesion: 0.29
Nodes (3): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta).

### Community 32 - "show_warning"
Cohesion: 0.10
Nodes (5): Mostrar mensaje de advertencia (naranja)., show_warning(), AuditView, build_empty_state(), VisualizeView

### Community 34 - "app_launcher.py"
Cohesion: 0.16
Nodes (16): _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico() (+8 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.08
Nodes (7): Ejecuta `handler` en el event loop de la página solo si la sesión web ya está…, run_when_connected(), Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Fuerza una sincronización con Supabase y recarga la lista., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "conn.py"
Cohesion: 0.15
Nodes (19): _candidate_env_paths(), Rutas candidatas para buscar .env en orden de prioridad., Connection, Path, get_cache(), get_cache_any_age(), init_cache_db(), Sistema de caché local para trabajo offline. Solo maneja cache de datos (no… (+11 more)

### Community 38 - "LocalReplica"
Cohesion: 0.04
Nodes (19): LocalReplica, Obtiene todas las existencias de un producto (sumadas por almacén)., Obtiene movimientos que no han sido sincronizados., Tras subir una requisición local, actualiza su id local al id remoto para que…, Registra el usuario de este dispositivo (solo una vez)., Verifica el PIN del usuario., Retorna la comanda abierta (con items parseados) de la mesa/habitacion, o None., Retorna el set de mesa_id que tienen comandas abiertas. (+11 more)

### Community 39 - "pos/data.py"
Cohesion: 0.50
Nodes (3): get_productos_activos(), Funciones de acceso a datos para el POS. Comparte la BD con el sistema de…, Obtiene todos los productos activos del inventario.

### Community 40 - "._enqueue_venta"
Cohesion: 0.33
Nodes (3): Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta).

### Community 41 - "movimientos.py"
Cohesion: 0.33
Nodes (9): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+1 more)

### Community 42 - "printer.py"
Cohesion: 0.05
Nodes (67): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., configurar_impresora(), _escpos_ticket(), _find_printer_device(), _find_printer_device_auto(), _find_serial_printers(), _find_usb_printers() (+59 more)

### Community 43 - ".aplicar_movimientos_venta"
Cohesion: 0.33
Nodes (3): Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias., Revierte la salida de mercancia de una venta anulada (tipo 'devolucion').

### Community 44 - ".get_contornos_activos"
Cohesion: 0.33
Nodes (3): Obtiene categorías de platos., Obtiene contornos activos para POS., Categorias de platos (sin padre) excluyendo las de contornos.

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - ".set_pos_setting"
Cohesion: 0.33
Nodes (3): Guarda la tasa de cambio (Bs por USD) junto con la fecha de actualizacion., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Inicializa la tabla de cola.

### Community 48 - ".get_usuario_dispositivo"
Cohesion: 0.33
Nodes (4): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Crea todas las tablas locales.

### Community 49 - "get_sync_queue"
Cohesion: 0.06
Nodes (70): Script único para migrar datos POS existentes a Supabase. Agrega todos los…, archivar_en_supabase(), archivar_movimientos(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo… (+62 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - ".get_existencias_by_producto_almacen"
Cohesion: 0.50
Nodes (3): Obtiene existencia por producto y almacén., get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén.

### Community 53 - ".get_producto_by_id"
Cohesion: 0.32
Nodes (3): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene un producto por ID.

### Community 54 - "launcher.py"
Cohesion: 0.21
Nodes (11): init_pos_sync_manager(), Page, Registrar la página activa. Llamar desde main.py al iniciar., set_page(), Page, Registrar la página activa para mostrar notificaciones., set_page(), main() (+3 more)

### Community 55 - ".get_venta_anulada_by_comanda"
Cohesion: 0.25
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 57 - "._on_categoria_click"
Cohesion: 0.29
Nodes (3): Obtiene sub-categorias (platos_categorias) de una categoria de inventario., Obtiene sub-categorias (platos_categorias) de una categoria POS., Obtiene productos del POS: activos y marcados para la venta.

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 63 - "get_local_conn"
Cohesion: 0.04
Nodes (19): archivar_movimientos_local(), Archiva movimientos en la BD local., get_local_conn(), Devuelve la lista de almacenes existentes (valores únicos)., Obtiene facturas de la BD local., Obtiene requisiciones de la BD local., Resetea el usuario (para cambio de operador)., Retorna el set de habitacion_id que tienen comandas abiertas. (+11 more)

### Community 64 - "get_settings"
Cohesion: 0.10
Nodes (15): BaseSettings, Config, get_settings(), Identificador único del dispositivo., Construye la URL de conexión a la base de datos de forma segura., Settings, Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, Sincronización bidireccional exclusiva para módulo POS. Solo maneja tablas POS:… (+7 more)

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

### Community 77 - "ajustar_existencia"
Cohesion: 0.25
Nodes (7): Guarda un movimiento en la BD local., Marca un movimiento como sincronizado., Guarda un movimiento en local y opcionalmente lo sincroniza. Retorna True si se…, save_movimiento_with_sync(), ajustar_existencia(), _encolar_sync(), Ajusta el stock de un producto en un almacén al conteo físico real. Registra un…

### Community 85 - "models/__init__.py"
Cohesion: 0.07
Nodes (21): Categoria, Base, CompraListaItem, Base, Existencia, Base, MovimientoArchivo, Base (+13 more)

## Knowledge Gaps
- **105 isolated node(s):** `Config`, `install_opencode.sh script`, `GITHUB_TOKEN`, `lycoris-control`, `graphify` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **36 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `ComandasView`, `show_error_with_copy`, `ConfigPOSView`, `get_db_adaptive`, `POSLoginView`, `._go_to_main`, `producciones/data.py`, `ComandaPedidoView`, `stock_view.py`, `show_error`, `SyncQueue`, `InventarioView`, `whatsapp_notifier.py`, `get_colors`, `._download_all_from_server`, `._download_all_from_server`, `base.py`, `VentasView`, `RecetaEditor`, `SyncManager`, `producciones/dialogs.py`, `._enqueue_comanda`, `show_warning`, `MesasView`, `app_launcher.py`, `POSSyncManager`, `pos/data.py`, `._enqueue_venta`, `printer.py`, `.aplicar_movimientos_venta`, `.get_contornos_activos`, `.set_pos_setting`, `.get_usuario_dispositivo`, `get_sync_queue`, `.get_existencias_by_producto_almacen`, `.crear_pos_usuario`, `.get_producto_by_id`, `.get_venta_anulada_by_comanda`, `._on_categoria_click`, `.get_productos`, `.save_componentes`, `.clear_productos`, `get_local_conn`, `get_settings`, `.get_last_sync`, `.save_produccion_detalle`, `.dedupe_existencias_producto`, `.delete_receta`, `ajustar_existencia`, `.get_recetas`, `.delete_plato_categoria`, `.get_categoria`, `.get_componentes_by_receta`, `.get_existencias`, `.get_movimientos`, `.get_plato_contornos`, `.get_receta_by_id`, `.get_recetas_que_producen`, `.migrate_proveedores_from_facturas`, `.update_existencia`, `.update_produccion_estado`?**
  _High betweenness centrality (0.385) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `get_local_conn` to `ComandasView`, `ConfigPOSView`, `get_db_adaptive`, `show_error`, `SyncQueue`, `InventarioView`, `whatsapp_notifier.py`, `._download_all_from_server`, `._download_all_from_server`, `base.py`, `VentasView`, `SyncManager`, `._enqueue_comanda`, `RequisicionesView`, `conn.py`, `POSSyncManager`, `LocalReplica`, `._enqueue_venta`, `printer.py`, `.aplicar_movimientos_venta`, `.get_contornos_activos`, `.set_pos_setting`, `.get_usuario_dispositivo`, `get_sync_queue`, `.get_existencias_by_producto_almacen`, `.crear_pos_usuario`, `.get_producto_by_id`, `.get_venta_anulada_by_comanda`, `._on_categoria_click`, `.get_productos`, `.save_componentes`, `.clear_productos`, `get_settings`, `.get_last_sync`, `.save_produccion_detalle`, `.dedupe_existencias_producto`, `.delete_receta`, `ajustar_existencia`, `.get_recetas`, `.delete_plato_categoria`, `.get_categoria`, `.get_componentes_by_receta`, `.get_existencias`, `.get_movimientos`, `.get_plato_contornos`, `.get_receta_by_id`, `.get_recetas_que_producen`, `.migrate_proveedores_from_facturas`, `.update_existencia`, `.update_produccion_estado`?**
  _High betweenness centrality (0.098) - this node is a cross-community bridge._
- **Why does `ConfigPOSView` connect `ConfigPOSView` to `ComandasView`, `printer.py`, `POSLoginView`, `LocalReplica`?**
  _High betweenness centrality (0.045) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Config`, `install_opencode.sh script`, `GITHUB_TOKEN` to the rest of the system?**
  _105 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `ComandasView` be split into smaller, more focused modules?**
  _Cohesion score 0.12473118279569892 - nodes in this community are weakly interconnected._