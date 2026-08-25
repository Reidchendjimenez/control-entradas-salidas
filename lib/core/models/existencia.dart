class Existencia {
  const Existencia({
    required this.id,
    required this.productoId,
    required this.almacen,
    this.cantidad = 0,
    this.unidad = 'unidad',
  });

  final int id;
  final int productoId;
  final String almacen;
  final double cantidad;
  final String unidad;

  factory Existencia.fromMap(Map<String, dynamic> m) => Existencia(
        id: m['id'] as int,
        productoId: m['producto_id'] as int,
        almacen: m['almacen'] as String,
        cantidad: (m['cantidad'] as num?)?.toDouble() ?? 0,
        unidad: (m['unidad'] as String?) ?? 'unidad',
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'producto_id': productoId,
        'almacen': almacen,
        'cantidad': cantidad,
        'unidad': unidad,
      };

  Existencia copyWith({
    int? id,
    int? productoId,
    String? almacen,
    double? cantidad,
    String? unidad,
  }) =>
      Existencia(
        id: id ?? this.id,
        productoId: productoId ?? this.productoId,
        almacen: almacen ?? this.almacen,
        cantidad: cantidad ?? this.cantidad,
        unidad: unidad ?? this.unidad,
      );
}

class StockCheckpoint {
  const StockCheckpoint({
    required this.productoId,
    required this.almacen,
    this.cantidad = 0,
  });

  final int productoId;
  final String almacen;
  final double cantidad;

  factory StockCheckpoint.fromMap(Map<String, dynamic> m) => StockCheckpoint(
        productoId: m['producto_id'] as int,
        almacen: m['almacen'] as String,
        cantidad: (m['cantidad'] as num?)?.toDouble() ?? 0,
      );

  Map<String, dynamic> toMap() => {
        'producto_id': productoId,
        'almacen': almacen,
        'cantidad': cantidad,
      };
}
