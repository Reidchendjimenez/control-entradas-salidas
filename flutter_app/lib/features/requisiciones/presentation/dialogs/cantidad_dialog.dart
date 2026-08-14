import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/requisiciones_providers.dart';
import '../../data/requisiciones_repository.dart';

/// Resultado del diálogo de cantidad (porta `build_agregar_producto_req_dialog`).
class CantidadProductoResult {
  const CantidadProductoResult({
    required this.item,
    required this.peso,
  });

  final RequisicionItem item;
  final double peso;
}

/// Diálogo para indicar cantidad de un producto en la requisición.
/// Para pesables: Und. + Kg/unidad + Peso Total con cálculo en vivo.
Future<CantidadProductoResult?> showCantidadDialog(
  BuildContext context, {
  required Producto producto,
  required String origen,
}) {
  return showDialog<CantidadProductoResult>(
    context: context,
    builder: (ctx) => _CantidadDialog(producto: producto, origen: origen),
  );
}

class _CantidadDialog extends ConsumerStatefulWidget {
  const _CantidadDialog({required this.producto, required this.origen});

  final Producto producto;
  final String origen;

  @override
  ConsumerState<_CantidadDialog> createState() => _CantidadDialogState();
}

class _CantidadDialogState extends ConsumerState<_CantidadDialog> {
  final _cantUndCtrl = TextEditingController(text: '1');
  final _pesoUndCtrl = TextEditingController(text: '0.100');
  final _pesoTotalCtrl = TextEditingController(text: '0.000');
  final _cantCtrl = TextEditingController(text: '1');
  double _disponible = 0;
  bool _cargado = false;

  bool get _esPesable => widget.producto.esPesable == 1;

  @override
  void initState() {
    super.initState();
    _cargarDisponible();
  }

  @override
  void dispose() {
    _cantUndCtrl.dispose();
    _pesoUndCtrl.dispose();
    _pesoTotalCtrl.dispose();
    _cantCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDisponible() async {
    final repo = ref.read(requisicionesRepoProvider);
    final disp =
        await repo.getExistencia(widget.producto.id, widget.origen);
    if (mounted) {
      setState(() {
        _disponible = disp;
        _cargado = true;
      });
    }
  }

  void _calcularDesdeUnidades() {
    try {
      final cant = double.tryParse(_cantUndCtrl.text) ?? 0;
      final pesoU =
          double.tryParse(_pesoUndCtrl.text.replaceAll(',', '.')) ?? 0;
      _pesoTotalCtrl.text = (cant * pesoU).toStringAsFixed(3);
    } catch (_) {
      _pesoTotalCtrl.text = '0.000';
    }
  }

  void _calcularDesdeTotal() {
    try {
      final total = double.tryParse(_pesoTotalCtrl.text.replaceAll(',', '.')) ?? 0;
      final cant = double.tryParse(_cantUndCtrl.text) ?? 0;
      if (cant > 0) {
        _pesoUndCtrl.text = (total / cant).toStringAsFixed(3);
      }
    } catch (_) {}
  }

  void _agregar() {
    final p = widget.producto;
    double peso = 0;
    RequisicionItem? item;
    final unidad = p.unidadMedida.isEmpty ? 'uds' : p.unidadMedida;

    if (_esPesable) {
      final cantUnd = int.tryParse(_cantUndCtrl.text
              .replaceAll(',', '')
              .replaceAll(' ', '')) ??
          -1;
      final pesoTotal =
          double.tryParse(_pesoTotalCtrl.text.replaceAll(',', '.')) ?? -1;
      if (cantUnd <= 0) {
        _snack('Número mayor a 0');
        return;
      }
      if (pesoTotal < 0) {
        _snack('Peso válido mayor a 0');
        return;
      }
      peso = pesoTotal;
      item = RequisicionItem(
        productoId: p.id,
        ingrediente: p.nombre,
        cantidad: peso,
        unidad: unidad,
        peso: peso,
        esPesable: true,
      );
    } else {
      final cant =
          int.tryParse(_cantCtrl.text.replaceAll(',', '').replaceAll(' ', '')) ??
              -1;
      if (cant <= 0) {
        _snack('Número entero mayor a 0');
        return;
      }
      item = RequisicionItem(
        productoId: p.id,
        ingrediente: p.nombre,
        cantidad: cant.toDouble(),
        unidad: unidad,
        esPesable: false,
      );
    }

    Navigator.pop(context, CantidadProductoResult(item: item, peso: peso));
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final p = widget.producto;
    final unidad = p.unidadMedida.isEmpty ? 'uds' : p.unidadMedida;
    final stockColor =
        _disponible > 0 ? Colors.green.shade700 : scheme.error;
    final isMobile = MediaQuery.of(context).size.width < 700;

    Widget stockInfo = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.inventory_2_rounded, size: 16, color: stockColor),
          const SizedBox(width: 5),
          Text(
            'Disponible: ${_disponible.toStringAsFixed(2)} $unidad',
            style: TextStyle(
                fontSize: 12, color: stockColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

    final campos = _esPesable
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cantUndCtrl,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: 'Und.', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(_calcularDesdeUnidades),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _pesoUndCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Kg/unidad', border: OutlineInputBorder()),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (_) => setState(_calcularDesdeUnidades),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _pesoTotalCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Peso Total',
                          border: OutlineInputBorder(),
                          suffixText: 'kg'),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (_) => setState(_calcularDesdeTotal),
                    ),
                  ),
                ],
              ),
            ],
          )
        : TextField(
            controller: _cantCtrl,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: 'Cantidad', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          );

    return AlertDialog(
      title: Text('Agregar: ${p.nombre}'),
      content: SizedBox(
        width: isMobile ? 420 : 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_cargado) stockInfo,
            const SizedBox(height: 10),
            Text('Unidad: $unidad',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 5),
            campos,
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(onPressed: _agregar, child: const Text('Agregar')),
      ],
    );
  }
}
