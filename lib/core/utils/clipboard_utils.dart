/// Lectura de imagen del portapapeles del sistema.
///
/// - Windows: lee CF_DIB del portapapeles vía Win32 MethodChannel.
/// - Web: ya se maneja con `setupPasteImageListener` en `web_utils_web.dart`.
/// - Otros (Android, Linux): stub — no hay forma estándar de leer imágenes.
library;

export 'clipboard_utils_stub.dart'
    if (dart.library.windows) 'clipboard_utils_windows.dart';
