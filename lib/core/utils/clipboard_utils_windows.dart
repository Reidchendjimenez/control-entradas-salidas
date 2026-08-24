import 'package:flutter/services.dart';

/// Lee una imagen del portapapeles del sistema en Windows.
///
/// Utiliza un MethodChannel registrado en `clipboard_handler.cpp` que lee
/// CF_DIB/CF_DIBV5/PNG/CF_BITMAP del portapapeles y devuelve bytes BMP.
/// En caso de error, lanza [PlatformException] con los formatos encontrados.
Future<Uint8List?> readClipboardImage() async {
  try {
    const channel = MethodChannel('com.lycoris.clipboard');
    final result = await channel.invokeMethod('readImage');
    if (result is Uint8List) return result;
    if (result is List) return Uint8List.fromList(result.cast<int>());
    return null;
  } on PlatformException catch (e) {
    // e.message contiene la lista de formatos encontrados en el portapapeles
    rethrow;
  }
}
