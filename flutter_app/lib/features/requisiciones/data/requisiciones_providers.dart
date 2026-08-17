import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import 'requisiciones_repository.dart';

/// Provider compartido del repositorio de requisiciones.
final requisicionesRepoProvider = Provider<RequisicionesRepository>((ref) {
  return RequisicionesRepository(ref.watch(appDatabaseProvider));
});
