import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/presentation/login_screen.dart';
import '../auth/session_controller.dart';
import '../state/theme_controller.dart';
import '../../features/inventario/presentation/inventario_screen.dart';

/// Shell principal:
/// - si no hay sesión → LoginScreen (porta login_view.py).
/// - si hay sesión → Scaffold con drawer de navegación (porta app_controller.py).
///
/// El drawer tiene 8 destinos (inventario, validación, stock, producciones,
/// requisiciones, historial, ajustes, bandeja) que se implementan en las fases
/// 2-5. Mientras no existan, muestran un placeholder.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  static const List<_NavDest> _destinos = [
    _NavDest(Icons.shopping_cart_outlined, 'Inventario', '/inventario'),
    _NavDest(Icons.checklist_outlined, 'Validación', '/validacion'),
    _NavDest(Icons.warehouse_outlined, 'Stock', '/stock'),
    _NavDest(Icons.factory_outlined, 'Producciones', '/producciones'),
    _NavDest(Icons.local_shipping_outlined, 'Requisiciones', '/requisiciones'),
    _NavDest(Icons.history_outlined, 'Historial', '/historial'),
    _NavDest(Icons.settings_outlined, 'Ajustes', '/ajustes'),
    _NavDest(Icons.mail_outlined, 'Bandeja', '/bandeja'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final themeMode = ref.watch(themeControllerProvider);

    final baseDark = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFBB86FC),
        brightness: Brightness.dark,
      ),
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF000000),
    );
    final baseLight = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6200EE),
        brightness: Brightness.light,
      ),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: baseLight,
      darkTheme: baseDark,
      themeMode: themeMode,
      home: session is _Authenticated
          ? _ShellAutenticado(destinos: _destinos)
          : const LoginScreen(),
    );
  }
}

class _ShellAutenticado extends ConsumerStatefulWidget {
  const _ShellAutenticado({required this.destinos});
  final List<_NavDest> destinos;

  @override
  ConsumerState<_ShellAutenticado> createState() => _ShellAutenticadoState();
}

class _ShellAutenticadoState extends ConsumerState<_ShellAutenticado> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final ancho = MediaQuery.of(context).size.width;
    final esEscritorio = ancho >= 900;
    final dest = widget.destinos[_index];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(dest.icono, size: 22),
            const SizedBox(width: 10),
            Text(dest.label),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sincronizar',
            onPressed: () => _dispararSync(context),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6_outlined),
            tooltip: 'Tema',
            onPressed: () =>
                ref.read(themeControllerProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => ref.read(sessionProvider.notifier).cerrarSesion(),
          ),
        ],
      ),
      body: _DestinoPage(destino: dest),
      drawer: esEscritorio
          ? null
          : Drawer(
              child: ListView(
                children: [
                  const DrawerHeader(
                    decoration:
                        BoxDecoration(color: Color(0xFF000000)),
                    child: Text('Menú',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)),
                  ),
                  ...[
                    for (var i = 0; i < widget.destinos.length; i++)
                      ListTile(
                        leading: Icon(widget.destinos[i].icono),
                        title: Text(widget.destinos[i].label),
                        selected: i == _index,
                        onTap: () {
                          setState(() => _index = i);
                          Navigator.pop(context);
                        },
                      ),
                  ],
                ],
              ),
            ),
      bottomNavigationBar: esEscritorio
          ? null
          : NavigationBar(
              selectedIndex: _index > 3 ? 3 : _index,
              onDestinationSelected: (i) {
                if (i == 3) {
                  // "Más": abrir drawer.
                  Scaffold.of(context).openDrawer();
                } else {
                  setState(() => _index = i);
                }
              },
              destinations: [
                NavigationDestination(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: widget.destinos[0].label),
                NavigationDestination(
                    icon: const Icon(Icons.checklist_outlined),
                    label: 'Validar'),
                NavigationDestination(
                    icon: const Icon(Icons.warehouse_outlined),
                    label: 'Stock'),
                const NavigationDestination(
                    icon: Icon(Icons.more_vert), label: 'Más'),
              ],
            ),
    );
  }

  Future<void> _dispararSync(BuildContext context) async {
    final snackbar = ScaffoldMessenger.of(context);
    snackbar.showSnackBar(
      const SnackBar(
        content: Text('Sincronizando...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _DestinoPage extends StatelessWidget {
  const _DestinoPage({required this.destino});
  final _NavDest destino;

  @override
  Widget build(BuildContext context) {
    if (destino.ruta == '/inventario') {
      return const InventarioScreen();
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(destino.icono, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(destino.label,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Módulo pendiente (Fases 3-5)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _NavDest {
  final IconData icono;
  final String label;
  final String ruta;
  const _NavDest(this.icono, this.label, this.ruta);
}
