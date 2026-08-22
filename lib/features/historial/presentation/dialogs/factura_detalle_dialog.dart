import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/historial_providers.dart';
import '../../data/historial_repository.dart';

/// Detalle de una factura (porta `_show_factura_detalle` de
/// `historial_facturas_view.py`): proveedor, productos registrados
/// (movimientos + archivados) y total neto.
Future<void> showFacturaDetalleDialog(BuildContext context, int facturaId) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => _FacturaDetalleDialog(facturaId: facturaId),
  );
}

class _FacturaDetalleDialog extends ConsumerStatefulWidget {
  const _FacturaDetalleDialog({required this.facturaId});

  final int facturaId;

  @override
  ConsumerState<_FacturaDetalleDialog> createState() => _FacturaDetalleDialogState();
}

class _FacturaDetalleDialogState extends ConsumerState<_FacturaDetalleDialog> {
  late final Future<FacturaDetalle> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(historialRepoProvider)!.getFacturaDetalle(widget.facturaId);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Detalle Factura'),
      content: FutureBuilder<FacturaDetalle>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snap.hasError) {
              return Text('Error: ${snap.error}',
                  style: TextStyle(color: scheme.error));
            }
            final d = snap.data!;
            final f = d.factura;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proveedor: ${(f['proveedor'] as String?) ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const Divider(height: 20),
                Text(
                  'Productos registrados:',
                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                if (d.items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text('Sin productos', style: TextStyle(color: scheme.onSurfaceVariant)),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: d.items.length,
                      itemBuilder: (context, i) {
                        final item = d.items[i];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            item.archivado
                                ? Icons.archive_outlined
                                : Icons.inventory_2_outlined,
                            size: 20,
                            color: item.archivado ? scheme.tertiary : scheme.primary,
                          ),
                          title: Text(item.nombre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            '${item.cantidadTexto}${item.archivado ? ' (archivado)' : ''}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        );
                      },
                    ),
                  ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL NETO:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      '\$${((f['total_neto'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 18),
                    ),
                  ],
                ),
                if (d.pagos.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  for (final p in d.pagos)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${_tipoPagoLabel((p['tipo_pago'] as String?) ?? '')}: \$${((p['monto'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)}'
                        '${p['tasa_cambio'] != null ? '  (tasa ${((p['tasa_cambio'] as num?)?.toDouble() ?? 0).toStringAsFixed(2)})' : ''}',
                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
      ],
    );
  }

  String _tipoPagoLabel(String tipo) {
    switch (tipo) {
      case 'efectivo':
        return 'Efectivo';
      case 'transferencia':
        return 'Transferencia';
      case 'divisas':
        return 'Divisas';
      default:
        return tipo;
    }
  }
}
