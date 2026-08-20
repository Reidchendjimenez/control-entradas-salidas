import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/schema/app_database.dart';
import 'configuracion_repository.dart';

/// Provider compartido del repositorio de configuración.
final configuracionRepoProvider = Provider<ConfiguracionRepository>((ref) {
  return ConfiguracionRepository(ref.watch(appDatabaseProvider));
});

/// Proveedores activos para dropdowns.
final proveedoresConfigProvider = FutureProvider<List<Proveedore>>((ref) {
  return ref.watch(configuracionRepoProvider).getProveedores();
});

/// Categorías activas para dropdowns.
final categoriasConfigProvider = FutureProvider<List<Categoria>>((ref) {
  return ref.watch(configuracionRepoProvider).getCategorias();
});

/// Almacenes disponibles.
final almacenesConfigProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(configuracionRepoProvider).getAlmacenes();
});

/// Productos para la pestaña de configuración.
final productosConfigProvider = FutureProvider<List<Producto>>((ref) {
  return ref.watch(configuracionRepoProvider).getProductos();
});

/// Configuración POS: permitir stock negativo.
final permitirStockNegativoProvider = FutureProvider<bool>((ref) {
  return ref.watch(configuracionRepoProvider).getPermitirStockNegativo();
});

/// Configuración POS: almacén por defecto de producción.
final almacenProduccionDefaultProvider = FutureProvider<String>((ref) {
  return ref.watch(configuracionRepoProvider).getAlmacenProduccionDefault();
});

/// Periodos archivados.
final periodosConfigProvider = FutureProvider<List<Periodo>>((ref) {
  return ref.watch(configuracionRepoProvider).getPeriodos();
});

/// Usuario del dispositivo.
final usuarioDispositivoProvider = FutureProvider<Map<String, dynamic>?>((ref) {
  return ref.watch(configuracionRepoProvider).getUsuarioDispositivo();
});