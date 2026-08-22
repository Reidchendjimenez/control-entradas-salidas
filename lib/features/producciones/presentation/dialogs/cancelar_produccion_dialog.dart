import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/receta.dart';
import '../../data/producciones_providers.dart';
import '../../data/producciones_repository.dart';

/// Confirmación de cancelar producción (porta `cancelar_produccion_dialog`).
/// Revierte el stock del producto final (las entradas del lote se anulan).
Future<void> showCancelarProduccionDialog(
  BuildContext context,
  WidgetRef ref,
  ProduccionInfo produccion,
  Receta receta, {
  VoidCallback? onConfirmed,
}) async {
  final repo = ref.read(produccionesRepoProvider)!;
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Cancelar Producción'),
      content: Text(
        '¿Cancelar la producción #${produccion.id} de '
        "'${receta.nombre}'?\n\n"
        'Se revertirá el stock del producto final (la entrada original se anula).',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('No cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(ctx).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Sí, cancelar'),
        ),
      ],
    ),
  );
  if (confirmado != true) return;

  try {
    await repo.cancelarProduccion(produccion, receta);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Producción #${produccion.id} cancelada y stock revertido')),
      );
    }
    onConfirmed?.call();
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cancelar: $e')),
      );
    }
  }
}
