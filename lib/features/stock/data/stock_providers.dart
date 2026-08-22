import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/supabase_providers.dart';
import 'stock_repository.dart';

final stockRepoProvider = Provider<StockRepository?>((ref) {
  final db = ref.watch(supabaseServiceProvider);
  if (db == null) return null;
  return StockRepository(db);
});
