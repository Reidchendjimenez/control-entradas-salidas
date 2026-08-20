import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'realtime_source.dart';

/// Implementación de [RealtimeSource] sobre Supabase Realtime (Postgres Changes).
///
/// Usa el canal WebSocket nativo de Supabase para escuchar cambios en tablas
/// PostgreSQL en tiempo real. Cada tabla se suscribe con un channel separado.
///
/// Para usar con otro backend (servidor propio, Firebase, etc.), crear una
/// implementación alternativa de [RealtimeSource] que emita los mismos
/// [RealtimeEvent].
class SupabaseRealtimeSource implements RealtimeSource {
  final SupabaseClient _client;

  /// Canales activos por nombre de tabla.
  final Map<String, RealtimeChannel> _channels = {};

  /// Controllers por nombre de tabla (múltiples listeners posibles).
  final Map<String, StreamController<RealtimeEvent>> _controllers = {};

  /// Tablas que ya tienen suscripción activa.
  final Set<String> _subscribed = {};

  SupabaseRealtimeSource(this._client);

  @override
  Stream<RealtimeEvent> watchTable(String table) {
    // Crear controller si no existe para esta tabla.
    final controller = _controllers.putIfAbsent(
      table,
      () => StreamController<RealtimeEvent>.broadcast(),
    );

    // Suscribirse solo si no estaba ya suscrito.
    if (!_subscribed.contains(table)) {
      _subscribeToTable(table);
    }

    return controller.stream;
  }

  void _subscribeToTable(String table) {
    final channelName = 'realtime:$table';

    final channel = _client.channel(channelName).onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: table,
      callback: (payload) {
        final event = _mapPayload(table, payload);
        if (event != null) {
          _controllers[table]?.add(event);
        }
      },
    );

    channel.subscribe((status, [error]) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        _subscribed.add(table);
      } else if (error != null) {
        // Reintentar después de un delay en caso de error.
        Future.delayed(const Duration(seconds: 5), () {
          if (_subscribed.contains(table)) {
            _subscribed.remove(table);
            _subscribeToTable(table);
          }
        });
      }
    });

    _channels[table] = channel;
  }

  RealtimeEvent? _mapPayload(String table, PostgresChangePayload payload) {
    try {
      final operation = switch (payload.eventType) {
        PostgresChangeEvent.insert => RealtimeOperation.insert,
        PostgresChangeEvent.update => RealtimeOperation.update,
        PostgresChangeEvent.delete => RealtimeOperation.delete,
        PostgresChangeEvent.all => RealtimeOperation.update,
      };

      // Para DELETE, usar oldRecord; para INSERT/UPDATE, usar newRecord.
      final row = operation == RealtimeOperation.delete
          ? (payload.oldRecord as Map<String, dynamic>? ?? {})
          : (payload.newRecord as Map<String, dynamic>);

      if (row.isEmpty) return null;

      return RealtimeEvent(
        table: table,
        operation: operation,
        row: row,
        timestamp: DateTime.now().toUtc(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void reconnect() {
    for (final entry in _channels.entries) {
      final table = entry.key;
      final channel = entry.value;
      _client.removeChannel(channel);
      _subscribed.remove(table);
    }
    _channels.clear();
    // Re-suscribir a todas las tablas que estaban activas.
    for (final table in _controllers.keys) {
      _subscribeToTable(table);
    }
  }

  @override
  void dispose() {
    for (final channel in _channels.values) {
      _client.removeChannel(channel);
    }
    _channels.clear();
    _subscribed.clear();
    for (final controller in _controllers.values) {
      controller.close();
    }
    _controllers.clear();
  }
}
