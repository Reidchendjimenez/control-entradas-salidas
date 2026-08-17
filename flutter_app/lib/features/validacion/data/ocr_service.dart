import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Servicio OCR compartido por el diálogo de validación y el pre-cargado de
/// temporales. Porta la lógica de `_extractOcrSpace` + `parseFacturaText` que
/// vivía en `validacion_dialog.dart`.
class OcrService {
  static const _apiKey = 'K86411242588957';

  /// Extrae el texto de una imagen vía OCR.space y lo parsea a campos de
  /// factura. Devuelve `null` si no se pudo extraer texto.
  static Future<Map<String, String>?> extractFactura(Uint8List bytes) async {
    try {
      final base64Image = 'data:image/png;base64,${base64Encode(bytes)}';
      final response = await http.post(
        Uri.parse('https://api.ocr.space/parse/image'),
        headers: {'apikey': _apiKey},
        body: {
          'base64Image': base64Image,
          'language': 'spa',
          'isOverlayRequired': 'false',
          'detectOrientation': 'true',
          'scale': 'true',
          'OCREngine': '2',
        },
      );
      if (response.statusCode != 200 || response.body.isEmpty) return null;
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['IsErroredOnProcessing'] == true) return null;
      final results = data['ParsedResults'] as List?;
      if (results == null || results.isEmpty) return null;
      final fullText = results.map((r) => r['ParsedText'] as String? ?? '').join('\n');
      if (fullText.trim().isEmpty) return null;
      return parseFacturaText(fullText.trim());
    } catch (_) {
      return null;
    }
  }

  static Map<String, String> parseFacturaText(String text) {
    String proveedor = '';
    String rif = '';
    String nroFactura = '';
    String fechaStr = '';
    String tipoDoc = 'Factura';

    final lines = text.split('\n');
    String provSection = text;
    for (final line in lines) {
      if (RegExp(r'\b(Proveedor|Emitido por|Vendido por|Nombre o Razón Social)\b', caseSensitive: false).hasMatch(line)) {
        provSection = line.replaceAll(RegExp(r'^[^:]*:\s*'), '');
        break;
      }
    }

    final provRegExpCA = RegExp(r'([A-Z][A-Z0-9\s,]*C\.?\s*A\.?)', caseSensitive: false);
    final provMatch = provRegExpCA.firstMatch(provSection) ?? provRegExpCA.firstMatch(text);
    if (provMatch != null) {
      final candidate = provMatch.group(1)?.trim() ?? '';
      if (!candidate.toUpperCase().contains('LA POSADA DE DANIEL')) {
        proveedor = candidate;
      }
    }

    final rifRegex = RegExp(r'(?:R\.?I\.?F\.?[-/ ]*C\.?I\.?[-/ ]*|C\.?I\.?[-/ ]*R\.?I\.?[-/ ]*|R\.?I\.?F\.?|C\.?I\.?|Cod\s*Prov\.?)\s*[:.]?\s*([JGV E])[\s-]*(\d{8,12})', caseSensitive: false);
    final rifMatch = rifRegex.firstMatch(text);
    if (rifMatch != null) {
      rif = '${rifMatch.group(1)}${rifMatch.group(2)}'.toUpperCase();
    } else {
      final allRifs = RegExp(r'\b([JGV E])[\s-]*(\d{8,12})\b', caseSensitive: false).allMatches(text);
      for (final m in allRifs) {
        final cand = '${m.group(1)}${m.group(2)}'.toUpperCase();
        if (cand != 'J316636151') {
          rif = cand;
          break;
        }
      }
    }

    final nroRegex = RegExp(r'(?:FACTURA|NOTA\s*DE\s*ENTREGA|ENTRADA\s*DE\s*INVENTARIO|ENTRADA|DOC|NRO|NUM)\s*#?\s*[:.]?\s*(\d{4,10})', caseSensitive: false);
    final nroMatch = nroRegex.firstMatch(text);
    if (nroMatch != null) {
      nroFactura = nroMatch.group(1) ?? '';
      final matchText = nroMatch.group(0)?.toUpperCase() ?? '';
      if (matchText.contains('NOTA')) {
        tipoDoc = 'Nota de Entrega';
      } else if (matchText.contains('ENTRADA')) {
        tipoDoc = 'Entrada';
      } else if (matchText.contains('FACTURA')) {
        tipoDoc = 'Factura';
      }
    } else {
      for (final line in lines) {
        final l = line.trim();
        if (RegExp(r'^\d{6,10}$').hasMatch(l)) {
          nroFactura = l;
          break;
        }
      }
    }

    final fechaRegex = RegExp(r'Fecha\s*:\s*(\d{1,2})\s*[/.\-]\s*(\d{1,2})\s*[/.\-]\s*(\d{2,4})', caseSensitive: false);
    final fechaMatch = fechaRegex.firstMatch(text);
    if (fechaMatch != null) {
      final dia = int.tryParse(fechaMatch.group(1) ?? '1') ?? 1;
      final mes = int.tryParse(fechaMatch.group(2) ?? '1') ?? 1;
      var anio = fechaMatch.group(3) ?? '2024';
      if (anio.length == 2) anio = '20$anio';
      fechaStr = '${dia.toString().padLeft(2, '0')}/${mes.toString().padLeft(2, '0')}/$anio';
    }

    return {
      'proveedor': proveedor,
      'rif': rif,
      'nro_factura': nroFactura,
      'fecha': fechaStr,
      'tipo_documento': tipoDoc,
    };
  }
}
