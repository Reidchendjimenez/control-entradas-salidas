"""
Constantes de colores para el tema de la aplicación
"""
import flet as ft


def get_colors(page):
    """Helper para obtener colores según el tema de la página"""
    if page and hasattr(page, 'theme_mode'):
        return get_theme(page.theme_mode == ft.ThemeMode.DARK)
    return get_theme(True)


def get_theme(is_dark: bool):
    """Retorna diccionario de colores según el tema.

    Tema basado en: primario = negro, secundario = morado.
    La variante oscura usa negro como base (bg/header/nav/drawer) con
    superficies en gris-morado y el morado como color de acción/acento.
    La variante clara usa negro como identidad fuerte (texto/header/buttons)
    con el morado como acento.
    """
    if is_dark:
        return {
            'bg': '#000000',
            'surface': '#0D0D14',
            'card': '#15151F',
            'card_hover': '#1E1E2A',
            'text_primary': '#FFFFFF',
            'text_secondary': '#C4B5E0',
            'text_hint': '#8B8798',
            'border': '#2A2A3A',
            'accent': '#BB86FC',
            'accent_dark': '#985EFF',
            'nav_bg': '#050508',
            'input_bg': '#15151F',
            'input_border': '#35354A',
            'input_text': '#FFFFFF',
            'input_hint': '#8B8798',
            'primary': '#000000',
            'surface_variant': '#1E1E2A',
            'success': '#4CAF50',
            'warning': '#FF9800',
            'error': '#F44336',
            'info': '#2196F3',
            'white': '#FFFFFF',
            'black': '#000000',
            'header_bg': '#000000',
            'header_title': '#FFFFFF',
            'header_subtitle': '#C4B5E0',
            'header_icon': '#BB86FC',
            'drawer_bg': '#050508',
            'drawer_active_bg': '#3D2B66',
            'drawer_active_fg': '#FFFFFF',
            'drawer_inactive_fg': '#C4C4CF',
            'drawer_on_surface': '#E8E8F0',
            'more_surface': '#15151F',
            'blue_50': '#2E2E48',
            'green_50': '#1B3B1B',
            'orange_50': '#4A3D2D',
            'red_50': '#3D1B1B',
        }
    else:
        return {
            'bg': '#FFFFFF',
            'surface': '#F6F4FA',
            'card': '#FFFFFF',
            'card_hover': '#EDE9F5',
            'text_primary': '#000000',
            'text_secondary': '#4F4A5A',
            'text_hint': '#85808F',
            'border': '#D8D2E4',
            'accent': '#6200EE',
            'accent_dark': '#3700B3',
            'nav_bg': '#ECE6F7',
            'input_bg': '#FFFFFF',
            'input_border': '#CBC4DA',
            'input_text': '#000000',
            'input_hint': '#85808F',
            'primary': '#000000',
            'surface_variant': '#E7E0EC',
            'success': '#388E3C',
            'warning': '#F57C00',
            'error': '#D32F2F',
            'info': '#1976D2',
            'white': '#FFFFFF',
            'black': '#000000',
            'header_bg': '#000000',
            'header_title': '#FFFFFF',
            'header_subtitle': '#C4B5E0',
            'header_icon': '#BB86FC',
            'drawer_bg': '#FFFFFF',
            'drawer_active_bg': '#EDE3FF',
            'drawer_active_fg': '#2B0A50',
            'drawer_inactive_fg': '#49454F',
            'drawer_on_surface': '#1A1A1C',
            'more_surface': '#FFFFFF',
            'blue_50': '#CDE8FD',
            'green_50': '#E8F5E9',
            'orange_50': '#FFF3E0',
            'red_50': '#FBE9E7',
        }


def apply_theme_to_container(container, is_dark: bool):
    """Aplica el tema a un Container"""
    colors = get_theme(is_dark)
    container.bgcolor = colors['card']

def apply_theme_to_textfield(tf, is_dark: bool):
    """Aplica el tema a un TextField"""
    colors = get_theme(is_dark)
    tf.border_color = colors['input_border']
    tf.focused_border_color = colors['accent']
    tf.cursor_color = colors['accent']
    tf.text_color = colors['input_text']
    tf.hint_color = colors['input_hint']

def apply_theme_to_button(btn, is_dark: bool):
    """Aplica el tema a un ElevatedButton"""
    colors = get_theme(is_dark)
    btn.bgcolor = colors['accent']
    btn.color = colors['white']
