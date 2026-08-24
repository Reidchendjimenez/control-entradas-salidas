# Graph Report - flutter_app  (2026-08-19)

## Corpus Check
- 213 files · ~257,416 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 5192 nodes · 9819 edges · 175 communities (166 shown, 9 thin omitted)
- Extraction: 93% EXTRACTED · 7% INFERRED · 0% AMBIGUOUS · INFERRED: 656 edges (avg confidence: 0.51)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `5731b0ef`
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
- ../../../../core/db/schema/app_database.dart
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
- descargo_dialog.dart
- package:flutter_riverpod/flutter_riverpod.dart
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
- package:flutter/material.dart
- pos_ventas_repository.dart
- requisiciones_repository.dart
- O
- Table
- a5
- validacion_repository.dart
- configuracion_repository.dart
- habitacion_config_dialog.dart
- config_platos_tab.dart
- aM
- a5
- at
- ajuste_auditoria_dialog.dart
- config_categorias_tab.dart
- plato_config_dialog.dart
- ticket_escpos.dart
- O
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
- ei
- estado_card.dart
- productos_tab.dart
- configuracionRepoProvider
- ka
- validacion_screen.dart
- stock_repository.dart
- categoria_dialog.dart
- State
- AppDelegate
- app_updater.dart
- update_dialog.dart
- ConsumerState
- pos_categoria_dialog.dart
- web_utils_web.dart
- bandeja_screen.dart
- por_fecha_tab.dart
- ka
- entry_card.dart
- sync_status.dart
- inventario_screen.dart
- win32_window.cpp
- pos_home_header.dart
- producto_stock_card.dart
- catalogo_card.dart
- temporales_dialog.dart
- facturas_tab.dart
- config_habitaciones_tab.dart
- config_mesas_tab.dart
- dart:async
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
- stockRepoProvider
- config_usuarios_tab.dart
- proveedores_tab.dart
- categorias_tab.dart
- requisiciones_screen.dart
- Win32Window
- stock/presentation/dialogs/historial_dialog.dart
- produccionesRepoProvider
- contornos_dialog.dart
- sistema_tab.dart
- wWinMain
- file_logger.dart
- update_models.dart
- sync_tables.dart
- categoria_card.dart
- ../../../../core/utils/web_utils.dart
- validacion_providers.dart
- agregar_producto_dialog.dart
- DateTime
- mesasOcupadasProvider
- web/manifest.json
- web_pos/manifest.json
- producciones_screen.dart
- MessageHandler
- printer_service_native.dart
- entrada_pendiente_card.dart
- entrada_card.dart
- app_config.dart
- ticket_escpos_test.dart
- PosHomeScreen
- RegisterPlugins
- app_database.dart
- db_executor_io.dart
- UpdatePermissionException
- LaunchImage.imageset/README.md
- web_utils.dart
- printer_service.dart
- README.md
- String?
- package:drift/drift.dart

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
- `build` --references--> `inventarioRepoProvider`  [EXTRACTED]
  lib/features/inventario/presentation/widgets/lista_compra_item.dart → lib/features/inventario/data/inventario_providers.dart

## Import Cycles
- None detected.

## Communities (175 total, 9 thin omitted)

### Community 0 - "app_database.dart"
Cohesion: 0.01
Nodes (313): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class PlatoIngrediente extends, class PosSyncTombstone extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends (+305 more)

### Community 1 - "web_pos/drift_worker.js"
Cohesion: 0.01
Nodes (80): cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), dl(), e4(), eR() (+72 more)

### Community 2 - "web/drift_worker.js"
Cohesion: 0.01
Nodes (72): cB(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), e4(), eR(), eS() (+64 more)

### Community 3 - "tables.dart"
Cohesion: 0.01
Nodes (140): DateTimeColumn get, IntColumn get, abiertaEn, activo, actualizada, almacen, almacenPredeterminado, anuladaEn (+132 more)

### Community 4 - "a"
Cohesion: 0.05
Nodes (107): $1(), a(), a1(), a4(), aa(), aH(), aR(), aw() (+99 more)

### Community 5 - "a"
Cohesion: 0.05
Nodes (107): $1(), a(), a1(), a4(), aa(), aH(), aR(), aw() (+99 more)

### Community 6 - "comanda_screen.dart"
Cohesion: 0.02
Nodes (115): AnimatedListState, ../../data/printer_service.dart, ../../data/tasa_bcv_service.dart, ../../data/ticket_escpos.dart, ../../data/ticket_settings.dart, dialogs/cobro_dialog.dart, dialogs/contornos_dialog.dart, ../dialogs/ticket_preview_dialog.dart (+107 more)

### Community 7 - "ventas_screen.dart"
Cohesion: 0.03
Nodes (79): calculadora_button.dart, calculadora_dialog.dart, ../../data/pos_comanda_models.dart, _AppDrawer, _AppHeader, _DestinoPage, _NavBarMobile, build (+71 more)

### Community 8 - "r"
Cohesion: 0.05
Nodes (73): $0(), $2(), $3(), $5(), a8(), a9(), ac(), aL() (+65 more)

### Community 9 - "../../../../core/db/schema/app_database.dart"
Cohesion: 0.03
Nodes (67): ../../../../core/db/schema/app_database.dart, estado_card.dart, historial_repository.dart, watch, HistorialRepository, build, _estadoBadge, factura (+59 more)

### Community 10 - "DataClass"
Cohesion: 0.05
Nodes (73): Insertable, UpdateCompanion, Categoria, CategoriasCompanion, ComprasListaCompanion, ComprasListaData, DataClass, DispositivoUsuarioCompanion (+65 more)

### Community 11 - "r"
Cohesion: 0.04
Nodes (75): $0(), $2(), $3(), $5(), a8(), a9(), ac(), aL() (+67 more)

### Community 12 - "pos_screen.dart"
Cohesion: 0.04
Nodes (62): comanda_screen.dart, config_screen.dart, ../../../core/sync/sync_status.dart, ../../../core/theme/app_theme.dart, dart:math, ../../data/pos_providers.dart, dialogs/pin_dialog.dart, habitaciones_screen.dart (+54 more)

### Community 13 - "c"
Cohesion: 0.04
Nodes (75): a2(), aE(), aj(), aX(), aY(), ba(), bg(), bY() (+67 more)

### Community 14 - "N"
Cohesion: 0.06
Nodes (54): aM(), aV(), b6(), bf(), ce(), cU(), D(), d3() (+46 more)

### Community 15 - "producciones_repository.dart"
Cohesion: 0.03
Nodes (59): almacen, almacenProduccionDefault, cancelarProduccion, cantidad, cantidadSugerida, cocineros, ComponenteInfo, contarComponentes (+51 more)

### Community 16 - "c"
Cohesion: 0.05
Nodes (56): a2(), aj(), aX(), aY(), ba(), bg(), bY(), c() (+48 more)

### Community 17 - "pos_home_screen.dart"
Cohesion: 0.05
Nodes (42): ../../../core/sync/global_sync_bar.dart, ../../../core/updater/update_settings_card.dart, ../data/pos_session.dart, PosSesionActiva, PosSessionNotifier, _ActualizacionesTab, build, ConfigScreen (+34 more)

### Community 18 - "N"
Cohesion: 0.10
Nodes (35): ce(), d5(), d6(), eE(), eK(), fm(), gac(), gb9() (+27 more)

### Community 19 - "pos_repository.dart"
Cohesion: 0.04
Nodes (52): abrirSesion, actualizarHabitacion, actualizarMesa, actualizarPlato, actualizarPosCategoria, actualizarUsuario, cerrarSesion, cerrarSesionesStale (+44 more)

### Community 20 - "app_shell.dart"
Cohesion: 0.04
Nodes (52): ../auth/session_controller.dart, class, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/producciones/presentation/producciones_screen.dart, ../../features/requisiciones/presentation/requisiciones_screen.dart (+44 more)

### Community 21 - "stock_screen.dart"
Cohesion: 0.09
Nodes (21): dialogs/existencias_dialog.dart, _almacen, _almacenes, build, _buildFiltros, _buildLista, _buildStats, capitalize (+13 more)

### Community 22 - "i"
Cohesion: 0.06
Nodes (50): a0(), aB(), b0(), b8(), bC(), bI(), bj(), c5() (+42 more)

### Community 23 - "AppDatabase"
Cohesion: 0.06
Nodes (43): _, @DriftDatabase, AppDatabase, openDbExecutor, PosRepository, PosVentasRepository, package:control_entradas_salidas/core/db/database_provider.dart, package:control_entradas_salidas/core/db/schema/app_database.dart (+35 more)

### Community 24 - "descargo_dialog.dart"
Cohesion: 0.06
Nodes (37): actualizar, _actualizarStock, _almacen, almacenDefault, almacenes, build, _buildItemRow, _cant (+29 more)

### Community 25 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.04
Nodes (50): ajuste_dialog.dart, categoria_card.dart, ConsumerWidget, ../../../core/db/database_provider.dart, ../../data/inventario_providers.dart, ../../data/inventario_repository.dart, ../data/stock_repository.dart, inventario_repository.dart (+42 more)

### Community 26 - "sync_engine.dart"
Cohesion: 0.04
Nodes (46): _catalogo, client, _db, def, _deleteMovimientoPorMatch, _deleteRequisicion, _descargarTabla, _downloadAllFromServer (+38 more)

### Community 27 - "updater_platform_io.dart"
Cohesion: 0.05
Nodes (42): 1, _basename, bat, canInstall, _channel, close, _copyContents, create (+34 more)

### Community 28 - "i"
Cohesion: 0.06
Nodes (54): a0(), aB(), ai(), aO(), b0(), b8(), bC(), bI() (+46 more)

### Community 29 - "pos_sync_engine.dart"
Cohesion: 0.05
Nodes (41): _bajarPaginado, client, _coerceIntColumns, _db, _descargarCatalogoVenta, _descargarSettings, _descargarTabla, _downloadAllFromServer (+33 more)

### Community 30 - "aQ"
Cohesion: 0.07
Nodes (42): a3(), ak(), an(), aQ(), b2(), b3(), b4(), b5() (+34 more)

### Community 31 - "movimiento_dialog.dart"
Cohesion: 0.05
Nodes (41): _abrirCalculadora, _almacen, _almacenes, _campoPrincipal, _cantCtrl, _cantFocus, capitalize, _cargar (+33 more)

### Community 32 - "validacion_dialog.dart"
Cohesion: 0.05
Nodes (39): proveedoresProvider, _aplicarPrefijo, _aplicarTemporal, build, _conPrefijo, createState, dispose, _escanearOcr (+31 more)

### Community 33 - "at"
Cohesion: 0.07
Nodes (37): aD(), aE(), aF(), at(), bL(), bt(), bU(), bV() (+29 more)

### Community 34 - "visualizar_view.dart"
Cohesion: 0.06
Nodes (34): build, detalle, _ErrorDetailsDialog, showErrorDetailsDialog, titulo, build, createState, _ctrl (+26 more)

### Community 35 - "receta_editor_screen.dart"
Cohesion: 0.05
Nodes (37): _agregarFilaVacia, _agregarProducto, _baseProducto, _baseSearchCtrl, _buscar, _cancelar, cantidadCtrl, _componentes (+29 more)

### Community 36 - "package:flutter/material.dart"
Cohesion: 0.03
Nodes (73): ../data/producciones_providers.dart, ../../data/producciones_repository.dart, dialogs/cancelar_produccion_dialog.dart, dialogs/delete_receta_dialog.dart, dialogs/descargo_dialog.dart, toggle, build, _imprimirWeb (+65 more)

### Community 37 - "pos_ventas_repository.dart"
Cohesion: 0.05
Nodes (36): anularVenta, aplicarMovimientosVenta, cambiarEstadoComanda, cerrarComanda, _db, eliminarComanda, eliminarVentaYMovimientos, _encolarComanda (+28 more)

### Community 38 - "requisiciones_repository.dart"
Cohesion: 0.05
Nodes (36): _aplicarMoverStock, AuditStock, buscarProductos, cantidad, contarDetalles, crearAjusteStock, _db, destino (+28 more)

### Community 39 - "O"
Cohesion: 0.05
Nodes (57): $4(), a3(), ak(), an(), aQ(), au(), b1(), b2() (+49 more)

### Community 40 - "Table"
Cohesion: 0.06
Nodes (36): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+28 more)

### Community 41 - "a5"
Cohesion: 0.07
Nodes (40): a5(), a6(), a7(), bZ(), c0(), c1(), c2(), d7() (+32 more)

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
Cohesion: 0.08
Nodes (24): ../dialogs/plato_config_dialog.dart, build, _cargando, _cargar, cat, _cats, color, ConfigPlatosTab (+16 more)

### Community 46 - "aM"
Cohesion: 0.11
Nodes (21): aM(), aV(), b6(), bf(), cU(), D(), dB(), dc() (+13 more)

### Community 47 - "a5"
Cohesion: 0.10
Nodes (28): a5(), a6(), a7(), c1(), c2(), d7(), e9(), eQ() (+20 more)

### Community 48 - "at"
Cohesion: 0.06
Nodes (43): aD(), aF(), at(), bL(), bt(), bU(), bV(), bw() (+35 more)

### Community 49 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (29): AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _calcularDesdeTotal, _calcularDesdeUnidades (+21 more)

### Community 50 - "config_categorias_tab.dart"
Cohesion: 0.07
Nodes (27): ../dialogs/pos_categoria_dialog.dart, ../dialogs/subcategoria_dialog.dart, activo, build, _cargando, color, ConfigCategoriasTab, _ConfigCategoriasTabState (+19 more)

### Community 51 - "plato_config_dialog.dart"
Cohesion: 0.07
Nodes (28): ../../../../features/inventario/data/inventario_providers.dart, build, cantidadCtrl, _cargando, _categoriaId, _categorias, createState, dispose (+20 more)

### Community 52 - "ticket_escpos.dart"
Cohesion: 0.07
Nodes (28): add, _centrar, cmd, construirTicketEscpos, construirTicketPreview, copyWith, _derecha, direccion (+20 more)

### Community 53 - "O"
Cohesion: 0.13
Nodes (16): $4(), au(), b1(), e0(), f2(), f3(), giI(), ha() (+8 more)

### Community 54 - "sync_service.dart"
Cohesion: 0.08
Nodes (27): ../db/database_provider.dart, ../db/schema/app_database.dart, Authenticated, cerrarSesion, _db, nombre, pinHash, registrarOperador (+19 more)

### Community 55 - "ticket_settings.dart"
Cohesion: 0.07
Nodes (27): cargarMembrete, direccion, getCorrelativoActual, getHeaderSize, getPrinterDevice, getSetting, guardarMembrete, kComandaCorrelativo (+19 more)

### Community 56 - "whatsapp_repository.dart"
Cohesion: 0.07
Nodes (27): botUrl, countPending, _db, eliminar, _enviarDesdeCola, enviarImagen, _enviarImagenDirecto, enviarMensaje (+19 more)

### Community 57 - "tasa_bcv_service.dart"
Cohesion: 0.08
Nodes (23): Client, dart:convert, AppColors, dark, light, of, _bcvFallbackUrl, _bcvSiteUrl (+15 more)

### Community 58 - "pos_providers.dart"
Cohesion: 0.14
Nodes (13): ../../../core/sync/pos_sync_engine.dart, client, comandasAbiertasProvider, engine, platosProvider, ref, ultimaVentaVigenteProvider, ventasProvider (+5 more)

### Community 59 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, FlView, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins() (+14 more)

### Community 60 - "dF"
Cohesion: 0.09
Nodes (26): aG(), c8(), cD(), cV(), d9(), dF(), dH(), ed() (+18 more)

### Community 61 - "form_view.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/buscador_productos_dialog.dart, ../dialogs/cantidad_dialog.dart, _agregarProducto, _almacenes, _almacenesCard, build, _cargado, createState (+17 more)

### Community 62 - "productos_panel.dart"
Cohesion: 0.08
Nodes (25): ../dialogs/movimiento_dialog.dart, abrirSeleccion, build, categoriaId, createState, didUpdateWidget, dispose, initState (+17 more)

### Community 63 - "calculadora_dialog.dart"
Cohesion: 0.07
Nodes (27): build, _buildKeypad, _CalculadoraDialog, _CalculadoraDialogState, _compute, createState, _display, _fmt (+19 more)

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
Cohesion: 0.07
Nodes (33): ../dialogs/ajuste_auditoria_dialog.dart, dialogs/historial_dialog.dart, requisicionesRepoProvider, _aceptar, _cargarProducto, _cargarDisponible, AuditView, _AuditViewState (+25 more)

### Community 72 - "update_settings_card.dart"
Cohesion: 0.09
Nodes (23): app_updater.dart, AppUpdater, AutoUpdateChecker, _AutoUpdateCheckerState, build, _checkear, _chequeado, createState (+15 more)

### Community 73 - "pos_comanda_models.dart"
Cohesion: 0.09
Nodes (22): cantidad, ComandaItem, dec, decimales, _encode, entero, formatearBs, formatearTasa (+14 more)

### Community 74 - "pagos_panel.dart"
Cohesion: 0.09
Nodes (22): _abrirPanel, _agregarBoton, _agregarPago, build, createState, dispose, _divisasMonto, _divisasTasa (+14 more)

### Community 75 - "ei"
Cohesion: 0.18
Nodes (14): aG(), c8(), cD(), d9(), ed(), ei(), eu(), f8() (+6 more)

### Community 76 - "estado_card.dart"
Cohesion: 0.10
Nodes (18): Color, IconData, build, color, createState, estado, info, numero (+10 more)

### Community 77 - "productos_tab.dart"
Cohesion: 0.08
Nodes (29): ColorScheme, configuracion_repository.dart, ../dialogs/producto_dialog.dart, almacenesConfigProvider, categoriasConfigProvider, periodosConfigProvider, productosConfigProvider, watch (+21 more)

### Community 78 - "configuracionRepoProvider"
Cohesion: 0.13
Nodes (20): configuracionRepoProvider, _aperturando, _aperturarPeriodo, build, createState, _forzando, _forzarArchivo, _periodoActual (+12 more)

### Community 79 - "ka"
Cohesion: 0.08
Nodes (29): ai(), aO(), bx(), cw(), d1(), d2(), dr(), ds() (+21 more)

### Community 80 - "validacion_screen.dart"
Cohesion: 0.11
Nodes (20): dialogs/precargar_imagen_dialog.dart, dialogs/temporales_dialog.dart, dialogs/validacion_dialog.dart, temporalesProvider, validacionRepoProvider, _seccionTemporalesGuardados, _onTipoDocumento, _validar (+12 more)

### Community 81 - "stock_repository.dart"
Cohesion: 0.12
Nodes (15): agotado, ajustarExistencia, bajo, _db, filterProductos, getAlmacenes, getExistenciasMap, getExistenciasProducto (+7 more)

### Community 82 - "categoria_dialog.dart"
Cohesion: 0.10
Nodes (20): _activo, build, categoria, _CategoriaDialog, _CategoriaDialogState, _colorCtrl, _ColorPickerButton, controller (+12 more)

### Community 83 - "State"
Cohesion: 0.20
Nodes (14): _LoteSelector, _LoteSelectorState, _AnularVentaDialog, _AnularVentaDialogState, CatalogoCard, _CatalogoCardState, EstadoCard, _EstadoCardState (+6 more)

### Community 84 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 85 - "app_updater.dart"
Cohesion: 0.06
Nodes (34): ../config/app_config.dart, double get, github_releases_source.dart, initialize, initializeSupabase, supabaseProvider, _assetName, canRun (+26 more)

### Community 86 - "update_dialog.dart"
Cohesion: 0.11
Nodes (19): _actualizar, build, _cargarVersion, createState, _descargando, _error, info, initState (+11 more)

### Community 87 - "ConsumerState"
Cohesion: 0.05
Nodes (40): ConsumerState, ConsumerStatefulWidget, build, _contactoCtrl, createState, _direccionCtrl, dispose, _emailCtrl (+32 more)

### Community 88 - "pos_categoria_dialog.dart"
Cohesion: 0.11
Nodes (19): build, categoria, _color, _colores, createState, dispose, _esEdicion, false (+11 more)

### Community 89 - "web_utils_web.dart"
Cohesion: 0.11
Nodes (17): dart:html, dart:typed_data, openInNewTab, PasteCancel, printHtml, reloadApp, setupPasteImageListener, contenedor (+9 more)

### Community 90 - "bandeja_screen.dart"
Cohesion: 0.11
Nodes (24): ../data/whatsapp_providers.dart, bandejaProvider, watch, whatsappPendientesProvider, whatsappRepoProvider, whatsappStatusProvider, WhatsappRepository, BandejaScreen (+16 more)

### Community 91 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 92 - "ka"
Cohesion: 0.14
Nodes (19): cw(), d1(), d2(), dr(), ds(), dY(), eX(), eY() (+11 more)

### Community 93 - "entry_card.dart"
Cohesion: 0.17
Nodes (12): badge, build, color, createState, EntryCard, _EntryCardState, icon, onTap (+4 more)

### Community 94 - "sync_status.dart"
Cohesion: 0.12
Nodes (17): _activos, dispose, error, errorDetail, estado, _hideTimer, iniciar, mensaje (+9 more)

### Community 95 - "inventario_screen.dart"
Cohesion: 0.09
Nodes (23): inventarioRepoProvider, _cargarExistencias, build, _buildHeader, _buildProductosDeCategoria, _categoria, createState, dispose (+15 more)

### Community 96 - "win32_window.cpp"
Cohesion: 0.18
Nodes (14): Point, Size, wchar_t, Scale(), Create, Destroy, UpdateTheme, Win32Window::Win32Window() (+6 more)

### Community 97 - "pos_home_header.dart"
Cohesion: 0.15
Nodes (12): double?, build, cargando, cargandoTasa, _fechaLarga, h, _meses, nombre (+4 more)

### Community 98 - "producto_stock_card.dart"
Cohesion: 0.20
Nodes (9): ../../data/stock_providers.dart, capitalize, categorias, _colorPara, _esPesable, _fmt, producto, _StringCapitalize (+1 more)

### Community 99 - "catalogo_card.dart"
Cohesion: 0.20
Nodes (9): badge, build, color, createState, _iniciales, nombre, onTap, _presionada (+1 more)

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

### Community 104 - "dart:async"
Cohesion: 0.28
Nodes (7): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, features/pos/presentation/pos_app.dart, main, main

### Community 105 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): FlutterViewController, unique_ptr, DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM (+6 more)

### Community 106 - "log_bridge.dart"
Cohesion: 0.11
Nodes (16): _endpoint, flush, instance, LogBridge, _pending, push, start, _timer (+8 more)

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
Cohesion: 0.09
Nodes (22): ../../../core/auth/session_controller.dart, ../../../core/updater/auto_update_checker.dart, sessionProvider, appDatabaseProvider, db, AppShell, build, _confirmCtrl (+14 more)

### Community 114 - "factura_detalle_dialog.dart"
Cohesion: 0.15
Nodes (14): ../data/historial_providers.dart, Future, historialRepoProvider, FacturaDetalle, _exportar, build, createState, _FacturaDetalleDialog (+6 more)

### Community 115 - "stockRepoProvider"
Cohesion: 0.22
Nodes (9): stockRepoProvider, _cargarFiltros, _reload, StockScreen, _StockScreenState, _verExistencias, _verHistorial, build (+1 more)

### Community 116 - "config_usuarios_tab.dart"
Cohesion: 0.14
Nodes (14): ../dialogs/nuevo_cajero_dialog.dart, build, _cargando, _cargar, ConfigUsuariosTab, _ConfigUsuariosTabState, createState, initState (+6 more)

### Community 117 - "proveedores_tab.dart"
Cohesion: 0.18
Nodes (12): ../dialogs/proveedor_dialog.dart, proveedoresConfigProvider, _abrirDialogo, build, _buildHeader, createState, dispose, _eliminar (+4 more)

### Community 118 - "categorias_tab.dart"
Cohesion: 0.18
Nodes (11): ../../data/configuracion_providers.dart, ../dialogs/categoria_dialog.dart, _abrirDialogo, CategoriasTab, _CategoriasTabState, createState, dispose, _eliminar (+3 more)

### Community 119 - "requisiciones_screen.dart"
Cohesion: 0.06
Nodes (31): ../../data/requisiciones_providers.dart, build, _BuscadorProductosDialog, _BuscadorProductosDialogState, _buscar, _busqueda, createState, initState (+23 more)

### Community 120 - "Win32Window"
Cohesion: 0.20
Nodes (14): RECT, OnCreate, OnDestroy, HWND, Win32Window, child_content_, GetClientArea, OnCreate (+6 more)

### Community 121 - "stock/presentation/dialogs/historial_dialog.dart"
Cohesion: 0.22
Nodes (8): build, esPesable, _fmt, m, _MovimientoCard, showHistorialDialog, _tiposSalida, Set

### Community 122 - "produccionesRepoProvider"
Cohesion: 0.12
Nodes (17): build, _cargarRecetas, historialProduccionesProvider, pendientesProvider, produccionesRepoProvider, productosActivosProvider, recetasProvider, watch (+9 more)

### Community 123 - "contornos_dialog.dart"
Cohesion: 0.17
Nodes (12): build, _confirmar, contornos, _ContornosDialog, _ContornosDialogState, createState, _error, _maxSel (+4 more)

### Community 124 - "sistema_tab.dart"
Cohesion: 0.10
Nodes (25): ../../../../core/state/theme_controller.dart, ../../data/configuracion_repository.dart, themeControllerProvider, syncEngineProvider, almacenProduccionDefaultProvider, permitirStockNegativoProvider, usuarioDispositivoProvider, _guardar (+17 more)

### Community 125 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 126 - "file_logger.dart"
Cohesion: 0.17
Nodes (11): IOSink?, dispose, FileLogger, init, _initialized, instance, log, logToFile (+3 more)

### Community 127 - "update_models.dart"
Cohesion: 0.17
Nodes (11): AppUpdateInfo, assetFor, assets, fromJson, name, _normalizeVersion, releasedAt, size (+3 more)

### Community 128 - "sync_tables.dart"
Cohesion: 0.25
Nodes (7): dedupeKey, incrementalById, incrementalColumn, localTable, serverTable, syncedTables, SyncTableDescriptor

### Community 129 - "categoria_card.dart"
Cohesion: 0.18
Nodes (11): build, CategoriaCard, _CategoriaCardState, color, createState, nombre, _onEnter, onTap (+3 more)

### Community 130 - "../../../../core/utils/web_utils.dart"
Cohesion: 0.33
Nodes (5): ../../../../core/utils/web_utils.dart, imprimirPorWeb, imprimirTicketNativo, listarImpresoras, puedeImprimirNativo

### Community 131 - "validacion_providers.dart"
Cohesion: 0.33
Nodes (5): TemporalesRepository, watch, ValidacionRepository, temporales_repository.dart, validacion_repository.dart

### Community 132 - "agregar_producto_dialog.dart"
Cohesion: 0.18
Nodes (10): ../../../core/sync/sync_service.dart, categoriaId, categorias, codigoCtrl, esPesable, nombreCtrl, precioCtrl, repo (+2 more)

### Community 133 - "DateTime"
Cohesion: 0.25
Nodes (5): DateTime, fetch_bcv_html(), get_bcv_html(), Descarga el HTML del sitio oficial del BCV (misma petición que el scrape del…, WebServer

### Community 134 - "mesasOcupadasProvider"
Cohesion: 0.67
Nodes (4): mesasOcupadasProvider, mesasProvider, build, MesasScreen

### Community 136 - "web/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 137 - "web_pos/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 139 - "producciones_screen.dart"
Cohesion: 0.05
Nodes (42): dialogs/exportar_dialog.dart, facturas_tab.dart, historial_tab.dart, build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose (+34 more)

### Community 141 - "MessageHandler"
Cohesion: 0.36
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetHandle, GetThisFromHandle (+2 more)

### Community 143 - "printer_service_native.dart"
Cohesion: 0.22
Nodes (8): dart:io, imprimirPorWeb, imprimirTicketNativo, listarImpresoras, nombre, printRawData, puedeImprimirNativo, package:windows_printer/windows_printer.dart

### Community 144 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

### Community 146 - "entrada_card.dart"
Cohesion: 0.25
Nodes (7): ../../data/historial_repository.dart, EntradaPorFecha, build, entrada, EntradaCard, _fmtHora, _pesoBadge

### Community 147 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 151 - "ticket_escpos_test.dart"
Cohesion: 0.33
Nodes (5): package:control_entradas_salidas/features/pos/data/pos_comanda_models.dart, package:control_entradas_salidas/features/pos/data/ticket_escpos.dart, header, items, main

### Community 152 - "PosHomeScreen"
Cohesion: 0.33
Nodes (9): comandasActivasProvider, habitacionesOcupadasProvider, habitacionesProvider, tasaCambioProvider, ventasHoyProvider, build, HabitacionesScreen, build (+1 more)

### Community 185 - "package:drift/drift.dart"
Cohesion: 0.40
Nodes (4): driftDatabase, openDbExecutor, package:drift/drift.dart, package:drift_flutter/drift_flutter.dart

## Knowledge Gaps
- **2412 isolated node(s):** `XCTest`, `_db`, `nombre`, `pinHash`, `registrarOperador` (+2407 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **9 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDatabase` connect `AppDatabase` to `app_database.dart`, `inventario_repository.dart`, `historial_repository.dart`, `pos_ventas_repository.dart`, `requisiciones_repository.dart`, `validacion_repository.dart`, `configuracion_repository.dart`, `temporales_repository.dart`, `producciones_repository.dart`, `login_screen.dart`, `stock_repository.dart`, `pos_repository.dart`, `sync_service.dart`, `whatsapp_repository.dart`, `sync_engine.dart`, `pos_sync_engine.dart`?**
  _High betweenness centrality (0.023) - this node is a cross-community bridge._
- **Why does `Producto` connect `DataClass` to `app_database.dart`, `producto_dialog.dart`, `producto_stock_card.dart`, `receta_editor_screen.dart`, `cantidad_dialog.dart`, `productos_tab.dart`, `requisiciones_screen.dart`, `package:flutter_riverpod/flutter_riverpod.dart`, `movimiento_dialog.dart`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Why does `posRepoProvider` connect `comanda_screen.dart` to `subcategoria_dialog.dart`, `config_habitaciones_tab.dart`, `config_mesas_tab.dart`, `pos_screen.dart`, `habitacion_config_dialog.dart`, `config_platos_tab.dart`, `pos_home_screen.dart`, `config_categorias_tab.dart`, `plato_config_dialog.dart`, `config_usuarios_tab.dart`, `ConsumerState`, `pos_categoria_dialog.dart`, `pos_providers.dart`, `inventario_screen.dart`?**
  _High betweenness centrality (0.004) - this node is a cross-community bridge._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web_pos/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._
- **What connects `XCTest`, `_db`, `nombre` to the rest of the system?**
  _2412 weakly-connected nodes found - possible documentation gaps or missing edges._