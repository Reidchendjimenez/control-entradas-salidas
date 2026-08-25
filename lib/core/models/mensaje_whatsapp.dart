/// Mensaje encolado de WhatsApp (`whatsapp_queue`) — porta la fila de
/// `usr/whatsapp_notifier.py`. Estados: pending | sending | sent | failed.
class MensajeWhatsapp {
  const MensajeWhatsapp({
    required this.id,
    this.tipo = 'text',
    this.mensaje,
    this.imagenBase64,
    this.imagenPath,
    this.estado = 'pending',
    this.intentos = 0,
    this.maxIntentos = 10,
    this.ultimoError,
    required this.createdAt,
    this.updatedAt,
  });

  final int id;
  final String tipo;
  final String? mensaje;
  final String? imagenBase64;
  final String? imagenPath;
  final String estado;
  final int intentos;
  final int maxIntentos;
  final String? ultimoError;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory MensajeWhatsapp.fromMap(Map<String, dynamic> m) => MensajeWhatsapp(
        id: m['id'] as int,
        tipo: (m['tipo'] as String?) ?? 'text',
        mensaje: m['mensaje'] as String?,
        imagenBase64: m['imagen_base64'] as String?,
        imagenPath: m['imagen_path'] as String?,
        estado: (m['estado'] as String?) ?? 'pending',
        intentos: (m['intentos'] as num?)?.toInt() ?? 0,
        maxIntentos: (m['max_intentos'] as num?)?.toInt() ?? 10,
        ultimoError: m['ultimo_error'] as String?,
        createdAt: _parseDt(m['created_at']) ?? DateTime.now(),
        updatedAt: _parseDt(m['updated_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'tipo': tipo,
        'mensaje': mensaje,
        'imagen_base64': imagenBase64,
        'imagen_path': imagenPath,
        'estado': estado,
        'intentos': intentos,
        'max_intentos': maxIntentos,
        'ultimo_error': ultimoError,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
