import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/supabase_client.dart';
import 'realtime_source.dart';
import 'supabase_realtime_source.dart';

/// Proveedor del servicio de Realtime.
///
/// Retorna [SupabaseRealtimeSource] si Supabase está configurado, o null
/// si no hay credenciales. Para cambiar a otro backend (servidor propio,
/// Firebase, etc.), reemplazar esta implementación por la alternativa.
///
/// **Para migrar a otro backend:**
/// 1. Crear una clase que implemente `RealtimeSource`
/// 2. Cambiar este provider para que retorne esa instancia
/// 3. No tocar la lógica de sync en `SyncEngine` ni `PosSyncEngine`
final realtimeSourceProvider = Provider<RealtimeSource?>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return null;
  return SupabaseRealtimeSource(client);
});
