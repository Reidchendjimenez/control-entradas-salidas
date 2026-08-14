import 'package:flutter/material.dart';

import '../../../../core/db/schema/app_database.dart';

/// Card individual de mensaje en la bandeja — porta `_build_card` +
/// `_estado_icon`/`_estado_text` de `whatsapp_bandeja_view.py`.
class MensajeCard extends StatelessWidget {
  const MensajeCard({
    super.key,
    required this.msg,
    required this.onRetry,
    required this.onDelete,
  });

  final WhatsappQueueData msg;
  final VoidCallback onRetry;
  final VoidCallback onDelete;

  String _fmtFechaHora(DateTime d) {
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(d.day)}/${p(d.month)} ${p(d.hour)}:${p(d.minute)}';
  }

  String _estadoTexto() {
    switch (msg.estado) {
      case 'sent':
        return '✅ Enviado';
      case 'failed':
        return '❌ Fallido (${msg.intentos}/${msg.maxIntentos})';
      case 'sending':
        return '⏳ Enviando...';
      default:
        return '⏳ Pendiente (${msg.intentos}/${msg.maxIntentos})';
    }
  }

  IconData _estadoIcono() {
    switch (msg.estado) {
      case 'sent':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'sending':
        return Icons.hourglass_top;
      default:
        return Icons.hourglass_empty;
    }
  }

  Color _estadoColor(ColorScheme scheme) {
    switch (msg.estado) {
      case 'sent':
        return Colors.green;
      case 'failed':
        return scheme.error;
      case 'sending':
        return Colors.orange;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final esImagen = msg.tipo == 'image';
    final preview = (msg.mensaje ?? '').trim();
    final previewText = esImagen && preview.isEmpty
        ? 'Imagen'
        : (preview.length > 80 ? '${preview.substring(0, 80)}...' : preview);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              esImagen ? Icons.image_outlined : Icons.text_fields,
              size: 24,
              color: scheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(_estadoIcono(),
                            size: 16, color: _estadoColor(scheme)),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _estadoTexto(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Text(
                        _fmtFechaHora(msg.createdAt.toLocal()),
                        style: TextStyle(
                            fontSize: 11, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(previewText,
                      style: TextStyle(fontSize: 13, color: scheme.onSurface)),
                  if (msg.ultimoError != null && msg.estado == 'failed') ...[
                    const SizedBox(height: 4),
                    Text(
                      msg.ultimoError!,
                      style: TextStyle(fontSize: 11, color: scheme.error),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.replay, size: 20),
              tooltip: 'Reintentar',
              onPressed: msg.estado == 'sent' ? null : onRetry,
            ),
            IconButton(
              icon: Icon(Icons.delete_outline,
                  size: 20, color: scheme.error),
              tooltip: 'Eliminar',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
