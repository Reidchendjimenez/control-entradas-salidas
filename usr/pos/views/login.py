"""
Vista de login del POS.

Muestra:
- Lista de cajeros registrados
- Botón para agregar nuevo cajero
- Botón de login (sin PIN por defecto, o con PIN si el cajero lo tiene)
"""
import flet as ft
from usr.database.local_replica import LocalReplica
from usr.theme import get_colors


class POSLoginView(ft.Container):
    def __init__(self, on_login=None):
        super().__init__()
        self.expand = True
        self.bgcolor = "#121212"
        self.padding = 20
        self.on_login = on_login
        self._build_ui()
        self._load_usuarios()

    def _build_ui(self):
        self.txt_status = ft.Text("", size=14, color="#EF5350")

        self.btn_login = ft.ElevatedButton(
            "Iniciar sesion",
            icon=ft.Icons.LOGIN_ROUNDED,
            bgcolor="#BB86FC",
            color=ft.Colors.WHITE,
            width=300,
            disabled=True,
            on_click=lambda _: self._do_login(),
        )

        self.txt_nombre_actual = ft.Text(
            "Seleccione un cajero para iniciar sesion",
            size=14,
            color="#9E9E9E",
            italic=True,
        )

        self.lv_usuarios = ft.ListView(
            expand=True,
            spacing=8,
            auto_scroll=False,
        )

        self.content = ft.Column(
            [
                ft.Container(
                    content=ft.Row(
                        [
                            ft.Icon(ft.Icons.STORE_ROUNDED, size=40, color="#BB86FC"),
                            ft.Column(
                                [
                                    ft.Text("Lycoris POS", size=28, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                                    ft.Text("Seleccione el cajero", size=14, color="#9E9E9E"),
                                ],
                                spacing=2,
                            ),
                        ],
                        alignment=ft.MainAxisAlignment.CENTER,
                    ),
                    alignment=ft.Alignment.CENTER,
                    padding=ft.Padding.only(top=40, bottom=30),
                ),
                ft.Container(
                    content=self.txt_nombre_actual,
                    alignment=ft.Alignment.CENTER,
                    padding=ft.Padding.only(bottom=10),
                ),
                ft.Container(
                    content=self.lv_usuarios,
                    border=ft.Border.all(1, "#3D3D3D"),
                    border_radius=10,
                    padding=10,
                    expand=True,
                ),
                ft.Container(height=10),
                self.txt_status,
                ft.Container(height=10),
                ft.Row(
                    [self.btn_login],
                    alignment=ft.MainAxisAlignment.CENTER,
                    spacing=10,
                ),
            ],
            expand=True,
        )

        self.selected_usuario = None

    def _load_usuarios(self):
        self.lv_usuarios.controls.clear()
        self._seed_default_admin()
        usuarios = LocalReplica.get_pos_usuarios()
        if not usuarios:
            self.lv_usuarios.controls.append(
                ft.Container(
                    content=ft.Column(
                        [
                            ft.Icon(ft.Icons.PERSON_OFF_ROUNDED, size=50, color="#757575"),
                            ft.Container(height=10),
                            ft.Text("No hay cajeros registrados", size=14, color="#9E9E9E"),
                            ft.Text("Agregue uno con el boton de abajo", size=12, color="#757575"),
                            ft.Container(height=10),
                            ft.OutlinedButton(
                                "Nuevo cajero",
                                icon=ft.Icons.PERSON_ADD_ROUNDED,
                                on_click=lambda _: self._show_agregar_dialog(),
                            ),
                        ],
                        horizontal_alignment=ft.CrossAxisAlignment.CENTER,
                    ),
                    padding=30,
                    alignment=ft.Alignment.CENTER,
                )
            )
            return

        for u in usuarios:
            self.lv_usuarios.controls.append(
                self._build_usuario_card(u)
            )

    def _seed_default_admin(self):
        usuarios = LocalReplica.get_pos_usuarios()
        if not usuarios:
            try:
                LocalReplica.crear_pos_usuario("Desarrollador", pin=None, es_admin=True)
                print("[POS LOGIN] Usuario 'Desarrollador' creado automaticamente")
            except Exception as e:
                print(f"[POS LOGIN] Error creando usuario por defecto: {e}")

    def _build_usuario_card(self, usuario: dict):
        has_pin = bool(usuario.get('pin_hash'))
        es_admin = bool(usuario.get('es_admin'))
        estado = []
        if es_admin:
            estado.append("Admin")
        estado.append("Con PIN" if has_pin else "Sin PIN")
        return ft.Container(
            content=ft.Row(
                [
                    ft.Container(
                        content=ft.Text(
                            usuario['nombre'][:2].upper(),
                            size=18,
                            weight=ft.FontWeight.BOLD,
                            color=ft.Colors.WHITE,
                        ),
                        width=50,
                        height=50,
                        bgcolor="#7C4DFF" if not es_admin else "#FF9800",
                        border_radius=25,
                        alignment=ft.Alignment.CENTER,
                    ),
                    ft.Column(
                        [
                            ft.Text(usuario['nombre'], size=16, weight=ft.FontWeight.BOLD, color=ft.Colors.WHITE),
                            ft.Text(" - ".join(estado), size=12, color="#9E9E9E"),
                        ],
                        spacing=2,
                        expand=True,
                    ),
                    ft.Icon(
                        ft.Icons.ADMIN_PANEL_SETTINGS_ROUNDED if es_admin else (
                            ft.Icons.LOCK_ROUNDED if has_pin else ft.Icons.LOCK_OPEN_ROUNDED
                        ),
                        size=20,
                        color="#FF9800" if es_admin else "#9E9E9E",
                    ),
                ],
                spacing=15,
            ),
            bgcolor="#1E1E1E",
            border=ft.Border.all(1, "#3D3D3D"),
            border_radius=10,
            padding=15,
            on_click=lambda _, uid=usuario['id']: self._select_and_login(uid),
            ink=True,
        )

    def _select_usuario(self, usuario_id: int):
        self.selected_usuario = usuario_id
        usuario = LocalReplica.get_pos_usuario(usuario_id)
        self.txt_nombre_actual.value = f"Seleccionado: {usuario['nombre']}"
        self.txt_nombre_actual.color = "#BB86FC"
        self.txt_nombre_actual.italic = False
        self.btn_login.disabled = False
        self.btn_login.text = f"Iniciar como {usuario['nombre']}"
        self._clear_status()
        if self.page:
            self.update()

    def _select_and_login(self, usuario_id: int):
        self._select_usuario(usuario_id)
        self._do_login()

    def _clear_status(self):
        self.txt_status.value = ""
        if self.page:
            self.update()

    def _do_login(self):
        if not self.selected_usuario:
            return
        usuario = LocalReplica.get_pos_usuario(self.selected_usuario)
        if not usuario:
            return

        if usuario.get('pin_hash'):
            self._show_pin_dialog(usuario)
        else:
            self._complete_login(usuario)

    def _show_pin_dialog(self, usuario: dict):
        self.pin_input = ft.TextField(
            label="PIN",
            password=True,
            max_length=4,
            keyboard_type=ft.KeyboardType.NUMBER,
            width=200,
            autofocus=True,
            on_submit=lambda _: self._verify_pin_and_login(usuario),
        )
        self.pin_dialog = ft.AlertDialog(
            title=ft.Text(f"PIN de {usuario['nombre']}"),
            content=self.pin_input,
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: self._close_pin_dialog()),
                ft.ElevatedButton(
                    "Entrar",
                    on_click=lambda _: self._verify_pin_and_login(usuario),
                    bgcolor="#BB86FC",
                    color=ft.Colors.WHITE,
                ),
            ],
        )
        if self.page:
            self.page.overlay.append(self.pin_dialog)
            self.pin_dialog.open = True
            self.page.update()

    def _verify_pin_and_login(self, usuario: dict):
        if not self.pin_input.value:
            return
        if LocalReplica.verificar_pos_pin(usuario['id'], self.pin_input.value):
            self._close_pin_dialog()
            self._complete_login(usuario)
        else:
            print(f"[POS LOGIN] PIN incorrecto para usuario {usuario.get('nombre')}")
            self._show_validation_error(self.pin_input, "PIN incorrecto")

    def _close_pin_dialog(self):
        if hasattr(self, 'pin_dialog') and self.pin_dialog:
            self.pin_dialog.open = False
            self.pin_dialog = None
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

    def _complete_login(self, usuario: dict):
        sesion_id = LocalReplica.abrir_pos_sesion(usuario['id'])
        if self.on_login:
            self.on_login(usuario, sesion_id)

    def _show_agregar_dialog(self):
        self.nombre_input = ft.TextField(
            label="Nombre del cajero",
            width=300,
            autofocus=True,
        )
        self.pin_check = ft.Checkbox(
            label="Proteger con PIN de 4 digitos",
            value=False,
        )
        self.pin_input_new = ft.TextField(
            label="PIN (4 digitos)",
            password=True,
            max_length=4,
            keyboard_type=ft.KeyboardType.NUMBER,
            width=300,
            disabled=True,
        )
        def _on_pin_check_change(e):
            self.pin_input_new.disabled = not e.control.value
            self.pin_input_new.error_text = None
            if self.page:
                self.page.update()
        self.pin_check.on_change = _on_pin_check_change
        self.admin_check = ft.Checkbox(
            label="Es administrador (acceso a configuracion)",
            value=False,
        )

        self.agregar_dialog = ft.AlertDialog(
            title=ft.Text("Nuevo Cajero"),
            content=ft.Column(
                [
                    self.nombre_input,
                    self.pin_check,
                    self.pin_input_new,
                    ft.Container(height=5),
                    ft.Divider(height=1, color="#3D3D3D"),
                    self.admin_check,
                ],
                tight=True,
            ),
            actions=[
                ft.TextButton("Cancelar", on_click=lambda _: self._close_agregar_dialog()),
                ft.ElevatedButton(
                    "Guardar",
                    on_click=lambda _: self._do_agregar(),
                    bgcolor="#4CAF50",
                    color=ft.Colors.WHITE,
                ),
            ],
        )
        if self.page:
            self.page.overlay.append(self.agregar_dialog)
            self.agregar_dialog.open = True
            self.page.update()

    def _close_agregar_dialog(self):
        if hasattr(self, 'agregar_dialog') and self.agregar_dialog:
            self.agregar_dialog.open = False
            self.agregar_dialog = None
            self._flush()

    def _do_agregar(self):
        import traceback as tb
        nombre = (self.nombre_input.value or "").strip()
        if not nombre:
            self._show_validation_error(self.nombre_input, "Ingrese un nombre")
            return

        pin = self.pin_input_new.value if self.pin_check.value else None
        if self.pin_check.value:
            if not pin or len(pin) != 4 or not pin.isdigit():
                self._show_validation_error(self.pin_input_new, "PIN debe tener 4 digitos")
                return

        es_admin = self.admin_check.value

        try:
            LocalReplica.crear_pos_usuario(nombre, pin, es_admin=es_admin)
            self._close_agregar_dialog()
            self._load_usuarios()
            if self.page:
                self.update()
        except Exception as ex:
            traceback_text = tb.format_exc()
            print(f"[POS LOGIN] Error al crear cajero:\n{traceback_text}")
            self._show_validation_error(
                self.nombre_input,
                f"Error: {ex}",
                exception=ex,
            )

    def _show_validation_error(self, field, message, exception=None):
        field.error_text = message
        if self.page:
            self.page.update()
        try:
            from usr.notifications import show_error_with_copy
            full_msg = message
            if exception:
                full_msg = f"{type(exception).__name__}: {exception}"
            show_error_with_copy(full_msg, ex=exception)
        except Exception:
            pass
