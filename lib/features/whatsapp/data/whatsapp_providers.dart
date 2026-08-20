import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/schema/app_database.dart';
import 'whatsapp_repository.dart';

/// Provider del repositorio de la cola de WhatsApp.
final whatsappRepoProvider = Provider<WhatsappRepository>((ref) {
  return WhatsappRepository(ref.watch(appDatabaseProvider));
});

/// Mensajes de la bandeja (los más recientes primero).
final bandejaProvider = FutureProvider.autoDispose<List<WhatsappQueueData>>(
    (ref) {
  return ref.watch(whatsappRepoProvider).getMensajes(limit: 100);
});

/// Pendientes por reintentar (badge/contador).
final whatsappPendientesProvider =
    FutureProvider.autoDispose<int>((ref) {
  return ref.watch(whatsappRepoProvider).countPending();
});

/// Estado de conexión del bot (GET /config).
final whatsappStatusProvider = FutureProvider.autoDispose<
    ({bool connected, String? groupId})>((ref) {
  return ref.watch(whatsappRepoProvider).getStatus();
});
