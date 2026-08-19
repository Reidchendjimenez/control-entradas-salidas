import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../updater/app_updater.dart';
import '../updater/update_models.dart';

/// Diálogo de "Actualización disponible" con descarga y progreso.
///
/// Flujo: muestra versión actual → nueva, descarga con barra de progreso y
/// finalmente instala (Android: PackageInstaller; Windows: updater.bat que
/// relanza la app). En web el botón se oculta (no aplica).
class UpdateDialog {
  /// Pide confirmación y ejecuta la descarga + instalación.
  /// Devuelve `true` si se instaló. En web siempre devuelve `false`.
  static Future<bool> show(
    BuildContext context, {
    required AppUpdater updater,
    required AppUpdateInfo info,
  }) async {
    final aplica = updater.canRun;
    if (!aplica) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _UpdateDialogBody(
        updater: updater,
        info: info,
      ),
    );
    return result ?? false;
  }
}

class _UpdateDialogBody extends StatefulWidget {
  const _UpdateDialogBody({required this.updater, required this.info});

  final AppUpdater updater;
  final AppUpdateInfo info;

  @override
  State<_UpdateDialogBody> createState() => _UpdateDialogBodyState();
}

class _UpdateDialogBodyState extends State<_UpdateDialogBody> {
  bool _descargando = false;
  double _progreso = 0;
  String? _versionActual;
  String? _error;
  bool _listo = false;

  @override
  void initState() {
    super.initState();
    _cargarVersion();
  }

  Future<void> _cargarVersion() async {
    final v = await widget.updater.localVersion();
    if (mounted) setState(() => _versionActual = v);
  }

  Future<void> _actualizar() async {
    setState(() {
      _descargando = true;
      _error = null;
    });
    try {
      final path = await widget.updater.download(
        widget.info,
        onProgress: (p) {
          if (mounted) setState(() => _progreso = p.fraction);
        },
      );
      await widget.updater.install(path);
      if (mounted) setState(() => _listo = true);
      // Windows: install() termina el proceso (updater.bat relanza).
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _descargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final local = _versionActual ?? '...';

    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.system_update, color: Color(0xFF42A5F5)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Actualización disponible',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(AppConfig.appLabel,
                    style: TextStyle(
                        fontSize: 12, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Versión actual: $local'),
          const SizedBox(height: 4),
          Text(
            'Nueva versión: ${widget.info.version}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              'Error: $_error',
              style: TextStyle(color: scheme.error, fontSize: 13),
            ),
          ],
          if (_descargando) ...[
            const SizedBox(height: 16),
            LinearProgressIndicator(value: _progreso),
            const SizedBox(height: 8),
            Text('Descargando... ${(_progreso * 100).round()}%',
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
          ],
          if (_listo) ...[
            const SizedBox(height: 12),
            Text('Instalado. La aplicación se reiniciará.',
                style: TextStyle(color: scheme.primary)),
          ],
        ],
      ),
      actions: [
        if (!_descargando && !_listo)
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Más tarde'),
          ),
        if (!_descargando && !_listo)
          FilledButton.icon(
            onPressed: _actualizar,
            icon: const Icon(Icons.download),
            label: const Text('Actualizar ahora'),
          ),
        if (_listo)
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Aceptar'),
          ),
      ],
    );
  }
}

/// Snackbar con el resultado de un chequeo manual de actualizaciones.
void showUpdateResult(BuildContext context, {required bool alDia}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(alDia ? 'La aplicación está al día' : 'Actualización lista'),
      backgroundColor: alDia ? const Color(0xFF4CAF50) : const Color(0xFF42A5F5),
    ),
  );
}