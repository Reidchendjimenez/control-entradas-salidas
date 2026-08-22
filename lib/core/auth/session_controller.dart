import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/supabase_service.dart';
import '../data/supabase_providers.dart';

final sessionProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
  return SessionController(ref.watch(supabaseServiceProvider));
});

class SessionController extends StateNotifier<SessionState> {
  SessionController(this._db) : super(const SessionState.unauthenticated());
  final SupabaseService? _db;

  Future<bool> registrarOperador({
    required String nombre,
    required String pin,
  }) async {
    if (_db == null) return false;
    final result = await _db!.insert('dispositivo_usuario', {
      'nombre': nombre,
      'pin_hash': pin,
      'configurado_en': DateTime.now().toIso8601String(),
    });
    if (result != null) {
      state = SessionState.authenticated(nombre: nombre, pinHash: pin);
      return true;
    }
    return false;
  }

  Future<bool> verificarPin(String pin) async {
    if (_db == null) return false;
    final rows = await _db!.client
        .from('dispositivo_usuario')
        .select('nombre, pin_hash')
        .limit(1);
    if (rows.isEmpty) return false;
    final u = rows.first;
    if (u['pin_hash'] == pin) {
      state = SessionState.authenticated(
        nombre: u['nombre'] as String,
        pinHash: u['pin_hash'] as String,
      );
      return true;
    }
    return false;
  }

  void cerrarSesion() {
    state = const SessionState.unauthenticated();
  }
}

sealed class SessionState {
  const SessionState();
  const factory SessionState.authenticated({
    required String nombre,
    required String pinHash,
  }) = Authenticated;
  const factory SessionState.unauthenticated() = Unauthenticated;
}

class Authenticated implements SessionState {
  final String nombre;
  final String pinHash;
  const Authenticated({required this.nombre, required this.pinHash});
}

class Unauthenticated implements SessionState {
  const Unauthenticated();
}
