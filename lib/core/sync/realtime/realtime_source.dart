/// Interfaz abstracta para fuentes de eventos en tiempo real.
///
/// Permite desacoplar la app del proveedor concreto (Supabase Realtime,
/// WebSocket propio, Firebase, etc.). La app solo usa esta interfaz;
/// el proveedor se inyecta vía Riverpod y se puede cambiar sin tocar
/// la lógica de sincronización.
abstract class RealtimeSource {
  /// Escucha cambios en una tabla remota.
  ///
  /// Emite un [RealtimeEvent] cada vez que se produce un INSERT, UPDATE
  /// o DELETE en la tabla indicada. La tabla debe usar el nombre del
  /// servidor (ej: 'categorias', 'productos', 'requisiciones').
  Stream<RealtimeEvent> watchTable(String table);

  /// Reconectar si se pierde la conexión WebSocket.
  void reconnect();

  /// Detener todas las suscripciones y liberar recursos.
  void dispose();
}

/// Tipo de operación que originó el evento.
enum RealtimeOperation { insert, update, delete }

/// Evento de cambio en tiempo real proveniente del servidor.
class RealtimeEvent {
  /// Nombre de la tabla afectada (nombre del servidor).
  final String table;

  /// Tipo de operación.
  final RealtimeOperation operation;

  /// Fila afectada (payload completo del row).
  final Map<String, dynamic> row;

  /// Timestamp del evento (UTC).
  final DateTime timestamp;

  const RealtimeEvent({
    required this.table,
    required this.operation,
    required this.row,
    required this.timestamp,
  });

  @override
  String toString() => 'RealtimeEvent($table, $operation, id=${row['id']})';
}
