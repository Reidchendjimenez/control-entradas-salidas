import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/pos_comanda_models.dart';
import '../../data/pos_providers.dart';
import '../../data/tasa_bcv_service.dart';

/// Pestaña Tasa BCV (port de `tasa_cambio.py` + `ComandaView._actualizar_tasa`):
/// muestra la tasa guardada, permite consultarla en línea desde el BCV (con
/// respaldo en bcv.today) o fijarla manualmente (se sincroniza al servidor).
class ConfigTasaTab extends ConsumerStatefulWidget {
  const ConfigTasaTab({super.key});

  @override
  ConsumerState<ConfigTasaTab> createState() => _ConfigTasaTabState();
}

class _ConfigTasaTabState extends ConsumerState<ConfigTasaTab> {
  final TasaBcvService _service = TasaBcvService();
  final _manualCtrl = TextEditingController();
  double _tasa = 0;
  String _fecha = '';
  bool _consultando = false;
  bool _guardandoManual = false;
  String _diagnostico = '';

  @override
  void initState() {
    super.initState();
    _cargarGuardada();
  }

  @override
  void dispose() {
    _manualCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarGuardada() async {
    final repo = ref.read(posRepoProvider);
    final tasa = await repo.getTasaCambio();
    final fecha = await repo.getTasaCambioFecha();
    if (!mounted) return;
    setState(() {
      _tasa = tasa;
      _fecha = fecha;
    });
  }

  /// Port de `tasa_cambio.actualizar_tasa`: consulta en línea, guarda y reporta
  /// si cambió y con qué fuente.
  Future<void> _actualizar() async {
    setState(() => _consultando = true);
    try {
      final repo = ref.read(posRepoProvider);
      final tasa = await _service.obtenerTasaBcv();
      final anterior = await repo.getTasaCambio();
      await repo.setTasaCambio(tasa, sync: true);
      final cambiada = anterior <= 0 || (anterior - tasa).abs() > 0.0001;
      final fuente = _service.ultimaFuente ?? '?';
      if (!mounted) return;
      setState(() {
        _tasa = tasa;
        _diagnostico = fuente;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cambiada
              ? 'Tasa ${formatearTasa(tasa)} Bs/\$ ($fuente)'
              : 'Tasa sin cambios (${formatearTasa(tasa)} Bs/\$ · $fuente)'),
          backgroundColor: cambiada ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _diagnostico = 'Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo consultar la tasa: $e')),
      );
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

  Future<void> _guardarManual() async {
    final valor = double.tryParse(_manualCtrl.text.trim().replaceAll(',', '.'));
    if (valor == null || valor <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese una tasa válida (ej: 835.9482)')),
      );
      return;
    }
    setState(() => _guardandoManual = true);
    try {
      await ref.read(posRepoProvider).setTasaCambio(valor, sync: true);
      await _cargarGuardada();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tasa guardada')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    } finally {
      if (mounted) setState(() => _guardandoManual = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tasa de cambio USD -> Bs',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  _tasa > 0
                      ? '${formatearTasa(_tasa)} Bs/\$'
                      : 'Sin tasa guardada',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _tasa > 0 ? const Color(0xFF26A69A) : scheme.outline,
                  ),
                ),
                if (_fecha.isNotEmpty)
                  Text('Actualizada: ${_fecha.substring(0, 16).replaceFirst('T', ' ')}',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                if (_diagnostico.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Fuente: $_diagnostico',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: _consultando ? null : _actualizar,
                      icon: _consultando
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.cloud_download),
                      label: Text(_consultando
                          ? 'Consultando BCV…'
                          : 'Actualizar desde BCV'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Consulta el sitio oficial del BCV; si falla usa bcv.today.',
                        style: TextStyle(
                            fontSize: 12, color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ],
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
                Text('Fijar manualmente',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Si no hay conexión, escriba la tasa del día.',
                    style:
                        TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _manualCtrl,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Tasa (Bs por \$)',
                          hintText: 'ej: 835.9482',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _guardandoManual ? null : _guardarManual,
                      child: Text(_guardandoManual ? 'Guardando…' : 'Guardar'),
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
