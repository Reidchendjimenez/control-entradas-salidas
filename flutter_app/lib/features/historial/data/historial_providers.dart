import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import '../../../core/db/schema/app_database.dart';
import 'historial_repository.dart';

/// Provider compartido del repositorio de historial.
final historialRepoProvider = Provider<HistorialRepository>((ref) {
  return HistorialRepository(ref.watch(appDatabaseProvider));
});

/// Facturas (últimas 100, sin filtros — cada tab filtra en memoria).
final facturasProvider = FutureProvider<List<Factura>>((ref) {
  return ref.watch(historialRepoProvider).getFacturas();
});

/// Entradas por fecha para el tab "Por Fecha".
final porFechaProvider = FutureProvider.autoDispose
    .family<List<EntradaPorFecha>, ({DateTime ini, DateTime fin})>((ref, rango) {
  return ref.watch(historialRepoProvider).getEntradasPorFecha(rango.ini, rango.fin);
});
