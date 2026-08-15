import 'package:flutter/material.dart';

import '../data/pos_session.dart';
import 'widgets/entry_card.dart';
import 'widgets/pos_top_bar.dart';

/// Selector de entrada de comandas (port de `ComandasView`): mesas,
/// habitaciones y ventas. El botón de config aparece solo para admins.
class PosHomeScreen extends StatelessWidget {
  const PosHomeScreen({
    super.key,
    required this.sesion,
    required this.onMesas,
    required this.onHabitaciones,
    required this.onVentas,
    required this.onConfig,
    required this.onLogout,
  });

  final PosSesionActiva sesion;
  final VoidCallback onMesas;
  final VoidCallback onHabitaciones;
  final VoidCallback onVentas;
  final VoidCallback onConfig;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final esAdmin = sesion.usuario.esAdmin == 1;

    return Scaffold(
      body: Column(
        children: [
          PosTopBar(
            usuario: sesion.usuario,
            titulo: 'POS',
            onLogout: onLogout,
            actions: [
              if (esAdmin)
                IconButton(
                  tooltip: 'Configuración',
                  onPressed: onConfig,
                  icon: const Icon(Icons.settings, color: Color(0xFFF57C00)),
                ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Comandas',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Seleccione el punto de entrada',
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 30,
                  runSpacing: 30,
                  children: [
                    EntryCard(
                      icon: Icons.restaurant,
                      titulo: 'Mesas',
                      subtitulo: 'Área del restaurante',
                      color: const Color(0xFFEF5350),
                      onTap: onMesas,
                    ),
                    EntryCard(
                      icon: Icons.hotel,
                      titulo: 'Habitaciones',
                      subtitulo: 'Servicio a la habitación',
                      color: const Color(0xFF4FC3F7),
                      onTap: onHabitaciones,
                    ),
                    EntryCard(
                      icon: Icons.receipt_long,
                      titulo: 'Ventas',
                      subtitulo: 'Historial y devoluciones',
                      color: const Color(0xFF66BB6A),
                      onTap: onVentas,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
