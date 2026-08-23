import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/pos_providers.dart';

/// Alta de cajero (login.py `_show_agregar_dialog` / `_do_agregar`):
/// nombre obligatorio, PIN opcional de 4 dígitos, flag de administrador.
Future<void> showNuevoCajeroDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (_) => const _NuevoCajeroDialog(),
  );
}

class _NuevoCajeroDialog extends ConsumerStatefulWidget {
  const _NuevoCajeroDialog();

  @override
  ConsumerState<_NuevoCajeroDialog> createState() => _NuevoCajeroDialogState();
}

class _NuevoCajeroDialogState extends ConsumerState<_NuevoCajeroDialog> {
  final _nombreCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  bool _conPin = false;
  bool _esAdmin = false;
  bool _esDesarrollador = false;
  bool _guardando = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreCtrl.text.trim();
    if (nombre.isEmpty) {
      _mostrarError(_nombreCtrl, 'Ingrese un nombre');
      return;
    }
    if (_conPin) {
      final pin = _pinCtrl.text.trim();
      if (pin.length != 4) {
        _mostrarError(_pinCtrl, 'El PIN debe tener 4 dígitos');
        return;
      }
    }
    setState(() => _guardando = true);
    try {
      await ref.read(posRepoProvider)!.crearUsuario(
            nombre,
            pin: _conPin ? _pinCtrl.text.trim() : null,
            esAdmin: _esAdmin,
            esDesarrollador: _esDesarrollador,
          );
      ref.invalidate(usuariosProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mostrarError(TextEditingController c, String msg) {
    setState(() {
      c.text = '';
      c.selection = const TextSelection.collapsed(offset: 0);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo Cajero'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre del cajero',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _conPin,
              onChanged: (v) => setState(() => _conPin = v),
              title: const Text('Proteger con PIN'),
              subtitle: const Text('PIN de 4 dígitos'),
              contentPadding: EdgeInsets.zero,
            ),
            if (_conPin)
              TextField(
                controller: _pinCtrl,
                obscureText: true,
                maxLength: 4,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'PIN (4 dígitos)',
                  counterText: '',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            const Divider(height: 24),
            SwitchListTile(
              value: _esAdmin,
              onChanged: (v) => setState(() => _esAdmin = v),
              title: const Text('Es administrador'),
              subtitle: const Text('Acceso a configuración'),
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              value: _esDesarrollador,
              onChanged: (v) => setState(() => _esDesarrollador = v),
              title: const Text('Desarrollador'),
              subtitle: const Text('Pruebas sin guardar en BD'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _guardando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
