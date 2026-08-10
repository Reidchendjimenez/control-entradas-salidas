"""Editor de recetas en pantalla completa (estilo wizard).

Reemplaza el antiguo `receta_dialog` (AlertDialog). Permite ver toda la
información cómodamente: header sticky, secciones scrolleables, tabla
de componentes con buscador de productos y resumen al pie.
"""
import flet as ft

from usr.database.local_replica import LocalReplica
from usr.notifications import show_success, show_error, show_warning
from usr.views.producciones import data
from usr.views.producciones.helpers import colors as _colors


class RecetaEditor(ft.Container):
    """Editor de receta en pantalla completa."""

    def __init__(self, page, productos, receta=None, on_saved=None, on_cancel=None):
        super().__init__()
        self.page = page
        self._productos = productos
        self._receta = receta
        self._on_saved = on_saved
        self._on_cancel = on_cancel
        self.is_edit = receta is not None
        self._running = False

        self.expand = True
        self.bgcolor = '#1A1A1A'
        self.padding = 0
        self.visible = True

        # refs a controles para lectura al guardar
        self._nombre = ft.Ref[ft.TextField]()
        self._cant_prod = ft.Ref[ft.TextField]()
        self._tipo_seg = ft.Ref[ft.SegmentedButton]()
        self._componentes_column = ft.Ref[ft.Column]()
        self._resumen_text = ft.Ref[ft.Text]()
        self._tipo_label = ft.Ref[ft.Text]()
        self._add_btn_text = ft.Ref[ft.Text]()
        self._comp_title = ft.Ref[ft.Text]()
        self._comp_sub = ft.Ref[ft.Text]()
        self._add_button = ft.Ref[ft.OutlinedButton]()

        self._build()

    # ----------------------- construcción -----------------------

    def _build(self):
        colors = _colors(self.page)
        receta = self._receta

        # Header sticky
        header = ft.Container(
            content=ft.Row([
                ft.IconButton(
                    icon=ft.Icons.ARROW_BACK,
                    icon_color=colors['text_primary'],
                    tooltip="Volver a Recetas",
                    on_click=lambda _: self._cancel(),
                ),
                ft.Icon(ft.Icons.DESCRIPTION_OUTLINED, color=colors['accent']),
                ft.Column([
                    ft.Text(
                        f"Editar Receta · {receta.get('nombre', '')}" if self.is_edit else "Nueva Receta",
                        size=20, weight=ft.FontWeight.BOLD, color=colors['text_primary'],
                    ),
                    ft.Text(
                        "Define cómo se fabrica este producto a partir de sus ingredientes.",
                        size=12, color=colors['text_secondary'],
                    ),
                ], spacing=2, expand=True),
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            padding=ft.Padding.only(left=16, right=20, top=12, bottom=12),
            bgcolor=colors['surface'],
            border=ft.Border(bottom=ft.BorderSide(1, colors['border'])),
        )

        # Footer sticky (se construye antes que sec3 para que las filas existentes
        # al editar puedan actualizar el resumen en su construcción).
        footer = self._build_footer(colors)

        # Sección 1 — Datos básicos
        sec1 = self._build_section_basicos(colors)

        # Sección 2 — Producto (base/final)
        sec2 = self._build_section_producto(colors)

        # Sección 3 — Componentes
        sec3 = self._build_section_componentes(colors)

        # Contenido scrolleable (Column con scroll evita problemas de ListView
        # con expand=True dentro de Containers con bgcolor transparente).
        content = ft.Container(
            content=ft.Column(
                controls=[sec1, sec2, sec3],
                spacing=20,
                scroll=ft.ScrollMode.AUTO,
                expand=True,
            ),
            padding=ft.Padding.all(20),
            expand=True,
        )

        self.content = ft.Column([
            header,
            content,
            footer,
        ], spacing=0, expand=True)

    def _build_section_basicos(self, colors):
        receta = self._receta
        sec = ft.Container(
            content=ft.Column([
                self._section_title("📋 Datos básicos", colors),
                ft.ResponsiveRow([
                    ft.Container(
                        content=ft.TextField(
                            ref=self._nombre,
                            label="Nombre de la Receta",
                            value=receta.get('nombre', '') if receta else '',
                            autofocus=not self.is_edit,
                            expand=True,
                        ),
                        col={"xs": 12, "sm": 8},
                    ),
                    ft.Container(
                        content=ft.TextField(
                            ref=self._cant_prod,
                            label="Cantidad Base (por batch)",
                            hint_text="Ej: 1 (kg, bandejas, unidades...)",
                            value=str(receta.get('cantidad_producida', 1)) if receta else "1",
                            keyboard_type=ft.KeyboardType.NUMBER,
                        ),
                        col={"xs": 12, "sm": 4},
                    ),
                ], spacing=12),
                ft.Container(height=8),
                ft.Text("Tipo de Receta", size=13, color=colors['text_secondary']),
                ft.SegmentedButton(
                    ref=self._tipo_seg,
                    allow_empty_selection=False,
                    selected={"compuesta" if (receta and receta.get('tipo') == 'compuesta') or not receta else "simple"},
                    segments=[
                        ft.Segment(value="simple", label=ft.Text("Simple · parte un producto en sus derivados")),
                        ft.Segment(value="compuesta", label=ft.Text("Compuesta · fabrica un producto desde ingredientes")),
                    ],
                    on_change=lambda _: self._on_tipo_change(),
                ),
            ], spacing=8),
            padding=ft.Padding.all(16),
            bgcolor=colors['surface'],
            border_radius=10,
            border=ft.Border.all(1, colors['border']),
        )
        return sec

    def _build_section_producto(self, colors):
        receta = self._receta
        is_simple = bool(receta) and receta.get('tipo') == 'simple'

        base_init = receta.get('producto_base_id') if (receta and receta.get('producto_base_id')) else None
        final_init = receta.get('producto_final_id') if (receta and receta.get('producto_final_id')) else None

        self._base_sel = self._build_producto_selector(
            colors, 'Producto Base (origen)', 'Producto que se va a partir/descomponer', base_init,
        )
        self._final_sel = self._build_producto_selector(
            colors, 'Producto Final (resultado)', 'Producto que se obtiene al fabricar', final_init,
        )

        self._base_container = ft.Container(
            content=self._base_sel, col={"xs": 12, "sm": 6},
            visible=is_simple,
        )
        self._final_container = ft.Container(
            content=self._final_sel, col={"xs": 12, "sm": 6},
            visible=not is_simple,
        )

        sec = ft.Container(
            content=ft.Column([
                self._section_title("🎯 Producto", colors),
                ft.Container(
                    content=ft.ResponsiveRow([
                        self._base_container,
                        self._final_container,
                    ], spacing=12),
                    padding=ft.Padding.only(top=4, bottom=4),
                ),
            ], spacing=8),
            padding=ft.Padding.all(16),
            bgcolor=colors['surface'],
            border_radius=10,
            border=ft.Border.all(1, colors['border']),
        )
        return sec

    def _build_producto_selector(self, colors, label, hint, initial_id):
        """Selector de producto con buscador (estilo sección de componentes).

        Muestra un campo de búsqueda; los aciertos aparecen debajo para elegir
        uno (selección única). Retorna un Container con el buscador y la selección.
        """
        state = {'id': None, 'nombre': ''}
        if initial_id:
            p = next((x for x in self._productos if x['id'] == int(initial_id)), None)
            if p:
                state['id'] = p['id']
                state['nombre'] = p.get('nombre', '')

        search = ft.TextField(
            label=hint or "Buscar producto...",
            hint_text="Escribe el nombre...",
            prefix_icon=ft.Icons.SEARCH,
            expand=True,
        )
        results = ft.Column(spacing=4)

        def _on_type(e):
            texto = (e.control.value or "").lower().strip()
            results.controls.clear()
            resultados = []
            if texto:
                for p in self._productos:
                    if p.get('activo') and texto in p.get('nombre', '').lower():
                        resultados.append(p)
            for p in resultados[:6]:
                stock = self._stock_total(p['id'])
                results.controls.append(
                    ft.Container(
                        content=ft.Row([
                            ft.Column([
                                ft.Text(p.get('nombre', ''), weight=ft.FontWeight.W_500),
                                ft.Text(
                                    f"Stock: {stock:.2f} {p.get('unidad_medida', 'unidad')}",
                                    size=11, color=colors['text_hint'],
                                ),
                            ], spacing=2, expand=True),
                            ft.Icon(ft.Icons.CHECK_CIRCLE_OUTLINE, size=18, color=colors['accent']),
                        ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
                        padding=ft.Padding.symmetric(horizontal=10, vertical=6),
                        border_radius=6,
                        border=ft.Border.all(1, colors['border']),
                        ink=True,
                        on_click=lambda _, prod=p: _elegir(prod),
                    )
                )
            if not resultados:
                results.controls.append(
                    ft.Container(
                        content=ft.Text("Sin resultados", size=12, color=colors['text_hint']),
                        padding=ft.Padding.all(8),
                    )
                )
            self._safe_update(results)

        def _elegir(prod):
            state['id'] = prod['id']
            state['nombre'] = prod.get('nombre', '')
            selector._sel_id = state['id']
            selector._sel_nombre = state['nombre']
            search.value = prod.get('nombre', '')
            results.controls.clear()
            self._safe_update(search)
            self._safe_update(results)
            self._safe_update(selected_row)

        def _limpiar(e=None):
            state['id'] = None
            state['nombre'] = ''
            selector._sel_id = None
            selector._sel_nombre = ''
            search.value = ''
            results.controls.clear()
            self._safe_update(search)
            self._safe_update(results)
            self._safe_update(selected_row)

        selected_row = ft.Container(
            content=ft.Row([
                ft.Icon(ft.Icons.INVENTORY_2_OUTLINED, size=16, color=colors['accent']),
                ft.Text(
                    state['nombre'] if state['id'] else "Ninguno seleccionado",
                    size=13, weight=ft.FontWeight.W_500,
                    color=colors['text_primary'],
                    expand=True,
                ),
                ft.IconButton(
                    icon=ft.Icons.CLOSE,
                    tooltip="Limpiar selección",
                    on_click=_limpiar,
                    visible=bool(state['id']),
                ),
            ], spacing=6, vertical_alignment=ft.CrossAxisAlignment.CENTER),
            padding=ft.Padding.symmetric(horizontal=10, vertical=6),
            bgcolor=colors['card_hover'],
            border_radius=8,
        )

        search.on_change = _on_type

        selector = ft.Column([
            search,
            results,
            ft.Container(height=4),
            selected_row,
        ], spacing=6, tight=True, visible=True)
        selector._sel_id = state['id']
        selector._sel_nombre = state['nombre']

        return selector

    def _build_section_componentes(self, colors):
        receta = self._receta

        # Buscador de productos para agregar
        self._buscador = ft.TextField(
            label="Buscar producto para agregar",
            hint_text="Escribe el nombre...",
            prefix_icon=ft.Icons.SEARCH,
            on_change=lambda e: self._on_search(e.control.value or ""),
            expand=True,
        )
        self._search_results = ft.Column(spacing=4)

        # Tabla de componentes
        self._componentes_list_ref = ft.Column(spacing=6, ref=self._componentes_column)
        self._render_component_rows()

        is_simple = self._current_tipo() == 'simple'
        comp_title = ft.Text(
            "🎯 Producto final" if is_simple else "🧩 Ingredientes",
            size=15, weight=ft.FontWeight.BOLD, color=colors['text_primary'],
            ref=self._comp_title,
        )
        comp_sub = ft.Text(
            "Productos resultantes (lo que se obtiene)" if is_simple
            else "Ingredientes (lo que se consume)",
            size=12, color=colors['text_hint'], italic=True,
            ref=self._comp_sub,
        )
        add_btn = ft.OutlinedButton(
            icon=ft.Icons.ADD,
            content=ft.Text(
                "+ Agregar ingrediente" if is_simple else "+ Agregar manualmente",
                ref=self._add_btn_text,
            ),
            on_click=lambda _: self._add_empty_row(),
            ref=self._add_button,
        )

        sec = ft.Container(
            content=ft.Column([
                comp_title,
                ft.Row([
                    ft.Icon(ft.Icons.INFO_OUTLINE, size=14, color=colors['text_hint']),
                    comp_sub,
                ], spacing=4),
                ft.Container(height=8),
                ft.Row([self._buscador], spacing=8),
                ft.Container(content=self._search_results, padding=ft.Padding.only(top=4, bottom=4)),
                ft.Divider(height=1, color=colors['border']),
                ft.Container(
                    content=self._componentes_list_ref,
                    padding=ft.Padding.only(top=4),
                ),
                add_btn,
            ], spacing=8),
            padding=ft.Padding.all(16),
            bgcolor=colors['surface'],
            border_radius=10,
            border=ft.Border.all(1, colors['border']),
        )
        return sec

    def _build_footer(self, colors):
        resumen_text = ft.Text(
            "", size=13, color=colors['text_secondary'], weight=ft.FontWeight.W_500,
            ref=self._resumen_text,
        )
        self._resumen_text_ref = resumen_text

        footer = ft.Container(
            content=ft.Column([
                resumen_text,
                ft.ResponsiveRow([
                    ft.Container(
                        content=ft.OutlinedButton(
                            content="Cancelar",
                            on_click=lambda _: self._cancel(),
                            expand=True,
                        ),
                        col={"xs": 6, "sm": 2},
                    ),
                    ft.Container(
                        content=ft.ElevatedButton(
                            content="💾 Guardar Receta",
                            icon=ft.Icons.SAVE_OUTLINED,
                            bgcolor=colors['accent'],
                            color=colors.get('white', ft.Colors.WHITE),
                            on_click=lambda _: self._save(),
                            expand=True,
                        ),
                        col={"xs": 6, "sm": 4},
                    ),
                ], spacing=8, alignment=ft.MainAxisAlignment.END),
            ], spacing=6),
            padding=ft.Padding.only(left=16, right=16, top=12, bottom=12),
            bgcolor=colors['surface'],
            border=ft.Border(top=ft.BorderSide(1, colors['border'])),
        )
        return footer

    def _section_title(self, title, colors):
        return ft.Text(
            title, size=15, weight=ft.FontWeight.BOLD, color=colors['text_primary'],
        )

    def _safe_update(self, control):
        """Llama control.update() solo si el control ya está añadido a la página."""
        if control is None:
            return
        try:
            if getattr(control, 'page', None) is not None:
                control.update()
        except (AssertionError, Exception):
            pass

    # ----------------------- helpers de productos -----------------------

    def _product_options(self):
        return [
            ft.dropdown.Option(key=str(p['id']), text=f"{p['nombre']} ({p.get('tipo', 'N/A')})")
            for p in self._productos if p.get('activo')
        ]

    def _on_search(self, texto):
        texto = (texto or "").lower().strip()
        self._search_results.controls.clear()
        if not texto:
            self._search_results.update()
            return
        resultados = [p for p in self._productos if p.get('activo') and texto in p.get('nombre', '').lower()][:8]
        if not resultados:
            self._search_results.controls.append(
                ft.Container(
                    content=ft.Text("Sin resultados", size=12, color=_colors(self.page)['text_hint']),
                    padding=ft.Padding.all(8),
                )
            )
        else:
            for p in resultados:
                stock = self._stock_total(p['id'])
                es_pesable = bool(p.get('es_pesable'))
                unidad = p.get('unidad_medida', 'unidad')
                self._search_results.controls.append(
                    ft.Container(
                        content=ft.Row([
                            ft.Column([
                                ft.Text(p.get('nombre', ''), weight=ft.FontWeight.W_500),
                                ft.Text(
                                    f"Stock: {stock:.2f} {unidad}" + (" · pesable" if es_pesable else ""),
                                    size=11,
                                    color=_colors(self.page)['text_hint'],
                                ),
                            ], spacing=2, expand=True),
                            ft.IconButton(
                                icon=ft.Icons.ADD_CIRCLE,
                                tooltip="Agregar a la receta",
                                on_click=lambda _, prod=p: self._add_product(prod),
                            ),
                        ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
                        padding=ft.Padding.symmetric(horizontal=10, vertical=6),
                        border_radius=6,
                        border=ft.Border.all(1, _colors(self.page)['border']),
                        ink=True,
                        on_click=lambda _, prod=p: self._add_product(prod),
                    )
                )
        if self.page:
            self._search_results.update()

    def _stock_total(self, producto_id):
        try:
            return data.stock_total_producto(producto_id)
        except Exception:
            return 0.0

    # ----------------------- gestión de filas -----------------------

    def _add_empty_row(self):
        is_simple = self._current_tipo() == 'simple'
        self._add_row({
            'tipo_componente': 'RESULTADO' if is_simple else 'INGREDIENTE',
        })
        self._buscador.value = ""
        self._search_results.controls.clear()
        if self.page:
            self._buscador.update()
            self._search_results.update()

    def _add_product(self, prod):
        is_simple = self._current_tipo() == 'simple'
        es_pesable = bool(prod.get('es_pesable'))
        unidad = 'kg' if es_pesable else prod.get('unidad_medida', 'unidad')
        self._add_row({
            'producto_id': prod['id'],
            'nombre': prod.get('nombre', ''),
            'cantidad': 1.0,
            'unidad': unidad,
            'es_pesable': es_pesable,
            'peso_variable': False,
            'tipo_componente': 'RESULTADO' if is_simple else 'INGREDIENTE',
        })
        self._buscador.value = ""
        self._search_results.controls.clear()
        if self.page:
            self._buscador.update()
            self._search_results.update()

    def _add_row(self, item):
        is_simple = self._current_tipo() == 'simple'

        prod_dd = ft.Dropdown(
            options=self._product_options(),
            value=str(item['producto_id']) if item.get('producto_id') else None,
            hint_text="Producto...",
            expand=True,
            width=280,
        )
        cant_field = ft.TextField(
            value=str(item.get('cantidad', 1)),
            keyboard_type=ft.KeyboardType.NUMBER,
            width=110,
            hint_text="Cant.",
        )
        unidad_field = ft.TextField(
            value=item.get('unidad', 'unidad'),
            width=100,
            hint_text="unidad",
        )

        def _remove(e):
            self._componentes_list_ref.controls.remove(row)
            if self.page:
                self._componentes_list_ref.update()
            self._update_resumen()

        row = ft.Container(
            content=ft.ResponsiveRow([
                ft.Container(content=prod_dd, col={"xs": 12, "sm": 6}),
                ft.Container(content=cant_field, col={"xs": 6, "sm": 2}),
                ft.Container(content=unidad_field, col={"xs": 4, "sm": 2}),
                ft.Container(
                    content=ft.IconButton(
                        icon=ft.Icons.DELETE_OUTLINE,
                        icon_color='#F44336',
                        tooltip="Quitar",
                        on_click=_remove,
                    ),
                    col={"xs": 2, "sm": 2},
                    alignment=ft.Alignment.CENTER_right,
                ),
            ], spacing=8, vertical_alignment=ft.CrossAxisAlignment.CENTER),
            padding=ft.Padding.all(8),
            border_radius=8,
            border=ft.Border.all(1, _colors(self.page)['border']),
        )
        self._componentes_list_ref.controls.append(row)
        self._safe_update(self._componentes_list_ref)
        self._update_resumen()

    def _render_component_rows(self):
        if not self._receta:
            return
        componentes = data.load_componentes(self._receta['id'])
        for comp in componentes:
            self._add_row(comp)

    def _update_resumen(self):
        total = len(self._componentes_list_ref.controls)
        txt = f"📊 {total} componentes · cantidad editable al descargar"
        self._resumen_text_ref.value = txt
        self._safe_update(self._resumen_text_ref)

    # ----------------------- helpers de estado -----------------------

    def _current_tipo(self):
        seg = self._tipo_seg.current
        if not seg or not seg.selected:
            return "compuesta"
        return "simple" if "simple" in seg.selected else "compuesta"

    def _on_tipo_change(self):
        is_simple = self._current_tipo() == 'simple'
        self._base_container.visible = is_simple
        self._final_container.visible = not is_simple
        if self._comp_title.current:
            self._comp_title.current.value = "🎯 Producto final" if is_simple else "🧩 Ingredientes"
        if self._comp_sub.current:
            self._comp_sub.current.value = \
                "Productos resultantes (lo que se obtiene)" if is_simple \
                else "Ingredientes (lo que se consume)"
        if self._add_btn_text.current:
            self._add_btn_text.current.value = "+ Agregar ingrediente" if is_simple else "+ Agregar manualmente"
        if self.page:
            for c in (self._base_container, self._final_container,
                      self._comp_title, self._comp_sub, self._add_btn_text):
                c.current.update() if c.current else None

        if self._componentes_list_ref.controls:
            show_warning("Cambiar de tipo puede requerir redefinir los componentes.")
            # Reasignar tipo_componente según nueva selección
            for row in self._componentes_list_ref.controls:
                pass  # el tipo se evalúa al guardar

    # ----------------------- guardar / cancelar -----------------------

    def _save(self):
        nombre = (self._nombre.current.value or '').strip()
        if not nombre:
            self._nombre.current.error_text = "Requerido"
            self._nombre.current.update()
            return

        try:
            cantidad = float(self._cant_prod.current.value or 1)
        except (ValueError, TypeError):
            self._cant_prod.current.error_text = "Número válido"
            self._cant_prod.current.update()
            return

        is_simple = self._current_tipo() == 'simple'

        receta_data = {
            'nombre': nombre,
            'tipo': "simple" if is_simple else "compuesta",
            'cantidad_producida': cantidad,
        }

        if is_simple:
            base_id = self._base_sel._sel_id
            if not base_id:
                show_warning("Selecciona el producto base")
                return
            receta_data['producto_base_id'] = base_id
            receta_data['producto_final_id'] = None
        else:
            final_id = self._final_sel._sel_id
            if not final_id:
                show_warning("Selecciona el producto final")
                return
            receta_data['producto_final_id'] = final_id
            receta_data['producto_base_id'] = None

        if self.is_edit:
            receta_data['id'] = self._receta['id']
            receta_data['activo'] = self._receta.get('activo', True)

        componentes = []
        for row in self._componentes_list_ref.controls:
            rr = row.content
            prod_dd = rr.controls[0].content
            cant_field = rr.controls[1].content
            unidad_field = rr.controls[2].content
            if not prod_dd.value:
                continue
            componentes.append({
                'producto_id': int(prod_dd.value),
                'cantidad': float(cant_field.value or 1),
                'unidad': (unidad_field.value or 'unidad').strip() or 'unidad',
                'tipo_componente': 'RESULTADO' if is_simple else 'INGREDIENTE',
                'peso_variable': 0,
            })

        receta_data['_componentes'] = componentes
        try:
            data.guardar_receta(receta_data)
        except Exception as ex:
            show_error(f"Error al guardar receta: {ex}")
            return

        show_success("Receta guardada correctamente")
        if self._on_saved:
            self._on_saved()
        self._close()

    def _cancel(self):
        if self._on_cancel:
            self._on_cancel()
        self._close()

    def _close(self):
        self.visible = False
        if self.page:
            self.page.update()
