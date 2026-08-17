import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../data/requisiciones_providers.dart';
import 'widgets/requisicion_card.dart';
import 'widgets/requisiciones_empty_state.dart';
import 'views/audit_view.dart';
import 'views/form_view.dart';
import 'views/visualizar_view.dart';

/// Pantalla de Requisiciones (porta `usr/views/requisiciones_view.py`).
/// Solo orquesta: lista de tarjetas + navegación a sub-vistas
/// (formulario, visualización, auditoría).
class RequisicionesScreen extends ConsumerStatefulWidget {
  const RequisicionesScreen({super.key});

  @override
  ConsumerState<RequisicionesScreen> createState() =>
      _RequisicionesScreenState();
}

class _RequisicionesScreenState extends ConsumerState<RequisicionesScreen> {
  /// Sub-vista activa: `null` = lista; si no, widget actual (form/visualizar/auditar).
  Widget? _vistaActiva;

  @override
  Widget build(BuildContext context) {
    if (_vistaActiva != null) {
      return _vistaActiva!;
    }
    final repo = ref.watch(requisicionesRepoProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Nueva requisición'),
            onPressed: () => setState(() {
              _vistaActiva = FormView(
                onBack: () => setState(() => _vistaActiva = null),
                onSaved: () => setState(() => _vistaActiva = null),
              );
            }),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Requisicione>>(
            stream: repo.watchRequisiciones(),
            builder: (context, snap) {
              final reqs = snap.data ?? [];
              if (reqs.isEmpty) {
                return const RequisicionesEmptyState();
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: reqs.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RequisicionCard(
                    req: reqs[i],
                    onVisualizar: () => _abrir(VisualizarView(
                      req: reqs[i],
                      onBack: _cerrar,
                    )),
                    onEditar: () => _abrir(FormView(
                      requisicion: reqs[i],
                      onBack: _cerrar,
                      onSaved: _cerrar,
                    )),
                    onAuditar: () => _abrir(AuditView(
                      req: reqs[i],
                      onBack: _cerrar,
                      onTotalizada: _cerrar,
                    )),
                    onEliminar: () => _eliminar(reqs[i]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _abrir(Widget view) => setState(() => _vistaActiva = view);

  void _cerrar() => setState(() => _vistaActiva = null);

  Future<void> _eliminar(Requisicione req) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar requisición'),
        content: Text('¿Eliminar ${req.numero}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      final done = await ref
          .read(requisicionesRepoProvider)
          .eliminarRequisicion(req.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(done ? 'Requisición eliminada' : 'Error al eliminar'),
          backgroundColor: done ? Colors.green : Colors.red,
        ));
      }
    }
  }
}
