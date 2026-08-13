import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/core/sync/sync_service.dart';

/// Test de la capa de datos local (drift) y el outbox, sin red.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('outbox registra operaciones pendientes', () async {
    final id = await addPending(
      db,
      tableName: 'categorias',
      operation: 'insert',
      data: {'nombre': 'Carnes'},
    );
    expect(id, greaterThan(0));

    final pending = await db.select(db.syncQueue).get();
    expect(pending, hasLength(1));
    expect(pending.first.targetTable, 'categorias');
    expect(pending.first.operation, 'insert');
    expect(pending.first.status, 'pending');
  });

  test('categorias se insertan y se leen', () async {
    await db.into(db.categorias).insert(
          CategoriasCompanion.insert(
            nombre: 'Vegetales',
            color: const Value('#4CAF50'),
          ),
        );

    final all = await db.select(db.categorias).get();
    expect(all, hasLength(1));
    expect(all.first.nombre, 'Vegetales');
    expect(all.first.activo, 1);
  });
}