import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/producciones_providers.dart';

/// Confirmación de eliminar receta (porta `delete_receta_dialog`).
Future<void> showDeleteRecetaDialog(
  BuildContext context,
  WidgetRef ref,
  Receta receta, {
  VoidCallback? onConfirmed,
}) async {
  final repo = ref.read(produccionesRepoProvider);
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Eliminar Receta'),
      content: Text("¿Eliminar '${receta.nombre}'?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Eliminar'),
        ),
      ],
    ),
  );
  if (confirmado != true) return;

  try {
    await repo.eliminarReceta(receta.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receta eliminada')),
      );
    }
    onConfirmed?.call();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e')),
      );
    }
  }
}
