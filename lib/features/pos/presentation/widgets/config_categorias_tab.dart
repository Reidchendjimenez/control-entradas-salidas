import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/pos_models.dart';
import '../../../../features/inventario/data/inventario_providers.dart';
import '../../data/pos_providers.dart';
import '../dialogs/pos_categoria_dialog.dart';
import '../dialogs/subcategoria_dialog.dart';

/// Pestaña de categorías POS + sub-categorías (port de `ConfigPOSView` sección
/// CATEGORÍAS POS): CRUD de pos_categorias y platos_categorias con toggle
/// de activo, todo sincronizado por outbox.
class ConfigCategoriasTab extends ConsumerStatefulWidget {
  const ConfigCategoriasTab({super.key});

  @override
  ConsumerState<ConfigCategoriasTab> createState() =>
      _ConfigCategoriasTabState();
}

class _ConfigCategoriasTabState extends ConsumerState<ConfigCategoriasTab> {
  List<PosCategoria> _posCats = [];
  List<PosPlatoCategoria> _subCats = [];
  Map<int, String> _invMap = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final repo = ref.read(posRepoProvider)!;
    final invRepo = ref.read(inventarioRepoProvider)!;
    final pos = await repo.getPosCategorias();
    final subs = await repo.getPlatosCategorias();
    final inv = await invRepo.getAllCategorias();
    if (!mounted) return;
    setState(() {
      _posCats = pos;
      _subCats = subs;
      _invMap = {for (final c in inv) c.id: c.nombre};
      _cargando = false;
    });
  }

  String _labelSubcat(PosPlatoCategoria sc) {
    if (sc.categoriaPadreId != null) {
      return '${sc.nombre}  (en ${_invMap[sc.categoriaPadreId] ?? '?'})';
    }
    if (sc.posCategoriaPadreId != null) {
      final pos = _posCats
          .where((c) => c.id == sc.posCategoriaPadreId)
          .firstOrNull;
      return '${sc.nombre}  (en POS: ${pos?.nombre ?? '?'})';
    }
    return sc.nombre;
  }

  Future<void> _nuevaPosCategoria() async {
    if (await showPosCategoriaDialog(context)) await _cargar();
  }

  Future<void> _editarPosCategoria(PosCategoria cat) async {
    if (await showPosCategoriaDialog(context, categoria: cat)) await _cargar();
  }

  Future<void> _eliminarPosCategoria(PosCategoria cat) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar categoría POS'),
        content: Text("¿Eliminar '${cat.nombre}'?"),
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
    await ref.read(posRepoProvider)!.eliminarPosCategoria(cat.id);
    await _cargar();
  }

  Future<void> _toggleSubcat(PosPlatoCategoria sc, bool activo) async {
    await ref.read(posRepoProvider)!.guardarPlatoCategoria(
          sc.nombre,
          id: sc.id,
          color: sc.color,
          activo: activo,
          categoriaPadreId: sc.categoriaPadreId,
          posCategoriaPadreId: sc.posCategoriaPadreId,
        );
    await _cargar();
  }

  Future<void> _eliminarSubcat(PosPlatoCategoria sc) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar sub-categoría'),
        content: Text("¿Eliminar '${sc.nombre}'?"),
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
    await ref.read(posRepoProvider)!.eliminarPlatoCategoria(sc.id);
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
              FilledButton.icon(
                onPressed: _nuevaPosCategoria,
                icon: const Icon(Icons.add),
                label: const Text('Nueva categoría POS'),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () async {
                  if (await showSubcategoriaDialog(context)) await _cargar();
                },
                icon: const Icon(Icons.subdirectory_arrow_right),
                label: const Text('Sub-categorías'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _cargando
              ? const Center(child: CircularProgressIndicator())
              : _posCats.isEmpty && _subCats.isEmpty
                  ? Center(
                      child: Text('Sin categorías POS',
                          style: TextStyle(color: scheme.outline)),
                    )
                  : ListView(
                      children: [
                        if (_posCats.isNotEmpty) ...[
                          const _SectionLabel('Categorías POS'),
                          for (final c in _posCats)
                            _PosCatRow(
                              color: _hexColor(c.color),
                              nombre: c.nombre,
                              onEdit: () => _editarPosCategoria(c),
                              onDelete: () => _eliminarPosCategoria(c),
                            ),
                        ],
                        if (_subCats.isNotEmpty) ...[
                          const _SectionLabel('Sub-categorías'),
                          for (final sc in _subCats)
                            _SubcatRow(
                              color: _hexColor(sc.color),
                              label: _labelSubcat(sc),
                              activo: sc.activo,
                              onToggle: (v) => _toggleSubcat(sc, v),
                              onEdit: () async {
                                if (await showSubcategoriaDialog(context,
                                    subcategoria: sc)) {
                                  await _cargar();
                                }
                              },
                              onDelete: () => _eliminarSubcat(sc),
                            ),
                        ],
                      ],
                    ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 4),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Color(0xFFBB86FC),
        ),
      ),
    );
  }
}

class _PosCatRow extends StatelessWidget {
  const _PosCatRow({
    required this.color,
    required this.nombre,
    required this.onEdit,
    required this.onDelete,
  });

  final Color color;
  final String nombre;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(nombre)),
          IconButton(
            tooltip: 'Editar',
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 18, color: Color(0xFFBB86FC)),
          ),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF5350)),
          ),
        ],
      ),
    );
  }
}

class _SubcatRow extends StatelessWidget {
  const _SubcatRow({
    required this.color,
    required this.label,
    required this.activo,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final Color color;
  final String label;
  final bool activo;
  final ValueChanged<bool> onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14)),
          ),
          Switch(
            value: activo,
            onChanged: onToggle,
          ),
          IconButton(
            tooltip: 'Editar',
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 18, color: Color(0xFFBB86FC)),
          ),
          IconButton(
            tooltip: 'Eliminar',
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF5350)),
          ),
        ],
      ),
    );
  }
}

Color _hexColor(String value) {
  final v = value.replaceFirst('#', '');
  return Color(int.parse('FF$v', radix: 16));
}
