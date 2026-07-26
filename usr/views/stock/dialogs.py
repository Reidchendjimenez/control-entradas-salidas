import flet as ft
from usr.theme import get_colors

tipo_labels = {
    'entrada': ('Entrada', ft.Colors.GREEN_400),
    'salida': ('Salida', ft.Colors.RED_400),
    'ajuste': ('Ajuste', ft.Colors.ORANGE_400),
    'tr_entrada': ('Tr. Entrada', ft.Colors.BLUE_400),
    'tr_salida': ('Tr. Salida', ft.Colors.PURPLE_400),
    'validacion': ('Validación', ft.Colors.TEAL_400),
}

def build_movimiento_card(m, colors, producto=None):
    tipo_info = tipo_labels.get(getattr(m, 'tipo', None) or m.get('tipo', ''), ('?', ft.Colors.GREY_400))
    tipo = tipo_info[0]
    color = tipo_info[1]

    if isinstance(m, dict):
        cant_anterior = m.get('cantidad_anterior', 0)
        cant = m.get('cantidad', 0)
        cant_nueva = m.get('cantidad_nueva', 0)
        fecha_raw = m.get('fecha_movimiento', '')
        fecha = (fecha_raw[:10] + ' ' + fecha_raw[11:16]) if len(fecha_raw) >= 16 else (fecha_raw or '')[:16]
        obs = (m.get('observaciones') or '').strip()
        usuario = m.get('registrado_por') or '?'
        alm = m.get('almacen') or ''
    else:
        cant_anterior = getattr(m, 'cantidad_anterior', 0) or 0
        cant = getattr(m, 'cantidad', 0) or 0
        cant_nueva = getattr(m, 'cantidad_nueva', 0) or 0
        fecha = (m.fecha_movimiento.strftime('%d/%m/%Y %H:%M') if m.fecha_movimiento else '')
        obs = (m.observaciones or '').strip()
        usuario = m.registrado_por or '?'
        alm = m.almacen or ''

    info_parts = [usuario]
    if alm:
        info_parts.append(alm)
    info_line = ' · '.join(info_parts)

    sign_color = colors.get('success', ft.Colors.GREEN_400) if cant >= 0 else ft.Colors.RED_400
    sign = '+' if cant >= 0 else ''

    rows_in_card = [
        ft.Row([
            ft.Text(fecha, size=10, color=colors['text_secondary']),
            ft.Container(
                content=ft.Text(tipo, size=9, color='white', weight='bold'),
                bgcolor=color, padding=ft.padding.only(4, 1, 4, 1), border_radius=3,
            ),
        ], spacing=6),
        ft.Row([
            ft.Text(info_line, size=10, color=colors['text_secondary']),
        ], spacing=6),
    ]

    if obs:
        rows_in_card.append(
            ft.Text(obs, size=9, color=colors['text_primary'], max_lines=1, overflow=ft.TextOverflow.ELLIPSIS),
        )

    rows_in_card.append(
        ft.Container(
            content=ft.Row([
                ft.Text(f"{cant_anterior:.1f}", size=11, color=colors['text_secondary'], text_align=ft.TextAlign.CENTER, expand=True),
                ft.Text("→", size=10, color=colors['text_secondary']),
                ft.Text(f"{sign}{cant:.1f}", size=12, weight='bold', color=sign_color, text_align=ft.TextAlign.CENTER, expand=True),
                ft.Text("→", size=10, color=colors['text_secondary']),
                ft.Text(f"{cant_nueva:.1f}", size=12, weight='bold', color=colors['text_primary'], text_align=ft.TextAlign.CENTER, expand=True),
            ], spacing=2, alignment=ft.MainAxisAlignment.CENTER),
            bgcolor=colors['bg'], padding=ft.padding.only(4, 3, 4, 3), border_radius=5,
        ),
    )

    return ft.Container(
        content=ft.Column(rows_in_card, spacing=3),
        padding=8, border_radius=7,
        bgcolor=colors['card'],
        border=ft.border.all(1, colors['border']),
    )


def build_producto_historial_dialog(producto, movimientos):
    colors = get_colors(None)

    mov_list = ft.Column(spacing=8, scroll=ft.ScrollMode.AUTO)
    for m in movimientos:
        mov_list.controls.append(build_movimiento_card(m, colors, producto))

    return ft.AlertDialog(
        title=ft.Text(f"Historial: {producto.nombre}"),
        content=ft.Container(content=mov_list, height=400),
        actions=[ft.TextButton("Cerrar", on_click=lambda e: None)],
    )


def build_existencias_dialog(producto, existencias, on_ajustar, on_close):
    colors = get_colors(None)
    es_pesable = getattr(producto, 'es_pesable', False)

    def _fmt(cant, unidad):
        if es_pesable:
            return f"{cant:.2f} {unidad}"
        return f"{cant:.0f} {unidad}"

    rows = []
    if existencias:
        for e in existencias:
            alm = e.almacen
            cant = e.cantidad or 0
            unidad = e.unidad or (producto.unidad_medida if producto else 'unidad')
            rows.append(
                ft.Container(
                    content=ft.Row([
                        ft.Column([
                            ft.Text(alm.capitalize(), weight="bold", size=15, color=colors['text_primary']),
                            ft.Text(f"Stock actual: {_fmt(cant, unidad)}", size=12, color=colors['text_secondary']),
                        ], spacing=2, expand=True),
                        ft.ElevatedButton(
                            "Ajustar", icon=ft.Icons.EDIT,
                            on_click=lambda _, a=alm, c=cant, u=unidad: on_ajustar(a, c, u),
                            style=ft.ButtonStyle(padding=ft.padding.symmetric(horizontal=12, vertical=8)),
                        )
                    ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                    bgcolor=colors['card'],
                    padding=12,
                    border_radius=10,
                    margin=ft.margin.only(bottom=8),
                    border=ft.border.all(1, colors['border']),
                )
            )
    else:
        rows.append(ft.Container(
            content=ft.Text("Este producto no tiene existencias registradas.", color=colors['text_secondary']),
            padding=10,
        ))

    unidad_prod = producto.unidad_medida if producto else 'unidad'
    stock_min = producto.stock_minimo if producto else 0

    contenido = ft.Column([
        ft.Container(
            content=ft.Text(
                f"Unidad: {unidad_prod}   •   Stock mínimo: {stock_min:.0f}",
                size=12, color=colors['text_secondary']
            ),
            padding=ft.padding.only(bottom=8),
        ),
        ft.ListView(controls=rows, height=360, spacing=0, padding=0, expand=False),
    ], tight=True, width=460)

    return ft.AlertDialog(
        title=ft.Text(f"Existencias: {producto.nombre}", size=18, weight="bold", color=colors['text_primary']),
        content=contenido,
        actions=[ft.TextButton("Cerrar", on_click=on_close)],
        actions_alignment="end",
    )


def build_ajuste_dialog(producto, almacen, cantidad_actual, unidad, on_confirm, on_cancel):
    colors = get_colors(None)
    es_pesable = getattr(producto, 'es_pesable', False)

    nueva_input = ft.TextField(
        label="Nuevo conteo físico",
        value=f"{cantidad_actual:.2f}" if es_pesable else f"{cantidad_actual:.0f}",
        keyboard_type=ft.KeyboardType.NUMBER,
        autofocus=True, border_radius=10, text_size=18,
        border_color=colors['input_border'],
        width=220,
        suffix_text=unidad,
    )
    motivo_input = ft.TextField(
        label="Motivo (opcional)",
        multiline=True, min_lines=1, max_lines=3,
        border_radius=10, border_color=colors['input_border'],
        width=440,
    )

    def _confirmar(e):
        try:
            val = float(nueva_input.value.replace(",", "").replace(" ", ""))
            if val < 0:
                raise ValueError()
        except (ValueError, AttributeError):
            nueva_input.error_text = "Número válido ≥ 0"
            nueva_input.update()
            return
        on_confirm(val, motivo_input.value or "")

    stock_actual_txt = f"{cantidad_actual:.2f} {unidad}" if es_pesable else f"{cantidad_actual:.0f} {unidad}"

    return ft.AlertDialog(
        title=ft.Text(f"Ajustar: {almacen.capitalize()}", size=18, weight="bold", color=colors['text_primary']),
        content=ft.Column([
            ft.Text(f"Stock actual: {stock_actual_txt}", size=13, color=colors['text_secondary']),
            ft.Divider(height=8, color="transparent"),
            nueva_input,
            ft.Container(height=8),
            motivo_input,
        ], tight=True, width=440),
        actions=[
            ft.TextButton("Cancelar", on_click=on_cancel),
            ft.ElevatedButton("Confirmar ajuste", on_click=_confirmar, bgcolor=colors['accent'], color="white"),
        ],
        actions_alignment="space-between",
    )
