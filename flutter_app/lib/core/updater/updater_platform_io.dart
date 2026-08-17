/// Implementación nativa (Windows/Android) de las operaciones del updater.
///
/// Usa `dart:io` + `path_provider`; no compila en web (se elige con el
/// import condicional de `updater_platform.dart`).
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

bool get updaterCanRun {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isAndroid;
}

String get updaterPlatformKey {
  if (kIsWeb) return 'web';
  if (Platform.isAndroid) return 'android';
  if (Platform.isWindows) return 'windows';
  return 'web';
}

Future<String> updaterDownloadDir() async {
  final base = await getApplicationSupportDirectory();
  final dir = Directory('${base.path}/updates');
  if (!await dir.exists()) await dir.create(recursive: true);
  return dir.path;
}

Future<String> updaterDownloadFile(
  String url,
  String destPath,
  int expectedBytes,
  void Function(int received, int total)? onProgress,
) async {
  final tmpPath = '$destPath.part';
  final req = http.Request('GET', Uri.parse(url))
    ..headers['User-Agent'] = 'Lycoris-App';
  final res = await http.Client().send(req);
  if (res.statusCode != 200) {
    throw Exception('Descarga falló (HTTP ${res.statusCode})');
  }
  final file = File(tmpPath);
  final sink = file.openWrite();
  var received = 0;
  final total = res.contentLength ?? expectedBytes;
  await for (final chunk in res.stream) {
    received += chunk.length;
    sink.add(chunk);
    onProgress?.call(received, total);
  }
  await sink.close();
  if (File(destPath).existsSync()) File(destPath).deleteSync();
  await file.rename(destPath);
  return destPath;
}

Future<void> updaterInstall(String filePath) async {
  if (Platform.isAndroid) {
    await _installAndroid(filePath);
  } else if (Platform.isWindows) {
    await _installWindows(filePath);
  } else {
    throw UnsupportedError('Instalación no soportada en esta plataforma');
  }
}

// ---------------------------------------------------------------------------
// Android: PackageInstaller vía MethodChannel (MainActivity.kt)
// ---------------------------------------------------------------------------

const _channel = MethodChannel('lycoris/updater');

class UpdatePermissionException implements Exception {
  @override
  String toString() =>
      'Habilita "Instalar apps desconocidas" en la configuración del sistema';
}

Future<void> _installAndroid(String apkPath) async {
  final canInstall = await _channel.invokeMethod<bool>(
      'canRequestUnknownSources');
  if (canInstall != true) {
    throw UpdatePermissionException();
  }
  final ok =
      await _channel.invokeMethod<bool>('installApk', {'path': apkPath});
  if (ok != true) {
    throw Exception('La instalación del APK falló');
  }
}

// ---------------------------------------------------------------------------
// Windows: zip + updater.bat (reemplaza archivos y relanza al cerrar la app)
// ---------------------------------------------------------------------------

Future<void> _installWindows(String zipPath) async {
  final base = await getApplicationSupportDirectory();
  final appDir = Directory(base.path);
  final staging = Directory('${appDir.path}/update_staging');
  if (await staging.exists()) await staging.delete(recursive: true);
  await staging.create(recursive: true);

  await _extractZip(zipPath, staging.path);

  final updatesDir = Directory('${appDir.path}/updates');
  if (await updatesDir.exists()) await updatesDir.delete(recursive: true);
  await updatesDir.create(recursive: true);
  await _copyContents(staging, updatesDir);

  final bat = File('${appDir.path}/updater.bat');
  final logFile = File('${appDir.path}/updater.log');
  final currentExe = Platform.resolvedExecutable;
  final targetExe = _basename(currentExe);
  final exeDir = _dirname(currentExe);
  final srcPattern = '${updatesDir.path}\\*.*';
  await bat.writeAsString('''
@echo off
title Lycoris Updater
echo [%date% %time%] Iniciando updater > ${_q(logFile.path)}
echo [%date% %time%] Exe actual: %~dp0 >> ${_q(logFile.path)}
echo [%date% %time%] ExeDir: ${exeDir} >> ${_q(logFile.path)}
echo [%date% %time%] SrcPattern: ${srcPattern} >> ${_q(logFile.path)}
echo Esperando que cierre la aplicacion...
taskkill /IM ${_q(targetExe)} /F >nul 2>&1
echo [%date% %time%] taskkill completado >> ${_q(logFile.path)}
timeout /t 2 /nobreak >nul
echo Copiando actualizacion...
xcopy /E /Y /Q ${_q(srcPattern)} ${_q(exeDir)} >> ${_q(logFile.path)} 2>&1
echo [%date% %time%] xcopy exit code: %errorlevel% >> ${_q(logFile.path)}
if errorlevel 1 (
  echo Error copiando archivos - ver updater.log
  echo [%date% %time%] ERROR en xcopy >> ${_q(logFile.path)}
  timeout /t 5 /nobreak >nul
)
del ${_q(updatesDir.path)}\\*.* /q 2>nul
echo Iniciando ${_q(targetExe)}...
echo [%date% %time%] Relanzando app >> ${_q(logFile.path)}
start "" ${_q('$exeDir\\$targetExe')}
del "%~f0"
''');

  final proc = await Process.start(
    'cmd.exe',
    ['/c', bat.path],
    mode: ProcessStartMode.detached,
  );
  await Future.delayed(const Duration(milliseconds: 500));
  exit(0);
}

Future<void> _extractZip(String zipPath, String dest) async {
  final r = await Process.run('tar', ['-xf', zipPath, '-C', dest]);
  if (r.exitCode != 0) {
    throw Exception('Error extrayendo zip: ${r.stderr}');
  }
}

Future<void> _copyContents(Directory src, Directory dest) async {
  await for (final e in src.list(recursive: true)) {
    if (e is File) {
      final rel = e.path.substring(src.path.length + 1);
      final target = File('${dest.path}/$rel');
      if (!await target.parent.exists()) {
        await target.parent.create(recursive: true);
      }
      await e.copy(target.path);
    }
  }
}

String _basename(String p) => p.split(RegExp(r'[\\/]')).last;
String _dirname(String p) => p.substring(0, p.length - _basename(p).length - 1);
String _q(String s) => '"${s.replaceAll('"', '""')}"';