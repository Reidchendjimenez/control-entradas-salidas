import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/updater/auto_update_checker.dart';

/// Pantalla de login / registro (porta `usr/views/login_view.py`).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _nombreCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _error = '';
  bool _loading = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _pinCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // Determina si hay operador registrado → modo login o registro.
  Future<bool> _hayOperador() async {
    final db = ref.read(appDatabaseProvider);
    final u = await db.select(db.dispositivoUsuario).getSingleOrNull();
    return u != null;
  }

  Future<void> _submit() async {
    setState(() {
      _error = '';
      _loading = true;
    });
    try {
      final hayOperador = await _hayOperador();
      final session = ref.read(sessionProvider.notifier);
      bool ok = false;
      if (!hayOperador) {
        // Registro
        if (_nombreCtrl.text.trim().isEmpty) {
          _error = 'Ingresa el nombre del operador';
          return;
        }
        if (_pinCtrl.text.length != 4) {
          _error = 'El PIN debe tener 4 dígitos';
          return;
        }
        if (_pinCtrl.text != _confirmCtrl.text) {
          _error = 'Los PIN no coinciden';
          return;
        }
        ok = await session.registrarOperador(
          nombre: _nombreCtrl.text.trim(),
          pin: _pinCtrl.text,
        );
        if (!ok) _error = 'No se pudo registrar el operador';
      } else {
        // Login
        if (_pinCtrl.text.length != 4) {
          _error = 'El PIN debe tener 4 dígitos';
          return;
        }
        ok = await session.verificarPin(_pinCtrl.text);
        if (!ok) _error = 'PIN incorrecto';
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hayOperador(),
      builder: (context, snapshot) {
        final hayOperador = snapshot.data ?? false;
        final isRegistro = !hayOperador;
        final pinLabel = isRegistro ? 'PIN de 4 dígitos' : 'Ingresa tu PIN';

        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 360),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          size: 56, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(
                        isRegistro ? 'Registro de Operador' : 'Bienvenido',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isRegistro
                            ? 'Configure el operador principal del dispositivo'
                            : 'Ingresa tu PIN para continuar',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 24),
                      if (isRegistro)
                        TextField(
                          controller: _nombreCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nombre del operador',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      if (isRegistro) const SizedBox(height: 12),
                      TextField(
                        controller: _pinCtrl,
                        decoration: InputDecoration(
                          labelText: pinLabel,
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        obscureText: true,
                      ),
                      if (isRegistro) const SizedBox(height: 12),
                      if (isRegistro)
                        TextField(
                          controller: _confirmCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Confirmar PIN',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          obscureText: true,
                        ),
                      if (_error.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(_error,
                            style: TextStyle(color: Theme.of(context).colorScheme.error)),
                      ],
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(isRegistro ? 'Registrar' : 'Desbloquear'),
                      ),
                    ],
                  ),
                ),
              ),
              // Verificar actualizaciones antes del login (Windows/Android).
              const Align(alignment: Alignment.topRight, child: AutoUpdateChecker()),
            ],
          ),
        );
      },
    );
  }
}