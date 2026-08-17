import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:control_entradas_salidas/features/pos/data/tasa_bcv_service.dart';

const _htmlOficial =
    '<html><div id="dolar"><strong class="strong-tb">748,78640000</strong></div></html>';

void main() {
  test('proxy local: fuente primaria parsea el bloque #dolar', () async {
    var llamadas = 0;
    final client = MockClient((req) async {
      llamadas++;
      expect(req.url.path, '/proxy-bcv');
      return http.Response(_htmlOficial, 200);
    });
    final svc = TasaBcvService(client: client);
    final tasa = await svc.obtenerTasaBcv();
    expect(tasa, closeTo(748.7864, 1e-9));
    expect(svc.ultimaFuente, 'sitio oficial BCV (proxy)');
    expect(llamadas, 1);
  });

  test('respaldo 1: sitio oficial directo cuando el proxy falla', () async {
    var llamadas = 0;
    final client = MockClient((req) async {
      llamadas++;
      if (req.url.path == '/proxy-bcv') {
        return http.Response('proxy error', 502);
      }
      expect(req.url.host, 'www.bcv.org.ve');
      return http.Response(_htmlOficial, 200);
    });
    final svc = TasaBcvService(client: client);
    final tasa = await svc.obtenerTasaBcv();
    expect(tasa, closeTo(748.7864, 1e-9));
    expect(svc.ultimaFuente, 'sitio oficial BCV');
    expect(llamadas, 2);
  });

  test('respaldo 2: bcv.today cuando proxy y sitio oficial fallan', () async {
    var llamadas = 0;
    final client = MockClient((req) async {
      llamadas++;
      if (req.url.path == '/proxy-bcv') {
        return http.Response('proxy error', 502);
      }
      if (req.url.host == 'www.bcv.org.ve') {
        return http.Response('server error', 500);
      }
      expect(req.url.host, 'bcv.today');
      return http.Response('{"USD": 830.12}', 200);
    });
    final svc = TasaBcvService(client: client);
    final tasa = await svc.obtenerTasaBcv();
    expect(tasa, closeTo(830.12, 1e-9));
    expect(svc.ultimaFuente, 'bcv.today');
    expect(llamadas, 3);
  });

  test('lanza StateError si las tres fuentes fallan', () async {
    final client = MockClient((req) async => http.Response('error', 500));
    final svc = TasaBcvService(client: client);
    expect(svc.obtenerTasaBcv(), throwsA(isA<StateError>()));
  });
}