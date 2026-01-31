import flet as ft
from app.database.base import get_db
from app.models import Producto, Movimiento, Categoria


class StockView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.padding = ft.padding.all(16)
        
        # Componentes UI
        self.categoria_filter = None
        self.search_field = None
        self.productos_list = None
        self.stats_row = None
        
        self._build_ui()
    
    def did_mount(self):
        """Se ejecuta despues de que la vista se agrega a la pagina"""
        self._load_productos()
        self._load_categorias()
    
    def _build_ui(self):
        """Construir la interfaz de usuario"""
        # Titulo
        title = ft.Text(
            "Consulta de Stock",
            size=24,
            weight=ft.FontWeight.BOLD,
            color=ft.colors.ON_SURFACE,
        )
        
        # Filtros
        self.search_field = ft.TextField(
            label="Buscar producto...",
            prefix_icon=ft.icons.SEARCH,
            border_radius=ft.border_radius.all(12),
            expand=True,
            on_change=self._filter_productos,
        )
        
        self.categoria_filter = ft.Dropdown(
            label="Categoria",
            border_radius=ft.border_radius.all(12),
            width=200,
            on_change=self._filter_productos,
        )
        
        filters_row = ft.Row(
            [
                self.search_field,
                self.categoria_filter,
            ],
            spacing=16,
            vertical_alignment=ft.CrossAxisAlignment.END,
        )
        
        # Lista de productos
        self.productos_list = ft.ListView(
            expand=True,
            spacing=8,
            padding=ft.padding.all(8),
        )
        
        # Contenedor principal
        self.content = ft.Column(
            [
                title,
                ft.Divider(height=1),
                ft.Container(height=16),
                self._build_summary_section(),
                ft.Container(height=16),
                filters_row,
                ft.Container(height=8),
                ft.Text(
                    "Productos en Inventario",
                    size=16,
                    weight=ft.FontWeight.W_500,
                ),
                ft.Container(height=8),
                self.productos_list,
            ],
            expand=True,
            spacing=0,
        )
        # NOTA: _load_categorias() se llama en did_mount() para evitar error "Control must be added to page first"
    
    def _build_summary_section(self):
        """Construir seccion de resumen"""
        self.total_productos_text = ft.Text("0", size=24, weight=ft.FontWeight.BOLD, color=ft.colors.PRIMARY)
        self.stock_bajo_text = ft.Text("0", size=24, weight=ft.FontWeight.BOLD, color=ft.colors.ORANGE)
        self.sin_stock_text = ft.Text("0", size=24, weight=ft.FontWeight.BOLD, color=ft.colors.ERROR)
        
        summary_card = ft.Card(
            content=ft.Container(
                content=ft.Row(
                    [
                        self._create_summary_item("Total Productos", self.total_productos_text),
                        self._create_summary_item("Stock Bajo", self.stock_bajo_text, ft.colors.ORANGE),
                        self._create_summary_item("Sin Stock", self.sin_stock_text, ft.colors.ERROR),
                    ],
                    alignment=ft.MainAxisAlignment.SPACE_AROUND,
                ),
                padding=ft.padding.all(16),
            ),
            elevation=2,
        )
        return summary_card
    
    def _create_summary_item(self, label: str, value_text, color=ft.colors.PRIMARY):
        """Crear item de resumen"""
        return ft.Column(
            [
                value_text,
                ft.Text(
                    label,
                    size=14,
                    color=ft.colors.ON_SURFACE_VARIANT,
                ),
            ],
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=4,
        )

    def _min_required_icon(self):
        """Devuelve el icono MINIMUM_REQUIRED si existe, o un fallback seguro."""
        # fallback a INFO si MINIMUM_REQUIRED no existe en la versión instalada
        return getattr(ft.icons, "MINIMUM_REQUIRED", ft.icons.INFO)
    
    def _load_categorias(self):
        """Cargar categorias para el filtro"""
        try:
            db = next(get_db())
            categorias = db.query(Categoria).filter(Categoria.activo == True).all()
            
            self.categoria_filter.options = [
                ft.dropdown.Option("", "Todas las categorias")
            ]
            
            for categoria in categorias:
                self.categoria_filter.options.append(
                    ft.dropdown.Option(str(categoria.id), categoria.nombre)
                )
            
            self.categoria_filter.value = ""
            self.update()
            
        except Exception as ex:
            print(f"Error cargando categorias: {ex}")
        finally:
            db.close()
    
    def _load_productos(self):
        """Cargar productos desde la base de datos"""
        try:
            db = next(get_db())
            productos = db.query(Producto).filter(Producto.activo == True).all()
            
            # Calcular estadisticas
            total = len(productos)
            stock_bajo = sum(1 for p in productos if 0 < p.stock_actual <= p.stock_minimo)
            sin_stock = sum(1 for p in productos if p.stock_actual <= 0)
            
            # Actualizar textos de resumen
            if hasattr(self, 'total_productos_text'):
                self.total_productos_text.value = str(total)
                self.stock_bajo_text.value = str(stock_bajo)
                self.sin_stock_text.value = str(sin_stock)
            
            self.productos_list.controls.clear()
            
            if not productos:
                self.productos_list.controls.append(
                    ft.Container(
                        content=ft.Column(
                            [
                                ft.Icon(
                                    ft.icons.INVENTORY_2,
                                    size=48,
                                    color=ft.colors.OUTLINE,
                                ),
                                ft.Text(
                                    "No hay productos registrados",
                                    size=16,
                                    color=ft.colors.ON_SURFACE_VARIANT,
                                    text_align=ft.TextAlign.CENTER,
                                ),
                            ],
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            spacing=16,
                        ),
                        alignment=ft.alignment.center,
                        padding=ft.padding.all(32),
                    )
                )
            else:
                for producto in productos:
                    # Determinar color segun stock
                    if producto.stock_actual <= 0:
                        stock_color = ft.colors.ERROR
                        status_icon = ft.icons.ERROR
                    elif producto.stock_actual <= producto.stock_minimo:
                        stock_color = ft.colors.ORANGE
                        status_icon = ft.icons.WARNING
                    else:
                        stock_color = ft.colors.GREEN
                        status_icon = ft.icons.CHECK_CIRCLE
                    
                    # Card de producto
                    card = ft.Card(
                        content=ft.Container(
                            content=ft.Column(
                                [
                                    ft.ListTile(
                                        leading=ft.Container(
                                            content=ft.Icon(
                                                status_icon,
                                                color=stock_color,
                                                size=28,
                                            ),
                                            bgcolor=ft.colors.with_opacity(0.1, stock_color),
                                            border_radius=ft.border_radius.all(8),
                                            padding=ft.padding.all(8),
                                        ),
                                        title=ft.Text(
                                            producto.nombre,
                                            weight=ft.FontWeight.BOLD,
                                            size=16,
                                        ),
                                        subtitle=ft.Column(
                                            [
                                                ft.Text(
                                                    f"Categoria: {producto.categoria.nombre if producto.categoria else 'N/A'}",
                                                    size=14,
                                                ),
                                                ft.Text(
                                                    f"Codigo: {producto.codigo or 'N/A'}",
                                                    size=14,
                                                    color=ft.colors.ON_SURFACE_VARIANT,
                                                ),
                                            ],
                                            spacing=2,
                                        ),
                                        trailing=ft.Column(
                                            [
                                                ft.Text(
                                                    f"{producto.stock_actual:.2f}",
                                                    size=24,
                                                    weight=ft.FontWeight.BOLD,
                                                    color=stock_color,
                                                ),
                                                ft.Text(
                                                    producto.unidad_medida,
                                                    size=12,
                                                    color=ft.colors.ON_SURFACE_VARIANT,
                                                ),
                                            ],
                                            horizontal_alignment=ft.CrossAxisAlignment.END,
                                            spacing=0,
                                        ),
                                        on_click=lambda e, p=producto: self._show_producto_details(p),
                                    ),
                                    ft.Container(
                                        content=ft.Row(
                                            [
                                                ft.Row(
                                                    [
                                                        ft.Icon(
                                                            self._min_required_icon(),
                                                            size=14,
                                                            color=ft.colors.ON_SURFACE_VARIANT,
                                                        ),
                                                        ft.Text(
                                                            f"Min: {producto.stock_minimo:.2f}",
                                                            size=12,
                                                            color=ft.colors.ON_SURFACE_VARIANT,
                                                        ),
                                                    ],
                                                    spacing=4,
                                                ),
                                                ft.TextButton(
                                                    "Ver Detalles",
                                                    on_click=lambda e, p=producto: self._show_producto_details(p),
                                                ),
                                            ],
                                            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                                            vertical_alignment=ft.CrossAxisAlignment.CENTER,
                                        ),
                                        padding=ft.padding.symmetric(horizontal=16, vertical=8),
                                        bgcolor=ft.colors.SURFACE_VARIANT,
                                    ),
                                ],
                                spacing=0,
                            ),
                            padding=ft.padding.all(0),
                        ),
                        elevation=1,
                        shape=ft.RoundedRectangleBorder(radius=12),
                    )
                    
                    self.productos_list.controls.append(card)
            
            self.update()
            
        except Exception as ex:
            print(f"Error cargando productos: {ex}")
            self._show_error("Error al cargar productos")
        finally:
            db.close()
    
    def _filter_productos(self, e):
        """Filtrar productos segun busqueda y categoria"""
        try:
            db = next(get_db())
            
            query = db.query(Producto).filter(Producto.activo == True)
            
            # Filtrar por categoria
            if self.categoria_filter.value:
                query = query.filter(Producto.categoria_id == int(self.categoria_filter.value))
            
            # Filtrar por busqueda
            search_term = self.search_field.value.lower().strip() if self.search_field.value else ""
            if search_term:
                query = query.filter(
                    (Producto.nombre.ilike(f"%{search_term}%")) |
                    (Producto.codigo.ilike(f"%{search_term}%"))
                )
            
            productos = query.all()
            
            # Calcular estadisticas filtradas
            total = len(productos)
            stock_bajo = sum(1 for p in productos if 0 < p.stock_actual <= p.stock_minimo)
            sin_stock = sum(1 for p in productos if p.stock_actual <= 0)
            
            # Actualizar textos de resumen
            if hasattr(self, 'total_productos_text'):
                self.total_productos_text.value = str(total)
                self.stock_bajo_text.value = str(stock_bajo)
                self.sin_stock_text.value = str(sin_stock)
            
            self.productos_list.controls.clear()
            
            if not productos:
                self.productos_list.controls.append(
                    ft.Container(
                        content=ft.Column(
                            [
                                ft.Icon(
                                    ft.icons.SEARCH_OFF,
                                    size=48,
                                    color=ft.colors.OUTLINE,
                                ),
                                ft.Text(
                                    "No se encontraron productos",
                                    size=16,
                                    color=ft.colors.ON_SURFACE_VARIANT,
                                    text_align=ft.TextAlign.CENTER,
                                ),
                            ],
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            spacing=16,
                        ),
                        alignment=ft.alignment.center,
                        padding=ft.padding.all(32),
                    )
                )
            else:
                for producto in productos:
                    # Determinar color segun stock
                    if producto.stock_actual <= 0:
                        stock_color = ft.colors.ERROR
                        status_icon = ft.icons.ERROR
                    elif producto.stock_actual <= producto.stock_minimo:
                        stock_color = ft.colors.ORANGE
                        status_icon = ft.icons.WARNING
                    else:
                        stock_color = ft.colors.GREEN
                        status_icon = ft.icons.CHECK_CIRCLE
                    
                    card = ft.Card(
                        content=ft.Container(
                            content=ft.Column(
                                [
                                    ft.ListTile(
                                        leading=ft.Container(
                                            content=ft.Icon(
                                                status_icon,
                                                color=stock_color,
                                                size=28,
                                            ),
                                            bgcolor=ft.colors.with_opacity(0.1, stock_color),
                                            border_radius=ft.border_radius.all(8),
                                            padding=ft.padding.all(8),
                                        ),
                                        title=ft.Text(
                                            producto.nombre,
                                            weight=ft.FontWeight.BOLD,
                                            size=16,
                                        ),
                                        subtitle=ft.Column(
                                            [
                                                ft.Text(
                                                    f"Categoria: {producto.categoria.nombre if producto.categoria else 'N/A'}",
                                                    size=14,
                                                ),
                                                ft.Text(
                                                    f"Codigo: {producto.codigo or 'N/A'}",
                                                    size=14,
                                                    color=ft.colors.ON_SURFACE_VARIANT,
                                                ),
                                            ],
                                            spacing=2,
                                        ),
                                        trailing=ft.Column(
                                            [
                                                ft.Text(
                                                    f"{producto.stock_actual:.2f}",
                                                    size=24,
                                                    weight=ft.FontWeight.BOLD,
                                                    color=stock_color,
                                                ),
                                                ft.Text(
                                                    producto.unidad_medida,
                                                    size=12,
                                                    color=ft.colors.ON_SURFACE_VARIANT,
                                                ),
                                            ],
                                            horizontal_alignment=ft.CrossAxisAlignment.END,
                                            spacing=0,
                                        ),
                                        on_click=lambda e, p=producto: self._show_producto_details(p),
                                    ),
                                    ft.Container(
                                        content=ft.Row(
                                            [
                                                ft.Row(
                                                    [
                                                        ft.Icon(
                                                            self._min_required_icon(),
                                                            size=14,
                                                            color=ft.colors.ON_SURFACE_VARIANT,
                                                        ),
                                                        ft.Text(
                                                            f"Min: {producto.stock_minimo:.2f}",
                                                            size=12,
                                                            color=ft.colors.ON_SURFACE_VARIANT,
                                                        ),
                                                    ],
                                                    spacing=4,
                                                ),
                                                ft.TextButton(
                                                    "Ver Detalles",
                                                    on_click=lambda e, p=producto: self._show_producto_details(p),
                                                ),
                                            ],
                                            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                                            vertical_alignment=ft.CrossAxisAlignment.CENTER,
                                        ),
                                        padding=ft.padding.symmetric(horizontal=16, vertical=8),
                                        bgcolor=ft.colors.SURFACE_VARIANT,
                                    ),
                                ],
                                spacing=0,
                            ),
                            padding=ft.padding.all(0),
                        ),
                        elevation=1,
                        shape=ft.RoundedRectangleBorder(radius=12),
                    )
                    
                    self.productos_list.controls.append(card)
            
            self.update()
            
        except Exception as ex:
            print(f"Error filtrando productos: {ex}")
            self._show_error("Error al filtrar productos")
        finally:
            db.close()
    
    def _show_producto_details(self, producto: Producto):
        """Mostrar detalles del producto"""
        try:
            db = next(get_db())
            
            # Historial de movimientos recientes
            movimientos = db.query(Movimiento).filter(
                Movimiento.producto_id == producto.id
            ).order_by(Movimiento.fecha_movimiento.desc()).limit(10).all()
            
            # Lista de movimientos
            movimientos_list = ft.ListView(
                spacing=4,
                padding=ft.padding.all(8),
                height=200,
            )
            
            if movimientos:
                for mov in movimientos:
                    # Icono segun tipo de movimiento
                    if mov.tipo == "entrada":
                        icon = ft.icons.ARROW_FORWARD
                        icon_color = ft.colors.GREEN
                    elif mov.tipo == "salida":
                        icon = ft.icons.ARROW_BACK
                        icon_color = ft.colors.RED
                    else:
                        icon = ft.icons.SWAP_HORIZ
                        icon_color = ft.colors.ORANGE
                    
                    movimientos_list.controls.append(
                        ft.ListTile(
                            leading=ft.Container(
                                content=ft.Icon(icon, size=24, color=icon_color),
                                # CORRECCION: usar ft.colors.with_opacity(opacity, color)
                                bgcolor=ft.colors.with_opacity(0.1, icon_color),
                                border_radius=ft.border_radius.all(8),
                                padding=ft.padding.all(4),
                            ),
                            title=ft.Text(
                                f"{mov.tipo.capitalize()}: {mov.cantidad:.2f} {producto.unidad_medida}",
                                size=14,
                                weight=ft.FontWeight.MEDIUM,
                            ),
                            subtitle=ft.Text(
                                mov.fecha_movimiento.strftime("%d/%m/%Y %H:%M") if mov.fecha_movimiento else "",
                                size=12,
                                color=ft.colors.ON_SURFACE_VARIANT,
                            ),
                            dense=True,
                        )
                    )
            else:
                movimientos_list.controls.append(
                    ft.Container(
                        content=ft.Column(
                            [
                                ft.Icon(
                                    ft.icons.HISTORY,
                                    size=32,
                                    color=ft.colors.OUTLINE,
                                ),
                                ft.Text(
                                    "No hay movimientos registrados",
                                    size=14,
                                    color=ft.colors.ON_SURFACE_VARIANT,
                                    text_align=ft.TextAlign.CENTER,
                                ),
                            ],
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            spacing=8,
                        ),
                        alignment=ft.alignment.center,
                        padding=ft.padding.all(16),
                    )
                )
            
            # Determinar color de estado
            if producto.stock_actual <= 0:
                estado_color = ft.colors.ERROR
                estado_texto = "Sin Stock"
            elif producto.stock_actual <= producto.stock_minimo:
                estado_color = ft.colors.ORANGE
                estado_texto = "Stock Bajo"
            else:
                estado_color = ft.colors.GREEN
                estado_texto = "Stock OK"
            
            # Contenido del dialogo
            content = ft.Column(
                [
                    ft.Row(
                        [
                            ft.Icon(
                                ft.icons.INVENTORY,
                                size=32,
                                color=ft.colors.PRIMARY,
                            ),
                            ft.Column(
                                [
                                    ft.Text(
                                        producto.nombre,
                                        size=20,
                                        weight=ft.FontWeight.BOLD,
                                    ),
                                    ft.Text(
                                        f"Codigo: {producto.codigo or 'N/A'}",
                                        size=14,
                                        color=ft.colors.ON_SURFACE_VARIANT,
                                    ),
                                ],
                                spacing=2,
                            ),
                        ],
                        spacing=16,
                    ),
                    ft.Divider(),
                    ft.Row(
                        [
                            ft.Column(
                                [
                                    ft.Text("Stock Actual", size=14, color=ft.colors.ON_SURFACE_VARIANT),
                                    ft.Text(
                                        f"{producto.stock_actual:.2f}",
                                        size=28,
                                        weight=ft.FontWeight.BOLD,
                                        color=estado_color,
                                    ),
                                ],
                                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            ),
                            ft.Column(
                                [
                                    ft.Text("Stock Minimo", size=14, color=ft.colors.ON_SURFACE_VARIANT),
                                    ft.Text(
                                        f"{producto.stock_minimo:.2f}",
                                        size=28,
                                        weight=ft.FontWeight.BOLD,
                                    ),
                                ],
                                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            ),
                            ft.Column(
                                [
                                    ft.Text("Unidad", size=14, color=ft.colors.ON_SURFACE_VARIANT),
                                    ft.Text(
                                        producto.unidad_medida,
                                        size=28,
                                        weight=ft.FontWeight.BOLD,
                                    ),
                                ],
                                horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            ),
                        ],
                        alignment=ft.MainAxisAlignment.SPACE_AROUND,
                    ),
                    ft.Container(
                        content=ft.Row(
                            [
                                ft.Icon(ft.icons.CIRCLE, size=12, color=estado_color),
                                ft.Text(estado_texto, size=14, color=estado_color, weight=ft.FontWeight.MEDIUM),
                            ],
                            spacing=8,
                        ),
                        # CORRECCION: usar ft.colors.with_opacity(opacity, color)
                        bgcolor=ft.colors.with_opacity(0.1, estado_color),
                        padding=ft.padding.symmetric(horizontal=16, vertical=8),
                        border_radius=ft.border_radius.all(8),
                        alignment=ft.alignment.center,
                    ),
                    ft.Divider(),
                    ft.Text("Movimientos Recientes", size=16, weight=ft.FontWeight.W_500),
                    movimientos_list,
                ],
                spacing=12,
                scroll=ft.ScrollMode.AUTO,
            )
            
            self.dialog_producto = ft.AlertDialog(
                title=ft.Text("Detalles del Producto"),
                content=content,
                actions=[
                    ft.TextButton("Cerrar", on_click=self._close_dialog),
                ],
                actions_alignment=ft.MainAxisAlignment.END,
                modal=True,
            )
            
            self.page.dialog = self.dialog_producto
            self.dialog_producto.open = True
            self.page.update()
            
        except Exception as ex:
            print(f"Error mostrando detalles: {ex}")
            self._show_error("Error al cargar detalles")
        finally:
            db.close()
    
    def _close_dialog(self, e=None):
        """Cerrar dialogo"""
        if self.dialog_producto:
            self.dialog_producto.open = False
            self.page.update()
    
    def _show_error(self, error: str):
        """Mostrar mensaje de error"""
        self.page.show_snack_bar(
            ft.SnackBar(
                content=ft.Text(error),
                bgcolor=ft.colors.RED,
                duration=3000,
            )
        )