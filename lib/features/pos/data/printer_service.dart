/// Servicio de impresión de tickets — abstrae la plataforma.
///
/// - Web: imprime con el diálogo del navegador (vista previa 32 col).
/// - Windows: envía los bytes ESC/POS raw a la impresora seleccionada
///   (paquete `windows_printer`).
/// - Otras nativas (Android/iOS): no-op (el usuario solo ve la vista previa).
library;

export 'printer_service_web.dart' if (dart.library.io) 'printer_service_native.dart';