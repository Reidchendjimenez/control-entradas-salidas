import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget reutilizable para mostrar errores de forma copiable.
///
/// Uso:
/// ```dart
/// if (snapshot.hasError)
///   ErrorDisplay(error: snapshot.error.toString());
/// ```
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final msg = error.toString();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: scheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 32, color: scheme.error),
              const SizedBox(height: 12),
              Text(
                'Ocurrio un error',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: scheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: msg));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error copiado al portapapeles'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: scheme.outline.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          msg,
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onErrorContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.copy, size: 14, color: scheme.error),
                    ],
                  ),
                ),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: onRetry,
                  child: const Text('Reintentar'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
