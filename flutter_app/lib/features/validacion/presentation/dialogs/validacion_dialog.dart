import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/validacion_providers.dart';
import '../../data/validacion_repository.dart';
import '../widgets/pagos_panel.dart';

const _prefijos = {'Factura': 'F-', 'Nota de Entrega': 'NE-', 'Entrada': 'EV-'};

/// Diálogo de validación de entradas (porta `ValidacionDialog` de dialog.py +
/// `ValidacionFields` de fields.py; sin el asistente OCR de IA).
/// Devuelve un [ResultadoValidacion] si se validó, o `null` si se canceló.
Future<ResultadoValidacion?> showValidacionDialog(
  BuildContext context, {
  required Set<int> selectedEntradas,
  required String usuario,
}) {
  return showDialog<ResultadoValidacion>(
    context: context,
    builder: (ctx) => _ValidacionDialog(
      selectedEntradas: selectedEntradas,
      usuario: usuario,
    ),
  );
}

class _ValidacionDialog extends ConsumerStatefulWidget {
  const _ValidacionDialog({
    required this.selectedEntradas,
    required this.usuario,
  });

  final Set<int> selectedEntradas;
  final String usuario;

  @override
  ConsumerState<_ValidacionDialog> createState() => _ValidacionDialogState();
}

class _ValidacionDialogState extends ConsumerState<_ValidacionDialog> {
  final _facturaCtrl = TextEditingController();
  final _nuevoProveedorCtrl = TextEditingController();
  final _nuevoRifCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();

  String _tipoDocumento = 'Factura';
  String? _proveedor; // valor del dropdown; '__nuevo__' abre campos nuevos
  DateTime _fecha = DateTime.now();
  bool _validando = false;

  final _pagosKey = GlobalKey<PagosPanelState>();
  StreamSubscription? _pasteSub;

  @override
  void initState() {
    super.initState();
    _fecha = DateTime.now();
    if (kIsWeb) {
      _initWebPasteListener();
    }
  }

  void _initWebPasteListener() {
    try {
      _pasteSub = html.document.onPaste.listen((html.ClipboardEvent event) {
        final items = event.clipboardData?.items;
        if (items == null) return;
        final count = items.length as int;
        for (int i = 0; i < count; i++) {
          final item = items[i];
          if (item.type?.startsWith('image/') == true) {
            final blob = item.getAsFile();
            if (blob != null) {
              final reader = html.FileReader();
              reader.readAsArrayBuffer(blob);
              reader.onLoadEnd.listen((_) {
                final bytes = reader.result as Uint8List?;
                if (bytes != null && mounted) {
                  _procesarBytesOcr(bytes);
                }
              });
              event.preventDefault();
              break;
            }
          }
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _pasteSub?.cancel();
    _facturaCtrl.dispose();
    _nuevoProveedorCtrl.dispose();
    _nuevoRifCtrl.dispose();
    _montoCtrl.dispose();
    super.dispose();
  }

  Future<void> _onTipoDocumento(String tipo) async {
    setState(() => _tipoDocumento = tipo);
    if (tipo == 'Entrada') {
      final repo = ref.read(validacionRepoProvider);
      final correlativo = await repo.getNextEntradaCorrelativo();
      if (mounted) setState(() => _facturaCtrl.text = correlativo);
    } else {
      _aplicarPrefijo();
    }
  }

  void _aplicarPrefijo() {
    var raw = _facturaCtrl.text.trim();
    for (final prefix in ['NE-', 'EV-', 'F-']) {
      if (raw.toUpperCase().startsWith(prefix)) {
        raw = raw.substring(prefix.length);
        break;
      }
    }
    _facturaCtrl.text = '${_prefijos[_tipoDocumento] ?? 'F-'}$raw';
    setState(() {});
  }

  void _onMontoChanged(String value) {
    final monto = double.tryParse(value.trim()) ?? 0;
    _pagosKey.currentState?.setMontoTotal(monto);
  }

  bool _puedeValidar() {
    if (_proveedor == '__nuevo__') {
      return _nuevoProveedorCtrl.text.trim().isNotEmpty;
    }
    return _proveedor != null && _proveedor!.isNotEmpty;
  }

  Future<void> _validar() async {
    final repo = ref.read(validacionRepoProvider);
    setState(() => _validando = true);
    try {
      final esNuevo = _proveedor == '__nuevo__';
      final proveedor = esNuevo
          ? _nuevoProveedorCtrl.text.trim()
          : (_proveedor ?? 'Varios');
      final rif = esNuevo ? _nuevoRifCtrl.text.trim() : '';

      final factura = _facturaCtrl.text.trim();
      final monto = double.tryParse(_montoCtrl.text.trim()) ?? 0;
      final pagos = _pagosKey.currentState?.pagos ?? [];

      final resultado = await repo.procesar(
        selectedEntradas: widget.selectedEntradas,
        proveedor: proveedor,
        rif: rif,
        factura: factura,
        monto: monto,
        fecha: _fecha,
        tipoDocumento: _tipoDocumento,
        pagos: pagos,
        usuario: widget.usuario,
      );
      if (mounted) Navigator.pop(context, resultado);
    } catch (e) {
      if (mounted) {
        setState(() => _validando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error al validar entradas: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Validar Entradas'),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460, maxHeight: 620),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Validado por: ${widget.usuario}',
                style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 2),
              Text(
                'Se validarán ${widget.selectedEntradas.length} entrada(s)',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _seccionDoc(scheme),
              const SizedBox(height: 12),
              _seccionMonto(scheme),
              const SizedBox(height: 12),
              PagosPanel(key: _pagosKey),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _validando ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton.icon(
          onPressed: _puedeValidar() && !_validando ? _validar : null,
          icon: _validando
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.check, size: 18),
          label: const Text('Validar Entradas'),
        ),
      ],
    );
  }

  Widget _seccionDoc(ColorScheme scheme) {
    return _section(
      scheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Datos del Documento',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              OutlinedButton.icon(
                icon: const Icon(Icons.document_scanner, size: 16),
                label: const Text('Escanear / Pegar (Ctrl+V)'),
                onPressed: _validando ? null : _escanearOcr,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Factura', label: Text('Factura')),
              ButtonSegment(value: 'Nota de Entrega', label: Text('N. Entrega')),
              ButtonSegment(value: 'Entrada', label: Text('Entrada')),
            ],
            selected: {_tipoDocumento},
            onSelectionChanged: _validando
                ? null
                : (sel) => _onTipoDocumento(sel.first),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _facturaCtrl,
            decoration: const InputDecoration(
              labelText: 'Número de Factura',
              hintText: 'Ej: F-2024-001',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (_) => _aplicarPrefijo(),
          ),
          const SizedBox(height: 10),
          Consumer(
            builder: (context, ref, _) {
              final prov = ref.watch(proveedoresProvider);
              return prov.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error: $e',
                    style: const TextStyle(color: Colors.red)),
                data: (proveedores) => DropdownButtonFormField<String>(
                  initialValue: _proveedor,
                  decoration: const InputDecoration(
                    labelText: 'Proveedor',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'Varios',
                      child: Text('Varios (Entrada sin proveedor)'),
                    ),
                    for (final p in proveedores)
                      DropdownMenuItem(
                        value: p.nombre,
                        child: Text(
                          p.nombre,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const DropdownMenuItem(
                      value: '__nuevo__',
                      child: Text('+ Agregar nuevo'),
                    ),
                  ],
                  onChanged: _validando
                      ? null
                      : (v) => setState(() => _proveedor = v),
                ),
              );
            },
          ),
          if (_proveedor == '__nuevo__') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nuevoProveedorCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo Proveedor',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _nuevoRifCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo RIF',
                      hintText: 'J-XXXXXXXX-X',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: const Text('Fecha'),
                onPressed: _validando
                    ? null
                    : () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _fecha,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (d != null) setState(() => _fecha = d);
                      },
              ),
              const SizedBox(width: 12),
              Text(
                'Fecha: ${_fmtFecha(_fecha)}',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionMonto(ColorScheme scheme) {
    return _section(
      scheme,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money, size: 20, color: scheme.primary),
              const SizedBox(width: 8),
              const Text('Monto Total',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _montoCtrl,
            decoration: const InputDecoration(
              labelText: 'Monto Total (VES)',
              hintText: '1000.00',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
              isDense: true,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: _onMontoChanged,
          ),
        ],
      ),
    );
  }

  Widget _section(ColorScheme scheme, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }

  String _fmtFecha(DateTime d) {
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(d.day)}/${p(d.month)}/${d.year}';
  }

  Future<void> _procesarBytesOcr(Uint8List bytes) async {
    setState(() => _validando = true);
    try {
      final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
      final response = await http.post(
        Uri.parse('https://api.ocr.space/parse/image'),
        headers: {'apikey': 'K86411242588957'},
        body: {
          'base64Image': base64Image,
          'language': 'spa',
          'isOverlayRequired': 'false',
          'detectOrientation': 'true',
          'scale': 'true',
          'OCREngine': '2',
        },
      );
      if (response.statusCode != 200 || response.body.isEmpty) return;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['IsErroredOnProcessing'] == true) return;
      final results = data['ParsedResults'] as List?;
      if (results == null || results.isEmpty) return;
      final fullText = results.map((r) => r['ParsedText'] as String? ?? '').join('\n');
      if (fullText.trim().isEmpty) return;

      final parsed = parseFacturaText(fullText.trim());
      if (mounted) {
        setState(() {
          if (parsed['tipo_documento'] != null && _prefijos.containsKey(parsed['tipo_documento'])) {
            _tipoDocumento = parsed['tipo_documento']!;
          }
          if (parsed['nro_factura'] != null && parsed['nro_factura']!.isNotEmpty) {
            _facturaCtrl.text = '${_prefijos[_tipoDocumento] ?? 'F-'}${parsed['nro_factura']}';
          }
          if (parsed['fecha'] != null && parsed['fecha']!.isNotEmpty) {
            final parts = parsed['fecha']!.split('/');
            if (parts.length == 3) {
              final d = int.tryParse(parts[0]);
              final m = int.tryParse(parts[1]);
              final y = int.tryParse(parts[2]);
              if (d != null && m != null && y != null) {
                _fecha = DateTime(y, m, d);
              }
            }
          }
          final provNombre = parsed['proveedor'] ?? '';
          if (provNombre.isNotEmpty) {
            _proveedor = provNombre;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OCR (Portapapeles): Doc ${parsed['nro_factura']} - ${parsed['proveedor']}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error OCR portapapeles: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _validando = false);
    }
  }

  Future<void> _escanearOcr() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [
        const XTypeGroup(
          label: 'Imágenes',
          extensions: ['jpg', 'jpeg', 'png', 'webp'],
        ),
      ],
    );
    if (file == null) return;

    setState(() => _validando = true);
    try {
      final raw = await _extractOcrSpace(file);
      if (raw == null || raw.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo extraer texto de la imagen (OCR).')),
          );
        }
        return;
      }

      final parsed = parseFacturaText(raw);
      if (mounted) {
        setState(() {
          if (parsed['tipo_documento'] != null && _prefijos.containsKey(parsed['tipo_documento'])) {
            _tipoDocumento = parsed['tipo_documento']!;
          }
          if (parsed['nro_factura'] != null && parsed['nro_factura']!.isNotEmpty) {
            _facturaCtrl.text = '${_prefijos[_tipoDocumento] ?? 'F-'}${parsed['nro_factura']}';
          }
          if (parsed['fecha'] != null && parsed['fecha']!.isNotEmpty) {
            final parts = parsed['fecha']!.split('/');
            if (parts.length == 3) {
              final d = int.tryParse(parts[0]);
              final m = int.tryParse(parts[1]);
              final y = int.tryParse(parts[2]);
              if (d != null && m != null && y != null) {
                _fecha = DateTime(y, m, d);
              }
            }
          }
          final provNombre = parsed['proveedor'] ?? '';
          if (provNombre.isNotEmpty) {
            _proveedor = provNombre;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OCR exitoso: Doc ${parsed['nro_factura']} - ${parsed['proveedor']}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en OCR: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _validando = false);
    }
  }

  Future<String?> _extractOcrSpace(XFile file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';

      final response = await http.post(
        Uri.parse('https://api.ocr.space/parse/image'),
        headers: {'apikey': 'K86411242588957'},
        body: {
          'base64Image': base64Image,
          'language': 'spa',
          'isOverlayRequired': 'false',
          'detectOrientation': 'true',
          'scale': 'true',
          'OCREngine': '2',
        },
      );
      if (response.statusCode != 200 || response.body.isEmpty) return null;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['IsErroredOnProcessing'] == true) return null;
      final results = data['ParsedResults'] as List?;
      if (results == null || results.isEmpty) return null;
      final fullText = results.map((r) => r['ParsedText'] as String? ?? '').join('\n');
      return fullText.trim().isNotEmpty ? fullText.trim() : null;
    } catch (_) {
      return null;
    }
  }

  Map<String, String> parseFacturaText(String text) {
    String proveedor = '';
    String rif = '';
    String nroFactura = '';
    String fechaStr = '';
    String tipoDoc = 'Factura';

    final lines = text.split('\n');
    String provSection = text;
    for (final line in lines) {
      if (RegExp(r'\b(Proveedor|Emitido por|Vendido por|Nombre o Razón Social)\b', caseSensitive: false).hasMatch(line)) {
        provSection = line.replaceAll(RegExp(r'^[^:]*:\s*'), '');
        break;
      }
    }

    final provRegExpCA = RegExp(r'([A-Z][A-Z0-9\s,]*C\.?\s*A\.?)', caseSensitive: false);
    final provMatch = provRegExpCA.firstMatch(provSection) ?? provRegExpCA.firstMatch(text);
    if (provMatch != null) {
      final candidate = provMatch.group(1)?.trim() ?? '';
      if (!candidate.toUpperCase().contains('LA POSADA DE DANIEL')) {
        proveedor = candidate;
      }
    }

    final rifRegex = RegExp(r'(?:R\.?I\.?F\.?[-/ ]*C\.?I\.?[-/ ]*|C\.?I\.?[-/ ]*R\.?I\.?[-/ ]*|R\.?I\.?F\.?|C\.?I\.?|Cod\s*Prov\.?)\s*[:.]?\s*([JGV E])[\s-]*(\d{8,12})', caseSensitive: false);
    final rifMatch = rifRegex.firstMatch(text);
    if (rifMatch != null) {
      rif = '${rifMatch.group(1)}${rifMatch.group(2)}'.toUpperCase();
    } else {
      final allRifs = RegExp(r'\b([JGV E])[\s-]*(\d{8,12})\b', caseSensitive: false).allMatches(text);
      for (final m in allRifs) {
        final cand = '${m.group(1)}${m.group(2)}'.toUpperCase();
        if (cand != 'J316636151') {
          rif = cand;
          break;
        }
      }
    }

    final nroRegex = RegExp(r'(?:FACTURA|NOTA\s*DE\s*ENTREGA|ENTRADA\s*DE\s*INVENTARIO|ENTRADA|DOC|NRO|NUM)\s*#?\s*[:.]?\s*(\d{4,10})', caseSensitive: false);
    final nroMatch = nroRegex.firstMatch(text);
    if (nroMatch != null) {
      nroFactura = nroMatch.group(1) ?? '';
      final matchText = nroMatch.group(0)?.toUpperCase() ?? '';
      if (matchText.contains('NOTA')) {
        tipoDoc = 'Nota de Entrega';
      } else if (matchText.contains('ENTRADA')) {
        tipoDoc = 'Entrada';
      } else if (matchText.contains('FACTURA')) {
        tipoDoc = 'Factura';
      }
    } else {
      for (final line in lines) {
        final l = line.trim();
        if (RegExp(r'^\d{6,10}$').hasMatch(l)) {
          nroFactura = l;
          break;
        }
      }
    }

    final fechaRegex = RegExp(r'Fecha\s*:\s*(\d{1,2})\s*[/.\-]\s*(\d{1,2})\s*[/.\-]\s*(\d{2,4})', caseSensitive: false);
    final fechaMatch = fechaRegex.firstMatch(text);
    if (fechaMatch != null) {
      final dia = int.tryParse(fechaMatch.group(1) ?? '1') ?? 1;
      final mes = int.tryParse(fechaMatch.group(2) ?? '1') ?? 1;
      var anio = fechaMatch.group(3) ?? '2024';
      if (anio.length == 2) anio = '20$anio';
      fechaStr = '${dia.toString().padLeft(2, '0')}/${mes.toString().padLeft(2, '0')}/$anio';
    }

    return {
      'proveedor': proveedor,
      'rif': rif,
      'nro_factura': nroFactura,
      'fecha': fechaStr,
      'tipo_documento': tipoDoc,
    };
  }
}
