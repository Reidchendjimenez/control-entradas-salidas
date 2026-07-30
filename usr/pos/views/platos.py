import flet as ft
from usr.database.local_replica import LocalReplica


class PlatosView(ft.Container):
    def __init__(self, on_back=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 20
        self.on_back = on_back
        self._mostrar_contornos = False
        self._build_ui()
        self._load_platos()

    def _build_ui(self):
        self.lv_platos = ft.ListView(expand=True, spacing=8, auto_scroll=False)
        self.content = ft.Column([
            ft.Row([
                ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                              tooltip="Volver", on_click=lambda _: self._go_back()),
                ft.Text("Platos", size=20, weight=ft.FontWeight.BOLD,
                        color=ft.Colors.WHITE, expand=True),
                ft.OutlinedButton("Categorias", icon=ft.Icons.CATEGORY_ROUNDED,
                                  on_click=lambda _: self._show_categorias_dialog()),
                ft.ElevatedButton("Nuevo plato", icon=ft.Icons.ADD_ROUNDED,
                                  bgcolor="#4CAF50", color=ft.Colors.WHITE,
                                  on_click=lambda _: self._show_plato_dialog()),
            ]),
            ft.Container(height=10),
            ft.Container(content=self.lv_platos, border=ft.border.all(1, "#3D3D3D"),
                          border_radius=10, padding=10, expand=True),
        ], expand=True)

    def _load_platos(self):
        self.lv_platos.controls.clear()
        all_platos = LocalReplica.get_platos()
        if self._mostrar_contornos:
            platos = [p for p in all_platos if p.get('es_contorno')]
        else:
            platos = [p for p in all_platos if not p.get('es_contorno')]
        if not platos:
            self.lv_platos.controls.append(self._empty_placeholder(
                "No hay contornos" if self._mostrar_contornos else "No hay platos registrados"
            ))
        else:
            for p in platos:
                self.lv_platos.controls.append(self._build_plato_card(p))
        header = ft.Row([
            ft.Container(expand=True),
            ft.ElevatedButton(
                "Ver contornos" if not self._mostrar_contornos else "Ver platos",
                icon=ft.Icons.DATASET_LINKED_ROUNDED,
                bgcolor="#FF6F00" if self._mostrar_contornos else "#3D3D3D",
                color=ft.Colors.WHITE,
                on_click=lambda _: (setattr(self, '_mostrar_contornos',
                                            not self._mostrar_contornos), self._load_platos()),
            ),
            ft.OutlinedButton("Categorias", icon=ft.Icons.CATEGORY_ROUNDED,
                              on_click=lambda _: self._show_categorias_dialog()),
            ft.ElevatedButton("Nuevo plato", icon=ft.Icons.ADD_ROUNDED,
                              bgcolor="#4CAF50", color=ft.Colors.WHITE,
                              on_click=lambda _: self._show_plato_dialog()),
        ], alignment=ft.MainAxisAlignment.START)
        self.lv_platos.controls.insert(0, ft.Container(content=header, padding=ft.padding.only(bottom=10)))
        if self.page:
            self.update()

    def _build_plato_card(self, plato: dict):
        cat = plato.get('categoria_nombre') or "Sin categoria"
        precio = float(plato.get('precio_venta', 0) or 0)
        es_contorno = bool(plato.get('es_contorno'))
        tags = []
        if es_contorno:
            tags.append(ft.Container(
                content=ft.Text("CONTORNO", size=9, weight=ft.FontWeight.BOLD, color="#FF6F00"),
                bgcolor="#FF6F0022", padding=ft.padding.symmetric(horizontal=6, vertical=2),
                border_radius=4,
            ))
        return ft.Container(
            content=ft.Row([
                ft.Container(
                    content=ft.Text(plato['nombre'][:2].upper(), size=18,
                                    weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    width=50, height=50, bgcolor=plato.get('categoria_color', '#FF6F00'),
                    border_radius=25, alignment=ft.alignment.center,
                ),
                ft.Column([
                    ft.Row([
                        ft.Text(plato['nombre'], size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                        *tags,
                    ], spacing=6, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                    ft.Text(f"{cat}  |  $ {precio:.2f}", size=12, color="#9E9E9E"),
                ], spacing=2, expand=True),
                ft.Row([
                    ft.IconButton(ft.Icons.EDIT, icon_size=18, icon_color="#BB86FC",
                                  on_click=lambda _, p=plato: self._show_plato_dialog(p)),
                    ft.IconButton(ft.Icons.DELETE, icon_size=18, icon_color="#EF5350",
                                  on_click=lambda _, p=plato: self._delete_plato(p)),
                ]),
            ], spacing=15),
            bgcolor="#1E1E1E", border=ft.border.all(1, "#3D3D3D"),
            border_radius=10, padding=15,
        )

    def _delete_plato(self, plato: dict):
        LocalReplica.delete_plato(plato['id'])
        self._load_platos()

    # ===== CATEGORIAS =====

    def _show_categorias_dialog(self):
        cats = LocalReplica.get_platos_categorias(solo_activas=False)
        cat_list = ft.ListView(expand=True, spacing=6)
        for c in cats:
            cat_list.controls.append(self._build_cat_card(c))
        if not cats:
            cat_list.controls.append(ft.Container(
                content=ft.Text("Sin categorias", color="#9E9E9E", italic=True),
                padding=10, alignment=ft.alignment.center,
            ))
        nombre_new = ft.TextField(label="Nombre", width=300, autofocus=True)
        color_dd = ft.Dropdown(label="Color", width=200, value="#FF6F00",
            options=[ft.dropdown.Option(c[0], c[1]) for c in [
                ("#FF6F00","Naranja"),("#E53935","Rojo"),("#43A047","Verde"),
                ("#1E88E5","Azul"),("#8E24AA","Morado"),("#00ACC1","Cyan"),
            ]])
        def add_cat():
            n = (nombre_new.value or "").strip()
            if n:
                LocalReplica.save_plato_categoria({'nombre': n, 'color': color_dd.value})
                nombre_new.value = ""
                self._show_categorias_dialog()
        content = ft.Column([
            ft.Row([nombre_new, color_dd, ft.IconButton(ft.Icons.ADD_CIRCLE, icon_color="#4CAF50",
                       icon_size=32, on_click=lambda _: add_cat())], spacing=6),
            ft.Container(height=8),
            ft.Container(content=cat_list, border=ft.border.all(1,"#3D3D3D"),
                          border_radius=10, padding=10, height=300),
        ], tight=True, scroll=ft.ScrollMode.AUTO, width=520)
        self._show_dialog("Categorias de platos", content, lambda: self._close_dialog(), "Cerrar")

    def _build_cat_card(self, cat: dict):
        return ft.Container(
            content=ft.Row([
                ft.Container(width=12, height=12, bgcolor=cat.get('color','#FF6F00'), border_radius=6),
                ft.Text(cat['nombre'], size=14, color=ft.Colors.WHITE, expand=True),
                ft.Switch(value=bool(cat.get('activo')),
                          on_change=lambda e, c=cat: LocalReplica.save_plato_categoria(
                              {'id': c['id'], 'nombre': c['nombre'], 'color': c.get('color','#FF6F00'),
                               'activo': e.control.value})),
                ft.IconButton(ft.Icons.DELETE, icon_size=18, icon_color="#EF5350",
                              on_click=lambda _, c=cat: (LocalReplica.delete_plato_categoria(c['id']),
                                                         self._show_categorias_dialog())),
            ], spacing=8, vertical_alignment=ft.CrossAxisAlignment.CENTER),
            padding=8, bgcolor="#1E1E1E", border_radius=8,
        )

    # ===== DIALOGO PLATO =====

    def _show_plato_dialog(self, plato: dict = None):
        is_edit = plato is not None
        pid = plato.get('id') if is_edit else None

        nombre = ft.TextField(label="Nombre", value=plato.get('nombre','') if is_edit else '',
                              width=350, autofocus=True)
        cats = LocalReplica.get_platos_categorias()
        cat_dd = ft.Dropdown(label="Categoria",
            options=[ft.dropdown.Option(str(c['id']), c['nombre']) for c in cats],
            value=str(plato.get('categoria_id','')) if is_edit else None, width=350)
        precio = ft.TextField(label="Precio ($)",
            value=f"{float(plato.get('precio_venta',0) or 0):.2f}" if is_edit else '',
            keyboard_type=ft.KeyboardType.NUMBER, width=350)

        es_contorno_sw = ft.Switch(
            label="Es un contorno (acompañante)",
            value=bool(plato.get('es_contorno')) if is_edit else False,
        )

        ing_col = ft.Column(spacing=6, tight=True)
        ings_data = []
        if is_edit:
            full = LocalReplica.get_plato_with_ingredientes(pid)
            if full: ings_data = full.get('ingredientes', [])

        def mkrow(d=None):
            opts = [ft.dropdown.Option(str(p['id']), f"{p['nombre']} ({p.get('tipo','')})")
                    for p in LocalReplica.get_productos_insumo()]
            r = ft.Row([
                ft.Dropdown(label="Producto", options=opts, width=280,
                            value=str(d.get('producto_id','')) if d else None),
                ft.TextField(label="Cant", width=80, keyboard_type=ft.KeyboardType.NUMBER,
                             value=str(d.get('cantidad','')) if d else ''),
                ft.TextField(label="Unidad", width=80, value=d.get('unidad','unidad') if d else 'unidad'),
                ft.IconButton(ft.Icons.DELETE_ROUNDED, icon_color="#EF5350", icon_size=20),
            ], spacing=6, vertical_alignment=ft.CrossAxisAlignment.CENTER)
            r.controls[-1].on_click = lambda _, rr=r: self._remove_ing_row(ing_col, rr)
            return r

        def add_ing():
            ing_col.controls.append(mkrow()); ing_col.update()

        for d in ings_data:
            ing_col.controls.append(mkrow(d))
        if not ings_data:
            ing_col.controls.append(ft.Text("Sin ingredientes (opcional)", size=12, color="#757575", italic=True))

        ing_section = ft.Column([
            ft.Text("INGREDIENTES (productos de inventario)", size=13, weight=ft.FontWeight.BOLD, color="#9E9E9E"),
            ing_col,
            ft.Container(ft.Row([ft.Icon(ft.Icons.ADD, size=16, color="#4CAF50"),
                ft.Text("Agregar ingrediente", size=13, color="#4CAF50")], spacing=4),
                on_click=lambda _: add_ing()),
        ], spacing=8, tight=True)

        lleva_contornos_sw = ft.Switch(
            label="Lleva contornos (elige al vender)",
            value=bool(plato.get('lleva_contornos')) if is_edit else False,
        )

        content = ft.Column([
            nombre, cat_dd, precio, es_contorno_sw, lleva_contornos_sw,
            ft.Divider(height=1, color="#3D3D3D"),
            ing_section,
        ], spacing=12, tight=True, scroll=ft.ScrollMode.AUTO)

        def save():
            n = (nombre.value or "").strip()
            if not n: return
            ingredientes = []
            for r in ing_col.controls:
                if not hasattr(r, 'controls'): continue
                f = r.controls
                if len(f) >= 3 and f[0].value and f[1].value:
                    ingredientes.append({
                        'producto_id': int(f[0].value),
                        'cantidad': float(f[1].value),
                        'unidad': f[2].value or 'unidad',
                    })
            data = {
                'nombre': n,
                'categoria_id': int(cat_dd.value),
                'precio_venta': float(precio.value or 0),
                'es_contorno': bool(es_contorno_sw.value),
                'lleva_contornos': bool(lleva_contornos_sw.value),
            }
            if is_edit: data['id'] = pid
            LocalReplica.save_plato(data, ingredientes)
            self._close_dialog(); self._load_platos()

        self._show_dialog(f"{'Editar' if is_edit else 'Nuevo'} Plato", content, save)

    def _remove_ing_row(self, container, row):
        if len([c for c in container.controls if hasattr(c, 'controls')]) > 1:
            container.controls.remove(row)
            container.update()

    # ===== UTILIDADES =====

    def _empty_placeholder(self, texto):
        return ft.Container(ft.Column([ft.Icon(ft.Icons.RAMEN_DINING, size=50, color="#757575"),
            ft.Text(texto, size=14, color="#9E9E9E")], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
            padding=30, alignment=ft.alignment.center)

    def _show_dialog(self, title, content, on_save, save_text="Guardar"):
        self._close_dialog()
        self.active_dialog = ft.AlertDialog(
            title=ft.Text(title), content=ft.Container(content=content, width=450, padding=5),
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: self._close_dialog()),
                ft.ElevatedButton(save_text, on_click=lambda _: on_save(),
                                  bgcolor="#4CAF50", color=ft.Colors.WHITE),
            ], actions_alignment=ft.MainAxisAlignment.END)
        if self.page:
            self.page.overlay.append(self.active_dialog)
            self.active_dialog.open = True; self.page.update()

    def _close_dialog(self):
        if hasattr(self, 'active_dialog') and self.active_dialog:
            self.active_dialog.open = False; self.active_dialog = None; self._flush()

    def _flush(self):
        if not self.page: return
        try:
            for c in self.page.overlay[:]:
                if isinstance(c, ft.AlertDialog): c.open = False
            self.page.update()
        except AssertionError: pass

    def _go_back(self):
        if self.on_back: self.on_back()
