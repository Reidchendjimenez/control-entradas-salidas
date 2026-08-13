import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../data/inventario_repository.dart';

final inventarioRepoProvider = Provider<InventarioRepository>((ref) {
  return InventarioRepository(ref.watch(appDatabaseProvider));
});

/// Pantalla de Inventario (porta `usr/views/inventario_view.py`).
/// Muestra categorías → productos de la categoría → diálogos de movimiento
/// (entrada/salida/ajuste). Incluye lista de compra.
class InventarioScreen extends ConsumerStatefulWidget {
  const InventarioScreen({super.key});

  @override
  ConsumerState<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends ConsumerState<InventarioScreen> {
  int? _categoriaSeleccionada;

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(inventarioRepoProvider);
    return Row(
      children: [
        // Panel izquierdo: categorías.
        Container(
          width: 220,
          decoration: BoxDecoration(
            border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor)),
          ),
          child: StreamBuilder(
            stream: repo.watchCategorias(),
            builder: (context, snap) {
              final cats = snap.data ?? [];
              if (cats.isEmpty) {
                return const Center(child: Text('Sin categorías'));
              }
              return ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.apps),
                    title: const Text('Todas'),
                    selected: _categoriaSeleccionada == null,
                    onTap: () => setState(() => _categoriaSeleccionada = null),
                  ),
                  ...cats.map((c) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _parseColor(c.color),
                          child: Text(
                            c.nombre.isNotEmpty ? c.nombre[0] : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(c.nombre),
                        selected: _categoriaSeleccionada == c.id,
                        onTap: () => setState(() => _categoriaSeleccionada = c.id),
                      )),
                ],
              );
            },
          ),
        ),
        // Panel derecho: productos.
        Expanded(
          child: _ProductosPanel(
            repo: repo,
            categoriaId: _categoriaSeleccionada,
          ),
        ),
      ],
    );
  }

  Color _parseColor(String hex) {
    final v = int.tryParse(hex.replaceFirst('#', '0xFF'));
    return v != null ? Color(v) : Colors.blue;
  }
}

class _ProductosPanel extends ConsumerStatefulWidget {
  const _ProductosPanel({required this.repo, required this.categoriaId});
  final InventarioRepository repo;
  final int? categoriaId;

  @override
  ConsumerState<_ProductosPanel> createState() => _ProductosPanelState();
}

class _ProductosPanelState extends ConsumerState<_ProductosPanel> {
  String _search = '';

  Future<List<Producto>> _load() {
    if (widget.categoriaId != null) {
      return widget.repo.getProductosByCategoria(widget.categoriaId!);
    }
    return widget.repo.getAllProductos(searchTerm: _search);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Buscar producto...',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
            onChanged: (v) => setState(() => _search = v),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Producto>>(
            future: _load(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final prods = snap.data ?? [];
              if (prods.isEmpty) {
                return const Center(child: Text('Sin productos'));
              }
              return ListView.builder(
                itemCount: prods.length,
                itemBuilder: (context, i) {
                  final p = prods[i];
                  return ListTile(
                    title: Text(p.nombre),
                    subtitle: Text(
                        '${p.unidadMedida} • Stock mín: ${p.stockMinimo}'),
                    trailing: FutureBuilder<List<Existencia>>(
                      future: widget.repo.getExistenciasByProducto(p.id),
                      builder: (context, eSnap) {
                        final total = (eSnap.data ?? [])
                            .fold<double>(0, (a, e) => a + e.cantidad);
                        return Text('${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium);
                      },
                    ),
                    onTap: () => _showMovimientoDialog(p),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showMovimientoDialog(Producto p) async {
    final cantidadCtrl = TextEditingController(text: '1');
    String tipo = 'entrada';
    String? almacen = p.almacenPredeterminado;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSt) => AlertDialog(
          title: Text(p.nombre),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'entrada', label: Text('Entrada')),
                  ButtonSegment(value: 'salida', label: Text('Salida')),
                  ButtonSegment(value: 'ajuste', label: Text('Ajuste')),
                ],
                selected: {tipo},
                onSelectionChanged: (s) => setSt(() => tipo = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cantidadCtrl,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Almacén'),
                value: almacen,
                items: const [
                  DropdownMenuItem(value: 'principal', child: Text('principal')),
                  DropdownMenuItem(value: 'cocina', child: Text('cocina')),
                  DropdownMenuItem(value: 'bar', child: Text('bar')),
                ],
                onChanged: (v) => setSt(() => almacen = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final cant = double.tryParse(cantidadCtrl.text) ?? 0;
                if (cant <= 0) return;
                final ok = await widget.repo.registrarMovimiento(
                  productoId: p.id,
                  tipo: tipo,
                  cantidad: cant,
                  almacen: almacen,
                  unidadMedida: p.unidadMedida,
                  esPesable: p.esPesable == 1,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok
                          ? 'Movimiento registrado'
                          : 'Stock insuficiente'),
                      backgroundColor: ok ? Colors.green : Colors.red,
                    ),
                  );
                  if (ok) setState(() {});
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
