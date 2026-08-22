# Graph Report - control-entradas-salidas  (2026-08-21)

## Corpus Check
- 234 files · ~207,092 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 4967 nodes · 9307 edges · 205 communities (193 shown, 12 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 654 edges (avg confidence: 0.51)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e1431a44`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- web_pos/drift_worker.js
- package:flutter_riverpod/flutter_riverpod.dart
- ventas_screen.dart
- validacion_screen.dart
- web/drift_worker.js
- a
- a
- config_categorias_tab.dart
- pos_repository.dart
- $0
- precargar_imagen_dialog.dart
- Control de Entradas y Salidas
- bR
- realtime_providers.dart
- r
- producciones_repository.dart
- c
- r
- pos_ventas_repository.dart
- app_shell.dart
- i
- pos_models.dart
- movimiento_dialog.dart
- package:flutter/material.dart
- inventario_screen.dart
- c
- What You Must Do When Invoked
- What You Must Do When Invoked
- realtime_service.dart
- receta_editor_screen.dart
- ConsumerState
- bool get
- form_view.dart
- aQ
- comanda_screen.dart
- ../../../../core/models/pos_models.dart
- a5
- producciones_screen.dart
- b4
- bR
- descargo_dialog.dart
- validacion_dialog.dart
- requisiciones_repository.dart
- productos_panel.dart
- ticket_escpos.dart
- configuracion_repository.dart
- habitacion_config_dialog.dart
- validacion_repository.dart
- b8
- config_usuarios_tab.dart
- graphify reference: extra exports and benchmark
- factura_detalle_dialog.dart
- Plan de Migración: Flet (Python) → Flutter (Dart)
- temporales_repository.dart
- config_habitaciones_tab.dart
- stock_screen.dart
- requisiciones/presentation/dialogs/historial_dialog.dart
- ajuste_auditoria_dialog.dart
- my_application.cc
- existencias_dialog.dart
- graphify reference: query, path, explain
- package:flutter_test/flutter_test.dart
- fN
- a5
- aM
- graphify reference: add a URL and watch a folder
- graphify reference: commit hook and native CLAUDE.md integration
- graphify reference: incremental update and cluster-only
- mensaje_whatsapp.dart
- configuracion_providers.dart
- aM
- graphify reference: GitHub clone and cross-repo merge
- graphify reference: transcribe video and audio
- cantidad_dialog.dart
- factura.dart
- producto_dialog.dart
- plato_config_dialog.dart
- github_releases_source.dart
- requisicion.dart
- producto.dart
- CLAUDE.md
- .claude/CLAUDE.md
- extraction-spec.md
- AppDelegate
- graphify.js
- historial_repository.dart
- AGENTS.md
- inventario_repository.dart
- subcategoria_dialog.dart
- exportar_dialog.dart
- movimiento.dart
- win32_window.cpp
- FlutterWindow
- receta.dart
- pos_comanda_models.dart
- session_controller.dart
- pos_home_header.dart
- Win32Window
- wWinMain
- bandeja_screen.dart
- pagos_panel.dart
- b8
- dF
- ei
- ka
- categoria_dialog.dart
- supabase_service.dart
- produccion.dart
- pos_categoria_dialog.dart
- nuevo_cajero_dialog.dart
- ka
- periodos_tab.dart
- proveedor_dialog.dart
- visualizar_view.dart
- file_logger.dart
- proveedor.dart
- produccionesRepoProvider
- whatsapp_repository.dart
- stock_repository.dart
- pin_dialog.dart
- RegisterPlugins
- MainActivity
- categoria.dart
- static const
- proveedores_tab.dart
- ConsumerWidget
- pos_providers.dart
- O
- sistema_tab.dart
- O
- models/models.dart
- update_models.dart
- ../../../core/data/supabase_providers.dart
- ticket_settings.dart
- categoria_card.dart
- ticket_preview_dialog.dart
- stock_whatsapp_models_test.dart
- updater_platform_io.dart
- catalogo_card.dart
- app_theme.dart
- requisicion_card.dart
- int?
- DateTime
- existencia.dart
- web_utils_web.dart
- por_fecha_tab.dart
- pos_screen.dart
- package:http/http.dart
- periodo.dart
- historial_providers.dart
- ../../data/pos_providers.dart
- ../../../core/models/categoria.dart
- pop_in.dart
- login_screen.dart
- facturas_tab.dart
- dart:async
- tasa_bcv_service.dart
- app_updater.dart
- config_platos_tab.dart
- categorias_tab.dart
- web/manifest.json
- web_pos/manifest.json
- mesa_config_dialog.dart
- productos_tab.dart
- producciones_providers.dart
- MessageHandler
- producto_stock_card.dart
- printer_service_native.dart
- entrada_card.dart
- State
- LaunchImage.imageset/README.md
- web_utils.dart
- log_bridge.dart
- printer_service.dart
- requisiciones_screen.dart
- update_dialog.dart
- audit_view.dart
- update_settings_card.dart
- List
- buscador_productos_dialog.dart
- config_tasa_tab.dart
- stock/presentation/dialogs/historial_dialog.dart
- app_config.dart
- entrada_pendiente_card.dart
- String?

## God Nodes (most connected - your core abstractions)
1. `c()` - 108 edges
2. `c()` - 108 edges
3. `a()` - 82 edges
4. `a()` - 82 edges
5. `j()` - 70 edges
6. `j()` - 70 edges
7. `k()` - 69 edges
8. `k()` - 69 edges
9. `i()` - 68 edges
10. `i()` - 68 edges

## Surprising Connections (you probably didn't know these)
- `_abrirDialogo` --references--> `configuracionRepoProvider`  [EXTRACTED]
  lib/features/configuracion/presentation/widgets/categorias_tab.dart → lib/features/configuracion/data/configuracion_providers.dart
- `_eliminar` --references--> `configuracionRepoProvider`  [EXTRACTED]
  lib/features/configuracion/presentation/widgets/categorias_tab.dart → lib/features/configuracion/data/configuracion_providers.dart
- `_aperturarPeriodo` --references--> `configuracionRepoProvider`  [EXTRACTED]
  lib/features/configuracion/presentation/widgets/periodos_tab.dart → lib/features/configuracion/data/configuracion_providers.dart
- `_forzarArchivo` --references--> `configuracionRepoProvider`  [EXTRACTED]
  lib/features/configuracion/presentation/widgets/periodos_tab.dart → lib/features/configuracion/data/configuracion_providers.dart
- `_recalcularDesdeCero` --references--> `configuracionRepoProvider`  [EXTRACTED]
  lib/features/configuracion/presentation/widgets/periodos_tab.dart → lib/features/configuracion/data/configuracion_providers.dart

## Import Cycles
- None detected.

## Communities (205 total, 12 thin omitted)

### Community 0 - "web_pos/drift_worker.js"
Cohesion: 0.01
Nodes (74): a0(), cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), dl(), e4() (+66 more)

### Community 1 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.05
Nodes (46): app_updater.dart, ../../../../core/models/receta.dart, ../data/producciones_providers.dart, ../../data/producciones_repository.dart, dialogs/cancelar_produccion_dialog.dart, dialogs/delete_receta_dialog.dart, dialogs/descargo_dialog.dart, confirmado (+38 more)

### Community 2 - "ventas_screen.dart"
Cohesion: 0.03
Nodes (61): calculadora_button.dart, calculadora_dialog.dart, PosVenta, _AppDrawer, _AppHeader, _DestinoPage, _NavBarMobile, build (+53 more)

### Community 3 - "validacion_screen.dart"
Cohesion: 0.12
Nodes (17): dialogs/precargar_imagen_dialog.dart, dialogs/temporales_dialog.dart, dialogs/validacion_dialog.dart, temporalesProvider, _seccionTemporalesGuardados, _buildHeader, createState, dispose (+9 more)

### Community 4 - "web/drift_worker.js"
Cohesion: 0.01
Nodes (68): bs(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), e4(), ef(), gaJ() (+60 more)

### Community 5 - "a"
Cohesion: 0.05
Nodes (112): $1(), $2(), a(), a9(), aa(), aH(), aR(), aw() (+104 more)

### Community 6 - "a"
Cohesion: 0.05
Nodes (112): $1(), $2(), a(), a9(), aa(), aH(), aR(), aw() (+104 more)

### Community 7 - "config_categorias_tab.dart"
Cohesion: 0.07
Nodes (27): ../dialogs/pos_categoria_dialog.dart, ../dialogs/subcategoria_dialog.dart, activo, build, _cargando, color, ConfigCategoriasTab, _ConfigCategoriasTabState (+19 more)

### Community 8 - "pos_repository.dart"
Cohesion: 0.04
Nodes (50): abrirSesion, actualizarHabitacion, actualizarMesa, actualizarPlato, actualizarPosCategoria, actualizarUsuario, cerrarSesion, cerrarSesionesStale (+42 more)

### Community 9 - "$0"
Cohesion: 0.07
Nodes (47): $0(), a8(), ai(), aO(), bh(), bx(), c6(), ce() (+39 more)

### Community 10 - "precargar_imagen_dialog.dart"
Cohesion: 0.06
Nodes (39): ../../data/ocr_service.dart, ../data/temporales_repository.dart, ../data/validacion_providers.dart, TemporalData, temporalesRepoProvider, build, _conPrefijo, createState (+31 more)

### Community 11 - "Control de Entradas y Salidas"
Cohesion: 0.14
Nodes (13): Aplicaciones, Arquitectura, Compilación y despliegue, Configuración (dart-define), Control de Entradas y Salidas, Documentación, Funcionalidades, Inventario (`lib/features/`) (+5 more)

### Community 12 - "bR"
Cohesion: 0.07
Nodes (39): a1(), a2(), a3(), a4(), aX(), aY(), bg(), bN() (+31 more)

### Community 13 - "realtime_providers.dart"
Cohesion: 0.09
Nodes (20): ../config/app_config.dart, ../../features/pos/data/pos_providers.dart, bindings, events, initRealtimeSubscriptions, invalidate, _RealtimeBindings, subs (+12 more)

### Community 14 - "r"
Cohesion: 0.05
Nodes (62): $3(), $5(), aP(), az(), bB(), bd(), be(), bP() (+54 more)

### Community 15 - "producciones_repository.dart"
Cohesion: 0.03
Nodes (64): almacen, almacenProduccionDefault, cancelarProduccion, cantidad, cantidadSugerida, cocineros, ComponenteInfo, contarComponentes (+56 more)

### Community 16 - "c"
Cohesion: 0.04
Nodes (62): aD(), aE(), at(), ba(), bt(), bV(), bZ(), c() (+54 more)

### Community 17 - "r"
Cohesion: 0.05
Nodes (62): $3(), $5(), aP(), az(), bB(), bd(), be(), bP() (+54 more)

### Community 18 - "pos_ventas_repository.dart"
Cohesion: 0.06
Nodes (31): anularVenta, aplicarMovimientosVenta, cambiarEstadoComanda, cerrarComanda, _db, eliminarComanda, eliminarVentaYMovimientos, getComanda (+23 more)

### Community 19 - "app_shell.dart"
Cohesion: 0.05
Nodes (37): ../auth/session_controller.dart, ../data/realtime_providers.dart, ../data/realtime_service.dart, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/producciones/presentation/producciones_screen.dart (+29 more)

### Community 20 - "i"
Cohesion: 0.05
Nodes (64): $0(), a8(), ac(), ai(), aL(), aO(), bh(), bx() (+56 more)

### Community 21 - "pos_models.dart"
Cohesion: 0.04
Nodes (55): abiertaEn, activo, anuladaEn, anuladaPor, cajaFinal, cajaInicial, cantidad, categoriaId (+47 more)

### Community 22 - "movimiento_dialog.dart"
Cohesion: 0.05
Nodes (40): _abrirCalculadora, _almacen, _almacenes, _campoPrincipal, _cantCtrl, _cantFocus, capitalize, _cargar (+32 more)

### Community 23 - "package:flutter/material.dart"
Cohesion: 0.03
Nodes (71): Color, ../../data/pos_comanda_models.dart, IconData, showSupabaseNotConfigured, supabaseReadyProvider, watch, MensajeWhatsapp, ThemeController (+63 more)

### Community 24 - "inventario_screen.dart"
Cohesion: 0.07
Nodes (30): ../../data/inventario_providers.dart, ../../data/inventario_repository.dart, inventarioRepoProvider, ComprasListaItem, showAgregarProductoDialog, _cargarExistencias, build, _buildHeader (+22 more)

### Community 25 - "c"
Cohesion: 0.03
Nodes (88): ac(), aD(), aE(), aj(), aL(), aQ(), at(), ba() (+80 more)

### Community 26 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 27 - "What You Must Do When Invoked"
Cohesion: 0.08
Nodes (24): For /graphify add and --watch, For /graphify query, For the commit hook and native CLAUDE.md integration, For --update and --cluster-only, /graphify, Honesty Rules, Interpreter guard for subcommands, Part A - Structural extraction for code files (+16 more)

### Community 28 - "realtime_service.dart"
Cohesion: 0.09
Nodes (22): cancel, _channel, _channelName, _client, _controller, dispose, newRecord, oldRecord (+14 more)

### Community 29 - "receta_editor_screen.dart"
Cohesion: 0.05
Nodes (37): _agregarFilaVacia, _agregarProducto, _baseProducto, _baseSearchCtrl, _buscar, _cancelar, cantidadCtrl, _componentes (+29 more)

### Community 30 - "ConsumerState"
Cohesion: 0.04
Nodes (63): ConsumerState, ConsumerStatefulWidget, dialogs/exportar_dialog.dart, facturas_tab.dart, _ShellAutenticado, _ShellAutenticadoState, build, _buildKeypad (+55 more)

### Community 31 - "bool get"
Cohesion: 0.11
Nodes (17): bool get, updaterCanRun, updaterDownloadDir, updaterDownloadFile, updaterInstall, updaterPlatformKey, updaterCanRun, updaterDownloadDir (+9 more)

### Community 32 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 33 - "aQ"
Cohesion: 0.07
Nodes (40): aF(), ak(), an(), aQ(), b3(), b4(), b5(), bL() (+32 more)

### Community 34 - "comanda_screen.dart"
Cohesion: 0.02
Nodes (98): AnimatedListState, ../../data/printer_service.dart, ../../data/ticket_escpos.dart, ../../data/ticket_settings.dart, dialogs/cobro_dialog.dart, dialogs/contornos_dialog.dart, ../dialogs/ticket_preview_dialog.dart, posRepoProvider (+90 more)

### Community 35 - "../../../../core/models/pos_models.dart"
Cohesion: 0.04
Nodes (53): ../../../../core/models/pos_models.dart, estado_card.dart, PosHabitacion, PosPlato, PosUsuario, build, cerrarSesion, forzarCerrarSesionAjena (+45 more)

### Community 36 - "a5"
Cohesion: 0.05
Nodes (50): a5(), a6(), a7(), aF(), aG(), bL(), bU(), c1() (+42 more)

### Community 37 - "producciones_screen.dart"
Cohesion: 0.06
Nodes (30): historial_tab.dart, Receta, _abrirEditor, build, _buildHeader, _cerrarEditor, createState, dispose (+22 more)

### Community 38 - "b4"
Cohesion: 0.11
Nodes (26): ak(), an(), b3(), b4(), b5(), bM(), bO(), cC() (+18 more)

### Community 39 - "bR"
Cohesion: 0.07
Nodes (39): a1(), a2(), a3(), a4(), aX(), aY(), bg(), bN() (+31 more)

### Community 40 - "descargo_dialog.dart"
Cohesion: 0.05
Nodes (38): ProduccionesRepository, actualizar, _actualizarStock, _almacen, almacenDefault, almacenes, build, _buildItemRow (+30 more)

### Community 41 - "validacion_dialog.dart"
Cohesion: 0.05
Nodes (43): proveedoresProvider, validacionRepoProvider, _aplicarPrefijo, _aplicarTemporal, build, _conPrefijo, createState, dispose (+35 more)

### Community 42 - "requisiciones_repository.dart"
Cohesion: 0.06
Nodes (35): _aplicarMoverStock, AuditStock, buscarProductos, cantidad, contarDetalles, crearAjusteStock, _db, destino (+27 more)

### Community 43 - "productos_panel.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/movimiento_dialog.dart, abrirSeleccion, build, categoriaId, createState, didUpdateWidget, dispose, initState (+17 more)

### Community 44 - "ticket_escpos.dart"
Cohesion: 0.07
Nodes (28): add, _centrar, cmd, construirTicketEscpos, construirTicketPreview, copyWith, _derecha, direccion (+20 more)

### Community 45 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (32): clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db, deleteCategoria (+24 more)

### Community 46 - "habitacion_config_dialog.dart"
Cohesion: 0.12
Nodes (17): build, createState, dispose, _esEdicion, false, _guardando, _guardar, habitacion (+9 more)

### Community 47 - "validacion_repository.dart"
Cohesion: 0.06
Nodes (31): almacen, buscarProveedor, cantidad, cantidadAnterior, cantidadNueva, crearProveedor, _db, eliminarEntrada (+23 more)

### Community 48 - "b8"
Cohesion: 0.11
Nodes (27): aB(), b0(), b2(), b8(), bC(), bI(), bj(), bs() (+19 more)

### Community 49 - "config_usuarios_tab.dart"
Cohesion: 0.14
Nodes (14): ../dialogs/nuevo_cajero_dialog.dart, build, _cargando, _cargar, ConfigUsuariosTab, _ConfigUsuariosTabState, createState, initState (+6 more)

### Community 50 - "graphify reference: extra exports and benchmark"
Cohesion: 0.22
Nodes (8): graphify reference: extra exports and benchmark, Step 6b - Wiki (only if --wiki flag), Step 7 - Neo4j export (only if --neo4j or --neo4j-push flag), Step 7a - FalkorDB export (only if --falkordb or --falkordb-push flag), Step 7b - SVG export (only if --svg flag), Step 7c - GraphML export (only if --graphml flag), Step 7d - MCP server (only if --mcp flag), Step 8 - Token reduction benchmark (only if total_words > 5000)

### Community 51 - "factura_detalle_dialog.dart"
Cohesion: 0.15
Nodes (14): ../data/historial_providers.dart, Future, historialRepoProvider, FacturaDetalle, _exportar, build, createState, _FacturaDetalleDialog (+6 more)

### Community 52 - "Plan de Migración: Flet (Python) → Flutter (Dart)"
Cohesion: 0.05
Nodes (39): 0. Inventario de lo que existe hoy (auditoría), 10. Riesgos y decisiones abiertas, 1. Arquitectura objetivo (Flutter), 2.1 Esquema, 2.2 Cliente Supabase, 2.3 Repositorios, 2. Capa de datos, 3. Motor de sincronización (+31 more)

### Community 53 - "temporales_repository.dart"
Cohesion: 0.08
Nodes (23): _controller, createdAt, dispose, eliminar, fecha, getTemporales, guardar, id (+15 more)

### Community 54 - "config_habitaciones_tab.dart"
Cohesion: 0.12
Nodes (16): ../dialogs/habitacion_config_dialog.dart, build, _cargando, _cargar, ConfigHabitacionesTab, _ConfigHabitacionesTabState, createState, _editarHabitacion (+8 more)

### Community 55 - "stock_screen.dart"
Cohesion: 0.07
Nodes (32): dialogs/existencias_dialog.dart, stockRepoProvider, _almacen, _almacenes, build, _buildFiltros, _buildLista, _buildStats (+24 more)

### Community 56 - "requisiciones/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.12
Nodes (15): ../../data/requisiciones_repository.dart, almacenes, build, esPesable, filtrados, _fmt, m, _MovimientoCard (+7 more)

### Community 57 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (28): AuditItem, _abrirCalculadora, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _campoPrincipal (+20 more)

### Community 58 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, FlView, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins() (+14 more)

### Community 59 - "existencias_dialog.dart"
Cohesion: 0.22
Nodes (8): ajuste_dialog.dart, ../data/stock_repository.dart, capitalize, esPesable, existencias, fmtCant, showExistenciasDialog, _StringCapitalize

### Community 60 - "graphify reference: query, path, explain"
Cohesion: 0.33
Nodes (5): For /graphify explain, For /graphify path, graphify reference: query, path, explain, Step 0 — Constrained query expansion (REQUIRED before traversal), Step 1 — Traversal

### Community 61 - "package:flutter_test/flutter_test.dart"
Cohesion: 0.11
Nodes (13): package:control_entradas_salidas/core/auth/session_controller.dart, package:control_entradas_salidas/core/router/app_shell.dart, package:control_entradas_salidas/features/pos/data/pos_comanda_models.dart, package:control_entradas_salidas/features/pos/data/ticket_escpos.dart, package:flutter_test/flutter_test.dart, main, main, main (+5 more)

### Community 62 - "fN"
Cohesion: 0.10
Nodes (20): a0(), bw(), cB(), dl(), eR(), eS(), fg(), fN() (+12 more)

### Community 63 - "a5"
Cohesion: 0.10
Nodes (29): a5(), a6(), a7(), aj(), c1(), cP(), d7(), e9() (+21 more)

### Community 64 - "aM"
Cohesion: 0.09
Nodes (28): aM(), aV(), b6(), bf(), cU(), D(), d3(), dB() (+20 more)

### Community 65 - "graphify reference: add a URL and watch a folder"
Cohesion: 0.50
Nodes (3): For /graphify add, For --watch, graphify reference: add a URL and watch a folder

### Community 66 - "graphify reference: commit hook and native CLAUDE.md integration"
Cohesion: 0.50
Nodes (3): For git commit hook, For native CLAUDE.md integration, graphify reference: commit hook and native CLAUDE.md integration

### Community 67 - "graphify reference: incremental update and cluster-only"
Cohesion: 0.50
Nodes (3): For --cluster-only, For --update (incremental re-extraction), graphify reference: incremental update and cluster-only

### Community 68 - "mensaje_whatsapp.dart"
Cohesion: 0.13
Nodes (14): createdAt, estado, fromMap, id, imagenBase64, imagenPath, intentos, maxIntentos (+6 more)

### Community 69 - "configuracion_providers.dart"
Cohesion: 0.21
Nodes (13): configuracion_repository.dart, ../../../core/models/periodo.dart, ../../../../core/models/proveedor.dart, almacenesConfigProvider, almacenProduccionDefaultProvider, db, periodosConfigProvider, permitirStockNegativoProvider (+5 more)

### Community 70 - "aM"
Cohesion: 0.09
Nodes (28): aM(), aV(), b6(), bf(), cU(), D(), d3(), dB() (+20 more)

### Community 73 - "cantidad_dialog.dart"
Cohesion: 0.08
Nodes (26): ../../../calculadora/presentation/calculadora.dart, RequisicionItem, _abrirCalculadora, _agregar, build, _campoPrincipal, _cantCtrl, _CantidadDialog (+18 more)

### Community 74 - "factura.dart"
Cohesion: 0.07
Nodes (26): createdAt, estado, Factura, facturaId, FacturaPago, fechaFactura, fechaPago, fechaRecepcion (+18 more)

### Community 75 - "producto_dialog.dart"
Cohesion: 0.08
Nodes (26): _activo, _almacenPredeterminado, _cargarCodigoAuto, _categoriaId, _codigoAuto, _codigoCtrl, createState, _descripcionCtrl (+18 more)

### Community 76 - "plato_config_dialog.dart"
Cohesion: 0.05
Nodes (36): ../../../../core/models/producto.dart, ../../../../features/inventario/data/inventario_providers.dart, build, cantidadCtrl, _cargando, _categoriaId, _categorias, createState (+28 more)

### Community 77 - "github_releases_source.dart"
Cohesion: 0.14
Nodes (13): checkForUpdate, checkOfNewer, _client, _compareVersions, createGitHubReleasesSource, fetchLatest, GitHubReleasesSource, _latestUrl (+5 more)

### Community 78 - "requisicion.dart"
Cohesion: 0.08
Nodes (25): actualizada, cantidad, cantidadSurtida, copyWith, creadaPor, destino, estado, fechaCreacion (+17 more)

### Community 79 - "producto.dart"
Cohesion: 0.08
Nodes (23): activo, almacenPredeterminado, categoriaId, codigo, copyWith, createdAt, descripcion, esPesable (+15 more)

### Community 83 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 85 - "historial_repository.dart"
Cohesion: 0.08
Nodes (25): archivado, cantidad, countFacturas, _db, divisasUsd, efectivo, esPesable, factura (+17 more)

### Community 87 - "inventario_repository.dart"
Cohesion: 0.09
Nodes (22): categoriaColor, categoriaId, categoriaNombre, _db, deleteComprasLista, esPesable, getAllCategorias, getAllProductos (+14 more)

### Community 88 - "subcategoria_dialog.dart"
Cohesion: 0.08
Nodes (24): PosPlatoCategoria, build, _cargando, _cargarPadres, _catsInv, _color, _colores, createState (+16 more)

### Community 89 - "exportar_dialog.dart"
Cohesion: 0.13
Nodes (15): _anioCtrl, build, createState, dispose, _exportando, _ExportarDialog, _ExportarDialogState, _fmtFecha (+7 more)

### Community 90 - "movimiento.dart"
Cohesion: 0.09
Nodes (21): almacen, cantidad, cantidadAnterior, cantidadNueva, copyWith, createdAt, facturaId, fechaMovimiento (+13 more)

### Community 91 - "win32_window.cpp"
Cohesion: 0.18
Nodes (14): Point, Size, wchar_t, Scale(), Create, Destroy, UpdateTheme, Win32Window::Win32Window() (+6 more)

### Community 92 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): FlutterViewController, unique_ptr, DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM (+6 more)

### Community 93 - "receta.dart"
Cohesion: 0.09
Nodes (21): activo, cantidad, cantidadProducida, copyWith, createdAt, fromMap, id, nombre (+13 more)

### Community 94 - "pos_comanda_models.dart"
Cohesion: 0.08
Nodes (23): cantidad, ComandaActiva, ComandaItem, dec, decimales, _encode, entero, formatearBs (+15 more)

### Community 95 - "session_controller.dart"
Cohesion: 0.16
Nodes (14): ../data/supabase_providers.dart, ../data/supabase_service.dart, Authenticated, cerrarSesion, _db, nombre, pinHash, registrarOperador (+6 more)

### Community 96 - "pos_home_header.dart"
Cohesion: 0.15
Nodes (12): double?, build, cargando, cargandoTasa, _fechaLarga, h, _meses, nombre (+4 more)

### Community 97 - "Win32Window"
Cohesion: 0.20
Nodes (14): RECT, OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, OnCreate (+6 more)

### Community 98 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 99 - "bandeja_screen.dart"
Cohesion: 0.08
Nodes (32): ../../../core/data/realtime_service.dart, ../../../../core/models/mensaje_whatsapp.dart, ../data/whatsapp_providers.dart, RealtimeSubscription, realtimeServiceProvider, initState, _initRealtime, bandejaProvider (+24 more)

### Community 100 - "pagos_panel.dart"
Cohesion: 0.08
Nodes (24): _abrirPanel, _agregarBoton, _agregarPago, build, createState, dispose, _divisasMonto, _divisasTasa (+16 more)

### Community 101 - "b8"
Cohesion: 0.14
Nodes (23): aB(), b0(), b2(), b8(), bC(), bI(), bj(), dN() (+15 more)

### Community 102 - "dF"
Cohesion: 0.10
Nodes (23): aG(), c8(), cV(), d9(), dF(), dH(), ed(), ei() (+15 more)

### Community 103 - "ei"
Cohesion: 0.31
Nodes (9): c8(), d9(), ed(), ei(), eu(), gbi(), hi(), hj() (+1 more)

### Community 104 - "ka"
Cohesion: 0.12
Nodes (22): c2(), cw(), d1(), d2(), dr(), ds(), dY(), eX() (+14 more)

### Community 105 - "categoria_dialog.dart"
Cohesion: 0.10
Nodes (20): _activo, build, categoria, _CategoriaDialog, _CategoriaDialogState, _colorCtrl, _ColorPickerButton, controller (+12 more)

### Community 106 - "supabase_service.dart"
Cohesion: 0.10
Nodes (20): _client, count, deleteById, deleteWhere, fetchAll, fetchByField, fetchById, fetchByTwoFields (+12 more)

### Community 107 - "produccion.dart"
Cohesion: 0.10
Nodes (19): cantidad, cocineros, createdAt, estado, fechaProduccion, fromMap, id, movimientoId (+11 more)

### Community 108 - "pos_categoria_dialog.dart"
Cohesion: 0.10
Nodes (20): PosCategoria, build, categoria, _color, _colores, createState, dispose, _esEdicion (+12 more)

### Community 109 - "nuevo_cajero_dialog.dart"
Cohesion: 0.15
Nodes (13): build, _conPin, createState, dispose, _esAdmin, _guardando, _guardar, _mostrarError (+5 more)

### Community 110 - "ka"
Cohesion: 0.12
Nodes (22): c2(), cw(), d1(), d2(), dr(), ds(), dY(), eX() (+14 more)

### Community 111 - "periodos_tab.dart"
Cohesion: 0.18
Nodes (13): ../../data/configuracion_repository.dart, _aperturando, _aperturarPeriodo, build, createState, _forzando, _forzarArchivo, _periodoActual (+5 more)

### Community 112 - "proveedor_dialog.dart"
Cohesion: 0.10
Nodes (20): ConfiguracionRepository, build, _contactoCtrl, createState, _direccionCtrl, dispose, _emailCtrl, _estado (+12 more)

### Community 113 - "visualizar_view.dart"
Cohesion: 0.09
Nodes (22): build, detalle, _ErrorDetailsDialog, showErrorDetailsDialog, titulo, build, _cargando, _cargar (+14 more)

### Community 114 - "file_logger.dart"
Cohesion: 0.17
Nodes (11): IOSink?, dispose, FileLogger, init, _initialized, instance, log, logToFile (+3 more)

### Community 115 - "proveedor.dart"
Cohesion: 0.12
Nodes (15): contacto, copyWith, createdAt, direccion, email, estado, fromMap, id (+7 more)

### Community 116 - "produccionesRepoProvider"
Cohesion: 0.18
Nodes (11): build, _cargarRecetas, produccionesRepoProvider, productosActivosProvider, _cargar, _cargar, build, _cargarInicial (+3 more)

### Community 117 - "whatsapp_repository.dart"
Cohesion: 0.07
Nodes (28): botUrl, countPending, _db, eliminar, _enviarDesdeCola, enviarImagen, _enviarImagenDirecto, enviarMensaje (+20 more)

### Community 118 - "stock_repository.dart"
Cohesion: 0.12
Nodes (16): agotado, ajustarExistencia, bajo, _db, filterProductos, getAlmacenes, getExistenciasMap, getExistenciasProducto (+8 more)

### Community 119 - "pin_dialog.dart"
Cohesion: 0.17
Nodes (12): build, createState, _ctrl, dispose, _entrar, _error, _focus, initState (+4 more)

### Community 121 - "MainActivity"
Cohesion: 0.26
Nodes (8): MainActivity, PackageInstallerReceiver, BroadcastReceiver, Context, FlutterActivity, FlutterEngine, Intent, MethodChannel

### Community 122 - "categoria.dart"
Cohesion: 0.13
Nodes (14): activo, Categoria, color, copyWith, createdAt, descripcion, fromMap, id (+6 more)

### Community 123 - "static const"
Cohesion: 0.17
Nodes (10): dart:convert, AppColors, dark, light, of, _apiKey, extractFactura, OcrService (+2 more)

### Community 124 - "proveedores_tab.dart"
Cohesion: 0.18
Nodes (12): ../dialogs/proveedor_dialog.dart, proveedoresConfigProvider, _abrirDialogo, build, _buildHeader, createState, dispose, _eliminar (+4 more)

### Community 125 - "ConsumerWidget"
Cohesion: 0.16
Nodes (18): ConsumerWidget, CategoriasGrid, ListaCompraItem, ProductoCard, comandasActivasProvider, habitacionesOcupadasProvider, habitacionesProvider, mesasOcupadasProvider (+10 more)

### Community 126 - "pos_providers.dart"
Cohesion: 0.17
Nodes (11): comandasAbiertasProvider, db, platosProvider, ref, ultimaVentaVigenteProvider, ventasProvider, watch, build (+3 more)

### Community 127 - "O"
Cohesion: 0.18
Nodes (13): $4(), au(), b1(), bK(), f2(), f3(), giI(), ha() (+5 more)

### Community 128 - "sistema_tab.dart"
Cohesion: 0.14
Nodes (17): ../../../../core/state/theme_controller.dart, configuracionRepoProvider, _abrirDialogo, _eliminar, _cambiarOperador, _confirmarCambioOperador, createState, _probarConexionLocal (+9 more)

### Community 129 - "O"
Cohesion: 0.10
Nodes (21): $4(), au(), b1(), bK(), bw(), f2(), f3(), fg() (+13 more)

### Community 130 - "models/models.dart"
Cohesion: 0.15
Nodes (12): categoria.dart, existencia.dart, factura.dart, mensaje_whatsapp.dart, movimiento.dart, periodo.dart, pos_models.dart, produccion.dart (+4 more)

### Community 131 - "update_models.dart"
Cohesion: 0.17
Nodes (11): AppUpdateInfo, assetFor, assets, fromJson, name, _normalizeVersion, releasedAt, size (+3 more)

### Community 132 - "../../../core/data/supabase_providers.dart"
Cohesion: 0.20
Nodes (7): ../../../core/data/supabase_providers.dart, inventario_repository.dart, db, db, db, requisiciones_repository.dart, stock_repository.dart

### Community 133 - "ticket_settings.dart"
Cohesion: 0.07
Nodes (27): cargarMembrete, direccion, getCorrelativoActual, getHeaderSize, getPrinterDevice, getSetting, guardarMembrete, kComandaCorrelativo (+19 more)

### Community 134 - "categoria_card.dart"
Cohesion: 0.18
Nodes (11): build, CategoriaCard, _CategoriaCardState, color, createState, nombre, _onEnter, onTap (+3 more)

### Community 135 - "ticket_preview_dialog.dart"
Cohesion: 0.22
Nodes (8): ../../../../core/utils/web_utils.dart, build, _imprimirWeb, lineas, showTicketPreview, TicketPreviewDialog, titulo, required List

### Community 136 - "stock_whatsapp_models_test.dart"
Cohesion: 0.25
Nodes (7): package:control_entradas_salidas/core/models/categoria.dart, package:control_entradas_salidas/core/models/existencia.dart, package:control_entradas_salidas/core/models/mensaje_whatsapp.dart, package:control_entradas_salidas/core/models/movimiento.dart, package:control_entradas_salidas/core/models/producto.dart, package:control_entradas_salidas/features/validacion/data/temporales_repository.dart, main

### Community 137 - "updater_platform_io.dart"
Cohesion: 0.04
Nodes (48): Exception, 1, _basename, bat, canInstall, _channel, close, _copyContents (+40 more)

### Community 138 - "catalogo_card.dart"
Cohesion: 0.18
Nodes (11): badge, build, CatalogoCard, _CatalogoCardState, color, createState, _iniciales, nombre (+3 more)

### Community 139 - "app_theme.dart"
Cohesion: 0.08
Nodes (24): app_colors.dart, accent, AppThemeData, base, buildAppTheme, buttonPadding, buttonShape, c (+16 more)

### Community 140 - "requisicion_card.dart"
Cohesion: 0.18
Nodes (10): ../../../../core/models/requisicion.dart, Requisicion, build, _estadoColor, _fmtFecha, onAuditar, onEditar, onEliminar (+2 more)

### Community 141 - "int?"
Cohesion: 0.18
Nodes (10): int?, categoriaId, categorias, codigoCtrl, esPesable, nombreCtrl, precioCtrl, repo (+2 more)

### Community 142 - "DateTime"
Cohesion: 0.25
Nodes (5): DateTime, fetch_bcv_html(), get_bcv_html(), Descarga el HTML del sitio oficial del BCV (misma petición que el scrape del…, WebServer

### Community 143 - "existencia.dart"
Cohesion: 0.18
Nodes (10): almacen, cantidad, copyWith, Existencia, fromMap, id, productoId, StockCheckpoint (+2 more)

### Community 144 - "web_utils_web.dart"
Cohesion: 0.11
Nodes (17): dart:html, dart:typed_data, openInNewTab, PasteCancel, printHtml, reloadApp, setupPasteImageListener, contenedor (+9 more)

### Community 145 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 146 - "pos_screen.dart"
Cohesion: 0.07
Nodes (37): comanda_screen.dart, config_screen.dart, dialogs/pin_dialog.dart, habitaciones_screen.dart, turnoActivoUsuarioProvider, usuariosProvider, posSessionProvider, didChangeAppLifecycleState (+29 more)

### Community 147 - "package:http/http.dart"
Cohesion: 0.29
Nodes (6): package:control_entradas_salidas/features/pos/data/tasa_bcv_service.dart, package:http/http.dart, package:http/testing.dart, StateError, _htmlOficial, main

### Community 148 - "periodo.dart"
Cohesion: 0.18
Nodes (10): ComprasLista, createdAt, fechaApertura, fromMap, id, _parseDt, Periodo, productoId (+2 more)

### Community 149 - "historial_providers.dart"
Cohesion: 0.33
Nodes (5): historial_repository.dart, db, ref, watch, return

### Community 150 - "../../data/pos_providers.dart"
Cohesion: 0.04
Nodes (49): ../../../core/theme/app_theme.dart, ../../../core/updater/update_settings_card.dart, dart:math, ../../data/pos_providers.dart, ../data/pos_session.dart, PosSesionActiva, PosSessionNotifier, _ActualizacionesTab (+41 more)

### Community 151 - "../../../core/models/categoria.dart"
Cohesion: 0.25
Nodes (7): categoria_card.dart, ../../../core/models/categoria.dart, InventarioRepository, build, onSelect, repo, searchTerm

### Community 152 - "pop_in.dart"
Cohesion: 0.13
Nodes (15): AnimationController, CurvedAnimation, Duration, build, child, createState, _ctrl, delay (+7 more)

### Community 153 - "login_screen.dart"
Cohesion: 0.10
Nodes (22): ../../../core/auth/session_controller.dart, ../../../core/updater/auto_update_checker.dart, sessionProvider, supabaseServiceProvider, AppShell, build, themeControllerProvider, build (+14 more)

### Community 154 - "facturas_tab.dart"
Cohesion: 0.13
Nodes (16): dialogs/factura_detalle_dialog.dart, facturasProvider, _abrirDetalle, build, _buildFiltros, createState, dispose, FacturasTab (+8 more)

### Community 155 - "dart:async"
Cohesion: 0.28
Nodes (7): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, features/pos/presentation/pos_app.dart, main, main

### Community 156 - "tasa_bcv_service.dart"
Cohesion: 0.14
Nodes (13): Client, _bcvFallbackUrl, _bcvSiteUrl, _client, obtenerTasaBcv, _obtenerTasaBcvToday, _obtenerTasaProxyOficial, _obtenerTasaSitioOficial (+5 more)

### Community 157 - "app_updater.dart"
Cohesion: 0.11
Nodes (17): double get, github_releases_source.dart, AppUpdater, _assetName, canRun, checkForUpdate, download, _fileName (+9 more)

### Community 158 - "config_platos_tab.dart"
Cohesion: 0.06
Nodes (31): ../dialogs/plato_config_dialog.dart, int get, build, _cargando, _cargar, cat, _cats, color (+23 more)

### Community 159 - "categorias_tab.dart"
Cohesion: 0.15
Nodes (14): ../../data/configuracion_providers.dart, ../dialogs/categoria_dialog.dart, categoriasConfigProvider, build, _abrirDialogo, build, CategoriasTab, _CategoriasTabState (+6 more)

### Community 160 - "web/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 161 - "web_pos/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 162 - "mesa_config_dialog.dart"
Cohesion: 0.06
Nodes (33): ../dialogs/mesa_config_dialog.dart, PosMesa, build, createState, dispose, _esEdicion, false, _guardando (+25 more)

### Community 163 - "productos_tab.dart"
Cohesion: 0.10
Nodes (21): ColorScheme, ../dialogs/producto_dialog.dart, productosConfigProvider, _almacen, build, _buildHeader, categoria, _categoriaId (+13 more)

### Community 165 - "producciones_providers.dart"
Cohesion: 0.22
Nodes (8): ../../../core/data/supabase_service.dart, db, historialProduccionesProvider, pendientesProvider, recetasProvider, ref, watch, producciones_repository.dart

### Community 166 - "MessageHandler"
Cohesion: 0.36
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetHandle, GetThisFromHandle (+2 more)

### Community 167 - "producto_stock_card.dart"
Cohesion: 0.12
Nodes (15): ../../../../core/models/existencia.dart, ../../data/stock_providers.dart, Producto, build, _parseColor, producto, repo, seleccionado (+7 more)

### Community 168 - "printer_service_native.dart"
Cohesion: 0.22
Nodes (8): dart:io, imprimirPorWeb, imprimirTicketNativo, listarImpresoras, nombre, printRawData, puedeImprimirNativo, package:windows_printer/windows_printer.dart

### Community 170 - "entrada_card.dart"
Cohesion: 0.25
Nodes (7): ../../data/historial_repository.dart, EntradaPorFecha, build, entrada, EntradaCard, _fmtHora, _pesoBadge

### Community 173 - "State"
Cohesion: 0.20
Nodes (14): _LoteSelector, _LoteSelectorState, _ContornosDialog, _ContornosDialogState, _AnularVentaDialog, _AnularVentaDialogState, EntryCard, _EntryCardState (+6 more)

### Community 177 - "log_bridge.dart"
Cohesion: 0.17
Nodes (11): _endpoint, flush, instance, LogBridge, _pending, push, start, _timer (+3 more)

### Community 179 - "requisiciones_screen.dart"
Cohesion: 0.15
Nodes (13): _abrir, build, _cerrar, createState, _eliminar, RequisicionesScreen, _RequisicionesScreenState, _vistaActiva (+5 more)

### Community 182 - "update_dialog.dart"
Cohesion: 0.11
Nodes (19): _actualizar, build, _cargarVersion, createState, _descargando, _error, info, initState (+11 more)

### Community 183 - "audit_view.dart"
Cohesion: 0.07
Nodes (32): ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, requisicionesRepoProvider, _aceptar, _cargarProducto, _cargarDisponible, AuditView, _AuditViewState (+24 more)

### Community 184 - "update_settings_card.dart"
Cohesion: 0.11
Nodes (21): AutoUpdateChecker, _AutoUpdateCheckerState, build, _checkear, _chequeado, createState, build, _buscando (+13 more)

### Community 186 - "List"
Cohesion: 0.06
Nodes (34): build, _CategoriaGroup, createState, group, ListaCompraPanel, _ListaCompraPanelState, onClose, _parseColor (+26 more)

### Community 187 - "buscador_productos_dialog.dart"
Cohesion: 0.18
Nodes (11): class, ../../data/requisiciones_providers.dart, build, _BuscadorProductosDialog, _BuscadorProductosDialogState, _buscar, _busqueda, createState (+3 more)

### Community 188 - "config_tasa_tab.dart"
Cohesion: 0.12
Nodes (17): ../../data/tasa_bcv_service.dart, _actualizar, build, _cargarGuardada, ConfigTasaTab, _ConfigTasaTabState, _consultando, createState (+9 more)

### Community 194 - "stock/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.18
Nodes (10): ../../../../core/models/movimiento.dart, Movimiento, build, esPesable, _fmt, m, _MovimientoCard, showHistorialDialog (+2 more)

### Community 197 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 203 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

## Knowledge Gaps
- **2270 isolated node(s):** `XCTest`, `_db`, `nombre`, `pinHash`, `registrarOperador` (+2265 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **12 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `SupabaseService` connect `session_controller.dart` to `pos_repository.dart`, `supabase_service.dart`, `requisiciones_repository.dart`, `configuracion_repository.dart`, `producciones_repository.dart`, `validacion_repository.dart`, `pos_ventas_repository.dart`, `historial_repository.dart`, `stock_repository.dart`, `inventario_repository.dart`, `whatsapp_repository.dart`?**
  _High betweenness centrality (0.010) - this node is a cross-community bridge._
- **Why does `posRepoProvider` connect `comanda_screen.dart` to `mesa_config_dialog.dart`, `../../../../core/models/pos_models.dart`, `config_categorias_tab.dart`, `config_platos_tab.dart`, `plato_config_dialog.dart`, `nuevo_cajero_dialog.dart`, `habitacion_config_dialog.dart`, `pos_categoria_dialog.dart`, `config_usuarios_tab.dart`, `pos_screen.dart`, `../../data/pos_providers.dart`, `ConsumerState`, `inventario_screen.dart`, `config_habitaciones_tab.dart`, `subcategoria_dialog.dart`, `config_tasa_tab.dart`, `pos_providers.dart`?**
  _High betweenness centrality (0.004) - this node is a cross-community bridge._
- **Why does `Producto` connect `producto_stock_card.dart` to `productos_tab.dart`, `producto_dialog.dart`, `producto.dart`, `movimiento_dialog.dart`, `receta_editor_screen.dart`?**
  _High betweenness centrality (0.002) - this node is a cross-community bridge._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web_pos/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._
- **What connects `XCTest`, `_db`, `nombre` to the rest of the system?**
  _2270 weakly-connected nodes found - possible documentation gaps or missing edges._