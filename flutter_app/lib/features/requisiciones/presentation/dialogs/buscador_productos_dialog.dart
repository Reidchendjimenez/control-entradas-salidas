import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../data/requisiciones_providers.dart';

/// Buscador de productos para agregar a una requisición (porta
/// `ProductoBuscadorSheet` de form.py). Se abre como diálogo centrado para
/// que el teclado móvil no tape el campo de búsqueda.
/// Devuelve un [Producto] o `null`.
Future<Producto?> showBuscadorProductos(BuildContext context) {
  return showDialog<Producto>(
    context: context,
    builder: (ctx) => const _BuscadorProductosDialog(),
  );
}

class _BuscadorProductosDialog extends ConsumerStatefulWidget {
  const _BuscadorProductosDialog();

  @override
  ConsumerState<_BuscadorProductosDialog> createState() =>
      _BuscadorProductosDialogState();
}

class _BuscadorProductosDialogState
    extends ConsumerState<_BuscadorProductosDialog> {
  String _busqueda = '';
  List<Producto> _resultados = [];

  @override
  void initState() {
    super.initState();
    _buscar();
  }

  Future<void> _buscar() async {
    final repo = ref.read(requisicionesRepoProvider);
    final res = await repo.buscarProductos(_busqueda);
    if (mounted) setState(() => _resultados = res);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Buscar producto'),
      content: SizedBox(
        width: 420,
        height: 420,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nombre',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) {
                _busqueda = v;
                _buscar();
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _resultados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 42, color: scheme.outline),
                          const SizedBox(height: 8),
                          Text('Sin resultados',
                              style:
                                  TextStyle(color: scheme.onSurfaceVariant)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _resultados.length,
                      itemBuilder: (context, i) {
                        final p = _resultados[i];
                        return InkWell(
                          onTap: () => Navigator.pop(context, p),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: scheme.primary
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Icon(
                                      Icons.inventory_2_outlined,
                                      size: 19,
                                      color: scheme.primary),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(p.nombre,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        'Unidad: ${p.unidadMedida} · ${p.esPesable == 1 ? 'pesable' : 'no pesable'}',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: scheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.add_circle,
                                    color: Colors.green.shade600),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
