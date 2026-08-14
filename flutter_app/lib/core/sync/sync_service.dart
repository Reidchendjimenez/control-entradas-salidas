import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database_provider.dart';
import '../db/schema/app_database.dart';
import '../network/supabase_client.dart';
import 'sync_engine.dart';

/// Provider del motor de sincronización (null si supabase no está configurado).
final syncEngineProvider = Provider<SyncEngine?>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return null;
  final db = ref.watch(appDatabaseProvider);
  final engine = SyncEngine(db: db, client: client);
  // Visibilizar el progreso del sync en los logs (vía LogBridge).
  engine.onProgress = (msg) => print('[sync] $msg');
  return engine;
});

/// Registra una operación pendiente en la cola de sync (outbox).
/// Réplica de `SyncQueue.add_pending()` de sync_queue.py.
Future<int> addPending(
  AppDatabase db, {
  required String tableName,
  required String operation,
  required Map<String, dynamic> data,
}) async {
  return db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          targetTable: tableName,
          operation: operation,
          data: jsonEncode(data),
          createdAt: DateTime.now(),
          status: const Value('pending'),
        ),
      );
}