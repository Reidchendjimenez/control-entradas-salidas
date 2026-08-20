/// Abre el executor de la BD local según plataforma.
/// - Web: SQLite WASM (drift_flutter).
/// - Nativo: SQLite con ruta fija en AppData (ver db_executor_io.dart).
library;

export 'db_executor_io.dart' if (dart.library.html) 'db_executor_web.dart';