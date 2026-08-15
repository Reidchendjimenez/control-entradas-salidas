import 'package:flutter/material.dart';

/// Card cuadrada del catálogo POS (ports de `_build_categoria_card`,
/// `_build_plato_card`, `_build_producto_card`, `_build_contorno_card`):
/// círculo con inicial(es) del color de la categoría, título, subtítulo
/// (precio) y badge "+" si el plato lleva contornos.
class CatalogoCard extends StatelessWidget {
  const CatalogoCard({
    super.key,
    required this.nombre,
    required this.color,
    this.subtitulo,
    this.badge = false,
    this.onTap,
  });

  final String nombre;
  final String color;
  final String? subtitulo;
  final bool badge;
  final VoidCallback? onTap;

  Color _color() {
    final hex = color.replaceFirst('#', '');
    final v = int.tryParse(hex, radix: 16);
    return v == null ? const Color(0xFF2196F3) : Color(0xFF000000 | v);
  }

  String _iniciales() {
    final parts = nombre
        .trim()
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .take(2)
        .toList();
    if (parts.isEmpty) return '?';
    return parts.map((p) => p[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    final c = _color();
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: c, width: 3),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: c,
                    child: Text(
                      _iniciales(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (badge)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                nombre.toUpperCase(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitulo!,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: c,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
