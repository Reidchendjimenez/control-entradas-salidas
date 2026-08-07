"""Tab Recetas: lista de recetas con cards + FAB para crear/editar."""
import flet as ft

from usr.views.producciones import data
from usr.views.producciones.dialogs import delete_receta_dialog
from usr.views.producciones.helpers import colors as _colors


def _build_card(receta, colors, on_edit, on_delete):
    tipo_text = "Simple" if receta.get('tipo') == 'simple' else "Compuesta"
    tipo_color = '#4CAF50' if receta.get('tipo') == 'simple' else '#2196F3'
    componentes = data.load_componentes(receta['id'])
    ing_count = sum(1 for c in componentes if c.get('tipo_componente') == 'INGREDIENTE')
    res_count = sum(1 for c in componentes if c.get('tipo_componente') == 'RESULTADO')
    var_count = sum(1 for c in componentes if c.get('peso_variable'))

    badges = ft.Row([
        ft.Container(content=ft.Text(tipo_text, size=11, color=ft.Colors.WHITE, weight=ft.FontWeight.BOLD),
                     padding=ft.padding.symmetric(horizontal=8, vertical=3),
                     bgcolor=tipo_color, border_radius=4),
        ft.Container(content=ft.Text(f"{len(componentes)} comp.", size=11, color=colors['text_secondary']),
                     padding=ft.padding.symmetric(horizontal=8, vertical=3),
                     bgcolor=colors['card_hover'], border_radius=4),
        ft.Container(content=ft.Text(f"Cant: {receta.get('cantidad_producida', 1)}", size=11, color=colors['text_secondary']),
                     padding=ft.padding.symmetric(horizontal=8, vertical=3),
                     bgcolor=colors['card_hover'], border_radius=4),
    ] + ([ft.Container(content=ft.Text(f"⚖️ {var_count} var.", size=11, color='#FF9800', weight=ft.FontWeight.BOLD),
                       padding=ft.padding.symmetric(horizontal=8, vertical=3),
                       bgcolor=colors['card_hover'], border_radius=4)] if var_count else []),
        spacing=6,
    )

    return ft.Container(
        content=ft.Column([
            ft.Row([
                ft.Column([
                    ft.Text(receta.get('nombre', ''), size=16, weight=ft.FontWeight.BOLD, color=colors['text_primary']),
                    badges,
                ], spacing=6, expand=True),
                ft.IconButton(
                    icon=ft.Icons.EDIT_OUTLINED,
                    icon_size=18,
                    tooltip="Editar",
                    on_click=lambda _, r=receta: on_edit(r),
                ),
                ft.IconButton(
                    icon=ft.Icons.DELETE_OUTLINED,
                    icon_size=18,
                    icon_color='#F44336',
                    tooltip="Eliminar",
                    on_click=lambda _, r=receta: on_delete(r),
                ),
            ], vertical_alignment=ft.CrossAxisAlignment.START),
        ], spacing=5),
        padding=ft.padding.all(15),
        bgcolor=colors['card'],
        border_radius=10,
        border=ft.border.all(1, colors['border']),
        ink=True,
        on_click=lambda _, r=receta: on_edit(r),
    )


def render_recetas(page, recetas, productos, recetas_list, on_change, on_edit):
    """Re-renderiza una lista existente (útil tras refresh).

    on_edit(receta): callback para abrir el editor.
    on_change(): callback tras eliminar/guardar (refresca la lista).
    """
    colors = _colors(page)
    cards = []
    for receta in recetas:
        cards.append(_build_card(
            receta, colors,
            on_edit=lambda r, _oe=on_edit: _oe(r),
            on_delete=lambda r, _oc=on_change: delete_receta_dialog(page, r, on_confirmed=_oc),
        ))

    if not cards:
        cards.append(
            ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.DESCRIPTION_OUTLINED, size=48, color=colors['text_hint']),
                    ft.Text("No hay recetas aún", size=16, color=colors['text_hint']),
                    ft.Text("Presiona '+ Nueva Receta' para crear una", size=13, color=colors['text_hint']),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=10),
                padding=ft.padding.all(40),
            )
        )

    recetas_list.controls = cards
    if page:
        page.update()
