import flet as ft
from datetime import datetime
from usr.database.sync_queue import get_sync_queue
from usr.database.local_replica import LocalReplica
from usr.notifications import show_error
from usr.views.configuracion.helpers import _colors, trigger_sync


def show_proveedor_dialog(view, proveedor=None):
    colors = _colors(view.page)

    nombre_input = ft.TextField(
        label="Nombre *",
        value=proveedor.get('nombre', '') if proveedor else '',
        border_radius=10
    )
    rif_input = ft.TextField(
        label="RIF",
        value=proveedor.get('rif', '') if proveedor else '',
        border_radius=10
    )
    telefono_input = ft.TextField(
        label="Telefono",
        value=proveedor.get('telefono', '') if proveedor else '',
        border_radius=10
    )
    email_input = ft.TextField(
        label="Email",
        value=proveedor.get('email', '') if proveedor else '',
        border_radius=10
    )
    direccion_input = ft.TextField(
        label="Direccion",
        value=proveedor.get('direccion', '') if proveedor else '',
        border_radius=10,
        multiline=True,
        min_lines=2
    )
    contacto_input = ft.TextField(
        label="Persona de contacto",
        value=proveedor.get('contacto', '') if proveedor else '',
        border_radius=10
    )
    observaciones_input = ft.TextField(
        label="Observaciones",
        value=proveedor.get('observaciones', '') if proveedor else '',
        border_radius=10,
        multiline=True,
        min_lines=2
    )
    estado_switch = ft.Switch(
        label="Activo",
        value=proveedor.get('estado', 'Activo') == 'Activo' if proveedor else True,
    )

    prov_id = proveedor.get('id') if proveedor else None

    from usr.views.configuracion.dialogs import close_dialog
    def on_guardar(e):
        if not nombre_input.value.strip():
            return
        if not rif_input.value.strip():
            from usr.utils import show_snackbar
            show_snackbar(view.page, "El RIF es obligatorio")
            return
        save_proveedor(
            view,
            nombre_input.value.strip(),
            rif_input.value.strip(),
            telefono_input.value.strip(),
            email_input.value.strip(),
            direccion_input.value.strip(),
            contacto_input.value.strip(),
            observaciones_input.value.strip(),
            estado_switch.value,
            prov_id
        )

    view.active_dialog = ft.AlertDialog(
        title=ft.Text(f"{'Editar' if proveedor else 'Nuevo'} Proveedor"),
        content=ft.Column([
            nombre_input, rif_input, telefono_input, email_input,
            direccion_input, contacto_input, observaciones_input, estado_switch
        ], tight=True, scroll=ft.ScrollMode.AUTO),
        actions=[
            ft.TextButton("Cancelar", on_click=lambda e: close_dialog(view, e)),
            ft.ElevatedButton("Guardar", on_click=on_guardar, bgcolor=colors['accent']),
        ]
    )
    view.page.overlay.append(view.active_dialog)
    view.active_dialog.open = True
    view.page.update()


def save_proveedor(view, nombre, rif, telefono, email, direccion, contacto, observaciones, activo, prov_id):
    prov_data = {
        "nombre": str(nombre),
        "rif": str(rif) if rif else None,
        "telefono": str(telefono) if telefono else None,
        "email": str(email) if email else None,
        "direccion": str(direccion) if direccion else None,
        "contacto": str(contacto) if contacto else None,
        "observaciones": str(observaciones) if observaciones else None,
        "estado": "Activo" if activo else "Inactivo",
        "updated_at": datetime.now().isoformat()
    }
    if prov_id:
        prov_data["id"] = prov_id

    try:
        LocalReplica.save_proveedores([prov_data])
    except Exception as e:
        print(f"Error SQLite: {e}")

    try:
        queue = get_sync_queue()
        queue.add_pending('proveedores', 'insert', prov_data)
        trigger_sync(view)
    except Exception as e:
        show_error("Error al agregar proveedor a sync", e, "configuracion.proveedores.save_proveedor")


def load_proveedores(view):
    view.proveedores_data = LocalReplica.get_proveedores()
    render_proveedores(view, view.proveedores_data)


def render_proveedores(view, data):
    colors = _colors(view.page)
    view.lista_proveedores.controls = []

    for prov in data:
        rif = prov.get('rif', '')
        tel = prov.get('telefono', '')
        email = prov.get('email', '')

        info_parts = [s for s in [rif, tel, email] if s]
        info_str = "  •  ".join(info_parts) if info_parts else ""

        card = ft.Container(
            content=ft.Column([
                ft.Row([
                    ft.Container(
                        content=ft.Icon(ft.Icons.LOCAL_SHIPPING, color=colors['white'], size=20),
                        bgcolor=colors['accent'],
                        padding=8,
                        border_radius=8,
                    ),
                    ft.Column([
                        ft.Text(prov.get('nombre', 'Sin nombre'), weight=ft.FontWeight.BOLD, size=14,
                                color=colors['text_primary'], max_lines=1, overflow=ft.TextOverflow.ELLIPSIS),
                        ft.Text(info_str, size=11, color=colors['text_secondary'],
                                max_lines=1, overflow=ft.TextOverflow.ELLIPSIS) if info_str else ft.Container(),
                    ], expand=True, spacing=2),
                    ft.Container(
                        content=ft.Text(prov.get('estado', 'Activo'), size=9, color="white"),
                        bgcolor=colors['success'] if prov.get('estado') == 'Activo' else colors['error'],
                        padding=ft.padding.symmetric(horizontal=6, vertical=2),
                        border_radius=6,
                    ),
                ], spacing=10),
            ], spacing=0, tight=True),
            padding=12,
            bgcolor=colors['card'],
            border_radius=12,
            border=ft.border.all(1, colors['border']),
            ink=True,
            on_click=lambda _, p=prov: show_proveedor_dialog(view, p)
        )
        view.lista_proveedores.controls.append(card)

    view.page.update()


def filter_proveedores(view, e):
    search = view.proveedor_search.value.lower()
    if not search:
        render_proveedores(view, view.proveedores_data)
        return
    filtered = [p for p in view.proveedores_data
                if search in (p.get('nombre') or '').lower()
                or search in (p.get('rif') or '').lower()]
    render_proveedores(view, filtered)


def build_proveedores_tab(view):
    colors = _colors(view.page)
    fab_content = ft.Row([
        ft.Icon(ft.Icons.ADD, size=20),
        ft.Text("Nuevo Proveedor" if not view.is_mobile else "Nuevo", weight=ft.FontWeight.BOLD),
    ], alignment=ft.MainAxisAlignment.CENTER, spacing=8)

    view.proveedor_search = ft.TextField(
        hint_text="Buscar proveedores...",
        prefix_icon=ft.Icons.SEARCH,
        border_radius=10,
        bgcolor=colors['card'],
        border_color=colors['border'],
        height=40,
        expand=True,
        on_change=lambda e: filter_proveedores(view, e),
    )

    view.lista_proveedores = ft.ListView(
        expand=True,
        spacing=10,
        padding=15,
    )

    return ft.Container(
        content=ft.Column([
            ft.Container(height=15),
            ft.Row([
                view.proveedor_search,
                ft.Container(
                    content=fab_content,
                    bgcolor=colors['accent'],
                    padding=ft.padding.symmetric(horizontal=20, vertical=12),
                    border_radius=30,
                    on_click=lambda _: show_proveedor_dialog(view),
                ),
            ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN, spacing=10),
            ft.Container(height=15),
            view.lista_proveedores,
        ], expand=True, spacing=0),
        padding=20,
        expand=True,
    )
