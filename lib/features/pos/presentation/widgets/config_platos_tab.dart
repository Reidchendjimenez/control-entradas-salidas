import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/pos_models.dart';
import '../../data/pos_providers.dart';
import '../dialogs/plato_config_dialog.dart';

/// Pestaña de platos POS (port de `ConfigPOSView` sección PLATOS): listado con
/// toggle platos/contornos, CRUD completo con ingredientes.
class ConfigPlatosTab extends ConsumerStatefulWidget {
  const ConfigPlatosTab({super.key});

  @override
  ConsumerState<ConfigPlatosTab> createState() => _ConfigPlatosTabState();
}

class _ConfigPlatosTabState extends ConsumerState<ConfigPlatosTab> {
  List<PosPlato> _platos = [];
  Map<int, PosPlatoCategoria> _cats = {};
  bool _cargando = true;
  bool _verContornos = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final repo = ref.read(posRepoProvider)!;
    final platos = await repo.getPlatos();
    final cats = await repo.getPlatosCategorias(soloActivas: false);
    if (!mounted) return;
    setState(() {
      _platos = platos;
      _cats = {for (final c in cats) c.id: c};
      _cargando = false;
    });
  }

  Future<void> _nuevoPlato() async {
    if (await showPlatoConfigDialog(context)) {
      ref.invalidate(platosProvider);
      await _cargar();
    }
  }

  Future<void> _editarPlato(PosPlato p) async {
    if (await showPlatoConfigDialog(context, plato: p)) {
      ref.invalidate(platosProvider);
      await _cargar();
    }
  }

  Future<void> _eliminarPlato(PosPlato p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar plato'),
        content: Text("¿Eliminar '${p.nombre}'?"),
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
    await ref.read(posRepoProvider)!.eliminarPlato(p.id);
    ref.invalidate(platosProvider);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final visibles = [
      for (final p in _platos)
        if (p.esContorno == (_verContornos ? 1 : 0)) p,
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
          child: Row(
            children: [
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () => setState(() => _verContornos = !_verContornos),
                icon: const Icon(Icons.dataset_linked),
                label: Text(_verContornos ? 'Ver platos' : 'Ver contornos'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _nuevoPlato,
                icon: const Icon(Icons.add),
                label: const Text('Nuevo plato'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : visibles.isEmpty
                  ? Center(
                      child: Text(_verContornos
                          ? 'No hay contornos'
                          : 'No hay platos registrados',
                          style: TextStyle(color: scheme.outline)),
                    )
                  : ListView(
                      children: [
                        for (final p in visibles)
                          _PlatoConfigCard(
                            plato: p,
                            cat: _cats[p.categoriaId],
                            onEdit: () => _editarPlato(p),
                            onDelete: () => _eliminarPlato(p),
                          ),
                      ],
                    ),
        ),
      ],
    );
  }
}

class _PlatoConfigCard extends StatelessWidget {
  const _PlatoConfigCard({
    required this.plato,
    required this.cat,
    required this.onEdit,
    required this.onDelete,
  });

  final PosPlato plato;
  final PosPlatoCategoria? cat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final esContorno = plato.esContorno == 1;
    final lleva = plato.llevaContornos == 1;
    final colorCat = cat?.color ?? '#FF6F00';

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
              decoration: BoxDecoration(color: _hexColor(colorCat), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                plato.nombre.length > 2
                    ? plato.nombre.substring(0, 2).toUpperCase()
                    : plato.nombre.toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(plato.nombre,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      if (esContorno) ...[
                        const SizedBox(width: 6),
                        const _Tag(
                          texto: 'CONTORNO',
                          color: Color(0xFFFF6F00),
                        ),
                      ],
                      if (lleva) ...[
                        const SizedBox(width: 6),
                        const _Tag(texto: '+', color: Color(0xFF4CAF50)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${cat?.nombre ?? 'Sin categoría'}  |  \$${plato.precioVenta.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                  ),
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

class _Tag extends StatelessWidget {
  const _Tag({required this.texto, required this.color});

  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        texto,
        style: TextStyle(
            fontSize: 9, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

Color _hexColor(String value) {
  final v = value.replaceFirst('#', '');
  return Color(int.parse('FF$v', radix: 16));
}
