import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/features/pos/data/pos_repository.dart';
import 'package:control_entradas_salidas/features/pos/data/pos_ventas_repository.dart';

/// Fase 6.2 — Mesas/Habitaciones: apertura de comanda, estado Ocupada y liberación.
void main() {
  late AppDatabase db;
  late PosRepository repo;
  late PosVentasRepository ventas;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = PosRepository(db);
    ventas = PosVentasRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('abrir comanda de mesa la marca ocupada', () async {
    final mesaId = await repo.crearMesa('1', zona: 'Terraza');
    final uid = await repo.crearUsuario('Cajero');
    final sesionId = await repo.abrirSesion(uid);

    final comandaId = await ventas.guardarComanda(
      sesionId,
      [],
      0,
      mesaId: mesaId,
    );
    expect(comandaId, greaterThan(0));

    expect(await ventas.getMesasOcupadas(), contains(mesaId));
    final abierta = await ventas.getComandaAbierta(mesaId: mesaId);
    expect(abierta, isNotNull);
    expect(abierta!.estado, 'abierta');
    expect(abierta.mesaId, mesaId);
  });

  test('guardarComanda reutiliza la comanda abierta de la mesa', () async {
    final mesaId = await repo.crearMesa('2');
    final uid = await repo.crearUsuario('Cajero');
    final sesionId = await repo.abrirSesion(uid);

    final c1 = await ventas.guardarComanda(sesionId, [], 0, mesaId: mesaId);
    final c2 = await ventas.guardarComanda(sesionId, [], 0, mesaId: mesaId);
    expect(c1, c2);
    expect(await ventas.getComandasAbiertas(), hasLength(1));
  });

  test('liberar comanda deja la mesa libre', () async {
    final mesaId = await repo.crearMesa('3');
    final uid = await repo.crearUsuario('Cajero');
    final sesionId = await repo.abrirSesion(uid);

    final comandaId = await ventas.guardarComanda(sesionId, [], 0, mesaId: mesaId);
    expect(await ventas.getMesasOcupadas(), contains(mesaId));

    await ventas.eliminarComanda(comandaId);
    expect(await ventas.getMesasOcupadas(), isEmpty);
    expect(await ventas.getComandasAbiertas(), isEmpty);
  });

  test('apertura de comanda de habitación', () async {
    final habId = await repo.crearHabitacion('101', piso: '1', tipo: 'Simple');
    final uid = await repo.crearUsuario('Cajero');
    final sesionId = await repo.abrirSesion(uid);

    await ventas.guardarComanda(sesionId, [], 0, habitacionId: habId);
    expect(await ventas.getHabitacionesOcupadas(), contains(habId));
    expect(await ventas.getComandaAbierta(habitacionId: habId), isNotNull);
  });
}
