/// Stub para web: el updater no aplica (la app se sirve desde el server).
library;

bool get updaterCanRun => false;

String get updaterPlatformKey => 'web';

Future<String> updaterDownloadDir() async => '';

Future<String> updaterDownloadFile(
  String url,
  String destPath,
  int expectedBytes,
  void Function(int received, int total)? onProgress,
) async {
  throw UnsupportedError('Updater no aplica en web');
}

Future<void> updaterInstall(String filePath) async {
  throw UnsupportedError('Updater no aplica en web');
}