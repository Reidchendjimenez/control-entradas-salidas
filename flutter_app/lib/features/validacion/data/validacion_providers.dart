import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/schema/app_database.dart';
import 'validacion_repository.dart';

/// Provider compartido del repositorio de validación.
final validacionRepoProvider = Provider<ValidacionRepository>((ref) {
  return ValidacionRepository(ref.watch(appDatabaseProvider));
});

/// Proveedores activos para el dropdown del diálogo de validación.
final proveedoresProvider = FutureProvider<List<Proveedore>>((ref) {
  return ref.watch(validacionRepoProvider).getProveedores();
});
