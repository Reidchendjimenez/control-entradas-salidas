import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../core/db/schema/app_database.dart';

/// Controlador de sesión (autenticación PIN + nombre).
/// Porta la lógica de `LoginView` y `LocalReplica.get_usuario_dispositivo()`.
class SessionController extends StateNotifier<SessionState> {
  SessionController(this._db) : super(SessionState.unauthenticated()) {
    _cargar();
  }

  final AppDatabase _db;

  Future<void> _cargar() async {
    final u = await _db.select(_db.dispositivoUsuario).getSingleOrNull();
    if (u != null && u.pinHash != null) {
      state = SessionState.authenticated(
        nombre: u.nombre,
        pinHash: u.pinHash!,
      );
    }
  }

  /// Registra el operador inicial (equivalente a modo="registro").
  Future<bool> registrarOperador({
    required String nombre,
    required String pin,
  }) async {
    final id = await _db.into(_db.dispositivoUsuario).insert(
          DispositivoUsuarioCompanion.insert(
            nombre: nombre,
            pinHash: Value(pin),
            configuradoEn: DateTime.now(),
          ),
        );
    if (id > 0) {
      state = SessionState.authenticated(nombre: nombre, pinHash: pin);
      return true;
    }
    return false;
  }

  /// Verifica el PIN (equivalente a modo="login").
  Future<bool> verificarPin(String pin) async {
    final u = await _db.select(_db.dispositivoUsuario).getSingleOrNull();
    if (u == null || u.pinHash == null) return false;
    if (u.pinHash == pin) {
      // (en producción: comparar hash)
      state = SessionState.authenticated(nombre: u.nombre, pinHash: u.pinHash!);
      return true;
    }
    return false;
  }

  void cerrarSesion() {
    state = SessionState.unauthenticated();
  }
}

/// Estado de la sesión (usuario logueado o no).
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