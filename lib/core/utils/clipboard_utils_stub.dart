import 'dart:typed_data';
import 'package:flutter/services.dart';

/// Stub para plataformas que no soportan lectura de imagen del portapapeles.
/// En Android/Linux no hay forma estándar de leer imágenes del clipboard.
Future<Uint8List?> readClipboardImage() async {
  throw PlatformException(
    code: 'STUB_LOADED',
    message: '⚠️ STUB cargado en vez de clipboard_windows. '
        'Platform: unknown. Esto NO debería ocurrir en Windows.',
  );
}
