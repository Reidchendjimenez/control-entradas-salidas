import flet as ft
from usr.database.local_replica import LocalReplica
from usr.database.sync_queue import get_sync_queue


class ConfigPOSView(ft.Container):
    def __init__(self, usuario: dict = None, sesion_id: int = None, on_logout=None, on_back=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding=20
        self.usuario=usuario
        self.sesion_id=sesion_id
        self.on_logout=on_logout
        self.on_back=on_back
        self._build_ui()
        self._load_usuarios()
        self._load_mesas()
        self._load_habitaciones()
        self._load_platos()

    def _build_ui(self):
        btn_back=ft.IconButton(
            icon=ft.Icons.ARROW_BACK_ROUNDED,
            icon_color=ft.Colors.WHITE,
            tooltip="Volver",
            on_click=lambda _: self._go_back(),
        )
        titulo=ft.Text("Configuracion del POS", size=20, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE, expand=True)
        btn_refresh=ft.IconButton(
            icon=ft.Icons.REFRESH_ROUNDED,
            icon_color=ft.Colors.WHITE,
            tooltip="Sincronizar con nube",
            on_click=lambda _: self._on_refresh(),
        )
        self.lv_usuarios=ft.ListView(expand=True, spacing=8, auto_scroll=False)
        self.lv_mesas=ft.ListView(expand=True, spacing=8, auto_scroll=False)
        self.lv_habitaciones=ft.ListView(expand=True, spacing=8, auto_scroll=False)
        self.lv_platos=ft.ListView(expand=True, spacing=8, auto_scroll=False)
        self.tabs=ft.Tabs(
            selected_index=0,
            animation_duration=300,
            tabs=[
                ft.Tab(
                    text="Usuarios",
                    icon=ft.Icons.PEOPLE_ROUNDED,
                    content=ft.Column([
                        ft.Row([
                            ft.Container(expand=True),
                            ft.ElevatedButton(
                                "Nuevo cajero", icon=ft.Icons.PERSON_ADD_ROUNDED,
                                bgcolor="#4CAF50", color=ft.Colors.WHITE,
                                on_click=lambda _: self._show_agregar_dialog(),
                            ),
                        ]),
                        ft.Container(height=10),
                        ft.Container(content=self.lv_usuarios, border=ft.border.all(1,"#3D3D3D"),
                                      border_radius=10, padding=10, expand=True),
                    ], expand=True),
                ),
                ft.Tab(
                    text="Mesas",
                    icon=ft.Icons.TABLE_RESTAURANT_ROUNDED,
                    content=ft.Column([
                        ft.Row([
                            ft.Container(expand=True),
                            ft.ElevatedButton(
                                "Nueva mesa", icon=ft.Icons.ADD_ROUNDED,
                                bgcolor="#4CAF50", color=ft.Colors.WHITE,
                                on_click=lambda _: self._show_agregar_mesa_dialog(),
                            ),
                        ]),
                        ft.Container(height=10),
                        ft.Container(content=self.lv_mesas, border=ft.border.all(1,"#3D3D3D"),
                                      border_radius=10, padding=10, expand=True),
                    ], expand=True),
                ),
                ft.Tab(
                    text="Habitaciones",
                    icon=ft.Icons.HOTEL_ROUNDED,
                    content=ft.Column([
                        ft.Row([
                            ft.Container(expand=True),
                            ft.ElevatedButton(
                                "Nueva habitacion", icon=ft.Icons.ADD_ROUNDED,
                                bgcolor="#4CAF50", color=ft.Colors.WHITE,
                                on_click=lambda _: self._show_agregar_habitacion_dialog(),
                            ),
                        ]),
                        ft.Container(height=10),
                        ft.Container(content=self.lv_habitaciones, border=ft.border.all(1,"#3D3D3D"),
                                      border_radius=10, padding=10, expand=True),
                    ], expand=True),
                ),
                ft.Tab(
                    text="Platos",
                    icon=ft.Icons.RAMEN_DINING_ROUNDED,
                    content=ft.Column([
                        ft.Row([
                            ft.Container(expand=True),
                        ]),
                        ft.Container(height=10),
                        ft.Container(content=self.lv_platos, border=ft.border.all(1,"#3D3D3F"),
                                      border_radius=10, padding=10, expand=True),
                    ], expand=True),
                ),
                ft.Tab(
                    text="Impresora",
                    icon=ft.Icons.PRINT_ROUNDED,
                    content=self._build_printer_tab(),
                ),
            ],
            expand=True,
        )
        self.content=ft.Column([
            ft.Row([btn_back, titulo, btn_refresh], alignment=ft.MainAxisAlignment.START),
            ft.Container(height=10),
            self.tabs,
        ], expand=True)

    def _build_printer_tab(self):
        """Construye el contenido de la pestaña de impresora."""
        self._printer_status = ft.Text("Buscando impresoras...", size=14, color="#9E9E9E")
        self._printer_list = ft.ListView(expand=True, spacing=6)
        self._btn_test = ft.ElevatedButton(
            "Probar impresion", icon=ft.Icons.PRINT_ROUNDED,
            bgcolor="#1E88E5", color=ft.Colors.WHITE,
            on_click=lambda _: self._on_test_printer(),
        )
        self._btn_refresh_printers = ft.IconButton(
            icon=ft.Icons.REFRESH_ROUNDED,
            icon_color=ft.Colors.WHITE,
            tooltip="Buscar impresoras",
            on_click=lambda _: self._load_printer_list(),
        )

        content = ft.Column([
            ft.Row([
                ft.Text("Impresora de comandas", size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                self._btn_refresh_printers,
            ], alignment=ft.MainAxisAlignment.SPACE_BETWEEN),
            ft.Container(height=10),
            self._printer_status,
            ft.Container(height=10),
            ft.Container(content=self._printer_list, border=ft.border.all(1,"#3D3D3D"),
                         border_radius=10, padding=10, expand=True),
            ft.Container(height=10),
            self._btn_test,
        ], expand=True)

        self._load_printer_list()
        return content

    def _load_printer_list(self):
        """Carga la lista de impresoras disponibles."""
        self._printer_list.controls.clear()
        try:
            from usr.pos.printer import listar_impresoras, _get_configured_device
            printers = listar_impresoras()
            configured = _get_configured_device()

            if not printers:
                self._printer_status.value = "No se encontraron impresoras"
                self._printer_status.color = "#9E9E9E"
                self._btn_test.disabled = True
            else:
                self._printer_status.value = f"Se encontraron {len(printers)} impresora(s)"
                self._printer_status.color = "#4CAF50"
                self._btn_test.disabled = False

            for p in printers:
                is_selected = configured == p.get('path')
                self._printer_list.controls.append(
                    ft.Container(
                        content=ft.Row([
                            ft.Icon(
                                ft.Icons.PRINT_ROUNDED if p.get('type') == 'usb' else ft.Icons.USB_ROUNDED,
                                color="#4CAF50" if is_selected else "#9E9E9E",
                                size=20,
                            ),
                            ft.Column([
                                ft.Text(p.get('name', 'Desconocida'), size=14, color=ft.Colors.WHITE, weight=ft.FontWeight.BOLD),
                                ft.Text(f"Tipo: {p.get('type','?')} | Path: {p.get('path','?')}", size=11, color="#9E9E9E"),
                            ], expand=True),
                            ft.Switch(
                                value=is_selected,
                                on_change=lambda e, pp=p: self._on_select_printer(pp, e.control.value),
                            ),
                        ], vertical_alignment=ft.CrossAxisAlignment.CENTER),
                        padding=10,
                        bgcolor="#2A2A2A" if is_selected else "#1E1E1E",
                        border=ft.border.all(1, "#4CAF50" if is_selected else "#3D3D3D"),
                        border_radius=8,
                    )
                )
        except Exception as e:
            self._printer_status.value = f"Error: {e}"
            self._printer_status.color = "#EF5350"
        if self.page:
            self.update()

    def _on_select_printer(self, printer: dict, selected: bool):
        """Selecciona o deselecciona una impresora."""
        if not selected:
            return
        try:
            from usr.pos.printer import configurar_impresora
            configurar_impresora(printer.get('path'))
            self._printer_status.value = f"Impresora configurada: {printer.get('name')}"
            self._printer_status.color = "#4CAF50"
        except Exception as e:
            self._printer_status.value = f"Error: {e}"
            self._printer_status.color = "#EF5350"
        self._load_printer_list()

    def _on_test_printer(self):
        """Prueba la impresion en la impresora configurada."""
        try:
            from usr.pos.printer import test_imprimir
            result = test_imprimir()
            if result:
                snack = ft.SnackBar(
                    content=ft.Text("Impresion de prueba enviada"),
                    bgcolor=ft.Colors.GREEN_600, duration=2000,
                )
            else:
                snack = ft.SnackBar(
                    content=ft.Text("No se encontro impresora"),
                    bgcolor=ft.Colors.RED_600, duration=2000,
                )
            if self.page:
                self.page.overlay.append(snack)
                snack.open = True
                self.page.update()
        except Exception as e:
            if self.page:
                snack = ft.SnackBar(
                    content=ft.Text(f"Error: {e}"),
                    bgcolor=ft.Colors.RED_600, duration=2000,
                )
                self.page.overlay.append(snack)
                snack.open = True
                self.page.update()

    def _on_refresh(self):
        """Fuerza sync con Supabase y recarga todos los datos POS."""
        try:
            from usr.database.base import is_online as base_is_online
            from usr.database import get_sync_manager
            online = base_is_online()
            if online:
                sync_mgr = get_sync_manager()
                if sync_mgr:
                    sync_mgr.force_sync_now()
        except Exception as e:
            print(f"[POS CONFIG] Error al forzar sync: {e}")
        self._load_usuarios()
        self._load_mesas()
        self._load_habitaciones()
        self._load_platos()
        if self.page:
            snack = ft.SnackBar(
                content=ft.Text("Sincronizacion completada"),
                bgcolor=ft.Colors.BLUE_600, duration=1500,
            )
            self.page.overlay.append(snack)
            snack.open = True
            self.page.update()

    # ==================== USUARIOS ====================

    def _load_usuarios(self):
        self.lv_usuarios.controls.clear()
        usuarios=LocalReplica.get_pos_usuarios()
        if not usuarios:
            self.lv_usuarios.controls.append(self._empty_placeholder("No hay cajeros registrados"))
        else:
            for u in usuarios:
                self.lv_usuarios.controls.append(self._build_usuario_card(u))
        if self.page:
            self.update()

    def _build_usuario_card(self, usuario: dict):
        has_pin=bool(usuario.get('pin_hash'))
        es_admin=bool(usuario.get('es_admin'))
        estado=[]
        if es_admin:
            estado.append("Admin")
        estado.append("Con PIN" if has_pin else "Sin PIN")
        return ft.Container(
            content=ft.Row([
                ft.Container(
                    content=ft.Text(usuario['nombre'][:2].upper(), size=18,
                                    weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    width=50, height=50,
                    bgcolor="#FF9800" if es_admin else "#7C4DFF",
                    border_radius=25, alignment=ft.alignment.center,
                ),
                ft.Column([
                    ft.Text(usuario['nombre'], size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    ft.Text(" - ".join(estado), size=12, color="#9E9E9E"),
                ], spacing=2, expand=True),
                ft.Icon(
                    ft.Icons.ADMIN_PANEL_SETTINGS_ROUNDED if es_admin else (
                        ft.Icons.LOCK_ROUNDED if has_pin else ft.Icons.LOCK_OPEN_ROUNDED
                    ),
                    size=20, color="#FF9800" if es_admin else "#9E9E9E",
                ),
            ], spacing=15),
            bgcolor="#1E1E1E", border=ft.border.all(1,"#3D3D3D"),
            border_radius=10, padding=15, ink=True,
        )

    def _show_agregar_dialog(self):
        self.nombre_input=ft.TextField(label="Nombre del cajero", width=300, autofocus=True)
        self.pin_check=ft.Checkbox(label="Proteger con PIN de 4 digitos", value=False)
        self.pin_input_new=ft.TextField(
            label="PIN (4 digitos)", password=True, max_length=4,
            keyboard_type=ft.KeyboardType.NUMBER, width=300, disabled=True,
        )
        def _on_pin_check_change(e):
            self.pin_input_new.disabled=not e.control.value
            self.pin_input_new.error_text=None
            if self.page:
                self.page.update()
        self.pin_check.on_change=_on_pin_check_change
        self.admin_check=ft.Checkbox(label="Es administrador (acceso a configuracion)", value=False)
        self._show_dialog(
            title="Nuevo Cajero",
            content=ft.Column([
                self.nombre_input, self.pin_check, self.pin_input_new,
                ft.Container(height=5), ft.Divider(height=1, color="#3D3D3D"), self.admin_check,
            ], tight=True),
            on_save=self._do_agregar,
        )

    def _do_agregar(self):
        import traceback as tb
        nombre=(self.nombre_input.value or "").strip()
        if not nombre:
            self._show_error(self.nombre_input, "Ingrese un nombre")
            return
        pin=self.pin_input_new.value if self.pin_check.value else None
        if self.pin_check.value:
            if not pin or len(pin)!=4 or not pin.isdigit():
                self._show_error(self.pin_input_new, "PIN debe tener 4 digitos")
                return
        es_admin=self.admin_check.value
        try:
            uid = LocalReplica.crear_pos_usuario(nombre, pin, es_admin=es_admin)
            get_sync_queue().add_pending('pos_usuarios', 'insert', {
                'id': uid, 'nombre': nombre, 'pin_hash': None,
                'es_admin': 1 if es_admin else 0, 'activo': 1,
            })
            self._close_dialog()
            self._load_usuarios()
        except Exception as ex:
            traceback_text=tb.format_exc()
            print(f"[POS CONFIG] Error al crear cajero:\n{traceback_text}")
            self._show_error(self.nombre_input, f"Error: {ex}")

    # ==================== MESAS ====================

    def _load_mesas(self):
        self.lv_mesas.controls.clear()
        mesas=LocalReplica.get_pos_mesas()
        if not mesas:
            self.lv_mesas.controls.append(self._empty_placeholder("No hay mesas registradas"))
        else:
            for m in mesas:
                self.lv_mesas.controls.append(self._build_mesa_card(m))
        if self.page:
            self.update()

    def _build_mesa_card(self, mesa: dict):
        return ft.Container(
            content=ft.Row([
                ft.Container(
                    content=ft.Text(mesa.get('numero','?'), size=18, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    width=50, height=50, bgcolor="#5C6BC0", border_radius=25, alignment=ft.alignment.center,
                ),
                ft.Column([
                    ft.Text(f"Mesa {mesa.get('numero','')}", size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    ft.Text(
                        " - ".join(filter(None, [mesa.get('nombre',''), mesa.get('zona','')])) or "Sin datos",
                        size=12, color="#9E9E9E",
                    ),
                ], spacing=2, expand=True),
                ft.Row([
                    ft.IconButton(ft.Icons.EDIT, icon_size=18, icon_color="#BB86FC",
                                  tooltip="Editar",
                                  on_click=lambda _, m=mesa: self._show_editar_mesa_dialog(m)),
                    ft.IconButton(ft.Icons.DELETE, icon_size=18, icon_color="#EF5350",
                                  tooltip="Eliminar",
                                  on_click=lambda _, m=mesa: self._delete_mesa(m)),
                ], spacing=0),
            ], spacing=15),
            bgcolor="#1E1E1E", border=ft.border.all(1,"#3D3D3D"),
            border_radius=10, padding=15,
        )

    def _show_agregar_mesa_dialog(self):
        self.mesa_numero=ft.TextField(label="Numero de mesa", width=300, autofocus=True)
        self.mesa_nombre=ft.TextField(label="Nombre (opcional)", width=300)
        self.mesa_zona=ft.TextField(label="Zona (opcional)", width=300)
        self._show_dialog(
            title="Nueva Mesa",
            content=ft.Column([self.mesa_numero, self.mesa_nombre, self.mesa_zona], tight=True),
            on_save=self._do_agregar_mesa,
        )

    def _do_agregar_mesa(self):
        import traceback as tb
        numero=(self.mesa_numero.value or "").strip()
        if not numero:
            self._show_error(self.mesa_numero, "Ingrese el numero de mesa")
            return
        try:
            mid = LocalReplica.crear_pos_mesa(numero, self.mesa_nombre.value, self.mesa_zona.value)
            get_sync_queue().add_pending('pos_mesas', 'insert', {
                'id': mid, 'numero': numero,
                'nombre': self.mesa_nombre.value, 'zona': self.mesa_zona.value, 'activo': 1,
            })
            self._close_dialog()
            self._load_mesas()
        except Exception as ex:
            traceback_text=tb.format_exc()
            print(f"[POS CONFIG] Error al crear mesa:\n{traceback_text}")
            self._show_error(self.mesa_numero, f"Error: {ex}")

    def _show_editar_mesa_dialog(self, mesa: dict):
        self.mesa_numero=ft.TextField(label="Numero de mesa", width=300, autofocus=True,
                                      value=mesa.get('numero',''))
        self.mesa_nombre=ft.TextField(label="Nombre (opcional)", width=300,
                                      value=mesa.get('nombre',''))
        self.mesa_zona=ft.TextField(label="Zona (opcional)", width=300,
                                    value=mesa.get('zona',''))
        self._editing_mesa_id = mesa['id']
        self._show_dialog(
            title="Editar Mesa",
            content=ft.Column([self.mesa_numero, self.mesa_nombre, self.mesa_zona], tight=True),
            on_save=self._do_editar_mesa,
        )

    def _do_editar_mesa(self):
        import traceback as tb
        numero=(self.mesa_numero.value or "").strip()
        if not numero:
            self._show_error(self.mesa_numero, "Ingrese el numero de mesa")
            return
        mid = getattr(self, '_editing_mesa_id', None)
        if not mid:
            return
        try:
            LocalReplica.update_pos_mesa(mid, numero=numero,
                                          nombre=self.mesa_nombre.value,
                                          zona=self.mesa_zona.value)
            get_sync_queue().add_pending('pos_mesas', 'update', {
                'id': mid, 'numero': numero,
                'nombre': self.mesa_nombre.value, 'zona': self.mesa_zona.value, 'activo': 1,
            })
            self._close_dialog()
            self._load_mesas()
        except Exception as ex:
            traceback_text=tb.format_exc()
            print(f"[POS CONFIG] Error al editar mesa:\n{traceback_text}")
            self._show_error(self.mesa_numero, f"Error: {ex}")

    def _delete_mesa(self, mesa: dict):
        def confirm():
            try:
                LocalReplica.delete_pos_mesa(mesa['id'])
                get_sync_queue().add_pending('pos_mesas', 'delete', {'id': mesa['id']})
                self._close_dialog()
                self._load_mesas()
            except Exception as ex:
                print(f"[POS CONFIG] Error al eliminar mesa: {ex}")
                self._close_dialog()
        self._show_dialog(
            title="Eliminar mesa",
            content=ft.Text(f"¿Eliminar mesa '{mesa.get('numero')}'?", color=ft.Colors.WHITE),
            on_save=confirm,
            save_text="Eliminar",
        )

    # ==================== HABITACIONES ====================

    def _load_habitaciones(self):
        self.lv_habitaciones.controls.clear()
        habs=LocalReplica.get_pos_habitaciones()
        if not habs:
            self.lv_habitaciones.controls.append(self._empty_placeholder("No hay habitaciones registradas"))
        else:
            for h in habs:
                self.lv_habitaciones.controls.append(self._build_habitacion_card(h))
        if self.page:
            self.update()

    def _build_habitacion_card(self, hab: dict):
        return ft.Container(
            content=ft.Row([
                ft.Container(
                    content=ft.Text(hab.get('numero','?'), size=18, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    width=50, height=50, bgcolor="#26A69A", border_radius=25, alignment=ft.alignment.center,
                ),
                ft.Column([
                    ft.Text(f"Habitacion {hab.get('numero','')}", size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    ft.Text(
                        " - ".join(filter(None, [hab.get('piso',''), hab.get('tipo','')])) or "Sin datos",
                        size=12, color="#9E9E9E",
                    ),
                ], spacing=2, expand=True),
                ft.Row([
                    ft.IconButton(ft.Icons.EDIT, icon_size=18, icon_color="#BB86FC",
                                  tooltip="Editar",
                                  on_click=lambda _, h=hab: self._show_editar_habitacion_dialog(h)),
                    ft.IconButton(ft.Icons.DELETE, icon_size=18, icon_color="#EF5350",
                                  tooltip="Eliminar",
                                  on_click=lambda _, h=hab: self._delete_habitacion(h)),
                ], spacing=0),
            ], spacing=15),
            bgcolor="#1E1E1E", border=ft.border.all(1,"#3D3D3D"),
            border_radius=10, padding=15,
        )

    def _show_agregar_habitacion_dialog(self):
        self.hab_numero=ft.TextField(label="Numero de habitacion", width=300, autofocus=True)
        self.hab_piso=ft.TextField(label="Piso (opcional)", width=300)
        self.hab_tipo=ft.TextField(label="Tipo (ej: Suite, Estandar)", width=300)
        self._show_dialog(
            title="Nueva Habitacion",
            content=ft.Column([self.hab_numero, self.hab_piso, self.hab_tipo], tight=True),
            on_save=self._do_agregar_habitacion,
        )

    def _do_agregar_habitacion(self):
        import traceback as tb
        numero=(self.hab_numero.value or "").strip()
        if not numero:
            self._show_error(self.hab_numero, "Ingrese el numero de habitacion")
            return
        try:
            hid = LocalReplica.crear_pos_habitacion(numero, self.hab_piso.value, self.hab_tipo.value)
            get_sync_queue().add_pending('pos_habitaciones', 'insert', {
                'id': hid, 'numero': numero,
                'piso': self.hab_piso.value, 'tipo': self.hab_tipo.value, 'activo': 1,
            })
            self._close_dialog()
            self._load_habitaciones()
        except Exception as ex:
            traceback_text=tb.format_exc()
            print(f"[POS CONFIG] Error al crear habitacion:\n{traceback_text}")
            self._show_error(self.hab_numero, f"Error: {ex}")

    def _show_editar_habitacion_dialog(self, hab: dict):
        self.hab_numero=ft.TextField(label="Numero de habitacion", width=300, autofocus=True,
                                     value=hab.get('numero',''))
        self.hab_piso=ft.TextField(label="Piso (opcional)", width=300,
                                   value=hab.get('piso',''))
        self.hab_tipo=ft.TextField(label="Tipo (ej: Suite, Estandar)", width=300,
                                   value=hab.get('tipo',''))
        self._editing_hab_id = hab['id']
        self._show_dialog(
            title="Editar Habitacion",
            content=ft.Column([self.hab_numero, self.hab_piso, self.hab_tipo], tight=True),
            on_save=self._do_editar_habitacion,
        )

    def _do_editar_habitacion(self):
        import traceback as tb
        numero=(self.hab_numero.value or "").strip()
        if not numero:
            self._show_error(self.hab_numero, "Ingrese el numero de habitacion")
            return
        hid = getattr(self, '_editing_hab_id', None)
        if not hid:
            return
        try:
            LocalReplica.update_pos_habitacion(hid, numero=numero,
                                                piso=self.hab_piso.value,
                                                tipo=self.hab_tipo.value)
            get_sync_queue().add_pending('pos_habitaciones', 'update', {
                'id': hid, 'numero': numero,
                'piso': self.hab_piso.value, 'tipo': self.hab_tipo.value, 'activo': 1,
            })
            self._close_dialog()
            self._load_habitaciones()
        except Exception as ex:
            traceback_text=tb.format_exc()
            print(f"[POS CONFIG] Error al editar habitacion:\n{traceback_text}")
            self._show_error(self.hab_numero, f"Error: {ex}")

    def _delete_habitacion(self, hab: dict):
        def confirm():
            try:
                LocalReplica.delete_pos_habitacion(hab['id'])
                get_sync_queue().add_pending('pos_habitaciones', 'delete', {'id': hab['id']})
                self._close_dialog()
                self._load_habitaciones()
            except Exception as ex:
                print(f"[POS CONFIG] Error al eliminar habitacion: {ex}")
                self._close_dialog()
        self._show_dialog(
            title="Eliminar habitacion",
            content=ft.Text(f"¿Eliminar habitacion '{hab.get('numero')}'?", color=ft.Colors.WHITE),
            on_save=confirm,
            save_text="Eliminar",
        )

    # ==================== PLATOS ====================

    def _load_platos(self):
        self.lv_platos.controls.clear()
        all_platos=LocalReplica.get_platos()
        mostrar_contornos=getattr(self, '_mostrar_contornos', False)
        if mostrar_contornos:
            platos=[p for p in all_platos if p.get('es_contorno')]
        else:
            platos=[p for p in all_platos if not p.get('es_contorno')]
        if not platos:
            self.lv_platos.controls.append(self._empty_placeholder(
                "No hay contornos" if mostrar_contornos else "No hay platos registrados"
            ))
        else:
            for p in platos:
                self.lv_platos.controls.append(self._build_plato_card(p))

        header=ft.Row([
            ft.Container(expand=True),
            ft.ElevatedButton(
                "Ver contornos" if not mostrar_contornos else "Ver platos",
                icon=ft.Icons.DATASET_LINKED_ROUNDED,
                bgcolor="#FF6F00" if mostrar_contornos else "#3D3D3D",
                color=ft.Colors.WHITE,
                on_click=lambda _: (setattr(self, '_mostrar_contornos', not getattr(self, '_mostrar_contornos', False)),
                                    self._load_platos()),
            ),
            ft.OutlinedButton(
                "Categorias", icon=ft.Icons.CATEGORY_ROUNDED,
                on_click=lambda _: self._show_plato_categorias_dialog(),
            ),
            ft.ElevatedButton(
                "Nuevo plato", icon=ft.Icons.ADD_ROUNDED,
                bgcolor="#4CAF50", color=ft.Colors.WHITE,
                on_click=lambda _: self._show_plato_dialog(),
            ),
        ], alignment=ft.MainAxisAlignment.START)
        self.lv_platos.controls.insert(0, ft.Container(content=header, padding=ft.padding.only(bottom=10)))
        if self.page:
            self.update()

    def _build_plato_card(self, plato: dict):
        cat=plato.get('categoria_nombre') or "Sin categoria"
        precio=float(plato.get('precio_venta', 0) or 0)
        es_contorno=bool(plato.get('es_contorno'))
        lleva=bool(plato.get('lleva_contornos'))
        tags=[]
        if es_contorno:
            tags.append(ft.Container(
                content=ft.Text("CONTORNO", size=9, weight=ft.FontWeight.BOLD, color="#FF6F00"),
                bgcolor="#FF6F0022", padding=ft.padding.symmetric(horizontal=6, vertical=2),
                border_radius=4,
            ))
        if lleva:
            tags.append(ft.Container(
                content=ft.Text("+", size=9, weight=ft.FontWeight.BOLD, color="#4CAF50"),
                bgcolor="#4CAF5022", padding=ft.padding.symmetric(horizontal=5, vertical=2),
                border_radius=4, tooltip="Lleva contornos",
            ))
        return ft.Container(
            content=ft.Row([
                ft.Container(
                    content=ft.Text(plato['nombre'][:2].upper(), size=18,
                                    weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                    width=50, height=50, bgcolor=plato.get('categoria_color','#FF6F00'),
                    border_radius=25, alignment=ft.alignment.center,
                ),
                ft.Column([
                    ft.Row([
                        ft.Text(plato['nombre'], size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                        *tags,
                    ], spacing=6, vertical_alignment=ft.CrossAxisAlignment.CENTER),
                    ft.Text(f"{cat}  |  $ {precio:.2f}", size=12, color="#9E9E9E"),
                ], spacing=2, expand=True),
                ft.Row([
                    ft.IconButton(ft.Icons.EDIT, icon_size=18, icon_color="#BB86FC",
                                  tooltip="Editar",
                                  on_click=lambda _, p=plato: self._show_plato_dialog(p)),
                    ft.IconButton(ft.Icons.DELETE, icon_size=18, icon_color="#EF5350",
                                  tooltip="Eliminar",
                                  on_click=lambda _, p=plato: self._delete_plato(p)),
                ], spacing=0),
            ], spacing=15),
            bgcolor="#1E1E1E", border=ft.border.all(1,"#3D3D3D"),
            border_radius=10, padding=15,
        )

    def _delete_plato(self, plato: dict):
        def confirm():
            LocalReplica.delete_plato(plato['id'])
            get_sync_queue().add_pending('platos', 'delete', {'id': plato['id']})
            self._close_dialog()
            self._load_platos()
        self._show_dialog(
            title="Eliminar plato",
            content=ft.Text(f"¿Eliminar '{plato['nombre']}'?", color=ft.Colors.WHITE),
            on_save=confirm,
            save_text="Eliminar",
        )

    # ==================== CATEGORIAS DE PLATOS ====================

    def _show_plato_categorias_dialog(self):
        cats=LocalReplica.get_platos_categorias(solo_activas=False)
        cat_list=ft.ListView(expand=True, spacing=6)
        for c in cats:
            cat_list.controls.append(self._build_pcat_card(c))
        if not cats:
            cat_list.controls.append(ft.Container(
                content=ft.Text("Sin categorias", color="#9E9E9E", italic=True),
                padding=10, alignment=ft.alignment.center,
            ))

        nombre_new=ft.TextField(label="Nueva categoria", width=250, autofocus=True)
        color_picker=ft.Dropdown(
            label="Color",
            options=[ft.dropdown.Option(c[0], c[1]) for c in [
                ("#FF6F00", "Naranja"), ("#E53935", "Rojo"), ("#43A047", "Verde"),
                ("#1E88E5", "Azul"), ("#8E24AA", "Morado"), ("#00ACC1", "Cyan"),
            ]],
            value="#FF6F00", width=150,
        )

        def add_cat():
            nombre=(nombre_new.value or "").strip()
            if nombre:
                cid = LocalReplica.save_plato_categoria({'nombre': nombre, 'color': color_picker.value})
                get_sync_queue().add_pending('platos_categorias', 'insert', {
                    'id': cid, 'nombre': nombre, 'color': color_picker.value, 'activo': 1,
                })
                nombre_new.value=""
                self._show_plato_categorias_dialog()
                if self.page:
                    self.page.update()

        content=ft.Column([
            ft.Row([nombre_new, color_picker, ft.IconButton(ft.Icons.ADD_CIRCLE, icon_color="#4CAF50",
                       icon_size=32, on_click=lambda _: add_cat())], spacing=6),
            ft.Container(height=8),
            ft.Container(content=cat_list, border=ft.border.all(1,"#3D3D3D"),
                          border_radius=10, padding=10, height=300),
        ], tight=True, scroll=ft.ScrollMode.AUTO, width=520)

        self._show_dialog(title="Categorias", content=content, on_save=lambda: self._close_dialog(),
                          save_text="Cerrar")

    def _build_pcat_card(self, cat: dict):
        return ft.Container(
            content=ft.Row([
                ft.Container(width=12, height=12, bgcolor=cat.get('color','#FF6F00'),
                             border_radius=6),
                ft.Text(cat['nombre'], size=14, color=ft.Colors.WHITE, expand=True),
                ft.Switch(value=bool(cat.get('activo')),
                          on_change=lambda e, c=cat: self._toggle_pcat(c, e.control.value)),
                ft.IconButton(ft.Icons.DELETE, icon_size=18, icon_color="#EF5350",
                              on_click=lambda _, c=cat: self._delete_pcat(c)),
            ], spacing=8, vertical_alignment=ft.CrossAxisAlignment.CENTER),
            padding=8, bgcolor="#1E1E1E", border_radius=8,
        )

    def _toggle_pcat(self, cat, activo):
        LocalReplica.save_plato_categoria({'id': cat['id'], 'nombre': cat['nombre'],
                                            'color': cat.get('color','#FF6F00'), 'activo': activo})
        get_sync_queue().add_pending('platos_categorias', 'update', {
            'id': cat['id'], 'nombre': cat['nombre'],
            'color': cat.get('color','#FF6F00'), 'activo': activo,
        })

    def _delete_pcat(self, cat):
        LocalReplica.delete_plato_categoria(cat['id'])
        get_sync_queue().add_pending('platos_categorias', 'delete', {'id': cat['id']})
        self._show_plato_categorias_dialog()

    # ==================== DIALOGO PLATO ====================

    def _show_plato_dialog(self, plato: dict = None):
        is_edit=plato is not None
        plato_id=plato.get('id') if is_edit else None

        nombre=ft.TextField(label="Nombre",
                            value=plato.get('nombre','') if is_edit else '',
                            width=350, autofocus=True)

        cats=LocalReplica.get_platos_categorias()
        cat_opts=[ft.dropdown.Option(str(c['id']), c['nombre']) for c in cats]
        cat_dd=ft.Dropdown(label="Categoria", options=cat_opts,
                           value=str(plato.get('categoria_id','')) if is_edit else None,
                           width=350)

        precio=ft.TextField(label="Precio de venta ($)",
                            value=f"{float(plato.get('precio_venta',0) or 0):.2f}" if is_edit else '',
                            keyboard_type=ft.KeyboardType.NUMBER, width=350)

        es_contorno_sw=ft.Switch(
            label="Es un contorno (acompañante)",
            value=bool(plato.get('es_contorno')) if is_edit else False,
        )

        ingredientes_container=ft.Column(spacing=6, tight=True)
        ingredientes_data=[]
        if is_edit:
            full=LocalReplica.get_plato_with_ingredientes(plato_id)
            if full:
                ingredientes_data=full.get('ingredientes',[])

        def build_ing_row(ing_data=None):
            prods=LocalReplica.get_productos_insumo()
            prod_opts=[ft.dropdown.Option(str(p['id']), f"{p['nombre']} ({p.get('tipo','')})")
                       for p in prods]
            ing_prod=ft.Dropdown(label="Producto", options=prod_opts, width=280,
                                 value=str(ing_data.get('producto_id','')) if ing_data else None)
            ing_cant=ft.TextField(label="Cantidad", width=100,
                                  value=str(ing_data.get('cantidad','')) if ing_data else '',
                                  keyboard_type=ft.KeyboardType.NUMBER)
            ing_unidad=ft.TextField(label="Unidad", width=100,
                                    value=ing_data.get('unidad','unidad') if ing_data else 'unidad')
            row=ft.Row([
                ing_prod, ing_cant, ing_unidad,
                ft.IconButton(ft.Icons.DELETE_ROUNDED, icon_color="#EF5350",
                              icon_size=20, tooltip="Quitar"),
            ], spacing=8, vertical_alignment=ft.CrossAxisAlignment.CENTER)
            row.controls[-1].on_click=lambda _, r=row: self._remove_ing_row(ingredientes_container, r)
            return row

        def add_ing_row():
            ingredientes_container.controls.append(build_ing_row())
            ingredientes_container.update()

        for ing in ingredientes_data:
            ingredientes_container.controls.append(build_ing_row(ing))
        if not ingredientes_data:
            ingredientes_container.controls.append(
                ft.Text("Sin ingredientes (opcional)", size=12, color="#757575", italic=True)
            )

        ingredientes_section=ft.Column([
            ft.Text("INGREDIENTES (productos de inventario)", size=13,
                    weight=ft.FontWeight.BOLD, color="#9E9E9E"),
            ingredientes_container,
            ft.Container(
                content=ft.Row([
                    ft.Icon(ft.Icons.ADD_ROUNDED, size=16, color="#4CAF50"),
                    ft.Text("Agregar ingrediente", size=13, color="#4CAF50"),
                ], spacing=4),
                on_click=lambda _: add_ing_row(),
            ),
        ], spacing=8, tight=True)

        lleva_contornos_sw=ft.Switch(
            label="Lleva contornos (elige al vender)",
            value=bool(plato.get('lleva_contornos')) if is_edit else False,
        )

        content=ft.Column([
            nombre, cat_dd, precio, es_contorno_sw, lleva_contornos_sw,
            ft.Divider(height=1, color="#3D3D3D"),
            ingredientes_section,
        ], spacing=12, tight=True, scroll=ft.ScrollMode.AUTO)

        def save():
            name_val=(nombre.value or "").strip()
            if not name_val:
                nombre.error_text="Requerido"; nombre.update(); return
            cat_val=cat_dd.value
            if not cat_val:
                cat_dd.error_text="Seleccione una categoria"; cat_dd.update(); return

            ingredientes=[]
            for row_ctrl in ingredientes_container.controls:
                if not hasattr(row_ctrl, 'controls') or not row_ctrl.controls: continue
                fields=row_ctrl.controls
                pid=fields[0].value; cant=fields[1].value; uni=fields[2].value
                if pid and cant:
                    ingredientes.append({
                        'producto_id': int(pid),
                        'cantidad': float(cant),
                        'unidad': uni or 'unidad',
                    })

            try:
                pd={
                    'nombre': name_val,
                    'categoria_id': int(cat_val),
                    'precio_venta': float(precio.value or 0),
                    'es_contorno': bool(es_contorno_sw.value),
                    'lleva_contornos': bool(lleva_contornos_sw.value),
                }
                if is_edit:
                    pd['id']=plato_id
                pid = LocalReplica.save_plato(pd, ingredientes)
                pd['id'] = pid
                get_sync_queue().add_pending('platos', 'upsert', pd)
                for ing in ingredientes:
                    get_sync_queue().add_pending('plato_ingredientes', 'insert', {
                        'plato_id': pid, 'producto_id': ing['producto_id'],
                        'cantidad': ing['cantidad'], 'unidad': ing['unidad'],
                    })
                self._close_dialog()
                self._load_platos()
            except Exception as ex:
                import traceback as tb
                tb.print_exc()
                print(f"[POS CONFIG] Error guardando plato: {ex}")

        self._show_dialog(title=f"{'Editar' if is_edit else 'Nuevo'} Plato",
                          content=content, on_save=save)

    def _remove_ing_row(self, container, row):
        if len(container.controls) > 1:
            container.controls.remove(row)
            container.update()

    # ==================== UTILIDADES ====================

    def _empty_placeholder(self, texto):
        return ft.Container(
            content=ft.Column([
                ft.Icon(ft.Icons.INBOX_ROUNDED, size=50, color="#757575"),
                ft.Text(texto, size=14, color="#9E9E9E"),
            ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
            padding=30, alignment=ft.alignment.center,
        )

    def _show_dialog(self, title, content, on_save, save_text="Guardar"):
        self._close_dialog()
        self.active_dialog=ft.AlertDialog(
            title=ft.Text(title),
            content=content,
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: self._close_dialog()),
                ft.ElevatedButton(save_text, on_click=lambda _: on_save(),
                                  bgcolor="#4CAF50", color=ft.Colors.WHITE),
            ],
        )
        if self.page:
            self.page.overlay.append(self.active_dialog)
            self.active_dialog.open=True
            self.page.update()

    def _close_dialog(self):
        if hasattr(self,'active_dialog') and self.active_dialog:
            self.active_dialog.open=False
            self.active_dialog=None
            self._flush()

    def _flush(self):
        if not self.page:
            return
        try:
            for c in self.page.overlay[:]:
                if isinstance(c, ft.AlertDialog):
                    c.open=False
            self.page.update()
        except AssertionError:
            pass

    def _show_error(self, field, message):
        field.error_text=message
        if self.page:
            self.page.update()
        try:
            from usr.notifications import show_error_with_copy
            show_error_with_copy(message, ex=None)
        except Exception:
            pass

    def _go_back(self):
        if self.on_back:
            self.on_back()
