import 'package:flutter/material.dart';

import '../../data/pos_comanda_models.dart';

const _meses = [
  'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
  'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
];

String _fechaLarga(DateTime f) =>
    '${f.day} de ${_meses[f.month - 1]} de ${f.year}';

String _saludo(DateTime f) {
  final h = f.hour;
  if (h < 12) return 'Buenos días';
  if (h < 19) return 'Buenas tardes';
  return 'Buenas noches';
}

/// Cabecera del home del POS (estética + contexto del turno): saludo con el
/// nombre del cajero, fecha en español y la tasa de cambio del día.
class PosHomeHeader extends StatelessWidget {
  const PosHomeHeader({
    super.key,
    required this.nombre,
    this.tasa,
    this.cargandoTasa = false,
  });

  final String nombre;
  final double? tasa;
  final bool cargandoTasa;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ahora = DateTime.now();

    return LayoutBuilder(
      builder: (context, constraints) {
        final apilado = constraints.maxWidth < 560;
        final saludo = Column(
          crossAxisAlignment: apilado
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              'Comandas',
              style: TextStyle(
                fontSize: apilado ? 26 : 30,
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_saludo(ahora)}, ${nombre.isNotEmpty ? nombre : 'Cajero'}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _fechaLarga(ahora),
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
          ],
        );

        final tasa = _TasaCambioPill(
          tasa: this.tasa,
          cargando: cargandoTasa,
        );

        if (apilado) {
          return Column(
            children: [
              saludo,
              const SizedBox(height: 18),
              tasa,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: saludo),
            const SizedBox(width: 16),
            tasa,
          ],
        );
      },
    );
  }
}

/// Pill con la tasa de cambio oficial (Bs por USD).
class _TasaCambioPill extends StatelessWidget {
  const _TasaCambioPill({this.tasa, required this.cargando});

  final double? tasa;
  final bool cargando;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4FC3F7).withValues(alpha: 0.18),
            scheme.surfaceContainerHigh.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF4FC3F7).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.currency_exchange,
              color: Color(0xFF4FC3F7), size: 22),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tasa BCV',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              if (cargando && tasa == null)
                SizedBox(
                  width: 110,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    borderRadius: BorderRadius.circular(2),
                    color: const Color(0xFF4FC3F7),
                  ),
                )
              else
                Text(
                  'Bs ${formatearTasa(tasa ?? 0)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}