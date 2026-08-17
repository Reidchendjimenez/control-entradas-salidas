import 'package:flutter/material.dart';

/// Estado vacío de la lista de entradas pendientes (porta el bloque vacío de
/// `_load_entradas_pendientes` de validacion_view.py).
class ValidacionEmptyState extends StatelessWidget {
  const ValidacionEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fact_check_outlined, size: 50, color: scheme.outline),
          const SizedBox(height: 12),
          Text(
            'Sin entradas pendientes',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
