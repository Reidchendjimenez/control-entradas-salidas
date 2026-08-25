import 'package:flutter/material.dart';

class FacturaCard extends StatelessWidget {
  const FacturaCard({super.key, required this.factura, required this.onTap});

  final Map<String, dynamic> factura;
  final VoidCallback onTap;

  String _fmtFecha(DateTime? d) {
    if (d == null) return '';
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(d.day)}/${p(d.month)}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final f = factura;
    final estado = (f['estado'] as String?) ?? '';
    final esValidada = estado == 'Validada';
    final estadoColor = esValidada ? Colors.green : scheme.tertiary;
    final numero = (f['numero_factura'] as String?) ?? 'Sin número';
    final proveedor = (f['proveedor'] as String?) ?? '';
    final ff = DateTime.tryParse(f['fecha_factura']?.toString() ?? '');
    final totalNeto = (f['total_neto'] as num?)?.toDouble() ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt_long_outlined,
                      color: scheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '#$numero',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _estadoBadge(estado, estadoColor),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                proveedor.trim().isNotEmpty
                    ? proveedor
                    : 'Proveedor No Identificado',
                style:
                    TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _fmtFecha(ff),
                      style: TextStyle(
                          fontSize: 11, color: scheme.onSurfaceVariant),
                    ),
                  ),
                  Text(
                    '\$${totalNeto.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _estadoBadge(String estado, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        estado,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
