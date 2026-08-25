import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../network/supabase_client.dart';
import 'cache_service.dart';
import 'realtime_service.dart';
import 'supabase_service.dart';

/// Provider del servicio Supabase centralizado.
///
/// Retorna `null` si no hay configuracion de Supabase (modo sin servidor).
/// Todos los repositorios deben usar este provider para acceder a la base
/// de datos remota.
final supabaseServiceProvider = Provider<SupabaseService?>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return null;
  return SupabaseService(client);
});

/// Provider del cliente Supabase raw (para queries complejas que el
/// servicio generico no cubre).
final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  return ref.watch(supabaseProvider);
});

/// Provider del servicio de Realtime.
final realtimeServiceProvider = Provider<RealtimeService?>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return null;
  return RealtimeService(client);
});

/// Provider del servicio de cache local.
/// Se inicializa una vez y se reutiliza en toda la app.
final cacheServiceProvider = FutureProvider<CacheService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return CacheService(prefs);
});
