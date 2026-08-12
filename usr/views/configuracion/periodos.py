import flet as ft
from datetime import datetime
from usr.database.local_replica import LocalReplica
from usr.database.archive import archivar_movimientos, guardar_periodo_en_supabase
from usr.notifications import show_success, show_error, show_info
from usr.views.configuracion.helpers import _colors


def build_periodos_tab(view):
    colors = _colors(view.page)

    periodos = LocalReplica.get_periodos()
    periodo_actual = datetime.now().strftime("%Y-%m")
    ya_abierto = LocalReplica.periodo_existe(periodo_actual)

    lista = ft.ListView(expand=True, spacing=8, auto_scroll=False)
    _render_lista(lista, periodos, colors)

    info_text = ft.Text(
        f"Periodo actual: {periodo_actual} — {'Abierto' if ya_abierto else 'Cerrado'}",
        size=13,
        color=colors['success'] if ya_abierto else colors['warning'],
        weight=ft.FontWeight.BOLD,
    )

    btn_aperturar = ft.ElevatedButton(
        "Aperturar Periodo",
        icon=ft.Icons.LOCK_OPEN,
        bgcolor=colors['accent'],
        color=colors['white'],
        disabled=ya_abierto,
        on_click=lambda e: _aperturar_periodo(view, lista, info_text, btn_aperturar),
    )

    btn_recalcular = ft.ElevatedButton(
        "Recalcular stock desde cero",
        icon=ft.Icons.REFRESH,
        bgcolor=colors['warning'],
        color=colors['white'],
        on_click=lambda e: _recalcular_desde_cero(view, lista, info_text, btn_aperturar),
    )

    btn_forzar_archivo = ft.ElevatedButton(
        "Re-aperturar (forzar archivo)",
        icon=ft.Icons.REPLAY,
        bgcolor=colors['warning'],
        color=colors['white'],
        visible=ya_abierto,
        on_click=lambda e: _forzar_archivo_periodo_actual(view, lista, info_text),
    )

    btn_reintentar_supabase = ft.ElevatedButton(
        "Reintentar archivo en nube",
        icon=ft.Icons.CLOUD_UPLOAD,
        bgcolor=colors['accent'],
        color=colors['white'],
        visible=ya_abierto,
        on_click=lambda e: _reintentar_supabase(view, lista, info_text),
    )

    return ft.Container(
        content=ft.Column([
            ft.Container(height=20),
            ft.Card(
                content=ft.Container(
                    content=ft.Column([
                        ft.Row([
                            ft.Container(
                                content=ft.Icon(ft.Icons.CALENDAR_MONTH, color=colors['white'], size=28),
                                bgcolor=colors['accent_dark'],
                                padding=12,
                                border_radius=12,
                            ),
                            ft.Column([
                                ft.Text("Periodos", weight=ft.FontWeight.BOLD, size=16),
                                ft.Text("Archive movimientos anteriores a 3 meses por periodo mensual", size=12, color=colors['text_secondary']),
                            ], spacing=2),
                        ], spacing=15),
                        ft.Divider(height=20, color=colors['border']),
                        info_text,
                        ft.Container(height=10),
                        ft.Row([btn_aperturar, btn_recalcular, btn_forzar_archivo, btn_reintentar_supabase], spacing=10, wrap=True),
                        ft.Divider(height=20, color=colors['border']),
                        ft.Text("Historial de Periodos", weight=ft.FontWeight.BOLD, size=14),
                        lista,
                    ], spacing=15),
                    padding=25,
                ),
            ),
        ], spacing=10, scroll=ft.ScrollMode.AUTO, expand=True),
        padding=20,
        expand=True,
    )


def _render_lista(lista, periodos, colors):
    lista.controls.clear()
    if not periodos:
        lista.controls.append(
            ft.Text("No hay periodos archivados aun", size=13, color=colors['text_hint'], italic=True)
        )
    else:
        for p in periodos:
            try:
                fecha = datetime.fromisoformat(p['fecha_apertura']).strftime("%d/%m/%Y %H:%M")
            except Exception:
                fecha = p.get('fecha_apertura', '')
            lista.controls.append(
                ft.Card(
                    content=ft.Container(
                        content=ft.Row([
                            ft.Icon(ft.Icons.CHECK_CIRCLE, color=colors['success'], size=20),
                            ft.Column([
                                ft.Text(p['periodo'], weight=ft.FontWeight.BOLD, size=14),
                                ft.Text(f"Aperturado: {fecha}", size=11, color=colors['text_secondary']),
                            ], spacing=2, expand=True),
                        ], spacing=10),
                        padding=15,
                    ),
                )
            )


def _aperturar_periodo(view, lista, info_text, btn):
    view.page.run_task(_do_aperturar, view, lista, info_text, btn)


def _show_loading(view, message="Procesando..."):
    if not view.page:
        return
    colors = _colors(view.page)
    overlay = ft.Container(
        content=ft.Container(
            content=ft.Column([
                ft.ProgressBar(width=200, color=colors['accent'], bgcolor=ft.Colors.TRANSPARENT),
                ft.Text(message, size=13, color=colors['text_primary'], text_align=ft.TextAlign.CENTER),
            ], tight=True, horizontal_alignment=ft.CrossAxisAlignment.CENTER),
            bgcolor=colors['card'],
            padding=20,
            border_radius=15,
            width=250,
        ),
        bgcolor=ft.Colors.with_opacity(0.5, ft.Colors.BLACK),
        alignment=ft.Alignment.CENTER,
        expand=True,
    )
    view.page._periodos_overlay = overlay
    view.page.overlay.append(overlay)
    view.page.update()


def _update_loading(view, message):
    try:
        if hasattr(view.page, '_periodos_overlay') and view.page._periodos_overlay:
            view.page._periodos_overlay.content.content.controls[1].value = message
            view.page.update()
    except Exception:
        pass


def _hide_loading(view):
    try:
        if hasattr(view.page, '_periodos_overlay') and view.page._periodos_overlay:
            view.page.overlay.remove(view.page._periodos_overlay)
            view.page._periodos_overlay = None
            view.page.update()
    except Exception:
        pass


async def _do_aperturar(view, lista, info_text, btn):
    print("[PERIODOS] _do_aperturar INICIO")
    periodo = datetime.now().strftime("%Y-%m")
    print(f"[PERIODOS] periodo actual: {periodo}")

    if LocalReplica.periodo_existe(periodo):
        print("[PERIODOS] periodo ya existe localmente")
        show_info(f"El periodo {periodo} ya fue aperturado")
        return

    _show_loading(view, "Aperturando periodo...")
    show_info(f"Aperturando periodo {periodo}...")
    print("[PERIODOS] llamando archivar_movimientos...")

    try:
        _update_loading(view, "Archivando movimientos...")
        archivados, eliminados = archivar_movimientos(meses_activos=3, meses_retencion=7)
        print(f"[PERIODOS] archivo completado: {archivados} archivados")

        _update_loading(view, "Guardando periodo en la nube...")
        try:
            print("[PERIODOS] guardando periodo en Supabase...")
            guardar_periodo_en_supabase(periodo)
            print("[PERIODOS] periodo guardado en Supabase")
        except Exception as e:
            print(f"[PERIODOS] No se pudo guardar periodo en nube: {e}")

        _update_loading(view, "Recalculando existencias...")
        LocalReplica.crear_periodo(periodo, registrado_por="sistema")
        print("[PERIODOS] periodo guardado localmente")
        LocalReplica.recalculate_existencias()
        print("[PERIODOS] existencias recalculadas")

        show_success(f"Periodo {periodo} aperturado: {archivados} movimientos archivados")

        periodos = LocalReplica.get_periodos()
        colors = _colors(view.page)
        _render_lista(lista, periodos, colors)
        info_text.value = f"Periodo actual: {periodo} — Abierto"
        info_text.color = colors['success']
        btn.disabled = True
        view.update()
    except Exception as e:
        print(f"[PERIODOS] Error al aperturar: {e}")
        show_error(f"Error al aperturar periodo: {str(e)}")
    finally:
        _hide_loading(view)


def _recalcular_desde_cero(view, lista, info_text, btn_aperturar):
    view.page.run_task(_do_recalcular, view, lista, info_text, btn_aperturar)


async def _do_recalcular(view, lista, info_text, btn_aperturar):
    show_info("Recalculando stock desde cero...")
    try:
        LocalReplica.clear_checkpoints()
        LocalReplica.recalculate_existencias()
        show_success("Stock recalculado desde todos los movimientos")
    except Exception as e:
        print(f"[PERIODOS] Error al recalcular: {e}")
        show_error(f"Error al recalcular: {str(e)}")


def _reintentar_supabase(view, lista, info_text):
    view.page.run_task(_do_reintentar_supabase, view, lista, info_text)


async def _do_reintentar_supabase(view, lista, info_text):
    show_info("Reintentando archivo en Supabase...")
    try:
        from usr.database.archive import archivar_en_supabase
        archivados = archivar_en_supabase(meses_activos=3)
        if archivados > 0:
            show_success(f"{archivados} movimientos archivados en la nube")
        else:
            show_info("No hay movimientos pendientes de archivar en la nube")
    except Exception as e:
        print(f"[PERIODOS] Error al reintentar Supabase: {e}")
        show_error(f"Error: {str(e)}")


def _forzar_archivo_periodo_actual(view, lista, info_text):
    """Fuerza el archivo completo (Supabase + local + recálculo) aunque el periodo ya exista.
    No crea un nuevo periodo; solo re-ejecuta el archivo y recalcula existencias."""
    view.page.run_task(_do_forzar_archivo, view, lista, info_text)


async def _do_forzar_archivo(view, lista, info_text):
    show_info("Ejecutando archivo forzado (Supabase + local + recálculo)...")
    try:
        from usr.database.archive import archivar_movimientos
        from usr.database.local_replica import LocalReplica
        from usr.views.configuracion.helpers import _colors
        colors = _colors(view.page)

        _show_loading(view, "Archivando en Supabase...")
        archivados, eliminados = archivar_movimientos(meses_activos=3, meses_retencion=7)
        print(f"[PERIODOS] Archivo completado: {archivados} archivados, {eliminados} eliminados")

        _update_loading(view, "Recalculando existencias...")
        LocalReplica.recalculate_existencias()
        print("[PERIODOS] Existencias recalculadas")

        show_success(f"Archivo forzado completado: {archivados} archivados, {eliminados} eliminados")

        periodos = LocalReplica.get_periodos()
        _render_lista(lista, periodos, colors)
        view.update()
    except Exception as e:
        print(f"[PERIODOS] Error en archivo forzado: {e}")
        show_error(f"Error: {str(e)}")
    finally:
        _hide_loading(view)
