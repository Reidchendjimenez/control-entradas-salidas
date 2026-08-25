import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/pos_models.dart';
import 'pos_providers.dart';

/// Sesión activa del POS: cajero + turno de caja abierto.
class PosSesionActiva {
  const PosSesionActiva({required this.usuario, required this.sesionId});
  final PosUsuario usuario;
  final int sesionId;
}

/// Resultado del intento de iniciar sesión.
enum SesionLoginResult {
  /// Se abrió un turno nuevo.
  nueva,

  /// Se retomó el turno existente del mismo usuario.
  retomada,

  /// Había un turno abierto de OTRO usuario. El caller debe preguntar
  /// al usuario si quiere cerrar el turno ajeno y abrir uno nuevo, o
  /// retomar el turno existente.
  sesionAjena,

  /// El PIN era incorrecto (no se hizo nada).
  pinIncorrecto,
}

/// Estado de la sesión del POS (flujo de turnos/cajas):
/// - Al hacer login se abre un turno con caja en 0 (o se retoma el turno que
///   quedó abierto si el sistema se cerró sin logout).
/// - Al cerrar sesión se cierra el turno y la caja (monto final automático =
///   caja inicial + ventas vigentes del turno), generando el reporte que se
///   guarda como `pos_sesiones`.
/// - Al arrancar siempre se pide login (no se restaura la sesión), pero el
///   turno abierto se conserva para retomarlo en el próximo login.
final posSessionProvider =
    NotifierProvider<PosSessionNotifier, PosSesionActiva?>(
        PosSessionNotifier.new);

class PosSessionNotifier extends Notifier<PosSesionActiva?> {
  /// ID de la sesión ajena detectada durante el login (para el diálogo).
  int? sesionAjenaId;
  String? sesionAjenaNombre;

  @override
  PosSesionActiva? build() => null;

  /// Valida el PIN (si el usuario lo tiene), cierra sesiones stale (>8h) y
  /// abre un turno de caja en 0, o retoma el turno que quedó abierto.
  ///
  /// Si hay un turno abierto de OTRO usuario, no lo cierra automáticamente:
  /// devuelve [SesionLoginResult.sesionAjena] para que la UI muestre un
  /// diálogo de confirmación. El caller debe llamar a
  /// [forzarCerrarSesionAjena] o [retomarSesionAjena] después.
  Future<SesionLoginResult> iniciarSesion(PosUsuario usuario,
      {String? pin}) async {
    if (usuario.pinHash != null && usuario.pinHash!.isNotEmpty) {
      if (pin == null || pin.isEmpty) return SesionLoginResult.pinIncorrecto;
      final ok = await ref.read(posRepoProvider)!.verificarPin(usuario.id, pin);
      if (!ok) return SesionLoginResult.pinIncorrecto;
    }

    final repo = ref.read(posRepoProvider)!;

    // Cerrar sesiones stale (>8h abiertas) automáticamente.
    await repo.cerrarSesionesStale(horas: 8);

    // Usuario desarrollador: inicia sesión SIN aperturar turno/caja
    // (`sesionId = 0` = sin turno). No hereda ni conflictúa con turnos ajenos.
    if (usuario.esDesarrollador) {
      state = PosSesionActiva(usuario: usuario, sesionId: 0);
      return SesionLoginResult.nueva;
    }

    final abierto = await repo.getSesionActiva();
    if (abierto != null) {
      // Turno pendiente del dispositivo.
      if (abierto.sesion.usuarioId != usuario.id) {
        // Turno de OTRO usuario: devolver info para que la UI pregunte.
        sesionAjenaId = abierto.sesion.id;
        sesionAjenaNombre = abierto.usuarioNombre;
        return SesionLoginResult.sesionAjena;
      }
      // Turno del MISMO usuario: retomar silenciosamente.
      final u = await repo.getUsuario(abierto.sesion.usuarioId);
      if (u == null) return SesionLoginResult.nueva;
      state = PosSesionActiva(usuario: u, sesionId: abierto.sesion.id);
      return SesionLoginResult.retomada;
    }

    final sesionId = await repo.abrirSesion(usuario.id);
    state = PosSesionActiva(usuario: usuario, sesionId: sesionId);
    return SesionLoginResult.nueva;
  }

  /// Cierra el turno ajeno detectado en [iniciarSesion] y abre uno nuevo para
  /// el usuario indicado. Llamar después de que el usuario confirme en el
  /// diálogo.
  Future<void> forzarCerrarSesionAjena(PosUsuario usuario) async {
    final repo = ref.read(posRepoProvider)!;
    if (sesionAjenaId != null) {
      await repo.forzarCerrarSesion(sesionAjenaId!);
      sesionAjenaId = null;
      sesionAjenaNombre = null;
    }
    final sesionId = await repo.abrirSesion(usuario.id);
    state = PosSesionActiva(usuario: usuario, sesionId: sesionId);
  }

  /// Retoma la sesión ajena existente (el usuario decidió NO cerrarla).
  Future<void> retomarSesionAjena(PosUsuario usuario) async {
    final repo = ref.read(posRepoProvider)!;
    if (sesionAjenaId != null) {
      state = PosSesionActiva(usuario: usuario, sesionId: sesionAjenaId!);
      sesionAjenaId = null;
      sesionAjenaNombre = null;
    }
  }

  /// Cierra el turno y la caja (monto final automático) y vuelve al login.
  Future<void> cerrarSesion() async {
    final s = state;
    state = null;
    // `sesionId == 0` = sesión de desarrollador sin turno (nada que cerrar).
    if (s != null && s.sesionId > 0) {
      await ref.read(posRepoProvider)!.cerrarSesion(s.sesionId);
    }
  }

  /// Vuelve al login sin cerrar la sesión en BD (el turno queda abierto).
  void salirSinCerrar() {
    state = null;
  }
}
