import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../data/pos_comanda_models.dart';
import '../data/pos_providers.dart';
import '../data/pos_repository.dart';
import '../data/pos_session.dart';
import 'dialogs/cobro_dialog.dart';
import 'dialogs/contornos_dialog.dart';
import 'widgets/catalogo_card.dart';
import 'widgets/pos_top_bar.dart';

/// Editor de comanda (Fase 6.3 — port de `ComandaPedidoView`): catálogo
/// (categorías → sub-categorías → platos/productos, contornos) + panel de
/// items con total. El cobro/caja llega en 6.4.
class ComandaScreen extends ConsumerStatefulWidget {
  const ComandaScreen({
    super.key,
    required this.sesion,
    this.mesa,
    this.habitacion,
    required this.onBack,
    required this.onLogout,
  });

  final PosSesionActiva sesion;
  final PosMesa? mesa;
  final PosHabitacione? habitacion;
  final VoidCallback onBack;
  final VoidCallback onLogout;

  @override
  ConsumerState<ComandaScreen> createState() => _ComandaScreenState();
}

enum _Seccion { categorias, subcategorias, productos, platos, platosDeCat, contornos }

class _CatalogoEntry {
  const _CatalogoEntry({
    required this.nombre,
    required this.color,
    this.subtitulo,
    this.badge = false,
    required this.onTap,
  });
  final String nombre;
  final String color;
  final String? subtitulo;
  final bool badge;
  final VoidCallback onTap;
}

class _ComandaScreenState extends ConsumerState<ComandaScreen> {
  final _items = <ComandaItem>[];
  int? _comandaId;
  double _tasa = 0;
  String _tasaFecha = '';
  bool _iniciando = true;

  _Seccion _seccion = _Seccion.categorias;
  final _historial = <_Seccion>[];
  String _titulo = 'CATEGORÍAS';
  String _tituloColor = '#9E9E9E';
  List<_CatalogoEntry> _catalogo = [];

  String get _ubicacion {
    final m = widget.mesa;
    final h = widget.habitacion;
    if (m != null) {
      final extra = [m.nombre, m.zona].whereType<String>().where((s) => s.isNotEmpty).join(' - ');
      return 'Mesa ${m.numero}${extra.isNotEmpty ? ' - $extra' : ''}';
    }
    if (h != null) {
      final extra = [h.piso, h.tipo].whereType<String>().where((s) => s.isNotEmpty).join(' - ');
      return 'Habitación ${h.numero}${extra.isNotEmpty ? ' - $extra' : ''}';
    }
    return 'Comanda';
  }

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  Future<void> _iniciar() async {
    final repo = ref.read(posRepoProvider);
    _tasa = await repo.getTasaCambio();
    _tasaFecha = await repo.getTasaCambioFecha();
    await _cargarComandaExistente();
    await _cargarCategorias();
    if (mounted) setState(() => _iniciando = false);
  }

  // =========================================================================
  // Comanda (items + persistencia)
  // =========================================================================

  Future<void> _cargarComandaExistente() async {
    final repo = ref.read(posVentasRepoProvider);
    final existente = await repo.getComandaAbierta(
      mesaId: widget.mesa?.id,
      habitacionId: widget.habitacion?.id,
    );
    if (existente == null) return;
    _comandaId = existente.id;
    _items
      ..clear()
      ..addAll(ComandaItem.listFromJson(existente.itemsJson));
  }

  Future<void> _guardar() async {
    if (_items.isEmpty) return;
    final total = _total;
    final comandaId = await ref.read(posVentasRepoProvider).guardarComanda(
          widget.sesion.sesionId,
          [for (final i in _items) i.toJson()],
          total,
          mesaId: widget.mesa?.id,
          habitacionId: widget.habitacion?.id,
        );
    _comandaId = comandaId;
    ref.invalidate(mesasOcupadasProvider);
    ref.invalidate(habitacionesOcupadasProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Comanda guardada')));
    widget.onBack();
  }

  Future<void> _eliminarComanda() async {
    final id = _comandaId;
    if (id == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar comanda'),
        content:
            const Text('¿Eliminar esta comanda? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await ref.read(posVentasRepoProvider).eliminarComanda(id);
    _comandaId = null;
    _items.clear();
    ref.invalidate(mesasOcupadasProvider);
    ref.invalidate(habitacionesOcupadasProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Comanda eliminada')));
    widget.onBack();
  }

  void _cobrar() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => CobroDialog(
        total: _total,
        tasa: _tasa,
        tasaFecha: _tasaFecha,
        ubicacion: _ubicacion,
        onConfirm: _confirmarCobro,
      ),
    );
  }

  Future<void> _confirmarCobro() async {
    if (!mounted) return;
    final repo = ref.read(posVentasRepoProvider);
    final mesaI = widget.mesa?.id;
    final habId = widget.habitacion?.id;
    final total = _total;
    final itemsJson = [for (final i in _items) i.toJson()];
    int? ventaId;
    try {
      final comandaId = await repo.guardarComanda(
        widget.sesion.sesionId,
        itemsJson,
        total,
        mesaId: mesaI,
        habitacionId: habId,
      );
      final anulada = await repo.getVentaAnuladaPorComanda(comandaId);
      final ventaAnulaId = anulada?.id;
      final correlativo = await repo.siguienteCorrelativo();

      ventaId = await repo.registrarVenta(
        correlativo,
        total,
        itemsJson,
        comandaId: comandaId,
        mesaId: mesaI,
        habitacionId: habId,
        usuarioId: widget.sesion.usuario.id,
        sesionId: widget.sesion.sesionId,
        ventaAnulaId: ventaAnulaId,
        tasaBs: _tasa > 0 ? _tasa : null,
      );
      final movs = await repo.resolverMovimientosVenta(itemsJson);
      if (movs.isNotEmpty) {
        await repo.aplicarMovimientosVenta(ventaId, movs,
            registradoPor: widget.sesion.usuario.nombre);
      }
      await repo.cerrarComanda(comandaId);
      _comandaId = null;
      _items.clear();
      ref.invalidate(mesasOcupadasProvider);
      ref.invalidate(habitacionesOcupadasProvider);
      ref.invalidate(ventasProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Comanda #${correlativo.toString().padLeft(5, '0')} cobrada'),
      ));
      widget.onBack();
    } catch (ex) {
      if (ventaId != null) {
        try {
          await repo.eliminarVentaYMovimientos(ventaId);
        } catch (_) {}
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al cobrar: $ex')));
    }
  }

  // =========================================================================
  // Catálogo: navegación
  // =========================================================================

  void _ir(_Seccion s) {
    _historial.add(_seccion);
    setState(() => _seccion = s);
  }

  void _volver() {
    if (_historial.isEmpty) {
      _cargarCategorias();
      return;
    }
    setState(() => _seccion = _historial.removeLast());
  }

  Future<void> _cargarCategorias() async {
    final repo = ref.read(posRepoProvider);
    final cats = await repo.getCategoriasPos();
    final posCats = await repo.getPosCategorias(soloActivas: true);
    final platosCats = await repo.getPlatosCategorias(soloActivas: true);
    final contornos = await repo.getContornosActivos();

    final rootPlatosCats = platosCats
        .where((c) =>
            c.categoriaPadreId == null &&
            c.posCategoriaPadreId == null &&
            !{for (final ct in contornos) ct.categoriaId}.contains(c.id))
        .toList();
    final hayPlatos = rootPlatosCats.isNotEmpty;

    final entries = <_CatalogoEntry>[
      for (final c in cats)
        _CatalogoEntry(
          nombre: c.nombre,
          color: c.color,
          onTap: () => _clickCategoria(c.id, c.color, c.nombre, esPos: false),
        ),
      for (final pc in posCats)
        _CatalogoEntry(
          nombre: pc.nombre,
          color: pc.color,
          onTap: () => _clickCategoria(pc.id, pc.color, pc.nombre, esPos: true),
        ),
      if (hayPlatos)
        _CatalogoEntry(
          nombre: 'PLATOS',
          color: '#FF6F00',
          onTap: _cargarPlatosSeccion,
        ),
      if (contornos.isNotEmpty)
        _CatalogoEntry(
          nombre: 'CONTORNOS',
          color: '#26A69A',
          onTap: _cargarContornos,
        ),
    ];

    _historial.clear();
    setState(() {
      _seccion = _Seccion.categorias;
      _titulo = 'CATEGORÍAS';
      _tituloColor = '#9E9E9E';
      _catalogo = entries;
    });
  }

  Future<void> _clickCategoria(
    int id,
    String color,
    String nombre, {
    required bool esPos,
  }) async {
    final repo = ref.read(posRepoProvider);
    final subcats = await repo.getSubcategorias(
      categoriaPadreId: esPos ? null : id,
      posCategoriaPadreId: esPos ? id : null,
    );
    if (subcats.isNotEmpty) {
      await _cargarSubcategorias(subcats, id, color, nombre);
      return;
    }
    await _cargarProductos(id, color, nombre);
  }

  Future<void> _cargarSubcategorias(
    List<PlatosCategoria> subcats,
    int padreId,
    String color,
    String nombre,
  ) async {
    final repo = ref.read(posRepoProvider);
    final prods = await repo.getProductosPos(categoriaId: padreId);
    final entries = <_CatalogoEntry>[
      for (final sc in subcats)
        _CatalogoEntry(
          nombre: sc.nombre,
          color: sc.color,
          onTap: () => _cargarPlatos(sc.id, sc.color, sc.nombre),
        ),
      if (prods.isNotEmpty) ...[
        const _CatalogoEntry(
          nombre: 'PRODUCTOS',
          color: '#4CAF50',
          onTap: _noop,
        ),
        for (final p in prods)
          _CatalogoEntry(
            nombre: p.nombre,
            color: '#4CAF50',
            subtitulo: '\$${p.precioVenta.toStringAsFixed(2)}',
            onTap: () => _agregarItem(
                id: p.id, nombre: p.nombre, precio: p.precioVenta, tipo: 'producto'),
          ),
      ],
    ];
    _ir(_Seccion.subcategorias);
    setState(() {
      _titulo = '$nombre > Sub-categorías';
      _tituloColor = color;
      _catalogo = entries;
    });
  }

  Future<void> _cargarProductos(int categoriaId, String color, String nombre) async {
    final repo = ref.read(posRepoProvider);
    final prods = await repo.getProductosPos(categoriaId: categoriaId);
    final entries = [
      for (final p in prods)
        _CatalogoEntry(
          nombre: p.nombre,
          color: color,
          subtitulo: '\$${p.precioVenta.toStringAsFixed(2)}',
          onTap: () => _agregarItem(
              id: p.id, nombre: p.nombre, precio: p.precioVenta, tipo: 'producto'),
        ),
    ];
    _ir(_Seccion.productos);
    setState(() {
      _titulo = nombre.toUpperCase();
      _tituloColor = color;
      _catalogo = entries;
    });
  }

  Future<void> _cargarPlatosSeccion() async {
    final repo = ref.read(posRepoProvider);
    final pcats = await repo.getPlatosCategorias(soloActivas: true);
    final contornos = await repo.getContornosActivos();
    final contornoCatIds = {for (final c in contornos) c.categoriaId};
    final root = pcats
        .where((c) =>
            c.categoriaPadreId == null &&
            c.posCategoriaPadreId == null &&
            !contornoCatIds.contains(c.id))
        .toList();
    final entries = [
      for (final c in root)
        _CatalogoEntry(
          nombre: c.nombre,
          color: c.color,
          onTap: () => _cargarPlatos(c.id, c.color, c.nombre),
        ),
    ];
    _ir(_Seccion.platos);
    setState(() {
      _titulo = 'PLATOS';
      _tituloColor = '#FF6F00';
      _catalogo = entries;
    });
  }

  Future<void> _cargarPlatos(int categoriaId, String color, String nombre) async {
    final repo = ref.read(posRepoProvider);
    final platos = await repo.getPlatos(
        soloActivos: true, categoriaId: categoriaId, esContorno: false);
    final entries = [
      for (final p in platos)
        _CatalogoEntry(
          nombre: p.nombre,
          color: color,
          subtitulo: '\$${p.precioVenta.toStringAsFixed(2)}',
          badge: p.llevaContornos == 1,
          onTap: () => _agregarItem(
              id: p.id,
              nombre: p.nombre,
              precio: p.precioVenta,
              tipo: 'plato',
              llevaContornos: p.llevaContornos == 1),
        ),
    ];
    _ir(_Seccion.platosDeCat);
    setState(() {
      _titulo = nombre.toUpperCase();
      _tituloColor = color;
      _catalogo = entries;
    });
  }

  Future<void> _cargarContornos() async {
    final repo = ref.read(posRepoProvider);
    final contornos = await repo.getContornosActivos();
    final entries = [
      for (final c in contornos)
        _CatalogoEntry(
          nombre: c.nombre,
          color: '#26A69A',
          subtitulo: '\$${c.precioVenta.toStringAsFixed(2)}',
          onTap: () => _agregarItem(
              id: c.id, nombre: c.nombre, precio: c.precioVenta, tipo: 'contorno'),
        ),
    ];
    _ir(_Seccion.contornos);
    setState(() {
      _titulo = 'CONTORNOS';
      _tituloColor = '#26A69A';
      _catalogo = entries;
    });
  }

  // =========================================================================
  // Items
  // =========================================================================

  Future<void> _agregarItem({
    required int id,
    required String nombre,
    required double precio,
    required String tipo,
    bool llevaContornos = false,
  }) async {
    if (llevaContornos) {
      final contornos = await ref.read(posRepoProvider).getContornosActivos();
      if (contornos.isNotEmpty) {
        if (!mounted) return;
        final seleccionados = await showContornosDialog(
            context, _platoStub(id, nombre), contornos);
        if (seleccionados.isEmpty) return;
        _agregarItemConContornos(id, nombre, precio, seleccionados);
        return;
      }
    }
    for (final item in _items) {
      if (item.id == id && !item.tieneContornos) {
        setState(() => item.cantidad++);
        return;
      }
    }
    setState(() {
      _items.add(ComandaItem(
        id: id,
        tipo: tipo,
        nombre: nombre,
        precio: precio,
        cantidad: 1,
      ));
    });
  }

  void _agregarItemConContornos(int id, String nombre, double precio, List<Plato> contornos) {
    for (final item in _items) {
      if (item.id == id && !item.tieneContornos) {
        setState(() => item.cantidad++);
        return;
      }
    }
    setState(() {
      _items.add(ComandaItem(
        id: id,
        tipo: 'plato',
        nombre: nombre,
        precio: precio,
        cantidad: 1,
        contornos: [for (final c in contornos) (id: c.id, nombre: c.nombre)],
      ));
    });
  }

  Plato _platoStub(int id, String nombre) => Plato(
        id: id,
        nombre: nombre,
        categoriaId: 0,
        precioVenta: 0,
        activo: 1,
        esContorno: 0,
        llevaContornos: 1,
      );

  void _cambiarCantidad(int idx, int delta) {
    if (idx < 0 || idx >= _items.length) return;
    setState(() => _items[idx].cantidad = (_items[idx].cantidad + delta).clamp(1, 9999));
  }

  void _eliminarItem(int idx) {
    if (idx < 0 || idx >= _items.length) return;
    setState(() => _items.removeAt(idx));
  }

  double get _total => _items.fold(0, (s, i) => s + i.subtotal);

  static void _noop() {}

  // =========================================================================
  // UI
  // =========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          PosTopBar(
            usuario: widget.sesion.usuario,
            titulo: _ubicacion,
            onBack: widget.onBack,
            onLogout: widget.onLogout,
          ),
          const Divider(height: 1),
          Expanded(
            child: _iniciando
                ? const Center(child: CircularProgressIndicator())
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 300,
                        child: _panelComanda(),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(child: _panelCatalogo()),
                    ],
                  ),
          ),
          _franjaBotones(),
        ],
      ),
    );
  }

  Widget _panelComanda() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Text(
            'COMANDA',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: _items.isEmpty
              ? const Center(
                  child: Text(
                    'Seleccione productos',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, i) => _itemRow(i),
                ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('TOTAL:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text(
                    '\$${_total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.sync, size: 16, color: Color(0xFFF57C00)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _tasa > 0
                          ? 'Tasa: ${formatearTasa(_tasa)} Bs/\$'
                          : 'Sin tasa',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                  Text(
                    _tasa > 0
                        ? 'Bs ${formatearBs(_total * _tasa)}'
                        : 'Bs --',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF26A69A),
                    ),
                  ),
                ],
              ),
              if (_tasaFecha.isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Actualizada: ${_tasaFecha.substring(0, 10)}',
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _itemRow(int i) {
    final item = _items[i];
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: i.isEven ? scheme.surfaceContainerHigh : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.nombre,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                Text(
                  '\$${item.precio.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                ),
                for (final c in item.contornos)
                  Text(
                    '+ ${c.nombre}',
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFFF57C00)),
                  ),
              ],
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _cambiarCantidad(i, -1),
            icon: const Icon(Icons.remove_circle_outline,
                size: 18, color: Color(0xFFF57C00)),
          ),
          Text('${item.cantidad}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _cambiarCantidad(i, 1),
            icon: const Icon(Icons.add_circle_outline,
                size: 18, color: Color(0xFF4CAF50)),
          ),
          const SizedBox(width: 4),
          Text(
            '\$${item.subtotal.toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => _eliminarItem(i),
            icon: const Icon(Icons.delete_outline,
                size: 18, color: Color(0xFFEF5350)),
          ),
        ],
      ),
    );
  }

  Widget _panelCatalogo() {
    final scheme = Theme.of(context).colorScheme;
    final showBack = _seccion != _Seccion.categorias;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              if (showBack)
                IconButton(
                  tooltip: 'Volver',
                  onPressed: _volver,
                  icon: const Icon(Icons.arrow_back),
                ),
              Expanded(
                child: Text(
                  _titulo,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: _colorHex(_tituloColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _catalogo.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.category_outlined,
                          size: 50, color: scheme.onSurfaceVariant),
                      const SizedBox(height: 8),
                      const Text('No hay elementos'),
                    ],
                  ),
                )
              : GridView.extent(
                  padding: const EdgeInsets.all(12),
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    for (final e in _catalogo)
                      CatalogoCard(
                        nombre: e.nombre,
                        color: e.color,
                        subtitulo: e.subtitulo,
                        badge: e.badge,
                        onTap: e.onTap,
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _franjaBotones() {
    final tieneItems = _items.isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          OutlinedButton.icon(
            onPressed: widget.onBack,
            icon: const Icon(Icons.cancel, color: Color(0xFFEF5350)),
            label: const Text('Cancelar'),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _comandaId == null ? null : _eliminarComanda,
            icon: const Icon(Icons.delete_outline, color: Color(0xFFEF5350)),
            label: const Text('Eliminar'),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: tieneItems ? _guardar : null,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Guardar'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            onPressed: tieneItems ? _cobrar : null,
            icon: const Icon(Icons.payments_outlined),
            label: const Text('Cobrar'),
          ),
        ],
      ),
    );
  }

  Color _colorHex(String hex) {
    final v = int.tryParse(hex.replaceFirst('#', ''), radix: 16);
    return v == null ? const Color(0xFF9E9E9E) : Color(0xFF000000 | v);
  }
}
