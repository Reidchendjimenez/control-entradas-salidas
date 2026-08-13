import warnings
warnings.filterwarnings("ignore", category=PendingDeprecationWarning)

import asyncio
import logging
import os
import time
import traceback
import flet as ft
from datetime import datetime

from usr.database.base import get_db_adaptive
from usr.database.sync_callbacks import register_sync_callback, unregister_sync_callback
from usr.models import Requisicion, RequisicionDetalle, Producto, Existencia
from usr.theme import get_colors
from usr.notifications import show_success, show_error, show_warning, show_info

from usr.views.requisiciones.helpers import _colors, _c
from usr.views.requisiciones.data import load_requisiciones, guardar_requisicion, eliminar_requisicion
from usr.views.requisiciones.components import (
    build_requisicion_card, build_empty_state, build_producto_busqueda_item
)
from usr.views.requisiciones.dialogs import (
    build_crear_dialog, build_agregar_producto_dialog, build_detalles_dialog,
    build_crear_vista, build_buscador_productos, build_agregar_producto_req_dialog,
)
from usr.views.requisiciones.visualize_view import VisualizeView
from usr.views.requisiciones.audit_view import AuditView

logger = logging.getLogger(__name__)


class RequisicionesView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.bgcolor = get_colors(None)['bg']
        self.padding = 0

        self.requisiciones_list = ft.ListView(expand=True, spacing=10, padding=20)
        self.detalles_temp = []
        self.active_dialog = None
        self.inventario_view = None
        self.app_controller = None

        self._vista_actual = "lista"
        self.lista_productos_req = []
        self._requisicion_editando = None
        self._origen_dropdown = None
        self._productos_lista_req = None
        self._bs_buscador = None
        self.loading_overlay = None

    def on_theme_change(self):
        if not self.page:
            return
        colors = _colors(self.page)
        self.bgcolor = colors['bg']
        try:
            self._build_ui()
        except Exception:
            pass

    def _sync_indicator(self):
        """Indicador de estado de la cola de sync (pendientes/fallidos/ok)."""
        self.sync_indicator = ft.Container(
            content=ft.Row(
                [ft.Icon(ft.Icons.CLOUD_SYNC, size=18, color=self.colors['text_secondary']),
                 ft.Text("—", size=12, color=self.colors['text_secondary'], weight="w500")],
                spacing=5, tight=True,
            ),
            padding=ft.Padding.only(left=10, top=6, right=10, bottom=6),
            border_radius=15,
            bgcolor=self.colors['bg'],
            tooltip="Estado de sincronización",
            on_click=self._on_sync_indicator_click,
        )
        self._update_sync_indicator()
        return self.sync_indicator

    def _on_sync_indicator_click(self, e):
        """Al pulsar: refresca el estado y muestra los errores si hay fallidos."""
        try:
            try:
                page = self.page
            except RuntimeError:
                return
            self._update_sync_indicator()
            if not page:
                return
            from usr.database.sync_queue import get_sync_queue
            from usr.database.conn import get_local_conn
            conn = get_local_conn()
            cursor = conn.cursor()
            cursor.execute("""
                SELECT table_name, operation, last_error, retries
                FROM sync_queue
                WHERE status = 'failed'
                ORDER BY created_at DESC
                LIMIT 10
            """)
            rows = cursor.fetchall()
            conn.close()
            if not rows:
                self._show_sync_estado_dialog()
                return
            lines = []
            for r in rows:
                nombre = r['table_name'] or '?'
                op = r['operation'] or '?'
                err = (r['last_error'] or 'error desconocido').split('\\n')[0][:80]
                lines.append(f"• {nombre} ({op}): {err}")
            dlg = ft.AlertDialog(
                title=ft.Text(f"Errores de sincronización ({len(rows)})", size=16, weight="bold"),
                content=ft.Column(
                    [ft.Text(ln, size=12, color=self.colors['error']) for ln in lines],
                    scroll=ft.ScrollMode.AUTO, tight=True, spacing=6,
                ),
                actions=[
                    ft.TextButton("Cerrar", on_click=lambda _: self._close_sync_dialog(dlg)),
                    ft.ElevatedButton("Reintentar ahora", on_click=lambda _: self._retry_sync(dlg)),
                ],
                actions_alignment=ft.MainAxisAlignment.END,
            )
            page.overlay.append(dlg)
            dlg.open = True
            page.update()
        except Exception as e:
            print(f"[REQ] Error en click indicador sync: {e}")

    def _close_sync_dialog(self, dlg):
        dlg.open = False
        try:
            self.page.overlay.remove(dlg)
        except Exception:
            pass
        self.page.update()

    def _retry_sync(self, dlg):
        try:
            self._close_sync_dialog(dlg)
            self._on_refresh()
        except Exception as e:
            print(f"[REQ] Error reintentando sync: {e}")

    def _show_sync_estado_dialog(self):
        try:
            page = self.page
        except RuntimeError:
            return
        if not page:
            return
        dlg = ft.AlertDialog(
            title=ft.Text("Estado de sincronización", size=16, weight="bold"),
            content=ft.Text("Todo sincronizado correctamente.", size=13),
            actions=[ft.TextButton("OK", on_click=lambda _: self._close_sync_dialog(dlg))],
            actions_alignment=ft.MainAxisAlignment.END,
        )
        page.overlay.append(dlg)
        dlg.open = True
        page.update()

    def _update_sync_indicator(self):
        """Lee la cola de sync y pinta el indicador: ok / pendientes / fallidos."""
        try:
            colors = _colors(self.page)
            from usr.database.sync_queue import get_sync_queue
            status = get_sync_queue().get_status()
            pending = status.get('pending', 0)
            failed = status.get('failed', 0)

            if failed > 0:
                icon = ft.Icons.ERROR_ROUNDED
                color = colors['error']
                text = f"{failed} error(es)"
                tip = f"{failed} operaciones fallaron y se reintentarán. Pulse para ver."
            elif pending > 0:
                icon = ft.Icons.CLOUD_UPLOAD
                color = colors['warning']
                text = f"{pending} pendiente(s)"
                tip = f"{pending} cambios sin subir a Supabase todavía."
            else:
                last = status.get('last_sync')
                if last and len(last) >= 16:
                    last = last[:16]
                icon = ft.Icons.CLOUD_DONE
                color = colors['success']
                text = "sincronizado"
                tip = f"Todo subido. Último sync: {last}" if last else "Todo subido."
            self.sync_indicator.content = ft.Row(
                [ft.Icon(icon, size=18, color=color),
                 ft.Text(text, size=12, color=color, weight="w500")],
                spacing=5, tight=True,
            )
            self.sync_indicator.tooltip = tip
            self.update()
        except Exception as e:
            print(f"[REQ] Error actualizando indicador sync: {e}")

    def _build_ui(self):
        self.colors = _colors(self.page)
        self._sync_indicator()
        self._btn_refresh = ft.IconButton(
            ft.Icons.REFRESH_ROUNDED,
            icon_color=self.colors['white'],
            bgcolor=self.colors['surface'],
            on_click=lambda _: self._on_refresh(),
            tooltip="Actualizar desde Supabase",
        )
        self._btn_agregar = ft.IconButton(
            ft.Icons.ADD_ROUNDED,
            icon_color=self.colors['white'],
            bgcolor=self.colors['accent'],
            on_click=lambda _: self._show_crear_vista(),
            tooltip="Nueva requisición",
        )

        self.list_container = ft.Container(
            content=self.requisiciones_list,
            expand=True,
            bgcolor=self.colors['bg'],
        )

        self.content = ft.Column([
            self.list_container,
        ], expand=True, spacing=0)
        self.content.bgcolor = self.colors['bg']

    async def _load_requisiciones_async(self):
        await asyncio.to_thread(self._load_requisiciones)

    def get_header_actions(self):
        return [self.sync_indicator, self._btn_refresh, self._btn_agregar]

    def on_view_shown(self):
        trace = os.environ.get("TRACE_SWITCH") == "1"
        # Al re-mostrar, volver siempre a la lista raíz (por si el usuario había
        # quedado en una sub-vista: visualizar/auditar) SIN recrear controles,
        # reutilizando el list_container ya montado.
        try:
            if getattr(self, '_vista_actual', 'lista') != 'lista':
                if trace:
                    print(f"[SWITCH] on_view_shown(Req) reinicia sub-vista {self._vista_actual} → lista")
                self._vista_actual = 'lista'
                if getattr(self, 'list_container', None) is not None:
                    self.content = ft.Column([self.list_container], expand=True, spacing=0)
        except Exception:
            pass
        # Al mostrar la vista: devuelve el futuro de la carga.
        if self.page:
            from usr.database.sync_callbacks import schedule_load
            return schedule_load(self._load_requisiciones_async)

    def did_mount(self):
        trace = os.environ.get("TRACE_SWITCH") == "1"
        t0 = time.monotonic()
        def tr(msg):
            if trace:
                print(f"[SWITCH] did_mount(Requisiciones) ±{time.monotonic()-t0:.3f}s | {msg}")
        tr(f"ENTRADA (_mounted={getattr(self, '_mounted', 'unset')}, content={'SÍ' if getattr(self, 'content', None) else 'no'})")
        try:
            try:
                page = self.page
            except RuntimeError:
                tr("SALIDA: page sin montar (RuntimeError)")
                return

            # En cada montaje se re-registra el callback de sync (idempotente);
            # will_unmount lo desregistra y el guard _mounted no debe impedirlo.
            register_sync_callback(self._on_sync_complete)

            if getattr(self, '_mounted', False):
                tr("SALIDA: ya montada (solo re-registro callback)")
                return

            # Marcar SIEMPRE al inicio (antes de construir/actualizar). Una
            # llamada reentrante a did_mount (por update() interno durante el
            # build o la serialización) debe ser no-op inmediato; si el flag se
            # asigna al final, la reentrada entra al cuerpo completo y deja la
            # vista sin pintar en web.
            self._mounted = True

            # Construir el contenido UNA SOLA VEZ. Antes se llamaba a _build_ui()
            # dos veces en el primer montaje (guard + llamada incondicional), lo
            # que recreaba list_container/sync_indicator/botones/content por
            # duplicado y el cliente terminaba sin recibir el contenido.
            if not getattr(self, 'content', None):
                self._build_ui()
                tr(f"controLES NUEVOS construidos (content={'SÍ' if self.content else 'no'})")
            else:
                tr("content ya existía; no se reconstruyó")

            tr("COMPLETO (_mounted=True)")
        except Exception as e:
            self._mounted = False
            from usr.error_handler import show_error
            logger.error(f"Error en did_mount de RequisicionesView: {e}", exc_info=True)
            tr(f"EXCEPCIÓN: {e}")

    def will_unmount(self):
        unregister_sync_callback(self._on_sync_complete)

    def _on_sync_complete(self):
        try:
            page = self.page
        except RuntimeError:
            return
        if page and self.visible:
            try:
                self._update_sync_indicator()
            except Exception:
                pass
            if self._vista_actual == "lista":
                async def _reload():
                    await asyncio.to_thread(self._load_requisiciones)
                from usr.database.sync_callbacks import run_when_connected
                run_when_connected(page, _reload)

    def on_sync_complete(self):
        self._on_sync_complete()

    def _on_refresh(self):
        """Fuerza una sincronización con Supabase y recarga la lista."""
        try:
            show_info("Actualizando requisiciones...", duration=1)
            self.page.run_task(self._do_refresh)
        except Exception as e:
            show_error("Error al refrescar", e)

    async def _do_refresh(self):
        try:
            from usr.database.base import is_online as base_is_online
            from usr.database import get_sync_manager

            if base_is_online():
                sync_mgr = get_sync_manager()
                if sync_mgr:
                    await asyncio.to_thread(sync_mgr.force_sync_now)
                await asyncio.to_thread(self._load_requisiciones)
            else:
                await asyncio.to_thread(self._load_requisiciones)
            self._update_sync_indicator()
            show_success("Requisiciones actualizadas")
        except Exception as e:
            logger.error(f"Error en _do_refresh de RequisicionesView: {e}")
            show_error("Error al actualizar requisiciones", e)

    def _load_requisiciones(self):
        trace = os.environ.get("TRACE_SWITCH") == "1"
        def tr(m):
            if trace:
                print(f"[SWITCH] _load_requisiciones(Req) | {m}")
        try:
            reqs = load_requisiciones()
            tr(f"BD: {len(reqs)} requisiciones; lista.controls={len(self.requisiciones_list.controls)}")

            self.requisiciones_list.controls.clear()

            if not reqs:
                self.requisiciones_list.controls.append(build_empty_state(_colors(self.page)))
            else:
                for req in reqs:
                    self.requisiciones_list.controls.append(
                        build_requisicion_card(
                            req,
                            {
                                "on_visualizar": lambda _=None, r=req: self._visualizar_requisicion(r),
                                "on_editar": lambda _=None, r=req: self._editar_requisicion(r),
                                "on_auditar": lambda _=None, r=req: self._auditar_requisicion(r),
                                "on_eliminar": lambda _=None, r=req: self._eliminar_requisicion(r),
                            },
                            _colors(self.page),
                        )
                    )

            try:
                if self.requisiciones_list.page is not None:
                    self.requisiciones_list.update()
            except RuntimeError:
                pass
            if self.list_container is not None:
                try:
                    if self.list_container.page is not None:
                        self.list_container.update()
                except RuntimeError:
                    pass
            if self.page:
                self.page.update()
            tr(f"pintado: lista.controls={len(self.requisiciones_list.controls)}, list_container={'SÍ' if self.list_container else 'NO'}, content={'SÍ' if self.content else 'NO'}, page=OK")
        except Exception as e:
            tr(f"EXCEPCIÓN: {e}")
            import traceback
            traceback.print_exc()

    def _editar_requisicion(self, req: Requisicion):
        if not self.page:
            return
        if req.estado == "completada":
            show_warning("No se puede editar una requisición completada")
            return
        self._show_crear_vista(requisicion=req)

    def _eliminar_requisicion(self, req: Requisicion):
        if not self.page:
            return
            
        def confirm_delete(_):
            if eliminar_requisicion(req.id):
                show_success(f"Requisición {req.numero} eliminada")
                import threading
                try:
                    from usr.database import get_sync_manager
                    sync_mgr = get_sync_manager()
                    if sync_mgr:
                        threading.Thread(target=sync_mgr.force_sync_now, daemon=True).start()
                except Exception:
                    pass
                self._load_requisiciones()
            else:
                show_error("Error al eliminar la requisición")
            dlg.open = False
            self.page.update()

        dlg = ft.AlertDialog(
            title=ft.Text("Eliminar Requisición"),
            content=ft.Text(f"¿Estás seguro de que deseas eliminar la requisición {req.numero}? Esta acción no se puede deshacer."),
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: setattr(dlg, 'open', False)),
                ft.ElevatedButton("Eliminar", on_click=confirm_delete, bgcolor=self.colors['error'], color=self.colors['white']),
            ]
        )
        self.page.overlay.append(dlg)
        dlg.open = True
        self.page.update()

    def _visualizar_requisicion(self, req: Requisicion):
        self._vista_actual = "visualizar"
        self.content = VisualizeView(req, on_back=self._volver_lista)
        self.update()

    def _auditar_requisicion(self, req: Requisicion):
        if req.estado != "pendiente":
            show_warning("Solo se pueden auditar requisiciones pendientes")
            return
        self._vista_actual = "auditar"
        self.content = AuditView(req.id, on_back=self._volver_lista)
        self.update()

    def _show_crear_dialog(self):
        build_crear_dialog(self)

    def _show_agregar_producto_dialog(self, productos_container):
        build_agregar_producto_dialog(self, productos_container)

    def _eliminar_producto_row(self, btn, container):
        for fila in container.controls:
            if btn in fila.controls:
                container.controls.remove(fila)
                container.update()
                break

    def _filtrar_productos_busqueda(self, texto, productos, container, on_agregar=None):
        colors = _colors(self.page)
        on_agregar = on_agregar or (lambda p: None)
        container.controls.clear()

        if not texto or len(texto) < 1:
            for p in productos[:20]:
                container.controls.append(build_producto_busqueda_item(p, on_agregar, colors))
        else:
            texto_lower = texto.lower()
            filtrados = [p for p in productos if texto_lower in p.nombre.lower()]
            for p in filtrados[:20]:
                container.controls.append(build_producto_busqueda_item(p, on_agregar, colors))

        container.update()

    def _cerrar_dialog(self, dialog):
        dialog.open = False
        self.page.update()

    def _close_dialog(self):
        if self.active_dialog:
            self.active_dialog.open = False
            self.page.update()

    def _show_detalles(self, req: Requisicion):
        build_detalles_dialog(self, req)

    def _show_crear_vista(self, requisicion=None):
        build_crear_vista(self, requisicion)

    def _abrir_buscador_productos(self):
        build_buscador_productos(self)

    def _buscar_productos_buscador(self, texto, container):
        db = next(get_db_adaptive())
        try:
            query = db.query(Producto).filter(Producto.activo == True)
            if texto:
                query = query.filter(Producto.nombre.ilike(f"%{texto}%"))
            resultados = query.limit(30).all()
        finally:
            db.close()

        colors = _colors(self.page)
        container.controls.clear()

        for p in resultados:
            container.controls.append(build_producto_busqueda_item(p, self._agregar_producto_req, colors))

        if not resultados and texto:
            container.controls.append(
                ft.Text("Sin resultados", color=colors['text_secondary'], text_align="center")
            )

        container.update()

    def _agregar_producto_req(self, producto):
        db = next(get_db_adaptive())
        try:
            almacen_origen = getattr(self, '_origen_dropdown', None)
            origen = almacen_origen.value if almacen_origen else "principal"
            exist = db.query(Existencia).filter(
                Existencia.producto_id == producto.id,
                Existencia.almacen == origen,
            ).first()
            disponible = exist.cantidad if exist else 0
        finally:
            db.close()
        build_agregar_producto_req_dialog(self, producto, disponible)

    def _actualizar_lista_productos(self):
        colors = _colors(self.page)
        if self._productos_lista_req is None:
            return
        self._productos_lista_req.controls.clear()

        if not self.lista_productos_req:
            self._productos_lista_req.controls.append(
                ft.Container(
                    content=ft.Column([
                        ft.Icon(ft.Icons.CHAT_BUBBLE_OUTLINE, size=40, color=colors['text_hint']),
                        ft.Text("Toca + para agregar productos", color=colors['text_secondary'], text_align="center"),
                    ], horizontal_alignment="center", spacing=10),
                    alignment=ft.Alignment.CENTER,
                    expand=True,
                )
            )
        else:
            for i, item in enumerate(self.lista_productos_req):
                es_pesable = item.get('es_pesable', False)
                peso = item.get('peso', 0) or 0

                if es_pesable:
                    subtitulo = f"{peso:.2f} kg" if peso else f"{item['cantidad']} {item['unidad']}"
                else:
                    subtitulo = f"{item['cantidad']} {item['unidad']}"

                self._productos_lista_req.controls.append(
                    ft.Container(
                        content=ft.Row([
                            ft.Icon(ft.Icons.INVENTORY_2_OUTLINED, size=18, color=colors['accent']),
                            ft.Column([
                                ft.Text(item['nombre'], weight="bold", color=colors['text_primary'], size=13),
                                ft.Text(subtitulo, color=colors['text_secondary'], size=11),
                            ], expand=True, spacing=2),
                            ft.IconButton(
                                ft.Icons.CLOSE,
                                icon_size=18,
                                icon_color=colors['error'],
                                tooltip="Quitar",
                                on_click=lambda _, idx=i: self._eliminar_producto_req(idx),
                            ),
                        ], spacing=10, vertical_alignment="center"),
                        padding=ft.Padding.symmetric(horizontal=12, vertical=6),
                        bgcolor=colors['card'],
                        border_radius=8,
                        margin=ft.Margin.only(bottom=4),
                    )
                )

        if getattr(self._productos_lista_req, 'page', None) is not None:
            self._productos_lista_req.update()
            if self.lista_productos_req:
                try:
                    self.page.run_task(lambda: self._productos_lista_req.scroll_to(offset=-1, duration=150))
                except Exception:
                    pass

    def _eliminar_producto_req(self, idx):
        if idx < len(self.lista_productos_req):
            self.lista_productos_req.pop(idx)
            self._actualizar_lista_productos()

    def _set_loading_overlay(self, visible: bool, message: str = "Procesando..."):
        if not self.page:
            return

        def _find_loading_overlays():
            return [c for c in list(self.page.overlay) if getattr(c, '_es_overlay_carga', False)]

        if visible:
            # Remover cualquier overlay de carga previo para evitar duplicados
            for ov in _find_loading_overlays():
                try:
                    self.page.overlay.remove(ov)
                except Exception:
                    pass
            self.loading_overlay = None
            colors = _colors(self.page)
            overlay = ft.Container(
                content=ft.Container(
                    content=ft.Column([
                        ft.ProgressBar(width=200, color=colors['accent'], bgcolor=ft.Colors.TRANSPARENT),
                        ft.Text(message, size=13, color=colors['text_primary'], weight="w500", text_align=ft.TextAlign.CENTER),
                    ], tight=True, horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                    bgcolor=colors['card'],
                    padding=20,
                    border_radius=15,
                    border=ft.Border.all(1, colors.get('border')),
                    width=250,
                ),
                bgcolor=ft.Colors.with_opacity(0.5, ft.Colors.BLACK),
                alignment=ft.Alignment.CENTER,
                expand=True,
            )
            overlay._es_overlay_carga = True
            self.loading_overlay = overlay
            self.page.overlay.append(overlay)
            try:
                self.page.update()
            except Exception:
                pass
        else:
            self.loading_overlay = None
            removed = False
            for ov in _find_loading_overlays():
                try:
                    self.page.overlay.remove(ov)
                    removed = True
                except Exception:
                    pass
            if removed:
                try:
                    self.page.update()
                except Exception:
                    pass

    def _crear_requisicion_vista(self, origen_dropdown, destino_dropdown, observaciones):
        if not self.lista_productos_req:
            show_warning("Agregue al menos un producto")
            return
        self.page.run_task(self._do_crear_requisicion, origen_dropdown, destino_dropdown, observaciones)

    async def _do_crear_requisicion(self, origen_dropdown, destino_dropdown, observaciones):
        import asyncio
        origen = origen_dropdown.value or "principal"
        destino = destino_dropdown.value or "restaurante"
        user_id = (self.page.session.store.get("user_id") or "Admin") if self.page else "Admin"

        req_editando = getattr(self, '_requisicion_editando', None)
        try:
            self._set_loading_overlay(True, "Actualizando requisición..." if req_editando else "Guardando requisición...")
            if req_editando:
                await asyncio.to_thread(
                    guardar_requisicion,
                    origen=origen, destino=destino,
                    observaciones=observaciones.value or "",
                    detalles=self.lista_productos_req,
                    editando=req_editando, user_id=user_id,
                )
            else:
                await asyncio.to_thread(
                    guardar_requisicion,
                    origen=origen, destino=destino,
                    observaciones=observaciones.value or "",
                    detalles=self.lista_productos_req,
                    user_id=user_id, estado="pendiente", mover_stock=False,
                )

            if req_editando:
                show_success("Requisición actualizada")
            else:
                show_success(f"Requisición creada: {origen} → {destino}")

            self._set_loading_overlay(True, "Sincronizando...")
            ok = await asyncio.to_thread(self._sync_bloqueante)
            if ok:
                self._set_loading_overlay(False)
                self.lista_productos_req = []
                self._requisicion_editando = None
                self._volver_lista()
            else:
                await self._preguntar_reintentar(req_editando, origen, destino, observaciones, user_id)

        except Exception as ex:
            self._set_loading_overlay(False)
            logger.error(f"Error guardando requisición: {ex}")
            show_error(f"Error: {ex}")

    def _sync_bloqueante(self):
        try:
            from usr.database import get_sync_manager
            sync_mgr = get_sync_manager()
            if sync_mgr:
                return bool(sync_mgr.full_sync())
            return True
        except Exception:
            return False

    async def _preguntar_reintentar(self, req_editando, origen, destino, observaciones, user_id):
        colors = _colors(self.page)
        self._set_loading_overlay(False)
        dlg = ft.AlertDialog(
            modal=True,
            title=ft.Text("Error de sincronización"),
            content=ft.Text("No se pudo sincronizar. ¿Reintentar?"),
            actions=[
                ft.TextButton("No", on_click=lambda e: self._cerrar_dlg(dlg) or self._volver_lista()),
                ft.ElevatedButton("Reintentar", bgcolor=colors['accent'], color=colors['white'],
                    on_click=lambda e: self._cerrar_dlg(dlg) or self.page.run_task(self._reintentar_sync_req, req_editando, user_id)),
            ],
            actions_alignment=ft.MainAxisAlignment.END,
        )
        self.page.overlay.append(dlg)
        dlg.open = True
        self.page.update()

    async def _reintentar_sync_req(self, req_editando, user_id):
        import asyncio
        self._set_loading_overlay(True, "Reintentando sincronización...")
        ok = await asyncio.to_thread(self._sync_bloqueante)
        if ok:
            self._set_loading_overlay(False)
            show_success("Sincronización completada")
            self.lista_productos_req = []
            self._requisicion_editando = None
            self._volver_lista()
        else:
            await self._preguntar_reintentar(req_editando, None, None, None, user_id)

    def _cerrar_dlg(self, dlg):
        dlg.open = False
        try:
            self.page.overlay.remove(dlg)
        except Exception:
            pass
        self.page.update()

    def _volver_lista(self):
        self._vista_actual = "lista"
        self.lista_productos_req = []
        self._build_ui()
        self.update()
