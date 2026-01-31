import flet as ft
from datetime import datetime
from sqlalchemy import func
from app.database.base import get_db
from app.models import Movimiento, Factura, Producto, Categoria


class ValidacionView(ft.Container):
    def __init__(self):
        super().__init__()
        self.visible = False
        self.expand = True
        self.padding = ft.padding.all(16)
        
        # Componentes UI
        self.entradas_list = None
        self.search_field = None
        self.dialog_validar = None
        self.selected_entradas = set()  # IDs de entradas seleccionadas
        self.entradas_data = {}  # Cache de entradas para referencia rapida
        
        self._build_ui()
    
    def did_mount(self):
        """Se ejecuta despues de que la vista se agrega a la pagina"""
        self._load_entradas_pendientes()
    
    def _build_ui(self):
        """Construir la interfaz de usuario"""
        # Titulo
        title = ft.Text(
            "Validacion de Entradas",
            size=24,
            weight=ft.FontWeight.BOLD,
            color=ft.colors.ON_SURFACE,
        )
        
        # Instrucciones
        instructions = ft.Text(
            "Toca las entradas que deseas validar y luego pulsa el boton",
            size=14,
            color=ft.colors.ON_SURFACE_VARIANT,
        )
        
        # Campo de busqueda
        self.search_field = ft.TextField(
            label="Buscar producto...",
            prefix_icon=ft.icons.SEARCH,
            border_radius=ft.border_radius.all(12),
            on_change=self._filter_entradas,
        )
        
        # Botones de accion
        self.validate_button = ft.ElevatedButton(
            text="Validar Seleccionados (0)",
            icon=ft.icons.CHECK_CIRCLE,
            disabled=True,
            on_click=self._show_validar_dialog,
        )
        
        self.clear_button = ft.OutlinedButton(
            text="Limpiar Seleccion",
            on_click=self._clear_selection,
        )
        
        action_row = ft.Row(
            [self.validate_button, self.clear_button],
            spacing=16,
        )
        
        # Lista de entradas
        self.entradas_list = ft.ListView(
            expand=True,
            spacing=8,
            padding=ft.padding.all(8),
        )
        
        # Contenedor principal
        self.content = ft.Column(
            [
                title,
                ft.Divider(height=1),
                ft.Container(height=8),
                instructions,
                ft.Container(height=8),
                self.search_field,
                ft.Container(height=8),
                action_row,
                ft.Container(height=8),
                ft.Text(
                    "Entradas Pendientes de Validar",
                    size=16,
                    weight=ft.FontWeight.W_500,
                ),
                self.entradas_list,
            ],
            expand=True,
            spacing=0,
        )
    
    def _load_entradas_pendientes(self):
        """Cargar entradas pendientes de validar (sin factura)"""
        try:
            db = next(get_db())
            
            # Obtener movimientos sin factura_id (entradas directas)
            query = db.query(Movimiento).filter(
                Movimiento.factura_id.is_(None),
                Movimiento.tipo == "entrada"
            )
            
            # Aplicar filtro de busqueda
            search_term = self.search_field.value.lower().strip() if self.search_field.value else ""
            if search_term:
                query = query.join(Producto).filter(
                    Producto.nombre.ilike(f"%{search_term}%")
                )
            
            entradas = query.order_by(Movimiento.fecha_movimiento.desc()).all()
            
            # Actualizar cache
            self.entradas_data = {e.id: e for e in entradas}
            
            # Mantener solo selections validas
            self.selected_entradas = self.selected_entradas.intersection(set(self.entradas_data.keys()))
            self._update_validate_button()
            
            self.entradas_list.controls.clear()
            
            if not entradas:
                self.entradas_list.controls.append(
                    ft.Container(
                        content=ft.Column(
                            [
                                ft.Icon(
                                    ft.icons.CHECK_CIRCLE,
                                    size=64,
                                    color=ft.colors.GREEN,
                                ),
                                ft.Text(
                                    "No hay entradas pendientes",
                                    size=18,
                                    color=ft.colors.ON_SURFACE_VARIANT,
                                    text_align=ft.TextAlign.CENTER,
                                ),
                                ft.Text(
                                    "Todas las entradas han sido validadas",
                                    size=14,
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
                for entrada in entradas:
                    card = self._create_entrada_card(entrada)
                    self.entradas_list.controls.append(card)
            
            self.update()
            
        except Exception as ex:
            print(f"Error cargando entradas: {ex}")
            import traceback
            traceback.print_exc()
            self._show_error("Error al cargar entradas")
        finally:
            db.close()
    
    def _create_entrada_card(self, entrada: Movimiento):
        """Crear tarjeta de entrada"""
        is_selected = entrada.id in self.selected_entradas
        
        # Determinar color segun seleccion
        if is_selected:
            border_color = ft.colors.PRIMARY
            bg_color = ft.colors.PRIMARY_CONTAINER
            icon_color = ft.colors.PRIMARY
        else:
            border_color = ft.colors.OUTLINE
            bg_color = None
            icon_color = ft.colors.PRIMARY
        
        # Producto nombre
        nombre = entrada.producto.nombre if entrada.producto else "Producto no encontrado"
        
        # Mostrar peso si existe
        peso_info = ""
        if entrada.peso_registrado:
            peso_info = f"Peso: {entrada.peso_registrado:.2f} kg | "
        
        # Fecha
        fecha_info = ""
        if entrada.fecha_movimiento:
            fecha_info = entrada.fecha_movimiento.strftime("%d/%m %H:%M")
        
        # Construir lista de controles
        controls = [
            ft.Row(
                [
                    ft.Container(
                        content=ft.Icon(
                            ft.icons.ARROW_FORWARD,
                            color=icon_color,
                            size=24,
                        ),
                        bgcolor=ft.colors.with_opacity(0.1, icon_color),
                        border_radius=ft.border_radius.all(8),
                        padding=ft.padding.all(8),
                    ),
                    ft.Container(expand=True),
                    ft.Icon(
                        ft.icons.CHECK_CIRCLE if is_selected else ft.icons.RADIO_BUTTON_UNCHECKED,
                        color=ft.colors.PRIMARY if is_selected else ft.colors.OUTLINE,
                        size=28,
                    ),
                ],
                vertical_alignment=ft.CrossAxisAlignment.CENTER,
            ),
            ft.Text(
                nombre,
                size=16,
                weight=ft.FontWeight.BOLD,
            ),
            ft.Row(
                [
                    ft.Icon(
                        ft.icons.INVENTORY,
                        size=14,
                        color=ft.colors.ON_SURFACE_VARIANT,
                    ),
                    ft.Text(
                        f"{entrada.cantidad:.2f} {entrada.producto.unidad_medida if entrada.producto else ''}",
                        size=14,
                        color=ft.colors.ON_SURFACE_VARIANT,
                    ),
                ],
                spacing=4,
            ),
            ft.Row(
                [
                    ft.Icon(
                        ft.icons.CALENDAR_TODAY,
                        size=14,
                        color=ft.colors.ON_SURFACE_VARIANT,
                    ),
                    ft.Text(
                        fecha_info,
                        size=14,
                        color=ft.colors.ON_SURFACE_VARIANT,
                    ),
                ],
                spacing=4,
            ),
        ]
        
        # Agregar peso si existe
        if entrada.peso_registrado:
            controls.append(
                ft.Row(
                    [
                        ft.Icon(
                            ft.icons.SCALE,
                            size=14,
                            color=ft.colors.ON_SURFACE_VARIANT,
                        ),
                        ft.Text(
                            f"Peso: {entrada.peso_registrado:.2f} kg",
                            size=14,
                            color=ft.colors.ON_SURFACE_VARIANT,
                        ),
                    ],
                    spacing=4,
                )
            )
        
        controls.append(
            ft.Row(
                [
                    ft.Icon(
                        ft.icons.PERSON,
                        size=14,
                        color=ft.colors.ON_SURFACE_VARIANT,
                    ),
                    ft.Text(
                        entrada.registrado_por or "N/A",
                        size=12,
                        color=ft.colors.ON_SURFACE_VARIANT,
                    ),
                ],
                spacing=4,
            )
        )
        
        card = ft.Card(
            content=ft.Container(
                content=ft.Column(controls, spacing=4),
                padding=ft.padding.all(12),
                on_click=lambda e, ent_id=entrada.id: self._toggle_entrada_selection(ent_id),
            ),
            elevation=1 if not is_selected else 3,
            shape=ft.RoundedRectangleBorder(radius=12),
            color=bg_color,
        )
        
        return card
    
    def _toggle_entrada_selection(self, entrada_id: int):
        """Alternar seleccion de entrada"""
        if entrada_id in self.selected_entradas:
            self.selected_entradas.discard(entrada_id)
        else:
            self.selected_entradas.add(entrada_id)
        
        self._update_validate_button()
        self._load_entradas_pendientes()  # Recargar para actualizar visuales
    
    def _clear_selection(self, e=None):
        """Limpiar seleccion"""
        self.selected_entradas.clear()
        self._update_validate_button()
        self._load_entradas_pendientes()
    
    def _update_validate_button(self):
        """Actualizar estado del boton de validar"""
        count = len(self.selected_entradas)
        if count > 0:
            self.validate_button.text = f"Validar ({count}) seleccionado(s)"
            self.validate_button.disabled = False
        else:
            self.validate_button.text = "Validar Seleccionados (0)"
            self.validate_button.disabled = True
    
    def _show_validar_dialog(self, e):
        """Mostrar dialogo para validar entradas"""
        count = len(self.selected_entradas)
        if count == 0:
            return
        
        # Campo de numero de factura
        factura_field = ft.TextField(
            label="Numero de Factura (ej: FAC-001)",
            prefix_icon=ft.icons.DESCRIPTION,
            border_radius=ft.border_radius.all(12),
            hint_text="Dejar vacio para generar referencia automatica",
        )
        
        # Campo de observaciones
        observaciones_field = ft.TextField(
            label="Observaciones (opcional)",
            multiline=True,
            border_radius=ft.border_radius.all(12),
            min_lines=2,
        )
        
        self.dialog_validar = ft.AlertDialog(
            title=ft.Text(f"Validar {count} Entrada(s)"),
            content=ft.Column(
                [
                    ft.Text(
                        f"Se validaran {count} entrada(s) de productos",
                        size=14,
                        color=ft.colors.ON_SURFACE_VARIANT,
                    ),
                    ft.Container(height=16),
                    ft.Text("Numero de Factura:", size=14, weight=ft.FontWeight.W_500),
                    factura_field,
                    ft.Container(height=16),
                    ft.Text("Observaciones:", size=14, weight=ft.FontWeight.W_500),
                    observaciones_field,
                ],
                spacing=0,
            ),
            actions=[
                ft.TextButton("Cancelar", on_click=self._close_dialog),
                ft.ElevatedButton(
                    "Validar",
                    icon=ft.icons.CHECK,
                    on_click=lambda e: self._validar_entradas(
                        factura_field.value.strip() if factura_field.value else None,
                        observaciones_field.value.strip() if observaciones_field.value else None,
                    ),
                ),
            ],
            actions_alignment=ft.MainAxisAlignment.END,
            modal=True,
        )
        
        self.page.dialog = self.dialog_validar
        self.dialog_validar.open = True
        self.page.update()
    
    def _validar_entradas(self, numero_factura: str = None, observaciones: str = None):
        """Validar entradas seleccionadas"""
        try:
            db = next(get_db())
            
            if not self.selected_entradas:
                self._show_error("No hay entradas seleccionadas")
                return
            
            # Obtener entradas seleccionadas
            entradas = db.query(Movimiento).filter(
                Movimiento.id.in_(list(self.selected_entradas))
            ).all()
            
            if not entradas:
                self._show_error("No se encontraron las entradas")
                return
            
            # Crear o obtener factura
            factura = None
            if numero_factura:
                # Buscar factura existente o crear nueva
                factura = db.query(Factura).filter(
                    Factura.numero_factura == numero_factura
                ).first()
                
                if not factura:
                    # Crear nueva factura
                    factura = Factura(
                        numero_factura=numero_factura,
                        proveedor="Varios",
                        fecha_factura=datetime.now(),
                        fecha_recepcion=datetime.now(),
                        total_bruto=0,
                        total_impuestos=0,
                        total_neto=0,
                        estado="Validada",
                        observaciones=observaciones or f"Factura creada desde validacion de {len(entradas)} entrada(s)",
                        validada_por="Administrador",
                        fecha_validacion=datetime.now(),
                    )
                    db.add(factura)
                    db.flush()
            else:
                # Generar referencia automatica
                ref = f"REF-{datetime.now().strftime('%Y%m%d%H%M%S')}"
                factura = Factura(
                    numero_factura=ref,
                    proveedor="Varios",
                    fecha_factura=datetime.now(),
                    fecha_recepcion=datetime.now(),
                    total_bruto=0,
                    total_impuestos=0,
                    total_neto=0,
                    estado="Validada",
                    observaciones=observaciones or f"Referencia automatica",
                    validada_por="Administrador",
                    fecha_validacion=datetime.now(),
                )
                db.add(factura)
                db.flush()
            
            # Actualizar cada entrada con la factura
            for entrada in entradas:
                entrada.factura_id = factura.id
            
            db.commit()
            
            self._close_dialog()
            self._show_message(f"{len(entradas)} entrada(s) validadas correctamente")
            
            # Limpiar seleccion y recargar
            self.selected_entradas.clear()
            self._load_entradas_pendientes()
            
        except Exception as ex:
            print(f"Error validando entradas: {ex}")
            import traceback
            traceback.print_exc()
            self._show_error(f"Error al validar: {str(ex)}")
            db.rollback()
        finally:
            db.close()
    
    def _filter_entradas(self, e):
        """Filtrar entradas segun busqueda"""
        self._load_entradas_pendientes()
    
    def _close_dialog(self, e=None):
        """Cerrar dialogo"""
        if self.dialog_validar:
            self.dialog_validar.open = False
            self.page.update()
    
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
