import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/pos_models.dart';
import '../../data/pos_providers.dart';
import '../dialogs/mesa_config_dialog.dart';

/// Pestaña de mesas POS (port de `ConfigPOSView` sección MESAS): listado con
/// número/nombre/zona y CRUD completo.
class ConfigMesasTab extends ConsumerStatefulWidget {
  const ConfigMesasTab({super.key});

  @override
  ConsumerState<ConfigMesasTab> createState() => _ConfigMesasTabState();
}

class _ConfigMesasTabState extends ConsumerState<ConfigMesasTab> {
  List<PosMesa> _mesas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final mesas = await ref.read(posRepoProvider)!.getMesas();
    if (!mounted) return;
    setState(() {
      _mesas = mesas;
      _cargando = false;
    });
  }

  Future<void> _nuevaMesa() async {
    if (await showMesaConfigDialog(context)) {
      ref.invalidate(mesasProvider);
      await _cargar();
    }
  }

  Future<void> _editarMesa(PosMesa mesa) async {
    if (await showMesaConfigDialog(context, mesa: mesa)) {
      ref.invalidate(mesasProvider);
      await _cargar();
    }
  }

  Future<void> _eliminarMesa(PosMesa mesa) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar mesa'),
        content: Text("¿Eliminar la mesa '${mesa.numero}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFEF5350)),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(posRepoProvider)!.eliminarMesa(mesa.id);
    ref.invalidate(mesasProvider);
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
                onPressed: _nuevaMesa,
                icon: const Icon(Icons.add),
                label: const Text('Nueva mesa'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : _mesas.isEmpty
                  ? Center(
                      child: Text('No hay mesas registradas',
                          style: TextStyle(color: scheme.outline)),
                    )
                  : ListView(
                      children: [
                        for (final m in _mesas)
                          _MesaConfigCard(
                            mesa: m,
                            onEdit: () => _editarMesa(m),
                            onDelete: () => _eliminarMesa(m),
                          ),
                      ],
                    ),
        ),
      ],
    );
  }
}

class _MesaConfigCard extends StatelessWidget {
  const _MesaConfigCard({
    required this.mesa,
    required this.onEdit,
    required this.onDelete,
  });

  final PosMesa mesa;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sub = [mesa.nombre, mesa.zona]
        .where((s) => s != null && s.isNotEmpty)
        .join(' · ');
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
              decoration: const BoxDecoration(
                color: Color(0xFF5C6BC0),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(mesa.numero,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mesa ${mesa.numero}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(sub.isEmpty ? 'Sin datos' : sub,
                      style: TextStyle(
                          fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Editar',
              onPressed: onEdit,
              icon: const Icon(Icons.edit, color: Color(0xFFBB86FC)),
            ),
            IconButton(
              tooltip: 'Eliminar',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline, color: Color(0xFFEF5350)),
            ),
          ],
        ),
      ),
    );
  }
}
