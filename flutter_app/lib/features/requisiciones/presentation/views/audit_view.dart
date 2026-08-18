import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/db/schema/app_database.dart';
import '../../../../core/sync/sync_service.dart';
import '../../data/requisiciones_providers.dart';
import '../../data/requisiciones_repository.dart';
import '../dialogs/ajuste_auditoria_dialog.dart';
import '../dialogs/historial_dialog.dart';

/// Auditoría de una requisición (porta `AuditView` de audit_view.py).
/// Verificación física de stock en origen/destino, ajuste de existencias y
/// totalización del traslado.
class AuditView extends ConsumerStatefulWidget {
  const AuditView({
    super.key,
    required this.req,
    required this.onBack,
    required this.onTotalizada,
  });

  final Requisicione req;
  final VoidCallback onBack;
  final VoidCallback onTotalizada;

  @override
  ConsumerState<AuditView> createState() => _AuditViewState();
}

class _AuditViewState extends ConsumerState<AuditView> {
  List<AuditItem> _items = [];
  bool _cargando = true;
  bool _totalizando = false;
  bool _guardando = false;
  int _tab = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final repo = ref.read(requisicionesRepoProvider);
      final items = await repo.getAuditData(widget.req.id);
      if (mounted) {
        setState(() {
          _items = items;
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _cargando = false;
        });
      }
    }
  }

  Future<void> _onVerify(AuditItem item, bool value) async {
    final repo = ref.read(requisicionesRepoProvider);
    setState(() {
      item.verificado = value;
    });
    await repo.marcarDetalleVerificado(item.detalleId, value);
  }

  Future<void> _showAjuste(AuditItem item) async {
    final result = await showAjusteAuditoriaDialog(
      context,
      item: item,
      almacen: widget.req.origen,
    );
    if (result != null && mounted) {
      _snack('Stock ajustado correctamente');
      await _cargar();
    }
  }

  Future<void> _showHistorial(AuditItem item) async {
    if (item.productoId == null) return;
    final repo = ref.read(requisicionesRepoProvider);
    final p = await repo.getProducto(item.productoId!);
    if (!mounted) return;
    await showHistorialAuditoria(
      context,
      repo: repo,
      productoId: item.productoId!,
      nombre: item.ingrediente,
      esPesable: p?.esPesable == 1,
    );
  }

  Future<void> _guardar() async {
    setState(() => _guardando = true);
    try {
      final engine = ref.read(syncEngineProvider);
      final ok = await engine?.fullSync();
      if (mounted) {
        if (ok == true) {
          _snack('Progreso de auditoría guardado y sincronizado');
        } else {
          _snack('Guardado local. La sincronización se reintentará automáticamente');
        }
      }
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _totalizar() async {
    if (_totalizando) return;
    final unverified = _items.where((i) => !i.verificado).map((i) => i.ingrediente).toList();
    if (unverified.isNotEmpty) {
      _snack('Hay productos no verificados: ${unverified.take(3).join(', ')}...');
      return;
    }
    setState(() => _totalizando = true);
    try {
      final repo = ref.read(requisicionesRepoProvider);
      await repo.totalizarRequisicion(widget.req.id);
      if (mounted) {
        _snack('Requisición totalizada y stock trasladado');
        widget.onTotalizada();
        widget.onBack();
      }
    } catch (e) {
      if (mounted) _snack('Error al totalizar: $e');
    } finally {
      if (mounted) setState(() => _totalizando = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.red),
              const SizedBox(height: 12),
              const Text('No se pudo cargar la auditoría',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _error = null;
                    _cargando = true;
                  });
                  _cargar();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(scheme),
        Divider(height: 1, color: scheme.outlineVariant),
        _tabs(scheme),
        Expanded(child: _tabContent(scheme)),
      ],
    );
  }

  Widget _header(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            tooltip: 'Volver',
            onPressed: _totalizando ? null : widget.onBack,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Auditoría de Requisición',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('Verifique stock físico antes de totalizar',
                    style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: _guardando ? null : _guardar,
            icon: _guardando
                ? const SizedBox(
                    width: 14, height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save, size: 18),
            label: const Text('Guardar'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _totalizando ? null : _totalizar,
            style: FilledButton.styleFrom(
                backgroundColor: Colors.green.shade700),
            icon: const Icon(Icons.check_circle, size: 18),
            label: Text(_totalizando ? 'Totalizando...' : 'Totalizar'),
          ),
        ],
      ),
    );
  }

  Widget _tabs(ColorScheme scheme) {
    return DefaultTabController(
      length: 2,
      child: TabBar(
        indicatorColor: scheme.primary,
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        tabs: const [
          Tab(icon: Icon(Icons.outbox), text: 'Salida (Origen)'),
          Tab(icon: Icon(Icons.inbox), text: 'Destino'),
        ],
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }

  Widget _tabContent(ColorScheme scheme) {
    final esOrigen = _tab == 0;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 560,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rowHeader(scheme),
            const SizedBox(height: 8),
            for (final item in _items) _itemRow(scheme, item, esOrigen),
          ],
        ),
      ),
    );
  }

  Widget _rowHeader(ColorScheme scheme) {
    final labelStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: scheme.onSurfaceVariant);
    return Row(
      children: [
        const SizedBox(width: 40),
        SizedBox(width: 130, child: Text('Producto', style: labelStyle)),
        const SizedBox(width: 32),
        const SizedBox(width: 40),
        SizedBox(
            width: 90,
            child: Text('Inicial',
                style: labelStyle, textAlign: TextAlign.right)),
        SizedBox(
            width: 80,
            child: Text('Traslado',
                style: labelStyle, textAlign: TextAlign.right)),
        SizedBox(
            width: 80,
            child: Text('Final', style: labelStyle, textAlign: TextAlign.right)),
      ],
    );
  }

  Widget _itemRow(ColorScheme scheme, AuditItem item, bool esOrigen) {
    final data = esOrigen ? item.origen : item.destino;
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: item.verificado ? scheme.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Checkbox(
            value: item.verificado,
            activeColor: scheme.primary,
            onChanged: (v) => _onVerify(item, v ?? false),
          ),
          SizedBox(
            width: 130,
            child: Text(
              item.ingrediente,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: scheme.onSurface),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history, size: 16),
            tooltip: 'Ver movimientos del producto',
            color: scheme.onSurfaceVariant,
            onPressed: () => _showHistorial(item),
          ),
          SizedBox(
            width: 40,
            child: esOrigen
                ? IconButton(
                    icon: const Icon(Icons.edit_note, size: 16),
                    tooltip: 'Ajustar stock',
                    color: scheme.primary,
                    onPressed: () => _showAjuste(item),
                  )
                : null,
          ),
          SizedBox(
            width: 90,
            child: Text(
              data.inicial.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: scheme.onSurface),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              data.trasladada.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13, color: scheme.primary),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              data.final_.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: scheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
