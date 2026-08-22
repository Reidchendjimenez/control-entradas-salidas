import '../utils/supabase_cast.dart';

class Producto {
  const Producto({
    required this.id,
    required this.nombre,
    this.codigo,
    this.descripcion,
    this.categoriaId,
    this.esPesable = false,
    this.requiereFotoPeso = false,
    this.pesoUnitario,
    this.precioVenta = 0,
    this.unidadMedida = 'unidad',
    this.stockActual = 0,
    this.stockMinimo = 0,
    this.activo = true,
    this.tipo = 'ninguno',
    this.almacenPredeterminado = 'principal',
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String nombre;
  final String? codigo;
  final String? descripcion;
  final int? categoriaId;
  final bool esPesable;
  final bool requiereFotoPeso;
  final double? pesoUnitario;
  final double precioVenta;
  final String unidadMedida;
  final double stockActual;
  final double stockMinimo;
  final bool activo;
  final String tipo;
  final String almacenPredeterminado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Producto.fromMap(Map<String, dynamic> m) => Producto(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        codigo: m['codigo'] as String?,
        descripcion: m['descripcion'] as String?,
        categoriaId: _toInt(m['categoria_id']),
        esPesable: toBool(m['es_pesable']),
        requiereFotoPeso: toBool(m['requiere_foto_peso']),
        pesoUnitario: _toDouble(m['peso_unitario']),
        precioVenta: _toDouble(m['precio_venta']) ?? 0,
        unidadMedida: (m['unidad_medida'] as String?) ?? 'unidad',
        stockActual: _toDouble(m['stock_actual']) ?? 0,
        stockMinimo: _toDouble(m['stock_minimo']) ?? 0,
        activo: toBool(m['activo'], fallback: true),
        tipo: (m['tipo'] as String?) ?? 'ninguno',
        almacenPredeterminado:
            (m['almacen_predeterminado'] as String?) ?? 'principal',
        createdAt: _parseDt(m['created_at']),
        updatedAt: _parseDt(m['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'nombre': nombre,
        'codigo': codigo,
        'descripcion': descripcion,
        'categoria_id': categoriaId,
        'es_pesable': esPesable,
        'requiere_foto_peso': requiereFotoPeso,
        'peso_unitario': pesoUnitario,
        'precio_venta': precioVenta,
        'unidad_medida': unidadMedida,
        'stock_actual': stockActual,
        'stock_minimo': stockMinimo,
        'activo': activo,
        'tipo': tipo,
        'almacen_predeterminado': almacenPredeterminado,
      };

  Producto copyWith({
    int? id,
    String? nombre,
    String? codigo,
    String? descripcion,
    int? categoriaId,
    bool? esPesable,
    bool? requiereFotoPeso,
    double? pesoUnitario,
    double? precioVenta,
    String? unidadMedida,
    double? stockActual,
    double? stockMinimo,
    bool? activo,
    String? tipo,
    String? almacenPredeterminado,
  }) =>
      Producto(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        codigo: codigo ?? this.codigo,
        descripcion: descripcion ?? this.descripcion,
        categoriaId: categoriaId ?? this.categoriaId,
        esPesable: esPesable ?? this.esPesable,
        requiereFotoPeso: requiereFotoPeso ?? this.requiereFotoPeso,
        pesoUnitario: pesoUnitario ?? this.pesoUnitario,
        precioVenta: precioVenta ?? this.precioVenta,
        unidadMedida: unidadMedida ?? this.unidadMedida,
        stockActual: stockActual ?? this.stockActual,
        stockMinimo: stockMinimo ?? this.stockMinimo,
        activo: activo ?? this.activo,
        tipo: tipo ?? this.tipo,
        almacenPredeterminado:
            almacenPredeterminado ?? this.almacenPredeterminado,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static int? _toInt(dynamic v) => v is num ? v.toInt() : int.tryParse('$v');
  static double? _toDouble(dynamic v) =>
      v is num ? v.toDouble() : double.tryParse('${v ?? ''}');
  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
