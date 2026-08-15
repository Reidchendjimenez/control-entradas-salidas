import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../data/pos_providers.dart';
import '../data/pos_session.dart';
import 'widgets/mesa_card.dart';
import 'widgets/pos_top_bar.dart';

/// Grid de mesas con estado Ocupada/Libre (port de `MesasView`).
class MesasScreen extends ConsumerWidget {
  const MesasScreen({
    super.key,
    required this.sesion,
    required this.onOpenMesa,
    required this.onBack,
    required this.onLogout,
  });

  final PosSesionActiva sesion;
  final ValueChanged<PosMesa> onOpenMesa;
  final VoidCallback onBack;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mesas = ref.watch(mesasProvider);
    final ocupadas = ref.watch(mesasOcupadasProvider);

    return Scaffold(
      body: Column(
        children: [
          PosTopBar(
            usuario: sesion.usuario,
            titulo: 'Mesas',
            onBack: onBack,
            onLogout: onLogout,
          ),
          Expanded(
            child: mesas.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (lista) {
                if (lista.isEmpty) return _vacio(context);
                final ocup = ocupadas.value ?? const <int>{};
                return GridView.extent(
                  padding: const EdgeInsets.all(20),
                  maxCrossAxisExtent: 130,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    for (final m in lista)
                      MesaCard(
                        mesa: m,
                        ocupada: ocup.contains(m.id),
                        onTap: () => onOpenMesa(m),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _vacio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.table_restaurant_outlined, size: 80),
          const SizedBox(height: 20),
          const Text('No hay mesas registradas',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Vaya a Configuración > Mesas para agregar',
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
