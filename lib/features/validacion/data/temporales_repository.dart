import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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

/// Repositorio de temporales en memoria: imagenes pre-cargadas por OCR.
/// Solo local, NO se sincroniza con Supabase.
class TemporalesRepository {
  final List<TemporalData> _items = [];
  int _nextId = 1;
  final _controller = StreamController<List<TemporalData>>.broadcast();

  Stream<List<TemporalData>> watchTemporales() {
    _controller.add(List.unmodifiable(_items));
    return _controller.stream;
  }

  Future<List<TemporalData>> getTemporales() async =>
      List.unmodifiable(_items);

  Future<int> guardar({
    required Uint8List imagen,
    String? tipoDocumento,
    String? nroFactura,
    String? proveedor,
    double? monto,
    DateTime? fecha,
  }) async {
    final id = _nextId++;
    _items.add(TemporalData(
      id: id,
      imagen: imagen,
      tipoDocumento: tipoDocumento,
      nroFactura: nroFactura,
      proveedor: proveedor,
      monto: monto,
      fecha: fecha,
      createdAt: DateTime.now(),
    ));
    _controller.add(List.unmodifiable(_items));
    return id;
  }

  Future<void> eliminar(int id) async {
    _items.removeWhere((t) => t.id == id);
    _controller.add(List.unmodifiable(_items));
  }

  Future<void> limpiar() async {
    _items.clear();
    _controller.add(List.unmodifiable(_items));
  }

  void dispose() => _controller.close();
}
