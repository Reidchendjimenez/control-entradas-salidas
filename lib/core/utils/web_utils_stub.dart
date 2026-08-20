library;

import 'dart:typed_data';

/// Stub nativo de [web_utils.dart]. No hace nada: el pegado de imágenes,
/// abrir URLs y recargar solo aplican a la web.

typedef PasteCancel = void Function();

PasteCancel? setupPasteImageListener(void Function(Uint8List bytes) onImage) =>
    null;

void openInNewTab(String url) {}

void reloadApp() {}

void printHtml(String text) {}