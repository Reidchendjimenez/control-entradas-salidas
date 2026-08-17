/// Facade de operaciones nativas del updater (Windows/Android).
///
/// Web no puede importar `dart:io`, así que la implementación real vive en
/// `updater_platform_io.dart` (solo nativo) y este archivo la expone de forma
/// condicional; en web se usa el stub vacío.
library;

import 'updater_platform_stub.dart'
    if (dart.library.io) 'updater_platform_io.dart' as impl;

/// True si la plataforma es nativa (Windows/Android) y soporta actualización.
bool get updaterCanRun => impl.updaterCanRun;

/// Clave de la plataforma actual (`windows`/`android`/`web`).
String get updaterPlatformKey => impl.updaterPlatformKey;

/// Directorio de descargas de la app (creado si no existe).
Future<String> updaterDownloadDir() => impl.updaterDownloadDir();

/// Descarga `url` a `destPath` y reporta progreso. Devuelve la ruta final.
Future<String> updaterDownloadFile(
  String url,
  String destPath,
  int expectedBytes,
  void Function(int received, int total)? onProgress,
) =>
    impl.updaterDownloadFile(url, destPath, expectedBytes, onProgress);

/// Instala el binario descargado según la plataforma.
Future<void> updaterInstall(String filePath) => impl.updaterInstall(filePath);