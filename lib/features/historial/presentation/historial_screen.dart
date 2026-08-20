import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dialogs/exportar_dialog.dart';
import 'facturas_tab.dart';
import 'por_fecha_tab.dart';

/// Pantalla de Historial de facturas (porta `historial_facturas_view.py`).
/// Dos pestañas: "Facturas" y "Por Fecha", con botón de exportar.
/// El indicador de conexión y el refresh viven en el header global del shell.
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

    return Column(
      children: [
        _buildHeader(scheme),
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

  Widget _buildHeader(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          const Spacer(),
          IconButton(
            icon: Icon(Icons.download, color: scheme.primary),
            tooltip: 'Exportar a Excel',
            onPressed: () => showExportarDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
