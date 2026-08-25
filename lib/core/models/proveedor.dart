class Proveedor {
  const Proveedor({
    required this.id,
    required this.nombre,
    this.rif,
    this.telefono,
    this.email,
    this.direccion,
    this.contacto,
    this.observaciones,
    this.estado = 'Activo',
    this.createdAt,
  });

  final int id;
  final String nombre;
  final String? rif;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? contacto;
  final String? observaciones;
  final String estado;
  final DateTime? createdAt;

  factory Proveedor.fromMap(Map<String, dynamic> m) => Proveedor(
        id: m['id'] as int,
        nombre: m['nombre'] as String,
        rif: m['rif'] as String?,
        telefono: m['telefono'] as String?,
        email: m['email'] as String?,
        direccion: m['direccion'] as String?,
        contacto: m['contacto'] as String?,
        observaciones: m['observaciones'] as String?,
        estado: (m['estado'] as String?) ?? 'Activo',
        createdAt: _parseDt(m['created_at']),
      );

  Map<String, dynamic> toMap() => {
        if (id > 0) 'id': id,
        'nombre': nombre,
        'rif': rif,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'contacto': contacto,
        'observaciones': observaciones,
        'estado': estado,
      };

  Proveedor copyWith({
    int? id,
    String? nombre,
    String? rif,
    String? telefono,
    String? email,
    String? direccion,
    String? contacto,
    String? observaciones,
    String? estado,
  }) =>
      Proveedor(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        rif: rif ?? this.rif,
        telefono: telefono ?? this.telefono,
        email: email ?? this.email,
        direccion: direccion ?? this.direccion,
        contacto: contacto ?? this.contacto,
        observaciones: observaciones ?? this.observaciones,
        estado: estado ?? this.estado,
        createdAt: createdAt,
      );

  static DateTime? _parseDt(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    return DateTime.tryParse(v.toString());
  }
}
