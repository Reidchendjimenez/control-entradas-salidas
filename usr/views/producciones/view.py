"""Orquestador del módulo Producciones.

Delega la lógica a submódulos:
- helpers.py: colores y utilidades
- data.py: carga y operaciones de negocio
- dialogs.py: diálogos
- recetas_view.py: tab Recetas
- pendientes_view.py: tab En Producción
- historial_view.py: tab Historial
"""
import flet as ft
import logging
import os
import asyncio

from usr.database.base import check_connection
from usr.views.producciones import data
from usr.views.producciones.helpers import colors as _colors
from usr.views.producciones.recetas_view import render_recetas
from usr.views.producciones.pendientes_view import build_pendientes_tab
from usr.views.producciones.historial_view import build_historial_tab

logger = logging.getLogger(__name__)


class ProduccionesView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.bgcolor = _colors(None)['bg']
        self.padding = ft.Padding.all(0)
        self._running = False

        self._recetas = []
        self._productos = []

        self.tabs = ft.Tabs(
            length=3,
            selected_index=0,
            animation_duration=300,
            on_change=self._on_tab_change,
            content=ft.Column(controls=[
                ft.TabBar(tabs=[
                    ft.Tab(label="Recetas", icon=ft.Icons.DESCRIPTION_OUTLINED),
                    ft.Tab(label="En Producción", icon=ft.Icons.PENDING_ACTIONS),
                    ft.Tab(label="Historial", icon=ft.Icons.HISTORY_OUTLINED),
                ]),
            ]),
        )

        self.recetas_container = ft.Container(expand=True, padding=ft.Padding.all(0))
        self.recetas_list = ft.Column(spacing=8, scroll=ft.ScrollMode.ALWAYS, expand=True)
        self.pendientes_container = ft.Container(expand=True, padding=ft.Padding.all(20), visible=False)
        self.historial_container = ft.Container(expand=True, padding=ft.Padding.all(20), visible=False)
        self.editor_container = ft.Container(expand=True, padding=0, bgcolor=_colors(None)['bg'], visible=False)

        self._connection_indicator = ft.Icon(
            ft.Icons.CLOUD_OFF, size=20, color=_colors(None)['error'], tooltip="Sin conexión",
        )

    def did_mount(self):
        trace = os.environ.get("TRACE_SWITCH") == "1"
        def tr(msg):
            if trace:
                print(f"[SWITCH] did_mount(Producciones) | {msg}")
        tr(f"ENTRADA (_mounted={getattr(self, '_mounted', 'unset')}, content={'SÍ' if getattr(self, 'content', None) else 'no'})")
        try:
            try:
                page = self.page
            except RuntimeError:
                tr("SALIDA: page sin montar")
                return

            # En cada montaje se reestablece el flag de ejecución; will_unmount
            # lo apaga al desmontar y el guard _mounted no debe impedir restaurarlo.
            self._running = True

            if getattr(self, '_mounted', False):
                tr("SALIDA: ya montada")
                return

            # Marcar SIEMPRE al inicio (antes de construir/actualizar). Una
            # llamada reentrante a did_mount (por update() interno durante el
            # build o la serialización) debe ser no-op inmediato; si el flag se
            # asigna al final, la reentrada entra al cuerpo completo y deja la
            # vista sin pintar en web.
            self._mounted = True

            if not getattr(self, 'content', None):
                self._build_ui()
                tr(f"controles construidos (content={'SÍ' if self.content else 'no'})")
            else:
                tr("content ya existía; no se reconstruyó")
            self._update_connection_indicator()
            tr("COMPLETO (_mounted=True)")
        except Exception as e:
            self._mounted = False
            logger.error(f"Error en did_mount de ProduccionesView: {e}", exc_info=True)
            tr(f"EXCEPCIÓN: {e}")

    def will_unmount(self):
        self._running = False

    def on_view_shown(self):
        # Al mostrar la vista: devuelve el futuro de la carga.
        if self.page:
            return self.page.run_task(self._load_data)

    def on_theme_change(self):
        self._update_colors()

    def _update_colors(self):
        colors = _colors(self.page)
        self.bgcolor = colors['bg']
        if hasattr(self, 'editor_container') and self.editor_container:
            self.editor_container.bgcolor = colors['bg']

    def _update_connection_indicator(self):
        try:
            c = _colors(self.page)
            is_online = check_connection()
            self._connection_indicator.icon = ft.Icons.CLOUD_DONE if is_online else ft.Icons.CLOUD_OFF
            self._connection_indicator.color = c['success'] if is_online else c['error']
            self._connection_indicator.tooltip = "Conectado" if is_online else "Sin conexión"
            try:
                _ = self._connection_indicator.page
                self._connection_indicator.update()
            except RuntimeError:
                pass
        except Exception:
            pass

    def _build_ui(self):
        colors = _colors(self.page)

        self.recetas_container.content = ft.Column([
            ft.Container(
                content=ft.Row([
                    ft.Text("", expand=True),
                    ft.ElevatedButton(
                        content="+ Nueva Receta",
                        icon=ft.Icons.ADD,
                        bgcolor=colors['accent'],
                        color=colors['white'],
                        on_click=lambda _: self._open_nueva_receta(),
                    ),
                ], spacing=8, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                padding=ft.Padding.only(left=20, top=10, right=20, bottom=4),
            ),
            ft.Container(
                content=self.recetas_list,
                expand=True,
                padding=ft.Padding.only(left=20, top=0, right=20, bottom=20),
            ),
        ])
        self.pendientes_container.content = build_pendientes_tab(self.page, on_change=self._on_pendiente_change)
        self.historial_container.content = build_historial_tab(self.page)

        self.content = ft.Column([
            self.tabs,
            ft.Container(
                content=ft.Stack([
                    self.recetas_container,
                    self.pendientes_container,
                    self.historial_container,
                    self.editor_container,
                ]),
                expand=True,
            ),
        ], expand=True, spacing=0)

    def get_header_actions(self):
        return [self._connection_indicator]

    def _open_nueva_receta(self):
        self._open_editor(None)

    def _open_edit_receta(self, receta):
        self._open_editor(receta)

    def _open_editor(self, receta):
        from usr.views.producciones.receta_editor import RecetaEditor
        editor = RecetaEditor(
            self.page,
            self._productos,
            receta=receta,
            on_saved=self._on_editor_saved,
            on_cancel=self._on_editor_cancel,
        )
        self.editor_container.content = editor
        self.editor_container.bgcolor = editor.bgcolor
        self.editor_container.visible = True
        self.recetas_container.visible = False
        self.pendientes_container.visible = False
        self.historial_container.visible = False
        self.tabs.visible = False
        # Forzar actualización del Stack y refresco total de la página
        if self.page:
            try:
                self.editor_container.update()
            except Exception:
                pass
            self.page.update()

    def _on_editor_saved(self):
        self.editor_container.visible = False
        self.editor_container.content = None
        self.tabs.visible = True
        self.recetas_container.visible = True
        self._refresh_recetas()
        if self.page:
            self.page.update()

    def _on_editor_cancel(self):
        self.editor_container.visible = False
        self.editor_container.content = None
        self.tabs.visible = True
        self.recetas_container.visible = True
        if self.page:
            self.page.update()

    def _on_pendiente_change(self):
        """Tras descargar/cancelar, refrescar pendientes y recetas (dropdown)."""
        self.pendientes_container.content = build_pendientes_tab(self.page, on_change=self._on_pendiente_change)
        if self.page:
            self.page.update()

    def _on_tab_change(self, e):
        idx = self.tabs.selected_index
        self.recetas_container.visible = idx == 0
        self.pendientes_container.visible = idx == 1
        self.historial_container.visible = idx == 2
        if idx == 2 and self.page:
            self.historial_container.content = build_historial_tab(self.page)
        if self.page:
            self.page.update()

    async def _load_data(self):
        # Lecturas de BD en hilo aparte para no bloquear el event loop ni el
        # barrido de entrada; el render de controles queda en el hilo principal.
        self._recetas = await asyncio.to_thread(data.load_recetas)
        self._productos = await asyncio.to_thread(data.load_productos)
        
        # Precargar componentes de todas las recetas para evitar N+1 queries en el render
        componentes_por_receta = {}
        for receta in self._recetas:
            componentes_por_receta[receta['id']] = await asyncio.to_thread(data.load_componentes, receta['id'])
        
        render_recetas(
            self.page, self._recetas, self._productos, componentes_por_receta,
            self.recetas_list,
            on_change=self._refresh_recetas,
            on_edit=self._open_edit_receta,
        )
        self._update_connection_indicator()

    def _refresh_recetas(self):
        self._recetas = data.load_recetas()
        # Recargar componentes para todas las recetas
        componentes_por_receta = {}
        for receta in self._recetas:
            componentes_por_receta[receta['id']] = data.load_componentes(receta['id'])
        
        render_recetas(
            self.page, self._recetas, self._productos, componentes_por_receta,
            self.recetas_list,
            on_change=self._refresh_recetas,
            on_edit=self._open_edit_receta,
        )
        if self.page:
            self.page.update()

    def on_sync_complete(self):
        self._refresh_recetas()
        if self.tabs.selected_index == 2:
            self.historial_container.content = build_historial_tab(self.page)
        elif self.tabs.selected_index == 1:
            self.pendientes_container.content = build_pendientes_tab(self.page, on_change=self._on_pendiente_change)
