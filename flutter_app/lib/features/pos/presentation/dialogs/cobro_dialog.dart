import 'package:flutter/material.dart';

import '../../data/pos_comanda_models.dart';

/// Confirmación de cobro (Fase 6.4): muestra el total en USD/Bs y pide
/// confirmación antes de registrar la venta y cerrar la comanda.
class CobroDialog extends StatelessWidget {
  const CobroDialog({
    super.key,
    required this.total,
    required this.tasa,
    required this.tasaFecha,
    required this.ubicacion,
    required this.onConfirm,
  });

  final double total;
  final double tasa;
  final String tasaFecha;
  final String ubicacion;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Cobrar comanda'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.table_bar_outlined, size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(ubicacion, style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Total a cobrar',
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
          ),
          if (tasa > 0) ...[
            const SizedBox(height: 4),
            Text('Bs ${formatearBs(total * tasa)}',
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF26A69A))),
            const SizedBox(height: 2),
            Text('Tasa ${formatearTasa(tasa)} Bs/\$'
                '${tasaFecha.isNotEmpty ? ' · $tasaFecha' : ''}',
                style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ],
          const SizedBox(height: 12),
          Text(
            'Se registrará la venta y se cerrará la comanda.',
            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          style: FilledButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          icon: const Icon(Icons.payments_outlined),
          label: const Text('Cobrar'),
        ),
      ],
    );
  }
}
