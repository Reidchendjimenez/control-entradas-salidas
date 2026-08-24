# Graph Report - flutter_app  (2026-08-18)

## Corpus Check
- 212 files · ~256,390 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 5179 nodes · 9794 edges · 183 communities (174 shown, 9 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 656 edges (avg confidence: 0.51)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `a9ef17fe`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- app_database.dart
- web_pos/drift_worker.js
- web/drift_worker.js
- tables.dart
- a
- a
- comanda_screen.dart
- ventas_screen.dart
- r
- package:flutter/material.dart
- DataClass
- r
- pos_screen.dart
- c
- N
- producciones_repository.dart
- c
- pos_home_screen.dart
- N
- pos_repository.dart
- app_shell.dart
- stock_screen.dart
- i
- AppDatabase
- ConsumerState
- producciones_screen.dart
- sync_engine.dart
- updater_platform_io.dart
- i
- pos_sync_engine.dart
- aQ
- movimiento_dialog.dart
- validacion_dialog.dart
- at
- visualizar_view.dart
- receta_editor_screen.dart
- List
- pos_ventas_repository.dart
- requisiciones_repository.dart
- O
- Table
- a5
- validacion_repository.dart
- configuracion_repository.dart
- habitacion_config_dialog.dart
- config_platos_tab.dart
- sistema_tab.dart
- a5
- $0
- ajuste_auditoria_dialog.dart
- config_categorias_tab.dart
- plato_config_dialog.dart
- ticket_escpos.dart
- lista_compra_panel.dart
- sync_service.dart
- ticket_settings.dart
- whatsapp_repository.dart
- tasa_bcv_service.dart
- pos_providers.dart
- my_application.cc
- dF
- form_view.dart
- productos_panel.dart
- calculadora_dialog.dart
- producto_dialog.dart
- inventario_repository.dart
- app_theme.dart
- precargar_imagen_dialog.dart
- historial_repository.dart
- cantidad_dialog.dart
- subcategoria_dialog.dart
- audit_view.dart
- update_settings_card.dart
- pos_comanda_models.dart
- pagos_panel.dart
- dF
- entry_card.dart
- productos_tab.dart
- configuracionRepoProvider
- ka
- validacion_screen.dart
- package:drift/drift.dart
- categoria_dialog.dart
- bg
- AppDelegate
- github_releases_source.dart
- update_dialog.dart
- proveedor_dialog.dart
- pos_categoria_dialog.dart
- web_utils_web.dart
- bandeja_screen.dart
- por_fecha_tab.dart
- ka
- config_tasa_tab.dart
- sync_status.dart
- inventario_screen.dart
- win32_window.cpp
- O
- package:flutter_riverpod/flutter_riverpod.dart
- recetas_tab.dart
- temporales_dialog.dart
- facturas_tab.dart
- config_habitaciones_tab.dart
- config_mesas_tab.dart
- app_updater.dart
- FlutterWindow
- log_bridge.dart
- temporales_repository.dart
- pop_in.dart
- requisiciones/presentation/dialogs/historial_dialog.dart
- exportar_dialog.dart
- MainActivity
- bool get
- login_screen.dart
- factura_detalle_dialog.dart
- pendientes_tab.dart
- config_usuarios_tab.dart
- proveedores_tab.dart
- categorias_tab.dart
- requisiciones_screen.dart
- Win32Window
- inventarioRepoProvider
- produccionesRepoProvider
- contornos_dialog.dart
- historial_tab.dart
- wWinMain
- file_logger.dart
- update_models.dart
- State
- categoria_card.dart
- catalogo_card.dart
- buscador_productos_dialog.dart
- agregar_producto_dialog.dart
- DateTime
- estado_card.dart
- producciones_providers.dart
- web/manifest.json
- web_pos/manifest.json
- requisicion_card.dart
- requisicionesRepoProvider
- ia
- MessageHandler
- dart:async
- printer_service_native.dart
- entrada_pendiente_card.dart
- stock/presentation/dialogs/historial_dialog.dart
- entrada_card.dart
- app_config.dart
- whatsapp_providers.dart
- ../../../../core/utils/web_utils.dart
- validacion_providers.dart
- ticket_escpos_test.dart
- ConsumerWidget
- database_provider.dart
- RegisterPlugins
- app_database.dart
- db_executor_io.dart
- UpdatePermissionException
- LaunchImage.imageset/README.md
- web_utils.dart
- printer_service.dart
- README.md
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
- `_abrirDialogo` --references--> `configuracionRepoProvider`  [EXTRACTED]
  lib/features/configuracion/presentation/widgets/proveedores_tab.dart → lib/features/configuracion/data/configuracion_providers.dart
- `_eliminar` --references--> `configuracionRepoProvider`  [EXTRACTED]
  lib/features/configuracion/presentation/widgets/proveedores_tab.dart → lib/features/configuracion/data/configuracion_providers.dart
- `cerrarSesion` --references--> `posRepoProvider`  [EXTRACTED]
  lib/features/pos/data/pos_session.dart → lib/features/pos/data/pos_providers.dart

## Import Cycles
- None detected.

## Communities (183 total, 9 thin omitted)

### Community 0 - "app_database.dart"
Cohesion: 0.01
Nodes (313): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class PlatoIngrediente extends, class PosSyncTombstone extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends (+305 more)

### Community 1 - "web_pos/drift_worker.js"
Cohesion: 0.01
Nodes (78): bs(), cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), e4(), eR(), eS() (+70 more)

### Community 2 - "web/drift_worker.js"
Cohesion: 0.01
Nodes (77): cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), e4(), eR(), eS() (+69 more)

### Community 3 - "tables.dart"
Cohesion: 0.01
Nodes (140): DateTimeColumn get, IntColumn get, abiertaEn, activo, actualizada, almacen, almacenPredeterminado, anuladaEn (+132 more)

### Community 4 - "a"
Cohesion: 0.05
Nodes (110): $1(), a(), a1(), a4(), aa(), aH(), aR(), aw() (+102 more)

### Community 5 - "a"
Cohesion: 0.05
Nodes (109): $1(), $2(), a(), a1(), a4(), a9(), aa(), aH() (+101 more)

### Community 6 - "comanda_screen.dart"
Cohesion: 0.02
Nodes (98): AnimatedListState, ../../data/printer_service.dart, ../../data/ticket_escpos.dart, ../../data/ticket_settings.dart, dialogs/cobro_dialog.dart, dialogs/contornos_dialog.dart, ../dialogs/ticket_preview_dialog.dart, posRepoProvider (+90 more)

### Community 7 - "ventas_screen.dart"
Cohesion: 0.02
Nodes (88): calculadora_button.dart, calculadora_dialog.dart, ../../data/pos_comanda_models.dart, double?, _AppDrawer, _AppHeader, _DestinoPage, _NavBarMobile (+80 more)

### Community 8 - "r"
Cohesion: 0.04
Nodes (82): $0(), $2(), $3(), $5(), a8(), a9(), ac(), ai() (+74 more)

### Community 9 - "package:flutter/material.dart"
Cohesion: 0.03
Nodes (70): ../../../../core/db/schema/app_database.dart, estado_card.dart, build, _estadoBadge, factura, FacturaCard, _fmtFecha, onTap (+62 more)

### Community 10 - "DataClass"
Cohesion: 0.05
Nodes (73): Insertable, UpdateCompanion, Categoria, CategoriasCompanion, ComprasListaCompanion, ComprasListaData, DataClass, DispositivoUsuarioCompanion (+65 more)

### Community 11 - "r"
Cohesion: 0.05
Nodes (63): $3(), $5(), ac(), aP(), az(), bB(), bd(), bP() (+55 more)

### Community 12 - "pos_screen.dart"
Cohesion: 0.04
Nodes (63): comanda_screen.dart, config_screen.dart, ../../../core/sync/sync_status.dart, ../../../core/theme/app_theme.dart, dart:math, ../../data/pos_providers.dart, dialogs/pin_dialog.dart, habitaciones_screen.dart (+55 more)

### Community 13 - "c"
Cohesion: 0.04
Nodes (64): aD(), aE(), at(), ba(), bt(), bV(), bw(), bZ() (+56 more)

### Community 14 - "N"
Cohesion: 0.05
Nodes (62): a3(), ai(), aM(), aV(), b6(), bf(), bN(), ce() (+54 more)

### Community 15 - "producciones_repository.dart"
Cohesion: 0.03
Nodes (59): almacen, almacenProduccionDefault, cancelarProduccion, cantidad, cantidadSugerida, cocineros, ComponenteInfo, contarComponentes (+51 more)

### Community 16 - "c"
Cohesion: 0.05
Nodes (60): a2(), aj(), aX(), aY(), ba(), bg(), bt(), bY() (+52 more)

### Community 17 - "pos_home_screen.dart"
Cohesion: 0.04
Nodes (52): ../../../core/sync/global_sync_bar.dart, ../../../core/updater/update_settings_card.dart, ../data/pos_session.dart, PosSesionActiva, PosSessionNotifier, _ActualizacionesTab, build, ConfigScreen (+44 more)

### Community 18 - "N"
Cohesion: 0.06
Nodes (56): aM(), aV(), b6(), bf(), ce(), cU(), D(), d3() (+48 more)

### Community 19 - "pos_repository.dart"
Cohesion: 0.04
Nodes (52): abrirSesion, actualizarHabitacion, actualizarMesa, actualizarPlato, actualizarPosCategoria, actualizarUsuario, cerrarSesion, cerrarSesionesStale (+44 more)

### Community 20 - "app_shell.dart"
Cohesion: 0.04
Nodes (48): ../auth/session_controller.dart, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/producciones/presentation/producciones_screen.dart, ../../features/requisiciones/presentation/requisiciones_screen.dart, ../../features/stock/presentation/stock_screen.dart (+40 more)

### Community 21 - "stock_screen.dart"
Cohesion: 0.05
Nodes (46): ajuste_dialog.dart, ../../data/stock_providers.dart, ../data/stock_repository.dart, dialogs/existencias_dialog.dart, stockRepoProvider, capitalize, esPesable, existencias (+38 more)

### Community 22 - "i"
Cohesion: 0.06
Nodes (49): a0(), aB(), b0(), b8(), bC(), bI(), bj(), c5() (+41 more)

### Community 23 - "AppDatabase"
Cohesion: 0.06
Nodes (39): _, @DriftDatabase, AppDatabase, openDbExecutor, PosRepository, PosVentasRepository, package:control_entradas_salidas/core/db/database_provider.dart, package:control_entradas_salidas/core/db/schema/app_database.dart (+31 more)

### Community 24 - "ConsumerState"
Cohesion: 0.05
Nodes (45): ConsumerState, ConsumerStatefulWidget, _CalculadoraDialog, _CalculadoraDialogState, _PinDialog, _PinDialogState, VentasScreen, _VentasScreenState (+37 more)

### Community 25 - "producciones_screen.dart"
Cohesion: 0.05
Nodes (42): dialogs/exportar_dialog.dart, facturas_tab.dart, historial_tab.dart, build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose (+34 more)

### Community 26 - "sync_engine.dart"
Cohesion: 0.04
Nodes (44): _catalogo, client, _db, def, _deleteMovimientoPorMatch, _descargarTabla, _downloadAllFromServer, fullSync (+36 more)

### Community 27 - "updater_platform_io.dart"
Cohesion: 0.05
Nodes (42): 1, _basename, bat, canInstall, _channel, close, _copyContents, create (+34 more)

### Community 28 - "i"
Cohesion: 0.07
Nodes (43): a0(), aB(), b0(), b8(), bC(), bI(), bj(), c5() (+35 more)

### Community 29 - "pos_sync_engine.dart"
Cohesion: 0.05
Nodes (41): _bajarPaginado, client, _coerceIntColumns, _db, _descargarCatalogoVenta, _descargarSettings, _descargarTabla, _downloadAllFromServer (+33 more)

### Community 30 - "aQ"
Cohesion: 0.07
Nodes (42): a3(), ak(), an(), aQ(), b2(), b3(), b4(), b5() (+34 more)

### Community 31 - "movimiento_dialog.dart"
Cohesion: 0.05
Nodes (39): _abrirCalculadora, _almacen, _almacenes, _campoPrincipal, _cantCtrl, _cantFocus, capitalize, _cargar (+31 more)

### Community 32 - "validacion_dialog.dart"
Cohesion: 0.05
Nodes (39): proveedoresProvider, _aplicarPrefijo, _aplicarTemporal, build, _conPrefijo, createState, dispose, _escanearOcr (+31 more)

### Community 33 - "at"
Cohesion: 0.06
Nodes (40): aD(), aE(), aF(), aQ(), at(), bL(), bU(), bV() (+32 more)

### Community 34 - "visualizar_view.dart"
Cohesion: 0.06
Nodes (35): build, detalle, _ErrorDetailsDialog, showErrorDetailsDialog, titulo, build, _conPin, createState (+27 more)

### Community 35 - "receta_editor_screen.dart"
Cohesion: 0.05
Nodes (37): _agregarFilaVacia, _agregarProducto, _baseProducto, _baseSearchCtrl, _buscar, _cancelar, cantidadCtrl, _componentes (+29 more)

### Community 36 - "List"
Cohesion: 0.06
Nodes (33): dedupeKey, incrementalById, incrementalColumn, localTable, serverTable, syncedTables, SyncTableDescriptor, build (+25 more)

### Community 37 - "pos_ventas_repository.dart"
Cohesion: 0.05
Nodes (36): anularVenta, aplicarMovimientosVenta, cambiarEstadoComanda, cerrarComanda, _db, eliminarComanda, eliminarVentaYMovimientos, _encolarComanda (+28 more)

### Community 38 - "requisiciones_repository.dart"
Cohesion: 0.05
Nodes (36): _aplicarMoverStock, AuditStock, buscarProductos, cantidad, contarDetalles, crearAjusteStock, _db, destino (+28 more)

### Community 39 - "O"
Cohesion: 0.08
Nodes (37): $4(), ak(), an(), au(), b1(), b2(), b3(), b4() (+29 more)

### Community 40 - "Table"
Cohesion: 0.06
Nodes (36): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+28 more)

### Community 41 - "a5"
Cohesion: 0.07
Nodes (36): a5(), a6(), a7(), c1(), c2(), d7(), dB(), dc() (+28 more)

### Community 42 - "validacion_repository.dart"
Cohesion: 0.06
Nodes (34): ../../../core/sync/sync_engine.dart, almacen, buscarProveedor, cantidad, cantidadAnterior, cantidadNueva, crearProveedor, _db (+26 more)

### Community 43 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (34): archivarEnSupabase, clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db (+26 more)

### Community 44 - "habitacion_config_dialog.dart"
Cohesion: 0.06
Nodes (33): build, createState, dispose, _esEdicion, false, _guardando, _guardar, habitacion (+25 more)

### Community 45 - "config_platos_tab.dart"
Cohesion: 0.06
Nodes (30): ../dialogs/plato_config_dialog.dart, build, _cargando, _cargar, cat, _cats, color, ConfigPlatosTab (+22 more)

### Community 46 - "sistema_tab.dart"
Cohesion: 0.09
Nodes (29): configuracion_repository.dart, ../../../../core/state/theme_controller.dart, ../../data/configuracion_repository.dart, themeControllerProvider, syncEngineProvider, almacenesConfigProvider, almacenProduccionDefaultProvider, periodosConfigProvider (+21 more)

### Community 47 - "a5"
Cohesion: 0.09
Nodes (31): a5(), a6(), a7(), aj(), c1(), cP(), d7(), dB() (+23 more)

### Community 48 - "$0"
Cohesion: 0.09
Nodes (31): $0(), a8(), aL(), aO(), be(), bh(), bx(), c6() (+23 more)

### Community 49 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (29): AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _calcularDesdeTotal, _calcularDesdeUnidades (+21 more)

### Community 50 - "config_categorias_tab.dart"
Cohesion: 0.07
Nodes (28): ../dialogs/pos_categoria_dialog.dart, ../dialogs/subcategoria_dialog.dart, activo, build, _cargando, color, ConfigCategoriasTab, _ConfigCategoriasTabState (+20 more)

### Community 51 - "plato_config_dialog.dart"
Cohesion: 0.07
Nodes (28): ../../../../features/inventario/data/inventario_providers.dart, build, cantidadCtrl, _cargando, _categoriaId, _categorias, createState, dispose (+20 more)

### Community 52 - "ticket_escpos.dart"
Cohesion: 0.07
Nodes (28): add, _centrar, cmd, construirTicketEscpos, construirTicketPreview, copyWith, _derecha, direccion (+20 more)

### Community 53 - "lista_compra_panel.dart"
Cohesion: 0.08
Nodes (24): categoria_card.dart, ../../data/inventario_repository.dart, inventario_repository.dart, InventarioRepository, build, onSelect, repo, searchTerm (+16 more)

### Community 54 - "sync_service.dart"
Cohesion: 0.08
Nodes (26): ../db/database_provider.dart, ../db/schema/app_database.dart, Authenticated, cerrarSesion, _db, nombre, pinHash, registrarOperador (+18 more)

### Community 55 - "ticket_settings.dart"
Cohesion: 0.07
Nodes (27): cargarMembrete, direccion, getCorrelativoActual, getHeaderSize, getPrinterDevice, getSetting, guardarMembrete, kComandaCorrelativo (+19 more)

### Community 56 - "whatsapp_repository.dart"
Cohesion: 0.07
Nodes (27): botUrl, countPending, _db, eliminar, _enviarDesdeCola, enviarImagen, _enviarImagenDirecto, enviarMensaje (+19 more)

### Community 57 - "tasa_bcv_service.dart"
Cohesion: 0.08
Nodes (24): Client, dart:convert, _bcvFallbackUrl, _bcvSiteUrl, _client, obtenerTasaBcv, _obtenerTasaBcvToday, _obtenerTasaProxyOficial (+16 more)

### Community 58 - "pos_providers.dart"
Cohesion: 0.11
Nodes (26): ../../../core/sync/pos_sync_engine.dart, client, comandasAbiertasProvider, comandasActivasProvider, engine, habitacionesOcupadasProvider, habitacionesProvider, mesasOcupadasProvider (+18 more)

### Community 59 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, FlView, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins() (+14 more)

### Community 60 - "dF"
Cohesion: 0.08
Nodes (27): aG(), c8(), cD(), cV(), d9(), dF(), dH(), ed() (+19 more)

### Community 61 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 62 - "productos_panel.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/movimiento_dialog.dart, abrirSeleccion, build, categoriaId, createState, didUpdateWidget, dispose, initState (+17 more)

### Community 63 - "calculadora_dialog.dart"
Cohesion: 0.08
Nodes (25): build, _buildKeypad, _compute, createState, _display, _fmt, _handleKey, initialValue (+17 more)

### Community 64 - "producto_dialog.dart"
Cohesion: 0.08
Nodes (25): _activo, _almacenPredeterminado, _cargarCodigoAuto, _categoriaId, _codigoAuto, _codigoCtrl, createState, _descripcionCtrl (+17 more)

### Community 65 - "inventario_repository.dart"
Cohesion: 0.08
Nodes (25): categoriaColor, categoriaId, categoriaNombre, _db, deleteComprasLista, esPesable, getAllCategorias, getAllProductos (+17 more)

### Community 66 - "app_theme.dart"
Cohesion: 0.08
Nodes (24): app_colors.dart, accent, AppThemeData, base, buildAppTheme, buttonPadding, buttonShape, c (+16 more)

### Community 67 - "precargar_imagen_dialog.dart"
Cohesion: 0.08
Nodes (24): ../../data/ocr_service.dart, build, _conPrefijo, createState, dispose, _extrayendo, _facturaCtrl, _fechaCtrl (+16 more)

### Community 68 - "historial_repository.dart"
Cohesion: 0.08
Nodes (24): archivado, cantidad, countFacturas, _db, divisasUsd, efectivo, esPesable, factura (+16 more)

### Community 69 - "cantidad_dialog.dart"
Cohesion: 0.08
Nodes (24): RequisicionItem, _agregar, build, _calcularDesdeTotal, _calcularDesdeUnidades, _cantCtrl, _CantidadDialog, _CantidadDialogState (+16 more)

### Community 70 - "subcategoria_dialog.dart"
Cohesion: 0.09
Nodes (23): build, _cargando, _cargarPadres, _catsInv, _color, _colores, createState, dispose (+15 more)

### Community 71 - "audit_view.dart"
Cohesion: 0.09
Nodes (22): ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, AuditView, _AuditViewState, build, _cargando, createState, _guardando (+14 more)

### Community 72 - "update_settings_card.dart"
Cohesion: 0.11
Nodes (21): AutoUpdateChecker, _AutoUpdateCheckerState, build, _checkear, _chequeado, createState, build, _buscando (+13 more)

### Community 73 - "pos_comanda_models.dart"
Cohesion: 0.09
Nodes (22): cantidad, ComandaItem, dec, decimales, _encode, entero, formatearBs, formatearTasa (+14 more)

### Community 74 - "pagos_panel.dart"
Cohesion: 0.09
Nodes (22): _abrirPanel, _agregarBoton, _agregarPago, build, createState, dispose, _divisasMonto, _divisasTasa (+14 more)

### Community 75 - "dF"
Cohesion: 0.10
Nodes (23): aG(), c8(), cV(), d9(), dF(), dH(), ed(), ei() (+15 more)

### Community 76 - "entry_card.dart"
Cohesion: 0.10
Nodes (20): Color, IconData, badge, build, color, createState, icon, onTap (+12 more)

### Community 77 - "productos_tab.dart"
Cohesion: 0.10
Nodes (21): ColorScheme, ../dialogs/producto_dialog.dart, productosConfigProvider, _almacen, build, _buildHeader, categoria, _categoriaId (+13 more)

### Community 78 - "configuracionRepoProvider"
Cohesion: 0.12
Nodes (21): configuracionRepoProvider, _aperturando, _aperturarPeriodo, build, createState, _forzando, _forzarArchivo, _periodoActual (+13 more)

### Community 79 - "ka"
Cohesion: 0.12
Nodes (22): c2(), cw(), d1(), d2(), dr(), ds(), dY(), eX() (+14 more)

### Community 80 - "validacion_screen.dart"
Cohesion: 0.11
Nodes (20): dialogs/precargar_imagen_dialog.dart, dialogs/temporales_dialog.dart, dialogs/validacion_dialog.dart, temporalesProvider, validacionRepoProvider, _seccionTemporalesGuardados, _onTipoDocumento, _validar (+12 more)

### Community 81 - "package:drift/drift.dart"
Cohesion: 0.10
Nodes (19): driftDatabase, openDbExecutor, agotado, ajustarExistencia, bajo, _db, filterProductos, getAlmacenes (+11 more)

### Community 82 - "categoria_dialog.dart"
Cohesion: 0.10
Nodes (20): _activo, build, categoria, _CategoriaDialog, _CategoriaDialogState, _colorCtrl, _ColorPickerButton, controller (+12 more)

### Community 83 - "bg"
Cohesion: 0.12
Nodes (21): a2(), aX(), aY(), bg(), bY(), cl(), cM(), cO() (+13 more)

### Community 84 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 85 - "github_releases_source.dart"
Cohesion: 0.10
Nodes (18): ../config/app_config.dart, initialize, initializeSupabase, supabaseProvider, checkForUpdate, checkOfNewer, _client, _compareVersions (+10 more)

### Community 86 - "update_dialog.dart"
Cohesion: 0.11
Nodes (19): _actualizar, build, _cargarVersion, createState, _descargando, _error, info, initState (+11 more)

### Community 87 - "proveedor_dialog.dart"
Cohesion: 0.11
Nodes (19): build, _contactoCtrl, createState, _direccionCtrl, dispose, _emailCtrl, _estado, _guardando (+11 more)

### Community 88 - "pos_categoria_dialog.dart"
Cohesion: 0.11
Nodes (19): build, categoria, _color, _colores, createState, dispose, _esEdicion, false (+11 more)

### Community 89 - "web_utils_web.dart"
Cohesion: 0.11
Nodes (17): dart:html, dart:typed_data, openInNewTab, PasteCancel, printHtml, reloadApp, setupPasteImageListener, contenedor (+9 more)

### Community 90 - "bandeja_screen.dart"
Cohesion: 0.15
Nodes (18): ../data/whatsapp_providers.dart, bandejaProvider, whatsappRepoProvider, BandejaScreen, _BandejaScreenState, build, createState, dispose (+10 more)

### Community 91 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 92 - "ka"
Cohesion: 0.14
Nodes (19): cw(), d1(), d2(), dr(), ds(), dY(), eX(), eY() (+11 more)

### Community 93 - "config_tasa_tab.dart"
Cohesion: 0.12
Nodes (17): ../../data/tasa_bcv_service.dart, _actualizar, build, _cargarGuardada, ConfigTasaTab, _ConfigTasaTabState, _consultando, createState (+9 more)

### Community 94 - "sync_status.dart"
Cohesion: 0.12
Nodes (17): _activos, dispose, error, errorDetail, estado, _hideTimer, iniciar, mensaje (+9 more)

### Community 95 - "inventario_screen.dart"
Cohesion: 0.12
Nodes (17): _buildHeader, _buildProductosDeCategoria, _categoria, createState, dispose, InventarioScreen, _InventarioScreenState, _onScreenKey (+9 more)

### Community 96 - "win32_window.cpp"
Cohesion: 0.18
Nodes (14): Point, Size, wchar_t, Scale(), Create, Destroy, UpdateTheme, Win32Window::Win32Window() (+6 more)

### Community 97 - "O"
Cohesion: 0.12
Nodes (18): $4(), au(), b1(), e0(), f2(), f3(), fg(), giI() (+10 more)

### Community 98 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.13
Nodes (12): app_updater.dart, ../../../core/db/database_provider.dart, historial_repository.dart, toggle, AppUpdater, watch, HistorialRepository, RequisicionesRepository (+4 more)

### Community 99 - "recetas_tab.dart"
Cohesion: 0.13
Nodes (15): ../data/producciones_providers.dart, ../../data/producciones_repository.dart, dialogs/delete_receta_dialog.dart, confirmado, repo, showCancelarProduccionDialog, build, createState (+7 more)

### Community 100 - "temporales_dialog.dart"
Cohesion: 0.13
Nodes (16): ../data/temporales_repository.dart, ../data/validacion_providers.dart, TemporalData, temporalesRepoProvider, _eliminarTemporal, _guardar, build, createState (+8 more)

### Community 101 - "facturas_tab.dart"
Cohesion: 0.13
Nodes (16): dialogs/factura_detalle_dialog.dart, facturasProvider, _abrirDetalle, build, _buildFiltros, createState, dispose, FacturasTab (+8 more)

### Community 102 - "config_habitaciones_tab.dart"
Cohesion: 0.12
Nodes (16): ../dialogs/habitacion_config_dialog.dart, build, _cargando, _cargar, ConfigHabitacionesTab, _ConfigHabitacionesTabState, createState, _editarHabitacion (+8 more)

### Community 103 - "config_mesas_tab.dart"
Cohesion: 0.12
Nodes (16): ../dialogs/mesa_config_dialog.dart, build, _cargando, _cargar, ConfigMesasTab, _ConfigMesasTabState, createState, _editarMesa (+8 more)

### Community 104 - "app_updater.dart"
Cohesion: 0.12
Nodes (16): double get, github_releases_source.dart, _assetName, canRun, checkForUpdate, download, _fileName, fraction (+8 more)

### Community 105 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): FlutterViewController, unique_ptr, DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM (+6 more)

### Community 106 - "log_bridge.dart"
Cohesion: 0.12
Nodes (15): _endpoint, flush, instance, LogBridge, _pending, push, start, _timer (+7 more)

### Community 107 - "temporales_repository.dart"
Cohesion: 0.12
Nodes (16): createdAt, _db, eliminar, fecha, _fromRow, getTemporales, guardar, id (+8 more)

### Community 108 - "pop_in.dart"
Cohesion: 0.13
Nodes (15): AnimationController, CurvedAnimation, Duration, build, child, createState, _ctrl, delay (+7 more)

### Community 109 - "requisiciones/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.12
Nodes (15): ../../data/requisiciones_repository.dart, almacenes, build, esPesable, filtrados, _fmt, m, _MovimientoCard (+7 more)

### Community 110 - "exportar_dialog.dart"
Cohesion: 0.13
Nodes (15): _anioCtrl, build, createState, dispose, _exportando, _ExportarDialog, _ExportarDialogState, _fmtFecha (+7 more)

### Community 111 - "MainActivity"
Cohesion: 0.26
Nodes (8): MainActivity, PackageInstallerReceiver, BroadcastReceiver, Context, FlutterActivity, FlutterEngine, Intent, MethodChannel

### Community 112 - "bool get"
Cohesion: 0.14
Nodes (13): bool get, updaterCanRun, updaterDownloadDir, updaterDownloadFile, updaterInstall, updaterPlatformKey, updaterCanRun, updaterDownloadDir (+5 more)

### Community 113 - "login_screen.dart"
Cohesion: 0.15
Nodes (14): ../../../core/auth/session_controller.dart, ../../../core/updater/auto_update_checker.dart, appDatabaseProvider, build, _confirmCtrl, createState, dispose, _error (+6 more)

### Community 114 - "factura_detalle_dialog.dart"
Cohesion: 0.15
Nodes (14): ../data/historial_providers.dart, Future, historialRepoProvider, FacturaDetalle, _exportar, build, createState, _FacturaDetalleDialog (+6 more)

### Community 115 - "pendientes_tab.dart"
Cohesion: 0.14
Nodes (14): dialogs/cancelar_produccion_dialog.dart, dialogs/descargo_dialog.dart, build, createState, entradas, _future, initState, PendienteCardData (+6 more)

### Community 116 - "config_usuarios_tab.dart"
Cohesion: 0.14
Nodes (14): ../dialogs/nuevo_cajero_dialog.dart, build, _cargando, _cargar, ConfigUsuariosTab, _ConfigUsuariosTabState, createState, initState (+6 more)

### Community 117 - "proveedores_tab.dart"
Cohesion: 0.16
Nodes (13): ../../data/configuracion_providers.dart, ../dialogs/proveedor_dialog.dart, proveedoresConfigProvider, _abrirDialogo, build, _buildHeader, createState, dispose (+5 more)

### Community 118 - "categorias_tab.dart"
Cohesion: 0.16
Nodes (13): ../dialogs/categoria_dialog.dart, categoriasConfigProvider, build, _abrirDialogo, build, CategoriasTab, _CategoriasTabState, createState (+5 more)

### Community 119 - "requisiciones_screen.dart"
Cohesion: 0.15
Nodes (13): _abrir, build, _cerrar, createState, _eliminar, RequisicionesScreen, _RequisicionesScreenState, _vistaActiva (+5 more)

### Community 120 - "Win32Window"
Cohesion: 0.20
Nodes (14): RECT, OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, OnCreate (+6 more)

### Community 121 - "inventarioRepoProvider"
Cohesion: 0.17
Nodes (12): ../../data/inventario_providers.dart, inventarioRepoProvider, ComprasListaItem, _cargarExistencias, build, build, item, ListaCompraItem (+4 more)

### Community 122 - "produccionesRepoProvider"
Cohesion: 0.17
Nodes (13): sessionProvider, _submit, build, _cargarRecetas, _doRegistrar, _MovimientoDialog, _MovimientoDialogState, produccionesRepoProvider (+5 more)

### Community 123 - "contornos_dialog.dart"
Cohesion: 0.17
Nodes (12): build, _confirmar, contornos, _ContornosDialog, _ContornosDialogState, createState, _error, _maxSel (+4 more)

### Community 124 - "historial_tab.dart"
Cohesion: 0.17
Nodes (12): build, createState, entradas, _future, HistorialCardData, HistorialTab, _HistorialTabState, initState (+4 more)

### Community 125 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 126 - "file_logger.dart"
Cohesion: 0.17
Nodes (11): IOSink?, dispose, FileLogger, init, _initialized, instance, log, logToFile (+3 more)

### Community 127 - "update_models.dart"
Cohesion: 0.17
Nodes (11): AppUpdateInfo, assetFor, assets, fromJson, name, _normalizeVersion, releasedAt, size (+3 more)

### Community 128 - "State"
Cohesion: 0.23
Nodes (12): _LoteSelector, _LoteSelectorState, _AnularVentaDialog, _AnularVentaDialogState, EntryCard, _EntryCardState, _StockText, _StockTextState (+4 more)

### Community 129 - "categoria_card.dart"
Cohesion: 0.18
Nodes (11): build, CategoriaCard, _CategoriaCardState, color, createState, nombre, _onEnter, onTap (+3 more)

### Community 130 - "catalogo_card.dart"
Cohesion: 0.18
Nodes (11): badge, build, CatalogoCard, _CatalogoCardState, color, createState, _iniciales, nombre (+3 more)

### Community 131 - "buscador_productos_dialog.dart"
Cohesion: 0.20
Nodes (10): class, build, _BuscadorProductosDialog, _BuscadorProductosDialogState, _buscar, _busqueda, createState, initState (+2 more)

### Community 132 - "agregar_producto_dialog.dart"
Cohesion: 0.18
Nodes (10): ../../../core/sync/sync_service.dart, categoriaId, categorias, codigoCtrl, esPesable, nombreCtrl, precioCtrl, repo (+2 more)

### Community 133 - "DateTime"
Cohesion: 0.25
Nodes (5): DateTime, fetch_bcv_html(), get_bcv_html(), Descarga el HTML del sitio oficial del BCV (misma petición que el scrape del…, WebServer

### Community 134 - "estado_card.dart"
Cohesion: 0.20
Nodes (10): build, color, createState, estado, EstadoCard, _EstadoCardState, info, numero (+2 more)

### Community 135 - "producciones_providers.dart"
Cohesion: 0.18
Nodes (10): historialProduccionesProvider, pendientesProvider, productosActivosProvider, recetasProvider, watch, ProduccionesRepository, build, RecetaEditorScreen (+2 more)

### Community 136 - "web/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 137 - "web_pos/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 138 - "requisicion_card.dart"
Cohesion: 0.20
Nodes (9): ../../data/requisiciones_providers.dart, build, _estadoColor, _fmtFecha, onAuditar, onEditar, onEliminar, onVisualizar (+1 more)

### Community 139 - "requisicionesRepoProvider"
Cohesion: 0.20
Nodes (10): requisicionesRepoProvider, _aceptar, _cargarProducto, _cargarDisponible, _cargar, _onVerify, _showHistorial, _totalizar (+2 more)

### Community 140 - "ia"
Cohesion: 0.20
Nodes (10): aF(), bL(), bU(), e5(), eT(), fI(), gey(), ia() (+2 more)

### Community 141 - "MessageHandler"
Cohesion: 0.36
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetHandle, GetThisFromHandle (+2 more)

### Community 142 - "dart:async"
Cohesion: 0.28
Nodes (7): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, features/pos/presentation/pos_app.dart, main, main

### Community 143 - "printer_service_native.dart"
Cohesion: 0.22
Nodes (8): dart:io, imprimirPorWeb, imprimirTicketNativo, listarImpresoras, nombre, printRawData, puedeImprimirNativo, package:windows_printer/windows_printer.dart

### Community 144 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

### Community 145 - "stock/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.22
Nodes (8): build, esPesable, _fmt, m, _MovimientoCard, showHistorialDialog, _tiposSalida, Set

### Community 146 - "entrada_card.dart"
Cohesion: 0.25
Nodes (7): ../../data/historial_repository.dart, EntradaPorFecha, build, entrada, EntradaCard, _fmtHora, _pesoBadge

### Community 147 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 148 - "whatsapp_providers.dart"
Cohesion: 0.29
Nodes (6): watch, whatsappPendientesProvider, whatsappStatusProvider, WhatsappRepository, _buildHeader, whatsapp_repository.dart

### Community 149 - "../../../../core/utils/web_utils.dart"
Cohesion: 0.33
Nodes (5): ../../../../core/utils/web_utils.dart, imprimirPorWeb, imprimirTicketNativo, listarImpresoras, puedeImprimirNativo

### Community 150 - "validacion_providers.dart"
Cohesion: 0.33
Nodes (5): TemporalesRepository, watch, ValidacionRepository, temporales_repository.dart, validacion_repository.dart

### Community 151 - "ticket_escpos_test.dart"
Cohesion: 0.33
Nodes (5): package:control_entradas_salidas/features/pos/data/pos_comanda_models.dart, package:control_entradas_salidas/features/pos/data/ticket_escpos.dart, header, items, main

### Community 152 - "ConsumerWidget"
Cohesion: 0.40
Nodes (5): ConsumerWidget, AppShell, CategoriasGrid, ProductoCard, RequisicionCard

### Community 153 - "database_provider.dart"
Cohesion: 0.50
Nodes (3): db, return, schema/app_database.dart

## Knowledge Gaps
- **2402 isolated node(s):** `XCTest`, `_db`, `nombre`, `pinHash`, `registrarOperador` (+2397 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **9 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDatabase` connect `AppDatabase` to `app_database.dart`, `inventario_repository.dart`, `historial_repository.dart`, `pos_ventas_repository.dart`, `requisiciones_repository.dart`, `validacion_repository.dart`, `configuracion_repository.dart`, `temporales_repository.dart`, `producciones_repository.dart`, `package:drift/drift.dart`, `pos_repository.dart`, `sync_service.dart`, `whatsapp_repository.dart`, `database_provider.dart`, `sync_engine.dart`, `pos_sync_engine.dart`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **Why does `Producto` connect `DataClass` to `app_database.dart`, `producto_dialog.dart`, `receta_editor_screen.dart`, `buscador_productos_dialog.dart`, `cantidad_dialog.dart`, `productos_tab.dart`, `lista_compra_panel.dart`, `stock_screen.dart`, `movimiento_dialog.dart`?**
  _High betweenness centrality (0.007) - this node is a cross-community bridge._
- **Why does `PosSessionNotifier` connect `pos_home_screen.dart` to `pos_screen.dart`, `comanda_screen.dart`?**
  _High betweenness centrality (0.007) - this node is a cross-community bridge._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web_pos/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._
- **What connects `XCTest`, `_db`, `nombre` to the rest of the system?**
  _2402 weakly-connected nodes found - possible documentation gaps or missing edges._