import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

/// Lee una imagen del portapapeles en web usando la Clipboard API del
/// navegador. Requiere gesto de usuario reciente (click del botón).
Future<Uint8List?> readClipboardImage() async {
  try {
    final jsClipboard = js.context['navigator']?.callMethod('clipboard');
    if (jsClipboard == null) return null;

    final promise = jsClipboard.callMethod('read', []);
    if (promise == null) return null;

    final items = await _awaitJsPromise(promise);
    if (items == null) return null;

    final length = (items['length'] as num?)?.toInt() ?? 0;
    for (int i = 0; i < length; i++) {
      final item = (items as js.JsObject)[i];
      if (item == null) continue;

      for (final mime in ['image/png', 'image/jpeg', 'image/bmp', 'image/webp']) {
        try {
          final blobPromise = (item as js.JsObject).callMethod('getType', [mime]);
          if (blobPromise == null) continue;
          final blob = await _awaitJsPromise(blobPromise);
          if (blob != null) {
            return await _blobToBytes(blob);
          }
        } catch (_) {}
      }
    }
    return null;
  } catch (_) {
    return null;
  }
}

Future<dynamic> _awaitJsPromise(dynamic jsPromise) {
  final completer = Completer<dynamic>();
  (jsPromise as js.JsObject).callMethod('then', [
    (dynamic resolve) {
      if (!completer.isCompleted) completer.complete(resolve);
    },
    (dynamic _) {
      if (!completer.isCompleted) completer.complete(null);
    },
  ]);
  return completer.future;
}

Future<Uint8List?> _blobToBytes(dynamic blob) async {
  final reader = html.FileReader();
  final completer = Completer<Uint8List?>();
  reader.onLoadEnd.listen((_) {
    final result = reader.result as Uint8List?;
    if (!completer.isCompleted) completer.complete(result);
  });
  reader.onError.listen((_) {
    if (!completer.isCompleted) completer.complete(null);
  });
  reader.readAsArrayBuffer(blob);
  return completer.future;
}
