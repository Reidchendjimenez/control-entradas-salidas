import 'package:flutter/material.dart';

import '../../data/validacion_repository.dart';

/// Panel de distribución de pago (porta `PaymentsManager` de payments.py).
/// Muestra los métodos de pago (transferencia/efectivo/divisas), la lista de
/// pagos agregados y el resumen de faltante vs. el monto total.
class PagosPanel extends StatefulWidget {
  const PagosPanel({super.key});

  @override
  State<PagosPanel> createState() => PagosPanelState();
}

class PagosPanelState extends State<PagosPanel> {
  final List<PagoData> _pagos = [];
  double _faltante = 0;

  String? _metodoActivo;

  final _transferenciaMonto = TextEditingController();
  final _transferenciaRef = TextEditingController();
  final _efectivoMonto = TextEditingController();
  final _divisasTasa = TextEditingController(text: '50');
  final _divisasMonto = TextEditingController();

  @override
  void dispose() {
    _transferenciaMonto.dispose();
    _transferenciaRef.dispose();
    _efectivoMonto.dispose();
    _divisasTasa.dispose();
    _divisasMonto.dispose();
    super.dispose();
  }

  List<PagoData> get pagos => List.unmodifiable(_pagos);

  void setMontoTotal(double monto) {
    _faltante = monto - _pagos.fold(0.0, (s, p) => s + p.monto);
  }

  void _abrirPanel(String metodo) {
    final faltante = _faltante < 0 ? 0.0 : _faltante;
    if (metodo == 'transferencia') {
      _transferenciaMonto.text = faltante > 0 ? faltante.round().toString() : '';
      _transferenciaRef.clear();
    } else if (metodo == 'efectivo') {
      _efectivoMonto.text = faltante > 0 ? faltante.round().toString() : '';
    } else {
      final tasa = double.tryParse(_divisasTasa.text) ?? 50;
      final usd = tasa > 0 ? faltante / tasa : 0;
      _divisasMonto.text = usd > 0 ? usd.toStringAsFixed(2) : '';
    }
    setState(() => _metodoActivo = metodo);
  }

  void _agregarPago() {
    double monto = 0;
    String ref = '';
    double tasa = 1;
    String tipo = '';

    if (_metodoActivo == 'transferencia') {
      tipo = 'transferencia';
      monto = _parse(_transferenciaMonto.text);
      ref = _transferenciaRef.text.trim();
      _transferenciaMonto.clear();
      _transferenciaRef.clear();
    } else if (_metodoActivo == 'efectivo') {
      tipo = 'efectivo';
      monto = _parse(_efectivoMonto.text);
      _efectivoMonto.clear();
    } else {
      tipo = 'divisas';
      tasa = _parse(_divisasTasa.text) == 0 ? 1 : _parse(_divisasTasa.text);
      final usd = _parse(_divisasMonto.text);
      monto = usd * tasa;
      _divisasMonto.clear();
    }

    if (monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un monto mayor a cero')),
      );
      return;
    }

    setState(() {
      _pagos.add(PagoData(tipo: tipo, monto: monto, ref: ref, tasa: tasa));
      _faltante -= monto;
      _metodoActivo = null;
    });
  }

  void _eliminarPago(int index) {
    setState(() {
      final p = _pagos.removeAt(index);
      _faltante += p.monto;
    });
  }

  double _parse(String v) => double.tryParse(v.trim()) ?? 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _section(
      scheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.payments, size: 20, color: scheme.primary),
              const SizedBox(width: 8),
              const Text('Distribución de Pago',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _metodoButton('Transferencia', Icons.account_balance,
                    'transferencia', scheme),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _metodoButton('Efectivo', Icons.payments, 'efectivo', scheme),
              ),
              const SizedBox(width: 8),
              Expanded(
                child:
                    _metodoButton('Divisas', Icons.currency_exchange, 'divisas', scheme),
              ),
            ],
          ),
          if (_metodoActivo != null) ...[
            const SizedBox(height: 12),
            _panelInputs(scheme),
          ],
          if (_pagos.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(height: 1, color: scheme.outlineVariant),
            const SizedBox(height: 8),
            for (var i = 0; i < _pagos.length; i++) _pagoRow(scheme, i),
          ],
          const SizedBox(height: 12),
          _resumen(scheme),
        ],
      ),
    );
  }

  Widget _metodoButton(
      String label, IconData icon, String metodo, ColorScheme scheme) {
    final activo = _metodoActivo == metodo;
    return OutlinedButton.icon(
      onPressed: () => _abrirPanel(metodo),
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        foregroundColor: activo ? scheme.primary : scheme.onSurfaceVariant,
        backgroundColor: activo ? scheme.primary.withValues(alpha: 0.1) : null,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }

  Widget _panelInputs(ColorScheme scheme) {
    if (_metodoActivo == 'transferencia') {
      return Column(
        children: [
          TextField(
            controller: _transferenciaMonto,
            decoration: const InputDecoration(
                labelText: 'Transferencia (VES)',
                prefixIcon: Icon(Icons.attach_money),
                isDense: true),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _transferenciaRef,
            decoration: const InputDecoration(
                labelText: 'Referencia', prefixIcon: Icon(Icons.label), isDense: true),
          ),
          const SizedBox(height: 8),
          _agregarBoton(scheme),
        ],
      );
    }
    if (_metodoActivo == 'efectivo') {
      return Column(
        children: [
          TextField(
            controller: _efectivoMonto,
            decoration: const InputDecoration(
                labelText: 'Efectivo (VES)',
                prefixIcon: Icon(Icons.payments),
                isDense: true),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 8),
          _agregarBoton(scheme),
        ],
      );
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _divisasTasa,
                decoration: const InputDecoration(
                    labelText: 'Tasa (VES/USD)',
                    prefixIcon: Icon(Icons.currency_exchange),
                    isDense: true),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _divisasMonto,
                decoration: const InputDecoration(
                    labelText: 'Monto en USD',
                    prefixIcon: Icon(Icons.attach_money),
                    isDense: true),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _agregarBoton(scheme),
      ],
    );
  }

  Widget _agregarBoton(ColorScheme scheme) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonalIcon(
        onPressed: _agregarPago,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Agregar'),
      ),
    );
  }

  Widget _pagoRow(ColorScheme scheme, int index) {
    final p = _pagos[index];
    final icona = switch (p.tipo) {
      'transferencia' => '🏦',
      'efectivo' => '💵',
      'divisas' => '💱',
      _ => '💳',
    };
    final refTxt = p.ref.isEmpty ? '' : ' (Ref: ${p.ref})';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$icona ${p.tipo} ${p.monto.round()} VES$refTxt',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            color: scheme.error,
            visualDensity: VisualDensity.compact,
            onPressed: () => _eliminarPago(index),
          ),
        ],
      ),
    );
  }

  Widget _resumen(ColorScheme scheme) {
    final absFaltante = _faltante.abs();
    final (IconData icono, Color color, String texto) =
        absFaltante < 0.01
            ? (Icons.check_circle, Colors.green, 'PAGO COMPLETO')
            : _faltante > 0
                ? (Icons.warning_amber_rounded, Colors.orange,
                    'FALTANTE: ${_faltante.toStringAsFixed(2)} VES')
                : (Icons.error_outline, scheme.error,
                    'EXCEDENTE: ${absFaltante.toStringAsFixed(2)} VES');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icono, color: color, size: 22),
          const SizedBox(width: 8),
          Text(texto,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _section(ColorScheme scheme, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }
}
