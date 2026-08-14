import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/requisiciones_providers.dart';

/// Tarjeta de requisición en la lista (porta `build_requisicion_card`).
/// Icono, número, origen→destino, badge de estado, items y acciones
/// según el estado de la requisición.
class RequisicionCard extends ConsumerWidget {
  const RequisicionCard({
    super.key,
    required this.req,
    required this.onVisualizar,
    required this.onEditar,
    required this.onAuditar,
    required this.onEliminar,
  });

  final Requisicione req;
  final VoidCallback onVisualizar;
  final VoidCallback onEditar;
  final VoidCallback onAuditar;
  final VoidCallback onEliminar;

  Color _estadoColor(ColorScheme scheme) {
    switch (req.estado) {
      case 'pendiente':
        return const Color(0xFFFB8C00);
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return scheme.error;
      default:
        return scheme.onSurfaceVariant;
    }
  }

  String _fmtFecha(DateTime? d) {
    if (d == null) return '';
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(d.day)}/${p(d.month)}/${d.year} ${p(d.hour)}:${p(d.minute)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final repo = ref.watch(requisicionesRepoProvider);
    final esPendiente = req.estado == 'pendiente';
    final estadoColor = _estadoColor(scheme);

    return InkWell(
      onTap: onVisualizar,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.assignment_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${req.numero}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${req.origen} → ${req.destino}',
                        style: TextStyle(
                            fontSize: 12, color: scheme.onSurfaceVariant),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: estadoColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        req.estado.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    FutureBuilder<int>(
                      future: repo.contarDetalles(req.id),
                      builder: (context, snap) => Text(
                        '${snap.data ?? 0} items',
                        style: TextStyle(
                            fontSize: 11, color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(height: 12, color: scheme.outlineVariant),
            Text(
              'Creada: ${_fmtFecha(req.fechaCreacion).isEmpty ? '-' : _fmtFecha(req.fechaCreacion)}',
              style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  tooltip: 'Visualizar',
                  color: scheme.onSurfaceVariant,
                  visualDensity: VisualDensity.compact,
                  onPressed: onVisualizar,
                ),
                if (esPendiente) ...[
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    tooltip: 'Editar',
                    color: scheme.onSurfaceVariant,
                    visualDensity: VisualDensity.compact,
                    onPressed: onEditar,
                  ),
                  IconButton(
                    icon: const Icon(Icons.fact_check_outlined, size: 18),
                    tooltip: 'Auditar',
                    color: scheme.primary,
                    visualDensity: VisualDensity.compact,
                    onPressed: onAuditar,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    tooltip: 'Eliminar',
                    color: scheme.error,
                    visualDensity: VisualDensity.compact,
                    onPressed: onEliminar,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
