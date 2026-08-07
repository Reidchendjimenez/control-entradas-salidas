"""Diálogos del módulo Producciones: receta (crear/editar), confirmar eliminar, descargo."""
import flet as ft

from usr.database.local_replica import LocalReplica
from usr.notifications import show_success, show_error, show_warning
from usr.views.producciones import data
from usr.views.producciones.helpers import colors as _colors


def receta_dialog(page, productos, receta=None, on_saved=None):
    """Diálogo para crear/editar una receta.

    productos: lista de dicts con productos activos.
    receta: dict si edición, None si nueva.
    on_saved: callback() al guardar exitosamente.
    """
    colors = _colors(page)
    is_edit = receta is not None

    nombre_field = ft.TextField(
        label="Nombre de la Receta",
        value=receta.get('nombre', '') if receta else '',
        expand=True,
    )

    tipo_seg = ft.SegmentedButton(
        allow_empty_selection=False,
        selected={"compuesta" if (receta and receta.get('tipo') == 'compuesta') or not receta else "simple"},
        segments=[
            ft.Segment(value="simple", label=ft.Text("Simple")),
            ft.Segment(value="compuesta", label=ft.Text("Compuesta")),
        ],
        on_change=lambda e: _on_tipo_change(),
    )

    cant_prod = ft.TextField(
        label="Cantidad Base (por batch)",
        value=str(receta.get('cantidad_producida', 1)) if receta else "1",
        keyboard_type=ft.KeyboardType.NUMBER,
        width=150,
    )

    base_prod_dropdown = ft.Dropdown(
        label="Producto Base (origen)",
        hint_text="Seleccionar...",
        options=[
            ft.dropdown.Option(key=str(p['id']), text=f"{p['nombre']} ({p.get('tipo', 'N/A')})")
            for p in productos if p.get('activo')
        ],
        value=str(receta.get('producto_base_id')) if receta and receta.get('producto_base_id') else None,
        expand=True,
        visible=(receta and receta.get('tipo') == 'simple') if receta else True,
    )

    final_prod_dropdown = ft.Dropdown(
        label="Producto Final (resultado)",
        hint_text="Seleccionar...",
        options=[
            ft.dropdown.Option(key=str(p['id']), text=f"{p['nombre']} ({p.get('tipo', 'N/A')})")
            for p in productos if p.get('activo')
        ],
        value=str(receta.get('producto_final_id')) if receta and receta.get('producto_final_id') else None,
        expand=True,
        visible=bool(receta and receta.get('tipo') == 'compuesta'),
    )

    componentes_list = ft.Column(spacing=8)
    peso_var_global = ft.Checkbox(
        label="Mostrar peso variable en nuevas filas",
        value=False,
    )

    def _add_component_row(tipo_comp, prod_id=None, cantidad=None, unidad="unidad", peso_variable=False):
        prod_dd = ft.Dropdown(
            options=[
                ft.dropdown.Option(key=str(p['id']), text=f"{p['nombre']} ({p.get('tipo', 'N/A')})")
                for p in productos if p.get('activo')
            ],
            value=str(prod_id) if prod_id else None,
            hint_text="Seleccionar...",
            expand=True,
            width=250,
        )
        cant_field = ft.TextField(
            value=str(cantidad) if cantidad is not None else "1",
            keyboard_type=ft.KeyboardType.NUMBER,
            width=80,
        )
        unidad_field = ft.TextField(
            value=unidad,
            width=80,
            hint_text="unidad",
        )
        peso_var_check = ft.Checkbox(
            value=bool(peso_variable),
            tooltip="Peso variable: la cantidad se define al descargar",
        )

        def _remove_row(e):
            componentes_list.controls.remove(row)
            componentes_list.update()

        def _on_peso_var(e):
            cant_field.disabled = peso_var_check.value
            if peso_var_check.value:
                cant_field.value = ""
            cant_field.update()

        peso_var_check.on_change = _on_peso_var
        if peso_variable:
            cant_field.disabled = True
            cant_field.value = ""

        row = ft.Row([
            prod_dd,
            cant_field,
            unidad_field,
            peso_var_check,
            ft.IconButton(icon=ft.Icons.REMOVE_CIRCLE_OUTLINE, icon_color='#F44336', on_click=_remove_row),
        ], spacing=8, vertical_alignment=ft.CrossAxisAlignment.CENTER)

        row._prod_dd = prod_dd
        row._cant_field = cant_field
        row._unidad_field = unidad_field
        row._peso_var_check = peso_var_check

        componentes_list.controls.append(row)
        return row

    tipo_label = ft.Text(
        "Productos resultantes (lo que se obtiene):" if not receta or receta.get('tipo') == 'simple'
        else "Ingredientes (lo que se consume):",
        size=14,
        weight=ft.FontWeight.BOLD,
        color=colors['text_primary'],
    )

    add_comp_btn = ft.TextButton(
        text="+ Agregar producto",
        icon=ft.Icons.ADD,
        on_click=lambda _: _add_component_row(
            'RESULTADO' if ("simple" in tipo_seg.selected) else 'INGREDIENTE'
        ),
    )

    def _on_tipo_change():
        is_simple = "simple" in tipo_seg.selected
        if componentes_list.controls and not is_simple == (receta and receta.get('tipo') != 'compuesta' if receta else True):
            # Advertir si hay componentes antes de cambiar
            pass
        if componentes_list.controls:
            # Solo avisar si la lista no está vacía
            show_warning("Cambiar de tipo vacía la lista de componentes.")
            componentes_list.controls.clear()
            componentes_list.update()

        base_prod_dropdown.visible = is_simple
        final_prod_dropdown.visible = not is_simple
        tipo_label.value = "Productos resultantes (lo que se obtiene):" if is_simple else "Ingredientes (lo que se consume):"
        add_comp_btn.text = "+ Agregar producto" if is_simple else "+ Agregar ingrediente"
        tipo_label.update()
        base_prod_dropdown.update()
        final_prod_dropdown.update()
        add_comp_btn.update()

    if receta:
        componentes = data.load_componentes(receta['id'])
        for comp in componentes:
            _add_component_row(
                comp['tipo_componente'],
                comp['producto_id'],
                comp['cantidad'],
                comp.get('unidad', 'unidad'),
                bool(comp.get('peso_variable')),
            )

    form = ft.Column([
        nombre_field,
        ft.Row([tipo_seg, cant_prod], spacing=15, vertical_alignment=ft.CrossAxisAlignment.END),
        ft.Row([base_prod_dropdown, final_prod_dropdown], spacing=15),
        ft.Divider(height=1, color=colors['border']),
        tipo_label,
        ft.Container(content=componentes_list, padding=ft.padding.only(left=10)),
        ft.Row([add_comp_btn]),
    ], spacing=12, scroll=ft.ScrollMode.ALWAYS, height=500)

    def _save(e):
        nombre = nombre_field.value.strip() if nombre_field.value else ''
        if not nombre:
            nombre_field.error_text = "Requerido"
            nombre_field.update()
            return

        is_simple = "simple" in tipo_seg.selected
        try:
            cantidad = float(cant_prod.value or 1)
        except (ValueError, TypeError):
            cant_prod.error_text = "Número válido"
            cant_prod.update()
            return

        receta_data = {
            'nombre': nombre,
            'tipo': "simple" if is_simple else "compuesta",
            'cantidad_producida': cantidad,
        }

        if is_simple:
            if not base_prod_dropdown.value:
                base_prod_dropdown.error_text = "Selecciona el producto base"
                base_prod_dropdown.update()
                return
            receta_data['producto_base_id'] = int(base_prod_dropdown.value)
            receta_data['producto_final_id'] = None
        else:
            if not final_prod_dropdown.value:
                final_prod_dropdown.error_text = "Selecciona el producto final"
                final_prod_dropdown.update()
                return
            receta_data['producto_final_id'] = int(final_prod_dropdown.value)
            receta_data['producto_base_id'] = None

        if is_edit:
            receta_data['id'] = receta['id']
            receta_data['activo'] = receta.get('activo', True)

        componentes = []
        for row in componentes_list.controls:
            if not hasattr(row, '_prod_dd') or not row._prod_dd.value:
                continue
            peso_var = bool(row._peso_var_check.value)
            componentes.append({
                'producto_id': int(row._prod_dd.value),
                'cantidad': 0.0 if peso_var else float(row._cant_field.value or 1),
                'unidad': row._unidad_field.value.strip() or 'unidad',
                'tipo_componente': 'RESULTADO' if is_simple else 'INGREDIENTE',
                'peso_variable': 1 if peso_var else 0,
            })

        receta_data['_componentes'] = componentes
        try:
            data.guardar_receta(receta_data)
        except Exception as ex:
            show_error(f"Error al guardar receta: {ex}")
            return

        try:
            page.close(dialog)
        except Exception:
            pass
        show_success("Receta guardada correctamente")
        if on_saved:
            on_saved()

    def _cancel(e):
        try:
            page.close(dialog)
        except Exception:
            pass

    dialog = ft.AlertDialog(
        title=ft.Text(f"{'Editar' if is_edit else 'Nueva'} Receta", weight=ft.FontWeight.BOLD),
        content=form,
        actions=[
            ft.TextButton("Cancelar", on_click=_cancel),
            ft.FilledButton("Guardar", on_click=_save),
        ],
        actions_alignment=ft.MainAxisAlignment.END,
    )
    page.open(dialog)
    dialog.update()


def delete_receta_dialog(page, receta, on_confirmed=None):
    colors = _colors(page)

    def _confirm(e):
        try:
            page.close(dialog)
        except Exception:
            pass
        try:
            data.eliminar_receta(receta['id'])
            show_success("Receta eliminada")
        except Exception as ex:
            show_error(f"Error al eliminar: {ex}")
            return
        if on_confirmed:
            on_confirmed()

    def _cancel(e):
        try:
            page.close(dialog)
        except Exception:
            pass

    dialog = ft.AlertDialog(
        title=ft.Text("Eliminar Receta"),
        content=ft.Text(f"¿Eliminar '{receta.get('nombre')}'?"),
        actions=[
            ft.TextButton("Cancelar", on_click=_cancel),
            ft.FilledButton("Eliminar", on_click=_confirm, style=ft.ButtonStyle(bgcolor='#F44336', color=ft.Colors.WHITE)),
        ],
        actions_alignment=ft.MainAxisAlignment.END,
    )
    page.open(dialog)
    dialog.update()


def descargo_dialog(page, produccion, receta, on_completed=None):
    """Diálogo para registrar el descargo de ingredientes de una producción pendiente."""
    from usr.views.producciones.data import planificar_descargo, ejecutar_descargo

    colors = _colors(page)
    items = planificar_descargo(receta, produccion)

    cantidad_fields = []

    def _build_field_row(item):
        unidad_label = 'kg' if item['es_pesable'] else item['unidad']
        sugerida = '' if item['peso_variable'] else f"{item['cantidad_sugerida']:.2f}"

        cant_field = ft.TextField(
            value=sugerida,
            keyboard_type=ft.KeyboardType.NUMBER,
            width=120,
            suffix_text=unidad_label,
            autofocus=item['peso_variable'],
        )
        if item['peso_variable']:
            cant_field.hint_text = "Peso real (kg)"
        else:
            cant_field.disabled = False  # editable también, por si la cantidad real varía
            cant_field.hint_text = "Sugerido"

        row = ft.Container(
            content=ft.Row([
                ft.Column([
                    ft.Text(item['nombre'], weight=ft.FontWeight.BOLD, color=colors['text_primary']),
                    ft.Text(
                        f"Variable · {unidad_label}" if item['peso_variable'] else f"Sugerido · {unidad_label}",
                        size=11, color=colors['text_secondary'],
                    ),
                ], expand=True, spacing=2),
                cant_field,
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            padding=ft.padding.all(10),
            bgcolor=colors['card'],
            border_radius=8,
            border=ft.border.all(1, colors['border']),
        )

        cantidad_fields.append({
            'producto_id': item['producto_id'],
            'es_pesable': item['es_pesable'],
            'almacen': item['almacen'],
            'unidad': unidad_label,
            'field': cant_field,
        })
        return row

    if not items:
        dialog = ft.AlertDialog(
            title=ft.Text("Sin ingredientes"),
            content=ft.Text("Esta receta no tiene ingredientes definidos para descargar."),
            actions=[ft.TextButton("Cerrar", on_click=lambda e: page.close(dialog))],
        )
        page.open(dialog)
        dialog.update()
        return

    rows = [_build_field_row(i) for i in items]

    content = ft.Column([
        ft.Text(
            f"Receta: {receta.get('nombre', '')} · Producción #{produccion['id']}",
            weight=ft.FontWeight.BOLD, color=colors['text_primary'],
        ),
        ft.Text(
            f"Cantidad producida: {produccion.get('cantidad', 1)}",
            size=12, color=colors['text_secondary'],
        ),
        ft.Divider(height=1, color=colors['border']),
        ft.Text(
            "Ingresa el peso/cantidad real usado de cada ingrediente:",
            size=12, color=colors['text_secondary'],
        ),
        *rows,
    ], spacing=10, scroll=ft.ScrollMode.ALWAYS, height=400)

    def _confirmar(e):
        items_cantidades = []
        errores = []
        for entry in cantidad_fields:
            try:
                cantidad = float((entry['field'].value or '').replace(',', '.').strip() or 0)
            except ValueError:
                errores.append(f"Cantidad inválida para producto {entry['producto_id']}")
                continue
            if cantidad <= 0:
                errores.append(f"Cantidad debe ser > 0 para producto {entry['producto_id']}")
                continue
            items_cantidades.append({
                'producto_id': entry['producto_id'],
                'cantidad': cantidad,
                'es_pesable': entry['es_pesable'],
                'almacen': entry['almacen'],
                'unidad': entry['unidad'],
            })
        if errores:
            show_error("\n".join(errores))
            return

        try:
            ok, errs = ejecutar_descargo(page, produccion, receta, items_cantidades)
        except Exception as ex:
            show_error(f"Error al ejecutar descargo: {ex}")
            return
        if not ok:
            show_error("No se pudo completar el descargo:\n" + "\n".join(f"• {e}" for e in errs))
            return

        try:
            page.close(dialog)
        except Exception:
            pass
        show_success(f"Producción #{produccion['id']} completada")
        if on_completed:
            on_completed()

    def _cancel(e):
        try:
            page.close(dialog)
        except Exception:
            pass

    dialog = ft.AlertDialog(
        title=ft.Text("Descargar Producción", weight=ft.FontWeight.BOLD),
        content=content,
        actions=[
            ft.TextButton("Cancelar", on_click=_cancel),
            ft.FilledButton("Confirmar Descargo", on_click=_confirmar),
        ],
        actions_alignment=ft.MainAxisAlignment.END,
    )
    page.open(dialog)
    dialog.update()


def cancelar_produccion_dialog(page, produccion, receta, on_confirmed=None):
    """Confirma cancelación + revierte el stock del producto final."""
    from usr.views.producciones.data import cancelar_produccion

    colors = _colors(page)

    def _confirm(e):
        try:
            page.close(dialog)
        except Exception:
            pass
        try:
            cancelar_produccion(page, produccion, receta)
            show_success(f"Producción #{produccion['id']} cancelada y stock revertido")
        except Exception as ex:
            show_error(f"Error al cancelar: {ex}")
            return
        if on_confirmed:
            on_confirmed()

    def _cancel(e):
        try:
            page.close(dialog)
        except Exception:
            pass

    dialog = ft.AlertDialog(
        title=ft.Text("Cancelar Producción", weight=ft.FontWeight.BOLD),
        content=ft.Text(
            f"¿Cancelar la producción #{produccion['id']} de '{receta.get('nombre', '')}'?\n\n"
            "Se revertirá el stock del producto final (la entrada original se anula)."
        ),
        actions=[
            ft.TextButton("No cancelar", on_click=_cancel),
            ft.FilledButton("Sí, cancelar", on_click=_confirm, style=ft.ButtonStyle(bgcolor='#F44336', color=ft.Colors.WHITE)),
        ],
        actions_alignment=ft.MainAxisAlignment.END,
    )
    page.open(dialog)
    dialog.update()
