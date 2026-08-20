import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/schema/app_database.dart';
import 'temporales_repository.dart';
import 'validacion_repository.dart';

/// Provider compartido del repositorio de validación.
final validacionRepoProvider = Provider<ValidacionRepository>((ref) {
  return ValidacionRepository(ref.watch(appDatabaseProvider));
});

/// Provider compartido del repositorio de temporales (imágenes pre-cargadas).
final temporalesRepoProvider = Provider<TemporalesRepository>((ref) {
  return TemporalesRepository(ref.watch(appDatabaseProvider));
});

/// Lista reactiva de temporales de Validación.
final temporalesProvider = StreamProvider<List<TemporalData>>((ref) {
  return ref.watch(temporalesRepoProvider).watchTemporales();
});

/// Proveedores activos para el dropdown del diálogo de validación.
final proveedoresProvider = FutureProvider<List<Proveedore>>((ref) {
  return ref.watch(validacionRepoProvider).getProveedores();
});
