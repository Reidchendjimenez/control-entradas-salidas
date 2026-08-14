#!/usr/bin/env python3
"""Servidor de desarrollo con logs en la terminal.

Sive build/web y recibe los print() de Flutter web (LogBridge)
imprimiéndolos en la consola, igual que en un script de Python.

Uso:
    python3 tool/server.py [puerto]
"""
import http.server
import os
import sys
from datetime import datetime

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WEB_DIR = os.path.join(ROOT, "build", "web")
PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8123


class WebServer(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)

    def do_POST(self):
        if self.path != "/log":
            self.send_response(404)
            self.end_headers()
            return

        length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(length).decode("utf-8", "replace")

        for line in body.splitlines():
            ts = datetime.now().strftime("%H:%M:%S")
            print(f"[{ts}] {line}", flush=True)

        self.send_response(204)
        self.end_headers()

    def log_message(self, fmt, *args):
        # Suprime los logs HTTP de cada request para no ensuciar la consola.
        pass


if __name__ == "__main__":
    os.makedirs(WEB_DIR, exist_ok=True)
    server = http.server.ThreadingHTTPServer(("0.0.0.0", PORT), WebServer)
    print(f"Serving app at http://0.0.0.0:{PORT} (Ctrl+C to stop)")
    print("Logs de la app aparecen abajo.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nDeteniendo servidor.")