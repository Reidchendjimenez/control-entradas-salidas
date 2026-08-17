import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Abre la BD local en web (SQLite WASM en el navegador).
QueryExecutor openDbExecutor() {
  return driftDatabase(
    name: 'control_entradas_salidas',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}