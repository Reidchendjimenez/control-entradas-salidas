import 'package:flutter/material.dart';

import '../../../../core/db/schema/app_database.dart';

const _libreColor = Color(0xFF5C6BC0);
const _ocupadaColor = Color(0xFFEF5350);

/// Card de mesa (port de `MesasView._build_card`): número en círculo,
/// badge Ocupada/Libre y zona/nombre.
class MesaCard extends StatelessWidget {
  const MesaCard({super.key, required this.mesa, required this.ocupada, this.onTap});

  final PosMesa mesa;
  final bool ocupada;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = ocupada ? _ocupadaColor : _libreColor;
    final info = [mesa.nombre, mesa.zona]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .join(' - ');

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: color,
          width: 3,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color,
                child: Text(
                  mesa.numero,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: ocupada ? const Color(0xFFB71C1C) : const Color(0xFF1B5E20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  ocupada ? 'Ocupada' : 'Libre',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: ocupada ? _ocupadaColor : const Color(0xFF4CAF50),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                info.isEmpty ? 'MESA ${mesa.numero}' : info.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
