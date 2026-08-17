import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'schema/app_database.dart';

/// Provider singleton de la base de datos drift.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});