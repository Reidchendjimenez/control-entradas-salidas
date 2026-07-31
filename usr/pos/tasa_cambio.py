"""Tasa de cambio USD -> Bs (bolivares).

La tasa oficial la publica el Banco Central de Venezuela (BCV) los dias
habiles ~16:30 hora de Caracas. Se obtiene de la API publica de bcv.today
(sin clave, sirve la tasa tal cual la publica el BCV) y se guarda en
pos_settings para no consultarla a cada momento. El boton "Actualizar tasa"
de la vista de comanda verifica si la tasa cambio y la actualiza.

Nota: Yadio (/exrates/USD) devuelve la tasa PARALELA (dolar cripto USDT/VES),
que NO coincide con la oficial del BCV, por eso aqui se usa bcv.today.
"""
import json
import urllib.request

from usr.database.local_replica import LocalReplica

BCV_URL = "https://bcv.today/api/v1/rate.json"


def obtener_tasa_bcv(timeout: int = 12) -> float:
    """Consulta la tasa oficial del BCV (Bs por USD). Lanza excepcion si falla."""
    req = urllib.request.Request(BCV_URL, headers={'User-Agent': 'Mozilla/5.0'})
    with urllib.request.urlopen(req, timeout=timeout) as r:
        data = json.loads(r.read().decode('utf-8'))
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
