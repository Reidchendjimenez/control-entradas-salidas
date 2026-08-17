import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/schema/app_database.dart';
import 'producciones_repository.dart';

/// Provider del repositorio de producciones.
final produccionesRepoProvider = Provider<ProduccionesRepository>((ref) {
  return ProduccionesRepository(ref.watch(appDatabaseProvider));
});

/// Recetas activas para el tab "Recetas".
final recetasProvider = FutureProvider.autoDispose<List<Receta>>((ref) {
  return ref.watch(produccionesRepoProvider).getRecetas();
});

/// Productos activos para el editor de recetas (buscador/selectores).
final productosActivosProvider = FutureProvider.autoDispose<List<Producto>>((ref) {
  return ref.watch(produccionesRepoProvider).getProductosActivos();
});

/// Producciones pendientes para el tab "En Producción".
final pendientesProvider =
    FutureProvider.autoDispose<List<ProduccionInfo>>((ref) {
  return ref.watch(produccionesRepoProvider).getProduccionesPorEstado('pendiente');
});

/// Historial de producciones para el tab "Historial".
final historialProduccionesProvider =
    FutureProvider.autoDispose<List<ProduccionInfo>>((ref) {
  return ref.watch(produccionesRepoProvider).getProducciones();
});
