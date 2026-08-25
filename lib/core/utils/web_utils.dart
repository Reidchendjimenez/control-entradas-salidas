/// Utilidades web-only con import condicional para evitar que `dart:html`
/// rompa los builds nativos (Windows/Android).
///
/// - `setupPasteImageListener`: registra un listener de pegado (Ctrl+V) que
///   entrega los bytes de la primera imagen del portapapeles. Solo funciona en
///   web; en nativo es no-op.
/// - `openInNewTab(url)`: abre una URL en otra pestaña (web) o en el
///   navegador del sistema (nativo).
/// - `reloadApp()`: recarga la app (web) o no hace nada (nativo).
/// - `printHtml(text)`: imprime texto con el diálogo del navegador (web);
///   en nativo es no-op (la impresión térmica usa ESC/POS por otra vía).
library;

export 'web_utils_stub.dart' if (dart.library.html) 'web_utils_web.dart';