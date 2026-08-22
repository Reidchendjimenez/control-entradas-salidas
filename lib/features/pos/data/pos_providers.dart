import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/data/supabase_providers.dart';
import '../../../core/data/supabase_service.dart';
import '../../../core/models/pos_models.dart';
import 'pos_comanda_models.dart';
import 'pos_repository.dart';
import 'pos_ventas_repository.dart';

/// Repositorio de catálogos/settings/sesiones del POS.
final posRepoProvider = Provider<PosRepository?>((ref) {
  final db = ref.watch(supabaseServiceProvider);
  if (db == null) return null;
  return PosRepository(db);
});

/// Repositorio de comandas/ventas del POS.
final posVentasRepoProvider = Provider<PosVentasRepository?>((ref) {
  final db = ref.watch(supabaseServiceProvider);
  if (db == null) return null;
  return PosVentasRepository(db);
});

// ---------------------------------------------------------------------------
// Providers de datos para la UI del POS (compartidos entre pantallas).
// ---------------------------------------------------------------------------

final mesasProvider = FutureProvider<List<PosMesa>>((ref) {
  return ref.watch(posRepoProvider)!.getMesas(soloActivos: true);
});

final habitacionesProvider = FutureProvider<List<PosHabitacion>>((ref) {
  return ref.watch(posRepoProvider)!.getHabitaciones(soloActivos: true);
});

final usuariosProvider = FutureProvider<List<PosUsuario>>((ref) {
  return ref.watch(posRepoProvider)!.getUsuarios();
});

/// ID del cajero con turno abierto (para marcarlo en el login), o null.
final turnoActivoUsuarioProvider = FutureProvider<int?>((ref) {
  return ref
      .watch(posRepoProvider)!
      .getSesionActiva()
      .then((a) => a?.sesion.usuarioId);
});

final platosProvider = FutureProvider<List<PosPlato>>((ref) {
  return ref.watch(posRepoProvider)!.getPlatos(soloActivos: true);
});

final comandasAbiertasProvider = FutureProvider<List<PosComanda>>((ref) {
  return ref.watch(posVentasRepoProvider)!.getComandasAbiertas();
});

/// Mesas con comanda abierta (para marcar Ocupada en el grid y el home).
/// Se refresca con `ref.invalidate` tras abrir/cerrar una comanda.
final mesasOcupadasProvider = FutureProvider<Set<int>>((ref) {
  return ref.watch(posVentasRepoProvider)!.getMesasOcupadas();
});

/// Comandas abiertas enriquecidas (etiqueta, total, items) para retomarlas
/// desde el home del POS. Se refresca con `ref.invalidate`.
final comandasActivasProvider = FutureProvider<List<ComandaActiva>>((ref) {
  return ref.watch(posVentasRepoProvider)!.getComandasActivas();
});

/// Habitaciones con comanda abierta. Se refresca con `ref.invalidate`.
final habitacionesOcupadasProvider = FutureProvider<Set<int>>((ref) {
  return ref.watch(posVentasRepoProvider)!.getHabitacionesOcupadas();
});

/// Historial de ventas (más recientes primero), se invalida al cobrar/anular.
final ventasProvider = FutureProvider<List<PosVenta>>((ref) {
  return ref.watch(posVentasRepoProvider)!.getVentas(limit: 200);
});

/// Resumen de ventas vigentes del día (cantidad + total) para el home del
/// POS. Se invalida al cobrar/anular.
final ventasHoyProvider =
    FutureProvider<({int cantidad, double total})>((ref) {
  return ref.watch(posVentasRepoProvider)!.getVentasHoy();
});

/// Tasa de cambio oficial guardada localmente (pos_settings).
final tasaCambioProvider = FutureProvider<double>((ref) {
  return ref.watch(posRepoProvider)!.getTasaCambio();
});

/// Última venta vigente (para el botón "Anular última venta").
final ultimaVentaVigenteProvider = FutureProvider<PosVenta?>((ref) {
  return ref.watch(posVentasRepoProvider)!.getUltimaVentaVigente();
});
