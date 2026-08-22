import 'package:flutter/material.dart';

import '../../../../core/models/producto.dart';

/// Card de producto con stock, precio y acciones.
class ProductoCard extends StatelessWidget {
  const ProductoCard({
    super.key,
    required this.producto,
    required this.onMovimiento,
    required this.onToggleLista,
    required this.onCorregir,
    this.seleccionado = false,
  });

  final Producto producto;
  final void Function(Producto) onMovimiento;
  final void Function(Producto) onToggleLista;
  final void Function(Producto) onCorregir;
  final bool seleccionado;

  Color _parseColor(String hex) {
    final v = int.tryParse(hex.replaceFirst('#', '0xFF'));
    return v != null ? Color(v) : Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final stock = producto.stockActual;
    final decimales = producto.esPesable ? 3 : 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: seleccionado ? colors.primaryContainer : null,
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
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(producto.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(
                      '${producto.unidadMedida} • \$${producto.precioVenta.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontSize: 12, color: colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Text(
                stock.toStringAsFixed(decimales),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      stock <= producto.stockMinimo ? colors.error : colors.primary,
                ),
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
                  const PopupMenuItem(
                      value: 'lista', child: Text('Agregar a lista de compra')),
                  const PopupMenuItem(
                      value: 'corregir', child: Text('Corregir stock')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}