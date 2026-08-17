import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/requisiciones_providers.dart';
import '../../data/requisiciones_repository.dart';

/// Resultado del ajuste de stock durante auditoría.
class AjusteStockResult {
  const AjusteStockResult({
    required this.productoId,
    required this.nuevaCantidad,
    required this.pesoTotal,
  });

  final int productoId;
  final double nuevaCantidad;
  final double? pesoTotal;
}

/// Diálogo de ajuste de stock en auditoría (porta `_show_adjust_dialog` de
/// audit_view.py). Devuelve [AjusteStockResult] o `null`.
Future<AjusteStockResult?> showAjusteAuditoriaDialog(
  BuildContext context, {
  required AuditItem item,
  required String almacen,
}) {
  return showDialog<AjusteStockResult>(
    context: context,
    builder: (ctx) => _AjusteDialog(item: item, almacen: almacen),
  );
}

class _AjusteDialog extends ConsumerStatefulWidget {
  const _AjusteDialog({required this.item, required this.almacen});

  final AuditItem item;
  final String almacen;

  @override
  ConsumerState<_AjusteDialog> createState() => _AjusteDialogState();
}

class _AjusteDialogState extends ConsumerState<_AjusteDialog> {
  final _cantUndCtrl = TextEditingController(text: '1');
  final _pesoUndCtrl = TextEditingController(text: '0.100');
  final _pesoTotalCtrl = TextEditingController();
  final _finalCtrl = TextEditingController();
  final _inicialCtrl = TextEditingController();
  bool _esPesable = false;

  double get _inicial => widget.item.origen.inicial;
  double get _trasladada => widget.item.origen.trasladada;

  @override
  void initState() {
    super.initState();
    final finalActual = _inicial - _trasladada;
    _pesoTotalCtrl.text = _inicial.toStringAsFixed(3);
    _finalCtrl.text = finalActual.toStringAsFixed(3);
    _inicialCtrl.text = _inicial.toInt().toString();
    _cargarProducto();
  }

  @override
  void dispose() {
    _cantUndCtrl.dispose();
    _pesoUndCtrl.dispose();
    _pesoTotalCtrl.dispose();
    _finalCtrl.dispose();
    _inicialCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarProducto() async {
    final repo = ref.read(requisicionesRepoProvider);
    final p = await repo.getProducto(widget.item.productoId ?? -1);
    if (mounted && p != null) {
      setState(() => _esPesable = p.esPesable == 1);
    }
  }

  void _recalcDesdePesoTotal() {
    try {
      final pt = double.tryParse(_pesoTotalCtrl.text.replaceAll(',', '.')) ?? 0;
      _finalCtrl.text = (pt - _trasladada).toStringAsFixed(3);
    } catch (_) {}
  }

  void _calcularDesdeUnidades() {
    try {
      final cant = double.tryParse(_cantUndCtrl.text) ?? 0;
      final pu = double.tryParse(_pesoUndCtrl.text.replaceAll(',', '.')) ?? 0;
      _pesoTotalCtrl.text = (cant * pu).toStringAsFixed(3);
      _recalcDesdePesoTotal();
    } catch (_) {
      _pesoTotalCtrl.text = '0.000';
      _recalcDesdePesoTotal();
    }
  }

  void _calcularDesdeTotal() {
    try {
      final total = double.tryParse(_pesoTotalCtrl.text.replaceAll(',', '.')) ?? 0;
      final cant = double.tryParse(_cantUndCtrl.text) ?? 1;
      if (cant > 0) {
        _pesoUndCtrl.text = (total / cant).toStringAsFixed(3);
      }
      _recalcDesdePesoTotal();
    } catch (_) {}
  }

  void _onFinalChange() {
    try {
      final nuevoFinal = double.tryParse(_finalCtrl.text.replaceAll(',', '.')) ?? 0;
      final nuevoInicial = nuevoFinal + _trasladada;
      _pesoTotalCtrl.text = nuevoInicial.toStringAsFixed(3);
      final cantU = double.tryParse(_cantUndCtrl.text) ?? 1;
      if (cantU > 0) {
        _pesoUndCtrl.text = (nuevoInicial / cantU).toStringAsFixed(3);
      }
    } catch (_) {}
  }

  void _onInicialChange() {
    try {
      final inic = double.tryParse(_inicialCtrl.text) ?? 0;
      _finalCtrl.text = (inic - _trasladada).toStringAsFixed(0);
    } catch (_) {}
  }

  void _onFinalChangeNoPesable() {
    try {
      final fin = double.tryParse(_finalCtrl.text) ?? 0;
      _inicialCtrl.text = (fin + _trasladada).toInt().toString();
    } catch (_) {}
  }

  Future<void> _aceptar() async {
    final repo = ref.read(requisicionesRepoProvider);
    final p = widget.item.productoId ?? -1;
    if (_esPesable) {
      final pesoTotal = double.tryParse(_pesoTotalCtrl.text.replaceAll(',', '.')) ?? -1;
      if (pesoTotal <= 0) {
        _snack('El peso debe ser mayor a 0');
        return;
      }
      await repo.crearAjusteStock(
        productoId: p,
        almacen: widget.almacen,
        nuevaCantidad: pesoTotal,
        motivo: 'Ajuste durante auditoría',
        pesoTotal: pesoTotal,
      );
      if (mounted) {
        Navigator.pop(context, AjusteStockResult(
          productoId: p,
          nuevaCantidad: pesoTotal,
          pesoTotal: pesoTotal,
        ));
      }
    } else {
      final nuevaQty = double.tryParse(_inicialCtrl.text) ?? -1;
      if (nuevaQty < 0) {
        _snack('La cantidad no puede ser negativa');
        return;
      }
      await repo.crearAjusteStock(
        productoId: p,
        almacen: widget.almacen,
        nuevaCantidad: nuevaQty,
        motivo: 'Ajuste durante auditoría',
      );
      if (mounted) {
        Navigator.pop(context, AjusteStockResult(
          productoId: p,
          nuevaCantidad: nuevaQty,
          pesoTotal: null,
        ));
      }
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final campos = _esPesable
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Trasladada: ${_trasladada.toStringAsFixed(3)} kg',
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cantUndCtrl,
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
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pesoTotalCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Peso Inicial',
                          border: OutlineInputBorder(),
                          suffixText: 'kg'),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (_) => setState(_calcularDesdeTotal),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _finalCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Stock Final',
                          border: OutlineInputBorder(),
                          suffixText: 'kg'),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      onChanged: (_) => setState(_onFinalChange),
                    ),
                  ),
                ],
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cantidad a trasladar: ${_trasladada.toInt()}',
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inicialCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Stock Inicial',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(_onInicialChange),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _finalCtrl,
                      decoration: const InputDecoration(
                          labelText: 'Stock Final',
                          border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(_onFinalChangeNoPesable),
                    ),
                  ),
                ],
              ),
            ],
          );

    return AlertDialog(
      title: Text('Ajustar ${widget.item.ingrediente}'),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock actual: ${_inicial.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            campos,
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _aceptar, child: const Text('Aceptar')),
      ],
    );
  }
}
