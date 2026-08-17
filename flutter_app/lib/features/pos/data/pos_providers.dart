import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/schema/app_database.dart';
import '../../../core/network/supabase_client.dart';
import '../../../core/sync/pos_sync_engine.dart';
import '../../../core/sync/sync_status.dart';
import 'pos_comanda_models.dart';
import 'pos_repository.dart';
import 'pos_ventas_repository.dart';

/// Repositorio de catálogos/settings/sesiones del POS.
final posRepoProvider = Provider<PosRepository>((ref) {
  return PosRepository(ref.watch(appDatabaseProvider));
});

/// Repositorio de comandas/ventas del POS.
final posVentasRepoProvider = Provider<PosVentasRepository>((ref) {
  return PosVentasRepository(ref.watch(appDatabaseProvider));
});

/// Motor de sync POS (null si Supabase no está configurado). Port de
/// `POSSyncManager` (pos_sync.py): sube el outbox `pos_*`/`platos_*` por
/// sync_uuid y descarga las 11 tablas con poda de huérfanos.
final posSyncEngineProvider = Provider<PosSyncEngine?>((ref) {
  final client = ref.watch(supabaseProvider);
  if (client == null) return null;
  final engine = PosSyncEngine(db: ref.watch(appDatabaseProvider), client: client);
  engine.onProgress = (msg) {
    print('[pos-sync] $msg');
    ref.read(syncStatusProvider.notifier).progreso(SyncOrigen.pos, msg);
  };
  return engine;
});

// ---------------------------------------------------------------------------
// Providers de datos para la UI del POS (compartidos entre pantallas).
// ---------------------------------------------------------------------------

final mesasProvider = FutureProvider<List<PosMesa>>((ref) {
  return ref.watch(posRepoProvider).getMesas(soloActivos: true);
});

final habitacionesProvider = FutureProvider<List<PosHabitacione>>((ref) {
  return ref.watch(posRepoProvider).getHabitaciones(soloActivos: true);
});

final usuariosProvider = FutureProvider<List<PosUsuario>>((ref) {
  return ref.watch(posRepoProvider).getUsuarios();
});

final platosProvider = FutureProvider<List<Plato>>((ref) {
  return ref.watch(posRepoProvider).getPlatos(soloActivos: true);
});

final comandasAbiertasProvider = FutureProvider<List<PosComanda>>((ref) {
  return ref.watch(posVentasRepoProvider).getComandasAbiertas();
});

/// Mesas con comanda abierta (reactivo: se actualiza ante cambios en
/// `pos_comandas`, para marcar Ocupada en el grid y el home).
final mesasOcupadasProvider = StreamProvider<Set<int>>((ref) {
  return ref.watch(posVentasRepoProvider).watchMesasOcupadas();
});

/// Comandas abiertas enriquecidas (etiqueta, total, items) para retomarlas
/// desde el home del POS (reactivo).
final comandasActivasProvider = StreamProvider<List<ComandaActiva>>((ref) {
  return ref.watch(posVentasRepoProvider).watchComandasActivas();
});

/// Habitaciones con comanda abierta (reactivo).
final habitacionesOcupadasProvider = StreamProvider<Set<int>>((ref) {
  return ref.watch(posVentasRepoProvider).watchHabitacionesOcupadas();
});

/// Historial de ventas (más recientes primero), se invalida al cobrar/anular.
final ventasProvider = FutureProvider<List<PosVenta>>((ref) {
  return ref.watch(posVentasRepoProvider).getVentas(limit: 200);
});

/// Resumen de ventas vigentes del día (cantidad + total) para el home del POS
/// (reactivo).
final ventasHoyProvider =
    StreamProvider<({int cantidad, double total})>((ref) {
  return ref.watch(posVentasRepoProvider).watchVentasHoy();
});

/// Tasa de cambio oficial guardada localmente (reactiva, pos_settings).
final tasaCambioProvider = StreamProvider<double>((ref) {
  return ref.watch(posRepoProvider).watchTasaCambio();
});

/// Última venta vigente (para el botón "Anular última venta").
final ultimaVentaVigenteProvider = FutureProvider<PosVenta?>((ref) {
  return ref.watch(posVentasRepoProvider).getUltimaVentaVigente();
});
