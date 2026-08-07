"""Tab Recetas: lista de recetas con cards + FAB para crear/editar."""
import flet as ft

from usr.database.local_replica import LocalReplica
from usr.views.producciones import data
from usr.views.producciones.dialogs import receta_dialog, delete_receta_dialog
from usr.views.producciones.helpers import colors as _colors


def build_recetas_tab(page, recetas, productos, on_change):
    """Construye el contenido del tab Recetas.

    recetas, productos: listas (se actualizan vía on_change).
    on_change: callback() para recargar datos en el orquestador.
    """
    colors = _colors(page)

    recetas_list = ft.Column(spacing=8, scroll=ft.ScrollMode.ALWAYS, expand=True)
    add_btn = ft.FloatingActionButton(
        icon=ft.Icons.ADD,
        text="Nueva Receta",
        bgcolor=colors['accent'],
        on_click=lambda _: receta_dialog(page, productos, on_saved=on_change),
    )

    def _on_edit(receta):
        receta_dialog(page, productos, receta=receta, on_saved=on_change)

    def _on_delete(receta):
        delete_receta_dialog(page, receta, on_confirmed=on_change)

    def render():
        cards = []
        for receta in recetas:
            tipo_text = "Simple" if receta.get('tipo') == 'simple' else "Compuesta"
            tipo_color = '#4CAF50' if receta.get('tipo') == 'simple' else '#2196F3'
            componentes = data.load_componentes(receta['id'])
            ing_count = sum(1 for c in componentes if c.get('tipo_componente') == 'INGREDIENTE')
            res_count = sum(1 for c in componentes if c.get('tipo_componente') == 'RESULTADO')

            card = ft.Container(
                content=ft.Column([
                    ft.Row([
                        ft.Container(
                            content=ft.Text(tipo_text, size=11, color=ft.Colors.WHITE, weight=ft.FontWeight.BOLD),
                            padding=ft.padding.only(left=8, right=8, top=3, bottom=3),
                            bgcolor=tipo_color,
                            border_radius=4,
                        ),
                        ft.Container(expand=True),
                        ft.IconButton(
                            icon=ft.Icons.EDIT_OUTLINED,
                            icon_size=18,
                            tooltip="Editar",
                            on_click=lambda _, r=receta: _on_edit(r),
                        ),
                        ft.IconButton(
                            icon=ft.Icons.DELETE_OUTLINED,
                            icon_size=18,
                            icon_color='#F44336',
                            tooltip="Eliminar",
                            on_click=lambda _, r=receta: _on_delete(r),
                        ),
                    ]),
                    ft.Text(receta.get('nombre', ''), size=16, weight=ft.FontWeight.BOLD, color=colors['text_primary']),
                    ft.Row([
                        ft.Text(f"{len(componentes)} componentes", size=12, color=colors['text_secondary']),
                        ft.Container(width=15),
                        ft.Text(f"Cant: {receta.get('cantidad_producida', 1)}", size=12, color=colors['text_secondary']),
                    ], spacing=0),
                ], spacing=5),
                padding=ft.padding.all(15),
                bgcolor=colors['card'],
                border_radius=10,
                border=ft.border.all(1, colors['border']),
                ink=True,
                on_click=lambda _, r=receta: _on_edit(r),
            )
            cards.append(card)

        if not cards:
            cards.append(
                ft.Container(
                    content=ft.Column([
                        ft.Icon(ft.Icons.DESCRIPTION_OUTLINED, size=48, color=colors['text_hint']),
                        ft.Text("No hay recetas aún", size=16, color=colors['text_hint']),
                        ft.Text("Presiona el botón + para crear una", size=13, color=colors['text_hint']),
                    ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=10),
                    padding=ft.padding.all(40),
                )
            )

        recetas_list.controls = cards
        if page:
            page.update()

    render()

    return ft.Stack([
        ft.Container(content=recetas_list, expand=True, padding=ft.padding.all(20)),
        ft.Container(content=ft.Row([ft.Container(expand=True), add_btn]), bottom=20, right=20),
    ])


def render_recetas(page, recetas, productos, recetas_list, on_change):
    """Re-renderiza una lista existente (útil tras refresh)."""
    colors = _colors(page)
    cards = []
    for receta in recetas:
        tipo_text = "Simple" if receta.get('tipo') == 'simple' else "Compuesta"
        tipo_color = '#4CAF50' if receta.get('tipo') == 'simple' else '#2196F3'
        componentes = data.load_componentes(receta['id'])
        card = ft.Container(
            content=ft.Column([
                ft.Row([
                    ft.Container(
                        content=ft.Text(tipo_text, size=11, color=ft.Colors.WHITE, weight=ft.FontWeight.BOLD),
                        padding=ft.padding.only(left=8, right=8, top=3, bottom=3),
                        bgcolor=tipo_color,
                        border_radius=4,
                    ),
                    ft.Container(expand=True),
                    ft.IconButton(
                        icon=ft.Icons.EDIT_OUTLINED,
                        icon_size=18,
                        tooltip="Editar",
                        on_click=lambda _, r=receta: receta_dialog(page, productos, receta=r, on_saved=on_change),
                    ),
                    ft.IconButton(
                        icon=ft.Icons.DELETE_OUTLINED,
                        icon_size=18,
                        icon_color='#F44336',
                        tooltip="Eliminar",
                        on_click=lambda _, r=receta: delete_receta_dialog(page, r, on_confirmed=on_change),
                    ),
                ]),
                ft.Text(receta.get('nombre', ''), size=16, weight=ft.FontWeight.BOLD, color=colors['text_primary']),
                ft.Row([
                    ft.Text(f"{len(componentes)} componentes", size=12, color=colors['text_secondary']),
                    ft.Container(width=15),
                    ft.Text(f"Cant: {receta.get('cantidad_producida', 1)}", size=12, color=colors['text_secondary']),
                ], spacing=0),
            ], spacing=5),
            padding=ft.padding.all(15),
            bgcolor=colors['card'],
            border_radius=10,
            border=ft.border.all(1, colors['border']),
            ink=True,
            on_click=lambda _, r=receta: receta_dialog(page, productos, receta=r, on_saved=on_change),
        )
        cards.append(card)

    if not cards:
        cards.append(
            ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.DESCRIPTION_OUTLINED, size=48, color=colors['text_hint']),
                    ft.Text("No hay recetas aún", size=16, color=colors['text_hint']),
                    ft.Text("Presiona el botón + para crear una", size=13, color=colors['text_hint']),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=10),
                padding=ft.padding.all(40),
            )
        )

    recetas_list.controls = cards
    if page:
        page.update()
