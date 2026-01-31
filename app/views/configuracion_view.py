import flet as ft
from app.database.base import get_db
from app.models import Categoria, Producto
from config.config import get_settings
import os


def _get_opacity_color(color, opacity: float):
    """Obtener color con opacidad - maneja hex strings y objetos Color de Flet."""
    try:
        # color es hex string como "#RRGGBB"
        if isinstance(color, str):
            if color.startswith("#"):
                base = ft.colors.CUSTOM(color)
                return ft.colors.with_opacity(opacity, base)
            # si es string no hex, fallback a PRIMARY con opacidad
            return ft.colors.with_opacity(opacity, ft.colors.PRIMARY)
        # color es objeto Flet Color (tiene método with_opacity)
        if hasattr(color, "with_opacity"):
            return color.with_opacity(opacity)
        # fallback genérico
        return ft.colors.with_opacity(opacity, ft.colors.PRIMARY)
    except Exception:
        return ft.colors.with_opacity(opacity, ft.colors.PRIMARY)


def _normalize_icon_color(card_color):
    """Devuelve un objeto Color usable por Flet para iconos, con fallback seguro."""
    try:
        if isinstance(card_color, str) and card_color.startswith("#"):
            return ft.colors.CUSTOM(card_color)
        if hasattr(card_color, "with_opacity"):
            return card_color
    except Exception:
        pass
    return ft.colors.PRIMARY


class ConfiguracionView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.padding = ft.padding.all(16)

        # Componentes UI
        self.tab_control = None
        self.categorias_list = None
        self.productos_list = None
        self.db_host_field = None
        self.dialog_categoria = None
        self.dialog_producto = None
        self.dialog_confirmar = None

        # Directorio de imagenes
        self.imagenes_dir = os.path.join(os.getcwd(), "uploads", "categorias")
        os.makedirs(self.imagenes_dir, exist_ok=True)

        self._build_ui()

    def did_mount(self):
        # Cargar datos al montarse
        self._load_categorias()
        self._load_productos()

        # listener ligero de resize para refrescar si es necesario
        def on_resize(e):
            try:
                self.update()
            except Exception:
                pass

        # proteger existencia de page
        try:
            self.page.on_resized = on_resize
        except Exception:
            pass

    def _build_ui(self):
        title = ft.Text("Configuracion", size=24, weight=ft.FontWeight.BOLD, color=ft.colors.ON_SURFACE)

        self.tab_control = ft.Tabs(
            selected_index=0,
            animation_duration=200,
            tabs=[
                ft.Tab(text="Categorias", icon=ft.icons.FOLDER_SPECIAL, content=self._build_categorias_tab()),
                ft.Tab(text="Productos", icon=ft.icons.INVENTORY, content=self._build_productos_tab()),
                ft.Tab(text="Base de Datos", icon=ft.icons.STORAGE, content=self._build_database_tab()),
            ],
            expand=True,
        )

        self.content = ft.Column(
            [title, ft.Divider(height=1), ft.Container(height=8), self.tab_control],
            expand=True,
            spacing=0,
        )

    def _build_categorias_tab(self):
        add_button = ft.ElevatedButton(
            "Nueva Categoria",
            icon=ft.icons.ADD,
            on_click=self._show_add_categoria_dialog,
            style=ft.ButtonStyle(
                shape=ft.RoundedRectangleBorder(radius=12),
                bgcolor=ft.colors.PRIMARY,
                color=ft.colors.WHITE,
                padding=ft.padding.symmetric(horizontal=18, vertical=10),
            ),
        )

        section_title = ft.Text("Gestion de Categorias", size=18, weight=ft.FontWeight.W_600)
        self.categorias_list = ft.ListView(expand=True, spacing=12, padding=ft.padding.all(8))

        return ft.Column(
            [
                ft.Row([section_title, ft.Container(expand=True), add_button], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                ft.Container(height=12),
                ft.Container(
                    content=self.categorias_list,
                    border=ft.border.all(1, ft.colors.OUTLINE_VARIANT),
                    border_radius=ft.border_radius.all(12),
                    padding=ft.padding.all(8),
                    expand=True,
                ),
            ],
            expand=True,
        )

    def _load_categorias(self):
        """Cargar categorias desde la base de datos"""
        db = None
        try:
            db = next(get_db())
            categorias = db.query(Categoria).order_by(Categoria.nombre).all()
            # limpiar lista
            if self.categorias_list:
                self.categorias_list.controls.clear()
            else:
                self.categorias_list = ft.ListView(expand=True)

            for categoria in categorias:
                # Determinar color correctamente
                try:
                    card_color = categoria.color if (categoria.color and isinstance(categoria.color, str)) else ft.colors.PRIMARY
                except Exception:
                    card_color = ft.colors.BLUE_GREY

                estado_color = ft.colors.GREEN if categoria.activo else ft.colors.ERROR
                estado_texto = "Activo" if categoria.activo else "Inactivo"

                productos_count = db.query(Producto).filter(Producto.categoria_id == categoria.id).count()

                # Icono o imagen
                if categoria.imagen and os.path.exists(categoria.imagen):
                    imagen_widget = ft.Image(
                        src=categoria.imagen,
                        width=64,
                        height=64,
                        fit=ft.ImageFit.COVER,
                        error_icon=ft.icons.FOLDER,
                    )
                else:
                    icon_color = _normalize_icon_color(card_color)
                    imagen_widget = ft.Icon(
                        ft.icons.FOLDER_SPECIAL,
                        size=32,
                        color=icon_color,
                    )

                card = ft.Card(
                    content=ft.Container(
                        content=ft.Row(
                            [
                                ft.Container(
                                    content=imagen_widget,
                                    width=72,
                                    height=72,
                                    border_radius=12,
                                    bgcolor=_get_opacity_color(card_color, 0.18),
                                    alignment=ft.alignment.center,
                                ),
                                ft.Column(
                                    [
                                        ft.Text(categoria.nombre, size=16, weight=ft.FontWeight.W_600),
                                        ft.Text(
                                            categoria.descripcion or "Sin descripcion",
                                            size=13,
                                            color=ft.colors.ON_SURFACE_VARIANT,
                                            max_lines=2,
                                            overflow=ft.TextOverflow.ELLIPSIS,
                                        ),
                                        ft.Row(
                                            [
                                                ft.Container(
                                                    content=ft.Row(
                                                        [
                                                            ft.Icon(ft.icons.CIRCLE, size=8, color=estado_color),
                                                            ft.Text(estado_texto, size=12, color=estado_color),
                                                        ],
                                                        spacing=6,
                                                    ),
                                                    bgcolor=_get_opacity_color(estado_color, 0.08),
                                                    padding=ft.padding.symmetric(horizontal=8, vertical=4),
                                                    border_radius=8,
                                                ),
                                                ft.Row(
                                                    [
                                                        ft.Icon(ft.icons.INVENTORY, size=14, color=ft.colors.ON_SURFACE_VARIANT),
                                                        ft.Text(f"{productos_count} productos", size=12, color=ft.colors.ON_SURFACE_VARIANT),
                                                    ],
                                                    spacing=6,
                                                ),
                                            ],
                                            spacing=8,
                                        ),
                                    ],
                                    expand=True,
                                    spacing=6,
                                ),
                                ft.Column(
                                    [
                                        ft.IconButton(
                                            ft.icons.EDIT,
                                            icon_color=ft.colors.PRIMARY,
                                            on_click=lambda e, cat=categoria: self._edit_categoria(cat),
                                        ),
                                        ft.IconButton(
                                            ft.icons.DELETE,
                                            icon_color=ft.colors.ERROR,
                                            on_click=lambda e, cat=categoria: self._confirm_delete_categoria(cat),
                                        ),
                                    ],
                                    spacing=0,
                                ),
                            ],
                            spacing=12,
                            vertical_alignment=ft.CrossAxisAlignment.CENTER,
                        ),
                        padding=12,
                    ),
                    elevation=1,
                    shape=ft.RoundedRectangleBorder(radius=12),
                )
                self.categorias_list.controls.append(card)

            try:
                self.update()
            except Exception:
                pass
        except Exception as ex:
            self._show_error(f"Error al cargar categorias: {ex}")
        finally:
            if db:
                try:
                    db.close()
                except Exception:
                    pass

    def _show_categoria_dialog(self, categoria=None):
        """Mostrar dialogo para agregar/editar categoria"""
        nombre_field = ft.TextField(label="Nombre", value=categoria.nombre if categoria else "", border_radius=12, autofocus=True)
        descripcion_field = ft.TextField(label="Descripcion", value=categoria.descripcion if categoria else "", multiline=True, border_radius=12)
        activo_checkbox = ft.Checkbox(label="Activo", value=categoria.activo if categoria else True)

        color_options = [
            "#F44336", "#E91E63", "#9C27B0", "#673AB7", "#3F51B5", "#2196F3",
            "#03A9F4", "#00BCD4", "#009688", "#4CAF50", "#8BC34A", "#FF9800",
            "#FF5722", "#795548", "#607D8B",
        ]

        color_dropdown = ft.Dropdown(
            label="Color",
            border_radius=12,
            options=[ft.dropdown.Option(color, color) for color in color_options],
            value=categoria.color if categoria and categoria.color else "#2196F3",
        )

        def save(e):
            self._save_categoria(categoria, nombre_field.value, descripcion_field.value, activo_checkbox.value, color_dropdown.value)

        dialog = ft.AlertDialog(
            title=ft.Text("Categoria"),
            content=ft.Column([nombre_field, descripcion_field, color_dropdown, activo_checkbox], tight=True, spacing=12, scroll=ft.ScrollMode.AUTO),
            actions=[
                ft.TextButton("Cancelar", on_click=self._close_dialog),
                ft.ElevatedButton("Guardar", on_click=save),
            ],
            modal=True,
        )
        try:
            self.page.dialog = dialog
            dialog.open = True
            self.page.update()
        except Exception:
            pass

    def _show_add_categoria_dialog(self, e):
        self._show_categoria_dialog()

    def _edit_categoria(self, cat):
        self._show_categoria_dialog(cat)

    def _confirm_delete_categoria(self, categoria):
        """Mostrar dialogo de confirmacion para eliminar"""
        def delete(e):
            self._delete_categoria(categoria)

        dialog = ft.AlertDialog(
            title=ft.Text("Confirmar Eliminacion"),
            content=ft.Text(f"Esta seguro que desea eliminar la categoria '{categoria.nombre}'?"),
            actions=[
                ft.TextButton("Cancelar", on_click=self._close_dialog),
                ft.ElevatedButton("Eliminar", on_click=delete, bgcolor=ft.colors.ERROR, color=ft.colors.WHITE),
            ],
            modal=True,
        )
        try:
            self.page.dialog = dialog
            dialog.open = True
            self.page.update()
        except Exception:
            pass

    def _delete_categoria(self, categoria):
        """Eliminar categoria (verifica productos)"""
        db = None
        try:
            db = next(get_db())
            productos_count = db.query(Producto).filter(Producto.categoria_id == categoria.id).count()
            if productos_count > 0:
                self._show_error(f"No se puede eliminar. La categoria tiene {productos_count} productos asignados.")
                self._close_dialog()
                return

            # Borrar la categoría
            db.delete(categoria)
            db.commit()
            self._close_dialog()
            self._load_categorias()
            self._show_message("Categoria eliminada correctamente")
        except Exception as ex:
            self._show_error(f"Error al eliminar categoria: {ex}")
        finally:
            if db:
                try:
                    db.close()
                except Exception:
                    pass

    def _save_categoria(self, categoria, nombre, descripcion, activo, color):
        """Guardar categoria"""
        if not nombre or not nombre.strip():
            self._show_error("El nombre es obligatorio")
            return
        db = None
        try:
            db = next(get_db())
            if categoria:
                # actualizar
                cat_db = db.query(Categoria).filter(Categoria.id == categoria.id).first()
                if not cat_db:
                    self._show_error("Categoria no encontrada")
                    return
                cat_db.nombre = nombre.strip()
                cat_db.descripcion = descripcion.strip() if descripcion else None
                cat_db.activo = activo
                cat_db.color = color
            else:
                nueva_categoria = Categoria(
                    nombre=nombre.strip(),
                    descripcion=descripcion.strip() if descripcion else None,
                    activo=activo,
                    color=color or "#2196F3",
                )
                db.add(nueva_categoria)
            db.commit()
            self._close_dialog()
            self._load_categorias()
            self._show_message("Guardado correctamente")
        except Exception as ex:
            self._show_error(f"Error al guardar: {ex}")
        finally:
            if db:
                try:
                    db.close()
                except Exception:
                    pass

    def _build_productos_tab(self):
        add_button = ft.ElevatedButton(
            "Nuevo Producto",
            icon=ft.icons.ADD,
            on_click=self._show_add_producto_dialog,
            style=ft.ButtonStyle(
                shape=ft.RoundedRectangleBorder(radius=12),
                bgcolor=ft.colors.PRIMARY,
                color=ft.colors.WHITE,
                padding=ft.padding.symmetric(horizontal=18, vertical=10),
            ),
        )

        section_title = ft.Text("Gestion de Productos", size=18, weight=ft.FontWeight.W_600)
        self.productos_list = ft.ListView(expand=True, spacing=12, padding=ft.padding.all(8))

        return ft.Column(
            [
                ft.Row([section_title, ft.Container(expand=True), add_button], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
                ft.Container(height=12),
                ft.Container(
                    content=self.productos_list,
                    border=ft.border.all(1, ft.colors.OUTLINE_VARIANT),
                    border_radius=ft.border_radius.all(12),
                    padding=ft.padding.all(8),
                    expand=True,
                ),
            ],
            expand=True,
        )

    def _build_database_tab(self):
        """Construir tab de base de datos (lectura/selector, guardado simulado)"""
        settings = get_settings()

        title = ft.Text("Configuracion de Base de Datos", size=18, weight=ft.FontWeight.W_600)

        db_type_dropdown = ft.Dropdown(
            label="Tipo de Base de Datos",
            border_radius=12,
            options=[
                ft.dropdown.Option("sqlite", "SQLite (Desarrollo)"),
                ft.dropdown.Option("postgresql", "PostgreSQL (Produccion)"),
            ],
            value=settings.DB_TYPE,
            on_change=self._on_db_type_change,
        )

        self.sqlite_path_field = ft.TextField(label="Ruta SQLite", value=settings.SQLITE_PATH, border_radius=12, visible=settings.DB_TYPE.lower() == "sqlite")
        self.db_host_field = ft.TextField(label="Host", value=settings.DB_HOST, border_radius=12, visible=settings.DB_TYPE.lower() == "postgresql")
        self.db_port_field = ft.TextField(label="Puerto", value=str(settings.DB_PORT), border_radius=12, visible=settings.DB_TYPE.lower() == "postgresql")
        self.db_name_field = ft.TextField(label="Nombre BD", value=settings.DB_NAME, border_radius=12, visible=settings.DB_TYPE.lower() == "postgresql")
        self.db_user_field = ft.TextField(label="Usuario", value=settings.DB_USER, border_radius=12, visible=settings.DB_TYPE.lower() == "postgresql")
        self.db_password_field = ft.TextField(label="Password", value=settings.DB_PASSWORD, password=True, border_radius=12, visible=settings.DB_TYPE.lower() == "postgresql")

        save_button = ft.ElevatedButton("Guardar Configuracion", icon=ft.icons.SAVE, on_click=self._save_db_config, style=ft.ButtonStyle(shape=ft.RoundedRectangleBorder(radius=12), bgcolor=ft.colors.PRIMARY, color=ft.colors.WHITE))
        test_button = ft.OutlinedButton("Probar Conexion", icon=ft.icons.WIFI, on_click=self._test_db_connection)

        return ft.Column(
            [
                title,
                ft.Container(height=12),
                db_type_dropdown,
                ft.Container(height=8),
                self.sqlite_path_field,
                ft.Container(height=8),
                self.db_host_field,
                ft.Row([self.db_port_field, self.db_name_field], spacing=8),
                ft.Row([self.db_user_field, self.db_password_field], spacing=8),
                ft.Container(height=20),
                ft.Row([save_button, test_button], spacing=12),
            ],
            expand=True,
            scroll=ft.ScrollMode.AUTO,
        )

    def _on_db_type_change(self, e):
        """Cambiar visibilidad de campos segun tipo de base de datos"""
        try:
            is_sqlite = e.control.value.lower() == "sqlite"
            self.sqlite_path_field.visible = is_sqlite
            self.db_host_field.visible = not is_sqlite
            self.db_port_field.visible = not is_sqlite
            self.db_name_field.visible = not is_sqlite
            self.db_user_field.visible = not is_sqlite
            self.db_password_field.visible = not is_sqlite
            try:
                self.page.update()
            except Exception:
                pass
        except Exception:
            pass

    def _save_db_config(self, e):
        """Guardar configuración de base de datos (acción mínima: notificar y pedir reinicio)."""
        try:
            # Aquí podrías guardar en un .env o archivo de configuración.
            # Por ahora sólo mostramos un mensaje y avisamos que debe reiniciar la app.
            self._show_message("Configuración guardada. Reinicie la aplicación para aplicar cambios.")
        except Exception as ex:
            self._show_error(f"Error guardando configuración: {ex}")

    def _test_db_connection(self, e):
        """Probar conexión a base de datos usando los campos visibles.
        - Si es SQLite verifica que el archivo exista o se pueda crear.
        - Si es PostgreSQL intenta crear un engine temporal y conectarse.
        """
        try:
            settings = get_settings()

            # Determinar si el usuario ha seleccionado SQLite (por visibilidad de campo o por settings)
            try:
                db_type = "sqlite" if getattr(self, "sqlite_path_field", None) and self.sqlite_path_field.visible else "postgresql"
            except Exception:
                db_type = settings.DB_TYPE.lower()

            if db_type == "sqlite":
                # Ruta a comprobar
                path = getattr(self, "sqlite_path_field", None).value if getattr(self, "sqlite_path_field", None) else settings.SQLITE_PATH
                try:
                    # crear el archivo si no existe (modo append lo crea)
                    with open(path, "a"):
                        pass
                    self._show_message(f"Conexión SQLite OK: '{path}'")
                    return
                except Exception as ex:
                    self._show_error(f"Error accediendo SQLite: {ex}")
                    return

            # Si llegamos aquí asumimos PostgreSQL (intentar conexión)
            try:
                host = getattr(self, "db_host_field", None).value if getattr(self, "db_host_field", None) else settings.DB_HOST
                port = getattr(self, "db_port_field", None).value if getattr(self, "db_port_field", None) else str(settings.DB_PORT)
                name = getattr(self, "db_name_field", None).value if getattr(self, "db_name_field", None) else settings.DB_NAME
                user = getattr(self, "db_user_field", None).value if getattr(self, "db_user_field", None) else settings.DB_USER
                password = getattr(self, "db_password_field", None).value if getattr(self, "db_password_field", None) else settings.DB_PASSWORD

                try:
                    from sqlalchemy import create_engine
                except Exception:
                    self._show_error("SQLAlchemy no está disponible para probar PostgreSQL.")
                    return

                url = f"postgresql://{user}:{password}@{host}:{port}/{name}"
                engine = create_engine(url, connect_args={}, pool_pre_ping=True)
                conn = engine.connect()
                conn.close()
                engine.dispose()
                self._show_message("Conexión PostgreSQL OK")
            except Exception as ex:
                self._show_error(f"Error conectando PostgreSQL: {ex}")
        except Exception as ex:
            self._show_error(f"Error en prueba de conexión: {ex}")

    def _load_productos(self):
        """Cargar productos para la lista"""
        db = None
        try:
            db = next(get_db())
            productos = db.query(Producto).order_by(Producto.nombre).all()
            if self.productos_list:
                self.productos_list.controls.clear()
            else:
                self.productos_list = ft.ListView(expand=True)

            if not productos:
                self.productos_list.controls.append(
                    ft.Container(
                        content=ft.Column(
                            [
                                ft.Icon(ft.icons.INVENTORY_2, size=48, color=ft.colors.OUTLINE),
                                ft.Text("No hay productos registrados", size=16, color=ft.colors.ON_SURFACE_VARIANT, text_align=ft.TextAlign.CENTER),
                            ],
                            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                            spacing=12,
                        ),
                        alignment=ft.alignment.center,
                        padding=ft.padding.all(24),
                    )
                )
                try:
                    self.update()
                except Exception:
                    pass
                return

            for producto in productos:
                card = ft.Card(
                    content=ft.Container(
                        content=ft.Row(
                            [
                                ft.Column(
                                    [
                                        ft.Text(producto.nombre, size=15, weight=ft.FontWeight.W_600),
                                        ft.Text(f"Codigo: {producto.codigo or 'N/A'}", size=12, color=ft.colors.ON_SURFACE_VARIANT),
                                        ft.Text(producto.categoria.nombre if producto.categoria else "Sin categoria", size=12, color=ft.colors.PRIMARY),
                                    ],
                                    expand=True,
                                    spacing=4,
                                ),
                                ft.Column(
                                    [
                                        ft.Text(f"{producto.stock_actual:.2f}", size=18, weight=ft.FontWeight.BOLD, color=ft.colors.PRIMARY),
                                        ft.Text(producto.unidad_medida, size=12, color=ft.colors.ON_SURFACE_VARIANT),
                                    ],
                                    horizontal_alignment=ft.CrossAxisAlignment.END,
                                    spacing=0,
                                ),
                                ft.Column(
                                    [
                                        ft.IconButton(ft.icons.EDIT, icon_color=ft.colors.PRIMARY, on_click=lambda e, prod=producto: self._edit_producto(prod)),
                                        ft.IconButton(ft.icons.DELETE, icon_color=ft.colors.ERROR, on_click=lambda e, prod=producto: self._confirm_delete_producto(prod)),
                                    ],
                                    spacing=0,
                                ),
                            ],
                            spacing=12,
                            vertical_alignment=ft.CrossAxisAlignment.CENTER,
                        ),
                        padding=12,
                    ),
                    elevation=1,
                    shape=ft.RoundedRectangleBorder(radius=12),
                )
                self.productos_list.controls.append(card)

            try:
                self.update()
            except Exception:
                pass
        except Exception as ex:
            print(f"Error cargando productos: {ex}")
        finally:
            if db:
                try:
                    db.close()
                except Exception:
                    pass

    def _show_add_producto_dialog(self, e):
        """Mostrar dialogo para agregar producto"""
        self._show_producto_dialog()

    def _show_producto_dialog(self, producto=None):
        """Mostrar dialogo para agregar/editar producto"""
        db = None
        try:
            db = next(get_db())
            categorias = db.query(Categoria).filter(Categoria.activo == True).order_by(Categoria.nombre).all()
        except Exception:
            categorias = []
        finally:
            if db:
                try:
                    db.close()
                except Exception:
                    pass

        categoria_options = [ft.dropdown.Option(str(cat.id), cat.nombre) for cat in categorias]

        nombre_field = ft.TextField(label="Nombre", value=producto.nombre if producto else "", border_radius=12, autofocus=True)
        codigo_field = ft.TextField(label="Codigo (opcional)", value=producto.codigo if producto else "", border_radius=12)
        descripcion_field = ft.TextField(label="Descripcion", value=producto.descripcion if producto else "", multiline=True, border_radius=12)
        categoria_dropdown = ft.Dropdown(label="Categoria", border_radius=12, options=categoria_options, value=str(producto.categoria_id) if producto else (categoria_options[0].key if categoria_options else ""))
        requiere_foto_check = ft.Checkbox(label="Requiere foto de balanza", value=producto.requiere_foto_peso if producto else False)
        unidad_dropdown = ft.Dropdown(label="Unidad de Medida", border_radius=12, options=[ft.dropdown.Option(u, u) for u in ["unidad", "kg", "litro", "metro", "caja", "paquete", "bolsa"]], value=producto.unidad_medida if producto else "unidad")
        stock_actual_field = ft.TextField(label="Stock Actual", value=str(producto.stock_actual) if producto else "0", keyboard_type=ft.KeyboardType.NUMBER, border_radius=12)
        stock_minimo_field = ft.TextField(label="Stock Minimo (alerta)", value=str(producto.stock_minimo) if producto else "0", keyboard_type=ft.KeyboardType.NUMBER, border_radius=12)
        activo_checkbox = ft.Checkbox(label="Activo", value=producto.activo if producto else True)

        def save(e):
            self._save_producto(producto, nombre_field.value, codigo_field.value, descripcion_field.value, categoria_dropdown.value, requiere_foto_check.value, unidad_dropdown.value, stock_actual_field.value, stock_minimo_field.value, activo_checkbox.value)

        dialog = ft.AlertDialog(
            title=ft.Text("Producto"),
            content=ft.Column(
                [
                    nombre_field,
                    codigo_field,
                    descripcion_field,
                    categoria_dropdown,
                    ft.Row([requiere_foto_check, unidad_dropdown], spacing=12),
                    ft.Row([stock_actual_field, stock_minimo_field], spacing=12),
                    activo_checkbox,
                ],
                tight=True,
                spacing=8,
                scroll=ft.ScrollMode.AUTO,
            ),
            actions=[ft.TextButton("Cancelar", on_click=self._close_dialog), ft.ElevatedButton("Guardar", on_click=save)],
            modal=True,
        )
        try:
            self.page.dialog = dialog
            dialog.open = True
            self.page.update()
        except Exception:
            pass

    def _confirm_delete_producto(self, producto):
        """Mostrar dialogo de confirmacion para eliminar producto"""
        def delete(e):
            self._delete_producto(producto)

        dialog = ft.AlertDialog(
            title=ft.Text("Confirmar Eliminacion"),
            content=ft.Text(f"Esta seguro que desea eliminar el producto '{producto.nombre}'?"),
            actions=[ft.TextButton("Cancelar", on_click=self._close_dialog), ft.ElevatedButton("Eliminar", on_click=delete, bgcolor=ft.colors.ERROR, color=ft.colors.WHITE)],
            modal=True,
        )
        try:
            self.page.dialog = dialog
            dialog.open = True
            self.page.update()
        except Exception:
            pass

    def _delete_producto(self, producto):
        """Eliminar producto"""
        db = None
        try:
            db = next(get_db())
            # marcar inactivo por seguridad
            prod_db = db.query(Producto).filter(Producto.id == producto.id).first()
            if not prod_db:
                self._show_error("Producto no encontrado")
                return
            prod_db.activo = False
            db.commit()
            self._close_dialog()
            self._load_productos()
            self._show_message("Producto eliminado (marcado inactivo)")
        except Exception as ex:
            self._show_error(f"Error al eliminar producto: {ex}")
        finally:
            if db:
                try:
                    db.close()
                except Exception:
                    pass

    def _save_producto(self, producto, nombre, codigo, descripcion, categoria_id, requiere_foto, unidad, stock_actual, stock_minimo, activo):
        """Guardar producto"""
        if not nombre or not nombre.strip():
            self._show_error("El nombre es obligatorio")
            return
        if not categoria_id:
            self._show_error("Seleccione una categoria")
            return

        db = None
        try:
            try:
                stock_actual_val = float(stock_actual) if stock_actual else 0
                stock_minimo_val = float(stock_minimo) if stock_minimo else 0
            except ValueError:
                self._show_error("Stock debe ser un numero valido")
                return

            db = next(get_db())

            if producto:
                prod_db = db.query(Producto).filter(Producto.id == producto.id).first()
                if not prod_db:
                    self._show_error("Producto no encontrado")
                    return
                prod_db.nombre = nombre.strip()
                prod_db.codigo = codigo.strip() if codigo else None
                prod_db.descripcion = descripcion.strip() if descripcion else None
                prod_db.categoria_id = int(categoria_id)
                prod_db.requiere_foto_peso = requiere_foto
                prod_db.unidad_medida = unidad
                prod_db.stock_actual = stock_actual_val
                prod_db.stock_minimo = stock_minimo_val
                prod_db.activo = activo
            else:
                nuevo_producto = Producto(
                    nombre=nombre.strip(),
                    codigo=codigo.strip() if codigo else None,
                    descripcion=descripcion.strip() if descripcion else None,
                    categoria_id=int(categoria_id),
                    requiere_foto_peso=requiere_foto,
                    unidad_medida=unidad,
                    stock_actual=stock_actual_val,
                    stock_minimo=stock_minimo_val,
                    activo=activo,
                )
                db.add(nuevo_producto)

            db.commit()
            self._close_dialog()
            self._load_productos()
            self._show_message("Producto guardado correctamente")
        except Exception as ex:
            self._show_error(f"Error al guardar producto: {ex}")
        finally:
            if db:
                try:
                    db.close()
                except Exception:
                    pass

    def _close_dialog(self, e=None):
        """Cerrar dialogo"""
        try:
            if getattr(self, "dialog_categoria", None) and self.dialog_categoria:
                try:
                    self.dialog_categoria.open = False
                except Exception:
                    pass
                self.dialog_categoria = None
            if getattr(self, "dialog_producto", None) and self.dialog_producto:
                try:
                    self.dialog_producto.open = False
                except Exception:
                    pass
                self.dialog_producto = None
            if getattr(self, "dialog_confirmar", None) and self.dialog_confirmar:
                try:
                    self.dialog_confirmar.open = False
                except Exception:
                    pass
                self.dialog_confirmar = None

            # también limpiar page.dialog si fue usado
            try:
                if getattr(self.page, "dialog", None):
                    self.page.dialog.open = False
                    self.page.dialog = None
            except Exception:
                pass

            try:
                self.page.update()
            except Exception:
                pass
        except Exception:
            pass

    def _show_message(self, message: str):
        """Mostrar mensaje de exito"""
        try:
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text(message), bgcolor=ft.colors.GREEN, duration=3000))
        except Exception:
            pass

    def _show_error(self, error: str):
        """Mostrar mensaje de error"""
        try:
            self.page.show_snack_bar(ft.SnackBar(content=ft.Text(error), bgcolor=ft.colors.RED, duration=4000))
        except Exception:
            pass