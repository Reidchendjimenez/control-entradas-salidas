import 'package:flutter/material.dart';

import '../../../../core/db/schema/app_database.dart';
import 'estado_card.dart';

const _libreColor = Color(0xFF5C6BC0);
const _ocupadaColor = Color(0xFFEF5350);

/// Card de mesa (diseño mejorado sobre `MesasView._build_card`): número en
/// círculo con glow, badge Ocupada/Libre y zona/nombre.
class MesaCard extends StatelessWidget {
  const MesaCard({super.key, required this.mesa, required this.ocupada, this.onTap});

  final PosMesa mesa;
  final bool ocupada;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final info = [mesa.nombre, mesa.zona]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(' - ');

    return EstadoCard(
      numero: mesa.numero,
      estado: ocupada ? 'Ocupada' : 'Libre',
      info: info.isEmpty ? 'MESA ${mesa.numero}' : info.toUpperCase(),
      color: ocupada ? _ocupadaColor : _libreColor,
      onTap: onTap,
    );
  }
}