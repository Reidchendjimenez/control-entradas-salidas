import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/supabase_providers.dart';
import 'inventario_repository.dart';

/// Provider del repositorio de inventario.
final inventarioRepoProvider = Provider<InventarioRepository?>((ref) {
  final db = ref.watch(supabaseServiceProvider);
  if (db == null) return null;
  return InventarioRepository(db);
});
