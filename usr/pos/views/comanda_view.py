import flet as ft
from usr.database.local_replica import LocalReplica


class ComandaPedidoView(ft.Container):
    def __init__(self, usuario: dict = None, sesion_id: int = None, mesa: dict = None,
                 on_logout=None, on_back=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 0
        self.usuario = usuario
        self.sesion_id = sesion_id
        self.mesa = mesa
        self.on_logout = on_logout
        self.on_back = on_back
        self.items = []
        self.categoria_actual = None
        self._build_ui()
        self._load_categorias()

    def _build_ui(self):
        top_bar = self._build_top_bar()
        divider = ft.Container(height=1, bgcolor="#3D3D3D")

        # ---- Panel izquierdo: COMANDA ----
        self.lv_comanda = ft.ListView(expand=True, spacing=6, auto_scroll=False)
        self.txt_total = ft.Text("Bs 0.00", size=22, weight=ft.FontWeight.BOLD, color="#4CAF50")
        self.txt_vacio = ft.Text("Seleccione productos", size=14, color="#9E9E9E", italic=True)

        col_comanda = ft.Column([
            ft.Container(
                content=ft.Text("COMANDA", size=13, weight=ft.FontWeight.BOLD, color="#9E9E9E"),
                padding=ft.padding.only(left=10, top=5, bottom=5),
            ),
            ft.Container(content=self.lv_comanda, expand=True),
            ft.Divider(height=1, color="#3D3D3D"),
            ft.Container(
                content=ft.Row([
                    ft.Text("TOTAL:", size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    self.txt_total,
                ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                padding=ft.padding.symmetric(horizontal=15, vertical=8),
            ),
            ft.Container(
                content=ft.Row([
                    ft.OutlinedButton("Cancelar", icon=ft.Icons.CANCEL_ROUNDED,
                                      icon_color="#EF5350",
                                      style=ft.ButtonStyle(color="#EF5350"),
                                      on_click=lambda _: self._go_back()),
                    ft.ElevatedButton("Cobrar", icon=ft.Icons.PAYMENTS_ROUNDED,
                                      bgcolor="#4CAF50", color=ft.Colors.WHITE,
                                      disabled=True),
                ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                padding=ft.padding.symmetric(horizontal=10, vertical=8),
            ),
        ], expand=True, spacing=0)

        panel_izq = ft.Container(
            content=col_comanda,
            width=300,
            border=ft.border.only(right=ft.BorderSide(1, "#3D3D3D")),
            bgcolor="#1A1A1A",
        )

        # ---- Panel derecho: CATEGORIAS / PRODUCTOS ----
        self.panel_derecho = ft.Container(expand=True, padding=15)
        self._build_panel_derecho()

        fila = ft.Row([panel_izq, self.panel_derecho], expand=True, spacing=0)

        self.content = ft.Column([top_bar, divider, fila], expand=True, spacing=0)

    def _build_top_bar(self):
        nombre = self.usuario.get('nombre', 'Cajero') if self.usuario else 'Cajero'
        iniciales = nombre[:2].upper() if nombre else "?"
        es_admin = bool(self.usuario.get('es_admin', 0)) if self.usuario else False
        avatar_color = "#FF9800" if es_admin else "#7C4DFF"
        avatar = ft.Container(
            content=ft.Text(iniciales, size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
            width=36, height=36, bgcolor=avatar_color, border_radius=18, alignment=ft.alignment.center,
        )
        user_info = ft.Column([
            ft.Text(nombre, size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
            ft.Text("Administrador" if es_admin else f"Cajero #{self.usuario.get('id', '?')}" if self.usuario else "",
                    size=11, color="#FF9800" if es_admin else "#9E9E9E"),
        ], spacing=1, tight=True)
        mesa_info = f"Mesa {self.mesa.get('numero', '?')}" if self.mesa else "Comanda"
        if self.mesa and self.mesa.get('zona'):
            mesa_info += f" - {self.mesa['zona']}"
        left = [
            ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                          tooltip="Volver", on_click=lambda _: self._go_back()),
            ft.Text(mesa_info, size=18, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
        ]
        return ft.Container(
            content=ft.Row([
                ft.Row(left, spacing=5, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                ft.Container(expand=True),
                ft.Row([avatar, user_info], spacing=10, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                ft.IconButton(icon=ft.Icons.LOGOUT_ROUNDED, icon_color="#EF5350",
                              tooltip="Cerrar sesion", on_click=lambda _: self._cerrar_sesion()),
            ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN, vertical_alignment=ft.CrossAxisAlignment.CENTER),
            bgcolor="#1E1E1E", border=ft.border.only(bottom=ft.BorderSide(1, "#3D3D3D")),
            padding=ft.padding.symmetric(horizontal=20, vertical=10),
        )

    def _build_panel_derecho(self):
        self.categoria_actual = None
        self.grid = ft.GridView(
            expand=True, runs_count=4, max_extent=150,
            child_aspect_ratio=1.0, spacing=10, run_spacing=10,
        )
        self.panel_derecho.content = ft.Column([
            ft.Text("CATEGORIAS", size=13, weight=ft.FontWeight.BOLD, color="#9E9E9E"),
            self.grid,
        ], expand=True, spacing=8)
        self._load_categorias()
        if self.page:
            self.update()

    def _load_categorias(self):
        self.grid.controls.clear()
        cats = LocalReplica.get_categorias_pos()
        if not cats:
            self.grid.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.CATEGORY_ROUNDED, size=50, color="#757575"),
                    ft.Text("No hay categorias para el POS", size=14, color="#9E9E9E"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                padding=30, alignment=ft.alignment.center,
            ))
        else:
            for cat in cats:
                self.grid.controls.append(self._build_categoria_card(cat))

        platos_activos = LocalReplica.get_platos_pos()
        plato_cats = LocalReplica.get_platos_categorias()
        if plato_cats:
            self.grid.controls.append(self._build_platos_card())

        cont_activos = LocalReplica.get_contornos_activos()
        if cont_activos:
            self.grid.controls.append(self._build_contornos_card())

        if self.page:
            self.update()

    def _build_platos_card(self):
        card = ft.Container(
            bgcolor="#1A1A2E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, "#FF6F00")),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, "#FF6F00"), offset=ft.Offset(0, 3)),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            on_click=lambda _: self._on_platos_seccion_click(),
            content=ft.Column([
                ft.Container(
                    content=ft.Text("P", size=24, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor="#FF6F00", shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, "#FF6F00"), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=8),
                ft.Text("PLATOS", size=11, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card: self._cat_hover(e, c, "#FF6F00")
        return card

    def _on_platos_seccion_click(self):
        self.categoria_actual = {"tipo": "platos"}
        self.grid.controls.clear()
        pcats = LocalReplica.get_platos_categorias()
        if not pcats:
            self.grid.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.CATEGORY_ROUNDED, size=50, color="#757575"),
                    ft.Text("No hay categorias de platos", size=14, color="#9E9E9E"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                padding=30, alignment=ft.alignment.center,
            ))
        else:
            for cat in pcats:
                self.grid.controls.append(self._build_plato_categoria_card(cat))
        self.panel_derecho.content = ft.Column([
            ft.Row([
                ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                             tooltip="Volver a categorias", on_click=lambda _: self._build_panel_derecho()),
                ft.Text("PLATOS", size=13, weight=ft.FontWeight.BOLD, color="#FF6F00", expand=True),
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            self.grid,
        ], expand=True, spacing=8)
        if self.page:
            self.update()

    def _build_plato_categoria_card(self, cat: dict):
        color = cat.get('color', '#FF6F00')
        inicial = cat.get('nombre', '?')[0].upper()
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3)),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            on_click=lambda _, c=cat: self._on_plato_categoria_click(c),
            content=ft.Column([
                ft.Container(
                    content=ft.Text(inicial, size=24, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor=color, shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, color), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=8),
                ft.Text(cat.get('nombre', '').upper(), size=11, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER, max_lines=2, overflow=ft.TextOverflow.ELLIPSIS),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card, cl=color: self._cat_hover(e, c, cl)
        return card

    def _on_plato_categoria_click(self, cat: dict):
        self.grid.controls.clear()
        platos = LocalReplica.get_platos_pos()
        platos_filtrados = [p for p in platos if str(p.get('categoria_id')) == str(cat.get('id'))]
        if not platos_filtrados:
            self.grid.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.RAMEN_DINING, size=50, color="#757575"),
                    ft.Text("No hay platos en esta categoria", size=14, color="#9E9E9E"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                padding=30, alignment=ft.alignment.center,
            ))
        else:
            for p in platos_filtrados:
                self.grid.controls.append(self._build_plato_card(p))
        self.panel_derecho.content = ft.Column([
            ft.Row([
                ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                             tooltip="Volver a categorias",
                             on_click=lambda _: self._on_platos_seccion_click()),
                ft.Text(cat.get('nombre', '').upper(), size=13, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE, expand=True),
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            self.grid,
        ], expand=True, spacing=8)
        if self.page:
            self.update()

    def _build_plato_card(self, plato: dict):
        precio = float(plato.get('precio_venta', 0) or 0)
        nombre = plato.get('nombre', '?')
        color = plato.get('categoria_color', '#FF6F00')
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3)),
            on_click=lambda _, p=plato: self._agregar_item(p),
            content=ft.Column([
                ft.Container(
                    content=ft.Text(nombre[:2].upper(), size=22, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor=color, shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, color), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=6),
                ft.Text(nombre.upper(), size=10, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER, max_lines=2, overflow=ft.TextOverflow.ELLIPSIS),
                ft.Text(f"Bs {precio:.2f}", size=12, weight="bold", color=color),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card, cl=color: self._cat_hover(e, c, cl)
        return card

    # ==================== CONTORNOS ====================

    def _build_contornos_card(self):
        card = ft.Container(
            bgcolor="#1A1A2E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, "#26A69A")),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, "#26A69A"), offset=ft.Offset(0, 3)),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            on_click=lambda _: self._on_contornos_seccion_click(),
            content=ft.Column([
                ft.Container(
                    content=ft.Text("C", size=24, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor="#26A69A", shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, "#26A69A"), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=8),
                ft.Text("CONTORNOS", size=11, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card: self._cat_hover(e, c, "#26A69A")
        return card

    def _on_contornos_seccion_click(self):
        self.categoria_actual = {"tipo": "contornos"}
        self.grid.controls.clear()
        cont_activos = LocalReplica.get_contornos_activos()
        if not cont_activos:
            self.grid.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.DATASET_LINKED_ROUNDED, size=50, color="#757575"),
                    ft.Text("No hay contornos activos", size=14, color="#9E9E9E"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                padding=30, alignment=ft.alignment.center,
            ))
        else:
            for c in cont_activos:
                self.grid.controls.append(self._build_contorno_card(c))
        self.panel_derecho.content = ft.Column([
            ft.Row([
                ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                             tooltip="Volver a categorias",
                             on_click=lambda _: self._build_panel_derecho()),
                ft.Text("CONTORNOS", size=13, weight=ft.FontWeight.BOLD, color="#26A69A", expand=True),
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            self.grid,
        ], expand=True, spacing=8)
        if self.page:
            self.update()

    def _build_contorno_card(self, cont: dict):
        precio = float(cont.get('precio_venta', 0) or 0)
        nombre = cont.get('nombre', '?')
        cat_nombre = cont.get('categoria_nombre', '')
        color = cont.get('categoria_color', '#26A69A')
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3)),
            on_click=lambda _, p=cont: self._agregar_item(p),
            content=ft.Column([
                ft.Container(
                    content=ft.Text(nombre[:2].upper(), size=22, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor=color, shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, color), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=6),
                ft.Text(nombre.upper(), size=10, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER, max_lines=2, overflow=ft.TextOverflow.ELLIPSIS),
                ft.Text(f"Bs {precio:.2f}", size=12, weight="bold", color=color),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card, cl=color: self._cat_hover(e, c, cl)
        return card

    def _build_categoria_card(self, cat: dict):
        color = cat.get('color', '#2196F3')
        inicial = cat.get('nombre', '?')[0].upper()
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3)),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            animate_rotation=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            on_click=lambda _, c=cat: self._on_categoria_click(c),
            content=ft.Column([
                ft.Container(
                    content=ft.Text(inicial, size=24, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor=color, shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, color), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=8),
                ft.Text(cat.get('nombre', '').upper(), size=11, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER, max_lines=2, overflow=ft.TextOverflow.ELLIPSIS),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card, cl=color: self._cat_hover(e, c, cl)
        return card

    @staticmethod
    def _cat_hover(e, card, color):
        if e.data == "true":
            card.scale = 1.05; card.rotate = 0.02
            card.shadow = ft.BoxShadow(blur_radius=15, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 0))
        else:
            card.scale = 1.0; card.rotate = 0
            card.shadow = ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.1, color), offset=ft.Offset(0, 0))
        card.update()

    def _on_categoria_click(self, cat: dict):
        self.categoria_actual = cat
        self.grid.controls.clear()
        prods = LocalReplica.get_productos_pos(cat['id'])
        if not prods:
            self.grid.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.INVENTORY_2_ROUNDED, size=50, color="#757575"),
                    ft.Text("No hay productos en esta categoria", size=14, color="#9E9E9E"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                padding=30, alignment=ft.alignment.center,
            ))
        else:
            for p in prods:
                self.grid.controls.append(self._build_producto_card(p))
        self.panel_derecho.content = ft.Column([
            ft.Row([
                ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                             tooltip="Volver a categorias", on_click=lambda _: self._build_panel_derecho()),
                ft.Text(cat.get('nombre', '').upper(), size=13, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE, expand=True),
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            self.grid,
        ], expand=True, spacing=8)
        if self.page:
            self.update()

    def _build_producto_card(self, prod: dict):
        precio = prod.get('precio_venta', 0) or 0
        nombre = prod.get('nombre', '?')
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, "#4CAF50")),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, "#4CAF50"), offset=ft.Offset(0, 3)),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            on_click=lambda _, p=prod: self._agregar_item(p),
            content=ft.Column([
                ft.Container(
                    content=ft.Text(nombre[:2].upper(), size=22, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor="#4CAF50", shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, "#4CAF50"), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=6),
                ft.Text(nombre.upper(), size=10, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER, max_lines=2, overflow=ft.TextOverflow.ELLIPSIS),
                ft.Text(f"Bs {precio:.2f}", size=11, color="#4CAF50", weight=ft.FontWeight.BOLD),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card: self._prod_hover(e, c)
        return card

    @staticmethod
    def _prod_hover(e, card):
        if e.data == "true":
            card.scale = 1.05
            card.shadow = ft.BoxShadow(blur_radius=15, color=ft.Colors.with_opacity(0.2, "#4CAF50"), offset=ft.Offset(0, 0))
        else:
            card.scale = 1.0
            card.shadow = ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.1, "#4CAF50"), offset=ft.Offset(0, 0))
        card.update()

    def _agregar_item(self, prod: dict):
        # Si es plato (es_contorno=0) con contornos asignados, mostrar dialogo
        if prod.get('es_contorno') == 0:
            contornos = LocalReplica.get_plato_contornos(prod['id'])
            if contornos:
                self._show_contornos_dialog(prod, contornos)
                return

        for item in self.items:
            if item['producto']['id'] == prod['id'] and not item.get('contornos_seleccionados'):
                item['cantidad'] += 1
                self._refrescar_comanda()
                return
        self.items.append({'producto': prod, 'cantidad': 1})
        self._refrescar_comanda()

    def _show_contornos_dialog(self, plato: dict, contornos: list):
        max_sel = contornos[0].get('max_seleccionar', 2)
        checks = {}
        for c in contornos:
            chk = ft.Checkbox(label=c['contorno_nombre'], value=False)
            checks[str(c['contorno_id'])] = chk

        max_text = ft.Text(f"Seleccione hasta {max_sel} contornos", size=12, color="#9E9E9E", italic=True)
        err_text = ft.Text("", size=11, color="#EF5350")

        def on_confirm(e):
            selected = [cid for cid, chk in checks.items() if chk.value]
            if len(selected) > max_sel:
                err_text.value = f"Maximo {max_sel} contornos"
                err_text.update(); return
            ci = [c for c in contornos if str(c['contorno_id']) in selected]
            for item in self.items:
                if item['producto']['id'] == plato['id'] and not item.get('contornos_seleccionados'):
                    item['cantidad'] += 1
                    self._refrescar_comanda()
                    self._close_dialog()
                    return
            self.items.append({
                'producto': plato, 'cantidad': 1,
                'contornos_seleccionados': selected,
                'contornos_info': ci,
            })
            self._refrescar_comanda()
            self._close_dialog()

        content = ft.Column([
            max_text, err_text,
            *[chk for chk in checks.values()],
        ], spacing=8, tight=True)

        self._show_dialog(
            title=f"Contornos para {plato.get('nombre','')}",
            content=content,
            on_save=on_confirm,
            save_text="Agregar",
        )

    def _refrescar_comanda(self):
        self.lv_comanda.controls.clear()
        total = 0
        for i, item in enumerate(self.items):
            p = item['producto']
            cant = item['cantidad']
            precio = p.get('precio_venta', 0) or 0
            subtotal = cant * precio
            total += subtotal
            lines = [
                ft.Text(p.get('nombre', '?'), size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                ft.Text(f"Bs {precio:.2f}", size=11, color="#9E9E9E"),
            ]
            if item.get('contornos_info'):
                for ci in item['contornos_info']:
                    lines.append(ft.Text(f"+ {ci['contorno_nombre']}", size=10, color="#FF6F00"))
            self.lv_comanda.controls.append(ft.Container(
                content=ft.Row([
                    ft.Column(lines, spacing=1, expand=True),
                    ft.Row([
                        ft.IconButton(icon=ft.Icons.REMOVE_CIRCLE_OUTLINE, icon_size=18, icon_color="#FF9800",
                                     on_click=lambda _, idx=i: self._cambiar_cantidad(idx, -1)),
                        ft.Text(str(cant), size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                        ft.IconButton(icon=ft.Icons.ADD_CIRCLE_OUTLINE, icon_size=18, icon_color="#4CAF50",
                                     on_click=lambda _, idx=i: self._cambiar_cantidad(idx, 1)),
                        ft.Container(width=10),
                        ft.Text(f"Bs {subtotal:.2f}", size=14, weight=ft.FontWeight.BOLD, color="#4CAF50"),
                        ft.IconButton(icon=ft.Icons.DELETE_OUTLINE, icon_size=18, icon_color="#EF5350",
                                     on_click=lambda _, idx=i: self._eliminar_item(idx)),
                    ], spacing=2, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
                padding=ft.padding.symmetric(horizontal=10, vertical=4),
                bgcolor="#222222" if i % 2 == 0 else "#1A1A1A",
            ))
        self.txt_total.value = f"Bs {total:.2f}"
        if self.page:
            self.update()

    def _cambiar_cantidad(self, idx, delta):
        if 0 <= idx < len(self.items):
            self.items[idx]['cantidad'] = max(1, self.items[idx]['cantidad'] + delta)
            self._refrescar_comanda()

    def _eliminar_item(self, idx):
        if 0 <= idx < len(self.items):
            self.items.pop(idx)
            self._refrescar_comanda()

    # ==================== DIALOGOS ====================

    def _show_dialog(self, title, content, on_save, save_text="Guardar"):
        self._close_dialog()
        self.active_dialog = ft.AlertDialog(
            title=ft.Text(title),
            content=content,
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: self._close_dialog()),
                ft.ElevatedButton(save_text, on_click=on_save,
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
        if self.on_back:
            self.on_back()

    def _cerrar_sesion(self):
        if self.sesion_id:
            try:
                LocalReplica.cerrar_pos_sesion(self.sesion_id)
            except Exception:
                pass
        if self.on_logout:
            self.on_logout()
        elif self.page:
            from usr.pos.views.login import POSLoginView
            self.page.clean()
            self.page.add(POSLoginView(on_login=self._on_login_done))
            self.page.update()

    def _on_login_done(self, usuario, sesion_id):
        if self.page:
            from usr.pos.views.comandas import ComandasView
            self.page.clean()
            self.page.add(ComandasView(usuario=usuario, sesion_id=sesion_id))
            self.page.update()
