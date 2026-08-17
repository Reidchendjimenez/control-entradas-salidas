import 'package:flutter/material.dart';

/// Card cuadrada del catálogo POS (ports de `_build_categoria_card`,
/// `_build_plato_card`, `_build_producto_card`, `_build_contorno_card`):
/// círculo con inicial(es) del color de la categoría y glow, título,
/// subtítulo (precio), badge "+" si el plato lleva contornos y escala al
/// presionar.
class CatalogoCard extends StatefulWidget {
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

  @override
  State<CatalogoCard> createState() => _CatalogoCardState();
}

class _CatalogoCardState extends State<CatalogoCard> {
  bool _presionada = false;

  Color _color() {
    final hex = widget.color.replaceFirst('#', '');
    final v = int.tryParse(hex, radix: 16);
    return v == null ? const Color(0xFF2196F3) : Color(0xFF000000 | v);
  }

  String _iniciales() {
    final parts = widget.nombre
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
    final scheme = Theme.of(context).colorScheme;
    return AnimatedScale(
      scale: _presionada ? 0.93 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              c.withValues(alpha: 0.16),
              scheme.surfaceContainerHigh.withValues(alpha: 0.4),
              c.withValues(alpha: 0.06),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c.withValues(alpha: 0.55), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (v) => setState(() => _presionada = v),
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
                      if (widget.badge)
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
                    widget.nombre.toUpperCase(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  if (widget.subtitulo != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitulo!,
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
        ),
      ),
    );
  }
}