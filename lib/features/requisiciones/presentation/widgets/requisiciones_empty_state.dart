import 'package:flutter/material.dart';

/// Estado vacío de la lista de requisiciones (porta `build_empty_state`).
class RequisicionesEmptyState extends StatelessWidget {
  const RequisicionesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 50, color: scheme.outline),
          const SizedBox(height: 8),
          Text('No hay requisiciones',
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
