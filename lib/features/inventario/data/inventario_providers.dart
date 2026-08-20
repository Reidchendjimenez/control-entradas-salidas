import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import 'inventario_repository.dart';

/// Provider del repositorio de inventario.
final inventarioRepoProvider = Provider<InventarioRepository>((ref) {
  return InventarioRepository(ref.watch(appDatabaseProvider));
});