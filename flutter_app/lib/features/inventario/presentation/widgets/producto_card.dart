import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/inventario_repository.dart';

/// Card de producto con stock, precio y acciones.
class ProductoCard extends ConsumerWidget {
  const ProductoCard({
    super.key,
    required this.producto,
    required this.repo,
    required this.onMovimiento,
    required this.onToggleLista,
    required this.onCorregir,
    this.seleccionado = false,
  });

  final Producto producto;
  final InventarioRepository repo;
  final void Function(Producto) onMovimiento;
  final void Function(Producto) onToggleLista;
  final void Function(Producto) onCorregir;
  final bool seleccionado;

  Color _parseColor(String hex) {
    final v = int.tryParse(hex.replaceFirst('#', '0xFF'));
    return v != null ? Color(v) : Colors.blue;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: seleccionado
          ? colors.primaryContainer
          : null,
      shape: seleccionado
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: colors.primary, width: 2),
            )
          : null,
      child: InkWell(
        onTap: () => onMovimiento(producto),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: _parseColor(''),
                child: Text(
                  producto.nombre.isNotEmpty ? producto.nombre[0] : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(producto.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      '${producto.unidadMedida} • \$${producto.precioVenta.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<Existencia>>(
                future: repo.getExistenciasByProducto(producto.id),
                builder: (context, snap) {
                  final total = (snap.data ?? [])
                      .fold<double>(0, (a, e) => a + e.cantidad);
                  return Text(
                    total.toStringAsFixed(producto.esPesable == 1 ? 3 : 0),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: total <= (producto.stockMinimo) ? colors.error : colors.primary,
                    ),
                  );
                },
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  switch (v) {
                    case 'lista':
                      onToggleLista(producto);
                      break;
                    case 'corregir':
                      onCorregir(producto);
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem(value: 'lista', child: Text('Agregar a lista de compra')),
                  const PopupMenuItem(value: 'corregir', child: Text('Corregir stock')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}