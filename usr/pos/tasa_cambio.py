"""Tasa de cambio USD -> Bs (bolivares) oficial del BCV.

La tasa oficial la publica el Banco Central de Venezuela (BCV) los dias
habiles ~16:30 hora de Caracas, con vigencia para el siguiente dia habil.
Aqui se consulta DIRECTAMENTE el sitio oficial (https://www.bcv.org.ve/)
para obtener la tasa mas reciente publicada, y como respaldo la API publica
de bcv.today (que a veces esta desactualizada). El valor se guarda en
pos_settings para no consultarla a cada momento.

Nota: Yadio (/exrates/USD) devuelve la tasa PARALELA (dolar cripto USDT/VES),
que NO coincide con la oficial del BCV, por eso no se usa.
"""
import json
import re
import ssl
import urllib.error
import urllib.request

from usr.database.local_replica import LocalReplica

BCV_SITE_URL = "https://www.bcv.org.ve/"
BCV_FALLBACK_URL = "https://bcv.today/api/v1/rate.json"
USER_AGENT = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
              "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36")

# Ultima fuente usada y su mensaje, para diagnostico
_ultima_fuente = None
_ultimo_error = None


def _abrir_url(url: str, timeout: int) -> str:
    """Descarga una URL con User-Agent real y reintento sin verificar SSL."""
    headers = {'User-Agent': USER_AGENT, 'Accept': '*/*',
               'Cache-Control': 'no-cache'}
    try:
        req = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.read().decode('utf-8', errors='replace')
    except Exception:
        # Reintentamos ignorando la verificacion SSL (errores de certificado
        # comunes al sitio del BCV, tambien en Windows con proxies).
        ctx = ssl.create_default_context()
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        req2 = urllib.request.Request(url, headers=headers)
        with urllib.request.urlopen(req2, timeout=timeout, context=ctx) as r:
            return r.read().decode('utf-8', errors='replace')


def obtener_tasa_bcv(timeout: int = 15) -> float:
    """Consulta la tasa oficial del BCV (Bs por USD) desde el sitio oficial.

    Lanza excepcion si falla. Como respaldo usa bcv.today.
    """
    global _ultima_fuente, _ultimo_error
    try:
        tasa = _obtener_tasa_sitio_oficial(timeout)
        _ultima_fuente = "sitio oficial BCV"
        _ultimo_error = None
        return tasa
    except Exception as e:
        _ultimo_error = f"Sitio oficial BCV fallo: {e}"
        try:
            tasa = _obtener_tasa_fallback(timeout)
            _ultima_fuente = "bcv.today (respaldo)"
            return tasa
        except Exception as e2:
            raise RuntimeError(f"Tasa de cambio no disponible: {_ultimo_error}; fallback: {e2}")


def get_diagnostico() -> str:
    """Texto de diagnostico: que fuente se uso y con que valor."""
    try:
        tasa = obtener_tasa_bcv()
        return f"Fuente: {_ultima_fuente} | Tasa: {tasa} | {_ultimo_error or 'ok'}"
    except Exception as e:
        return f"Error: {e} | Fuente: {_ultima_fuente}"


def _obtener_tasa_sitio_oficial(timeout: int) -> float:
    """Scrapea la tasa USD del sitio oficial del BCV (www.bcv.org.ve).

    El valor aparece en un bloque con id='dolar' dentro de
    <strong class="strong-tb">748,78640000</strong> (coma decimal espanola).
    """
    html = _abrir_url(BCV_SITE_URL, timeout)
    idx = html.find('id="dolar"')
    if idx < 0:
        raise ValueError("No se encontro el bloque USD en el sitio del BCV")
    seg = html[idx:idx + 4000]
    m = re.search(r'strong-tb">\s*([0-9.,]+)\s*<', seg)
    if not m:
        raise ValueError("No se encontro el valor de la tasa USD en el sitio del BCV")
    valor = m.group(1).replace('.', '').replace(',', '.')
    tasa = float(valor)
    if tasa <= 0:
        raise ValueError(f"Tasa USD invalida en el sitio del BCV: {m.group(1)}")
    return tasa


def _obtener_tasa_fallback(timeout: int) -> float:
    """Respaldo: consulta la tasa USD en la API de bcv.today."""
    html = _abrir_url(BCV_FALLBACK_URL, timeout)
    data = json.loads(html)
    tasa = data.get('USD')
    if tasa is None:
        raise ValueError("La API del BCV no devolvio la tasa USD")
    return float(tasa)


def actualizar_tasa() -> tuple:
    """Consulta la tasa del BCV y la guarda. Si la consulta falla conserva la guardada.

    Retorna (tasa, cambiada, anterior) donde 'cambiada' indica si el valor
    guardado difiere del que se acaba de consultar (o si no habia ninguna)."""
    tasa = obtener_tasa_bcv()
    anterior = LocalReplica.get_tasa_cambio()
    LocalReplica.set_tasa_cambio(tasa)
    cambiada = anterior is None or abs(float(anterior) - tasa) > 0.0001
    return tasa, cambiada, anterior


def get_tasa() -> float:
    """Tasa guardada; 0 si aun no se ha consultado ninguna."""
    tasa = LocalReplica.get_tasa_cambio()
    return float(tasa) if tasa else 0.0


def convertir(usd: float, tasa: float = None) -> float:
    """Convierte un monto en dolares a bolivares usando la tasa indicada
    (por defecto, la guardada)."""
    if tasa is None:
        tasa = get_tasa()
    return float(usd) * tasa


def formatear_bs(monto: float) -> str:
    """Formatea un monto en bolivares estilo venezolano: 1.234,56."""
    try:
        m = float(monto)
    except Exception:
        m = 0.0
    signo = '-' if m < 0 else ''
    m = abs(m)
    entero = int(m)
    decimales = int(round((m - entero) * 100))
    if decimales == 100:
        entero += 1
        decimales = 0
    s = f"{entero:,}".replace(',', '.')
    return f"{signo}{s},{decimales:02d}"


def formatear_tasa(tasa: float = None) -> str:
    """Tasa con 4 decimales, ej: 835,9482 Bs/$."""
    if tasa is None:
        tasa = get_tasa()
    t = float(tasa)
    signo = '-' if t < 0 else ''
    t = abs(t)
    entero = int(t)
    decimales = int(round((t - entero) * 10000))
    if decimales == 10000:
        entero += 1
        decimales = 0
    s = f"{entero:,}".replace(',', '.')
    return f"{signo}{s},{decimales:04d}"
