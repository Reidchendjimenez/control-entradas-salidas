import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Lee una imagen del portapapeles del sistema.
///
/// - Windows: lee CF_DIB/DIBV5/PNG del portapapeles vía Win32 MethodChannel.
/// - Otros: lanza error explícito (sin soporte nativo para leer imágenes).
Future<Uint8List?> readClipboardImage() async {
  if (Platform.isWindows) {
    return _readClipboardImageWindows();
  }
  throw PlatformException(
    code: 'UNSUPPORTED_PLATFORM',
    message: 'Lectura de portapapeles no soportada en esta plataforma.',
  );
}

Future<Uint8List?> _readClipboardImageWindows() async {
  try {
    const channel = MethodChannel('com.lycoris.clipboard');
    final result = await channel.invokeMethod('readImage');
    if (result is Uint8List) return result;
    if (result is List) return Uint8List.fromList(result.cast<int>());
    throw Exception(
        'Tipo inesperado del portapapeles: ${result.runtimeType} '
        '(isNull=${result == null}, valor=$result)');
  } on PlatformException {
    rethrow;
  } on FlutterError {
    rethrow;
  }
}
