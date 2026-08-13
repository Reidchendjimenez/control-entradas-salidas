import asyncio
import time
import logging
import flet as ft
from sqlalchemy.orm import joinedload
from usr.models import Categoria, Producto
from usr.database.base import get_db_adaptive, is_online
from usr.notifications import show_error
from usr.views.configuracion.helpers import _colors
from usr.views.configuracion.categorias import show_categoria_dialog, create_categoria_grid, create_categoria_item_mobile
from usr.views.configuracion.productos import show_producto_dialog, create_producto_item
from usr.views.configuracion.proveedores import build_proveedores_tab, load_proveedores
from usr.views.configuracion.sistema import build_sistema_tab
from usr.views.configuracion.periodos import build_periodos_tab

logger = logging.getLogger(__name__)


def _get_tipo_label(tipo):
    labels = {
        "PRODUCTO PARA USO INTERNO": "Uso Interno",
        "PRODUCTOS PARA LA VENTA": "Venta",
        "INSUMOS": "Insumo",
    }
    return labels.get(tipo)


class ConfiguracionView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.padding = 0
        self.bgcolor = _colors(None)['bg']

        self.selected_image_path = None
        self.active_dialog = None
        self.active_snackbar = None
        self.is_mobile = False

        self.lista_categorias = ft.ListView(expand=True, spacing=12, auto_scroll=False)
        self.lista_productos = ft.ListView(expand=True, spacing=12, auto_scroll=False)
        self.test_result_text = ft.Text("", size=14, weight=ft.FontWeight.BOLD)

        is_online_flag = is_online()

        self.offline_status_indicator = ft.Text(
            "ONLINE" if is_online_flag else "OFFLINE",
            size=14,
            color=_colors(None)['success'] if is_online_flag else _colors(None)['error'],
            weight=ft.FontWeight.BOLD,
        )

    def did_mount(self):
        # Early exit if already fully initialized
        if getattr(self, '_fully_initialized', False):
            return
        try:
            try:
                page = self.page
            except RuntimeError:
                return
            if page:
                self.is_mobile = (page.width < 768) if page.width else False
                page.on_resize = self._on_resize
            if not self.content:
                self._build_ui()
            self._fully_initialized = True
            self._mounted = True
        except Exception as e:
            self._mounted = False
            logger.error(f"Error en did_mount de ConfiguracionView: {e}", exc_info=True)

    def on_theme_change(self):
        if not self.page:
            return
        colors = _colors(self.page)
        self.bgcolor = colors['bg']
        if hasattr(self, 'tema_switch') and self.tema_switch:
            try:
                self.tema_switch.value = self.page.theme_mode != ft.ThemeMode.LIGHT
            except Exception:
                pass
        self.update()

    def _on_resize(self, e):
        if self.page and self.page.width:
            self.is_mobile = self.page.width < 768
            self.update()

    def _build_ui(self):
        colors = _colors(self.page)

        self.tabs = ft.Tabs(
            selected_index=0,
            animation_duration=300,
            expand=True,
            length=5,
            content=ft.Column(controls=[
                ft.TabBar(scrollable=True, tabs=[
                    ft.Tab(label="Categorias", icon=ft.Icons.CATEGORY),
                    ft.Tab(label="Productos", icon=ft.Icons.INVENTORY_2),
                    ft.Tab(label="Proveedores", icon=ft.Icons.LOCAL_SHIPPING),
                    ft.Tab(label="Sistema", icon=ft.Icons.DASHBOARD_CUSTOMIZE),
                    ft.Tab(label="Periodos", icon=ft.Icons.CALENDAR_MONTH),
                ]),
                ft.TabBarView(expand=True, controls=[
                    self._build_categorias_tab(),
                    self._build_productos_tab(),
                    build_proveedores_tab(self),
                    build_sistema_tab(self),
                    build_periodos_tab(self),
                ]),
            ]),
        )

        self.content = ft.Column([self.tabs], expand=True, spacing=0)
        self.update()

    def get_header_actions(self):
        return []

    def on_view_shown(self):
        # Al mostrar la vista: devuelve el futuro de la carga.
        if self.page:
            from usr.database.sync_callbacks import schedule_load
            return schedule_load(self._load_data_async)

    def _build_categorias_tab(self):
        colors = _colors(self.page)
        fab_content = ft.Row([
            ft.Icon(ft.Icons.ADD, size=20),
            ft.Text("Nueva Categoria" if not self.is_mobile else "Nueva", weight=ft.FontWeight.BOLD),
        ], alignment=ft.MainAxisAlignment.CENTER, spacing=8)

        self.categoria_search = ft.TextField(
            hint_text="Buscar categorias...",
            prefix_icon=ft.Icons.SEARCH,
            border_radius=10,
            bgcolor=colors['card'],
            border_color=colors['border'],
            height=40,
            expand=True,
            on_change=self._filter_categorias,
        )

        return ft.Container(
            content=ft.Column([
                ft.Container(height=15),
                ft.Row([
                    self.categoria_search,
                    ft.Container(
                        content=fab_content,
                        bgcolor=colors['accent'],
                        padding=ft.Padding.symmetric(horizontal=20, vertical=12),
                        border_radius=30,
                        on_click=lambda _: show_categoria_dialog(self),
                    ),
                ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN, spacing=10),
                ft.Container(height=15),
                self.lista_categorias,
            ], expand=True, spacing=0),
            padding=20,
            expand=True,
        )

    def _build_productos_tab(self):
        colors = _colors(self.page)

        self.producto_cat_filter = ft.Dropdown(
            label="Filtrar por categoria",
            options=[],
            value=None,
            border_radius=10,
            bgcolor=colors['card'],
            border_color=colors['border'],
            width=200,
            on_select=self._filter_productos,
        )

        self.producto_search = ft.TextField(
            hint_text="Buscar productos...",
            prefix_icon=ft.Icons.SEARCH,
            border_radius=10,
            bgcolor=colors['card'],
            border_color=colors['border'],
            height=40,
            expand=True,
            on_change=self._filter_productos,
        )

        return ft.Container(
            content=self.lista_productos,
            padding=20,
            expand=True,
        )

    def _build_producto_header(self):
        colors = _colors(self.page)
        fab_content = ft.Row([
            ft.Icon(ft.Icons.ADD_BOX, size=20),
            ft.Text("Nuevo Producto" if not self.is_mobile else "Nuevo", weight=ft.FontWeight.BOLD),
        ], alignment=ft.MainAxisAlignment.CENTER, spacing=8)

        fab_btn = ft.Container(
            content=fab_content,
            bgcolor=colors['success'],
            padding=ft.Padding.symmetric(horizontal=20, vertical=12),
            border_radius=30,
            on_click=lambda _: show_producto_dialog(self),
        )

        if self.is_mobile:
            self.producto_cat_filter.width = None
            self.producto_cat_filter.expand = True
            filtros_col = ft.Column([
                self.producto_cat_filter,
                ft.Row([
                    self.producto_search,
                    fab_btn,
                ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN, spacing=10, vertical_alignment=ft.CrossAxisAlignment.CENTER),
            ], spacing=10)
        else:
            filtros_col = ft.Row([
                self.producto_cat_filter,
                self.producto_search,
                fab_btn,
            ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN, spacing=10, vertical_alignment=ft.CrossAxisAlignment.CENTER)

        return ft.Container(
            content=ft.Column([
                filtros_col,
                ft.Divider(height=1, color=colors['border']),
            ], spacing=15),
            padding=ft.Padding.only(bottom=10),
        )

    async def _load_data_async(self):
        """Cargar datos en background con progress ring"""
        # Si ya tenemos datos en cache, no recargar
        if hasattr(self, 'categorias_cache') and self.categorias_cache:
            return
            
        self.is_mobile = self.page.width < 768 if self.page else False

        # Mostrar progress ring inmediatamente
        if self.page:
            try:
                self.lista_categorias.controls = [ft.Container(
                    ft.Column([ft.ProgressRing(), ft.Text("Cargando categorias...", size=12)],
                              horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=10),
                    alignment=ft.Alignment.CENTER, padding=50
                )]
                self.lista_productos.controls = [ft.Container(
                    ft.Column([ft.ProgressRing(), ft.Text("Cargando productos...", size=12)],
                              horizontal_alignment=ft.CrossAxisAlignment.CENTER, spacing=10),
                    alignment=ft.Alignment.CENTER, padding=50
                )]
                self.page.update()
            except:
                pass

        # Ceder control al event loop para que renderice el ProgressRing
        await asyncio.sleep(0)

        # Cargar en background (thread pool para no bloquear event loop)
        try:
            db = await asyncio.to_thread(next, get_db_adaptive())
            cats = await asyncio.to_thread(
                lambda: db.query(Categoria).filter(Categoria.activo == True).all()
            )
            prods = await asyncio.to_thread(
                lambda: db.query(Producto).filter(Producto.activo == True).options(
                    joinedload(Producto.categoria)
                ).all()
            )

            self.categorias_cache = cats
            self.productos_cache = prods

            self.producto_cat_filter.options = [
                ft.dropdown.Option("", "Todas las categorias")
            ] + [ft.dropdown.Option(str(c.id), c.nombre) for c in cats]

            if self.is_mobile:
                self.lista_categorias.controls = [create_categoria_item_mobile(self, c) for c in cats]
            else:
                self.lista_categorias.controls = create_categoria_grid(self, cats)

            self.lista_productos.controls = [self._build_producto_header()] + [create_producto_item(self, p) for p in prods]

            await asyncio.to_thread(load_proveedores, self)

            self.update()
            self._apply_producto_filters()
            await asyncio.to_thread(db.close)
        except Exception as e:
            show_error(f"Error al cargar datos: {str(e)}")
            if 'db' in locals():
                await asyncio.to_thread(db.close)

    def _filter_categorias(self, e=None):
        if not hasattr(self, 'categorias_cache'):
            return
        self._last_cat_search = time.time()
        self.page.run_task(self._debounced_filter_categorias)

    async def _debounced_filter_categorias(self):
        await asyncio.sleep(0.3)
        if time.time() - self._last_cat_search < 0.3:
            return
        search = self.categoria_search.value.lower() if self.categoria_search.value else ""
        filtered = [c for c in self.categorias_cache if search in c.nombre.lower()]
        if self.is_mobile:
            self.lista_categorias.controls = [create_categoria_item_mobile(self, c) for c in filtered]
        else:
            self.lista_categorias.controls = create_categoria_grid(self, filtered)
        self.update()

    def _filter_productos(self, e=None):
        if not hasattr(self, 'productos_cache'):
            return
        self._last_prod_search = time.time()
        self.page.run_task(self._debounced_filter_productos)

    async def _debounced_filter_productos(self):
        await asyncio.sleep(0.3)
        if time.time() - self._last_prod_search < 0.3:
            return
        self._apply_producto_filters()

    def _apply_producto_filters(self):
        search = self.producto_search.value.lower() if self.producto_search.value else ""
        cat_val = self.producto_cat_filter.value
        filtered = self.productos_cache
        if search:
            filtered = [p for p in filtered if search in p.nombre.lower()]
        if cat_val:
            filtered = [p for p in filtered if str(p.categoria_id) == cat_val]
        self.lista_productos.controls = [self._build_producto_header()] + [create_producto_item(self, p) for p in filtered]
        self.update()

    def refresh(self):
        self.is_mobile = self.page.width < 768 if self.page else False
        self.page.run_task(self._load_data_async)
