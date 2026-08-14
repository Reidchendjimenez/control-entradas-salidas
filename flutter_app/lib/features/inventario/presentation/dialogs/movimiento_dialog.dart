import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/inventario_providers.dart';

/// Diálogo para registrar movimiento (entrada/salida/ajuste) con soporte pesable.
Future<void> showMovimientoDialog(BuildContext context, WidgetRef ref, Producto p) async {
  final repo = ref.read(inventarioRepoProvider);
  final existencias = await repo.getExistenciasByProducto(p.id);
  final almacenes = existencias.map((e) => e.almacen).toSet().toList();
  if (!almacenes.contains('principal')) almacenes.add('principal');

  String tipo = 'entrada';
  String? almacen = p.almacenPredeterminado;
  if (!almacenes.contains(almacen)) almacen = almacenes.first;

  await showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setSt) => AlertDialog(
        title: Text(p.nombre),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'entrada', label: Text('Entrada'), icon: Icon(Icons.input)),
                  ButtonSegment(value: 'salida', label: Text('Salida'), icon: Icon(Icons.output)),
                  ButtonSegment(value: 'ajuste', label: Text('Ajuste'), icon: Icon(Icons.tune)),
                ],
                selected: {tipo},
                onSelectionChanged: (s) => setSt(() => tipo = s.first),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Almacén'),
                value: almacen,
                items: [
                  for (final a in almacenes) DropdownMenuItem(value: a, child: Text(a.capitalize())),
                ],
                onChanged: (v) => setSt(() => almacen = v),
              ),
              const SizedBox(height: 12),
              _StockInfoPanel(existencias: existencias),
              const SizedBox(height: 12),
              if (p.esPesable != 1)
                TextField(
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  controller: TextEditingController(text: '1'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                )
              else ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Und.'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'Kg/und.'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(labelText: 'Peso Total (kg)', suffixText: 'kg'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Movimiento registrado')),
              );
            },
            child: const Text('Registrar'),
          ),
        ],
      ),
    ),
  );
}

/// Panel de stock por almacén dentro del diálogo de movimiento.
class _StockInfoPanel extends StatelessWidget {
  const _StockInfoPanel({required this.existencias});

  final List<Existencia> existencias;

  @override
  Widget build(BuildContext context) {
    if (existencias.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Sin stock registrado', style: TextStyle(fontSize: 12)),
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '���� Stock por almacén:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (final e in existencias)
                Text(
                  '${e.almacen.capitalize()}: ${e.cantidad.toStringAsFixed(e.cantidad % 1 == 0 ? 0 : 2)} ${e.unidad}',
                  style: const TextStyle(fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

extension _StringCapitalize on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}