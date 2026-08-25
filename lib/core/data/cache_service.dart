import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Entrada de cache con timestamp para stale-while-revalidate.
class CacheEntry<T> {
  final T data;
  final DateTime cachedAt;

  const CacheEntry({required this.data, required this.cachedAt});

  bool isStale(Duration ttl) => DateTime.now().difference(cachedAt) > ttl;
}

/// Servicio de cache local con SharedPreferences.
///
/// Almacena JSON en SharedPreferences con timestamp para
/// stale-while-revalidate: sirve datos viejos mientras refresca en background.
class CacheService {
  CacheService(this._prefs);
  final SharedPreferences _prefs;

  /// TTL por defecto: 5 minutos.
  static const defaultTtl = Duration(minutes: 5);

  /// Guarda datos en cache bajo una clave.
  Future<void> put<T>(
    String key,
    T data, {
    Duration ttl = defaultTtl,
  }) async {
    final entry = {
      'data': data,
      'cachedAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString(key, jsonEncode(entry));
  }

  /// Lee datos del cache. Retorna null si no existe o esta expirado.
  CacheEntry<T>? get<T>(String key, {Duration ttl = defaultTtl}) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(decoded['cachedAt'] as String);
      final entry = CacheEntry(
        data: decoded['data'] as T,
        cachedAt: cachedAt,
      );
      if (entry.isStale(ttl)) return null;
      return entry;
    } catch (_) {
      return null;
    }
  }

  /// Lee datos sin importar si estan expirados (para fallback offline).
  CacheEntry<T>? getStale<T>(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(decoded['cachedAt'] as String);
      return CacheEntry(
        data: decoded['data'] as T,
        cachedAt: cachedAt,
      );
    } catch (_) {
      return null;
    }
  }

  /// Elimina una clave del cache.
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Limpia todo el cache.
  Future<void> clear() async {
    final keys = _prefs.getKeys().where((k) => k.startsWith('cache_'));
    for (final k in keys) {
      await _prefs.remove(k);
    }
  }
}
