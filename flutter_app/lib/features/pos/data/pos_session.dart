import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import 'pos_providers.dart';

/// Sesión activa del POS: cajero + turno de caja abierto.
class PosSesionActiva {
  const PosSesionActiva({required this.usuario, required this.sesionId});
  final PosUsuario usuario;
  final int sesionId;
}

/// Estado de la sesión del POS (flujo de turnos/cajas):
/// - Al hacer login se abre un turno con caja en 0 (o se retoma el turno que
///   quedó abierto si el sistema se cerró sin logout).
/// - Al cerrar sesión se cierra el turno y la caja (monto final automático =
///   caja inicial + ventas vigentes del turno), generando el reporte que se
///   sincroniza como `pos_sesiones`.
/// - Al arrancar siempre se pide login (no se restaura la sesión), pero el
///   turno abierto se conserva para retomarlo en el próximo login.
final posSessionProvider =
    NotifierProvider<PosSessionNotifier, PosSesionActiva?>(
        PosSessionNotifier.new);

class PosSessionNotifier extends Notifier<PosSesionActiva?> {
  @override
  PosSesionActiva? build() => null;

  /// Valida el PIN (si el usuario lo tiene) y abre un turno de caja en 0, o
  /// retoma el turno que quedó abierto. Devuelve `false` si el PIN es
  /// requerido e incorrecto.
  Future<bool> iniciarSesion(PosUsuario usuario, {String? pin}) async {
    if (usuario.pinHash != null && usuario.pinHash!.isNotEmpty) {
      if (pin == null || pin.isEmpty) return false;
      final ok = await ref.read(posRepoProvider).verificarPin(usuario.id, pin);
      if (!ok) return false;
    }

    final repo = ref.read(posRepoProvider);
    final abierto = await repo.getSesionActiva();
    if (abierto != null) {
      // Turno pendiente del dispositivo: se retoma con su usuario.
      final u = await repo.getUsuario(abierto.sesion.usuarioId);
      if (u == null) return false;
      state = PosSesionActiva(usuario: u, sesionId: abierto.sesion.id);
      return true;
    }

    final sesionId = await repo.abrirSesion(usuario.id);
    state = PosSesionActiva(usuario: usuario, sesionId: sesionId);
    return true;
  }

  /// Cierra el turno y la caja (monto final automático) y vuelve al login.
  Future<void> cerrarSesion() async {
    final s = state;
    state = null;
    if (s != null) {
      await ref.read(posRepoProvider).cerrarSesion(s.sesionId);
    }
  }
}