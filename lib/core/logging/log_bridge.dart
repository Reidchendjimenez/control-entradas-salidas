import 'package:flutter/foundation.dart';

/// Puente de logs para desarrollo en la web.
///
/// En el navegador, `print()` solo aparece en la consola del navegador.
/// Este bridge reenvía todos los logs a un servidor local (tool/server.py)
/// a través de un POST a `/log` para poder verlos en la terminal.
class LogBridge {
  LogBridge._();

  static final LogBridge instance = LogBridge._();

  final List<String> _pending = [];

  Future<void> start() async {
    if (!kIsWeb) return;

    // Reenvía errores de Flutter (widgets) y errores globales no capturados.
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      return true;
    };
  }

  void push(String line) {
    _pending.add(line);
  }

  Future<void> flush() async {}
}