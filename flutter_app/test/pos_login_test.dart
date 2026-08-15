import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/features/pos/data/pos_repository.dart';

/// Fase 6.1 — Login PIN: usuarios con/sin PIN, verificación y sesión de caja.
void main() {
  late AppDatabase db;
  late PosRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = PosRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('seed: usuario admin sin PIN', () async {
    await repo.crearUsuario('Desarrollador', esAdmin: true);
    final usuarios = await repo.getUsuarios();
    expect(usuarios, hasLength(1));
    expect(usuarios.first.nombre, 'Desarrollador');
    expect(usuarios.first.esAdmin, 1);
    expect(usuarios.first.pinHash, isNull);
  });

  test('usuario con PIN de 4 dígitos', () async {
    await repo.crearUsuario('Cajero', pin: '1234');
    final usuarios = await repo.getUsuarios();
    expect(usuarios.first.pinHash, isNotNull);
    expect(await repo.verificarPin(usuarios.first.id, '1234'), isTrue);
    expect(await repo.verificarPin(usuarios.first.id, '0000'), isFalse);
  });

  test('login sin PIN abre sesión directamente', () async {
    final uid = await repo.crearUsuario('Cajero');
    final sesionId = await repo.abrirSesion(uid);
    expect(sesionId, greaterThan(0));

    final activa = await repo.getSesionActiva();
    expect(activa, isNotNull);
    expect(activa!.sesion.usuarioId, uid);
    expect(activa.usuarioNombre, 'Cajero');
  });

  test('cerrarSesion deja de haber sesión activa', () async {
    final uid = await repo.crearUsuario('Cajero');
    final sesionId = await repo.abrirSesion(uid);
    await repo.cerrarSesion(sesionId);
    expect(await repo.getSesionActiva(), isNull);
  });
}
