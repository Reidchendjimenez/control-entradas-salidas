import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Abre la BD local en nativo con ruta **fija y estable**: un subdirectorio
/// `Lycoris` dentro del directorio de soporte de la app (AppData en Windows).
/// Evita que el archivo `.sqlite` aparezca en Documentos o en cualquier otra
/// carpeta según cómo `path_provider` resuelva el nombre de la app.
QueryExecutor openDbExecutor() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final dataDir = Directory(p.join(dir.path, 'Lycoris'));
    await dataDir.create(recursive: true);
    return NativeDatabase.createInBackground(
      File(p.join(dataDir.path, 'control_entradas_salidas.sqlite')),
    );
  });
}