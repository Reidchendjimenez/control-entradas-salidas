import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/sync/sync_service.dart';
import '../data/historial_providers.dart';
import 'dialogs/exportar_dialog.dart';
import 'facturas_tab.dart';
import 'por_fecha_tab.dart';

/// Pantalla de Historial de facturas (porta `historial_facturas_view.py`).
/// Dos pestañas: "Facturas" y "Por Fecha", con indicador de conexión,
/// botón de exportar y refrescar en el header.
class HistorialScreen extends ConsumerStatefulWidget {
  const HistorialScreen({super.key});

  @override
  ConsumerState<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends ConsumerState<HistorialScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final offline = ref.watch(isOfflineProvider);

    return Column(
      children: [
        _buildHeader(scheme, offline),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: scheme.outlineVariant,
          indicatorColor: scheme.primary,
          labelColor: scheme.primary,
          unselectedLabelColor: scheme.onSurfaceVariant,
          tabs: const [
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Facturas'),
            Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Por Fecha'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [FacturasTab(), PorFechaTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ColorScheme scheme, bool offline) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              offline ? 'Modo offline' : 'Conectado',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: offline ? scheme.error : Colors.green,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, color: scheme.primary),
            tooltip: 'Exportar a Excel',
            onPressed: () => showExportarDialog(context),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: scheme.primary),
            tooltip: 'Refrescar',
            onPressed: () => _refrescar(),
          ),
          Icon(
            offline ? Icons.wifi_off : Icons.wifi,
            size: 18,
            color: offline ? scheme.error : Colors.green,
          ),
        ],
      ),
    );
  }

  Future<void> _refrescar() async {
    final engine = ref.read(syncEngineProvider);
    if (engine != null) {
      await engine.fullSync();
    }
    ref.invalidate(facturasProvider);
    ref.invalidate(porFechaProvider);
    ref.invalidate(historialRepoProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Actualizado'), duration: Duration(seconds: 2)),
      );
    }
  }
}
