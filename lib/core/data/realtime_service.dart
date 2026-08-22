import 'dart:async';

import 'package:realtime_client/realtime_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Evento de cambio en una tabla de Supabase Realtime.
class RealtimeEvent {
  final PostgresChangeEvent type;
  final String table;
  final Map<String, dynamic>? newRecord;
  final Map<String, dynamic>? oldRecord;

  const RealtimeEvent({
    required this.type,
    required this.table,
    this.newRecord,
    this.oldRecord,
  });
}

/// Servicio generico de Supabase Realtime.
///
/// Permite suscribirse a cambios (INSERT/UPDATE/DELETE) en tablas
/// de Postgres y recibir un stream de [RealtimeEvent].
class RealtimeService {
  RealtimeService(this._client);
  final SupabaseClient _client;

  final Map<String, RealtimeSubscription> _subs = {};

  /// Suscribe a cambios en una tabla.
  ///
  /// [events] filtra que tipos de evento recibir. Si es null, recibe todos.
  /// [schema] defaults a 'public'.
  /// [filter] filtro Postgres Realtime.
  RealtimeSubscription subscribe({
    required String table,
    Set<PostgresChangeEvent>? events,
    String schema = 'public',
    PostgresChangeFilter? filter,
  }) {
    final channelName = 'rt:$table:${DateTime.now().millisecondsSinceEpoch}';

    RealtimeChannel channel = _client.channel(channelName);

    final effectiveEvents = events ??
        {PostgresChangeEvent.insert, PostgresChangeEvent.update, PostgresChangeEvent.delete};

    for (final event in effectiveEvents) {
      channel = channel.onPostgresChanges(
        event: event,
        schema: schema,
        table: table,
        filter: filter,
        callback: (payload) {
          final sub = _subs[channelName];
          if (sub == null || sub._controller.isClosed) return;
          sub._controller.add(RealtimeEvent(
            type: event,
            table: table,
            newRecord: payload.newRecord,
            oldRecord: payload.oldRecord,
          ));
        },
      );
    }

    channel.subscribe();

    final sub = RealtimeSubscription._(
      channelName: channelName,
      channel: channel,
      service: this,
    );
    _subs[channelName] = sub;
    return sub;
  }

  void _remove(String channelName) {
    _subs.remove(channelName);
  }

  /// Cancela todas las suscripciones activas.
  void dispose() {
    for (final sub in _subs.values.toList()) {
      sub.cancel();
    }
    _subs.clear();
  }
}

/// Suscripcion activa a una tabla Realtime.
class RealtimeSubscription {
  RealtimeSubscription._({
    required String channelName,
    required RealtimeChannel channel,
    required RealtimeService service,
  })  : _channelName = channelName,
        _channel = channel,
        _service = service;

  final String _channelName;
  final RealtimeChannel _channel;
  final RealtimeService _service;
  final StreamController<RealtimeEvent> _controller =
      StreamController<RealtimeEvent>.broadcast();

  /// Stream de eventos de cambio.
  Stream<RealtimeEvent> get stream => _controller.stream;

  /// Cancela esta suscripcion.
  void cancel() {
    if (_controller.isClosed) return;
    _channel.unsubscribe();
    _controller.close();
    _service._remove(_channelName);
  }
}
