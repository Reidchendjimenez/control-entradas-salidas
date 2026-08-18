import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/features/pos/data/pos_repository.dart';
import 'package:control_entradas_salidas/features/pos/data/pos_ventas_repository.dart';

/// Fase 6.4 — Ventas/caja: correlativo, registro, movimientos, paginación y
/// anulación que restaura stock y reabre la comanda.
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

  Future<(int, int)> setupBasico(String numero) async {
    final mesaId = await repo.crearMesa(numero);
    final uid = await repo.crearUsuario('Cajero');
    final sesionId = await repo.abrirSesion(uid);
    return (mesaId, sesionId);
  }

  /// Inserta un producto con existencia inicial y devuelve su id.
  Future<int> productoConStock(String nombre, double stock) async {
    final id = await db.into(db.productos).insert(ProductosCompanion.insert(
          nombre: nombre,
          precioVenta: const Value(1),
          unidadMedida: const Value('unidad'),
        ));
    await db.into(db.existencias).insert(ExistenciasCompanion.insert(
          productoId: Value(id),
          almacen: 'restaurante',
          cantidad: Value(stock),
        ));
    return id;
  }

  Future<double> stock(int productoId, [String almacen = 'restaurante']) async {
    final e = await (db.select(db.existencias)
          ..where((t) => t.productoId.equals(productoId) & t.almacen.equals(almacen)))
        .getSingleOrNull();
    return e?.cantidad ?? 0;
  }

  test('registrarVenta asigna correlativo secuencial y estado vigente', () async {
    final (mesaId, sesionId) = await setupBasico('1');
    final comandaId = await ventas.guardarComanda(
        sesionId, [{'id': 1, 'tipo': 'producto', 'nombre': 'Refresco', 'precio': 2.0, 'cantidad': 1}], 2.0,
        mesaId: mesaId);

    final c1 = await ventas.siguienteCorrelativo();
    final v1 = await ventas.registrarVenta(c1, 2.0, [], comandaId: comandaId,
        mesaId: mesaId, usuarioId: (await repo.getUsuarios()).first.id);
    final c2 = await ventas.siguienteCorrelativo();
    final v2 = await ventas.registrarVenta(c2, 2.0, [], comandaId: comandaId,
        mesaId: mesaId, usuarioId: (await repo.getUsuarios()).first.id);

    expect(v2, greaterThan(v1));
    expect((await ventas.getVenta(v1))!.estado, 'vigente');
    expect((await ventas.getVenta(v1))!.correlativo, c1);
    expect(c2, c1 + 1);
  });

  test('aplicarMovimientosVenta descuenta existencias', () async {
    final (mesaId, sesionId) = await setupBasico('2');
    final productoId = await productoConStock('Coca', 10);
    final comandaId = await ventas.guardarComanda(sesionId, [], 0, mesaId: mesaId);
    final corr = await ventas.siguienteCorrelativo();
    final ventaId = await ventas.registrarVenta(corr, 3.0, [],
        comandaId: comandaId, mesaId: mesaId);

    await ventas.aplicarMovimientosVenta(ventaId, [
      {'producto_id': productoId, 'producto_nombre': 'Coca', 'cantidad': 3.0, 'almacen': 'restaurante'},
    ]);

    expect(await stock(productoId), 7.0);
    final movs = await ventas.getMovimientosVenta(ventaId);
    expect(movs, hasLength(1));
    expect(movs.first['cantidad'], 3.0);
  });

  test('anularVenta restaura stock y reabre la comanda', () async {
    final (mesaId, sesionId) = await setupBasico('3');
    final productoId = await productoConStock('Agua', 5);
    final comandaId = await ventas.guardarComanda(
        sesionId, [{'id': 1, 'tipo': 'producto', 'nombre': 'Agua', 'precio': 1.0, 'cantidad': 2}], 2.0,
        mesaId: mesaId);
    final corr = await ventas.siguienteCorrelativo();
    final ventaId = await ventas.registrarVenta(corr, 2.0, [],
        comandaId: comandaId, mesaId: mesaId, usuarioId: (await repo.getUsuarios()).first.id);

    await ventas.aplicarMovimientosVenta(ventaId, [
      {'producto_id': productoId, 'producto_nombre': 'Agua', 'cantidad': 2.0, 'almacen': 'restaurante'},
    ]);
    await ventas.cerrarComanda(comandaId);
    expect((await ventas.getComanda(comandaId))!.estado, 'cerrada');

    await ventas.revertirMovimientosVenta(ventaId, registradoPor: 'Cajero');
    await ventas.anularVenta(ventaId, anuladaPor: 'Cajero', motivo: 'Corrección de la venta');
    await ventas.reabrirComanda(comandaId);

    expect((await ventas.getVenta(ventaId))!.estado, 'anulada');
    expect((await ventas.getVenta(ventaId))!.motivoAnulacion, 'Corrección de la venta');
    expect((await ventas.getComanda(comandaId))!.estado, 'abierta');
    expect(await stock(productoId), 5.0);
  });

  test('getVentas pagina con beforeId', () async {
    final (mesaId, sesionId) = await setupBasico('4');
    final comandaId = await ventas.guardarComanda(sesionId, [], 0, mesaId: mesaId);
    for (var i = 0; i < 5; i++) {
      final corr = await ventas.siguienteCorrelativo();
      await ventas.registrarVenta(corr, 1.0, [], comandaId: comandaId, mesaId: mesaId);
    }
    final pagina1 = await ventas.getVentas(limit: 2);
    expect(pagina1, hasLength(2));
    final pagina2 = await ventas.getVentas(limit: 2, beforeId: pagina1.last.id);
    expect(pagina2, hasLength(2));
    expect(pagina2.first.id, lessThan(pagina1.last.id));
    expect(
      {...pagina1.map((v) => v.id), ...pagina2.map((v) => v.id)},
      hasLength(4),
    );
  });

  test('ultima venta vigente y correlativo de ventas anuladas', () async {
    final (mesaId, sesionId) = await setupBasico('5');
    final comandaId = await ventas.guardarComanda(sesionId, [], 0, mesaId: mesaId);
    final corr1 = await ventas.siguienteCorrelativo();
    final v1 = await ventas.registrarVenta(corr1, 1.0, [], comandaId: comandaId, mesaId: mesaId);
    final corr2 = await ventas.siguienteCorrelativo();
    final v2 = await ventas.registrarVenta(corr2, 1.0, [], comandaId: comandaId, mesaId: mesaId);

    expect((await ventas.getUltimaVentaVigente())!.id, v2);
    expect(await ventas.getVentasCorrelativos([v1]), {v1: corr1});
    expect(await ventas.getVentaAnuladaPorComanda(comandaId), null);

    await ventas.anularVenta(v1, anuladaPor: 'Cajero', motivo: 'test');
    expect((await ventas.getVentaAnuladaPorComanda(comandaId))!.id, v1);
    expect((await ventas.getUltimaVentaVigente())!.id, v2);
  });
}
