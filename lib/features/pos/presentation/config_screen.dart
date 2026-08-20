import 'package:flutter/material.dart';

import '../../../core/sync/global_sync_bar.dart';
import '../../../core/updater/update_settings_card.dart';
import '../data/pos_session.dart';
import 'widgets/config_categorias_tab.dart';
import 'widgets/config_habitaciones_tab.dart';
import 'widgets/config_impresora_tab.dart';
import 'widgets/config_mesas_tab.dart';
import 'widgets/config_platos_tab.dart';
import 'widgets/config_tasa_tab.dart';
import 'widgets/config_usuarios_tab.dart';
import 'widgets/pos_top_bar.dart';

/// Configuración del POS (port de `ConfigPOSView` de config.py): pestañas de
/// cajeros, mesas, habitaciones, platos, categorías POS/sub-categorías, tasa
/// BCV e impresora (membrete/correlativo/dispositivo).
class ConfigScreen extends StatelessWidget {
  const ConfigScreen({
    super.key,
    required this.sesion,
    required this.onBack,
    required this.onLogout,
  });

  final PosSesionActiva sesion;
  final VoidCallback onBack;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        body: Column(
          children: [
            PosTopBar(
              usuario: sesion.usuario,
              titulo: 'Configuración',
              onBack: onBack,
              onLogout: onLogout,
            ),
            const GlobalSyncBar(),
            const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                Tab(text: 'Cajeros', icon: Icon(Icons.person_outline)),
                Tab(text: 'Mesas', icon: Icon(Icons.table_bar_outlined)),
                Tab(
                  text: 'Habitaciones',
                  icon: Icon(Icons.hotel_outlined),
                ),
                Tab(text: 'Platos', icon: Icon(Icons.restaurant_outlined)),
                Tab(
                  text: 'Categorías',
                  icon: Icon(Icons.category_outlined),
                ),
                Tab(text: 'Tasa BCV', icon: Icon(Icons.currency_exchange)),
                Tab(text: 'Impresora', icon: Icon(Icons.print_outlined)),
                Tab(text: 'Actualización', icon: Icon(Icons.system_update)),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  ConfigUsuariosTab(),
                  ConfigMesasTab(),
                  ConfigHabitacionesTab(),
                  ConfigPlatosTab(),
                  ConfigCategoriasTab(),
                  ConfigTasaTab(),
                  ConfigImpresoraTab(),
                  _ActualizacionesTab(),
                ],
              ),
            ),          ],
        ),
      ),
    );
  }
}

/// Pestaña de actualizaciones (escritorio/Android).
class _ActualizacionesTab extends StatelessWidget {
  const _ActualizacionesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [UpdateSettingsCard()],
    );
  }
}
