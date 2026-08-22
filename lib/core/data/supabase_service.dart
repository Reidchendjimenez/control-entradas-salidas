import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio base para operaciones CRUD contra Supabase.
///
/// Provee métodos genéricos para select, insert, update, delete, upsert.
/// Los repositorios de cada feature usan este servicio o acceden al
/// cliente raw para queries complejas.
class SupabaseService {
  SupabaseService(this._client);

  final SupabaseClient _client;

  /// Cliente Supabase subyacente (para queries complejas).
  SupabaseClient get client => _client;

  // -------------------------------------------------------------------
  // SELECT
  // -------------------------------------------------------------------

  /// Lee todas las filas de una tabla.
  Future<List<Map<String, dynamic>>> fetchAll(
    String table, {
    String? orderBy,
    bool ascending = true,
    int? limit,
    Map<String, dynamic>? filters,
  }) async {
    var builder = _client.from(table).select();
    if (filters != null) {
      for (final e in filters.entries) {
        final v = e.value is bool ? (e.value ? 1 : 0) : e.value;
        builder = builder.eq(e.key, v);
      }
    }
    dynamic q = builder;
    if (orderBy != null) q = q.order(orderBy, ascending: ascending);
    if (limit != null) q = q.limit(limit);
    final data = await q;
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Lee filas con filtro `gte` (>=) en una columna.
  Future<List<Map<String, dynamic>>> fetchWhereGte(
    String table,
    String column,
    String value, {
    String? orderBy,
    bool ascending = true,
  }) async {
    dynamic q = _client.from(table).select().gte(column, value);
    if (orderBy != null) q = q.order(orderBy, ascending: ascending);
    final data = await q;
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Lee filas con filtro `or` (complejo).
  Future<List<Map<String, dynamic>>> fetchWhereOr(
    String table,
    String orFilter, {
    String? orderBy,
    bool ascending = true,
  }) async {
    dynamic q = _client.from(table).select().or(orFilter);
    if (orderBy != null) q = q.order(orderBy, ascending: ascending);
    final data = await q;
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Lee una fila por ID.
  Future<Map<String, dynamic>?> fetchById(String table, int id) async {
    final data = await _client.from(table).select().eq('id', id).maybeSingle();
    return data;
  }

  /// Lee una fila por un campo arbitrario.
  Future<Map<String, dynamic>?> fetchByField(
    String table,
    String field,
    dynamic value,
  ) async {
    final data =
        await _client.from(table).select().eq(field, value).maybeSingle();
    return data;
  }

  /// Lee una fila con filtro compuesto (dos campos).
  Future<Map<String, dynamic>?> fetchByTwoFields(
    String table,
    String field1,
    dynamic value1,
    String field2,
    dynamic value2,
  ) async {
    final data = await _client
        .from(table)
        .select()
        .eq(field1, value1)
        .eq(field2, value2)
        .maybeSingle();
    return data;
  }

  /// Cuenta filas que cumplen un filtro.
  Future<int> count(String table, {Map<String, dynamic>? filters}) async {
    dynamic builder = _client.from(table).select('id');
    if (filters != null) {
      for (final e in filters.entries) {
        builder = builder.eq(e.key, e.value);
      }
    }
    final data = await builder;
    return (data as List).length;
  }

  // -------------------------------------------------------------------
  // INSERT
  // -------------------------------------------------------------------

  /// Inserta una fila y retorna el ID asignado por el server.
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final result =
        await _client.from(table).insert(data).select('id').single();
    return (result['id'] as num).toInt();
  }

  /// Inserta múltiples filas en lote.
  Future<void> insertBatch(
      String table, List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    await _client.from(table).insert(rows);
  }

  // -------------------------------------------------------------------
  // UPDATE
  // -------------------------------------------------------------------

  /// Actualiza una fila por ID.
  Future<void> updateById(
    String table,
    int id,
    Map<String, dynamic> data,
  ) async {
    await _client.from(table).update(data).eq('id', id);
  }

  /// Actualiza filas por filtro.
  Future<void> updateWhere(
    String table,
    Map<String, dynamic> filters,
    Map<String, dynamic> data,
  ) async {
    dynamic builder = _client.from(table).update(data);
    for (final e in filters.entries) {
      builder = builder.eq(e.key, e.value);
    }
    await builder;
  }

  // -------------------------------------------------------------------
  // UPSERT
  // -------------------------------------------------------------------

  /// Upsert por conflicto en una columna natural (ej: `nombre`, `codigo`).
  Future<int> upsert(
    String table,
    Map<String, dynamic> data, {
    required String conflictColumn,
  }) async {
    final result = await _client
        .from(table)
        .upsert(data, onConflict: conflictColumn)
        .select('id')
        .single();
    return (result['id'] as num).toInt();
  }

  /// Upsert por ID.
  Future<int> upsertById(String table, Map<String, dynamic> data) async {
    final result = await _client
        .from(table)
        .upsert(data, onConflict: 'id')
        .select('id')
        .single();
    return (result['id'] as num).toInt();
  }

  // -------------------------------------------------------------------
  // DELETE
  // -------------------------------------------------------------------

  /// Elimina una fila por ID.
  Future<void> deleteById(String table, int id) async {
    await _client.from(table).delete().eq('id', id);
  }

  /// Elimina filas por filtro.
  Future<void> deleteWhere(
    String table,
    Map<String, dynamic> filters,
  ) async {
    var builder = _client.from(table).delete();
    for (final e in filters.entries) {
      final v = e.value is bool ? (e.value ? 1 : 0) : e.value;
      builder = builder.eq(e.key, v);
    }
    await builder;
  }

  // -------------------------------------------------------------------
  // RPC
  // -------------------------------------------------------------------

  /// Ejecuta una función RPC en Supabase.
  Future<dynamic> rpc(
    String functionName, {
    Map<String, dynamic>? params,
  }) async {
    return _client.rpc(functionName, params: params);
  }
}
