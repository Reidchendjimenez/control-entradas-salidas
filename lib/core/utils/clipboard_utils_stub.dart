import 'dart:typed_data';

/// Stub para plataformas que no soportan lectura de imagen del portapapeles.
/// En Android/Linux no hay forma estándar de leer imágenes del clipboard.
Future<Uint8List?> readClipboardImage() async => null;
