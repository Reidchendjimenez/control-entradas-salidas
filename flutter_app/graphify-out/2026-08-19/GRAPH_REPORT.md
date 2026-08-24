# Graph Report - flutter_app  (2026-08-18)

## Corpus Check
- 213 files · ~257,122 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 5188 nodes · 9808 edges · 187 communities (177 shown, 10 thin omitted)
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
- descargo_dialog.dart
- package:flutter_riverpod/flutter_riverpod.dart
- sync_engine.dart
- updater_platform_io.dart
- b8
- pos_sync_engine.dart
- O
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
- a7
- validacion_repository.dart
- configuracion_repository.dart
- mesa_config_dialog.dart
- config_platos_tab.dart
- configuracion_providers.dart
- a5
- at
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
- ei
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
- calculadora_button.dart
- productos_tab.dart
- sistema_tab.dart
- ka
- validacion_screen.dart
- stock_repository.dart
- categoria_dialog.dart
- a3
- AppDelegate
- app_updater.dart
- update_dialog.dart
- proveedor_dialog.dart
- pos_categoria_dialog.dart
- web_utils_web.dart
- bandeja_screen.dart
- por_fecha_tab.dart
- ka
- posRepoProvider
- sync_status.dart
- inventario_screen.dart
- win32_window.cpp
- pos_home_header.dart
- requisiciones_sync_test.dart
- ConsumerState
- temporales_dialog.dart
- facturas_tab.dart
- config_habitaciones_tab.dart
- config_mesas_tab.dart
- config_impresora_tab.dart
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
- $0
- config_usuarios_tab.dart
- proveedores_tab.dart
- categorias_tab.dart
- requisiciones_screen.dart
- Win32Window
- inventarioRepoProvider
- produccionesRepoProvider
- contornos_dialog.dart
- syncEngineProvider
- wWinMain
- file_logger.dart
- update_models.dart
- bg
- categoria_card.dart
- habitacion_config_dialog.dart
- buscador_productos_dialog.dart
- agregar_producto_dialog.dart
- DateTime
- pos_session.dart
- ../../data/pos_providers.dart
- web/manifest.json
- web_pos/manifest.json
- requisicion_card.dart
- historial_screen.dart
- ja
- MessageHandler
- configuracion_screen.dart
- db_executor_io.dart
- entrada_pendiente_card.dart
- pin_dialog.dart
- entrada_card.dart
- app_config.dart
- receta_card.dart
- existencias_dialog.dart
- auto_update_checker.dart
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
- ajuste_dialog.dart
- package:flutter/services.dart
- package:drift/drift.dart
- updater_providers.dart

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

## Communities (187 total, 10 thin omitted)

### Community 0 - "app_database.dart"
Cohesion: 0.01
Nodes (313): class ComprasListaData extends, class DispositivoUsuarioData extends, class MovimientosArchivoData extends, class PlatoIngrediente extends, class PosSyncTombstone extends, class ProduccionDetalle extends, class RecetaComponente extends, class RequisicionDetalle extends (+305 more)

### Community 1 - "web_pos/drift_worker.js"
Cohesion: 0.01
Nodes (78): c3(), convertAllToFastObject(), convertToFastObject(), copyProperties(), cS(), dB(), dc(), e4() (+70 more)

### Community 2 - "web/drift_worker.js"
Cohesion: 0.01
Nodes (76): bs(), convertAllToFastObject(), convertToFastObject(), copyProperties(), dB(), dc(), e4(), eW() (+68 more)

### Community 3 - "tables.dart"
Cohesion: 0.01
Nodes (140): DateTimeColumn get, IntColumn get, abiertaEn, activo, actualizada, almacen, almacenPredeterminado, anuladaEn (+132 more)

### Community 4 - "a"
Cohesion: 0.05
Nodes (109): $1(), $2(), a(), a1(), a4(), a9(), aa(), aH() (+101 more)

### Community 5 - "a"
Cohesion: 0.05
Nodes (110): $1(), a(), a1(), a4(), aa(), aH(), aR(), aw() (+102 more)

### Community 6 - "comanda_screen.dart"
Cohesion: 0.04
Nodes (59): AnimatedListState, dialogs/cobro_dialog.dart, dialogs/contornos_dialog.dart, posVentasRepoProvider, _agregarItem, _agregarItemConContornos, _aTicketItem, badge (+51 more)

### Community 7 - "ventas_screen.dart"
Cohesion: 0.04
Nodes (50): _AppDrawer, _AppHeader, _DestinoPage, _NavBarMobile, _StockInfoPanel, _anularUltima, _Badge, _bordeId (+42 more)

### Community 8 - "r"
Cohesion: 0.05
Nodes (59): $3(), $5(), ac(), az(), bB(), bd(), bP(), c3() (+51 more)

### Community 9 - "package:flutter/material.dart"
Cohesion: 0.04
Nodes (47): estado_card.dart, build, _estadoBadge, factura, FacturaCard, _fmtFecha, onTap, build (+39 more)

### Community 10 - "DataClass"
Cohesion: 0.05
Nodes (73): Insertable, UpdateCompanion, Categoria, CategoriasCompanion, ComprasListaCompanion, ComprasListaData, DataClass, DispositivoUsuarioCompanion (+65 more)

### Community 11 - "r"
Cohesion: 0.05
Nodes (68): $0(), $2(), $3(), $5(), a8(), a9(), ac(), aL() (+60 more)

### Community 12 - "pos_screen.dart"
Cohesion: 0.06
Nodes (38): comanda_screen.dart, config_screen.dart, dialogs/pin_dialog.dart, habitaciones_screen.dart, turnoActivoUsuarioProvider, usuariosProvider, posSessionProvider, didChangeAppLifecycleState (+30 more)

### Community 13 - "c"
Cohesion: 0.05
Nodes (59): a2(), aP(), aX(), aY(), ba(), bg(), bY(), c() (+51 more)

### Community 14 - "N"
Cohesion: 0.06
Nodes (56): aM(), aV(), b6(), bf(), ce(), cU(), D(), d3() (+48 more)

### Community 15 - "producciones_repository.dart"
Cohesion: 0.03
Nodes (59): almacen, almacenProduccionDefault, cancelarProduccion, cantidad, cantidadSugerida, cocineros, ComponenteInfo, contarComponentes (+51 more)

### Community 16 - "c"
Cohesion: 0.04
Nodes (68): a5(), aD(), aE(), aG(), aj(), ba(), bL(), c() (+60 more)

### Community 17 - "pos_home_screen.dart"
Cohesion: 0.05
Nodes (46): ../../../core/sync/global_sync_bar.dart, ../../../core/sync/sync_status.dart, ../../../core/theme/app_theme.dart, ../../../core/updater/update_settings_card.dart, dart:math, ../data/pos_session.dart, _ActualizacionesTab, build (+38 more)

### Community 18 - "N"
Cohesion: 0.05
Nodes (59): a3(), ai(), aM(), aV(), b6(), bf(), ce(), cU() (+51 more)

### Community 19 - "pos_repository.dart"
Cohesion: 0.04
Nodes (52): abrirSesion, actualizarHabitacion, actualizarMesa, actualizarPlato, actualizarPosCategoria, actualizarUsuario, cerrarSesion, cerrarSesionesStale (+44 more)

### Community 20 - "app_shell.dart"
Cohesion: 0.05
Nodes (37): ../auth/session_controller.dart, ../../features/auth/presentation/login_screen.dart, ../../features/configuracion/presentation/configuracion_screen.dart, ../../features/historial/presentation/historial_screen.dart, ../../features/inventario/presentation/inventario_screen.dart, ../../features/producciones/presentation/producciones_screen.dart, ../../features/requisiciones/presentation/requisiciones_screen.dart, ../../features/stock/presentation/stock_screen.dart (+29 more)

### Community 21 - "stock_screen.dart"
Cohesion: 0.05
Nodes (44): ../../data/stock_providers.dart, dialogs/existencias_dialog.dart, stockRepoProvider, _almacen, _almacenes, build, _buildFiltros, _buildLista (+36 more)

### Community 22 - "i"
Cohesion: 0.09
Nodes (36): aB(), b0(), b8(), bI(), bj(), c5(), ch(), cT() (+28 more)

### Community 23 - "AppDatabase"
Cohesion: 0.07
Nodes (35): _, @DriftDatabase, AppDatabase, PosRepository, PosVentasRepository, package:control_entradas_salidas/core/db/database_provider.dart, package:control_entradas_salidas/core/db/schema/app_database.dart, package:control_entradas_salidas/core/router/app_shell.dart (+27 more)

### Community 24 - "descargo_dialog.dart"
Cohesion: 0.06
Nodes (37): actualizar, _actualizarStock, _almacen, almacenDefault, almacenes, build, _buildItemRow, _cant (+29 more)

### Community 25 - "package:flutter_riverpod/flutter_riverpod.dart"
Cohesion: 0.03
Nodes (62): categoria_card.dart, ../../../../core/db/schema/app_database.dart, ../data/producciones_providers.dart, ../../data/producciones_repository.dart, dialogs/cancelar_produccion_dialog.dart, dialogs/delete_receta_dialog.dart, dialogs/descargo_dialog.dart, historial_repository.dart (+54 more)

### Community 26 - "sync_engine.dart"
Cohesion: 0.04
Nodes (46): _catalogo, client, _db, def, _deleteMovimientoPorMatch, _deleteRequisicion, _descargarTabla, _downloadAllFromServer (+38 more)

### Community 27 - "updater_platform_io.dart"
Cohesion: 0.05
Nodes (42): 1, _basename, bat, canInstall, _channel, close, _copyContents, create (+34 more)

### Community 28 - "b8"
Cohesion: 0.12
Nodes (25): aB(), b0(), b8(), bI(), bj(), c5(), cT(), dT() (+17 more)

### Community 29 - "pos_sync_engine.dart"
Cohesion: 0.05
Nodes (41): _bajarPaginado, client, _coerceIntColumns, _db, _descargarCatalogoVenta, _descargarSettings, _descargarTabla, _downloadAllFromServer (+33 more)

### Community 30 - "O"
Cohesion: 0.08
Nodes (39): $4(), ak(), aQ(), au(), b1(), b2(), b3(), b4() (+31 more)

### Community 31 - "movimiento_dialog.dart"
Cohesion: 0.05
Nodes (41): _abrirCalculadora, _almacen, _almacenes, _campoPrincipal, _cantCtrl, _cantFocus, capitalize, _cargar (+33 more)

### Community 32 - "validacion_dialog.dart"
Cohesion: 0.05
Nodes (39): proveedoresProvider, _aplicarPrefijo, _aplicarTemporal, build, _conPrefijo, createState, dispose, _escanearOcr (+31 more)

### Community 33 - "at"
Cohesion: 0.06
Nodes (38): a0(), at(), bt(), bw(), bZ(), c0(), cB(), dl() (+30 more)

### Community 34 - "visualizar_view.dart"
Cohesion: 0.09
Nodes (21): ../../../../core/utils/web_utils.dart, imprimirPorWeb, imprimirTicketNativo, listarImpresoras, puedeImprimirNativo, build, _cargando, _cargar (+13 more)

### Community 35 - "receta_editor_screen.dart"
Cohesion: 0.05
Nodes (41): productosActivosProvider, _agregarFilaVacia, _agregarProducto, _baseProducto, _baseSearchCtrl, build, _buscar, _cancelar (+33 more)

### Community 36 - "List"
Cohesion: 0.04
Nodes (43): dedupeKey, incrementalById, incrementalColumn, localTable, serverTable, syncedTables, SyncTableDescriptor, build (+35 more)

### Community 37 - "pos_ventas_repository.dart"
Cohesion: 0.05
Nodes (36): anularVenta, aplicarMovimientosVenta, cambiarEstadoComanda, cerrarComanda, _db, eliminarComanda, eliminarVentaYMovimientos, _encolarComanda (+28 more)

### Community 38 - "requisiciones_repository.dart"
Cohesion: 0.05
Nodes (36): _aplicarMoverStock, AuditStock, buscarProductos, cantidad, contarDetalles, crearAjusteStock, _db, destino (+28 more)

### Community 39 - "O"
Cohesion: 0.07
Nodes (43): $4(), ak(), aQ(), au(), b1(), b2(), b3(), b4() (+35 more)

### Community 40 - "Table"
Cohesion: 0.06
Nodes (36): Categorias, ComprasLista, DispositivoUsuario, Existencias, FacturaPagos, Facturas, Movimientos, MovimientosArchivo (+28 more)

### Community 41 - "a7"
Cohesion: 0.08
Nodes (31): a6(), a7(), bV(), c1(), c2(), cV(), d7(), e9() (+23 more)

### Community 42 - "validacion_repository.dart"
Cohesion: 0.06
Nodes (34): ../../../core/sync/sync_engine.dart, almacen, buscarProveedor, cantidad, cantidadAnterior, cantidadNueva, crearProveedor, _db (+26 more)

### Community 43 - "configuracion_repository.dart"
Cohesion: 0.06
Nodes (34): archivarEnSupabase, clearCheckpoints, crearPeriodo, crearUsuarioDispositivo, createCategoria, createProducto, createProveedor, _db (+26 more)

### Community 44 - "mesa_config_dialog.dart"
Cohesion: 0.12
Nodes (17): build, createState, dispose, _esEdicion, false, _guardando, _guardar, initState (+9 more)

### Community 45 - "config_platos_tab.dart"
Cohesion: 0.09
Nodes (22): ../dialogs/plato_config_dialog.dart, build, _cargando, _cargar, cat, _cats, color, createState (+14 more)

### Community 46 - "configuracion_providers.dart"
Cohesion: 0.27
Nodes (11): configuracion_repository.dart, themeControllerProvider, almacenesConfigProvider, almacenProduccionDefaultProvider, periodosConfigProvider, permitirStockNegativoProvider, usuarioDispositivoProvider, watch (+3 more)

### Community 47 - "a5"
Cohesion: 0.08
Nodes (34): a5(), a6(), a7(), aj(), c1(), c2(), cP(), d7() (+26 more)

### Community 48 - "at"
Cohesion: 0.07
Nodes (34): a0(), at(), bt(), bZ(), c0(), cB(), cR(), dl() (+26 more)

### Community 49 - "ajuste_auditoria_dialog.dart"
Cohesion: 0.07
Nodes (29): AuditItem, _AjusteDialog, _AjusteDialogState, AjusteStockResult, almacen, build, _calcularDesdeTotal, _calcularDesdeUnidades (+21 more)

### Community 50 - "config_categorias_tab.dart"
Cohesion: 0.07
Nodes (26): ../dialogs/pos_categoria_dialog.dart, ../dialogs/subcategoria_dialog.dart, activo, build, _cargando, color, createState, _editarPosCategoria (+18 more)

### Community 51 - "plato_config_dialog.dart"
Cohesion: 0.07
Nodes (28): ../../../../features/inventario/data/inventario_providers.dart, build, cantidadCtrl, _cargando, _categoriaId, _categorias, createState, dispose (+20 more)

### Community 52 - "ticket_escpos.dart"
Cohesion: 0.07
Nodes (28): add, _centrar, cmd, construirTicketEscpos, construirTicketPreview, copyWith, _derecha, direccion (+20 more)

### Community 53 - "lista_compra_panel.dart"
Cohesion: 0.20
Nodes (10): build, _CategoriaGroup, createState, group, ListaCompraPanel, _ListaCompraPanelState, onClose, _parseColor (+2 more)

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
Cohesion: 0.06
Nodes (29): Client, dart:convert, AppColors, dark, light, of, _bcvFallbackUrl, _bcvSiteUrl (+21 more)

### Community 58 - "pos_providers.dart"
Cohesion: 0.14
Nodes (13): ../../../core/sync/pos_sync_engine.dart, client, comandasAbiertasProvider, engine, platosProvider, ref, ultimaVentaVigenteProvider, ventasProvider (+5 more)

### Community 59 - "my_application.cc"
Cohesion: 0.09
Nodes (22): FlPluginRegistry, FlView, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins() (+14 more)

### Community 60 - "ei"
Cohesion: 0.31
Nodes (9): c8(), d9(), ed(), ei(), eu(), gbi(), hi(), hj() (+1 more)

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
Nodes (28): ../../data/ocr_service.dart, temporalesRepoProvider, build, _conPrefijo, createState, dispose, _eliminarTemporal, _extrayendo (+20 more)

### Community 68 - "historial_repository.dart"
Cohesion: 0.08
Nodes (25): archivado, cantidad, countFacturas, _db, divisasUsd, efectivo, esPesable, factura (+17 more)

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
Cohesion: 0.16
Nodes (14): _checkear, build, _buscando, _buscar, _cargarVersion, createState, _error, initState (+6 more)

### Community 73 - "pos_comanda_models.dart"
Cohesion: 0.09
Nodes (22): cantidad, ComandaItem, dec, decimales, _encode, entero, formatearBs, formatearTasa (+14 more)

### Community 74 - "pagos_panel.dart"
Cohesion: 0.08
Nodes (24): _abrirPanel, _agregarBoton, _agregarPago, build, createState, dispose, _divisasMonto, _divisasTasa (+16 more)

### Community 75 - "dF"
Cohesion: 0.09
Nodes (25): aG(), c8(), cD(), cV(), d9(), dF(), ed(), ei() (+17 more)

### Community 76 - "calculadora_button.dart"
Cohesion: 0.09
Nodes (20): calculadora_button.dart, calculadora_dialog.dart, IconData, build, CalculadoraButton, CalculadoraSuffixIcon, _defaultFormat, icon (+12 more)

### Community 77 - "productos_tab.dart"
Cohesion: 0.10
Nodes (21): ColorScheme, ../dialogs/producto_dialog.dart, productosConfigProvider, _almacen, build, _buildHeader, categoria, _categoriaId (+13 more)

### Community 78 - "sistema_tab.dart"
Cohesion: 0.08
Nodes (31): ../../../../core/state/theme_controller.dart, ../../data/configuracion_repository.dart, configuracionRepoProvider, _aperturando, _aperturarPeriodo, build, createState, _forzando (+23 more)

### Community 79 - "ka"
Cohesion: 0.16
Nodes (17): cw(), d1(), d2(), dr(), ds(), dY(), eX(), eY() (+9 more)

### Community 80 - "validacion_screen.dart"
Cohesion: 0.09
Nodes (25): dialogs/precargar_imagen_dialog.dart, dialogs/temporales_dialog.dart, dialogs/validacion_dialog.dart, TemporalesRepository, temporalesProvider, validacionRepoProvider, watch, ValidacionRepository (+17 more)

### Community 81 - "stock_repository.dart"
Cohesion: 0.07
Nodes (24): ../../../core/db/database_provider.dart, historialProduccionesProvider, pendientesProvider, recetasProvider, watch, ProduccionesRepository, agotado, ajustarExistencia (+16 more)

### Community 82 - "categoria_dialog.dart"
Cohesion: 0.10
Nodes (20): _activo, build, categoria, _CategoriaDialog, _CategoriaDialogState, _colorCtrl, _ColorPickerButton, controller (+12 more)

### Community 83 - "a3"
Cohesion: 0.07
Nodes (31): a3(), aF(), an(), aP(), bC(), bN(), bU(), cq() (+23 more)

### Community 84 - "AppDelegate"
Cohesion: 0.11
Nodes (14): Any, Bool, Flutter, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate, FlutterSceneDelegate, AppDelegate (+6 more)

### Community 85 - "app_updater.dart"
Cohesion: 0.06
Nodes (34): ../config/app_config.dart, double get, github_releases_source.dart, initialize, initializeSupabase, supabaseProvider, _assetName, canRun (+26 more)

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
Cohesion: 0.08
Nodes (24): dart:html, dart:typed_data, openInNewTab, PasteCancel, printHtml, reloadApp, setupPasteImageListener, contenedor (+16 more)

### Community 90 - "bandeja_screen.dart"
Cohesion: 0.11
Nodes (24): ../data/whatsapp_providers.dart, bandejaProvider, watch, whatsappPendientesProvider, whatsappRepoProvider, whatsappStatusProvider, WhatsappRepository, BandejaScreen (+16 more)

### Community 91 - "por_fecha_tab.dart"
Cohesion: 0.12
Nodes (18): porFechaProvider, build, _buildListado, _buildSelectorRow, _chip, createState, _elegirFecha, _fechaEspecifica (+10 more)

### Community 92 - "ka"
Cohesion: 0.09
Nodes (27): ai(), aO(), bx(), cw(), d1(), d2(), dr(), ds() (+19 more)

### Community 93 - "posRepoProvider"
Cohesion: 0.08
Nodes (27): ../../data/tasa_bcv_service.dart, posRepoProvider, _cargarCategorias, _cargarContornos, _cargarPlatos, _cargarPlatosSeccion, _cargarProductos, _cargarSubcategorias (+19 more)

### Community 94 - "sync_status.dart"
Cohesion: 0.08
Nodes (25): _activos, dispose, error, errorDetail, estado, _hideTimer, iniciar, mensaje (+17 more)

### Community 95 - "inventario_screen.dart"
Cohesion: 0.09
Nodes (23): ../../data/inventario_providers.dart, ../../data/inventario_repository.dart, ComprasListaItem, _buildHeader, _buildProductosDeCategoria, _categoria, createState, dispose (+15 more)

### Community 96 - "win32_window.cpp"
Cohesion: 0.18
Nodes (14): Point, Size, wchar_t, Scale(), Create, Destroy, UpdateTheme, Win32Window::Win32Window() (+6 more)

### Community 97 - "pos_home_header.dart"
Cohesion: 0.07
Nodes (27): ../../data/pos_comanda_models.dart, double?, ComandaActiva, build, CobroDialog, onConfirm, tasa, tasaFecha (+19 more)

### Community 98 - "requisiciones_sync_test.dart"
Cohesion: 0.22
Nodes (7): RequisicionesRepository, package:control_entradas_salidas/features/requisiciones/data/requisiciones_repository.dart, requisiciones_repository.dart, db, dec, main, repo

### Community 99 - "ConsumerState"
Cohesion: 0.15
Nodes (19): ConsumerState, ConsumerStatefulWidget, SistemaTab, VentasScreen, _VentasScreenState, ConfigCategoriasTab, _ConfigCategoriasTabState, ConfigPlatosTab (+11 more)

### Community 100 - "temporales_dialog.dart"
Cohesion: 0.18
Nodes (11): ../data/temporales_repository.dart, ../data/validacion_providers.dart, TemporalData, createState, _fmtFecha, SeleccionTemporal, showTemporalesDialog, temporal (+3 more)

### Community 101 - "facturas_tab.dart"
Cohesion: 0.13
Nodes (16): dialogs/factura_detalle_dialog.dart, facturasProvider, _abrirDetalle, build, _buildFiltros, createState, dispose, FacturasTab (+8 more)

### Community 102 - "config_habitaciones_tab.dart"
Cohesion: 0.12
Nodes (16): ../dialogs/habitacion_config_dialog.dart, build, _cargando, _cargar, ConfigHabitacionesTab, _ConfigHabitacionesTabState, createState, _editarHabitacion (+8 more)

### Community 103 - "config_mesas_tab.dart"
Cohesion: 0.12
Nodes (16): ../dialogs/mesa_config_dialog.dart, build, _cargando, _cargar, ConfigMesasTab, _ConfigMesasTabState, createState, _editarMesa (+8 more)

### Community 104 - "config_impresora_tab.dart"
Cohesion: 0.07
Nodes (29): ../../data/printer_service.dart, ../../data/ticket_escpos.dart, ../../data/ticket_settings.dart, ../dialogs/ticket_preview_dialog.dart, build, _cargar, ConfigImpresoraTab, _ConfigImpresoraTabState (+21 more)

### Community 105 - "FlutterWindow"
Cohesion: 0.12
Nodes (14): FlutterViewController, unique_ptr, DartProject, HWND, LPARAM, LRESULT, UINT, WPARAM (+6 more)

### Community 106 - "log_bridge.dart"
Cohesion: 0.11
Nodes (17): core/logging/log_bridge.dart, core/network/supabase_client.dart, core/router/app_shell.dart, dart:async, features/pos/presentation/pos_app.dart, _endpoint, flush, instance (+9 more)

### Community 107 - "temporales_repository.dart"
Cohesion: 0.12
Nodes (16): createdAt, _db, eliminar, fecha, _fromRow, getTemporales, guardar, id (+8 more)

### Community 108 - "pop_in.dart"
Cohesion: 0.12
Nodes (16): AnimationController, CurvedAnimation, Duration, build, child, createState, _ctrl, delay (+8 more)

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
Cohesion: 0.10
Nodes (21): ../../../core/auth/session_controller.dart, ../../../core/updater/auto_update_checker.dart, sessionProvider, appDatabaseProvider, build, isOfflineProvider, build, _confirmCtrl (+13 more)

### Community 114 - "factura_detalle_dialog.dart"
Cohesion: 0.15
Nodes (14): ../data/historial_providers.dart, Future, historialRepoProvider, FacturaDetalle, _exportar, build, createState, _FacturaDetalleDialog (+6 more)

### Community 115 - "$0"
Cohesion: 0.10
Nodes (28): $0(), a8(), aL(), aO(), be(), bh(), bx(), c6() (+20 more)

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
Cohesion: 0.25
Nodes (8): inventarioRepoProvider, _cargarExistencias, _MovimientoDialog, _MovimientoDialogState, build, _toggleListaCompra, _cargarDatos, _cargar

### Community 122 - "produccionesRepoProvider"
Cohesion: 0.29
Nodes (7): build, _cargarRecetas, produccionesRepoProvider, _cargar, _cargar, _cargarInicial, _guardar

### Community 123 - "contornos_dialog.dart"
Cohesion: 0.04
Nodes (50): Color, build, _confirmar, contornos, _ContornosDialog, _ContornosDialogState, createState, _error (+42 more)

### Community 124 - "syncEngineProvider"
Cohesion: 0.11
Nodes (21): _dispararSync, initState, _ShellAutenticado, _ShellAutenticadoState, build, GlobalSyncBar, syncEngineProvider, syncStatusProvider (+13 more)

### Community 125 - "wWinMain"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 126 - "file_logger.dart"
Cohesion: 0.17
Nodes (11): IOSink?, dispose, FileLogger, init, _initialized, instance, log, logToFile (+3 more)

### Community 127 - "update_models.dart"
Cohesion: 0.17
Nodes (11): AppUpdateInfo, assetFor, assets, fromJson, name, _normalizeVersion, releasedAt, size (+3 more)

### Community 128 - "bg"
Cohesion: 0.12
Nodes (21): a2(), aX(), aY(), bg(), bY(), cl(), cM(), cO() (+13 more)

### Community 129 - "categoria_card.dart"
Cohesion: 0.18
Nodes (11): build, CategoriaCard, _CategoriaCardState, color, createState, nombre, _onEnter, onTap (+3 more)

### Community 130 - "habitacion_config_dialog.dart"
Cohesion: 0.12
Nodes (16): build, createState, dispose, _esEdicion, false, _guardando, _guardar, habitacion (+8 more)

### Community 131 - "buscador_productos_dialog.dart"
Cohesion: 0.20
Nodes (10): class, build, _BuscadorProductosDialog, _BuscadorProductosDialogState, _buscar, _busqueda, createState, initState (+2 more)

### Community 132 - "agregar_producto_dialog.dart"
Cohesion: 0.18
Nodes (10): ../../../core/sync/sync_service.dart, categoriaId, categorias, codigoCtrl, esPesable, nombreCtrl, precioCtrl, repo (+2 more)

### Community 133 - "DateTime"
Cohesion: 0.25
Nodes (5): DateTime, fetch_bcv_html(), get_bcv_html(), Descarga el HTML del sitio oficial del BCV (misma petición que el scrape del…, WebServer

### Community 134 - "pos_session.dart"
Cohesion: 0.13
Nodes (15): int?, build, cerrarSesion, forzarCerrarSesionAjena, iniciarSesion, PosSesionActiva, PosSessionNotifier, retomarSesionAjena (+7 more)

### Community 135 - "../../data/pos_providers.dart"
Cohesion: 0.14
Nodes (14): ../../data/pos_providers.dart, build, _conPin, createState, dispose, _esAdmin, _guardando, _guardar (+6 more)

### Community 136 - "web/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 137 - "web_pos/manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 138 - "requisicion_card.dart"
Cohesion: 0.20
Nodes (9): ../../data/requisiciones_providers.dart, build, _estadoColor, _fmtFecha, onAuditar, onEditar, onEliminar, onVisualizar (+1 more)

### Community 139 - "historial_screen.dart"
Cohesion: 0.17
Nodes (12): dialogs/exportar_dialog.dart, facturas_tab.dart, build, _buildHeader, createState, dispose, HistorialScreen, _HistorialScreenState (+4 more)

### Community 140 - "ja"
Cohesion: 0.08
Nodes (30): aD(), aE(), aF(), an(), bC(), bL(), bN(), bU() (+22 more)

### Community 141 - "MessageHandler"
Cohesion: 0.36
Nodes (10): HWND, LPARAM, LRESULT, UINT, WPARAM, EnableFullDpiSupportIfAvailable(), GetHandle, GetThisFromHandle (+2 more)

### Community 142 - "configuracion_screen.dart"
Cohesion: 0.17
Nodes (12): build, ConfiguracionScreen, _ConfiguracionScreenState, createState, dispose, initState, _tabController, widgets/categorias_tab.dart (+4 more)

### Community 143 - "db_executor_io.dart"
Cohesion: 0.40
Nodes (4): dart:io, openDbExecutor, package:path/path.dart, package:path_provider/path_provider.dart

### Community 144 - "entrada_pendiente_card.dart"
Cohesion: 0.22
Nodes (8): ../../data/validacion_repository.dart, EntradaPendiente, build, entrada, EntradaPendienteCard, onEliminar, onToggle, selected

### Community 145 - "pin_dialog.dart"
Cohesion: 0.17
Nodes (12): build, createState, _ctrl, dispose, _entrar, _error, _focus, initState (+4 more)

### Community 146 - "entrada_card.dart"
Cohesion: 0.25
Nodes (7): ../../data/historial_repository.dart, EntradaPorFecha, build, entrada, EntradaCard, _fmtHora, _pesoBadge

### Community 147 - "app_config.dart"
Cohesion: 0.25
Nodes (7): AppConfig, hasSupabaseKey, syncIntervalSeconds, webPort, static bool get, static const int, static String get

### Community 148 - "receta_card.dart"
Cohesion: 0.15
Nodes (12): _badge, build, _fmtCant, ingredientes, onDelete, onEdit, onTap, receta (+4 more)

### Community 149 - "existencias_dialog.dart"
Cohesion: 0.22
Nodes (8): ajuste_dialog.dart, ../data/stock_repository.dart, capitalize, esPesable, existencias, fmtCant, showExistenciasDialog, _StringCapitalize

### Community 150 - "auto_update_checker.dart"
Cohesion: 0.29
Nodes (7): AutoUpdateChecker, _AutoUpdateCheckerState, build, _chequeado, createState, update_dialog.dart, updater_providers.dart

### Community 151 - "ticket_escpos_test.dart"
Cohesion: 0.33
Nodes (5): package:control_entradas_salidas/features/pos/data/pos_comanda_models.dart, package:control_entradas_salidas/features/pos/data/ticket_escpos.dart, header, items, main

### Community 152 - "ConsumerWidget"
Cohesion: 0.16
Nodes (18): ConsumerWidget, AppShell, CategoriasGrid, ListaCompraItem, comandasActivasProvider, habitacionesOcupadasProvider, habitacionesProvider, mesasOcupadasProvider (+10 more)

### Community 153 - "database_provider.dart"
Cohesion: 0.50
Nodes (3): db, return, schema/app_database.dart

### Community 183 - "ajuste_dialog.dart"
Cohesion: 0.25
Nodes (7): cantCtrl, capitalize, errorText, esPesable, motivoCtrl, _StringCapitalize, unidad

### Community 184 - "package:flutter/services.dart"
Cohesion: 0.29
Nodes (6): build, detalle, _ErrorDetailsDialog, showErrorDetailsDialog, titulo, package:flutter/services.dart

### Community 185 - "package:drift/drift.dart"
Cohesion: 0.40
Nodes (4): driftDatabase, openDbExecutor, package:drift/drift.dart, package:drift_flutter/drift_flutter.dart

## Knowledge Gaps
- **2410 isolated node(s):** `XCTest`, `_db`, `nombre`, `pinHash`, `registrarOperador` (+2405 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **10 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AppDatabase` connect `AppDatabase` to `app_database.dart`, `inventario_repository.dart`, `requisiciones_sync_test.dart`, `historial_repository.dart`, `pos_ventas_repository.dart`, `requisiciones_repository.dart`, `validacion_repository.dart`, `configuracion_repository.dart`, `temporales_repository.dart`, `producciones_repository.dart`, `stock_repository.dart`, `pos_repository.dart`, `sync_service.dart`, `whatsapp_repository.dart`, `database_provider.dart`, `sync_engine.dart`, `pos_sync_engine.dart`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Why does `Producto` connect `DataClass` to `app_database.dart`, `producto_dialog.dart`, `receta_editor_screen.dart`, `buscador_productos_dialog.dart`, `cantidad_dialog.dart`, `productos_tab.dart`, `stock_screen.dart`, `package:flutter_riverpod/flutter_riverpod.dart`, `movimiento_dialog.dart`?**
  _High betweenness centrality (0.006) - this node is a cross-community bridge._
- **Why does `posRepoProvider` connect `posRepoProvider` to `habitacion_config_dialog.dart`, `ConsumerState`, `pos_session.dart`, `comanda_screen.dart`, `../../data/pos_providers.dart`, `subcategoria_dialog.dart`, `config_habitaciones_tab.dart`, `config_impresora_tab.dart`, `mesa_config_dialog.dart`, `pos_screen.dart`, `config_mesas_tab.dart`, `config_platos_tab.dart`, `config_categorias_tab.dart`, `plato_config_dialog.dart`, `config_usuarios_tab.dart`, `pos_categoria_dialog.dart`, `inventarioRepoProvider`, `pos_providers.dart`?**
  _High betweenness centrality (0.004) - this node is a cross-community bridge._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 108 inferred relationships involving `c()` (e.g. with `web_pos/drift_worker.js` and `aG()`) actually correct?**
  _`c()` has 108 INFERRED edges - model-reasoned connections that need verification._
- **Are the 31 inferred relationships involving `a()` (e.g. with `aG()` and `aH()`) actually correct?**
  _`a()` has 31 INFERRED edges - model-reasoned connections that need verification._
- **What connects `XCTest`, `_db`, `nombre` to the rest of the system?**
  _2410 weakly-connected nodes found - possible documentation gaps or missing edges._