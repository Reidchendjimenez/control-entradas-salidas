import 'dart:convert';

import 'package:http/http.dart' as http;

/// Consulta la tasa oficial USD -> Bs del BCV (port de `usr/pos/tasa_cambio.py`),
/// priorizando la tasa **más actualizada del sitio oficial** (que en fin de
/// semana ya muestra la del lunes, a diferencia de bcv.today).
///
/// En Flutter web el navegador bloquea por CORS el fetch directo a
/// www.bcv.org.ve, así que la fuente primaria es el proxy local `/proxy-bcv`
/// que sirve `tool/server.py` (misma app, sin CORS). Respaldos: el sitio
/// oficial directo (entornos no-web o si el CORS cambia) y bcv.today.
/// El valor guardado vive en `pos_settings` vía `setTasaCambio`.
class TasaBcvService {
  TasaBcvService({http.Client? client}) : _client = client ?? http.Client();

  static const _bcvSiteUrl = 'https://www.bcv.org.ve/';
  static const _bcvFallbackUrl = 'https://bcv.today/api/v1/rate.json';
  static const _userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/124.0 Safari/537.36';

  final http.Client _client;
  String? _ultimaFuente;
  String? _ultimoError;

  /// Fuente usada en la última consulta exitosa (diagnóstico).
  String? get ultimaFuente => _ultimaFuente;

  /// Error de la última consulta fallida (diagnóstico).
  String? get ultimoError => _ultimoError;

  /// Consulta la tasa oficial del BCV (Bs por USD). Lanza excepción si falla.
  Future<double> obtenerTasaBcv({int timeout = 15}) async {
    try {
      final tasa = await _obtenerTasaProxyOficial(timeout);
      _ultimaFuente = 'sitio oficial BCV (proxy)';
      _ultimoError = null;
      return tasa;
    } catch (e) {
      _ultimoError = 'proxy BCV falló: $e';
    }
    try {
      final tasa = await _obtenerTasaSitioOficial(timeout);
      _ultimaFuente = 'sitio oficial BCV';
      return tasa;
    } catch (e) {
      _ultimoError = '$_ultimoError; sitio oficial: $e';
    }
    try {
      final tasa = await _obtenerTasaBcvToday(timeout);
      _ultimaFuente = 'bcv.today';
      return tasa;
    } catch (e) {
      throw StateError(
          'Tasa de cambio no disponible: $_ultimoError; bcv.today: $e');
    }
  }

  /// Fuente primaria (web): `/proxy-bcv` en el mismo servidor de la app.
  Future<double> _obtenerTasaProxyOficial(int timeout) async {
    final res = await _client
        .get(
          Uri.base.resolve('/proxy-bcv'),
          headers: {'Accept': 'text/html'},
        )
        .timeout(Duration(seconds: timeout));
    if (res.statusCode != 200) {
      throw StateError('HTTP ${res.statusCode} del proxy BCV');
    }
    return _parseDolar(res.body);
  }

  /// Scrape directo del sitio oficial (sin CORS en entornos no-web).
  Future<double> _obtenerTasaSitioOficial(int timeout) async {
    final res = await _client
        .get(
          Uri.parse(_bcvSiteUrl),
          headers: {
            'User-Agent': _userAgent,
            'Accept': '*/*',
            'Cache-Control': 'no-cache',
          },
        )
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw StateError('HTTP ${res.statusCode} del sitio del BCV');
    }
    return _parseDolar(res.body);
  }

  /// Parse del bloque `#dolar` del HTML del BCV (proxy o sitio directo).
  double _parseDolar(String html) {
    final idx = html.indexOf('id="dolar"');
    if (idx < 0) {
      throw StateError('No se encontró el bloque USD en el sitio del BCV');
    }
    final fin = idx + 4000 < html.length ? idx + 4000 : html.length;
    final seg = html.substring(idx, fin);
    final m = RegExp(r'strong-tb">\s*([0-9.,]+)\s*<').firstMatch(seg);
    if (m == null) {
      throw StateError(
          'No se encontró el valor de la tasa USD en el sitio del BCV');
    }
    final valor =
        double.tryParse(m.group(1)!.replaceAll('.', '').replaceAll(',', '.'));
    if (valor == null || valor <= 0) {
      throw StateError('Tasa USD inválida en el sitio del BCV: ${m.group(1)}');
    }
    return valor;
  }

  /// Último respaldo: API de bcv.today (CORS abierto, tasa del último día hábil).
  Future<double> _obtenerTasaBcvToday(int timeout) async {
    final res = await _client.get(
      Uri.parse(_bcvFallbackUrl),
      headers: {'User-Agent': _userAgent, 'Accept': '*/*'},
    ).timeout(Duration(seconds: timeout));
    if (res.statusCode != 200) {
      throw StateError('HTTP ${res.statusCode} de bcv.today');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final tasa = data['USD'];
    if (tasa is! num) {
      throw StateError('La API del BCV no devolvió la tasa USD');
    }
    return tasa.toDouble();
  }
}