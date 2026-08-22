class Produccion {
  const Produccion({
    required this.id,
    required this.recetaId,
    required this.cantidad,
    this.estado = 'completado',
    this.usuario,
    this.observaciones,
    this.cocineros,
    this.fechaProduccion,
    this.createdAt,
  });

  final int id;
  final int recetaId;
  final double cantidad;
  final String estado;
  final String? usuario;
  final String? observaciones;
  final String? cocineros;
  final DateTime? fechaProduccion;
  final DateTime? createdAt;

  factory Produccion.fromMap(Map<String, dynamic> m) => Produccion(
        id: m['id'] as int,
        recetaId: m['receta_id'] as int,
        cantidad: (m['cantidad'] as num?)?.toDouble() ?? 0,
        estado: (m['estado'] as String?) ?? 'completado',
        usuario: m['usuario'] as String?,
        observaciones: m['observaciones'] as String?,
        cocineros: m['cocineros'] as String?,
        fechaProduccion: _parseDt(m['fecha_produccion']),
        createdAt: _parseDt(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'receta_id': recetaId,
        'cantidad': cantidad,
        'estado': estado,
        'usuario': usuario,
        'observaciones': observaciones,
        'cocineros': cocineros,
        'fecha_produccion':
            fechaProduccion?.toUtc().toIso8601String(),
      };

  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}

class ProduccionDetalle {
  const ProduccionDetalle({
    required this.id,
    required this.produccionId,
    required this.productoId,
    required this.tipo,
    required this.cantidad,
    this.unidad = 'unidad',
    this.movimientoId,
  });

  final int id;
  final int produccionId;
  final int productoId;
  final String tipo;
  final double cantidad;
  final String unidad;
  final int? movimientoId;

  factory ProduccionDetalle.fromMap(Map<String, dynamic> m) =>
      ProduccionDetalle(
        id: m['id'] as int,
        produccionId: m['produccion_id'] as int,
        productoId: m['producto_id'] as int,
        tipo: m['tipo'] as String,
        cantidad: (m['cantidad'] as num?)?.toDouble() ?? 0,
        unidad: (m['unidad'] as String?) ?? 'unidad',
        movimientoId: m['movimiento_id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'produccion_id': produccionId,
        'producto_id': productoId,
        'tipo': tipo,
        'cantidad': cantidad,
        'unidad': unidad,
        'movimiento_id': movimientoId,
      };
}
