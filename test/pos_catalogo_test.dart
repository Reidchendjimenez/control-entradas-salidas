import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:control_entradas_salidas/core/db/schema/app_database.dart';
import 'package:control_entradas_salidas/features/pos/data/pos_comanda_models.dart';
import 'package:control_entradas_salidas/features/pos/data/pos_repository.dart';

/// Fase 6.3 — Comanda: queries del catálogo POS y modelo de items.
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

  group('modelo ComandaItem', () {
    test('round-trip JSON con contornos', () {
      final item = ComandaItem(
        id: 7,
        tipo: 'plato',
        nombre: 'Pabellón',
        precio: 6.5,
        cantidad: 2,
        contornos: const [(id: 1, nombre: 'Arroz'), (id: 2, nombre: 'Tajadas')],
      );
      final json = item.toJson();
      expect(json['contornos'], ['Arroz', 'Tajadas']);
      expect(json['contorno_ids'], [1, 2]);

      final back = ComandaItem.fromJson(json);
      expect(back.id, 7);
      expect(back.nombre, 'Pabellón');
      expect(back.cantidad, 2);
      expect(back.tieneContornos, isTrue);
      expect(back.subtotal, 13.0);
    });

    test('listFromJson tolera null/vacío', () {
      expect(ComandaItem.listFromJson(null), isEmpty);
      expect(ComandaItem.listFromJson(''), isEmpty);
      expect(ComandaItem.listFromJson('no es json'), isEmpty);
    });
  });

  group('catálogo POS', () {
    test('categorias visibles en POS', () async {
      await db.batch((b) {
        b.insert(db.categorias, CategoriasCompanion.insert(
            nombre: 'Carnes',
            color: const Value('#B71C1C'),
            visibleEnPos: const Value(1)));
        b.insert(db.categorias, CategoriasCompanion.insert(
            nombre: 'Uso interno',
            color: const Value('#455A64'),
            visibleEnPos: const Value(0)));
        b.insert(db.categorias, CategoriasCompanion.insert(
            nombre: 'Inactiva',
            color: const Value('#000000'),
            activo: const Value(0)));
      });
      final cats = await repo.getCategoriasPos();
      expect(cats.map((c) => c.nombre), ['Carnes']);
    });

    test('productos de venta por categoría', () async {
      final catId = await db.into(db.categorias).insert(
            CategoriasCompanion.insert(nombre: 'Bebidas'),
          );
      await db.batch((b) {
        b.insert(db.productos, ProductosCompanion.insert(
            nombre: 'Coca 355ml',
            categoriaId: Value(catId),
            tipo: const Value('Productos para la venta'),
            precioVenta: const Value(1.5)));
        b.insert(db.productos, ProductosCompanion.insert(
            nombre: 'Tomate',
            categoriaId: Value(catId),
            tipo: const Value('Insumos')));
        b.insert(db.productos, ProductosCompanion.insert(
            nombre: 'Pepsi 355ml',
            categoriaId: Value(catId),
            tipo: const Value('Productos para la venta'),
            activo: const Value(0)));
      });
      final prods = await repo.getProductosPos(categoriaId: catId);
      expect(prods.map((p) => p.nombre), ['Coca 355ml']);
    });

    test('subcategorías por padre inventario y POS', () async {
      await db.batch((b) {
        b.insert(db.platosCategorias, PlatosCategoriasCompanion.insert(
            nombre: 'Desayunos', categoriaPadreId: const Value(10)));
        b.insert(db.platosCategorias, PlatosCategoriasCompanion.insert(
            nombre: 'Ejecutivos', posCategoriaPadreId: const Value(20)));
        b.insert(db.platosCategorias, PlatosCategoriasCompanion.insert(
            nombre: 'Sueltos', categoriaPadreId: const Value(10)));
      });
      final deInv = await repo.getSubcategorias(categoriaPadreId: 10);
      expect(deInv.map((c) => c.nombre), ['Desayunos', 'Sueltos']);
      final dePos = await repo.getSubcategorias(posCategoriaPadreId: 20);
      expect(dePos.map((c) => c.nombre), ['Ejecutivos']);
    });

    test('platos POS excluyen contornos; contornos activos', () async {
      final catId = await db.into(db.platosCategorias).insert(
            PlatosCategoriasCompanion.insert(nombre: 'Platos'),
          );
      await db.batch((b) {
        b.insert(db.platos, PlatosCompanion.insert(
            nombre: 'Pabellón',
            categoriaId: catId,
            precioVenta: const Value(6.5),
            esContorno: const Value(0),
            llevaContornos: const Value(1)));
        b.insert(db.platos, PlatosCompanion.insert(
            nombre: 'Tajadas',
            categoriaId: catId,
            precioVenta: const Value(1.0),
            esContorno: const Value(1)));
      });
      final platos = await repo.getPlatosPos();
      expect(platos.map((p) => p.nombre), ['Pabellón']);
      final contornos = await repo.getContornosActivos();
      expect(contornos.map((p) => p.nombre), ['Tajadas']);
    });

    test('tasa de cambio en pos_settings', () async {
      expect(await repo.getTasaCambio(), 0);
      await repo.setTasaCambio(93.5, sync: false);
      expect(await repo.getTasaCambio(), 93.5);
      expect(await repo.getTasaCambioFecha(), isNotEmpty);
    });
  });
}
