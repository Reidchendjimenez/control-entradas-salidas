import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

/// Logger simple que escribe a un archivo junto al exe (solo nativo).
/// En web es un no-op.
class FileLogger {
  FileLogger._();
  static final instance = FileLogger._();

  IOSink? _sink;
  bool _initialized = false;

  /// Inicializa el logger creando/abriendo `sync.log` junto al exe.
  void init() {
    if (_initialized) return;
    _initialized = true;
    if (kIsWeb) return;
    try {
      final exeDir = p.dirname(Platform.resolvedExecutable);
      final file = File('$exeDir/sync.log');
      _sink = file.openWrite(mode: FileMode.append);
    } catch (_) {}
  }

  /// Escribe una línea con timestamp.
  void log(String msg) {
    if (_sink == null) return;
    final now = DateTime.now();
    final ts =
        '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    _sink!.writeln('[$ts] $msg');
    _sink!.flush();
  }

  void dispose() {
    _sink?.close();
    _sink = null;
  }
}

/// Función global para logging a archivo (junto al exe).
void logToFile(String msg) {
  FileLogger.instance.log(msg);
}
