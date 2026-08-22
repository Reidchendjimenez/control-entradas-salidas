class Factura {
  const Factura({
    required this.id,
    required this.numeroFactura,
    this.tipoDocumento = 'Factura',
    this.proveedor,
    required this.fechaFactura,
    this.fechaRecepcion,
    this.totalBruto = 0,
    this.totalImpuestos = 0,
    this.totalNeto = 0,
    this.estado = 'Pendiente',
    this.observaciones,
    this.validadaPor,
    this.fechaValidacion,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String numeroFactura;
  final String tipoDocumento;
  final String? proveedor;
  final DateTime fechaFactura;
  final DateTime? fechaRecepcion;
  final double totalBruto;
  final double totalImpuestos;
  final double totalNeto;
  final String estado;
  final String? observaciones;
  final String? validadaPor;
  final DateTime? fechaValidacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Factura.fromMap(Map<String, dynamic> m) => Factura(
        id: m['id'] as int,
        numeroFactura: m['numero_factura'] as String,
        tipoDocumento: (m['tipo_documento'] as String?) ?? 'Factura',
        proveedor: m['proveedor'] as String?,
        fechaFactura: _parseDt(m['fecha_factura']) ?? DateTime.now(),
        fechaRecepcion: _parseDt(m['fecha_recepcion']),
        totalBruto: (m['total_bruto'] as num?)?.toDouble() ?? 0,
        totalImpuestos: (m['total_impuestos'] as num?)?.toDouble() ?? 0,
        totalNeto: (m['total_neto'] as num?)?.toDouble() ?? 0,
        estado: (m['estado'] as String?) ?? 'Pendiente',
        observaciones: m['observaciones'] as String?,
        validadaPor: m['validada_por'] as String?,
        fechaValidacion: _parseDt(m['fecha_validacion']),
        createdAt: _parseDt(m['created_at']),
        updatedAt: _parseDt(m['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'numero_factura': numeroFactura,
        'tipo_documento': tipoDocumento,
        'proveedor': proveedor,
        'fecha_factura': fechaFactura.toUtc().toIso8601String(),
        'fecha_recepcion': fechaRecepcion?.toUtc().toIso8601String(),
        'total_bruto': totalBruto,
        'total_impuestos': totalImpuestos,
        'total_neto': totalNeto,
        'estado': estado,
        'observaciones': observaciones,
        'validada_por': validadaPor,
        'fecha_validacion': fechaValidacion?.toUtc().toIso8601String(),
      };

  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}

class FacturaPago {
  const FacturaPago({
    required this.id,
    required this.facturaId,
    required this.tipoPago,
    required this.monto,
    this.referencia,
    this.tasaCambio,
    this.fechaPago,
  });

  final int id;
  final int facturaId;
  final String tipoPago;
  final double monto;
  final String? referencia;
  final double? tasaCambio;
  final DateTime? fechaPago;

  factory FacturaPago.fromMap(Map<String, dynamic> m) => FacturaPago(
        id: m['id'] as int,
        facturaId: m['factura_id'] as int,
        tipoPago: m['tipo_pago'] as String,
        monto: (m['monto'] as num?)?.toDouble() ?? 0,
        referencia: m['referencia'] as String?,
        tasaCambio: (m['tasa_cambio'] as num?)?.toDouble(),
        fechaPago: _parseDt(m['fecha_pago']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'factura_id': facturaId,
        'tipo_pago': tipoPago,
        'monto': monto,
        'referencia': referencia,
        'tasa_cambio': tasaCambio,
        'fecha_pago': fechaPago?.toUtc().toIso8601String(),
      };

  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
