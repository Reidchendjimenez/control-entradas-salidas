#!/usr/bin/env python3
"""Servidor de desarrollo con logs en la terminal.

Sirve el build de Flutter web elegido y recibe los print() de Flutter web
(LogBridge) imprimiéndolos en la consola, igual que en un script de Python.

Uso:
    python3 tool/server.py [puerto] [web_dir_rel]

web_dir_rel por defecto "build/web" (app de inventario). Para el POS:
    python3 tool/server.py 8501 build/pos
"""
import http.server
import json
import os
import ssl
import sys
import time
import urllib.request
from datetime import datetime

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
WEB_REL = sys.argv[2] if len(sys.argv) > 2 else os.path.join("build", "web")
WEB_DIR = os.path.join(ROOT, WEB_REL)
PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8123

BCV_SITE_URL = "https://www.bcv.org.ve/"
BCV_USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/124.0 Safari/537.36"
)


def fetch_bcv_html(timeout=15):
    """Descarga el HTML del sitio oficial del BCV (misma petición que el scrape
    del POS). Reintenta sin verificar TLS si no hay certificados CA locales."""
    req = urllib.request.Request(
        BCV_SITE_URL,
        headers={
            "User-Agent": BCV_USER_AGENT,
            "Accept": "*/*",
            "Cache-Control": "no-cache",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=timeout) as res:
            return res.read().decode("utf-8", "replace")
    except Exception:
        ctx = ssl._create_unverified_context()
        with urllib.request.urlopen(req, timeout=timeout, context=ctx) as res:
            return res.read().decode("utf-8", "replace")


# Caché del sitio oficial: el BCV a veces responde lento o corta conexiones,
# así que se guarda el último HTML exitoso. Si el refresco falla se devuelve
# el dato viejo (stale) en vez de fallar el request y dejar la UI colgada.
_BCV_CACHE = {"ts": 0.0, "html": None}
_BCV_CACHE_TTL = 30 * 60  # 30 minutos


def get_bcv_html():
    now = time.time()
    if _BCV_CACHE["html"] is not None and now - _BCV_CACHE["ts"] < _BCV_CACHE_TTL:
        return _BCV_CACHE["html"]
    try:
        html = fetch_bcv_html()
        _BCV_CACHE["ts"] = now
        _BCV_CACHE["html"] = html
        return html
    except Exception:
        # BCV caído/lento: sirve la última copia si existe.
        if _BCV_CACHE["html"] is not None:
            return _BCV_CACHE["html"]
        raise


class WebServer(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)

    def end_headers(self):
        # Evita que el navegador cachee el bundle (SW del dev loop stale).
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def do_GET(self):
        # Proxy del sitio oficial del BCV: sortea el CORS que bloquea el fetch
        # desde Flutter web (el navegador no puede pedir www.bcv.org.ve).
        if self.path.split("?")[0] == "/proxy-bcv":
            try:
                html = get_bcv_html()
            except Exception as e:  # noqa: BLE001
                self.send_response(502)
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"error": str(e)}).encode())
                return
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header("Cache-Control", "no-store")
            self.end_headers()
            self.wfile.write(html.encode("utf-8"))
            return
        super().do_GET()

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