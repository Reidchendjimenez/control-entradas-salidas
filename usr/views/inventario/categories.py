import flet as ft
from usr.theme import get_colors
from usr.views.inventario.helpers import generar_color, get_safe_colors


def get_card_bg(page):
    return get_colors(page)['card']


def create_categoria_card(categoria, colors, on_click_cb):
    nombre = getattr(categoria, 'nombre', '') or 'SIN NOMBRE'
    cat_color = getattr(categoria, 'color', None) or colors['accent']
    inicial = nombre[0].upper() if nombre else "?"

    content_col = ft.Column(
        [
            ft.Container(
                content=ft.Text(inicial, size=22, weight="bold", color=colors['white']),
                width=45, height=45, bgcolor=cat_color,
                border_radius=25, alignment=ft.Alignment.CENTER,
            ),
            ft.Text(nombre.upper(), size=10, weight="bold", color=colors['white'], text_align="center"),
        ],
        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
        spacing=5,
    )

    def _on_hover(e):
        if e.data:
            e.control.scale = 1.05
            e.control.shadow = ft.BoxShadow(
                blur_radius=15,
                color=ft.Colors.with_opacity(0.2, cat_color),
                offset=ft.Offset(0, 0),
            )
        else:
            e.control.scale = 1.0
            e.control.shadow = ft.BoxShadow(
                blur_radius=0,
                color=ft.Colors.with_opacity(0.1, cat_color),
                offset=ft.Offset(0, 0),
            )
        e.control.update()

    card = ft.Container(
        content=content_col,
        bgcolor=colors['card'],
        width=110, height=130,
        border_radius=12, padding=10,
        border=ft.Border(bottom=ft.BorderSide(4, cat_color)),
        scale=1.0,
        animate_scale=ft.Animation(300, ft.AnimationCurve.EASE_OUT),
        on_hover=_on_hover,
        ink=True,
    )
    card.on_click = lambda e: on_click_cb(categoria, card)
    return card


def create_categoria_card_from_dict(cat_dict, colors, on_click_cb):
    nombre = cat_dict.get("nombre", "")
    cat_color = cat_dict.get("color") or generar_color(nombre)
    inicial = nombre[0].upper() if nombre else "?"
    card_bg = colors['card']
    text_color = colors['text_primary']

    def _on_hover(e):
        if e.data:
            e.control.scale = 1.05
            e.control.rotate = 0.02
            e.control.shadow = ft.BoxShadow(
                blur_radius=15,
                color=ft.Colors.with_opacity(0.2, cat_color),
                offset=ft.Offset(0, 0),
            )
        else:
            e.control.scale = 1.0
            e.control.rotate = 0
            e.control.shadow = ft.BoxShadow(
                blur_radius=0,
                color=ft.Colors.with_opacity(0.1, cat_color),
                offset=ft.Offset(0, 0),
            )
        e.control.update()

    card = ft.Container(
        bgcolor=card_bg,
        border_radius=12,
        padding=12,
        width=110, height=130,
        alignment=ft.Alignment.CENTER,
        border=ft.Border(bottom=ft.BorderSide(3, cat_color)),
        scale=1.0,
        rotate=0,
        shadow=ft.BoxShadow(
            blur_radius=0,
            color=ft.Colors.with_opacity(0.2, cat_color),
            offset=ft.Offset(0, 3),
        ),
        animate_scale=ft.Animation(300, ft.AnimationCurve.EASE_OUT),
        animate_rotation=ft.Animation(300, ft.AnimationCurve.EASE_OUT),
        content=ft.Column(
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            alignment=ft.MainAxisAlignment.CENTER,
            controls=[
                ft.Container(
                    content=ft.Text(inicial, size=20, weight="bold", color=colors['white']),
                    alignment=ft.Alignment.CENTER,
                    width=40, height=40,
                    bgcolor=cat_color,
                    shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(
                        blur_radius=8,
                        color=ft.Colors.with_opacity(0.3, cat_color),
                        offset=ft.Offset(0, 3)
                    )
                ),
                ft.Container(height=8),
                ft.Text(
                    str(nombre).upper(),
                    size=10, weight="bold",
                    color=text_color,
                    text_align=ft.TextAlign.CENTER,
                    max_lines=2,
                    overflow=ft.TextOverflow.ELLIPSIS
                ),
            ]
        )
    )
    card.on_hover = _on_hover
    card.on_click = lambda e: on_click_cb(cat_dict, card)
    return card
