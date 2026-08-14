import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Puente de logs para desarrollo en la web.
///
/// En el navegador, `print()` solo aparece en la consola del navegador.
/// Este bridge reenvía todos los logs a un servidor local (tool/server.py)
/// a través de un POST a `/log` para poder verlos en la terminal.
class LogBridge {
  LogBridge._();

  static final LogBridge instance = LogBridge._();

  static const _endpoint = '/log';

  final List<String> _pending = [];
  Timer? _timer;

  Future<void> start() async {
    if (!kIsWeb) return;

    // Reenvía errores de Flutter (widgets) y errores globales no capturados.
    FlutterError.onError = (details) {
      push('[FLUTTER] ${details.exception}');
      FlutterError.dumpErrorToConsole(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      push('[UNCAUGHT] $error\n$stack');
      return true;
    };
  }

  void push(String line) {
    _pending.add(line);
    _timer ??= Timer(const Duration(milliseconds: 200), flush);
  }

  Future<void> flush() async {
    if (!kIsWeb || _pending.isEmpty) return;

    final batch = _pending.join('\n');
    _pending.clear();
    _timer?.cancel();
    _timer = null;

    try {
      await http
          .post(Uri.parse(_endpoint), body: batch)
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      // El servidor de logs no está corriendo: se ignora.
    }
  }
}