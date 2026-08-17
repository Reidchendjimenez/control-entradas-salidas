import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../data/pos_providers.dart';
import '../data/pos_session.dart';
import 'comanda_screen.dart';
import 'config_screen.dart';
import 'dialogs/nuevo_cajero_dialog.dart';
import 'dialogs/pin_dialog.dart';
import 'habitaciones_screen.dart';
import 'mesas_screen.dart';
import 'pos_home_screen.dart';
import 'ventas_screen.dart';
import 'widgets/usuario_card.dart';

/// Pantalla del módulo POS.
/// - Sin sesión: login PIN (Fase 6.1) — lista de cajeros, seed admin, alta.
/// - Con sesión: router de etapas (Fase 6.2): selector → mesas/habitaciones →
///   apertura de comanda. Ventas (6.4) con historial y anulación; Config (6.5)
///   con cajeros/mesas/habitaciones/platos/categorías/tasa BCV.
class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sesion = ref.watch(posSessionProvider);
    if (sesion == null) return const _LoginView();
    return _PosRouter(key: ValueKey(sesion.sesionId), sesion: sesion);
  }
}

// ===========================================================================
// Router por etapas (post-login)
// ===========================================================================

enum _PosStage { home, mesas, habitaciones, comanda, ventas, config }

class _PosRouter extends ConsumerStatefulWidget {
  const _PosRouter({super.key, required this.sesion});
  final PosSesionActiva sesion;

  @override
  ConsumerState<_PosRouter> createState() => _PosRouterState();
}

class _PosRouterState extends ConsumerState<_PosRouter> {
  _PosStage _stage = _PosStage.home;
  PosMesa? _mesa;
  PosHabitacione? _habitacion;

  void _go(_PosStage stage) {
    setState(() {
      _stage = stage;
      _mesa = null;
      _habitacion = null;
    });
  }

  void _abrirMesa(PosMesa m) {
    setState(() {
      _mesa = m;
      _habitacion = null;
      _stage = _PosStage.comanda;
    });
  }

  void _abrirHabitacion(PosHabitacione h) {
    setState(() {
      _habitacion = h;
      _mesa = null;
      _stage = _PosStage.comanda;
    });
  }

  void _cerrarSesion() {
    ref.read(posSessionProvider.notifier).cerrarSesion();
  }

  /// Retoma una comanda activa desde el home (resuelve mesa/habitación por id
  /// y abre la etapa de comanda directamente).
  Future<void> _abrirComandaActiva(int? mesaId, int? habitacionId) async {
    final repo = ref.read(posRepoProvider);
    if (mesaId != null) {
      final m = await repo.getMesaById(mesaId);
      if (m == null) return;
      if (!mounted) return;
      setState(() {
        _mesa = m;
        _habitacion = null;
        _stage = _PosStage.comanda;
      });
    } else if (habitacionId != null) {
      final h = await repo.getHabitacionById(habitacionId);
      if (h == null) return;
      if (!mounted) return;
      setState(() {
        _habitacion = h;
        _mesa = null;
        _stage = _PosStage.comanda;
      });
    }
  }

  /// Después de anular una venta: abre la comanda de la mesa/habitación
  /// devuelta para corregirla y volver a cobrar (port de `VentasView._ir_a_comanda`).
  Future<void> _corregirVenta(int? mesaId, int? habitacionId) async {
    final repo = ref.read(posRepoProvider);
    if (mesaId != null) {
      final m = await repo.getMesaById(mesaId);
      if (m == null) {
        _go(_PosStage.ventas);
        return;
      }
      if (!mounted) return;
      setState(() {
        _mesa = m;
        _habitacion = null;
        _stage = _PosStage.comanda;
      });
    } else if (habitacionId != null) {
      final h = await repo.getHabitacionById(habitacionId);
      if (h == null) {
        _go(_PosStage.ventas);
        return;
      }
      if (!mounted) return;
      setState(() {
        _habitacion = h;
        _mesa = null;
        _stage = _PosStage.comanda;
      });
    } else {
      _go(_PosStage.ventas);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.sesion;
    switch (_stage) {
      case _PosStage.mesas:
        return MesasScreen(
          sesion: s,
          onOpenMesa: _abrirMesa,
          onBack: () => _go(_PosStage.home),
          onLogout: _cerrarSesion,
        );
      case _PosStage.habitaciones:
        return HabitacionesScreen(
          sesion: s,
          onOpenHabitacion: _abrirHabitacion,
          onBack: () => _go(_PosStage.home),
          onLogout: _cerrarSesion,
        );
      case _PosStage.comanda:
        return ComandaScreen(
          sesion: s,
          mesa: _mesa,
          habitacion: _habitacion,
          onBack: () => _go(_PosStage.home),
          onLogout: _cerrarSesion,
        );
      case _PosStage.ventas:
        return VentasScreen(
          sesion: s,
          onBack: () => _go(_PosStage.home),
          onLogout: _cerrarSesion,
          onCorregirVenta: _corregirVenta,
        );
      case _PosStage.config:
        return ConfigScreen(
          sesion: s,
          onBack: () => _go(_PosStage.home),
          onLogout: _cerrarSesion,
        );
      case _PosStage.home:
        return PosHomeScreen(
          sesion: s,
          onMesas: () => _go(_PosStage.mesas),
          onHabitaciones: () => _go(_PosStage.habitaciones),
          onVentas: () => _go(_PosStage.ventas),
          onConfig: () => _go(_PosStage.config),
          onLogout: _cerrarSesion,
          onAbrirComanda: _abrirComandaActiva,
        );
    }
  }
}

// ===========================================================================
// Login PIN
// ===========================================================================

class _LoginView extends ConsumerStatefulWidget {
  const _LoginView();

  @override
  ConsumerState<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<_LoginView> {
  int? _selectedId;

  @override
  void initState() {
    super.initState();
    _seedAdmin();
  }

  /// Port de `POSLoginView._seed_default_admin`: si no hay cajeros, crea
  /// "Desarrollador" (admin, sin PIN) para la primera entrada.
  Future<void> _seedAdmin() async {
    final repo = ref.read(posRepoProvider);
    if ((await repo.getUsuarios()).isEmpty) {
      await repo.crearUsuario('Desarrollador', esAdmin: true);
      ref.invalidate(usuariosProvider);
    }
  }

  Future<void> _login(PosUsuario u) async {
    if (u.pinHash != null && u.pinHash!.isNotEmpty) {
      final ok = await showPinDialog(context, u);
      if (!ok && mounted) {
        ref.invalidate(usuariosProvider);
        return;
      }
    }
    final notifier = ref.read(posSessionProvider.notifier);
    final result = await notifier.iniciarSesion(u);
    if (!mounted) return;

    if (result == SesionLoginResult.sesionAjena) {
      // Turno abierto de otro usuario: preguntar qué hacer.
      final cerrar = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Turno abierto de otro cajero'),
          content: Text(
            'Hay un turno abierto de ${notifier.sesionAjenaNombre ?? "otro cajero"}. '
            '¿Cerrar ese turno y abrir uno nuevo para ${u.nombre}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Retomar turno existente'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Cerrar y abrir nuevo'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (cerrar == true) {
        await notifier.forzarCerrarSesionAjena(u);
      } else {
        await notifier.retomarSesionAjena(u);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final usuarios = ref.watch(usuariosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lycoris POS'),
        leading: Image.asset(
          'assets/icono_azul.png',
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront, size: 40, color: scheme.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Lycoris POS',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'Seleccione el cajero',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
              const SizedBox(height: 16),
              usuarios.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (lista) => lista.isEmpty
                    ? _sinCajeros()
                    : Column(
                        children: [
                          for (final u in lista) ...[
                            UsuarioCard(
                              usuario: u,
                              selected: u.id == _selectedId,
                              onTap: () {
                                setState(() => _selectedId = u.id);
                                _login(u);
                              },
                            ),
                            const SizedBox(height: 8),
                          ],
                          const SizedBox(height: 8),
                          _loginButton(lista),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sinCajeros() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.person_off_outlined, size: 48),
            const SizedBox(height: 8),
            const Text('No hay cajeros registrados',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Agregue uno con el botón de abajo',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => showNuevoCajeroDialog(context),
              icon: const Icon(Icons.person_add_alt_1_outlined),
              label: const Text('Nuevo cajero'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton(List<PosUsuario> lista) {
    final selected = lista.where((u) => u.id == _selectedId).firstOrNull;
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: selected == null
                ? null
                : () {
                    setState(() => _selectedId = selected.id);
                    _login(selected);
                  },
            icon: const Icon(Icons.login),
            label: Text(selected == null
                ? 'Iniciar sesión'
                : 'Iniciar sesión como ${selected.nombre}'),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          tooltip: 'Nuevo cajero',
          onPressed: () => showNuevoCajeroDialog(context),
          icon: const Icon(Icons.person_add_alt_1),
        ),
      ],
    );
  }
}
