import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/producciones_providers.dart';
import '../data/producciones_repository.dart';
import 'widgets/historial_card.dart';

/// Tab Historial: producciones con su estado (completado/cancelada).
class HistorialTab extends ConsumerStatefulWidget {
  const HistorialTab({super.key});

  @override
  ConsumerState<HistorialTab> createState() => _HistorialTabState();
}

class _HistorialTabState extends ConsumerState<HistorialTab> {
  Future<List<HistorialCardData>>? _future;

  @override
  void initState() {
    super.initState();
    _future = _cargar();
  }

  Future<List<HistorialCardData>> _cargar() async {
    final repo = ref.read(produccionesRepoProvider);
    final producciones = await repo.getProducciones();
    final datos = <HistorialCardData>[];
    for (final p in producciones) {
      final detalles = await repo.getDetalles(p.id);
      datos.add(HistorialCardData(
        produccion: p,
        salidas: detalles.where((d) => d.tipo == 'salida').toList(),
        entradas: detalles.where((d) => d.tipo == 'entrada').toList(),
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

    return FutureBuilder<List<HistorialCardData>>(
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
                Icon(Icons.history_outlined, size: 48, color: scheme.outline),
                const SizedBox(height: 10),
                Text('No hay producciones registradas',
                    style: TextStyle(fontSize: 16, color: scheme.outline)),
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
              return HistorialCard(
                produccion: d.produccion,
                salidas: d.salidas,
                entradas: d.entradas,
              );
            },
          ),
        );
      },
    );
  }
}

/// Datos agrupados para el tab historial.
class HistorialCardData {
  const HistorialCardData({
    required this.produccion,
    required this.salidas,
    required this.entradas,
  });

  final ProduccionInfo produccion;
  final List<DetalleInfo> salidas;
  final List<DetalleInfo> entradas;
}
