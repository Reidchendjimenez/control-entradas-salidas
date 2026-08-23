import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'update_dialog.dart';
import 'updater_providers.dart';

/// Chequeo de actualización al arrancar (solo nativo).
///
/// Se monta una sola vez en el shell; consulta GitHub y si hay una versión
/// más nueva muestra el diálogo de descarga/instalación. En web no hace nada.
class AutoUpdateChecker extends ConsumerStatefulWidget {
  const AutoUpdateChecker({super.key});

  @override
  ConsumerState<AutoUpdateChecker> createState() => _AutoUpdateCheckerState();
}

class _AutoUpdateCheckerState extends ConsumerState<AutoUpdateChecker> {
  bool _chequeado = false;

  @override
  Widget build(BuildContext context) {
    if (!_chequeado) {
      _chequeado = true;
      Future.microtask(_checkear);
    }
    return const SizedBox.shrink();
  }

  Future<void> _checkear() async {
    final updater = ref.read(appUpdaterProvider);
    if (!updater.canRun || !mounted) return;
    try {
      final info = await updater.checkForUpdate();
      if (!mounted || info == null) return;
      await UpdateDialog.show(context, updater: updater, info: info);
    } catch (e) {
      dev.log('Auto-update check failed: $e', name: 'AutoUpdateChecker');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo verificar actualizaciones: $e'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}