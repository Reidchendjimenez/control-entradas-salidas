from usr.theme import get_colors


def _colors(page):
    return get_colors(page)


def _c(page, color_name):
    colors = _colors(page)
    mapping = {
        'WHITE': colors['white'],
        'GREY_300': colors['text_hint'],
        'GREY_400': colors['text_secondary'],
        'GREY_500': colors['text_secondary'],
        'GREY_600': colors['text_secondary'],
        'GREY_50': colors['bg'],
        'BLUE_GREY_900': colors['text_primary'],
        'BLUE_GREY_800': colors['text_primary'],
        'BLUE_600': colors['accent'],
        'BLUE_700': colors['accent'],
        'GREEN_600': colors['success'],
        'GREEN_700': colors['success'],
        'RED_600': colors['error'],
        'RED_700': colors['error'],
        'ORANGE_600': colors['warning'],
        'ORANGE_700': colors['warning'],
    }
    return mapping.get(color_name, colors['text_primary'])


def get_safe_colors(page):
    if page:
        c = _colors(page)
        if c:
            return c
    return {
        'white': '#FFFFFF', 'bg': '#FFFFFF', 'surface': '#F6F4FA',
        'card': '#FFFFFF', 'card_hover': '#EDE9F5', 'border': '#D8D2E4',
        'accent': '#6200EE', 'accent_dark': '#3700B3',
        'primary': '#000000', 'surface_variant': '#E7E0EC',
        'success': '#388E3C', 'error': '#D32F2F', 'warning': '#F57C00', 'info': '#1976D2',
        'text_primary': '#000000', 'text_secondary': '#4F4A5A',
        'text_hint': '#85808F',
        'input_border': '#CBC4DA',
    }


def trigger_sync(view):
    try:
        from usr.database.sync import get_sync_manager
        sync_mgr = get_sync_manager()
        if sync_mgr and sync_mgr.check_connection():
            import threading
            thread = threading.Thread(target=sync_mgr._process_sync_queue, daemon=True)
            thread.start()
    except Exception as e:
        print(f"[SYNC] Error al activar sync inmediato: {e}")
