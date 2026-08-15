import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/db/schema/app_database.dart';

/// Datos de una imagen temporal pre-cargada en la vista de Validación.
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

/// Repositorio de temporales: imágenes pre-cargadas por OCR en Validación.
/// Solo local (tabla `temporales`), NO se sincroniza con Supabase.
class TemporalesRepository {
  TemporalesRepository(this._db);
  final AppDatabase _db;

  Stream<List<TemporalData>> watchTemporales() {
    return (_db.select(_db.temporales)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<List<TemporalData>> getTemporales() async {
    final rows = await (_db.select(_db.temporales)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
    return rows.map(_fromRow).toList();
  }

  Future<int> guardar({
    required Uint8List imagen,
    String? tipoDocumento,
    String? nroFactura,
    String? proveedor,
    double? monto,
    DateTime? fecha,
  }) async {
    final row = await _db.temporales.insertReturning(
      TemporalesCompanion.insert(
        imagenB64: Value(base64Encode(imagen)),
        tipoDocumento: Value(tipoDocumento),
        nroFactura: Value(nroFactura),
        proveedor: Value(proveedor),
        monto: Value(monto),
        fecha: Value(fecha),
        createdAt: DateTime.now(),
      ),
    );
    return row.id;
  }

  Future<void> eliminar(int id) async {
    await (_db.temporales.delete()..where((t) => t.id.equals(id))).go();
  }

  Future<void> limpiar() async {
    await _db.temporales.deleteAll();
  }

  TemporalData _fromRow(Temporale row) => TemporalData(
        id: row.id,
        imagen: row.imagenB64 != null ? base64Decode(row.imagenB64!) : null,
        tipoDocumento: row.tipoDocumento,
        nroFactura: row.nroFactura,
        proveedor: row.proveedor,
        monto: row.monto,
        fecha: row.fecha,
        createdAt: row.createdAt,
      );
}
