import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/error_details_dialog.dart';
import 'sync_status.dart';

/// Barra global de progreso de sincronización (port de `POSSyncIndicator` de
/// `usr/pos/sync_indicator.py`): aparece bajo el header del shell mientras hay
/// un sync manual/inicial en curso y se oculta sola al terminar. Comparte la
/// cola de estado entre el sync general y el del POS.
class GlobalSyncBar extends ConsumerWidget {
  const GlobalSyncBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(syncStatusProvider);
    if (!s.visible) return const SizedBox.shrink();

    final Color bg;
    final Color fg;
    final Widget indicador;
    switch (s.estado) {
      case SyncEstado.activo:
        bg = const Color(0xFF2D2D2D);
        fg = const Color(0xFFBBBBBB);
        indicador = const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Color(0xFFBB86FC)),
          ),
        );
      case SyncEstado.ok:
        bg = const Color(0xFF1B3D1B);
        fg = const Color(0xFF4CAF50);
        indicador = const Icon(Icons.check_circle, size: 16, color: Color(0xFF4CAF50));
      case SyncEstado.error:
        bg = const Color(0xFF3D1B1B);
        fg = const Color(0xFFF44336);
        indicador = const Icon(Icons.error_outline, size: 16, color: Color(0xFFF44336));
      case SyncEstado.inactivo:
        return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          indicador,
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              s.mensaje,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: fg),
            ),
          ),
          if (s.estado == SyncEstado.error)
            IconButton(
              onPressed: () => showErrorDetailsDialog(
                context,
                titulo: 'Error de sincronización',
                detalle: s.errorDetail ?? s.mensaje,
              ),
              icon: const Icon(Icons.copy, size: 16),
              color: fg,
              tooltip: 'Ver y copiar el error',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 24),
            ),
        ],
      ),
    );
  }
}

/// Listener que, ante cualquier error de sincronizacion, abre automaticamente
/// el dialogo de detalle (con copiado al portapapeles) ademas de la barra.
///
/// Se monta una sola vez en el shell, asi que funciona sin importar la vista
/// activa. Solo dispara una vez por error distinto; se reinicia al volver a un
/// estado sin error.
class SyncErrorDialogListener extends ConsumerStatefulWidget {
  const SyncErrorDialogListener({super.key});

  @override
  ConsumerState<SyncErrorDialogListener> createState() =>
      _SyncErrorDialogListenerState();
}

class _SyncErrorDialogListenerState
    extends ConsumerState<SyncErrorDialogListener> {
  String? _ultimoMostrado;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(syncStatusProvider);

    if (s.estado == SyncEstado.error) {
      final key = '${s.mensaje} ${s.errorDetail ?? ''}';
      if (key != _ultimoMostrado) {
        _ultimoMostrado = key;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showErrorDetailsDialog(
              context,
              titulo: 'Error de sincronizacion',
              detalle: s.errorDetail ?? s.mensaje,
            );
          }
        });
      }
    } else {
      _ultimoMostrado = null;
    }

    return const SizedBox.shrink();
  }
}
