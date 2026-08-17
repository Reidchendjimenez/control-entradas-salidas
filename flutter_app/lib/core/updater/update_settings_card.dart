import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../updater/update_dialog.dart';
import '../updater/updater_providers.dart';

/// Tarjeta de "Actualizaciones" para la Configuración (POS e inventario).
///
/// Muestra la versión instalada, permite buscar actualizaciones manualmente y
/// ofrece descargar/instalar. En web muestra el estado "al día" sin botón de
/// instalar (el despliegue web se sirve desde el server).
class UpdateSettingsCard extends ConsumerStatefulWidget {
  const UpdateSettingsCard({super.key});

  @override
  ConsumerState<UpdateSettingsCard> createState() => _UpdateSettingsCardState();
}

class _UpdateSettingsCardState extends ConsumerState<UpdateSettingsCard> {
  bool _buscando = false;
  String? _version;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarVersion();
  }

  Future<void> _cargarVersion() async {
    final updater = ref.read(appUpdaterProvider);
    final v = await updater.localVersion();
    if (mounted) setState(() => _version = v);
  }

  Future<void> _buscar() async {
    final updater = ref.read(appUpdaterProvider);
    if (!updater.canRun) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Las actualizaciones aplican en la versión de escritorio o Android',
            ),
          ),
        );
      }
      return;
    }

    setState(() {
      _buscando = true;
      _error = null;
    });
    try {
      final info = await updater.checkForUpdate(force: true);
      if (!mounted) return;
      if (info == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('La aplicación está al día'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      } else {
        final instalado = await UpdateDialog.show(
          context,
          updater: updater,
          info: info,
        );
        if (instalado && mounted) {
          _cargarVersion();
        }
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.system_update_alt,
                      color: scheme.onPrimaryContainer, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Actualizaciones',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Buscar e instalar nuevas versiones de la aplicación',
                          style: TextStyle(
                              fontSize: 12, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Text('Versión instalada: ${_version ?? "..."}',
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: _buscando
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.search),
              label: Text(_buscando ? 'Buscando...' : 'Buscar actualizaciones'),
              onPressed: _buscando ? null : _buscar,
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text('Error: $_error',
                  style: TextStyle(color: scheme.error, fontSize: 13)),
            ],
          ],
        ),
      ),
    );
  }
}