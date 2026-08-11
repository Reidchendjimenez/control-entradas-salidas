"""Tab Historial: lista de producciones con su estado (completado/cancelada)."""
import flet as ft

from usr.views.producciones import data
from usr.views.producciones.helpers import colors as _colors, fmt_fecha


def build_historial_tab(page):
    """Construye el contenido del tab Historial."""
    colors = _colors(page)
    historial_list = ft.Column(spacing=8, scroll=ft.ScrollMode.ALWAYS, expand=True)

    def render():
        cards = []
        producciones = data.load_producciones()
        for produccion in producciones:
            detalles = data.load_detalle(produccion['id'])
            entradas = [d for d in detalles if d.get('tipo') == 'entrada']
            salidas = [d for d in detalles if d.get('tipo') == 'salida']

            estado = produccion.get('estado', 'completado')
            if estado == 'cancelada':
                estado_color = '#F44336'
                estado_icon = ft.Icons.CANCEL_OUTLINED
            elif estado == 'pendiente':
                estado_color = '#FF9800'
                estado_icon = ft.Icons.PENDING_ACTIONS
            else:
                estado_color = '#4CAF50'
                estado_icon = ft.Icons.CHECK_CIRCLE_OUTLINE

            card = ft.Container(
                content=ft.Column([
                    ft.Row([
                        ft.Icon(estado_icon, color=estado_color, size=20),
                        ft.Text(produccion.get('receta_nombre', '?'), size=16, weight=ft.FontWeight.BOLD, color=colors['text_primary']),
                        ft.Container(expand=True),
                        ft.Container(
                            content=ft.Text(estado.upper(), size=10, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                            padding=ft.Padding.symmetric(horizontal=8, vertical=2),
                            bgcolor=estado_color,
                            border_radius=4,
                        ),
                        ft.Container(width=8),
                        ft.Text(f"x{produccion.get('cantidad', 1)}", size=14, color=colors['accent'], weight=ft.FontWeight.BOLD),
                    ]),
                    ft.Text(fmt_fecha(produccion.get('fecha_produccion', '')), size=12, color=colors['text_secondary']),
                    ft.Text(f"Por: {produccion.get('usuario', 'Sistema')}", size=12, color=colors['text_secondary']),
                    *([ft.Text(f"Cocineros: {produccion.get('cocineros')}", size=12, color=colors['text_secondary'])]
                      if produccion.get('cocineros') else []),
                    ft.Row([
                        ft.Container(
                            content=ft.Column([
                                ft.Text(f"Salidas: {len(salidas)}", size=12, color='#FF9800'),
                                *[ft.Text(
                                    f"  - {d.get('producto_nombre', '?')} x{d['cantidad']} {d.get('unidad', '')}".rstrip(),
                                    size=11, color=colors['text_secondary'],
                                ) for d in salidas[:3]],
                            ], spacing=2),
                            expand=True,
                        ),
                        ft.Container(
                            content=ft.Column([
                                ft.Text(f"Entradas: {len(entradas)}", size=12, color='#4CAF50'),
                                *[ft.Text(
                                    f"  + {d.get('producto_nombre', '?')} x{d['cantidad']} {d.get('unidad', '')}".rstrip(),
                                    size=11, color=colors['text_secondary'],
                                ) for d in entradas[:3]],
                            ], spacing=2),
                            expand=True,
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
                        ft.Icon(ft.Icons.HISTORY_OUTLINED, size=48, color=colors['text_hint']),
                        ft.Text("No hay producciones registradas", size=16, color=colors['text_hint']),
                    ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=10),
                    padding=ft.Padding.all(40),
                )
            )

        historial_list.controls = cards
        if page:
            page.update()

    render()

    return ft.Container(content=historial_list, expand=True, padding=ft.Padding.all(20))
