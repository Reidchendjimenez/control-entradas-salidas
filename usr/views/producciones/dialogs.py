"""Diálogos del módulo Producciones: confirmar eliminar receta, descargo y cancelación.

El editor de receta se maneja en `receta_editor.py` (pantalla completa).
"""
import flet as ft

from usr.notifications import show_success, show_error, show_warning
from usr.views.producciones import data
from usr.views.producciones.helpers import colors as _colors


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
