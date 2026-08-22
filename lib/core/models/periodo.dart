class Periodo {
  const Periodo({
    required this.id,
    required this.periodo,
    required this.fechaApertura,
    this.registradoPor,
  });

  final int id;
  final String periodo;
  final String fechaApertura;
  final String? registradoPor;

  factory Periodo.fromMap(Map<String, dynamic> m) => Periodo(
        id: m['id'] as int,
        periodo: m['periodo'] as String,
        fechaApertura: m['fecha_apertura'] as String,
        registradoPor: m['registrado_por'] as String?,
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'periodo': periodo,
        'fecha_apertura': fechaApertura,
        'registrado_por': registradoPor,
      };
}

class ComprasLista {
  const ComprasLista({
    required this.id,
    required this.productoId,
    this.createdAt,
  });

  final int id;
  final int productoId;
  final DateTime? createdAt;

  factory ComprasLista.fromMap(Map<String, dynamic> m) => ComprasLista(
        id: m['id'] as int,
        productoId: m['producto_id'] as int,
        createdAt: _parseDt(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'producto_id': productoId,
      };

  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
