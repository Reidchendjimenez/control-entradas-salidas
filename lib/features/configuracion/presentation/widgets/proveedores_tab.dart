import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../../../core/sync/sync_service.dart';
import '../../data/configuracion_providers.dart';
import '../dialogs/proveedor_dialog.dart';

/// Pestaña de Proveedores (porta `usr/views/configuracion/proveedores.py`).
class ProveedoresTab extends ConsumerStatefulWidget {
  const ProveedoresTab({super.key});

  @override
  ConsumerState<ProveedoresTab> createState() => _ProveedoresTabState();
}

class _ProveedoresTabState extends ConsumerState<ProveedoresTab> {
  final _searchCtrl = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final proveedoresAsync = ref.watch(proveedoresConfigProvider);

    return Column(
      children: [
        _buildHeader(scheme),
        Expanded(
          child: proveedoresAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: scheme.error))),
            data: (proveedores) {
              final filtered = proveedores.where((Proveedore p) {
                if (_search.isEmpty) return true;
                final term = _search.toLowerCase();
                return p.nombre.toLowerCase().contains(term) ||
                    (p.rif?.toLowerCase().contains(term) ?? false) ||
                    (p.telefono?.toLowerCase().contains(term) ?? false);
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Text(
                    _search.isEmpty ? 'No hay proveedores' : 'Sin coincidencias',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final p = filtered[i];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: scheme.secondaryContainer,
                        child: Icon(Icons.local_shipping, color: scheme.onSecondaryContainer),
                      ),
                      title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (p.rif != null && p.rif!.isNotEmpty) Text('RIF: ${p.rif}', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                          if (p.telefono != null && p.telefono!.isNotEmpty) Text('Tel: ${p.telefono}', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                          if (p.email != null && p.email!.isNotEmpty) Text(p.email!, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_outlined, color: scheme.primary),
                            tooltip: 'Editar',
                            onPressed: () => _abrirDialogo(p),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: scheme.error),
                            tooltip: 'Eliminar',
                            onPressed: () => _eliminar(p),
                          ),
                        ],
                      ),
                      onTap: () => _abrirDialogo(p),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: scheme.outlineVariant))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Buscar proveedores...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Nuevo'),
            onPressed: () => _abrirDialogo(null),
          ),
        ],
      ),
    );
    }

  Future<void> _abrirDialogo(Proveedore? prov) async {
    final result = await showProveedorDialog(context, ref.read(configuracionRepoProvider), proveedor: prov);
    if (result == true && mounted) ref.invalidate(proveedoresConfigProvider);
  }

  Future<void> _eliminar(Proveedore prov) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar proveedor'),
        content: Text('¿Eliminar "${prov.nombre}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final repo = ref.read(configuracionRepoProvider);
      await repo.deleteProveedor(prov.id);
      ref.read(syncEngineProvider)?.pushPending();
      if (mounted) ref.invalidate(proveedoresConfigProvider);
    }
  }
}