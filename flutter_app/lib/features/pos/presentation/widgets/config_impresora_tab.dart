import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/pos_providers.dart';
import '../../data/ticket_escpos.dart';
import '../../data/ticket_settings.dart';
import '../dialogs/ticket_preview_dialog.dart';

/// Pestaña Impresora (port de `_build_printer_tab` de `usr/pos/views/config.py`):
/// membrete de comandas (nombre/RIF/dirección/teléfono), tamaño del membrete,
/// correlativo inicial y dispositivo de impresora (en web se guarda el path
/// para uso nativo; la impresión web se hace por vista previa + diálogo del
/// navegador, no requiere impresora).
class ConfigImpresoraTab extends ConsumerStatefulWidget {
  const ConfigImpresoraTab({super.key});

  @override
  ConsumerState<ConfigImpresoraTab> createState() => _ConfigImpresoraTabState();
}

class _ConfigImpresoraTabState extends ConsumerState<ConfigImpresoraTab> {
  final _nombreCtrl = TextEditingController();
  final _rifCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _correlativoCtrl = TextEditingController();
  final _deviceCtrl = TextEditingController();

  String _size = 'large';
  int _correlativoActual = 0;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _rifCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _correlativoCtrl.dispose();
    _deviceCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final repo = ref.read(posRepoProvider);
    final header = await cargarMembrete(repo);
    final corr = await getCorrelativoActual(repo);
    final device = await getPrinterDevice(repo);
    if (!mounted) return;
    setState(() {
      _nombreCtrl.text = header.nombre;
      _rifCtrl.text = header.rif;
      _direccionCtrl.text = header.direccion;
      _telefonoCtrl.text = header.telefono;
      _size = header.size;
      _correlativoActual = corr;
      _correlativoCtrl.text = corr.toString();
      _deviceCtrl.text = device ?? '';
    });
  }

  void _snack(String msg, {Color color = const Color(0xFF4CAF50)}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Future<void> _guardarMembrete() async {
    setState(() => _guardando = true);
    try {
      await guardarMembrete(
        ref.read(posRepoProvider),
        nombre: _nombreCtrl.text.trim(),
        rif: _rifCtrl.text.trim(),
        direccion: _direccionCtrl.text.trim(),
        telefono: _telefonoCtrl.text.trim(),
        size: _size,
      );
      _snack('Membrete guardado');
    } catch (e) {
      _snack('Error al guardar: $e', color: const Color(0xFFEF5350));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  Future<void> _guardarCorrelativo() async {
    final v = int.tryParse(_correlativoCtrl.text.trim());
    if (v == null || v < 0) {
      _snack('Ingrese un número válido', color: const Color(0xFFEF5350));
      return;
    }
    try {
      await setCorrelativoInicial(ref.read(posRepoProvider), v);
      setState(() => _correlativoActual = v);
      _snack('Correlativo establecido en $v');
    } catch (e) {
      _snack('Error: $e', color: const Color(0xFFEF5350));
    }
  }

  Future<void> _guardarDevice() async {
    try {
      await setPrinterDevice(ref.read(posRepoProvider), _deviceCtrl.text.trim());
      _snack('Dispositivo guardado');
    } catch (e) {
      _snack('Error: $e', color: const Color(0xFFEF5350));
    }
  }

  /// Vista previa de prueba (port de `test_imprimir` a web).
  Future<void> _probar() async {
    final repo = ref.read(posRepoProvider);
    final header = await cargarMembrete(repo);
    if (!mounted) return;
    final lineas = construirTicketPreview(
      items: const [
        (cantidad: 1, nombre: 'PRUEBA DE IMPRESIÓN', precio: 0, contornos: []),
      ],
      comandaId: 0,
      correlativo: _correlativoActual,
      header: header,
    );
    await showTicketPreview(context, lineas: lineas, titulo: 'Prueba de impresión');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: const Color(0xFFBB86FC),
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('MEMBRETE DE COMANDAS', style: labelStyle),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _guardando ? null : _guardarMembrete,
                      icon: const Icon(Icons.save),
                      label: Text(_guardando ? 'Guardando…' : 'Guardar membrete'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nombreCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la empresa',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _rifCtrl,
                  decoration: const InputDecoration(
                    labelText: 'RIF',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _direccionCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dirección',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _telefonoCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _size,
                  decoration: const InputDecoration(
                    labelText: 'Tamaño del membrete',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'small',
                      child: Text('Pequeño (condensado)'),
                    ),
                    DropdownMenuItem(value: 'normal', child: Text('Normal')),
                    DropdownMenuItem(value: 'large', child: Text('Grande')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _size = v);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CORRELATIVO DE COMANDAS', style: labelStyle),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('Actual:', style: TextStyle(color: scheme.onSurfaceVariant)),
                    const SizedBox(width: 8),
                    Text(
                      '$_correlativoActual',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _correlativoCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Correlativo inicial',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _guardarCorrelativo,
                      child: const Text('Establecer'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'El correlativo real de cada ticket sale de las ventas '
                  'registradas (máximo + 1), por lo que este valor es solo '
                  'informativo para el arranque.',
                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('IMPRESORA DE COMANDAS', style: labelStyle),
                const SizedBox(height: 4),
                Text(
                  'En web no se detectan impresoras USB; la impresión usa el '
                  'diálogo del navegador. El dispositivo se guarda para uso '
                  'nativo (Android/Windows).',
                  style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _deviceCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Dispositivo de impresora',
                    hintText: 'ej: /dev/usb/lp0 (solo nativo)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _guardarDevice,
                      icon: const Icon(Icons.usb),
                      label: const Text('Guardar dispositivo'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _probar,
                      icon: const Icon(Icons.print),
                      label: const Text('Probar impresión'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
