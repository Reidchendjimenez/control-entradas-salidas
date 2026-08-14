import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/features/inventario/data/inventario_repository.dart';
import 'package:control_entradas_salidas/features/inventario/data/inventario_providers.dart';
import 'package:control_entradas_salidas/features/calculadora/presentation/calculadora_dialog.dart';
import 'package:control_entradas_salidas/features/calculadora/presentation/calculadora_button.dart';
import 'producto_card.dart';

/// Panel derecho: productos filtrados por categoría o búsqueda.
class ProductosPanel extends ConsumerStatefulWidget {
  const ProductosPanel({
    super.key,
    required this.repo,
    required this.categoriaId,
    required this.searchTerm,
  });

  final InventarioRepository repo;
  final int? categoriaId;
  final String searchTerm;

  @override
  ConsumerState<ProductosPanel> createState() => _ProductosPanelState();
}

class _ProductosPanelState extends ConsumerState<ProductosPanel> {
  @override
  Widget build(BuildContext context) {
    final future = widget.categoriaId != null
        ? widget.repo.getProductosByCategoria(widget.categoriaId!)
        : widget.repo.getAllProductos(searchTerm: widget.searchTerm);

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Producto>>(
            future: future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              var prods = snap.data ?? [];
              if (widget.searchTerm.isNotEmpty) {
                final q = widget.searchTerm.toLowerCase();
                prods = prods
                    .where((p) => p.nombre.toLowerCase().contains(q))
                    .toList();
              }
              if (prods.isEmpty) {
                return const Center(child: Text('Sin productos'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: prods.length,
                itemBuilder: (context, i) => ProductoCard(
                  producto: prods[i],
                  repo: widget.repo,
                  onMovimiento: _showMovimientoDialog,
                  onToggleLista: _toggleListaCompra,
                  onCorregir: _showCorreccionDialog,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _showMovimientoDialog(Producto p) async {
    final repo = ref.read(inventarioRepoProvider);
    final existencias = await repo.getExistenciasByProducto(p.id);
    final almacenes = existencias.map((e) => e.almacen).toSet().toList();
    if (!almacenes.contains('principal')) almacenes.add('principal');

    String tipo = 'entrada';
    String? almacen = p.almacenPredeterminado;
    if (!almacenes.contains(almacen)) almacen = almacenes.first;

    final cantCtrl = TextEditingController(text: '1');
    final undCtrl = TextEditingController();
    final kgUndCtrl = TextEditingController();
    final pesoTotalCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSt) => AlertDialog(
          title: Text(p.nombre),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'entrada', label: Text('Entrada'), icon: Icon(Icons.input)),
                    ButtonSegment(value: 'salida', label: Text('Salida'), icon: Icon(Icons.output)),
                    ButtonSegment(value: 'ajuste', label: Text('Ajuste'), icon: Icon(Icons.tune)),
                  ],
                  selected: {tipo},
                  onSelectionChanged: (s) => setSt(() => tipo = s.first),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Almacén'),
                  value: almacen,
                  items: [
                    for (final a in almacenes) DropdownMenuItem(value: a, child: Text(a.capitalize())),
                  ],
                  onChanged: (v) => setSt(() => almacen = v),
                ),
                const SizedBox(height: 12),
                _StockInfoPanel(existencias: existencias),
                const SizedBox(height: 12),
                if (p.esPesable != 1)
                  TextField(
                    controller: cantCtrl,
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                      suffixIcon: CalculadoraSuffixIcon(targetController: cantCtrl),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: undCtrl,
                          decoration: InputDecoration(
                            labelText: 'Und.',
                            suffixIcon: CalculadoraSuffixIcon(targetController: undCtrl),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: kgUndCtrl,
                          decoration: InputDecoration(
                            labelText: 'Kg/und.',
                            suffixIcon: CalculadoraSuffixIcon(targetController: kgUndCtrl),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: pesoTotalCtrl,
                    decoration: InputDecoration(
                      labelText: 'Peso Total (kg)',
                      suffixText: 'kg',
                      suffixIcon: CalculadoraSuffixIcon(targetController: pesoTotalCtrl),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Movimiento registrado')),
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleListaCompra(Producto p) async {
    await ref.read(inventarioRepoProvider).toggleComprasLista(p.id);
    setState(() {});
  }

  Future<void> _showCorreccionDialog(Producto p) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Corregir ${p.nombre} - pendiente')),
    );
  }
}

/// Panel de stock por almacén dentro del diálogo de movimiento.
class _StockInfoPanel extends StatelessWidget {
  const _StockInfoPanel({required this.existencias});

  final List<Existencia> existencias;

  @override
  Widget build(BuildContext context) {
    if (existencias.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Sin stock registrado', style: TextStyle(fontSize: 12)),
      );
    }
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '���� Stock por almacén:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              for (final e in existencias)
                Text(
                  '${e.almacen.capitalize()}: ${e.cantidad.toStringAsFixed(e.cantidad % 1 == 0 ? 0 : 2)} ${e.unidad}',
                  style: const TextStyle(fontSize: 11),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

extension _StringCapitalize on String {
  String capitalize() => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}