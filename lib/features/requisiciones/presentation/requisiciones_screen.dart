import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/requisicion.dart';
import '../data/requisiciones_providers.dart';
import '../data/requisiciones_repository.dart';
import 'widgets/requisicion_card.dart';
import 'widgets/requisiciones_empty_state.dart';
import 'views/audit_view.dart';
import 'views/form_view.dart';
import 'views/visualizar_view.dart';

class RequisicionesScreen extends ConsumerStatefulWidget {
  const RequisicionesScreen({super.key});

  @override
  ConsumerState<RequisicionesScreen> createState() =>
      _RequisicionesScreenState();
}

class _RequisicionesScreenState extends ConsumerState<RequisicionesScreen> {
  Widget? _vistaActiva;
  Future<(List<Requisicion>, Map<int, int>)>? _future;

  @override
  void initState() {
    super.initState();
    final repo = ref.read(requisicionesRepoProvider);
    if (repo != null) _future = _cargar(repo);
  }

  void _refresh() {
    final repo = ref.read(requisicionesRepoProvider);
    if (repo == null) return;
    setState(() => _future = _cargar(repo));
  }

  @override
  Widget build(BuildContext context) {
    if (_vistaActiva != null) {
      return _vistaActiva!;
    }
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
                onSaved: () {
                  setState(() => _vistaActiva = null);
                  _refresh();
                },
              );
            }),
          ),
        ),
        Expanded(
          child: _buildLista(),
        ),
      ],
    );
  }

  void _abrir(Widget view) => setState(() => _vistaActiva = view);
  void _cerrar() => setState(() => _vistaActiva = null);

  Widget _buildLista() {
    if (_future == null) {
      return const Center(child: Text('Supabase no configurado'));
    }
    return FutureBuilder<(List<Requisicion>, Map<int, int>)>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }
        final (reqs, counts) = snap.data ?? (const [], <int, int>{});
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
              itemCount: counts[reqs[i].id] ?? 0,
              onVisualizar: () => _abrir(VisualizarView(
                req: reqs[i],
                onBack: _cerrar,
              )),
              onEditar: () => _abrir(FormView(
                requisicion: reqs[i],
                onBack: _cerrar,
                onSaved: () {
                  _cerrar();
                  _refresh();
                },
              )),
              onAuditar: () => _abrir(AuditView(
                req: reqs[i],
                onBack: _cerrar,
                onTotalizada: () {
                  _cerrar();
                  _refresh();
                },
              )),
              onEliminar: () => _eliminar(reqs[i]),
            ),
          ),
        );
      },
    );
  }

  Future<(List<Requisicion>, Map<int, int>)> _cargar(
      RequisicionesRepository repo) async {
    final reqs = await repo.loadRequisiciones();
    final ids = reqs.map((r) => r.id).toList();
    final counts = await repo.contarDetallesBatch(ids);
    return (reqs, counts);
  }

  Future<void> _eliminar(Requisicion req) async {
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
      final repo = ref.read(requisicionesRepoProvider);
      if (repo == null) return;
      final done = await repo.eliminarRequisicion(req.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(done ? 'Requisicion eliminada' : 'Error al eliminar'),
          backgroundColor: done ? Colors.green : Colors.red,
        ));
        if (done) _refresh();
      }
    }
  }
}
