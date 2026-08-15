import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/network/supabase_client.dart';
import '../../../core/sync/pos_sync_engine.dart';
import 'pos_repository.dart';
import 'pos_ventas_repository.dart';

/// Repositorio de catálogos/settings/sesiones del POS.
final posRepoProvider = Provider<PosRepository>((ref) {
  return PosRepository(ref.watch(appDatabaseProvider));
});

/// Repositorio de comandas/ventas del POS.
final posVentasRepoProvider = Provider<PosVentasRepository>((ref) {
  return PosVentasRepository(ref.watch(appDatabaseProvider));
});

/// Motor de sync POS (null si Supabase no está configurado). Port de
/// `POSSyncManager` (pos_sync.py): sube el outbox `pos_*`/`platos_*` por
/// sync_uuid y descarga las 11 tablas con poda de huérfanos.
final posSyncEngineProvider = Provider<PosSyncEngine?>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return null;
  final engine = PosSyncEngine(db: ref.watch(appDatabaseProvider), client: client);
  engine.onProgress = (msg) => print('[pos-sync] $msg');
  return engine;
});
