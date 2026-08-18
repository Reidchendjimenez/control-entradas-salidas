/// Implementación nativa de [printer_service.dart].
///
/// - Windows: usa `windows_printer` para descubrir impresoras y enviar los
///   bytes ESC/POS en modo RAW (indispensable para impresoras térmicas).
/// - Otras plataformas nativas (Android/iOS/Linux/macOS): `puedeImprimirNativo`
///   es false y no hay envío raw (se usa la vista previa).
library;

import 'dart:io';
import 'dart:typed_data';

import 'package:windows_printer/windows_printer.dart';

/// Solo Windows soporta envío RAW de ESC/POS con este servicio.
bool get puedeImprimirNativo => !Platform.isAndroid && Platform.isWindows;

/// Lista las impresoras del sistema (solo Windows).
Future<List<String>> listarImpresoras() async {
  if (!puedeImprimirNativo) return const [];
  try {
    return await WindowsPrinter.getAvailablePrinters();
  } catch (_) {
    return const [];
  }
}

/// Envía los bytes ESC/POS a la impresora en modo RAW (Windows).
Future<void> imprimirTicketNativo(String impresora, List<int> bytes) async {
  if (!puedeImprimirNativo) return;
  final nombre = impresora.isEmpty ? null : impresora;
  await WindowsPrinter.printRawData(
    printerName: nombre,
    data: Uint8List.fromList(bytes),
    useRawDatatype: true,
  );
}

/// No-op en nativo: la impresión real es por ESC/POS raw, no por el navegador.
void imprimirPorWeb(String texto) {}