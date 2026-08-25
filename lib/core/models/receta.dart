import '../utils/supabase_cast.dart';

class Receta {
  const Receta({
    required this.id,
    required this.nombre,
    required this.tipo,
    this.productoBaseId,
    this.productoFinalId,
    this.cantidadProducida = 1,
    this.activo = true,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String nombre;
  final String tipo;
  final int? productoBaseId;
  final int? productoFinalId;
  final double cantidadProducida;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Receta.fromMap(Map<String, dynamic> m) => Receta(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        tipo: m['tipo'] as String,
        productoBaseId: _toInt(m['producto_base_id']),
        productoFinalId: _toInt(m['producto_final_id']),
        cantidadProducida:
            (m['cantidad_producida'] as num?)?.toDouble() ?? 1,
        activo: toBool(m['activo']),
        createdAt: _parseDt(m['created_at']),
        updatedAt: _parseDt(m['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'nombre': nombre,
        'tipo': tipo,
        'producto_base_id': productoBaseId,
        'producto_final_id': productoFinalId,
        'cantidad_producida': cantidadProducida,
        'activo': activo,
      };

  Receta copyWith({
    int? id,
    String? nombre,
    String? tipo,
    int? productoBaseId,
    int? productoFinalId,
    double? cantidadProducida,
    bool? activo,
  }) =>
      Receta(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        tipo: tipo ?? this.tipo,
        productoBaseId: productoBaseId ?? this.productoBaseId,
        productoFinalId: productoFinalId ?? this.productoFinalId,
        cantidadProducida: cantidadProducida ?? this.cantidadProducida,
        activo: activo ?? this.activo,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static int? _toInt(dynamic v) => v is num ? v.toInt() : int.tryParse('$v');
  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}

class RecetaComponente {
  const RecetaComponente({
    required this.id,
    required this.recetaId,
    required this.productoId,
    required this.cantidad,
    this.unidad = 'unidad',
    required this.tipoComponente,
    this.pesoVariable = false,
  });

  final int id;
  final int recetaId;
  final int productoId;
  final double cantidad;
  final String unidad;
  final String tipoComponente;
  final bool pesoVariable;

  factory RecetaComponente.fromMap(Map<String, dynamic> m) =>
      RecetaComponente(
        id: m['id'] as int,
        recetaId: m['receta_id'] as int,
        productoId: m['producto_id'] as int,
        cantidad: (m['cantidad'] as num?)?.toDouble() ?? 0,
        unidad: (m['unidad'] as String?) ?? 'unidad',
        tipoComponente: m['tipo_componente'] as String,
        pesoVariable: toBool(m['peso_variable']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'receta_id': recetaId,
        'producto_id': productoId,
        'cantidad': cantidad,
        'unidad': unidad,
        'tipo_componente': tipoComponente,
        'peso_variable': pesoVariable ? 1 : 0,
      };
}
