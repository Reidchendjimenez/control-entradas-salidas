import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Datos de una imagen temporal pre-cargada en la vista de Validacion.
class TemporalData {
  final int? id;
  final Uint8List? imagen;
  final String? tipoDocumento;
  final String? nroFactura;
  final String? proveedor;
  final double? monto;
  final DateTime? fecha;
  final DateTime createdAt;

  TemporalData({
    this.id,
    this.imagen,
    this.tipoDocumento,
    this.nroFactura,
    this.proveedor,
    this.monto,
    this.fecha,
    required this.createdAt,
  });
}

/// Repositorio de temporales en Supabase: imagenes pre-cargadas por OCR.
/// Sincronizado en tiempo real entre todos los dispositivos.
class TemporalesRepository {
  TemporalesRepository(this._client);
  final SupabaseClient _client;

  final _controller = StreamController<List<TemporalData>>.broadcast();
  RealtimeChannel? _channel;

  /// Escucha cambios en pos_temporales vía Supabase Realtime.
  Stream<List<TemporalData>> watchTemporales() {
    _suscribirRealtime();
    return _controller.stream;
  }

  void _suscribirRealtime() {
    if (_channel != null) return;
    _channel = _client
        .channel('pos_temporales_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'pos_temporales',
          callback: (_) => _refrescar(),
        )
        .subscribe();
    _refrescar();
  }

  Future<void> _refrescar() async {
    final items = await getTemporales();
    if (!_controller.isClosed) {
      _controller.add(items);
    }
  }

  Future<List<TemporalData>> getTemporales() async {
    final rows = await _client
        .from('pos_temporales')
        .select()
        .order('creado_en', ascending: false);
    return rows.map<Map<String, dynamic>>((r) => r as Map<String, dynamic>).map(_fromRow).toList();
  }

  Future<int> guardar({
    required Uint8List imagen,
    String? tipoDocumento,
    String? nroFactura,
    String? proveedor,
    double? monto,
    DateTime? fecha,
  }) async {
    final row = await _client.from('pos_temporales').insert({
      'imagen_base64': base64Encode(imagen),
      'tipo_documento': tipoDocumento,
      'nro_factura': nroFactura,
      'proveedor': proveedor,
      'monto': monto,
      'fecha': fecha?.toIso8601String(),
    }).select('id').single();
    return row['id'] as int;
  }

  Future<void> eliminar(int id) async {
    await _client.from('pos_temporales').delete().eq('id', id);
  }

  Future<void> limpiar() async {
    await _client.from('pos_temporales').delete().neq('id', 0);
  }

  void dispose() {
    if (_channel != null) {
      _client.removeChannel(_channel!);
      _channel = null;
    }
    _controller.close();
  }

  TemporalData _fromRow(Map<String, dynamic> row) {
    DateTime? parseDate(String? s) {
      if (s == null || s.isEmpty) return null;
      return DateTime.tryParse(s);
    }

    return TemporalData(
      id: row['id'] as int,
      imagen: row['imagen_base64'] != null
          ? base64Decode(row['imagen_base64'] as String)
          : null,
      tipoDocumento: row['tipo_documento'] as String?,
      nroFactura: row['nro_factura'] as String?,
      proveedor: row['proveedor'] as String?,
      monto: (row['monto'] as num?)?.toDouble(),
      fecha: parseDate(row['fecha'] as String?),
      createdAt: DateTime.parse(row['creado_en'] as String),
    );
  }
}
