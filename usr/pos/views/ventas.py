import flet as ft
from usr.database.local_replica import LocalReplica


class VentasView(ft.Container):
    def __init__(self, usuario: dict = None, sesion_id: int = None, on_logout=None, on_back=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 0
        self.usuario = usuario
        self.sesion_id = sesion_id
        self.on_logout = on_logout
        self.on_back = on_back
        self._build_ui()
        self._load_ventas()

    def _build_ui(self):
        top_bar = self._build_top_bar(titulo="Ventas", on_back=self.on_back)
        self.btn_anular_ultima = ft.ElevatedButton(
            "Anular ultima venta", icon=ft.Icons.UNDO_ROUNDED,
            bgcolor="#EF5350", color=ft.Colors.WHITE,
            disabled=True, on_click=lambda _: self._anular_ultima(),
        )
        header = ft.Container(
            content=ft.Row([
                ft.Column([
                    ft.Text("Historial de ventas", size=24, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    ft.Text("Las ventas registran la salida de mercancia (movimientos tipo 'venta')",
                            size=13, color="#9E9E9E"),
                ], spacing=2),
                ft.Container(expand=True),
                self.btn_anular_ultima,
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            padding=ft.padding.symmetric(horizontal=20, vertical=15),
        )
        self.lv_ventas = ft.ListView(expand=True, spacing=8, auto_scroll=False, padding=20)
        self.content = ft.Column([top_bar, header, self.lv_ventas], expand=True, spacing=0)

    def _load_ventas(self):
        self.lv_ventas.controls.clear()
        ventas = LocalReplica.get_ventas(limit=200)
        mesas = {m['id']: m for m in LocalReplica.get_pos_mesas()}
        habs = {h['id']: h for h in LocalReplica.get_pos_habitaciones()}
        self._ultima_vigente = None
        for v in ventas:
            if v.get('estado') == 'vigente' and self._ultima_vigente is None:
                self._ultima_vigente = v
            self.lv_ventas.controls.append(self._build_venta_card(v, mesas, habs))

        if not ventas:
            self.lv_ventas.controls.append(ft.Container(
                content=ft.Column([
                    ft.Icon(ft.Icons.RECEIPT_LONG_ROUNDED, size=80, color="#9E9E9E"),
                    ft.Container(height=16),
                    ft.Text("No hay ventas registradas", size=16, color="#9E9E9E"),
                    ft.Text("Cobre una comanda para registrar su primera venta", size=13, color="#757575"),
                ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
                alignment=ft.alignment.center, expand=True, padding=40,
            ))
        self.btn_anular_ultima.disabled = self._ultima_vigente is None
        if self.page:
            self.update()

    def _build_venta_card(self, venta: dict, mesas: dict, habs: dict):
        correlativo = venta.get('correlativo')
        numero = f"{correlativo:05d}" if correlativo is not None else f"#{venta.get('comanda_id', '?')}"
        fecha = (venta.get('created_at') or '')[:16].replace('T', ' ')
        total = float(venta.get('total', 0) or 0)
        vigente = venta.get('estado') == 'vigente'

        lugar = "Sin mesa"
        if venta.get('mesa_id'):
            m = mesas.get(venta['mesa_id'])
            if m:
                lugar = f"Mesa {m.get('numero', '?')}"
        elif venta.get('habitacion_id'):
            h = habs.get(venta['habitacion_id'])
            if h:
                lugar = f"Habitacion {h.get('numero', '?')}"

        corr_text = ""
        if venta.get('venta_anula_id'):
            corr_venta = LocalReplica.get_venta_by_id(venta['venta_anula_id'])
            if corr_venta and corr_venta.get('correlativo') is not None:
                corr_text = f"Corrige comanda {corr_venta['correlativo']:05d}"

        tasa_bs = venta.get('tasa_bs')
        if tasa_bs:
            from usr.pos.tasa_cambio import formatear_bs
            total_bs_text = ft.Text(
                f"Bs {formatear_bs(total * float(tasa_bs))}",
                size=12, weight=ft.FontWeight.BOLD,
                color="#26A69A" if vigente else "#9E9E9E",
            )
        else:
            total_bs_text = ft.Container()

        estado_badge = ft.Container(
            content=ft.Text("VIGENTE" if vigente else "ANULADA",
                            size=9, weight=ft.FontWeight.BOLD,
                            color="#4CAF50" if vigente else "#EF5350"),
            bgcolor="#1B5E20" if vigente else "#B71C1C",
            border_radius=10, padding=ft.padding.symmetric(horizontal=8, vertical=2),
        )

        actions = []
        if vigente:
            actions.append(ft.IconButton(
                icon=ft.Icons.UNDO_ROUNDED, icon_color="#EF5350",
                tooltip="Anular venta", on_click=lambda _, v=venta: self._anular_venta(v),
            ))

        return ft.Container(
            content=ft.Row([
                ft.Container(
                    content=ft.Text(numero, size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    width=52, height=52, bgcolor="#1E88E5", border_radius=26,
                    alignment=ft.alignment.center,
                ),
                ft.Container(width=12),
                ft.Column([
                    ft.Row([ft.Text(numero, size=14, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                            estado_badge,
                            ft.Text("CORRECCION" if corr_text else "", size=9, weight=ft.FontWeight.BOLD, color="#FFB74D")],
                           spacing=8, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                    ft.Row([
                        ft.Text(fecha, size=11, color="#9E9E9E"),
                        ft.Text(" · ", size=11, color="#555555"),
                        ft.Text(lugar, size=11, color="#9E9E9E"),
                    ], spacing=2),
                    ft.Text(corr_text, size=10, color="#FFB74D") if corr_text else ft.Container(),
                ], spacing=2, expand=True),
                ft.Column([
                    ft.Text(f"$ {total:.2f}", size=16, weight=ft.FontWeight.BOLD, color="#4CAF50" if vigente else "#9E9E9E"),
                    total_bs_text,
                ], spacing=0, horizontal_alignment=ft.CrossAxisAlignment.END),
                ft.Container(width=8),
                *actions,
            ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
            bgcolor="#1E1E1E",
            border=ft.border.all(1, "#3D3D3D"),
            border_radius=12,
            padding=ft.padding.symmetric(horizontal=14, vertical=10),
        )

    def _anular_ultima(self):
        if self._ultima_vigente:
            self._anular_venta(self._ultima_vigente)

    def _anular_venta(self, venta: dict):
        motivo_field = ft.TextField(
            label="Motivo de la anulacion",
            value="Correccion de la venta",
            width=320, autofocus=True,
        )
        content = ft.Column([
            ft.Text(f"Se devolvera la venta #{venta.get('correlativo', venta.get('id'))} "
                    f"($ {float(venta.get('total', 0) or 0):.2f})",
                    color=ft.Colors.WHITE, size=14),
            ft.Text("Se restaura el stock, la comanda vuelve a la mesa y podra corregir y volver a cobrar.",
                    color="#9E9E9E", size=12),
            motivo_field,
        ], spacing=12, tight=True)
        self._show_dialog(
            title="Anular venta",
            content=content,
            on_save=lambda e: self._confirmar_anulacion(venta, motivo_field.value or 'Correccion'),
            save_text="Anular venta",
            save_bgcolor="#EF5350",
        )

    def _confirmar_anulacion(self, venta: dict, motivo: str):
        self._close_dialog()
        registrado_por = (self.usuario or {}).get('nombre', 'POS')
        try:
            LocalReplica.revertir_movimientos_venta(venta['id'], registrado_por)
            LocalReplica.anular_venta(venta['id'], anulada_por=registrado_por, motivo=motivo)
            LocalReplica.reabrir_comanda(venta['comanda_id'])
        except Exception as ex:
            import traceback as tb
            tb.print_exc()
            self._show_snack(f"Error al anular: {ex}", color="#EF5350")
            return
        self._ir_a_comanda(venta)

    def _ir_a_comanda(self, venta: dict):
        if not self.page:
            self._load_ventas()
            return
        mesa = None
        habitacion = None
        if venta.get('mesa_id'):
            mesa = LocalReplica.get_pos_mesa_by_id(venta['mesa_id'])
        elif venta.get('habitacion_id'):
            habitacion = LocalReplica.get_pos_habitacion_by_id(venta['habitacion_id'])
        if mesa or habitacion:
            from usr.pos.views.comanda_view import ComandaPedidoView
            v = ComandaPedidoView(
                usuario=self.usuario, sesion_id=self.sesion_id,
                mesa=mesa, habitacion=habitacion, on_logout=self.on_logout,
                on_back=self.on_back,
            )
            self.page.clean()
            self.page.add(v)
            self.page.update()
            self._show_snack("Venta anulada. Corrija la comanda y cobre de nuevo.", color="#4CAF50")
        else:
            self._load_ventas()

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
            print(f"[VENTAS] Error mostrando snack: {e}")

    def _show_dialog(self, title, content, on_save, save_text="Guardar", save_bgcolor="#4CAF50"):
        self._close_dialog()
        self.active_dialog = ft.AlertDialog(
            title=ft.Text(title),
            content=content,
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: self._close_dialog()),
                ft.ElevatedButton(save_text, on_click=on_save,
                                  bgcolor=save_bgcolor, color=ft.Colors.WHITE),
            ], actions_alignment=ft.MainAxisAlignment.END)
        if self.page:
            self.page.overlay.append(self.active_dialog)
            self.active_dialog.open = True
            self.page.update()

    def _close_dialog(self):
        if hasattr(self, 'active_dialog') and self.active_dialog:
            self.active_dialog.open = False
            self.active_dialog = None
            self._flush()

    def _flush(self):
        if not self.page:
            return
        try:
            for c in self.page.overlay[:]:
                if isinstance(c, ft.AlertDialog):
                    c.open = False
            self.page.update()
        except AssertionError:
            pass

    def _build_top_bar(self, titulo: str, on_back=None):
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
        left = []
        if on_back:
            left.append(ft.IconButton(icon=ft.Icons.ARROW_BACK_ROUNDED, icon_color=ft.Colors.WHITE,
                                      tooltip="Volver", on_click=lambda _: on_back()))
        left.append(ft.Text(titulo, size=18, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE))
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
