import flet as ft
from usr.database.local_replica import LocalReplica
from usr.pos.tasa_cambio import get_tasa


class ComandaPedidoView(ft.Container):
    def __init__(self, usuario: dict = None, sesion_id: int = None, mesa: dict = None,
                 habitacion: dict = None, on_logout=None, on_back=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 0
        self.usuario = usuario
        self.sesion_id = sesion_id
        self.mesa = mesa
        self.habitacion = habitacion
        self.on_logout = on_logout
        self.on_back = on_back
        self.items = []
        self.comanda_id = None
        self.categoria_actual = None
        self.tasa = get_tasa()
        self._build_ui()
        self._load_categorias()
        self._load_comanda_existente()

    def _build_ui(self):
        top_bar = self._build_top_bar()
        divider = ft.Container(height=1, bgcolor="#3D3D3D")

        # ---- Panel izquierdo: COMANDA ----
        self.lv_comanda = ft.ListView(expand=True, spacing=6, auto_scroll=False)
        self.txt_total = ft.Text("$ 0.00", size=22, weight=ft.FontWeight.BOLD, color="#4CAF50")
        self.txt_total_bs = ft.Text("Bs --", size=15, weight=ft.FontWeight.BOLD, color="#26A69A")
        self.txt_tasa_info = ft.Text("", size=11, color="#9E9E9E",
                                     max_lines=1, overflow=ft.TextOverflow.ELLIPSIS)
        self.btn_actualizar_tasa = ft.IconButton(
            icon=ft.Icons.SYNC_ROUNDED, icon_color="#FF9800", icon_size=18,
            tooltip="Actualizar tasa de cambio", on_click=lambda _: self._actualizar_tasa(),
        )
        self.txt_vacio = ft.Text("Seleccione productos", size=14, color="#9E9E9E", italic=True)
        self.btn_guardar = ft.ElevatedButton("Guardar", icon=ft.Icons.SAVE_ROUNDED,
                                             bgcolor="#1E88E5", color=ft.Colors.WHITE,
                                             disabled=True, on_click=lambda _: self._guardar())
        self.btn_cobrar = ft.ElevatedButton("Cobrar", icon=ft.Icons.PAYMENTS_ROUNDED,
                                            bgcolor="#4CAF50", color=ft.Colors.WHITE,
                                            disabled=True, on_click=lambda _: self._cobrar())
        self.btn_eliminar = ft.OutlinedButton(
            "Eliminar", icon=ft.Icons.DELETE_OUTLINE_ROUNDED, icon_color="#EF5350",
            style=ft.ButtonStyle(color="#EF5350"),
            disabled=True, on_click=lambda _: self._eliminar_comanda(),
        )

        col_comanda = ft.Column([
            ft.Container(
                content=ft.Text("COMANDA", size=13, weight=ft.FontWeight.BOLD, color="#9E9E9E"),
                padding=ft.padding.only(left=10, top=5, bottom=5),
            ),
            ft.Container(content=self.lv_comanda, expand=True),
            ft.Divider(height=1, color="#3D3D3D"),
            ft.Container(
                content=ft.Column([
                    ft.Row([
                        ft.Text("TOTAL:", size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                        self.txt_total,
                    ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                    ft.Row([
                        self.btn_actualizar_tasa,
                        ft.Container(content=self.txt_tasa_info, expand=True,
                                     padding=ft.padding.only(right=4)),
                        self.txt_total_bs,
                    ], spacing=6, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                ], spacing=2),
                padding=ft.padding.symmetric(horizontal=15, vertical=8),
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

        # ---- Franja inferior de acciones (a lo ancho de toda la vista) ----
        franja_botones = ft.Container(
            content=ft.Row([
                ft.OutlinedButton("Cancelar", icon=ft.Icons.CANCEL_ROUNDED,
                                  icon_color="#EF5350",
                                  style=ft.ButtonStyle(color="#EF5350"),
                                  on_click=lambda _: self._go_back()),
                self.btn_eliminar,
                ft.Container(expand=True),
                self.btn_guardar,
                ft.Container(width=8),
                self.btn_cobrar,
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            bgcolor="#1E1E1E",
            border=ft.border.only(top=ft.BorderSide(1, "#3D3D3D")),
            padding=ft.padding.symmetric(horizontal=15, vertical=10),
        )

        self.content = ft.Column([top_bar, divider, fila, franja_botones], expand=True, spacing=0)

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
        mesa_info = f"Comanda"
        if self.mesa:
            mesa_info = f"Mesa {self.mesa.get('numero', '?')}"
            if self.mesa.get('zona'):
                mesa_info += f" - {self.mesa['zona']}"
        elif self.habitacion:
            mesa_info = f"Habitacion {self.habitacion.get('numero', '?')}"
            if self.habitacion.get('tipo'):
                mesa_info += f" - {self.habitacion['tipo']}"
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
        # Categorias de inventario (visibles en POS)
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

        # Categorias POS independientes
        pos_cats = LocalReplica.get_pos_categorias(solo_activas=True)
        for cat in pos_cats:
            cat['_tipo'] = 'pos'  # marcar como POS para el click handler
            self.grid.controls.append(self._build_categoria_card(cat))

        platos_activos = LocalReplica.get_platos_pos()
        plato_cats = self._get_platos_categorias_pos()
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

    def _get_platos_categorias_pos(self):
        """Categorias de platos (sin padre) excluyendo las de contornos."""
        contorno_cat_ids = {p.get('categoria_id') for p in LocalReplica.get_contornos_activos()}
        return [c for c in LocalReplica.get_platos_categorias()
                if not c.get('categoria_padre_id') and not c.get('pos_categoria_padre_id')
                and c['id'] not in contorno_cat_ids]

    def _on_platos_seccion_click(self):
        self.categoria_actual = {"tipo": "platos"}
        self.grid.controls.clear()
        pcats = self._get_platos_categorias_pos()
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
        lleva = bool(plato.get('lleva_contornos'))
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3)),
            on_click=lambda _, p=plato: self._agregar_item(p, tipo='plato'),
            content=ft.Stack([
                ft.Column([
                    ft.Container(
                        content=ft.Text(nombre[:2].upper(), size=22, weight="bold", color=ft.Colors.WHITE),
                        alignment=ft.alignment.center, width=50, height=50,
                        bgcolor=color, shape=ft.BoxShape.CIRCLE,
                        shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, color), offset=ft.Offset(0, 3)),
                    ),
                    ft.Container(height=6),
                    ft.Text(nombre.upper(), size=10, weight="bold", color=ft.Colors.WHITE,
                            text_align=ft.TextAlign.CENTER, max_lines=2, overflow=ft.TextOverflow.ELLIPSIS),
                    ft.Text(f"$ {precio:.2f}", size=12, weight="bold", color=color),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
                ft.Container(
                    content=ft.Text("+", size=11, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    bgcolor="#4CAF50", width=18, height=18, border_radius=9,
                    alignment=ft.alignment.center,
                    right=30, top=0,
                ) if lleva else ft.Container(),
            ]),
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
            on_click=lambda _, p=cont: self._agregar_item(p, tipo='contorno'),
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
                ft.Text(f"$ {precio:.2f}", size=12, weight="bold", color=color),
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
        # Verificar si tiene sub-categorias
        sub_cats = []
        if cat.get('categoria_padre_id'):
            sub_cats = LocalReplica.get_subcategorias_by_categoria_padre(cat['id'])
        elif cat.get('pos_categoria_padre_id'):
            sub_cats = LocalReplica.get_subcategorias_by_pos_categoria_padre(cat.get('pos_categoria_padre_id'))
        elif cat.get('_tipo') == 'pos':
            # Categoria POS independiente
            sub_cats = LocalReplica.get_subcategorias_by_pos_categoria_padre(cat['id'])
        else:
            # Categoria de inventario
            sub_cats = LocalReplica.get_subcategorias_by_categoria_padre(cat['id'])

        if sub_cats:
            # Tiene sub-categorias: mostrarlas
            self._show_subcategorias(cat, sub_cats)
        else:
            # Sin sub-categorias: mostrar productos directamente
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
                    self.grid.controls.append(self._build_producto_card(p, color=cat.get('color', '#4CAF50')))
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

    def _show_subcategorias(self, parent_cat: dict, sub_cats: list):
        """Muestra las sub-categorias de una categoria padre junto a sus productos directos."""
        self.categoria_actual = parent_cat
        self.grid.controls.clear()
        for sc in sub_cats:
            sc['_parent'] = parent_cat  # guardar referencia al padre
            self.grid.controls.append(self._build_subcategoria_card(sc))

        prods = LocalReplica.get_productos_pos(parent_cat['id'])
        if prods:
            self.grid.controls.append(ft.Container(
                content=ft.Text("PRODUCTOS", size=11, weight=ft.FontWeight.BOLD, color="#4CAF50"),
                padding=ft.padding.only(top=14, bottom=4),
            ))
            for p in prods:
                self.grid.controls.append(self._build_producto_card(p, color=parent_cat.get('color', '#4CAF50')))

        self.panel_derecho.content = ft.Column([
            ft.Row([
                ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                             tooltip="Volver a categorias", on_click=lambda _: self._build_panel_derecho()),
                ft.Text(f"{parent_cat.get('nombre', '').upper()} > Sub-categorias",
                        size=13, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE, expand=True),
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            self.grid,
        ], expand=True, spacing=8)
        if self.page:
            self.update()

    def _build_subcategoria_card(self, sc: dict):
        color = sc.get('color', '#FF6F00')
        inicial = sc.get('nombre', '?')[0].upper()
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3)),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            on_click=lambda _, c=sc: self._on_subcategoria_click(c),
            content=ft.Column([
                ft.Container(
                    content=ft.Text(inicial, size=24, weight="bold", color=ft.Colors.WHITE),
                    alignment=ft.alignment.center, width=50, height=50,
                    bgcolor=color, shape=ft.BoxShape.CIRCLE,
                    shadow=ft.BoxShadow(blur_radius=8, color=ft.Colors.with_opacity(0.3, color), offset=ft.Offset(0, 3)),
                ),
                ft.Container(height=8),
                ft.Text(sc.get('nombre', '').upper(), size=11, weight="bold", color=ft.Colors.WHITE,
                        text_align=ft.TextAlign.CENTER),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card: self._cat_hover(e, c, color)
        return card

    def _on_subcategoria_click(self, sc: dict):
        parent_cat = sc.get('_parent')
        self.categoria_actual = sc
        self.grid.controls.clear()
        platos = LocalReplica.get_platos_pos()
        platos_filtrados = [p for p in platos if str(p.get('categoria_id')) == str(sc.get('id'))]
        if not platos_filtrados:
            self.grid.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.RAMEN_DINING, size=50, color="#757575"),
                    ft.Text("No hay platos en esta sub-categoria", size=14, color="#9E9E9E"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                padding=30, alignment=ft.alignment.center,
            ))
        else:
            for p in platos_filtrados:
                self.grid.controls.append(self._build_plato_card(p))
        self.panel_derecho.content = ft.Column([
            ft.Row([
                ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                             tooltip="Volver a sub-categorias",
                             on_click=lambda _: self._show_subcategorias(sc.get('_parent'), 
                                 LocalReplica.get_subcategorias_by_categoria_padre(sc['_parent']['id']) 
                                 if sc['_parent'].get('_tipo') != 'pos' 
                                 else LocalReplica.get_subcategorias_by_pos_categoria_padre(sc['_parent']['id']))),
                ft.Text(f"{sc.get('nombre', '').upper()}", size=13, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE, expand=True),
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            self.grid,
        ], expand=True, spacing=8)
        if self.page:
            self.update()

    def _build_producto_card(self, prod: dict, color: str = "#4CAF50"):
        precio = prod.get('precio_venta', 0) or 0
        nombre = prod.get('nombre', '?')
        card = ft.Container(
            bgcolor="#1E1E1E", border_radius=12, padding=12,
            alignment=ft.alignment.center,
            border=ft.border.only(bottom=ft.BorderSide(3, color)),
            shadow=ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 3)),
            animate_scale=ft.Animation(400, ft.AnimationCurve.DECELERATE),
            on_click=lambda _, p=prod: self._agregar_item(p, tipo='producto'),
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
                ft.Text(f"$ {precio:.2f}", size=11, color=color, weight=ft.FontWeight.BOLD),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER, alignment=ft.MainAxisAlignment.CENTER),
        )
        card.on_hover = lambda e, c=card, cl=color: self._prod_hover(e, c, cl)
        return card

    @staticmethod
    def _prod_hover(e, card, color):
        if e.data == "true":
            card.scale = 1.05
            card.shadow = ft.BoxShadow(blur_radius=15, color=ft.Colors.with_opacity(0.2, color), offset=ft.Offset(0, 0))
        else:
            card.scale = 1.0
            card.shadow = ft.BoxShadow(blur_radius=0, color=ft.Colors.with_opacity(0.1, color), offset=ft.Offset(0, 0))
        card.update()

    def _agregar_item(self, prod: dict, tipo='producto'):
        if prod.get('lleva_contornos'):
            contornos = LocalReplica.get_contornos_activos()
            if contornos:
                self._show_contornos_dialog(prod, contornos)
                return

        for item in self.items:
            if item['producto']['id'] == prod['id'] and not item.get('contornos_seleccionados'):
                item['cantidad'] += 1
                self._refrescar_comanda()
                return
        self.items.append({'producto': prod, 'cantidad': 1, 'tipo': tipo})
        self._refrescar_comanda()

    def _load_comanda_existente(self):
        comanda = None
        if self.mesa:
            comanda = LocalReplica.get_comanda_abierta(mesa_id=self.mesa.get('id'))
        elif self.habitacion:
            comanda = LocalReplica.get_comanda_abierta(habitacion_id=self.habitacion.get('id'))
        self.comanda_id = comanda.get('id') if comanda else None
        self.btn_eliminar.disabled = self.comanda_id is None
        if comanda and comanda.get('items'):
            for it in comanda['items']:
                prod = {
                    'id': it.get('id'),
                    'nombre': it.get('nombre', '?'),
                    'precio_venta': it.get('precio', 0),
                }
                entry = {'producto': prod, 'cantidad': it.get('cantidad', 1)}
                tipo = it.get('tipo')
                if not tipo:
                    tipo = 'producto' if LocalReplica.get_producto_by_id(it.get('id')) else 'plato'
                entry['tipo'] = tipo
                contornos = it.get('contornos') or []
                if contornos:
                    cids = it.get('contorno_ids') or []
                    entry['contornos_info'] = [{'id': cid, 'nombre': nm} for cid, nm in zip(cids, contornos)]
                    if not entry['contornos_info']:
                        entry['contornos_info'] = [{'nombre': nm} for nm in contornos]
                    entry['contornos_seleccionados'] = True
                self.items.append(entry)
            self._refrescar_comanda()

    def _build_items_data(self):
        items_data = []
        for item in self.items:
            p = item['producto']
            entry = {
                'id': p.get('id'),
                'tipo': item.get('tipo', 'producto'),
                'nombre': p.get('nombre'),
                'precio': float(p.get('precio_venta', 0) or 0),
                'cantidad': item['cantidad'],
            }
            if item.get('contornos_info'):
                entry['contornos'] = [c.get('nombre') for c in item['contornos_info']]
                cids = [c.get('id') for c in item['contornos_info'] if c.get('id')]
                if cids:
                    entry['contorno_ids'] = cids
            items_data.append(entry)
        return items_data

    def _guardar(self):
        if not self.items:
            return
        mesa_id = self.mesa.get('id') if self.mesa else None
        hab_id = self.habitacion.get('id') if self.habitacion else None
        total = sum(
            item['cantidad'] * float(item['producto'].get('precio_venta', 0) or 0)
            for item in self.items
        )
        items_data = self._build_items_data()

        try:
            comanda_id = LocalReplica.save_comanda(
                sesion_id=self.sesion_id, items=items_data, total=total,
                mesa_id=mesa_id, habitacion_id=hab_id,
            )
            self.comanda_id = comanda_id
            if self.on_back:
                self.on_back()
            self._show_snack("Comanda guardada", color="#4CAF50")
        except Exception as ex:
            import traceback as tb
            tb.print_exc()
            self._show_snack(f"Error: {ex}", color="#EF5350")

    def _cobrar(self):
        if not self.items:
            return
        mesa_id = self.mesa.get('id') if self.mesa else None
        hab_id = self.habitacion.get('id') if self.habitacion else None
        total = sum(
            item['cantidad'] * float(item['producto'].get('precio_venta', 0) or 0)
            for item in self.items
        )
        items_data = self._build_items_data()
        usuario = self.usuario or {}
        registrado_por = usuario.get('nombre', 'POS')
        usuario_id = usuario.get('id')

        venta_id = None
        try:
            comanda_id = LocalReplica.save_comanda(
                sesion_id=self.sesion_id, items=items_data, total=total,
                mesa_id=mesa_id, habitacion_id=hab_id,
            )
            self.comanda_id = comanda_id

            venta_anulada = LocalReplica.get_venta_anulada_by_comanda(comanda_id)
            correccion_de = venta_anulada.get('correlativo') if venta_anulada else None
            venta_anula_id = venta_anulada.get('id') if venta_anulada else None

            from usr.pos.printer import imprimir_comanda, _get_next_correlativo
            correlativo = _get_next_correlativo()

            venta_id = LocalReplica.registrar_venta(
                comanda_id=comanda_id, correlativo=correlativo, total=total,
                items=items_data, mesa_id=mesa_id, habitacion_id=hab_id,
                usuario_id=usuario_id, sesion_id=self.sesion_id,
                venta_anula_id=venta_anula_id, tasa_bs=self.tasa or None,
            )
            movs = LocalReplica.resolver_movimientos_venta(items_data)
            if movs:
                LocalReplica.aplicar_movimientos_venta(venta_id, movs, registrado_por)

            impreso = imprimir_comanda(items_data, total, comanda_id,
                                       correlativo=correlativo, correccion_de=correccion_de,
                                       tasa=self.tasa or None, cajero=registrado_por,
                                       mesa=self._mesa_ticket_label(),
                                       habitacion=self._habitacion_ticket_label())
            if not impreso:
                LocalReplica.eliminar_venta_y_movimientos(venta_id)
                venta_id = None
                self._show_snack("No se encontro impresora; la venta no se registro", color="#EF5350")
                return

            LocalReplica.cerrar_comanda(comanda_id)
            self.comanda_id = None
            self.items.clear()
            self._refrescar_comanda()
            self._show_snack(f"Comanda #{correlativo:05d} cobrada", color="#4CAF50")
        except Exception as ex:
            import traceback as tb
            tb.print_exc()
            if venta_id is not None:
                try:
                    LocalReplica.eliminar_venta_y_movimientos(venta_id)
                except Exception:
                    pass
            self._show_snack(f"Error: {ex}", color="#EF5350")

    def _actualizar_tasa(self):
        from usr.pos.tasa_cambio import actualizar_tasa, formatear_tasa, get_diagnostico
        try:
            tasa, cambiada, anterior = actualizar_tasa()
        except Exception as ex:
            self._show_snack(f"No se pudo consultar la tasa: {ex}", color="#EF5350")
            return
        self.tasa = tasa
        self._refrescar_comanda()
        fuente = get_diagnostico().split("|")[0].replace("Fuente:", "").strip()
        if cambiada:
            self._show_snack(f"Tasa {formatear_tasa(tasa)} Bs/$ ({fuente})", color="#4CAF50")
        else:
            self._show_snack(f"Tasa sin cambios ({formatear_tasa(tasa)} Bs/$ · {fuente})", color="#FF9800")

    def _show_snack(self, msg, color="#4CAF50"):
        from usr.notifications import show_success, show_error, show_warning, show_info
        try:
            if color == "#4CAF50":
                show_success(msg)
            elif color == "#EF5350":
                show_error(msg)
            elif color == "#FF9800":
                show_warning(msg)
            else:
                show_info(msg)
        except Exception as e:
            print(f"[COMANDA] Error mostrando snack: {e}")

    def _show_contornos_dialog(self, plato: dict, contornos: list):
        checks = {}
        for c in contornos:
            chk = ft.Checkbox(label=c.get('nombre', '?'), value=False)
            checks[str(c['id'])] = chk

        max_sel = 2
        max_text = ft.Text(f"Seleccione hasta {max_sel} contornos", size=12, color="#9E9E9E", italic=True)
        err_text = ft.Text("", size=11, color="#EF5350")

        def on_confirm(e):
            selected = [cid for cid, chk in checks.items() if chk.value]
            if not selected:
                err_text.value = "Seleccione al menos un contorno"
                err_text.update(); return
            if len(selected) > max_sel:
                err_text.value = f"Maximo {max_sel} contornos"
                err_text.update(); return
            ci = [c for c in contornos if str(c['id']) in selected]
            for item in self.items:
                if item['producto']['id'] == plato['id'] and not item.get('contornos_seleccionados'):
                    item['cantidad'] += 1
                    self._refrescar_comanda()
                    self._close_dialog()
                    return
            self.items.append({
                'producto': plato, 'cantidad': 1, 'tipo': 'plato',
                'contornos_seleccionados': selected,
                'contornos_info': ci,
            })
            self._refrescar_comanda()
            self._close_dialog()

        content = ft.Column([
            max_text, err_text,
            *[chk for chk in checks.values()],
        ], spacing=8, tight=True, scroll=ft.ScrollMode.AUTO)

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
                ft.Text(f"$ {precio:.2f}", size=11, color="#9E9E9E"),
            ]
            if item.get('contornos_info'):
                for ci in item['contornos_info']:
                    lines.append(ft.Text(f"+ {ci.get('nombre','?')}", size=10, color="#FF6F00"))
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
                        ft.Text(f"$ {subtotal:.2f}", size=14, weight=ft.FontWeight.BOLD, color="#4CAF50"),
                        ft.IconButton(icon=ft.Icons.DELETE_OUTLINE, icon_size=18, icon_color="#EF5350",
                                     on_click=lambda _, idx=i: self._eliminar_item(idx)),
                    ], spacing=2, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
                padding=ft.padding.symmetric(horizontal=10, vertical=4),
                bgcolor="#222222" if i % 2 == 0 else "#1A1A1A",
            ))
        self.txt_total.value = f"$ {total:.2f}"
        if self.tasa:
            from usr.pos.tasa_cambio import convertir, formatear_bs, formatear_tasa
            self.txt_total_bs.value = f"Bs {formatear_bs(convertir(total, self.tasa))}"
            self.txt_tasa_info.value = f"Tasa: {formatear_tasa(self.tasa)} Bs/$"
        else:
            self.txt_total_bs.value = "Bs --"
            self.txt_tasa_info.value = "Sin tasa"
        self.btn_guardar.disabled = len(self.items) == 0
        self.btn_cobrar.disabled = len(self.items) == 0
        self.btn_eliminar.disabled = self.comanda_id is None
        if self.page:
            self.update()

    def _cambiar_cantidad(self, idx, delta):
        if 0 <= idx < len(self.items):
            self.items[idx]['cantidad'] = max(1, self.items[idx]['cantidad'] + delta)
            self._refrescar_comanda()

    def _mesa_ticket_label(self) -> str:
        if not self.mesa:
            return ""
        numero = self.mesa.get('numero') or self.mesa.get('nombre') or ''
        nombre = self.mesa.get('nombre')
        if nombre and nombre != numero:
            return f"{numero} - {nombre}" if numero else nombre
        return numero or ""

    def _habitacion_ticket_label(self) -> str:
        if not self.habitacion:
            return ""
        numero = self.habitacion.get('numero') or ''
        piso = self.habitacion.get('piso')
        tipo = self.habitacion.get('tipo')
        etiqueta = numero
        if tipo:
            etiqueta = f"{tipo} {etiqueta}".strip()
        if piso:
            etiqueta = f"{etiqueta} - Piso {piso}"
        return etiqueta

    def _eliminar_item(self, idx):
        if 0 <= idx < len(self.items):
            self.items.pop(idx)
            self._refrescar_comanda()

    def _eliminar_comanda(self):
        if self.comanda_id is None:
            return
        self._close_dialog()
        self.active_dialog = ft.AlertDialog(
            modal=True,
            title=ft.Text("Eliminar comanda"),
            content=ft.Text("¿Eliminar esta comanda? Esta acción no se puede deshacer."),
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: self._close_dialog()),
                ft.ElevatedButton("Eliminar", bgcolor="#EF5350", color=ft.Colors.WHITE,
                                  on_click=lambda _: self._confirmar_eliminar()),
            ],
            actions_alignment=ft.MainAxisAlignment.END)
        if self.page:
            self.page.overlay.append(self.active_dialog)
            self.active_dialog.open = True
            self.page.update()

    def _confirmar_eliminar(self):
        self._close_dialog()
        try:
            LocalReplica.eliminar_comanda(self.comanda_id)
            self.comanda_id = None
            self.items.clear()
            if self.on_back:
                self.on_back()
            self._show_snack("Comanda eliminada", color="#4CAF50")
        except Exception as ex:
            import traceback as tb
            tb.print_exc()
            self._show_snack(f"Error: {ex}", color="#EF5350")

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
