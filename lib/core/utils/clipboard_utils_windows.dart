import 'package:flutter/services.dart';

/// Lee una imagen del portapapeles del sistema en Windows.
///
/// Utiliza un MethodChannel registrado en `clipboard_handler.cpp` que lee
/// CF_DIB del portapapeles, le antepone un BITMAPFILEHEADER y devuelve
/// los bytes BMP completos listos para decodificar con `decodeImageFromList`.
Future<Uint8List?> readClipboardImage() async {
  try {
    const channel = MethodChannel('com.lycoris.clipboard');
    final result = await channel.invokeMethod('readImage');
    if (result is Uint8List) return result;
    if (result is List) return Uint8List.fromList(result.cast<int>());
    return null;
  } on PlatformException {
    return null;
  }
}
