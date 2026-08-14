import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;

import '../../../core/db/schema/app_database.dart';

/// URL del bot de WhatsApp y token (replican `usr/whatsapp_notifier.py`).
const whatsappBotUrl = 'https://lycorys-control.shares.zrok.io';
const whatsappBotToken = 'mi_token_secreto_123';

/// Repositorio de la cola local de WhatsApp — réplica de
/// `usr/whatsapp_notifier.py` y `usr/views/whatsapp_bandeja_view.py`.
///
/// La cola es local (outbox): los mensajes se envían por HTTP al bot y si
/// fallan quedan en `whatsapp_queue` con estado `pending` para reintentar.
class WhatsappRepository {
  WhatsappRepository(this._db);

  final AppDatabase _db;

  static String get botUrl => whatsappBotUrl;

  // ---------------------------------------------------------------------
  // Consultas de la cola
  // ---------------------------------------------------------------------

  /// Mensajes de la cola (los más recientes primero).
  Future<List<WhatsappQueueData>> getMensajes({
    String? estado,
    int limit = 100,
  }) async {
    final q = _db.select(_db.whatsappQueue)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(limit);
    if (estado != null) {
      q.where((t) => t.estado.equals(estado));
    }
    return q.get();
  }

  /// Cantidad de mensajes pendientes por reintentar.
  Future<int> countPending() async {
    final q = _db.selectOnly(_db.whatsappQueue)
      ..addColumns([_db.whatsappQueue.id.count()])
      ..where(_db.whatsappQueue.estado.equals('pending') &
          _db.whatsappQueue.intentos.isSmallerThan(
              _db.whatsappQueue.maxIntentos));
    final row = await q.getSingle();
    return row.read(_db.whatsappQueue.id.count()) ?? 0;
  }

  /// Guarda un mensaje en la cola local.
  Future<void> saveToQueue({
    required String tipo,
    String mensaje = '',
    String? imagenBase64,
    String? imagenPath,
  }) async {
    await _db.into(_db.whatsappQueue).insert(
          WhatsappQueueCompanion.insert(
            tipo: Value(tipo),
            mensaje: Value(mensaje),
            imagenBase64: Value(imagenBase64),
            imagenPath: Value(imagenPath),
            createdAt: DateTime.now(),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Actualiza el estado de un mensaje.
  Future<void> updateEstado(int id, String estado, {String? error}) async {
    await (_db.update(_db.whatsappQueue)..where((t) => t.id.equals(id)))
        .write(WhatsappQueueCompanion(
      estado: Value(estado),
      ultimoError: Value(error),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Elimina un mensaje de la cola.
  Future<void> eliminar(int id) async {
    await (_db.delete(_db.whatsappQueue)..where((t) => t.id.equals(id))).go();
  }

  // ---------------------------------------------------------------------
  // Envío directo al bot
  // ---------------------------------------------------------------------

  Map<String, String> get _headers => {
        'x-auth-token': whatsappBotToken,
        // zrok (plan free) muestra una página interstitial a los navegadores
        // y bloquea CORS; este header la salta. Véase docs de zrok.
        'skip_zrok_interstitial': '1',
      };

  /// POST /send — envía un texto al grupo del bot.
  Future<bool> _enviarTextoDirecto(String mensaje) async {
    try {
      final resp = await http
          .post(
            Uri.parse('$whatsappBotUrl/send'),
            headers: _headers,
            body: {'message': mensaje},
          )
          .timeout(const Duration(seconds: 10));
      if (resp.statusCode != 200) {
        print('[WA] send texto -> ${resp.statusCode} ${resp.body}');
      }
      return resp.statusCode == 200;
    } catch (e) {
      print('[WA] send texto error: $e');
      return false;
    }
  }

  /// POST /send-image — envía una imagen (base64) con caption.
  Future<bool> _enviarImagenDirecto({
    String? imagenBase64,
    String caption = '',
    String? imagenPath,
  }) async {
    final b64 = imagenBase64;
    if (b64 == null || b64.isEmpty) return false;
    try {
      final resp = await http
          .post(
            Uri.parse('$whatsappBotUrl/send-image'),
            headers: {..._headers, 'Content-Type': 'application/json'},
            body: '{"imageBase64": "$b64", "caption": "$caption"}',
          )
          .timeout(const Duration(seconds: 30));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  /// GET /config — estado del bot.
  Future<({bool connected, String? groupId})> getStatus() async {
    try {
      final resp = await http
          .get(Uri.parse('$whatsappBotUrl/config'), headers: _headers)
          .timeout(const Duration(seconds: 5));
      if (resp.statusCode != 200) {
        return (connected: false, groupId: null);
      }
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return (
        connected: data['whatsapp_connected'] == true,
        groupId: data['group_id'] as String?,
      );
    } catch (_) {
      return (connected: false, groupId: null);
    }
  }

  // ---------------------------------------------------------------------
  // Envío con cola (intenta directo y si falla guarda en cola)
  // ---------------------------------------------------------------------

  /// Envía un mensaje de texto; si falla lo encola para reintentar.
  Future<bool> enviarMensaje(String mensaje) async {
    if (await _enviarTextoDirecto(mensaje)) return true;
    await saveToQueue(tipo: 'text', mensaje: mensaje);
    return false;
  }

  /// Envía una imagen; si falla la encola.
  Future<bool> enviarImagen({
    required String? imagenBase64,
    String caption = '',
  }) async {
    if (imagenBase64 != null &&
        await _enviarImagenDirecto(
            imagenBase64: imagenBase64, caption: caption)) {
      return true;
    }
    await saveToQueue(
      tipo: imagenBase64 != null ? 'image' : 'text',
      mensaje: caption,
      imagenBase64: imagenBase64,
    );
    return false;
  }

  // ---------------------------------------------------------------------
  // Reintentos
  // ---------------------------------------------------------------------

  /// Procesa los mensajes pendientes/fallidos (igual que
  /// `retry_queued_messages` en Python). Devuelve cuántos se enviaron.
  Future<int> reintentarTodos({int limit = 20}) async {
    final pendientes = await getMensajesEstados(
      estados: const ['pending', 'failed'],
      limit: limit,
    );
    var ok = 0;
    for (final msg in pendientes) {
      if (await _enviarDesdeCola(msg)) ok++;
    }
    return ok;
  }

  /// Reintenta un único mensaje; devuelve true si se envió.
  Future<bool> reintentarUno(int id) async {
    final msg = await (_db.select(_db.whatsappQueue)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (msg == null) return false;
    return _enviarDesdeCola(msg);
  }

  /// Envía un mensaje de la cola y actualiza su estado.
  Future<bool> _enviarDesdeCola(WhatsappQueueData msg) async {
    if (msg.estado != 'pending' && msg.estado != 'failed') return false;
    await updateEstado(msg.id, 'sending');
    final success = msg.tipo == 'image'
        ? await _enviarImagenDirecto(
            imagenBase64: msg.imagenBase64,
            caption: msg.mensaje ?? '',
            imagenPath: msg.imagenPath,
          )
        : await _enviarTextoDirecto(msg.mensaje ?? '');
    if (success) {
      await updateEstado(msg.id, 'sent');
    } else {
      final intentos = msg.intentos + 1;
      final estado = intentos >= msg.maxIntentos ? 'failed' : 'pending';
      await (_db.update(_db.whatsappQueue)..where((t) => t.id.equals(msg.id)))
          .write(WhatsappQueueCompanion(
        intentos: Value(intentos),
        estado: Value(estado),
        ultimoError: const Value('Error de conexión'),
        updatedAt: Value(DateTime.now()),
      ));
    }
    return success;
  }

  /// Mensajes en los estados dados, los más antiguos primero.
  Future<List<WhatsappQueueData>> getMensajesEstados({
    required List<String> estados,
    int limit = 50,
  }) async {
    final q = _db.select(_db.whatsappQueue)
      ..where((t) => t.estado.isIn(estados))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
      ..limit(limit);
    return q.get();
  }

  /// Mensaje de prueba del bot (igual que `_on_test_bot` en Flet).
  Future<bool> probarBot(String usuario) async {
    final ts = _fmtFechaHora(DateTime.now());
    final msg = '🤖 *Bot activo*\n👤 $usuario\n🕐 $ts';
    return enviarMensaje(msg);
  }
}

String _fmtFechaHora(DateTime d) {
  String p(int v) => v.toString().padLeft(2, '0');
  return '${p(d.day)}/${p(d.month)} ${p(d.hour)}:${p(d.minute)}';
}

/// Mensaje de "Entrada Validada" — réplica de
/// `format_validation_message()` en `usr/whatsapp_notifier.py`.
String formatValidationMessage({
  required String productos,
  required String proveedor,
  required String factura,
  double monto = 0,
  String usuario = '',
  DateTime? fechaEntrada,
}) {
  final fechaStr = fechaEntrada != null
      ? _fmtFechaHora(fechaEntrada)
      : _fmtFechaHora(DateTime.now());
  final productosBlock = productos.contains('\n')
      ? '📦 *Cargo productos:*\n'
          '${productos.split('\n').map((l) => '• $l').join('\n')}'
      : '📦 *Cargo productos:* $productos';
  return '✅ *Entrada Validada* ✅\n\n'
      '$productosBlock\n'
      '🏢 *Proveedor:* $proveedor\n'
      '📃 *Factura:* $factura\n'
      '🕐 *Fecha:* $fechaStr\n'
      '👤 *Usuario:* $usuario\n\n'
      '_🤖-Lycoris_bot_';
}
