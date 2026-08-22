import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Fake de SupabaseClient que simula tablas en memoria.
/// Solo cubre los métodos usados por los repos (select, insert, update, delete).
class FakeSupabaseClient extends SupabaseClient {
  FakeSupabaseClient()
      : super('https://fake.supabase.co', 'fake-anon-key');

  final Map<String, List<Map<String, dynamic>>> _tables = {};
  int _nextId = 1;

  /// Inserta datos de prueba en una tabla fake.
  void seedTable(String table, List<Map<String, dynamic>> rows) {
    _tables[table] = rows.map((r) => Map<String, dynamic>.from(r)).toList();
  }

  /// Devuelve las filas actuales de una tabla (para assertions).
  List<Map<String, dynamic>> getTable(String table) =>
      List.unmodifiable(_tables[table] ?? []);

  int get nextId => _nextId++;

  void reset() {
    _tables.clear();
    _nextId = 1;
  }
}
