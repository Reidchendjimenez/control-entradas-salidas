import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Inicializa Supabase (equivalente a la conexión a Supabase de sync.py, pero
/// vía REST en vez de pg8000 — necesario para web/móvil).
///
/// En Flutter web el API REST de Supabase va por HTTP; el Postgres pooler
/// directo (pg8000) no aplica. La anon key se inyecta con `--dart-define`.
Future<void> initializeSupabase() async {
  if (!AppConfig.hasSupabaseKey) return;
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );
}

/// Cliente Supabase (null si no hay key o no fue inicializado).
final supabaseProvider = Provider<SupabaseClient?>((ref) {
  if (!AppConfig.hasSupabaseKey) return null;
  return Supabase.instance.client;
});