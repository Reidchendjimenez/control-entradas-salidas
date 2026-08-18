/// Implementación web de [printer_service.dart]: la impresión usa el diálogo
/// del navegador (única vía disponible). No hay impresoras USB detectables en
/// web; el dispositivo configurado se guarda para uso nativo (Windows).
library;

import '../../../core/utils/web_utils.dart' show printHtml;

/// Indica si la plataforma actual puede imprimir por medio nativo (USB/RAW).
bool get puedeImprimirNativo => false;

/// Lista las impresoras disponibles. En web no hay descubrimiento; se retorna
/// lista vacía y el usuario configura el nombre desde Config > Impresora.
Future<List<String>> listarImpresoras() async => const [];

/// Envía bytes ESC/POS a la impresora nombrada. En web no hay envío raw;
/// la impresión real usa el diálogo del navegador vía [imprimirPorWeb].
Future<void> imprimirTicketNativo(String impresora, List<int> bytes) async {}

/// Imprime texto plano con el diálogo del navegador (solo web).
void imprimirPorWeb(String texto) => printHtml(texto);