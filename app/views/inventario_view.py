import flet as ft
from datetime import datetime
from app.database.base import get_db
from app.models import Categoria, Producto, Movimiento, Factura
import os


class InventarioView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.padding = ft.padding.all(16)

        # Componentes UI
        self.categorias_grid = None
        self.search_field = None
        self.productos_list = None
        self.dialog_cantidad = None
        self.dialog_producto = None

        # Estado
        self.categoria_seleccionada = None
        self.producto_seleccionado = None

        # Directorio de imagenes
        self.imagenes_dir = os.path.join(os.getcwd(), "uploads", "categorias")
        os.makedirs(self.imagenes_dir, exist_ok=True)

        # Construir UI (sin usar valores de page que aún no existen)
        self._build_ui()

    def did_mount(self):
        """Se ejecuta después de que la vista se agrega a la página"""
        # Cargar datos y ajustar responsividad ahora que self.page está disponible
        self._load_categorias()
        # Registrar listener de resize para adaptar el grid/runs_count si es necesario
        def on_resize(e):
            # Forzar recálculo de layout de categorías si cambia mucho el ancho
            # Ajusta max_extent dinámicamente si quieres
            try:
                # Forzar un refresh para que GridView recalcule
                self.update()
            except Exception:
                pass

        self.page.on_resized = on_resize

    def _build_ui(self):
        """Construir la interfaz de usuario (estructura base)"""
        # Titulo
        title = ft.Text(
            "Registro de Movimientos",
            size=24,
            weight=ft.FontWeight.BOLD,
            color=ft.colors.ON_SURFACE,
        )

        # Grid de categorias - usar max_extent para que sea adaptativo
        self.categorias_grid = ft.GridView(
            expand=True,
            # runs_count removed so grid calcula según max_extent
            max_extent=160,
            child_aspect_ratio=1.0,
            spacing=12,
            run_spacing=12,
            padding=ft.padding.all(8),
        )

        # Contenedor principal
        self.content = ft.Column(
            [
                title,
                ft.Divider(height=1),
                ft.Container(height=12),
                ft.Text(
                    "Seleccionar Categoria",
                    size=16,
                    weight=ft.FontWeight.W_500,
                ),
                ft.Container(height=8),
                self.categorias_grid,
            ],
            expand=True,
            spacing=0,
        )

        # Poner content dentro del Container (este control es la vista completa)
        self.content_area = ft.Container(content=self.content, expand=True)
        # Asignar content_area como contenido principal de este Container
        self.content = self.content_area

    def _load_categorias(self):
        """Cargar categorias desde la base de datos"""
        try:
            db = next(get_db())
            categorias = db.query(Categoria).filter(Categoria.activo == True).all()

            self.categorias_grid.controls.clear()

            for categoria in categorias:
                # Obtener imagen o usar icono
                imagen_path = None
                if categoria.imagen and os.path.exists(categoria.imagen):
                    imagen_path = categoria.imagen

                # Contenido del boton
                contenido = []

                if imagen_path:
                    # Mostrar imagen
                    contenido.append(
                        ft.Image(
                            src=imagen_path,
                            width=80,
                            height=80,
                            fit=ft.ImageFit.CONTAIN,
                        )
                    )
                else:
                    # Usar icono por defecto
                    contenido.append(
                        ft.Container(
                            content=ft.Icon(
                                ft.icons.CATEGORY,
                                size=48,
                                color=ft.colors.ON_PRIMARY,
                            ),
                            alignment=ft.alignment.center,
                            padding=ft.padding.all(8),
                        )
                    )

                # Nombre de la categoria
                contenido.append(
                    ft.Text(
                        categoria.nombre,
                        size=14,
                        weight=ft.FontWeight.W_600,
                        color=ft.colors.ON_PRIMARY,
                        text_align=ft.TextAlign.CENTER,
                        max_lines=2,
                        overflow=ft.TextOverflow.ELLIPSIS,
                    )
                )

                # Contador de productos
                productos_count = db.query(Producto).filter(
                    Producto.categoria_id == categoria.id,
                    Producto.activo == True
                ).count()

                contenido.append(
                    ft.Text(
                        f"{productos_count} productos",
                        size=11,
                        color=ft.colors.with_opacity(0.85, ft.colors.WHITE),
                        text_align=ft.TextAlign.CENTER,
                    )
                )

                # Determinar color del boton - convertir string hex a Color
                try:
                    if categoria.color and categoria.color.startswith("#"):
                        btn_color = ft.colors.CUSTOM(categoria.color)
                    else:
                        btn_color = ft.colors.PRIMARY
                except:
                    btn_color = ft.colors.PRIMARY

                # NO fijar width/height: dejar que el Grid adapte el tamaño
                btn = ft.Container(
                    content=ft.Column(
                        contenido,
                        alignment=ft.MainAxisAlignment.CENTER,
                        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                        spacing=6,
                    ),
                    # ancho/alto flexibles para mobile
                    bgcolor=btn_color,
                    border_radius=ft.border_radius.all(12),
                    padding=ft.padding.all(12),
                    ink=True,
                    on_click=lambda e, cat=categoria: self._on_categoria_click(cat),
                    shadow=ft.BoxShadow(
                        spread_radius=1,
                        blur_radius=6,
                        color=ft.colors.with_opacity(0.18, ft.colors.BLACK),
                        offset=ft.Offset(0, 2),
                    ),
                )

                self.categorias_grid.controls.append(btn)

            if not categorias:
                self.categorias_grid.controls.append(
                    ft.Container(
                        content=ft.Column(
                            [
                                ft.Icon(
                                    ft.icons.INVENTORY_2,
                                    size=64,
                                    color=ft.colors.OUTLINE,
                                ),
                                ft.Text(
                                    "No hay categorias registradas",
                                    size=16,
                                    color=ft.colors.ON_SURFACE_VARIANT,
                                    text_align=ft.TextAlign.CENTER,
                                ),
                                ft.Text(
                                    "Agrega categorias en Configuracion",
                                    size=14,
                                    color=ft.colors.ON_SURFACE_VARIANT,
                                    text_align=ft.TextAlign.CENTER,
                                ),
                            ],
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            spacing=8,
                        ),
                        alignment=ft.alignment.center,
                        padding=ft.padding.all(20),
                        expand=True,
                    )
                )

            # Si esta montada en page, actualizar
            try:
                self.update()
            except Exception:
                pass

        except Exception as ex:
            print(f"Error cargando categorias: {ex}")
            self._show_error("Error al cargar categorias")
        finally:
            try:
                db.close()
            except Exception:
                pass

    def _on_categoria_click(self, categoria: Categoria):
        """Manejar click en categoria"""
        self.categoria_seleccionada = categoria
        self._show_productos_view(categoria)

    def _show_productos_view(self, categoria: Categoria):
        """Mostrar vista de productos de la categoria"""
        print(f"=== Mostrando productos de categoria: {categoria.nombre} (ID: {categoria.id}) ===")
        
        # Campo de busqueda (expand para ocupar ancho en móvil)
        self.search_field = ft.TextField(
            label="Buscar producto...",
            prefix_icon=ft.icons.SEARCH,
            border_radius=ft.border_radius.all(12),
            on_change=self._filter_productos,
            expand=True,
        )

        # CAMBIAR de ListView a Column con scroll (mejor compatibilidad)
        self.productos_list = ft.Column(
            spacing=8,
            scroll=ft.ScrollMode.AUTO,
        )

        # Boton volver
        back_button = ft.IconButton(
            icon=ft.icons.ARROW_BACK,
            icon_size=24,
            on_click=self._back_to_categorias,
            tooltip="Volver a categorias",
        )

        # Titulo con categoria
        title_row = ft.Row(
            [
                back_button,
                ft.Text(
                    categoria.nombre,
                    size=20,
                    weight=ft.FontWeight.BOLD,
                    expand=True,
                    max_lines=1,
                    overflow=ft.TextOverflow.ELLIPSIS,
                ),
            ],
            alignment=ft.MainAxisAlignment.START,
            spacing=8,
            vertical_alignment=ft.CrossAxisAlignment.CENTER,
        )

        # Actualizar contenido: usar Column con scroll automático (mejor para móvil)
        nueva_vista = ft.Column(
            [
                title_row,
                ft.Divider(height=1),
                ft.Container(height=8),
                self.search_field,
                ft.Container(height=8),
                ft.Text(
                    "Productos",
                    size=16,
                    weight=ft.FontWeight.W_500,
                ),
                ft.Container(height=8),
                # Usar Container con expand para que el Column de productos ocupe el espacio disponible
                ft.Container(
                    content=self.productos_list,
                    expand=True,
                    padding=ft.padding.all(8),
                ),
            ],
            expand=True,
            spacing=0,
        )
        
        self.content_area.content = nueva_vista

        # Cargar productos ANTES de actualizar la vista
        self._load_productos(categoria)
        
        # Ahora sí, forzar actualización de toda la jerarquía
        try:
            self.page.update()
        except Exception as e:
            print(f"Error actualizando page: {e}")

    def _load_productos(self, categoria: Categoria = None):
        """Cargar productos de la categoria"""
        if categoria is None:
            categoria = self.categoria_seleccionada
            if categoria is None:
                return

        try:
            db = next(get_db())

            # Verificar busqueda - mejor manejo de None
            search_term = ""
            if self.search_field is not None and hasattr(self.search_field, 'value') and self.search_field.value:
                search_term = self.search_field.value.lower().strip()

            # Construir query con filtros explícitos
            query = db.query(Producto).filter(
                Producto.categoria_id == categoria.id
            ).filter(
                Producto.activo.is_(True)
            )

            if search_term:
                query = query.filter(
                    (Producto.nombre.ilike(f"%{search_term}%")) |
                    (Producto.codigo.ilike(f"%{search_term}%"))
                )

            productos = query.all()
            
            # Debug: imprimir cantidad de productos encontrados
            print(f"Categoria: {categoria.nombre} (ID: {categoria.id})")
            print(f"Productos encontrados: {len(productos)}")
            
            # Debug adicional: verificar todos los productos de esta categoría sin filtros
            todos_productos = db.query(Producto).filter(Producto.categoria_id == categoria.id).all()
            print(f"Total productos en categoria (sin filtro activo): {len(todos_productos)}")
            for p in todos_productos:
                print(f"  - {p.nombre} (activo: {p.activo})")

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
                                    f"No hay productos en {categoria.nombre}" if not search_term else "No se encontraron productos",
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
                is_mobile = False
                try:
                    is_mobile = (self.page.width is not None and self.page.width < 600)
                except Exception:
                    pass

                for producto in productos:
                    # Determinar icono según si requiere foto
                    icon = ft.icons.PHOTO_CAMERA if producto.requiere_foto_peso else ft.icons.INVENTORY

                    # Determinar color de stock
                    if producto.stock_actual <= 0:
                        stock_color = ft.colors.ERROR
                        stock_text = "Sin stock"
                    elif producto.stock_actual <= producto.stock_minimo:
                        stock_color = ft.colors.ORANGE
                        stock_text = f"Stock bajo: {producto.stock_actual:.2f}"
                    else:
                        stock_color = ft.colors.GREEN
                        stock_text = f"Stock: {producto.stock_actual:.2f}"

                    # Construir la sección de acciones: en móvil usar columna, en desktop fila
                    if is_mobile:
                        acciones = ft.Column(
                            [
                                ft.ElevatedButton(
                                    "Entrada",
                                    on_click=lambda e, p=producto: self._show_cantidad_dialog(p, tipo="entrada"),
                                    style=ft.ButtonStyle(padding=ft.padding.symmetric(horizontal=12, vertical=6))
                                ),
                                ft.Container(height=6),
                                ft.ElevatedButton(
                                    "Salida",
                                    on_click=lambda e, p=producto: self._show_cantidad_dialog(p, tipo="salida"),
                                    style=ft.ButtonStyle(padding=ft.padding.symmetric(horizontal=12, vertical=6)),
                                    bgcolor=ft.colors.ERROR
                                ),
                            ],
                            spacing=6,
                        )
                    else:
                        acciones = ft.Row(
                            [
                                ft.ElevatedButton(
                                    "Entrada",
                                    on_click=lambda e, p=producto: self._show_cantidad_dialog(p, tipo="entrada"),
                                    style=ft.ButtonStyle(padding=ft.padding.symmetric(horizontal=12, vertical=6))
                                ),
                                ft.Container(width=8),
                                ft.ElevatedButton(
                                    "Salida",
                                    on_click=lambda e, p=producto: self._show_cantidad_dialog(p, tipo="salida"),
                                    style=ft.ButtonStyle(padding=ft.padding.symmetric(horizontal=12, vertical=6)),
                                    bgcolor=ft.colors.ERROR
                                ),
                            ],
                            spacing=8,
                        )

                    card = ft.Card(
                        content=ft.Container(
                            content=ft.Column(
                                [
                                    ft.ListTile(
                                        leading=ft.Container(
                                            content=ft.Icon(icon, color=ft.colors.PRIMARY, size=28),
                                            bgcolor=ft.colors.PRIMARY_CONTAINER,
                                            border_radius=ft.border_radius.all(8),
                                            padding=ft.padding.all(8),
                                        ),
                                        title=ft.Text(
                                            producto.nombre,
                                            weight=ft.FontWeight.W_500,
                                            size=16,
                                            max_lines=2,
                                            overflow=ft.TextOverflow.ELLIPSIS,
                                        ),
                                        subtitle=ft.Column(
                                            [
                                                ft.Text(
                                                    producto.codigo or "Sin codigo",
                                                    size=12,
                                                    color=ft.colors.ON_SURFACE_VARIANT,
                                                ),
                                                ft.Row(
                                                    [
                                                        ft.Icon(
                                                            ft.icons.SCALE,
                                                            size=14,
                                                            color=ft.colors.ON_SURFACE_VARIANT,
                                                        ),
                                                        ft.Text(
                                                            f" {producto.unidad_medida}",
                                                            size=12,
                                                            color=ft.colors.ON_SURFACE_VARIANT,
                                                        ),
                                                    ],
                                                    spacing=4,
                                                ),
                                            ],
                                            spacing=2,
                                        ),
                                        trailing=ft.Icon(
                                            ft.icons.CHEVRON_RIGHT,
                                            color=ft.colors.ON_SURFACE_VARIANT,
                                        ),
                                        on_click=lambda e, prod=producto: self._on_producto_click(prod),
                                    ),
                                    ft.Container(
                                        content=ft.Row(
                                            [
                                                ft.Column(
                                                    [
                                                        ft.Row(
                                                            [
                                                                ft.Icon(
                                                                    ft.icons.TRENDING_DOWN if producto.stock_actual <= producto.stock_minimo else ft.icons.TRENDING_UP,
                                                                    size=16,
                                                                    color=stock_color,
                                                                ),
                                                                ft.Text(
                                                                    stock_text,
                                                                    size=12,
                                                                    color=stock_color,
                                                                    weight=ft.FontWeight.W_500,
                                                                ),
                                                            ],
                                                            spacing=4,
                                                        ),
                                                        ft.Container(height=6),
                                                        acciones,
                                                    ],
                                                    spacing=6,
                                                ),
                                                # Min info alineada a la derecha en desktop; en móvil irá debajo dentro 'acciones'
                                                (ft.Text(
                                                    f"Min: {producto.stock_minimo:.2f}",
                                                    size=11,
                                                    color=ft.colors.ON_SURFACE_VARIANT,
                                                ) if not is_mobile else ft.Container()),
                                            ],
                                            alignment=ft.MainAxisAlignment.SPACE_BETWEEN,
                                            vertical_alignment=ft.CrossAxisAlignment.CENTER,
                                        ),
                                        padding=ft.padding.symmetric(horizontal=12, vertical=8),
                                        bgcolor=ft.colors.with_opacity(0.06, stock_color),
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

            # Debug: verificar cuántos controles hay en la lista
            print(f"Total controles en productos_list: {len(self.productos_list.controls)}")
            
            # NO actualizar productos_list directamente, solo la vista completa
            # El ListView se actualizará cuando se actualice su contenedor padre
            try:
                self.update()
            except Exception as e:
                print(f"Error actualizando vista: {e}")

        except Exception as ex:
            print(f"Error cargando productos: {ex}")
            self._show_error("Error al cargar productos")
        finally:
            try:
                db.close()
            except Exception:
                pass

    def _filter_productos(self, e):
        """Filtrar productos según búsqueda"""
        if self.categoria_seleccionada:
            self._load_productos(self.categoria_seleccionada)

    def _on_producto_click(self, producto: Producto):
        """Manejar click en producto"""
        self.producto_seleccionado = producto
        # Abrir dialogo por defecto en modo "entrada" al hacer click en el tile
        self._show_cantidad_dialog(producto, tipo="entrada")

    def _show_cantidad_dialog(self, producto: Producto, tipo: str = "entrada"):
        """Mostrar dialogo para ingresar cantidad (entrada o salida)"""
        cantidad_field = ft.TextField(
            label="Cantidad",
            keyboard_type=ft.KeyboardType.NUMBER,
            border_radius=ft.border_radius.all(12),
            autofocus=True,
            value="1",
        )

        # Campo de peso (solo si requiere foto de balanza)
        peso_field = None
        if producto.requiere_foto_peso:
            peso_field = ft.TextField(
                label="Peso registrado (kg)",
                keyboard_type=ft.KeyboardType.NUMBER,
                border_radius=ft.border_radius.all(12),
                hint_text="Ej: 5.5",
            )

        # Campo de observaciones
        observaciones_field = ft.TextField(
            label="Observaciones (opcional)",
            multiline=True,
            border_radius=ft.border_radius.all(12),
        )

        # Titulo y color según tipo
        titulo = "Registrar Entrada" if tipo == "entrada" else "Registrar Salida"
        titulo_color = ft.colors.GREEN if tipo == "entrada" else ft.colors.ERROR

        contenido = [ft.Text(producto.nombre, size=18, weight=ft.FontWeight.BOLD, text_align=ft.TextAlign.CENTER)]

        if producto.requiere_foto_peso:
            contenido.extend([
                ft.Container(height=12),
                cantidad_field,
                ft.Container(height=8),
                peso_field,
            ])
        else:
            contenido.extend([
                ft.Container(height=12),
                cantidad_field,
            ])

        contenido.extend([
            ft.Container(height=8),
            observaciones_field,
        ])

        # Dialogo con scroll para móviles
        dialog_content = ft.Column(
            contenido,
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            spacing=8,
            scroll=ft.ScrollMode.AUTO,
        )

        self.dialog_cantidad = ft.AlertDialog(
            title=ft.Row(
                [
                    ft.Icon(ft.icons.SELL, color=titulo_color, size=18),
                    ft.Container(width=8),
                    ft.Text(titulo)
                ],
                vertical_alignment=ft.CrossAxisAlignment.CENTER
            ),
            content=dialog_content,
            actions=[
                ft.TextButton("Cancelar", on_click=self._close_dialog),
                ft.ElevatedButton(
                    "Guardar",
                    on_click=lambda e: self._guardar_movimiento(
                        producto=producto,
                        cantidad=cantidad_field.value,
                        peso=peso_field.value if producto.requiere_foto_peso else None,
                        observaciones=observaciones_field.value,
                        tipo=tipo,
                    ),
                ),
            ],
            actions_alignment=ft.MainAxisAlignment.END,
            modal=True,
        )

        self.page.dialog = self.dialog_cantidad
        self.dialog_cantidad.open = True
        try:
            self.page.update()
        except Exception:
            pass

    def _guardar_movimiento(self, producto: Producto, cantidad: str, peso: str = None, observaciones: str = None, tipo: str = "entrada"):
        """Guardar entrada o salida de producto."""
        try:
            # Validar cantidad
            if not cantidad:
                self._show_error("Ingrese una cantidad válida")
                return
            try:
                cantidad_val = float(cantidad)
            except ValueError:
                self._show_error("Cantidad inválida")
                return
            if cantidad_val <= 0:
                self._show_error("La cantidad debe ser mayor a 0")
                return

            # Validar peso si aplica
            peso_val = None
            if producto.requiere_foto_peso and peso:
                try:
                    peso_val = float(peso)
                except ValueError:
                    self._show_error("Peso inválido")
                    return

            db = next(get_db())
            try:
                # Recargar producto desde la DB
                prod = db.query(Producto).filter(Producto.id == producto.id).first()
                if not prod:
                    self._show_error("Producto no encontrado")
                    return

                cantidad_anterior = float(prod.stock_actual or 0.0)
                if tipo == "entrada":
                    cantidad_nueva = cantidad_anterior + cantidad_val
                else:  # salida
                    cantidad_nueva = cantidad_anterior - cantidad_val
                    if cantidad_nueva < 0:
                        self._show_error("Stock insuficiente para esta salida")
                        return

                movimiento = Movimiento(
                    producto_id=prod.id,
                    factura_id=None,
                    tipo=tipo,
                    cantidad=cantidad_val,
                    cantidad_anterior=cantidad_anterior,
                    cantidad_nueva=cantidad_nueva,
                    peso_registrado=peso_val,
                    foto_peso_url=None,
                    registrado_por="Administrador",
                    observaciones=observaciones,
                    fecha_movimiento=datetime.now(),
                )

                # Actualizar stock del producto
                prod.stock_actual = cantidad_nueva

                db.add(movimiento)
                db.add(prod)
                db.commit()

                self._close_dialog()

                acción_text = "Entrada registrada" if tipo == "entrada" else "Salida registrada"
                self._show_message(f"{acción_text}: {cantidad_val} {prod.unidad_medida} de {prod.nombre}")

                # Recargar lista de productos
                if self.categoria_seleccionada:
                    self._load_productos(self.categoria_seleccionada)
            except Exception as db_ex:
                db.rollback()
                print(f"Error guardando movimiento en BD: {db_ex}")
                self._show_error("Error al guardar movimiento")
            finally:
                try:
                    db.close()
                except Exception:
                    pass
        except Exception as ex:
            print(f"Error guardando movimiento: {ex}")
            self._show_error("Error al guardar movimiento")

    def _back_to_categorias(self, e):
        """Volver a la vista de categorias"""
        self.categoria_seleccionada = None
        # Restaurar la UI base con el grid de categorias
        self.content_area.content = ft.Column(
            [
                ft.Text("Registro de Movimientos", size=24, weight=ft.FontWeight.BOLD),
                ft.Divider(height=1),
                ft.Container(height=12),
                ft.Text("Seleccionar Categoria", size=16, weight=ft.FontWeight.W_500),
                ft.Container(height=8),
                self.categorias_grid,
            ],
            expand=True,
            spacing=0,
            scroll=ft.ScrollMode.AUTO,
        )
        try:
            self.update()
        except Exception:
            pass

    def _close_dialog(self, e=None):
        """Cerrar dialogo"""
        if self.dialog_cantidad:
            try:
                self.dialog_cantidad.open = False
                self.page.dialog = None
                self.page.update()
            except Exception:
                pass

    def _show_message(self, message: str):
        """Mostrar mensaje de exito"""
        self.page.show_snack_bar(
            ft.SnackBar(
                content=ft.Text(message),
                bgcolor=ft.colors.GREEN,
                duration=3000,
            )
        )

    def _show_error(self, error: str):
        """Mostrar mensaje de error"""
        self.page.show_snack_bar(
            ft.SnackBar(
                content=ft.Text(error),
                bgcolor=ft.colors.RED,
                duration=3000,
            )
        )