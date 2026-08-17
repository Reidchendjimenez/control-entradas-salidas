import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/schema/app_database.dart';
import '../data/historial_providers.dart';
import 'dialogs/factura_detalle_dialog.dart';
import 'widgets/factura_card.dart';

/// Tab "Facturas" (porta `_build_facturas_tab` + `_render_facturas` de
/// `historial_facturas_view.py`): búsqueda por número/proveedor, filtro por
/// rango de fechas y lista de facturas con detalle al tocar.
class FacturasTab extends ConsumerStatefulWidget {
  const FacturasTab({super.key});

  @override
  ConsumerState<FacturasTab> createState() => _FacturasTabState();
}

class _FacturasTabState extends ConsumerState<FacturasTab> {
  final _searchCtrl = TextEditingController();
  String _search = '';
  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final facturasAsync = ref.watch(facturasProvider);

    return Column(
      children: [
        _buildFiltros(scheme),
        Expanded(
          child: facturasAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e', style: TextStyle(color: scheme.error))),
            data: (facturas) {
              final filtradas = facturas.where((f) {
                if (_search.isNotEmpty) {
                  final term = _search.toLowerCase();
                  final num = (f.numeroFactura ?? '').toLowerCase();
                  final prov = (f.proveedor ?? '').toLowerCase();
                  if (!num.contains(term) && !prov.contains(term)) return false;
                }
                if (_fechaInicio != null && (f.fechaFactura ?? DateTime(2000)).isBefore(_fechaInicio!)) {
                  return false;
                }
                if (_fechaFin != null) {
                  final fin = _fechaFin!.add(const Duration(days: 1));
                  if (!(f.fechaFactura ?? DateTime(2100)).isBefore(fin)) return false;
                }
                return true;
              }).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 0, 0),
                    child: Text(
                      '${filtradas.length} factura(s) encontradas',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                  ),
                  Expanded(
                    child: filtradas.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.search_off, size: 50, color: scheme.outlineVariant),
                                const SizedBox(height: 8),
                                Text('Sin registros', style: TextStyle(color: scheme.onSurfaceVariant)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filtradas.length,
                            itemBuilder: (context, i) {
                              final f = filtradas[i];
                              return FacturaCard(
                                factura: f,
                                onTap: () => _abrirDetalle(f),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFiltros(ColorScheme scheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Buscar número o proveedor...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.clear, size: 20),
                tooltip: 'Limpiar búsqueda',
                onPressed: () {
                  _searchCtrl.clear();
                  setState(() => _search = '');
                },
              ),
            ],
          ),
          const Divider(height: 1),
          Row(
            children: [
              Text('Filtrar por fecha:', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
              const SizedBox(width: 8),
              _fechaBtn(scheme, _fechaInicio, 'Inicio', (d) {
                setState(() => _fechaInicio = d);
              }),
              Text('→', style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 14)),
              _fechaBtn(scheme, _fechaFin, 'Fin', (d) {
                setState(() => _fechaFin = d);
              }),
              IconButton(
                icon: const Icon(Icons.close, size: 16),
                color: scheme.onSurfaceVariant,
                tooltip: 'Limpiar filtro',
                onPressed: () => setState(() {
                  _fechaInicio = null;
                  _fechaFin = null;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _fechaBtn(
    ColorScheme scheme,
    DateTime? fecha,
    String label,
    ValueChanged<DateTime?> onPick,
  ) {
    final texto = fecha == null ? label : _fmtFecha(fecha);
    return TextButton.icon(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: fecha ?? DateTime.now(),
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        );
        if (picked != null) onPick(picked);
      },
      icon: const Icon(Icons.calendar_today, size: 14),
      label: Text(texto, style: const TextStyle(fontSize: 12)),
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  String _fmtFecha(DateTime d) {
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(d.day)}/${p(d.month)}/${d.year}';
  }

  void _abrirDetalle(Factura f) {
    showFacturaDetalleDialog(context, f.id);
  }
}
