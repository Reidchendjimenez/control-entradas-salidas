"""Tab En Producción: lista de producciones pendientes con acciones Descargar/Cancelar."""
import flet as ft

from usr.database.local_replica import LocalReplica
from usr.views.producciones import data
from usr.views.producciones.dialogs import descargo_dialog, cancelar_produccion_dialog
from usr.views.producciones.helpers import colors as _colors, fmt_fecha


def build_pendientes_tab(page, on_change):
    """Construye el contenido del tab En Producción.

    on_change: callback() para recargar después de descargar/cancelar.
    """
    colors = _colors(page)
    pendientes_list = ft.Column(spacing=8, scroll=ft.ScrollMode.ALWAYS, expand=True)

    def _get_receta(produccion):
        return LocalReplica.get_recetas(activo=True) and next(
            (r for r in LocalReplica.get_recetas(activo=True) if r['id'] == produccion['receta_id']),
            None,
        )

    def render():
        cards = []
        pendientes = data.load_pendientes()
        for produccion in pendientes:
            receta = _get_receta(produccion)
            if not receta:
                continue
            detalles = data.load_detalle(produccion['id'])
            entradas = [d for d in detalles if d.get('tipo') == 'entrada']

            entradas_txt = "Sin detalles de entrada"
            if entradas:
                entradas_txt = ", ".join(
                    f"{d.get('producto_nombre', '?')}: {d.get('cantidad', 0)} {d.get('unidad', '')}".rstrip()
                    for d in entradas
                )

            card = ft.Container(
                content=ft.Column([
                    ft.Row([
                        ft.Icon(ft.Icons.PENDING_ACTIONS, color='#FF9800', size=22),
                        ft.Column([
                            ft.Text(
                                f"{receta.get('nombre', '?')}",
                                size=16, weight=ft.FontWeight.BOLD,
                                color=colors['text_primary'],
                            ),
                            ft.Text(
                                f"Producción #{produccion['id']} · {fmt_fecha(produccion.get('fecha_produccion', ''))}",
                                size=11, color=colors['text_secondary'],
                            ),
                            ft.Text(
                                f"Por: {produccion.get('usuario', 'Sistema')}",
                                size=11, color=colors['text_secondary'],
                            ),
                        ], expand=True, spacing=2),
                        ft.Container(
                            content=ft.Text(f"x{produccion.get('cantidad', 1)}", size=14, weight=ft.FontWeight.BOLD, color=colors['accent']),
                            padding=ft.Padding.symmetric(horizontal=10, vertical=5),
                            bgcolor=colors['card_hover'],
                            border_radius=6,
                        ),
                    ]),
                    ft.Container(height=5),
                    ft.Text(
                        f"Entradas del lote ({len(entradas)}): {entradas_txt}",
                        size=12, color=colors['text_secondary'],
                    ),
                    ft.Container(height=8),
                    ft.Row([
                        ft.ElevatedButton(
                            "Descargar",
                            icon=ft.Icons.PLAY_ARROW,
                            bgcolor=colors['accent'],
                            color=colors.get('white', ft.Colors.WHITE),
                            on_click=lambda _, p=produccion, r=receta: descargo_dialog(page, p, r, on_completed=on_change),
                        ),
                        ft.Container(width=8),
                        ft.OutlinedButton(
                            "Cancelar",
                            icon=ft.Icons.CANCEL_OUTLINED,
                            on_click=lambda _, p=produccion, r=receta: cancelar_produccion_dialog(page, p, r, on_confirmed=on_change),
                        ),
                    ]),
                ], spacing=5),
                padding=ft.Padding.all(15),
                bgcolor=colors['card'],
                border_radius=10,
                border=ft.Border.all(1, colors['border']),
            )
            cards.append(card)

        if not cards:
            cards.append(
                ft.Container(
                    content=ft.Column([
                        ft.Icon(ft.Icons.CHECK_CIRCLE_OUTLINE, size=48, color=colors['text_hint']),
                        ft.Text("Sin producciones pendientes", size=16, color=colors['text_hint']),
                        ft.Text("Las producciones se crean desde Inventario al hacer una entrada de producción", size=13, color=colors['text_hint'], text_align=ft.TextAlign.CENTER),
                    ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=10),
                    padding=ft.Padding.all(40),
                )
            )

        pendientes_list.controls = cards
        if page:
            page.update()

    render()

    return ft.Container(content=pendientes_list, expand=True, padding=ft.Padding.all(20))
