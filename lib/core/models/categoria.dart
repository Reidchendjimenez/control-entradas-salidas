import '../utils/supabase_cast.dart';

class Categoria {
  const Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagen,
    this.color = '#2196F3',
    this.activo = true,
    this.visibleEnPos = true,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String nombre;
  final String? descripcion;
  final String? imagen;
  final String color;
  final bool activo;
  final bool visibleEnPos;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Categoria.fromMap(Map<String, dynamic> m) => Categoria(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        descripcion: m['descripcion'] as String?,
        imagen: m['imagen'] as String?,
        color: (m['color'] as String?) ?? '#2196F3',
        activo: toBool(m['activo'], fallback: true),
        visibleEnPos: toBool(m['visible_en_pos'], fallback: true),
        createdAt: _parseDt(m['created_at']),
        updatedAt: _parseDt(m['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'imagen': imagen,
        'color': color,
        'activo': activo,
        'visible_en_pos': visibleEnPos,
      };

  Categoria copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? imagen,
    String? color,
    bool? activo,
    bool? visibleEnPos,
  }) =>
      Categoria(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        descripcion: descripcion ?? this.descripcion,
        imagen: imagen ?? this.imagen,
        color: color ?? this.color,
        activo: activo ?? this.activo,
        visibleEnPos: visibleEnPos ?? this.visibleEnPos,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
