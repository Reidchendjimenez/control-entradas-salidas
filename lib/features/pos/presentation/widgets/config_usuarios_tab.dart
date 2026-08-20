import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/pos_providers.dart';
import '../dialogs/nuevo_cajero_dialog.dart';

/// Pestaña de cajeros POS (port de `ConfigPOSView` sección USUARIOS):
/// lista de cajeros con su estado (Admin / Con PIN) y alta de nuevos.
class ConfigUsuariosTab extends ConsumerStatefulWidget {
  const ConfigUsuariosTab({super.key});

  @override
  ConsumerState<ConfigUsuariosTab> createState() => _ConfigUsuariosTabState();
}

class _ConfigUsuariosTabState extends ConsumerState<ConfigUsuariosTab> {
  List<PosUsuario> _usuarios = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final usuarios =
        await ref.read(posRepoProvider).getUsuarios(soloActivos: false);
    if (!mounted) return;
    setState(() {
      _usuarios = usuarios;
      _cargando = false;
    });
  }

  Future<void> _toggleActivo(PosUsuario u, bool activo) async {
    await ref.read(posRepoProvider).actualizarUsuario(u.id, activo: activo);
    ref.invalidate(usuariosProvider);
    await _cargar();
  }

  Future<void> _nuevoCajero() async {
    await showNuevoCajeroDialog(context);
    ref.invalidate(usuariosProvider);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
          child: Row(
            children: [
              const Spacer(),
              FilledButton.icon(
                onPressed: _nuevoCajero,
                icon: const Icon(Icons.person_add_alt_1),
                label: const Text('Nuevo cajero'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : _usuarios.isEmpty
                  ? Center(
                      child: Text('No hay cajeros registrados',
                          style: TextStyle(color: scheme.outline)),
                    )
                  : ListView(
                      children: [
                        for (final u in _usuarios)
                          _UsuarioConfigCard(
                            usuario: u,
                            onToggleActivo: (v) => _toggleActivo(u, v),
                          ),
                      ],
                    ),
        ),
      ],
    );
  }
}

class _UsuarioConfigCard extends StatelessWidget {
  const _UsuarioConfigCard({required this.usuario, required this.onToggleActivo});

  final PosUsuario usuario;
  final ValueChanged<bool> onToggleActivo;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final esAdmin = usuario.esAdmin == 1;
    final esDev = usuario.esDesarrollador == 1;
    final hasPin = usuario.pinHash != null && usuario.pinHash!.isNotEmpty;
    final tags = [
      if (esAdmin) 'Admin',
      if (esDev) 'Desarrollador',
      hasPin ? 'Con PIN' : 'Sin PIN',
    ].join(' · ');
    final activo = usuario.activo == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: esDev
                    ? const Color(0xFF00ACC1)
                    : esAdmin
                        ? const Color(0xFFFF9800)
                        : const Color(0xFF7C4DFF),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                usuario.nombre.length > 2
                    ? usuario.nombre.substring(0, 2).toUpperCase()
                    : usuario.nombre.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(usuario.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(tags,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            if (!activo)
              Text('Inactivo',
                  style: TextStyle(
                      fontSize: 11,
                      color: scheme.outline,
                      fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Switch(
              value: activo,
              onChanged: onToggleActivo,
            ),
          ],
        ),
      ),
    );
  }
}
