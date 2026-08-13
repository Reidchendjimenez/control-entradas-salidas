import flet as ft
import asyncio
import os
import time
from sqlalchemy.orm import joinedload
from usr.database.base import get_db_adaptive, is_online
from usr.models import Movimiento
from usr.logger import get_logger
from usr.theme import get_colors
from usr.notifications import show_success, show_error
from usr.views.validacion import ValidacionDialog
from usr.database.sync_callbacks import register_sync_callback, unregister_sync_callback
from usr.whatsapp_notifier import (
    send_whatsapp_message, send_whatsapp_image,
    format_validation_message
)

logger = get_logger(__name__)


class ValidacionView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.padding = ft.Padding.only(left=10, right=10, bottom=16, top=8)
        self.bgcolor = get_colors(None)['bg']
        
        self.entradas_list = ft.ListView(expand=True, spacing=10, padding=ft.Padding.only(top=10))
        self.search_field = None
        self.selected_entradas = set()
        self.entradas_data = {}
        self.is_loading = False
        self.active_dialog = None
        self.validate_button = None
        self.clear_button = None
        self.cards_dict = {}
        self._connection_indicator = None
        self._connection_thread = None
        self.loading_overlay = None

    def did_mount(self):
        trace = os.environ.get("TRACE_SWITCH") == "1"
        t0 = time.monotonic()
        def tr(msg):
            if trace:
                print(f"[SWITCH] did_mount(Validacion) ±{time.monotonic()-t0:.3f}s | {msg}")
        tr(f"ENTRADA (_mounted={getattr(self, '_mounted', 'unset')})")
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
                tr("SALIDA: ya montada")
                return

            # Marcar SIEMPRE al inicio (antes de construir/actualizar). Una
            # llamada reentrante a did_mount (disparada por update() interno
            # durante el build o por la serialización) debe ser un no-op
            # inmediato; si el flag se asigna al final, la reentrada entra al
            # cuerpo completo y deja la vista sin pintar en web (el log
            # mostraba did_mount ejecutado 2-3 veces con _mounted=unset).
            self._mounted = True

            # Construir el contenido UNA SOLA VEZ. No hay hook build(): Flet
            # lo dispara automáticamente durante la serialización y reconstruir
            # aquí crearía dos generaciones de controles, dejando los on_click
            # del cliente desincronizados (vista visible pero no interactiva).
            if not self.content:
                self._build_controls()
                tr("controles construidos")

            # _update_connection_indicator() hace _connection_indicator.update()
            # que puede re-disparar did_mount; ya _mounted=True lo neutraliza.
            self._update_connection_indicator()
            self._start_connection_monitor()
            tr("COMPLETO (_mounted=True)")
        except Exception as e:
            self._mounted = False
            logger.error(f"Error en did_mount de ValidacionView: {e}", exc_info=True)
            tr(f"EXCEPCIÓN: {e}")

    def will_unmount(self):
        unregister_sync_callback(self._on_sync_complete)

    def on_view_shown(self):
        # Al mostrar la vista: devuelve el futuro de la carga para que el
        # controlador oculte el overlay solo cuando termine.
        if self.page:
            from usr.database.sync_callbacks import schedule_load
            return schedule_load(self._load_entradas_pendientes)

    def _on_sync_complete(self):
        try:
            page = self.page
        except RuntimeError:
            return
        if page and self.visible:
            from usr.database.sync_callbacks import run_when_connected
            run_when_connected(page, self._load_entradas_pendientes)

    def _update_connection_indicator(self):
        if not hasattr(self, '_connection_indicator') or not self._connection_indicator:
            return
        try:
            colors = get_colors(self.page)
            online = is_online()
            self._connection_indicator.content = ft.Icon(
                ft.Icons.WIFI if online else ft.Icons.WIFI_OFF,
                color=colors['success'] if online else colors['error'],
                size=18
            )
            self._connection_indicator.tooltip = "Conectado" if online else "Sin conexión"
            try:
                _ = self._connection_indicator.page
                self._connection_indicator.update()
            except RuntimeError:
                pass
        except:
            pass

    def _start_connection_monitor(self):
        import asyncio, time
        try:
            page = self.page
        except RuntimeError:
            return
        if not page:
            return

        # NO usar threading.Thread para actualizar la UI: en Flet web toda
        # actualización debe pasar por el event loop asyncio del servidor. Un
        # page.update()/control.update() lanzado desde un hilo crudo de Python
        # compite con el loop que publica el árbol y corrompe el protocolo
        # websocket, dejando la vista (y las siguientes) sin pintar. Se usa
        # page.run_task() con un loop async, como hace Historial.
        async def loop():
            while True:
                await asyncio.sleep(10)
                try:
                    page = self.page
                except RuntimeError:
                    continue
                # No competir con el barrido de cambio de vista: si hay una
                # transición en curso, omitir este ciclo (se reintenta en 10s).
                transitioning = bool(getattr(getattr(self, 'app_controller', None), '_switching_view', False))
                if transitioning:
                    continue
                self._update_connection_indicator()
                # Solo forzar refresh de la página si la vista está visible,
                # para no causar tirones al navegar mientras está oculta.
                if not self.visible:
                    continue
                try:
                    page.update()
                except:
                    pass
        try:
            page.run_task(loop)
        except Exception:
            pass

    def _set_loading_overlay(self, visible: bool, message: str = "Procesando..."):
        try:
            page = self.page
        except RuntimeError:
            return
        if not page: return

        def _find_loading_overlays():
            return [c for c in list(page.overlay) if getattr(c, '_es_overlay_carga', False)]

        if visible:
            # Remover cualquier overlay de carga previo para evitar duplicados
            for ov in _find_loading_overlays():
                try:
                    page.overlay.remove(ov)
                except Exception:
                    pass
            self.loading_overlay = None

            colors = get_colors(self.page)
            overlay = ft.Container(
                content=ft.Container(
                    content=ft.Column([
                        ft.ProgressBar(width=200, color=colors['accent'], bgcolor=ft.Colors.TRANSPARENT),
                        ft.Text(message, size=13, color=colors['text_primary'], weight="w500", text_align=ft.TextAlign.CENTER),
                    ], tight=True, horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                    bgcolor=colors['surface'],
                    padding=20,
                    border_radius=15,
                    border=ft.Border.all(1, colors['border']),
                    width=250,
                ),
                bgcolor=ft.Colors.with_opacity(0.5, ft.Colors.BLACK),
                alignment=ft.Alignment.CENTER,
                expand=True,
            )
            overlay._es_overlay_carga = True
            self.loading_overlay = overlay
            page.overlay.append(overlay)
            try:
                page.update()
            except Exception:
                pass
        else:
            self.loading_overlay = None
            removed = False
            for ov in _find_loading_overlays():
                try:
                    page.overlay.remove(ov)
                    removed = True
                except Exception:
                    pass
            if removed:
                try:
                    page.update()
                except Exception:
                    pass

    def _build_controls(self):
        colors = get_colors(self.page)
        
        # Connection indicator
        self._connection_indicator = ft.Container(
            content=ft.Icon(ft.Icons.WIFI, color=colors['success'], size=18),
            tooltip="Conectado",
            padding=5,
            on_click=self._on_sync_indicator_click
        )
        
        self.search_field = ft.TextField(
            hint_text="Buscar...",
            prefix_icon=ft.Icons.SEARCH_ROUNDED,
            border_radius=12,
            border_color=colors.get('input_border'),
            focused_border_color=colors.get('accent'),
            height=45,
            expand=1,
            on_change=lambda _: self._on_search_change()
        )
        
        self.validate_button = ft.ElevatedButton(
            "Validar seleccionadas",
            bgcolor=colors['info'],
            color=colors['white'],
            disabled=True,
            on_click=self._show_validar_dialog
        )
        
        self.clear_button = ft.ElevatedButton(
            "Limpiar selección",
            bgcolor=colors['warning'],
            color=colors['white'],
            disabled=True,
            on_click=lambda _: self._clear_selection()
        )
        
        self._btn_refresh = ft.IconButton(
            ft.Icons.REFRESH_ROUNDED,
            on_click=lambda _: self._on_refresh(),
            icon_color=colors['text_secondary'],
        )

        controls = ft.Container(
            content=ft.Column([
                self.search_field,
                ft.Row([self.validate_button, self.clear_button], alignment=ft.MainAxisAlignment.SPACE_BETWEEN)
            ], spacing=10),
            padding=ft.Padding.symmetric(horizontal=20, vertical=10),
        )
        
        self.content = ft.Column([controls, self.entradas_list], spacing=0, expand=True)
        # No llamar a self.update() aquí: se ejecuta durante did_mount (montaje
        # de Flet) y disparaba "dictionary changed size during iteration",
        # dejando _mounted=False y la vista vacía. El framework refleja el
        # cambio al asignar self.content.

    def get_header_actions(self):
        return [self._connection_indicator, self._btn_refresh]

    def _on_sync_indicator_click(self, e=None):
        from usr.database import get_sync_manager
        sync_mgr = get_sync_manager()
        if not sync_mgr or not self.page:
            return
        self._update_connection_indicator()
        if self.page:
            self.page.update()

    def _on_search_change(self):
        if self.page:
            from usr.database.sync_callbacks import schedule_load
            schedule_load(self._load_entradas_pendientes)

    def _on_refresh(self):
        if not self.page:
            return

        online = is_online()
        if online:
            from usr.database import get_sync_manager
            sync_mgr = get_sync_manager()
            if sync_mgr:
                sync_mgr.force_sync_now()
        from usr.database.sync_callbacks import schedule_load
        schedule_load(self._load_entradas_pendientes)

        show_success("Datos refrescados correctamente")

    async def _send_wa_background(self, img_path, msg):
        """Tâche de fond pour l'envoi WhatsApp sans bloquer l'UI"""
        try:
            if img_path:
                await asyncio.to_thread(send_whatsapp_image, img_path, msg)
            else:
                await asyncio.to_thread(send_whatsapp_message, msg)
        except Exception as e:
            logger.error(f"[WA Background] Error: {e}")

    def _show_validar_dialog(self, e):
        theme_colors = get_colors(self.page)
        dialog = ValidacionDialog(self.page, self.selected_entradas, theme_colors)
        async def on_validar_click(btn_event):
            try:
                data = dialog.get_data()
                dialog.dialog.open = False
                self.page.update()

                self._set_loading_overlay(True, "Validando datos...")

                from usr.views.validacion.service import ValidacionService
                result = await asyncio.to_thread(ValidacionService.procesar, data, self.selected_entradas)
                
                show_success(f"✅ Validadas {result.get('movimientos_count', 0)} entradas")

                # Envío WhatsApp siempre: si el bot está apagado, el envío directo
                # falla y el mensaje queda encolado en la bandeja (no se descarta).
                img_path = None
                def get_long_path(short_path):
                    try:
                        import ctypes
                        GetLongPathName = ctypes.windll.kernel32.GetLongPathNameW
                        buf = ctypes.create_unicode_buffer(512)
                        result = GetLongPathName(short_path, buf, 512)
                        return buf.value if result else short_path
                    except Exception:
                        return short_path
                
                if hasattr(dialog.ocr, 'current_image_path') and dialog.ocr.current_image_path:
                    candidate = get_long_path(dialog.ocr.current_image_path)
                    if os.path.exists(candidate):
                        img_path = candidate
                
                productos_str = "Productos variados"
                fecha_entrada = None
                if self.selected_entradas:
                    try:
                        from usr.database.local_replica import LocalReplica
                        db = next(get_db_adaptive())
                        try:
                            movimientos = db.query(Movimiento).filter(Movimiento.id.in_(list(self.selected_entradas))).all()
                            productos_ids = set(m.get('producto_id') if isinstance(m, dict) else m.producto_id for m in movimientos)
                            nombres = []
                            fechas = []
                            for m in movimientos:
                                fm = m.get('fecha_movimiento') if isinstance(m, dict) else m.fecha_movimiento
                                if fm:
                                    fechas.append(fm)
                                pid = m.get('producto_id') if isinstance(m, dict) else m.producto_id
                                prod = LocalReplica.get_producto_by_id(pid)
                                if prod:
                                    nom = prod.get('nombre', 'Producto') if isinstance(prod, dict) else getattr(prod, 'nombre', 'Producto')
                                    cant = m.get('cantidad') if isinstance(m, dict) else getattr(m, 'cantidad', 0)
                                    peso = m.get('peso_total') if isinstance(m, dict) else getattr(m, 'peso_total', 0) or 0
                                    es_pesable = prod.get('es_pesable', False) if isinstance(prod, dict) else getattr(prod, 'es_pesable', False)
                                    if es_pesable and peso and peso > 0:
                                        nombres.append(f"{nom}: {float(peso):.2f} kg")
                                    else:
                                        unidad = prod.get('unidad_medida') or 'uds' if isinstance(prod, dict) else getattr(prod, 'unidad_medida', 'uds') or 'uds'
                                        nombres.append(f"{nom}: {int(float(cant or 0))} {unidad}")
                            productos_str = "\n".join(nombres) if nombres else "Productos variados"
                            if fechas:
                                fecha_entrada = min(fechas)
                        finally:
                            db.close()
                    except Exception:
                        productos_str = "Productos variados"
                
                msg = format_validation_message(
                    productos_str, 0, data.get('factura', ''),
                    data.get('proveedor', ''), data.get('monto', 0),
                    data.get('pagos', []), result.get('usuario', 'Sistema'),
                    fecha_entrada
                )
                
                # Envío asíncrono sin esperar la respuesta (directo o encolado)
                self.page.run_task(self._send_wa_background, img_path, msg)
                
                if result.get('sync'):
                    print("[SYNC] Factura sincronizada")
                
                self._set_loading_overlay(True, "Actualizando lista de pendientes...")
                self.selected_entradas.clear()
                await self._load_entradas_pendientes()
                
                self._set_loading_overlay(False)

            except Exception as ex:
                self._set_loading_overlay(False)
                print(f"[ERROR] on_validar_click: {ex}")
                import traceback; traceback.print_exc()
                try:
                    from usr.notifications import show_error_with_copy
                    show_error_with_copy("Error al validar entradas", ex)
                except:
                    pass
        
        dialog.set_on_validate(on_validar_click)
        dialog.show()

    async def _load_entradas_pendientes(self):
        trace = os.environ.get("TRACE_SWITCH") == "1"
        def tr(msg):
            if trace:
                print(f"[VAL] _load_entradas_pendientes | {msg}")
        if self.is_loading:
            tr(f"SKIP is_loading=True (stale)")
            return
        self.is_loading = True
        colors = get_colors(self.page)
        tr("ENTRADA (is_loading=True)")
        
        self.entradas_list.controls = [ft.ProgressBar()]
        if self.page:
            self.update()
        
        try:
            # Ejecutamos la consulta en un hilo separado para no bloquear la UI
            entradas = await asyncio.to_thread(self._fetch_entradas_data)
            tr(f"BD devolvió {len(entradas)} entradas")
            
            self.entradas_list.controls.clear()
            if not entradas:
                self.entradas_list.controls.append(ft.Container(
                    content=ft.Column([
                        ft.Icon(ft.Icons.FACT_CHECK_OUTLINED, size=50, color=colors['text_hint']),
                        ft.Text("Sin entradas pendientes", color=colors['text_secondary'])
                    ], horizontal_alignment="center"),
                    padding=ft.Padding.only(top=100),
                    alignment="center"
                ))
            else:
                for ent in entradas:
                    self.entradas_list.controls.append(self._create_entrada_card(ent))
            
            self._update_buttons()
            tr(f"pintado: entradas_list.controls={len(self.entradas_list.controls)}, entradas_list.page={'SÍ' if self.entradas_list.page else 'no'}")
            if self.page:
                self.update()
        except Exception as ex:
            logger.error(f"Error cargando entradas: {ex}")
            tr(f"EXCEPCIÓN: {ex}")
            self.entradas_list.controls = [ft.Text(f"Error: {str(ex)}")]
        finally:
            self.is_loading = False
            tr("finally is_loading=False")
            if self.page:
                self.update()

    def _fetch_entradas_data(self):
        db = next(get_db_adaptive())
        try:
            query = db.query(Movimiento).options(joinedload(Movimiento.producto)).filter(
                Movimiento.tipo == "entrada",
                Movimiento.factura_id.is_(None)
            )
            
            search = self.search_field.value.lower().strip() if self.search_field.value else ""
            if search:
                from usr.models import Producto
                query = query.join(Producto).filter(Producto.nombre.ilike(f"%{search}%"))
            
            return query.order_by(Movimiento.fecha_movimiento.desc()).all()
        finally:
            db.close()

    def _create_entrada_card(self, entrada):
        colors = get_colors(self.page)
        is_selected = entrada.id in self.selected_entradas
        
        # Get producto safely
        try:
            producto = entrada.producto
            nombre = getattr(producto, 'nombre', 'Sin nombre') if producto else "Sin nombre"
            unidad = getattr(producto, 'unidad_medida', 'uds') if producto else 'uds'
            es_pesable = getattr(producto, 'es_pesable', False) if producto else False
        except:
            nombre = "Sin nombre"
            unidad = 'uds'
            es_pesable = False
        
        almacen = getattr(entrada, 'almacen', 'principal') or 'principal'
        peso = getattr(entrada, 'peso_total', 0) or 0
        
        almacen_badge = ft.Text(
            f"📦 {almacen.title()}",
            size=10,
            color=colors['text_secondary'],
        )
        
        if es_pesable and peso > 0:
            cantidad_texto = f"{peso:.3f} kg"
        else:
            cantidad_texto = f"{entrada.cantidad} {unidad}"
        
        if peso > 0.001:
            peso_badge = ft.Text(f"⚖️ {peso:.3f} kg", size=10, color=colors['warning'])
        else:
            peso_badge = ft.Text()
        
        check_icon = ft.Icon(
            ft.Icons.CHECK_CIRCLE_ROUNDED if is_selected else ft.Icons.RADIO_BUTTON_UNCHECKED_ROUNDED,
            color=colors['accent'] if is_selected else colors['text_hint'],
            size=22
        )
        
        card = ft.Container(
            content=ft.Row([
                ft.Container(content=check_icon, padding=2),
                ft.Column([
                    ft.Text(
                        nombre,
                        weight=ft.FontWeight.BOLD,
                        size=15,
                        color=colors['text_primary'],
                        max_lines=1,
                        overflow=ft.TextOverflow.ELLIPSIS
                    ),
                    ft.Row([
                        ft.Text(cantidad_texto, size=13, weight="w600", color=colors['success']),
                        peso_badge,
                        ft.Container(expand=True),
                        ft.Text(
                            entrada.fecha_movimiento.strftime("%d/%m %H:%M") if entrada.fecha_movimiento else "Sin fecha",
                            size=11,
                            color=colors['text_secondary']
                        ),
                    ], spacing=8, vertical_alignment="center"),
                    almacen_badge,
                ], expand=True, spacing=2),
                ft.IconButton(
                    icon=ft.Icons.DELETE_OUTLINE_ROUNDED,
                    icon_color=colors['error'],
                    tooltip="Eliminar entrada",
                    on_click=lambda _: self._eliminar_entrada(entrada)
                )
            ], spacing=8),
            padding=15,
            animate=200,
            bgcolor=colors['card_hover'] if is_selected else colors['card'],
            border_radius=12,
            border=ft.Border.all(2, colors['accent']) if is_selected else ft.Border.all(1, colors['border']),
            on_click=lambda _: self._toggle_selection(entrada.id)
        )
        
        self.cards_dict[entrada.id] = card
        return card

    def _toggle_selection(self, entrada_id):
        if entrada_id in self.selected_entradas:
            self.selected_entradas.discard(entrada_id)
        else:
            self.selected_entradas.add(entrada_id)
        
        if entrada_id in self.cards_dict:
            card = self.cards_dict[entrada_id]
            is_sel = entrada_id in self.selected_entradas
            colors = get_colors(self.page)
            card.bgcolor = colors['card_hover'] if is_sel else colors['card']
            card.border = ft.Border.all(2, colors['accent']) if is_sel else ft.Border.all(1, colors['border'])
            if card.page:
                card.update()
        
        self._update_buttons()
        
        # Update check icon
        if entrada_id in self.cards_dict:
            card = self.cards_dict[entrada_id]
            is_sel = entrada_id in self.selected_entradas
            row = card.content
            if row and row.controls:
                check_icon = row.controls[0].content
                if isinstance(check_icon, ft.Icon):
                    check_icon.name = ft.Icons.CHECK_CIRCLE_ROUNDED if is_sel else ft.Icons.RADIO_BUTTON_UNCHECKED_ROUNDED
                    check_icon.color = get_colors(self.page)['accent'] if is_sel else get_colors(self.page)['text_hint']
                if card.page:
                    card.update()

    def _update_buttons(self):
        has_sel = len(self.selected_entradas) > 0
        self.validate_button.disabled = not has_sel
        self.clear_button.disabled = not has_sel
        if has_sel:
            self.validate_button.text = f"Validar {len(self.selected_entradas)} entradas"
        else:
            self.validate_button.text = "Validar seleccionadas"
        
        if self.page and self.validate_button.page:
            self.validate_button.update()
            self.clear_button.update()
            self.page.update()

    def _clear_selection(self, e=None):
        self.selected_entradas.clear()
        # NO actualizar card por card: N updates individuales saturan/corrompen
        # el websocket en Flet web y la lista termina sin pintarse. Se recrea la
        # lista completa con schedule_load (ensure_future sobre el loop activo,
        # como on_view_shown), en lugar de page.run_task que exige
        # session.connection.loop y puede fallar silenciosamente.
        if self.page:
            from usr.database.sync_callbacks import schedule_load
            schedule_load(self._load_entradas_pendientes)

    def _eliminar_entrada(self, entrada):
        db = next(get_db_adaptive())
        try:
            match_data = {
                'producto_id': entrada.producto_id,
                'tipo': entrada.tipo,
                'cantidad': entrada.cantidad,
                'fecha_movimiento': str(entrada.fecha_movimiento) if entrada.fecha_movimiento else None,
                'almacen': entrada.almacen,
            }
            db.delete(entrada)
            db.commit()
            show_success(f"Eliminado: {entrada.cantidad}")
            if self.page:
                from usr.database.sync_callbacks import schedule_load
                schedule_load(self._load_entradas_pendientes)
            # Encolar eliminación para que Supabase también lo borre
            try:
                from usr.database.sync_queue import get_sync_queue
                get_sync_queue().add_pending('movimientos', 'delete', match_data)
            except Exception as e:
                print(f"[VALIDACION] Error encolando delete movimiento: {e}")
        except Exception as ex:
            db.rollback()
            show_error(f"Error: {str(ex)}")
        finally:
            db.close()