import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/inventario_repository.dart';
import '../../data/inventario_providers.dart';

/// Item individual de la lista de compra con acciones.
class ListaCompraItem extends ConsumerWidget {
  const ListaCompraItem({super.key, required this.item});

  final ComprasListaItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(inventarioRepoProvider);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _parseColor(item.categoriaColor),
          child: Text(item.nombre[0], style: const TextStyle(color: Colors.white)),
        ),
        title: Text(item.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          'Stock: ${item.stockActual.toStringAsFixed(item.esPesable ? 3 : 0)} ${item.unidadMedida}  •  \$${item.precioVenta.toStringAsFixed(2)}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Corregir',
              onPressed: () {
                // TODO: diálogo de corrección
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Registrar entrada',
              onPressed: () {
                // TODO: diálogo de entrada rápida
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Eliminar de lista',
              onPressed: () async {
                await repo.deleteComprasLista(item.productoId);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final v = int.tryParse(hex.replaceFirst('#', '0xFF'));
    return v != null ? Color(v) : Colors.blue;
  }
}