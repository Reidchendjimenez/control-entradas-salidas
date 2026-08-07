import datetime
from usr.theme import get_theme, get_colors


def colors(page):
    return get_colors(page)


def theme(page):
    return get_theme(page)


def fmt_fecha(iso_str, max_len=19):
    """Recorta ISO 'YYYY-MM-DDTHH:MM:SS...' a 'YYYY-MM-DD HH:MM'."""
    if not iso_str:
        return ''
    s = str(iso_str)
    if len(s) >= 16:
        return s[:10] + ' ' + s[11:16]
    return s[:max_len]


def fmt_cantidad(cant):
    try:
        return f"{float(cant or 0):.1f}"
    except (TypeError, ValueError):
        return "0.0"


def now_iso():
    return datetime.datetime.now().isoformat()


def usuario_actual(page):
    if not page:
        return "Sistema"
    try:
        return page.session.get("username") or "Sistema"
    except Exception:
        return "Sistema"
