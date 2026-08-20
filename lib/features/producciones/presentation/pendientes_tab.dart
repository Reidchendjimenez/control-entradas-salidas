import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../data/producciones_providers.dart';
import '../data/producciones_repository.dart';
import 'dialogs/cancelar_produccion_dialog.dart';
import 'dialogs/descargo_dialog.dart';
import 'widgets/pendiente_card.dart';

/// Tab En Producción: producciones pendientes con acciones Descargar/Cancelar.
class PendientesTab extends ConsumerStatefulWidget {
  const PendientesTab({super.key});

  @override
  ConsumerState<PendientesTab> createState() => _PendientesTabState();
}

class _PendientesTabState extends ConsumerState<PendientesTab> {
  Future<List<PendienteCardData>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _cargar();
  }

  Future<List<PendienteCardData>> _cargar() async {
    final repo = ref.read(produccionesRepoProvider);
    final pendientes = await repo.getProduccionesPorEstado('pendiente');
    final recetas = await repo.getRecetas();
    final recetaPorId = {for (final r in recetas) r.id: r};

    final datos = <PendienteCardData>[];
    for (final p in pendientes) {
      final receta = recetaPorId[p.recetaId];
      if (receta == null) continue;
      final entradas = (await repo.getDetalles(p.id))
          .where((d) => d.tipo == 'entrada')
          .toList();
      datos.add(PendienteCardData(
        produccion: p,
        receta: receta,
        entradas: entradas,
      ));
    }
    return datos;
  }

  void _refresh() {
    setState(() => _future = _cargar());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<List<PendienteCardData>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        final datos = snap.data!;
        if (datos.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_outline,
                    size: 48, color: scheme.outline),
                const SizedBox(height: 10),
                Text('Sin producciones pendientes',
                    style: TextStyle(fontSize: 16, color: scheme.outline)),
                const SizedBox(height: 4),
                Text(
                  'Las producciones se crean desde Inventario al hacer una entrada de producción',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: scheme.outline),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => _refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: datos.length,
            itemBuilder: (context, i) {
              final d = datos[i];
              return PendienteCard(
                produccion: d.produccion,
                entradas: d.entradas,
                onDescargar: () => showDescargoDialog(
                  context,
                  ref,
                  d.produccion,
                  d.receta,
                  onCompleted: _refresh,
                ),
                onCancelar: () => showCancelarProduccionDialog(
                  context,
                  ref,
                  d.produccion,
                  d.receta,
                  onConfirmed: _refresh,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/// Datos agrupados para el tab pendientes.
class PendienteCardData {
  const PendienteCardData({
    required this.produccion,
    required this.receta,
    required this.entradas,
  });

  final ProduccionInfo produccion;
  final Receta receta;
  final List<DetalleInfo> entradas;
}
