import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Origen del mensaje de progreso (el sync general y el POS corren en
/// paralelo; cada uno alimenta la misma barra).
enum SyncOrigen { general, pos }

/// Estado visible de la barra global de sync.
enum SyncEstado { inactivo, activo, ok, error }

/// Estado reactivo de la barra global de sincronización.
class SyncStatus {
  const SyncStatus({
    this.origen,
    this.estado = SyncEstado.inactivo,
    this.mensaje = '',
    this.errorDetail,
  });

  final SyncOrigen? origen;
  final SyncEstado estado;
  final String mensaje;

  /// Detalle completo del error (para el diálogo de copiado).
  final String? errorDetail;

  bool get visible => estado != SyncEstado.inactivo;
}

/// Notifier de la barra global de sync (port de `usr/pos/sync_indicator.py`
/// + el indicador de `requisiciones_view.py`): solo se muestra durante una
/// sincronización manual o inicial; los ciclos de background no pestañean la
/// barra. Replica la heurística de mapeo de mensajes de Flet (start/done/error)
/// y se oculta sola a los pocos segundos de terminar.
class SyncStatusNotifier extends StateNotifier<SyncStatus> {
  SyncStatusNotifier() : super(const SyncStatus());

  final Set<SyncOrigen> _activos = {};
  Timer? _hideTimer;

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _mostrar(SyncOrigen? origen, SyncEstado estado, String mensaje,
      {String? errorDetail}) {
    _hideTimer?.cancel();
    if (estado == SyncEstado.ok || estado == SyncEstado.error) {
      _hideTimer = Timer(
        Duration(seconds: estado == SyncEstado.error ? 8 : 4),
        () => state = const SyncStatus(),
      );
    }
    state = SyncStatus(
      origen: origen,
      estado: estado,
      mensaje: mensaje,
      errorDetail: errorDetail,
    );
  }

  /// Marca una sesión de sync como activa (manual o inicial) y muestra la barra.
  void iniciar(SyncOrigen origen, {String mensaje = 'Iniciando sincronización…'}) {
    _activos.add(origen);
    _mostrar(origen, SyncEstado.activo, mensaje);
  }

  /// Cierra la sesión sin esperar el mensaje del motor (respaldo si
  /// `fullSync()` retorna temprano por estar ya en curso). No-op si el motor
  /// ya emitió la finalización/error.
  void terminar(SyncOrigen origen, {required bool ok}) {
    if (!_activos.remove(origen)) return;
    _mostrar(
      origen,
      ok ? SyncEstado.ok : SyncEstado.error,
      ok ? 'Sincronización completada' : 'Error en la sincronización',
    );
  }

  /// Reporta un error de sincronización con su detalle completo.
  void error(SyncOrigen origen, String mensaje, {String? detalle}) {
    _activos.remove(origen);
    _mostrar(origen, SyncEstado.error, mensaje, errorDetail: detalle);
  }

  /// Puente para `engine.onProgress`: réplica de la heurística de
  /// `sync_indicator.py` (done = mensaje terminado en finalizada/completada/o;
  /// error = contiene "Error"). Solo renderiza mensajes de un origen con
  /// sesión activa.
  void progreso(SyncOrigen origen, String msg) {
    if (!_activos.contains(origen)) return;
    final limpio = msg
        .replaceFirst(RegExp(r'^\[(pos-)?sync\] '), '')
        .trim();
    if (limpio.contains('Error')) {
      _activos.remove(origen);
      _mostrar(origen, SyncEstado.error, limpio);
    } else if (limpio.endsWith('finalizada') ||
        limpio.endsWith('completada') ||
        limpio.endsWith('completado')) {
      _activos.remove(origen);
      _mostrar(origen, SyncEstado.ok, limpio);
    } else {
      _mostrar(origen, SyncEstado.activo, limpio);
    }
  }
}

/// Estado global de la barra de sync (watch en `GlobalSyncBar`).
final syncStatusProvider =
    StateNotifierProvider<SyncStatusNotifier, SyncStatus>(
  (ref) => SyncStatusNotifier(),
);
