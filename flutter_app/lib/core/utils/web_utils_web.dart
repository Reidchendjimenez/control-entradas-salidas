library;

import 'dart:html' as html;
import 'dart:typed_data';

typedef PasteCancel = void Function();

PasteCancel? setupPasteImageListener(void Function(Uint8List bytes) onImage) {
  try {
    final sub = html.document.onPaste.listen((html.ClipboardEvent event) {
      final items = event.clipboardData?.items;
      if (items == null) return;
      final count = items.length as int;
      for (int i = 0; i < count; i++) {
        final item = items[i];
        if (item.type?.startsWith('image/') == true) {
          final blob = item.getAsFile();
          if (blob != null) {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(blob);
            reader.onLoadEnd.listen((_) {
              final bytes = reader.result as Uint8List?;
              if (bytes != null) onImage(bytes);
            });
            event.preventDefault();
            break;
          }
        }
      }
    });
    return sub.cancel;
  } catch (_) {
    return null;
  }
}

void openInNewTab(String url) {
  html.window.open(url, '_blank');
}

void reloadApp() {
  html.window.location.reload();
}

void printHtml(String text) {
  final doc = html.document;
  doc.querySelector('#ticket-print')?.remove();
  final contenedor = html.DivElement()
    ..id = 'ticket-print'
    ..style.cssText = 'display:none;';
  final pre = html.PreElement()..text = text;
  contenedor.append(pre);
  doc.body?.append(contenedor);
  final style = html.StyleElement()
    ..text = '''
#ticket-print { display:block; font-family:'Courier New',monospace; font-size:14px; white-space:pre; }
@media print {
  body > * { display: none !important; }
  #ticket-print { display: block !important; }
}''';
  doc.head?.append(style);
  html.window.print();
  contenedor.remove();
  style.remove();
}