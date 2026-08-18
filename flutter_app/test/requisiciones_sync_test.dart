import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/features/requisiciones/data/requisiciones_repository.dart';

void main() {
  late AppDatabase db;
  late RequisicionesRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = RequisicionesRepository(db);
  });
  tearDown(() async => db.close());

  Map<String, dynamic> dec(SyncQueueData e) =>
      jsonDecode(e.data) as Map<String, dynamic>;

  test('guardarRequisicion encola la cabecera COMPLETA (no solo numero)',
      () async {
    final id = await repo.guardarRequisicion(
      origen: 'principal',
      destino: 'restaurante',
      detalles: const [
        RequisicionItem(productoId: 1, ingrediente: 'Harina', cantidad: 5),
      ],
    );

    final queue = await db.select(db.syncQueue).get();
    final reqEntry = queue.firstWhere(
      (e) => e.targetTable == 'requisiciones' && e.operation == 'upsert',
    );
    final data = dec(reqEntry);
    expect(data, containsPair('numero', isNotEmpty));
    expect(data, containsPair('origen', 'principal'));
    expect(data, containsPair('destino', 'restaurante'));
    expect(data, containsPair('estado', 'pendiente'));
    expect(data['id'], id);

    // Los detalles NO se encolan por separado: el motor los sube desde la
    // cabecera resolviendo el id remoto, evitando FK rota.
    final detEntries = queue.where((e) => e.targetTable == 'requisicion_detalles');
    expect(detEntries, isEmpty);
  });

  test('marcar detalle verificado re-encola la cabecera completa', () async {
    final id = await repo.guardarRequisicion(
      origen: 'principal',
      destino: 'restaurante',
      detalles: const [
        RequisicionItem(productoId: 1, ingrediente: 'Harina', cantidad: 5),
      ],
    );
    final det = (await repo.getDetalles(id)).first;
    await repo.marcarDetalleVerificado(det.id, true);

    final queue = await db.select(db.syncQueue).get();
    final reqEntries = queue
        .where((e) => e.targetTable == 'requisiciones')
        .map(dec)
        .toList();
    expect(reqEntries, isNotEmpty);
    expect(reqEntries.last['estado'], 'pendiente');
  });
}
