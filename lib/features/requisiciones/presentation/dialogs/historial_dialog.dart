import 'package:flutter/material.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/requisiciones_repository.dart';

const String _todosAlmacenes = 'TODOS';

const Map<String, (String, Color)> _tipoLabels = {
  'entrada': ('Entrada', Colors.green),
  'salida': ('Salida', Colors.red),
  'ajuste': ('Ajuste', Color(0xFFFB8C00)),
  'tr_entrada': ('Tr. Entrada', Colors.blue),
  'tr_salida': ('Tr. Salida', Colors.indigo),
  'validacion': ('Validación', Colors.green),
  'venta': ('Venta', Colors.green),
  'devolucion': ('Devolución', Colors.blue),
  'entrada_produccion': ('Ent. Producción', Colors.green),
  'salida_produccion': ('Sal. Producción', Colors.red),
};

const Set<String> _tiposSalida = {'salida', 'salida_produccion', 'venta'};

/// Diálogo de historial de movimientos de un producto en auditoría (porta
/// `_show_movimientos_historial` de audit_view.py).
Future<void> showHistorialAuditoria(
  BuildContext context, {
  required RequisicionesRepository repo,
  required int productoId,
  required String nombre,
  required bool esPesable,
}) async {
  final movs = await repo.getMovimientosProducto(productoId);
  if (!context.mounted) return;
  if (movs.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No hay movimientos para este producto')),
    );
    return;
  }

  final almacenes = (movs.map((m) => m.almacen).whereType<String>().toSet()).toList()..sort();
  String seleccion;
  String titulo;
  if (almacenes.length > 1) {
    final elegido = await _preguntarAlmacen(context, nombre, almacenes);
    if (elegido == null || !context.mounted) return;
    seleccion = elegido;
  } else {
    seleccion = almacenes.isEmpty ? _todosAlmacenes : almacenes.first;
  }

  if (seleccion == _todosAlmacenes) {
    titulo = 'Historial: $nombre';
  } else {
    titulo = 'Historial: $nombre - $seleccion';
  }

  final filtrados = seleccion == _todosAlmacenes
      ? movs
      : movs.where((m) => m.almacen == seleccion).toList();
  filtrados.sort(
      (a, b) => (b.fechaMovimiento ?? DateTime(0))
          .compareTo(a.fechaMovimiento ?? DateTime(0)));

  if (!context.mounted) return;
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(titulo),
      content: SizedBox(
        width: 520,
        child: filtrados.isEmpty
            ? const Text('Sin movimientos')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: filtrados.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _MovimientoCard(m: filtrados[i], esPesable: esPesable),
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cerrar'),
        ),
      ],
    ),
  );
}

Future<String?> _preguntarAlmacen(
    BuildContext context, String nombre, List<String> almacenes) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text('Almacén de $nombre'),
      children: [
        for (final a in almacenes)
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, a),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(a),
            ),
          ),
      ],
    ),
  );
}

class _MovimientoCard extends StatelessWidget {
  const _MovimientoCard({required this.m, required this.esPesable});

  final Movimiento m;
  final bool esPesable;

  String _fmt(DateTime? d) {
    if (d == null) return '';
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(d.day)}/${p(d.month)}/${d.year} ${p(d.hour)}:${p(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) =
        _tipoLabels[m.tipo] ?? (m.tipo.isEmpty ? '?' : m.tipo, scheme.outline);

    var cantMedio = m.cantidad;
    var unidadMedio = '';
    if (esPesable && m.tipo != 'ajuste' && m.pesoTotal > 0) {
      cantMedio = m.pesoTotal;
      unidadMedio = 'kg';
    }
    if (_tiposSalida.contains(m.tipo)) {
      cantMedio = -cantMedio.abs();
    }

    final sign = cantMedio >= 0 ? '+' : '';
    final signColor = cantMedio >= 0 ? Colors.green : scheme.error;
    final infoParts = [m.registradoPor ?? '?', if (m.almacen != null) m.almacen!];
    final obs = (m.observaciones ?? '').trim();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_fmt(m.fechaMovimiento),
                  style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration:
                    BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
                child: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Text(
            infoParts.join(' · '),
            style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant),
          ),
          if (obs.isNotEmpty)
            Text(
              obs,
              style: TextStyle(fontSize: 9, color: scheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    m.cantidadAnterior.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                  ),
                ),
                Text('→',
                    style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                Expanded(
                  child: Text(
                    '$sign${cantMedio.toStringAsFixed(1)} $unidadMedio'.trim(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold, color: signColor),
                  ),
                ),
                Text('→',
                    style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant)),
                Expanded(
                  child: Text(
                    m.cantidadNueva.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold, color: scheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
