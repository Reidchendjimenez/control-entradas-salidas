import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/receta.dart';
import '../../../core/widgets/error_display.dart';
import '../data/producciones_providers.dart';
import '../data/producciones_repository.dart';
import 'dialogs/delete_receta_dialog.dart';
import 'widgets/receta_card.dart';

/// Tab Recetas: lista de recetas con cards + boton para crear/editar.
class RecetasTab extends ConsumerStatefulWidget {
  const RecetasTab({super.key, required this.onEdit});

  /// Abre el editor (receta nula → nueva).
  final ValueChanged<Receta?> onEdit;

  @override
  ConsumerState<RecetasTab> createState() => _RecetasTabState();
}

class _RecetasTabState extends ConsumerState<RecetasTab> {
  Future<(List<Receta>, Map<int, List<ComponenteInfo>>)>? _future;

  @override
  void initState() {
    super.initState();
    _future = _cargar();
  }

  Future<(List<Receta>, Map<int, List<ComponenteInfo>>)> _cargar() async {
    final repo = ref.read(produccionesRepoProvider);
    if (repo == null) {
      throw Exception('Supabase no configurado. Verifica la conexion.');
    }
    final recetas = await repo.getRecetas();
    final componentes = await repo.getAllComponentes();
    final porReceta = <int, List<ComponenteInfo>>{};
    for (final c in componentes) {
      porReceta.putIfAbsent(c.recetaId, () => []).add(c);
    }
    return (recetas, porReceta);
  }

  void _refresh() {
    ref.invalidate(produccionesRepoProvider);
    setState(() => _future = _cargar());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return FutureBuilder<(List<Receta>, Map<int, List<ComponenteInfo>>)>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return ErrorDisplay(
            error: snap.error!,
            onRetry: _refresh,
          );
        }
        final (recetas, porReceta) = snap.data!;
        if (recetas.isEmpty) {
          return _empty(scheme);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recetas.length,
          itemBuilder: (context, i) {
            final r = recetas[i];
            final comps = porReceta[r.id] ?? const <ComponenteInfo>[];
            final ingredientes =
                comps.where((c) => c.tipoComponente == 'INGREDIENTE').length;
            final resultados =
                comps.where((c) => c.tipoComponente == 'RESULTADO').length;
            final variables =
                comps.where((c) => c.pesoVariable == 1).length;
            return RecetaCard(
              receta: r,
              totalComponentes: comps.length,
              ingredientes: ingredientes,
              resultados: resultados,
              variables: variables,
              onTap: () => widget.onEdit(r),
              onEdit: () => widget.onEdit(r),
              onDelete: () => showDeleteRecetaDialog(
                context,
                ref,
                r,
                onConfirmed: _refresh,
              ),
            );
          },
        );
      },
    );
  }

  Widget _empty(ColorScheme scheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.description_outlined, size: 48, color: scheme.outline),
          const SizedBox(height: 10),
          Text('No hay recetas aún',
              style: TextStyle(fontSize: 16, color: scheme.outline)),
          const SizedBox(height: 4),
          Text("Presiona '+ Nueva Receta' para crear una",
              style: TextStyle(fontSize: 13, color: scheme.outline)),
        ],
      ),
    );
  }
}
