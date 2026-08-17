import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import 'stock_repository.dart';

/// Provider compartido del repositorio de stock.
final stockRepoProvider = Provider<StockRepository>((ref) {
  return StockRepository(ref.watch(appDatabaseProvider));
});
