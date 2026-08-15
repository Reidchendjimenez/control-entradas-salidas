import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../data/pos_providers.dart';

/// Pantalla base del módulo POS (Fase 6.0 — capa de datos). La UI completa
/// (login PIN, mesas/habitaciones, comandas, caja, config) llega en 6.1–6.6.
class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mesas = ref.watch(mesasProvider);
    final usuarios = ref.watch(usuariosProvider);
    final platos = ref.watch(platosProvider);
    final comandas = ref.watch(comandasAbiertasProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('POS'),
        leading: const Icon(Icons.point_of_sale),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Card(
            child: ListTile(
              leading: Icon(Icons.dataset),
              title: Text('Capa de datos POS lista (Fase 6.0)'),
              subtitle: Text(
                  'Los repositorios y el motor de sync por sync_uuid ya están '
                  'operativos. La interfaz (login PIN, mesas, comandas, caja) '
                  'se construye en las fases 6.1–6.6.'),
            ),
          ),
          const SizedBox(height: 8),
          _fila('Mesas', mesas.value ?? const []),
          _fila('Usuarios', usuarios.value ?? const []),
          _fila('Platos', platos.value ?? const []),
          _fila('Comandas abiertas', comandas.value ?? const []),
        ],
      ),
    );
  }

  Widget _fila(String label, List<Object> lista) => Card(
        child: ListTile(
          leading: const Icon(Icons.chevron_right),
          title: Text('$label: ${lista.length}'),
        ),
      );
}

final mesasProvider = FutureProvider<List<PosMesa>>((ref) {
  return ref.watch(posRepoProvider).getMesas(soloActivos: true);
});

final usuariosProvider = FutureProvider<List<PosUsuario>>((ref) {
  return ref.watch(posRepoProvider).getUsuarios();
});

final platosProvider = FutureProvider<List<Plato>>((ref) {
  return ref.watch(posRepoProvider).getPlatos(soloActivos: true);
});

final comandasAbiertasProvider = FutureProvider<List<PosComanda>>((ref) {
  return ref.watch(posVentasRepoProvider).getComandasAbiertas();
});
