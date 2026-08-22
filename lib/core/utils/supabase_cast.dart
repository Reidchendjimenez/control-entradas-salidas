/// Cast seguro de valores booleanos desde Supabase.
///
/// Supabase retorna `int` (0/1) en columnas booleanas cuando se usa
/// el driver Dart directo. Este helper convierte int/bool/null a bool.
bool toBool(dynamic v, {bool fallback = false}) {
  if (v == null) return fallback;
  if (v is bool) return v;
  if (v is int) return v != 0;
  if (v is String) return v.toLowerCase() == 'true' || v == '1';
  return fallback;
}

/// Cast seguro de enteros desde Supabase (puede venir como double).
int toInt(dynamic v, {int fallback = 0}) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v) ?? fallback;
  return fallback;
}
