/// Lectura de imagen del portapapeles del sistema.
///
/// - Windows: lee CF_DIB del portapapeles vía Win32 MethodChannel.
/// - Web: lee vía Clipboard API del navegador (`navigator.clipboard.read()`).
/// - Otros (Android, Linux): stub — no hay forma estándar de leer imágenes.
library;

export 'clipboard_utils_stub.dart'
    if (dart.library.windows) 'clipboard_utils_windows.dart'
    if (dart.library.html) 'clipboard_utils_web.dart';
