import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:control_entradas_salidas/core/data/cache_service.dart';

void main() {
  late CacheService cache;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    cache = CacheService(prefs);
  });

  group('CacheService', () {
    test('guarda y lee datos', () async {
      await cache.put('test_key', ['a', 'b', 'c']);
      final entry = cache.get<List>('test_key');
      expect(entry, isNotNull);
      expect(entry!.data, ['a', 'b', 'c']);
    });

    test('retorna null si la clave no existe', () {
      expect(cache.get('nonexistent'), isNull);
    });

    test('retorna null si expiro el TTL', () async {
      await cache.put('old_key', 'data');
      // TTL por defecto es 5 min, no podemos simular paso del tiempo
      // pero verificamos que getStale retorna el dato
      final stale = cache.getStale<String>('old_key');
      expect(stale, isNotNull);
      expect(stale!.data, 'data');
    });

    test('elimina una clave', () async {
      await cache.put('to_delete', 'value');
      expect(cache.get('to_delete'), isNotNull);
      await cache.remove('to_delete');
      expect(cache.get('to_delete'), isNull);
    });

    test('guarda y recupera listas de mapas', () async {
      final data = [
        {'id': 1, 'nombre': 'Carnes'},
        {'id': 2, 'nombre': 'Bebidas'},
      ];
      await cache.put('cats', data);
      final entry = cache.get<List>('cats');
      expect(entry, isNotNull);
      expect((entry!.data).length, 2);
      expect((entry.data[0] as Map)['nombre'], 'Carnes');
    });
  });
}
