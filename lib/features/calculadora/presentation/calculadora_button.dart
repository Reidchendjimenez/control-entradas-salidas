import 'package:flutter/material.dart';
import 'calculadora_dialog.dart';

/// Botón que abre la calculadora y vuelca el resultado en [targetController].
///
/// Uso típico en un modal:
/// ```dart
/// final pesoCtrl = TextEditingController();
/// ...
/// CalculadoraButton(
///   targetController: pesoCtrl,
///   tooltip: 'Calcular peso total',
///   icon: Icons.calculate,
/// )
/// ```
class CalculadoraButton extends StatelessWidget {
  const CalculadoraButton({
    super.key,
    required this.targetController,
    this.tooltip,
    this.icon = Icons.calculate_outlined,
    this.label,
    this.onResult,
    this.formatResult,
  });

  final TextEditingController targetController;
  final String? tooltip;
  final IconData icon;
  final String? label;
  final void Function(double)? onResult;
  final String Function(double)? formatResult;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? 'Abrir calculadora',
      child: OutlinedButton.icon(
        icon: Icon(icon, size: 18),
        label: label != null ? Text(label!) : const SizedBox.shrink(),
        style: OutlinedButton.styleFrom(
          padding: label != null
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
              : const EdgeInsets.all(10),
          minimumSize: label != null ? const Size(80, 40) : const Size(40, 40),
        ),
        onPressed: () async {
          final initial = double.tryParse(targetController.text) ?? 0;
          final result = await showCalculadoraDialog(context, initialValue: initial);
          if (result != null && context.mounted) {
            final formatted = formatResult?.call(result) ?? _defaultFormat(result);
            targetController.text = formatted;
            targetController.selection = TextSelection.collapsed(offset: formatted.length);
            onResult?.call(result);
          }
        },
      ),
    );
  }

  String _defaultFormat(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    // Redondear a 3 decimales para evitar basura flotante
    return v.toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}

/// Variante compacta solo icono (para usar dentro de un InputDecoration como suffixIcon).
class CalculadoraSuffixIcon extends StatelessWidget {
  const CalculadoraSuffixIcon({
    super.key,
    required this.targetController,
    this.onResult,
    this.formatResult,
  });

  final TextEditingController targetController;
  final void Function(double)? onResult;
  final String Function(double)? formatResult;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calculate_outlined, size: 20),
      tooltip: 'Calculadora',
      onPressed: () async {
        final initial = double.tryParse(targetController.text) ?? 0;
        final result = await showCalculadoraDialog(context, initialValue: initial);
        if (result != null && context.mounted) {
          final formatted = formatResult?.call(result) ?? _defaultFormat(result);
          targetController.text = formatted;
          targetController.selection = TextSelection.collapsed(offset: formatted.length);
          onResult?.call(result);
        }
      },
    );
  }

  String _defaultFormat(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }
}