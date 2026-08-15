import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import 'pos_providers.dart';

/// Sesión activa del POS: cajero + sesión de caja abierta.
class PosSesionActiva {
  const PosSesionActiva({required this.usuario, required this.sesionId});
  final PosUsuario usuario;
  final int sesionId;
}

/// Estado de la sesión del POS. Port de `POSLoginView._complete_login`
/// (login.py): al entrar se abre una sesión (`pos_sesiones`) y se guarda en
/// memoria; al salir se cierra la sesión de caja.
final posSessionProvider =
    NotifierProvider<PosSessionNotifier, PosSesionActiva?>(
        PosSessionNotifier.new);

class PosSessionNotifier extends Notifier<PosSesionActiva?> {
  @override
  PosSesionActiva? build() {
    _restaurarSesion();
    return null;
  }

  Future<void> _restaurarSesion() async {
    final repo = ref.read(posRepoProvider);
    final activa = await repo.getSesionActiva();
    if (activa == null || state != null) return;
    final u = await repo.getUsuario(activa.sesion.usuarioId);
    if (u == null) return;
    state = PosSesionActiva(usuario: u, sesionId: activa.sesion.id);
  }

  /// Valida el PIN (si el usuario lo tiene) y abre la sesión de caja.
  /// Devuelve `false` si el PIN es requerido e incorrecto.
  Future<bool> iniciarSesion(PosUsuario usuario, {String? pin}) async {
    if (usuario.pinHash != null && usuario.pinHash!.isNotEmpty) {
      if (pin == null || pin.isEmpty) return false;
      final ok = await ref.read(posRepoProvider).verificarPin(usuario.id, pin);
      if (!ok) return false;
    }
    final sesionId = await ref.read(posRepoProvider).abrirSesion(usuario.id);
    state = PosSesionActiva(usuario: usuario, sesionId: sesionId);
    return true;
  }

  Future<void> cerrarSesion() async {
    final s = state;
    state = null;
    if (s != null) {
      await ref.read(posRepoProvider).cerrarSesion(s.sesionId);
    }
  }
}
