# Graph Report - control-entradas-salidas  (2026-08-13)

## Corpus Check
- 188 files · ~280,198 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 3376 nodes · 7734 edges · 228 communities (111 shown, 117 thin omitted)
- Extraction: 95% EXTRACTED · 5% INFERRED · 0% AMBIGUOUS · INFERRED: 416 edges (avg confidence: 0.53)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f14af054`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- requisiciones_view.py
- show_error_with_copy
- ConfigPOSView
- get_db_adaptive
- ProduccionesView
- ._go_to_main
- producciones/data.py
- ._load_categorias
- stock_view.py
- schedule_load
- ._ensure_tables
- Historial de Cambios
- inventario_view.py
- get_colors
- whatsapp_notifier.py
- drift_worker.js
- comprobar_y_aplicar_actualizaciones
- models/__init__.py
- ._download_all_from_server
- POSSyncManager
- _abrir_url
- ControlEntradasSalidasApp
- base.py
- HistorialFacturasView
- show_error
- RecetaEditor
- What You Must Do When Invoked
- What You Must Do When Invoked
- SyncManager
- producciones/dialogs.py
- LoadingSplash
- ._confirmar_anulacion
- AuditView
- periodos.py
- launcher.py
- RequisicionesView
- conn.py
- app_database.dart
- LocalReplica
- a
- ComandasView
- Requisicion
- r
- POSSyncIndicator
- c
- N
- main_pos.py
- aQ
- i
- _colors
- graphify reference: extra exports and benchmark
- DataClass
- 4. Módulos feature por feature
- .get_producto_by_id
- sync_engine.dart
- ._ver_detalle
- _NullStream
- a5
- my_application.cc
- ComandaPedidoView
- graphify reference: query, path, explain
- .save_componentes
- app_launcher.py
- app_shell.dart
- sync_service.dart
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- reset_requisiciones.py
- .get_existencias_by_producto_almacen
- .save_categorias
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- _frozen_runtime_hook.py
- install_opencode.sh
- bg
- ka
- Table
- .get_recetas
- .get_productos
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- AppDelegate
- graphify.js
- POSLoginView
- AGENTS.md
- login_screen.dart
- VentasView
- inventario_screen.dart
- O
- win32_window.cpp
- FlutterWindow
- inventario_repository.dart
- app_theme.dart
- session_controller.dart
- ei
- Win32Window
- wWinMain
- movimientos.py
- package:flutter_riverpod/flutter_riverpod.dart
- pos/__init__.py
- lycoris-control
- manifest.json
- get_theme
- HabitacionesView
- MesasView
- MessageHandler
- app_config.dart
- AppDatabase
- sync_tables.dart
- app_colors.dart
- .get_usuario_dispositivo
- Control de Entradas y Salidas — App Flutter
- RegisterPlugins
- MainActivity.kt
- LaunchImage.imageset/README.md
- ProduccionDetallesCompanion
- activo
- actualizada
- almacen
- almacenPredeterminado
- cantidad
- cantidadAnterior
- cantidadNueva
- cantidadProducida
- cantidadSurtida
- categoriaId
- cocineros
- codigo
- color
- configuradoEn
- contacto
- creadaPor
- createdAt
- data
- descripcion
- destino
- direccion
- email
- esPesable
- estado
- facturaId
- fechaApertura
- fechaCreacion
- fechaFactura
- fechaMovimiento
- fechaPago
- fechaProcesamiento
- fechaProduccion
- fechaRecepcion
- fechaValidacion
- id
- imagen
- ingrediente
- key
- lastError
- monto
- movimientoId
- nombre
- numero
- numeroFactura
- numeroSecuencial
- observaciones
- operation
- origen
- pesoTotal
- pesoUnitario
- pesoVariable
- pinHash
- precioVenta
- procesadaPor
- produccionId
- productoBaseId
- productoFinalId
- productoId
- proveedor
- recetaId
- referencia
- registradoPor
- requiereFotoPeso
- requisicionId
- retries
- rif
- sincronizado
- status
- stockActual
- stockMinimo
- targetTable
- tasaCambio
- telefono
- tipo
- tipoComponente
- tipoDocumento
- tipoPago
- totalBruto
- totalImpuestos
- totalNeto
- unidad
- unidadMedida
- updatedAt
- usuario
- validadaPor
- value
- ventaId
- ventaSyncUuid
- verificado
- visibleEnPos
- Producto
- String?

## God Nodes (most connected - your core abstractions)
1. `LocalReplica` - 212 edges
2. `get_local_conn()` - 179 edges
3. `c()` - 108 edges
4. `a()` - 82 edges
5. `show_error()` - 73 edges
6. `j()` - 70 edges
7. `k()` - 69 edges
8. `get_db_adaptive()` - 69 edges
9. `show_success()` - 69 edges
10. `i()` - 68 edges

## Surprising Connections (you probably didn't know these)
- `_show_snackbar()` --references--> `icons`  [EXTRACTED]
  usr/notifications.py → flutter_app/web/manifest.json
- `main()` --calls--> `get_settings()`  [EXTRACTED]
  usr/app_launcher.py → config/config.py
- `_get_remote_engine()` --calls--> `get_settings()`  [EXTRACTED]
  usr/database/archive.py → config/config.py
- `ajustar_existencia()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py
- `registrar_movimiento()` --calls--> `get_settings()`  [EXTRACTED]
  usr/views/inventario/movements.py → config/config.py

## Import Cycles
- None detected.

## Communities (228 total, 117 thin omitted)

### Community 0 - "requisiciones_view.py"
Cohesion: 0.14
Nodes (21): build_detalle_row(), build_producto_busqueda_item(), get_almacenes(), get_detalles(), get_productos_activos(), build_agregar_producto_dialog(), build_agregar_producto_req_dialog(), build_buscador_productos() (+13 more)

### Community 1 - "show_error_with_copy"
Cohesion: 0.06
Nodes (15): Exception, Mostrar mensaje de error con botón para copiar detalles al clipboard., show_error_with_copy(), check_proveedor_exists(), extract_from_image(), _extract_from_image_ocrspace(), _get_easyocr_reader(), parse_factura_text() (+7 more)

### Community 2 - "ConfigPOSView"
Cohesion: 0.07
Nodes (10): Obtiene categorías POS independientes., Obtiene categorías de platos., ConfigPOSView, Construye el contenido de la pestaña de impresora., Guarda la configuracion del membrete., Establece el correlativo inicial., Carga la lista de impresoras disponibles., Selecciona o deselecciona una impresora. (+2 more)

### Community 3 - "get_db_adaptive"
Cohesion: 0.11
Nodes (28): get_db_adaptive(), Generator que proporciona una sesión SQLite local., Existencia, Base, Producto, Base, get_productos_activos(), Obtiene todos los productos activos del inventario. (+20 more)

### Community 4 - "ProduccionesView"
Cohesion: 0.12
Nodes (4): build_historial_tab(), Construye el contenido del tab Historial., ProduccionesView, Tras descargar/cancelar, refrescar pendientes y recetas (dropdown).

### Community 6 - "producciones/data.py"
Cohesion: 0.12
Nodes (24): almacen_produccion_default(), cancelar_produccion(), ejecutar_descargo(), eliminar_receta(), load_componentes(), load_detalle(), load_pendientes(), load_pendientes_de_receta() (+16 more)

### Community 7 - "._load_categorias"
Cohesion: 0.14
Nodes (5): Obtiene contornos activos para POS., Obtiene productos del POS: activos y marcados para la venta., Categorias de platos (sin padre) excluyendo las de contornos., Reemplaza la grilla y dispara la animacion de entrada escalonada., Muestra las sub-categorias de una categoria padre junto a sus productos…

### Community 8 - "stock_view.py"
Cohesion: 0.12
Nodes (16): build_product_card(), build_stat_card(), filter_products_db(), get_existencias_map(), get_existencias_producto(), get_producto_historial(), get_stock_stats(), load_categories() (+8 more)

### Community 9 - "schedule_load"
Cohesion: 0.11
Nodes (11): clear_all_callbacks(), notify_sync_complete(), Manejo de callbacks de sincronización entre vistas., Ejecuta `handler` en el event loop de la página solo si la sesión web ya está…, Agenda una corrutina de carga de vista en el event loop ACTIVO y retorna una…, Registra un callback que se ejecuta después de cada sync., Notifica a todos los callbacks registrados., Limpia todos los callbacks registrados. (+3 more)

### Community 10 - "._ensure_tables"
Cohesion: 0.12
Nodes (8): Obtiene operaciones pendientes Y fallidas con reintentos disponibles., Marca operación como completada., Marca operación como fallida., Obtiene estado de la cola., Obtiene timestamp del último sync., Asegura que las tablas de la cola existan (defensa ante arranques donde…, Agrega una operación a la cola de sync., Estado de conexión y sincronización.

### Community 11 - "Historial de Cambios"
Cohesion: 0.04
Nodes (45): 1. El código actualizado no se refleja en el App, 1. Smart Launcher & Dynamic Updates, 1. Variables `snack` sin definir, 2. Código de depuración en producción, 2. Fallo en Notificaciones tras Actualización, 2. Motor de Sincronización (Offline-First), 3. Bases de Datos Duplicadas, 3. Flujo de Requisiciones (Audit Workflow) (+37 more)

### Community 12 - "inventario_view.py"
Cohesion: 0.05
Nodes (40): Guarda un movimiento en la BD local., Exception, Sistema global de manejo y notificación de errores. Este módulo mantiene…, Muestra el error en consola Y en pantalla como SnackBar rojo., Banner persistente para errores de sincronización., show_error(), show_sync_error(), clear_notifications() (+32 more)

### Community 13 - "get_colors"
Cohesion: 0.07
Nodes (13): Elimina un callback registrado., unregister_sync_callback(), Vista de login del POS. Muestra: - Lista de cajeros registrados - Botón para…, get_colors(), Constantes de colores para el tema de la aplicación, Helper para obtener colores según el tema de la página, build_producto_item_row(), build_requisicion_card() (+5 more)

### Community 14 - "whatsapp_notifier.py"
Cohesion: 0.11
Nodes (21): Control, Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI, BandejaWhatsAppView, _notify_error(), Container, count_pending(), delete_from_queue(), format_validation_message() (+13 more)

### Community 15 - "drift_worker.js"
Cohesion: 0.01
Nodes (72): cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), e4(), eR(), eS() (+64 more)

### Community 16 - "comprobar_y_aplicar_actualizaciones"
Cohesion: 0.24
Nodes (11): Text, comprobar_y_aplicar_actualizaciones(), _download_file(), _fetch_url(), Page, Bloqueante — corre en executor., Comprueba, descarga e instala actualizaciones de código de forma dinámica., Lee UPDATE_URL. Prioridad: 1. Variable ya cargada en os.environ (config.config… (+3 more)

### Community 17 - "models/__init__.py"
Cohesion: 0.07
Nodes (20): Elimina y recrea todas las tablas de la base de datos., reset_database(), Categoria, Base, CompraListaItem, Base, FacturaPago, Base (+12 more)

### Community 18 - "._download_all_from_server"
Cohesion: 0.05
Nodes (16): Limpia todos los movimientos., Guarda múltiples movimientos (para sync desde servidor) con deduplicación., Guarda facturas en la base de datos local., Guarda pagos de facturas en la base de datos local., Guarda los detalles de las requisiciones (upsert). Incluye verificado para…, Recalcula las existencias basándose en todos los movimientos. Si hay…, Elimina registros locales que no están en la lista de IDs remotos y no están…, Restaura movimientos.venta_id desde venta_sync_uuid tras una descarga. (+8 more)

### Community 19 - "POSSyncManager"
Cohesion: 0.08
Nodes (12): Aplica comandas descargadas de Supabase (upsert por sync_uuid). Retorna cuantas…, Aplica ventas descargadas de Supabase (upsert por sync_uuid). Resuelve…, Bulk upsert pos_categorias para sync (categorias POS independientes)., Bulk upsert platos_categorias para sync., Bulk upsert platos para sync., Bulk upsert plato_ingredientes para sync., Bulk upsert plato_contornos para sync., Bulk upsert pos_mesas para sync. (+4 more)

### Community 20 - "_abrir_url"
Cohesion: 0.33
Nodes (6): _abrir_url(), _obtener_tasa_fallback(), _obtener_tasa_sitio_oficial(), Respaldo: consulta la tasa USD en la API de bcv.today., Descarga una URL con User-Agent real y reintento sin verificar SSL., Scrapea la tasa USD del sitio oficial del BCV (www.bcv.org.ve). El valor…

### Community 21 - "ControlEntradasSalidasApp"
Cohesion: 0.10
Nodes (9): ControlEntradasSalidasApp, Page, Imprime en el log (solo si TRACE_SWITCH=1) un marcador con delta de tiempo para…, Reenvía el estado autoritativo de visibilidad del Stack y fuerza el repintado…, Coloca las acciones de la vista donde corresponde según el layout. Las acciones…, Muestra u oculta la barra de acciones bajo el encabezado (móvil). En móvil los…, Recibe mensajes de progreso del SyncManager. Puede ejecutarse en un hilo nativo…, Registra el callback de progreso en el SyncManager. (+1 more)

### Community 22 - "base.py"
Cohesion: 0.06
Nodes (50): get_settings(), Valores de BD empaquetados para builds compilados (Windows exe / Android APK).…, DateTime?, Script único para migrar datos POS existentes a Supabase. Agrega todos los…, check_connection(), check_connection_async(), get_base(), get_connection_status() (+42 more)

### Community 23 - "HistorialFacturasView"
Cohesion: 0.14
Nodes (4): _c(), _colors(), HistorialFacturasView, Mapea colores de ft.Colors a tema dinámico

### Community 24 - "show_error"
Cohesion: 0.04
Nodes (81): Obtiene un setting de POS (ej: printer_device)., Tasa de cambio guardada (Bs por USD). None si no hay ninguna., Guarda un setting de POS. Si sync=True, lo encola para subir a Supabase., Mostrar mensaje de éxito (verde)., Mostrar mensaje de error (rojo)., Mostrar mensaje de advertencia (naranja)., Mostrar mensaje informativo (azul)., Función interna para mostrar SnackBar. Args: action_text: Texto para botón de… (+73 more)

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
Cohesion: 0.06
Nodes (20): Obtiene movimientos que no han sido sincronizados., Marca un movimiento como sincronizado., Obtiene facturas de la BD local., Tras subir una requisición local, actualiza su id local al id remoto para que…, Guarda timestamp del último sync., Verifica la conexión real con Supabase (no la BD local ni Internet). Crea un…, Realiza una sincronización completa: sube pendientes y descarga del servidor., Fuerza una sincronización inmediata. (+12 more)

### Community 29 - "producciones/dialogs.py"
Cohesion: 0.15
Nodes (19): cancelar_produccion_dialog(), delete_receta_dialog(), descargo_dialog(), Diálogos del módulo Producciones: confirmar eliminar receta, descargo y…, Confirma cancelación + revierte el stock del producto final., Diálogo para registrar el descargo de ingredientes de una producción pendiente., colors(), fmt_fecha() (+11 more)

### Community 30 - "LoadingSplash"
Cohesion: 0.09
Nodes (12): _find_background_image(), LoadingSplash, Container, Page, Pantalla de carga (splash) animada que se muestra durante la sincronización.…, Splash a pantalla completa con fondo (imagen estática) y UI animada. No hereda…, Devuelve el Container raíz para añadir a la página: page.add(splash.control), Actualiza anillo, % y etiqueta en función del mensaje del sync. (+4 more)

### Community 31 - "._confirmar_anulacion"
Cohesion: 0.09
Nodes (9): Guarda la comanda abierta de la mesa/habitacion (upsert). Si ya existe una…, Encola una comanda para subirla a Supabase (sync POS)., Reabre una comanda cerrada (para correccion/venta devuelta)., Registra una venta cobrada. Retorna el id de la venta., Encola una venta para subirla a Supabase (sync POS)., Marca una venta como anulada (devuelta)., Sync_uuid de una venta (para el vinculo estable venta<->movimientos)., Registra movimientos tipo 'venta' (salida de mercancia) y descuenta existencias. (+1 more)

### Community 32 - "AuditView"
Cohesion: 0.18
Nodes (3): AuditView, _forzar_sync(), Ejecuta sync sincrónico (bloqueante). Retorna True si OK, False si falló.

### Community 33 - "periodos.py"
Cohesion: 0.18
Nodes (22): archivar_en_supabase(), archivar_movimientos(), archivar_movimientos_local(), _get_remote_engine(), guardar_periodo_en_supabase(), Archiva en Supabase (si se puede) y siempre en local., Archiva en Supabase: guarda checkpoint, mueve movimientos viejos a archivo.…, Guarda el periodo aperturado en Supabase para que los demas dispositivos lo… (+14 more)

### Community 34 - "launcher.py"
Cohesion: 0.12
Nodes (24): Logger, get_engine(), Alias de get_local_engine() para compatibilidad., Llamar desde main() antes de cualquier import de BD., set_db_path(), ensure_local_db(), Asegura que la BD local existe. Llamar después de set_db_path()., init_pos_sync_manager() (+16 more)

### Community 35 - "RequisicionesView"
Cohesion: 0.09
Nodes (4): Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos., Indicador de estado de la cola de sync (pendientes/fallidos/ok)., Al pulsar: refresca el estado y muestra los errores si hay fallidos., RequisicionesView

### Community 36 - "conn.py"
Cohesion: 0.10
Nodes (22): BaseSettings, _candidate_env_paths(), Config, Construye la URL de conexión a la base de datos de forma segura., Identificador único del dispositivo., Rutas candidatas para buscar .env en orden de prioridad., Settings, Connection (+14 more)

### Community 37 - "app_database.dart"
Cohesion: 0.01
Nodes (231): class, class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends, class StockCheckpointData extends (+223 more)

### Community 38 - "LocalReplica"
Cohesion: 0.02
Nodes (52): get_local_conn(), LocalReplica, Devuelve la lista de almacenes existentes (valores únicos)., Obtiene todas las existencias de un producto (sumadas por almacén)., Actualiza la existencia existente o la crea si no existe (sin duplicar)., Obtiene movimientos de la BD local (con numero de documento de la factura si…, Obtiene requisiciones de la BD local., Verifica el PIN del usuario. (+44 more)

### Community 39 - "a"
Cohesion: 0.05
Nodes (107): $1(), a(), a1(), a4(), aa(), aH(), aR(), aw() (+99 more)

### Community 40 - "ComandasView"
Cohesion: 0.16
Nodes (5): ComandasView, Vista de Comandas del POS. Muestra dos puntos de entrada para comandas: - Mesas…, POSHomeView, Vista post-login del POS. Redirige al usuario a la pantalla de Comandas (mesas…, PosView

### Community 41 - "Requisicion"
Cohesion: 0.10
Nodes (10): Base, Requisicion, RequisicionDetalle, build_empty_state(), build_requisicion_card(), _parse_dt(), Tarjeta de una requisición en la lista., Convierte fecha (datetime o string ISO) a datetime de forma segura. (+2 more)

### Community 42 - "r"
Cohesion: 0.04
Nodes (75): $0(), $2(), $3(), $5(), a8(), a9(), ac(), aL() (+67 more)

### Community 43 - "POSSyncIndicator"
Cohesion: 0.21
Nodes (5): get_pos_sync_indicator(), POSSyncIndicator, Page, Barra de progreso global del POS. Aparece en la parte superior de todas las…, Activa/desactiva la barra. Solo se muestra durante un sync manual.

### Community 44 - "c"
Cohesion: 0.04
Nodes (69): aD(), aE(), aj(), at(), ba(), bt(), bV(), bw() (+61 more)

### Community 45 - "N"
Cohesion: 0.05
Nodes (61): aM(), aV(), b6(), bf(), ce(), cU(), D(), d3() (+53 more)

### Community 46 - "main_pos.py"
Cohesion: 0.12
Nodes (11): assets_dir_path(), _get_app_dir(), main(), _NullStream, Page, Entry point alternativo para el modulo POS (Point of Sale). Este main abre SOLO…, Sustituto de std out/err cuando el .exe compilado se ejecuta en modo --windowed…, Resuelve la ruta de recursos tanto para ejecucion directa como PyInstaller. (+3 more)

### Community 47 - "aQ"
Cohesion: 0.05
Nodes (58): a3(), aF(), ak(), an(), aP(), aQ(), b2(), b3() (+50 more)

### Community 48 - "i"
Cohesion: 0.05
Nodes (55): a0(), aB(), ai(), aO(), b0(), b8(), bC(), bI() (+47 more)

### Community 49 - "_colors"
Cohesion: 0.12
Nodes (24): _create_categoria_card(), create_categoria_grid(), create_categoria_item_mobile(), save_categoria(), show_categoria_dialog(), _update_color_preview(), add_to_overlay(), close_dialog() (+16 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "DataClass"
Cohesion: 0.06
Nodes (50): Categoria, Existencia, Factura, FacturaPago, Periodo, Insertable, Movimiento, Receta (+42 more)

### Community 52 - "4. Módulos feature por feature"
Cohesion: 0.06
Nodes (31): 0. Inventario de lo que existe hoy (auditoría), 1. Arquitectura objetivo (Flutter), 2.1 Esquema, 2.2 Cliente Supabase, 2.3 Repositorios, 2. Capa de datos, 3. Motor de sincronización, 4.10 Updater (`updater.py`) (+23 more)

### Community 53 - ".get_producto_by_id"
Cohesion: 0.16
Nodes (6): Ingredientes de un plato/contorno., Resuelve cada item de la comanda a los productos de inventario a descontar. -…, Obtiene una categoría por ID., Obtiene un producto por ID., Obtiene existencias de la BD local., Lee datos de la BD local y retorna (items, colors).

### Community 54 - "sync_engine.dart"
Cohesion: 0.07
Nodes (29): ../config/app_config.dart, dart:async, initialize, initializeSupabase, supabaseProvider, client, _db, def (+21 more)

### Community 55 - "._ver_detalle"
Cohesion: 0.15
Nodes (3): Historial de ventas (mas recientes primero). Paginable por before_id., Ultima venta cobrada que sigue vigente (no anulada)., Ultima venta anulada de una comanda (para saber si el proximo cobro es una…

### Community 57 - "a5"
Cohesion: 0.09
Nodes (31): a5(), a6(), a7(), c1(), cV(), d7(), dB(), dc() (+23 more)

### Community 58 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, fl_register_plugins(), main(), first_frame_cb(), my_application_activate(), my_application_class_init(), my_application_dispose(), my_application_init() (+14 more)

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - ".save_componentes"
Cohesion: 0.33
Nodes (4): Guarda una receta y retorna su ID., Reemplaza todos los componentes de una receta., guardar_receta(), Guarda receta + componentes. receta_data incluye id si es edición.

### Community 62 - "app_launcher.py"
Cohesion: 0.16
Nodes (15): _get_app_dir(), main(), Page, Ruta a recursos empaquetados (assets, .env, etc.). - PyInstaller (Windows):…, Directorio base de la app (escribible para BD, logs, app_updates). Prioridad:…, resource_path(), main(), mostrar_error_critico() (+7 more)

### Community 63 - "app_shell.dart"
Cohesion: 0.09
Nodes (23): ../auth/session_controller.dart, ConsumerWidget, ../../features/auth/presentation/login_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, AppShell, build, createState, destino (+15 more)

### Community 64 - "sync_service.dart"
Cohesion: 0.09
Nodes (20): dart:convert, ../db/database_provider.dart, ../db/schema/app_database.dart, addPending, client, db, into, syncEngineProvider (+12 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 69 - ".get_existencias_by_producto_almacen"
Cohesion: 0.50
Nodes (3): Obtiene existencia por producto y almacén., get_existencia_producto(), Obtiene la existencia actual de un producto en un almacén.

### Community 70 - ".save_categorias"
Cohesion: 0.29
Nodes (3): Guarda categorías en la base de datos local (upsert, no borra)., Obtiene todas las categorías de la BD local., Lee caché local y (si hay conexión) consulta el servidor. Corre en hilo aparte…

### Community 75 - "bg"
Cohesion: 0.11
Nodes (23): a2(), aX(), aY(), bg(), bY(), cl(), cM(), cO() (+15 more)

### Community 76 - "ka"
Cohesion: 0.12
Nodes (22): c2(), cw(), d1(), d2(), dr(), ds(), dY(), eX() (+14 more)

### Community 77 - "Table"
Cohesion: 0.10
Nodes (21): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+13 more)

### Community 83 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, AppDelegate, SceneDelegate, RunnerTests, FlutterAppDelegate, FlutterImplicitEngineBridge (+6 more)

### Community 87 - "login_screen.dart"
Cohesion: 0.13
Nodes (18): ConsumerState, ConsumerStatefulWidget, ../../../core/auth/session_controller.dart, ../../../core/db/database_provider.dart, appDatabaseProvider, build, _confirmCtrl, createState (+10 more)

### Community 89 - "inventario_screen.dart"
Cohesion: 0.14
Nodes (17): ../data/inventario_repository.dart, InventarioRepository, build, categoriaId, _categoriaSeleccionada, createState, inventarioRepoProvider, InventarioScreen (+9 more)

### Community 90 - "O"
Cohesion: 0.12
Nodes (18): $4(), au(), b1(), e0(), f2(), f3(), fg(), giI() (+10 more)

### Community 91 - "win32_window.cpp"
Cohesion: 0.17
Nodes (14): wchar_t, Scale(), Create, Destroy, SetQuitOnClose, Win32Window::Win32Window(), WindowClassRegistrar, class_registered_ (+6 more)

### Community 92 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM, FlutterWindow, flutter_controller_ (+6 more)

### Community 93 - "inventario_repository.dart"
Cohesion: 0.12
Nodes (15): ../../../core/sync/sync_service.dart, _db, deleteComprasLista, getAllCategorias, getAllProductos, getComprasLista, getExistenciasByProducto, getProductosByCategoria (+7 more)

### Community 94 - "app_theme.dart"
Cohesion: 0.14
Nodes (13): app_colors.dart, AppThemeData, buildAppTheme, c, color, colors, dark, inputDecoration (+5 more)

### Community 95 - "session_controller.dart"
Cohesion: 0.18
Nodes (13): ../../../core/db/schema/app_database.dart, Authenticated, _cargar, cerrarSesion, _db, nombre, pinHash, registrarOperador (+5 more)

### Community 96 - "ei"
Cohesion: 0.18
Nodes (14): aG(), c8(), cD(), d9(), ed(), ei(), eu(), f8() (+6 more)

### Community 97 - "Win32Window"
Cohesion: 0.20
Nodes (14): OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, GetHandle, OnCreate (+6 more)

### Community 98 - "wWinMain"
Cohesion: 0.24
Nodes (9): wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16(), _In_, _In_opt_ (+1 more)

### Community 99 - "movimientos.py"
Cohesion: 0.29
Nodes (10): _build_almacen_option(), build_historial_dialog(), build_movimiento_card(), _copiar_documento(), _es_movil(), _fmt_cantidad(), preguntar_almacen(), Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,… (+2 more)

### Community 100 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.20
Nodes (9): core/network/supabase_client.dart, core/router/app_shell.dart, ThemeController, toggle, initializeSupabase, main, package:flutter/material.dart, package:flutter_riverpod/flutter_riverpod.dart (+1 more)

### Community 109 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 110 - "get_theme"
Cohesion: 0.18
Nodes (9): apply_theme_to_button(), apply_theme_to_container(), apply_theme_to_textfield(), get_theme(), Aplica el tema a un Container, Aplica el tema a un TextField, Aplica el tema a un ElevatedButton, Retorna diccionario de colores según el tema. Tema basado en: primario = negro,… (+1 more)

### Community 113 - "MessageHandler"
Cohesion: 0.38
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetThisFromHandle, MessageHandler (+2 more)

### Community 114 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 115 - "AppDatabase"
Cohesion: 0.29
Nodes (6): _, @DriftDatabase, db, AppDatabase, return, schema/app_database.dart

### Community 116 - "sync_tables.dart"
Cohesion: 0.29
Nodes (6): dedupeKey, localTable, serverTable, syncedTables, SyncTableDescriptor, List

### Community 117 - "app_colors.dart"
Cohesion: 0.33
Nodes (5): AppColors, dark, light, of, static const

### Community 118 - ".get_usuario_dispositivo"
Cohesion: 0.33
Nodes (4): init_local_db(), Inicializa la base de datos local con todas las tablas. Usa los mismos nombres…, Devuelve el usuario registrado en este dispositivo, o None., Crea todas las tablas locales.

### Community 119 - "Control de Entradas y Salidas — App Flutter"
Cohesion: 0.40
Nodes (4): Control de Entradas y Salidas — App Flutter, Estado actual del esqueleto (Fase 0), Instrucciones, Pendientes (Fase 1 y siguientes)

## Knowledge Gaps
- **553 isolated node(s):** `Config`, `XCTest`, `_db`, `nombre`, `pinHash` (+548 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **117 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LocalReplica` connect `LocalReplica` to `show_error_with_copy`, `ConfigPOSView`, `get_db_adaptive`, `._go_to_main`, `producciones/data.py`, `._load_categorias`, `stock_view.py`, `._ensure_tables`, `inventario_view.py`, `get_colors`, `whatsapp_notifier.py`, `._download_all_from_server`, `POSSyncManager`, `base.py`, `show_error`, `RecetaEditor`, `SyncManager`, `producciones/dialogs.py`, `._confirmar_anulacion`, `AuditView`, `periodos.py`, `launcher.py`, `ComandasView`, `_colors`, `.get_producto_by_id`, `._ver_detalle`, `ComandaPedidoView`, `.save_componentes`, `app_launcher.py`, `.get_existencias_by_producto_almacen`, `.save_categorias`, `.get_recetas`, `.get_productos`, `POSLoginView`, `VentasView`, `HabitacionesView`, `MesasView`, `.get_usuario_dispositivo`?**
  _High betweenness centrality (0.131) - this node is a cross-community bridge._
- **Why does `get_local_conn()` connect `LocalReplica` to `requisiciones_view.py`, `ConfigPOSView`, `._go_to_main`, `._load_categorias`, `._ensure_tables`, `inventario_view.py`, `whatsapp_notifier.py`, `._download_all_from_server`, `POSSyncManager`, `base.py`, `show_error`, `SyncManager`, `._confirmar_anulacion`, `periodos.py`, `RequisicionesView`, `conn.py`, `.get_producto_by_id`, `._ver_detalle`, `.save_componentes`, `.get_existencias_by_producto_almacen`, `.save_categorias`, `.get_recetas`, `.get_productos`, `POSLoginView`, `.get_usuario_dispositivo`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **Why does `AppDatabase` connect `AppDatabase` to `sync_service.dart`, `app_database.dart`, `sync_engine.dart`, `inventario_repository.dart`, `session_controller.dart`?**
  _High betweenness centrality (0.018) - this node is a cross-community bridge._
- **Are the 18 inferred relationships involving `LocalReplica` (e.g. with `SyncQueue` and `POSSyncManager`) actually correct?**
  _`LocalReplica` has 18 INFERRED edges - model-reasoned connections that need verification._
- **Are the 2 inferred relationships involving `get_local_conn()` (e.g. with `.procesar()` and `_get_queue_conn()`) actually correct?**
  _`get_local_conn()` has 2 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._