import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/categorias_tab.dart';
import 'widgets/productos_tab.dart';
import 'widgets/proveedores_tab.dart';
import 'widgets/sistema_tab.dart';
import 'widgets/periodos_tab.dart';

/// Pantalla de Configuración / Ajustes (porta `usr/views/configuracion_view.py`).
///
/// 5 pestañas: Categorias, Productos, Proveedores, Sistema, Periodos.
class ConfiguracionScreen extends ConsumerStatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  ConsumerState<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends ConsumerState<ConfiguracionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          dividerColor: scheme.outlineVariant,
          indicatorColor: scheme.primary,
          labelColor: scheme.primary,
          unselectedLabelColor: scheme.onSurfaceVariant,
          tabs: const [
            Tab(icon: Icon(Icons.category_outlined), text: 'Categorías'),
            Tab(icon: Icon(Icons.inventory_2_outlined), text: 'Productos'),
            Tab(icon: Icon(Icons.local_shipping_outlined), text: 'Proveedores'),
            Tab(icon: Icon(Icons.settings_outlined), text: 'Sistema'),
            Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Periodos'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              CategoriasTab(),
              ProductosTab(),
              ProveedoresTab(),
              SistemaTab(),
              PeriodosTab(),
            ],
          ),
        ),
      ],
    );
  }
}