import flet as ft

tipo_labels = {
    'entrada': ('Entrada', ft.Colors.GREEN_400),
    'salida': ('Salida', ft.Colors.RED_400),
    'ajuste': ('Ajuste', ft.Colors.ORANGE_400),
    'tr_entrada': ('Tr. Entrada', ft.Colors.BLUE_400),
    'tr_salida': ('Tr. Salida', ft.Colors.PURPLE_400),
    'validacion': ('Validación', ft.Colors.TEAL_400),
    'venta': ('Venta', ft.Colors.GREEN_400),
    'devolucion': ('Devolución', ft.Colors.TEAL_400),
    'entrada_produccion': ('Ent. Producción', ft.Colors.GREEN_400),
    'salida_produccion': ('Sal. Producción', ft.Colors.RED_400),
}

def _fmt_cantidad(cant):
    try:
        return f"{float(cant or 0):.1f}"
    except (TypeError, ValueError):
        return "0.0"

def build_movimiento_card(m, colors, producto=None, page=None):
    if isinstance(m, dict):
        tipo = m.get('tipo', '')
        cant_anterior = _fmt_cantidad(m.get('cantidad_anterior', 0))
        cant = float(m.get('cantidad', 0) or 0)
        cant_nueva = _fmt_cantidad(m.get('cantidad_nueva', 0))
        peso_total = float(m.get('peso_total', 0) or 0)
        es_pesable = bool(m.get('es_pesable'))
        fecha_raw = m.get('fecha_movimiento', '')
        fecha = (fecha_raw[:10] + ' ' + fecha_raw[11:16]) if len(fecha_raw) >= 16 else (fecha_raw or '')[:16]
        obs = (m.get('observaciones') or '').strip()
        usuario = m.get('registrado_por') or '?'
        alm = m.get('almacen') or ''
        factura_id = m.get('factura_id')
        numero_doc = m.get('numero_factura') or ''
        tipo_doc = m.get('tipo_documento') or ''
    else:
        tipo = getattr(m, 'tipo', '') or ''
        cant_anterior = _fmt_cantidad(getattr(m, 'cantidad_anterior', 0))
        cant = float(getattr(m, 'cantidad', 0) or 0)
        cant_nueva = _fmt_cantidad(getattr(m, 'cantidad_nueva', 0))
        peso_total = float(getattr(m, 'peso_total', 0) or 0)
        prod_obj = getattr(m, 'producto', None)
        es_pesable = bool(getattr(prod_obj, 'es_pesable', False)) if prod_obj else bool(getattr(producto, 'es_pesable', False))
        fecha = (m.fecha_movimiento.strftime('%d/%m/%Y %H:%M') if getattr(m, 'fecha_movimiento', None) else '')
        obs = (getattr(m, 'observaciones', None) or '').strip()
        usuario = getattr(m, 'registrado_por', None) or '?'
        alm = getattr(m, 'almacen', None) or ''
        factura = getattr(m, 'factura', None)
        factura_id = getattr(m, 'factura_id', None)
        numero_doc = getattr(factura, 'numero_factura', '') if factura else ''
        tipo_doc = getattr(factura, 'tipo_documento', '') if factura else ''

    tipo_info = tipo_labels.get(tipo, (tipo or '?', ft.Colors.GREY_400))
    label, color = tipo_info

    # Para productos pesables, la variación real de stock es el peso (kg),
    # no el número de unidades. El medio de la tarjeta debe mostrar el peso.
    # (En 'ajuste' pesable, cantidad ya es la diferencia en kg y peso_total
    # guarda el nuevo total, así que se conserva cantidad).
    if es_pesable and tipo != 'ajuste' and peso_total > 0:
        cant_medio = peso_total
        unidad_medio = 'kg'
    else:
        cant_medio = cant
        unidad_medio = ''

    if tipo in ('salida', 'salida_produccion', 'venta'):
        cant_medio = -abs(cant_medio)

    sign_color = colors.get('success', ft.Colors.GREEN_400) if cant_medio >= 0 else ft.Colors.RED_400
    sign = '+' if cant_medio >= 0 else ''

    info_parts = [usuario]
    if alm:
        info_parts.append(alm)
    info_line = ' · '.join(info_parts)

    rows_in_card = [
        ft.Row([
            ft.Text(fecha, size=10, color=colors['text_secondary']),
            ft.Container(
                content=ft.Text(label, size=9, color='white', weight='bold'),
                bgcolor=color, padding=ft.Padding.only(left=4, top=1, right=4, bottom=1), border_radius=3,
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

    if factura_id and numero_doc:
        doc_label = tipo_doc or 'Documento'
        if numero_doc:
            doc_text = ft.Text(
                f"{doc_label}: {numero_doc}", size=10, weight='bold',
                color=colors['accent'], max_lines=1, overflow=ft.TextOverflow.ELLIPSIS, expand=True,
            )
            doc_row = [doc_text]
            if page is not None:
                copy_icon = ft.IconButton(
                    icon=ft.Icons.CONTENT_COPY, icon_size=14, icon_color=colors['accent'],
                    tooltip="Copiar documento",
                    on_click=lambda _, n=numero_doc: _copiar_documento(page, n),
                )
                doc_row.append(copy_icon)
            rows_in_card.append(
                ft.Row(doc_row, spacing=4, alignment=ft.MainAxisAlignment.START),
            )

    rows_in_card.append(
        ft.Container(
            content=ft.Row([
                ft.Text(cant_anterior, size=11, color=colors['text_secondary'], text_align=ft.TextAlign.CENTER, expand=True),
                ft.Text("→", size=10, color=colors['text_secondary']),
                ft.Text(f"{sign}{cant_medio:.1f} {unidad_medio}".strip(), size=12, weight='bold', color=sign_color, text_align=ft.TextAlign.CENTER, expand=True),
                ft.Text("→", size=10, color=colors['text_secondary']),
                ft.Text(cant_nueva, size=12, weight='bold', color=colors['text_primary'], text_align=ft.TextAlign.CENTER, expand=True),
            ], spacing=2, alignment=ft.MainAxisAlignment.CENTER),
            bgcolor=colors['bg'], padding=ft.Padding.only(left=4, top=3, right=4, bottom=3), border_radius=5,
        ),
    )

    return ft.Container(
        content=ft.Column(rows_in_card, spacing=3),
        padding=8, border_radius=7,
        bgcolor=colors['card'],
        border=ft.Border.all(1, colors['border']),
    )

def _es_movil(page):
    if page is None:
        return False
    width = getattr(page, 'width', None)
    return bool(width) and width < 600

TODOS_ALMACENES = '__todos__'

def _build_almacen_option(nombre, icono, colors, on_click, destacado=False):
    return ft.Container(
        content=ft.Row([
            ft.Container(
                content=ft.Icon(icono, size=18, color=colors['accent'] if destacado else colors['text_primary']),
                bgcolor=ft.Colors.with_opacity(0.12, colors['accent']) if destacado else ft.Colors.with_opacity(0.08, colors['text_primary']),
                padding=8, border_radius=10,
            ),
            ft.Text(
                nombre, size=14, weight='bold' if destacado else 'w500',
                color=colors['accent'] if destacado else colors['text_primary'],
                expand=True, max_lines=1, overflow=ft.TextOverflow.ELLIPSIS,
            ),
            ft.Icon(ft.Icons.CHEVRON_RIGHT, size=18, color=colors['text_hint']),
        ], spacing=10, vertical_alignment=ft.CrossAxisAlignment.CENTER),
        padding=ft.Padding.symmetric(horizontal=12, vertical=10),
        bgcolor=colors['surface'],
        border_radius=10,
        border=ft.Border.all(1, colors['accent'] if destacado else colors['border']),
        on_click=on_click,
        ink=True,
    )

async def preguntar_almacen(page, colors, nombre, almacenes, incluir_todos=True):
    """Pregunta al usuario qué almacén filtrar. Retorna el almacén seleccionado,
    TODOS_ALMACENES si elige 'Todos los almacenes', o None si cancela."""
    import asyncio
    ev = asyncio.Event()
    result = [None]

    def on_click(alm):
        result[0] = alm
        dlg.open = False
        page.update()
        ev.set()

    options = []
    if incluir_todos:
        options.append(_build_almacen_option(
            "Todos los almacenes", ft.Icons.ALL_INBOX, colors,
            lambda _: on_click(TODOS_ALMACENES), destacado=True,
        ))
    options += [_build_almacen_option(
        a, ft.Icons.WAREHOUSE, colors, lambda e, a=a: on_click(a)
    ) for a in almacenes]

    page_width = getattr(page, 'width', None) or 0
    dialog_width = min(400, max(300, page_width - 48)) if page_width else 400

    dlg = ft.AlertDialog(
        title=ft.Text(f"Filtrar historial", size=16, weight='bold', color=colors['text_primary']),
        content=ft.Container(
            content=ft.Column([
                ft.Text(
                    f"Producto: {nombre}", size=13, color=colors['text_secondary'],
                    max_lines=1, overflow=ft.TextOverflow.ELLIPSIS,
                ),
                ft.Container(height=6),
                ft.Divider(height=1, color=colors['border']),
                ft.Container(height=10),
                ft.Column(options, spacing=8, tight=True),
            ], spacing=0, tight=True),
            width=dialog_width,
        ),
        actions=[ft.TextButton("Cancelar", on_click=lambda _: on_click(None))],
        actions_alignment=ft.MainAxisAlignment.END,
    )
    page.overlay.append(dlg)
    dlg.open = True
    page.update()

    await ev.wait()
    return result[0]

def _copiar_documento(page, numero_doc):
    try:
        page.set_clipboard(numero_doc)
        try:
            from usr.notifications import show_success
            show_success(f"Documento copiado: {numero_doc}")
        except Exception:
            pass
    except Exception as ex:
        print(f"[MOVIMIENTOS] Error copiando documento: {ex}")

def build_historial_dialog(titulo, movimientos, colors, on_close=None, page=None, height=400):
    mov_list = ft.Column(spacing=8, scroll=ft.ScrollMode.AUTO)
    for m in movimientos:
        mov_list.controls.append(build_movimiento_card(m, colors, page=page))

    is_mobile = _es_movil(page)
    content_width = None if is_mobile else 480
    content_height = height
    if is_mobile:
        page_height = getattr(page, 'height', None)
        content_height = int(page_height * 0.6) if page_height else height

    return ft.AlertDialog(
        title=ft.Text(titulo, size=15, weight='bold'),
        content=ft.Container(content=mov_list, height=content_height, width=content_width),
        actions=[ft.TextButton("Cerrar", on_click=on_close)],
        actions_alignment=ft.MainAxisAlignment.END,
    )
