"""Capa de datos/negocio del módulo Producciones.

Funciones puras (sin UI) que cargan datos, validan y ejecutan operaciones.
Reciben `page` cuando necesitan al usuario actual.
"""
from datetime import datetime

from usr.database.local_replica import LocalReplica
from usr.views.producciones.helpers import now_iso, usuario_actual


# ----------------------- carga -----------------------

def load_recetas(activo=True):
    return LocalReplica.get_recetas(activo=activo) or []


def load_productos():
    return LocalReplica.get_productos() or []


def stock_total_producto(producto_id: int) -> float:
    """Suma de existencias de un producto en todos los almacenes."""
    existencias = LocalReplica.get_existencias_by_producto(producto_id) or []
    return sum(float(e.get('cantidad', 0) or 0) for e in existencias)


def load_componentes(receta_id):
    return LocalReplica.get_componentes_by_receta(receta_id) or []


def load_producciones(estado=None, limit=50):
    data = LocalReplica.get_producciones(limit=limit) or []
    if estado is None:
        return data
    return [p for p in data if p.get('estado') == estado]


def load_pendientes():
    return load_producciones(estado='pendiente')


def load_pendientes_de_receta(receta_id):
    """Producciones pendientes de una receta, más reciente primero."""
    return [p for p in load_pendientes() if p.get('receta_id') == receta_id]


def load_detalle(produccion_id):
    return LocalReplica.get_detalles_by_produccion(produccion_id) or []


# ----------------------- persistencia de recetas -----------------------

def guardar_receta(receta_data):
    """Guarda receta + componentes. receta_data incluye id si es edición."""
    receta_id = LocalReplica.save_receta(receta_data)
    componentes = receta_data.pop('_componentes', None)
    if componentes is None:
        componentes = receta_data.get('componentes', [])
    LocalReplica.save_componentes(receta_id, componentes)
    return receta_id


def eliminar_receta(receta_id):
    LocalReplica.delete_receta(receta_id)


# ----------------------- flujo 2 etapas -----------------------

def registrar_produccion_pendiente(page, producto, receta, cantidad, peso_total=0.0, almacen=None, produccion_id=None):
    """Etapa 1: registra entrada_produccion + producción pendiente + detalle.

    Si `produccion_id` es None se crea una producción nueva (lote). Si se pasa
    un id, la entrada se VINCULA a ese lote existente (misma pieza/materia
    prima), y la cantidad del lote pasa a ser la suma de todas sus entradas.

    Retorna (produccion_id, movimiento_id). Stock del producto final sube.
    La producción queda en estado 'pendiente' para su descargo.
    """
    from usr.views.inventario.movements import registrar_movimiento

    usuario = usuario_actual(page)
    fecha = now_iso()

    if produccion_id is None:
        observaciones = f"Producción pendiente - Receta '{receta.get('nombre', '')}'"
    else:
        observaciones = f"Entrada vinculada al lote #{produccion_id} - Receta '{receta.get('nombre', '')}'"

    movimiento_id = registrar_movimiento(
        page,
        producto,
        'entrada_produccion',
        cantidad,
        peso_total=peso_total,
        almacen=almacen,
        observaciones=observaciones,
    )
    if not movimiento_id:
        return None, None

    if produccion_id is None:
        produccion_id = LocalReplica.save_produccion({
            'receta_id': receta['id'],
            'cantidad': cantidad,
            'estado': 'pendiente',
            'usuario': usuario,
            'observaciones': observaciones,
            'fecha_produccion': fecha,
        })
    else:
        # Vincular entrada al lote existente y recalcular cantidad = suma de entradas
        detalles = load_detalle(produccion_id)
        entradas = [d for d in detalles if d.get('tipo') == 'entrada']
        total = float(cantidad or 0) + sum(float(d.get('cantidad', 0) or 0) for d in entradas)
        LocalReplica.update_produccion_cantidad(produccion_id, total)

    LocalReplica.save_produccion_detalle({
        'produccion_id': produccion_id,
        'producto_id': producto['id'],
        'tipo': 'entrada',
        'cantidad': cantidad,
        'unidad': 'kg' if peso_total else producto.get('unidad_medida', 'unidad'),
        'movimiento_id': movimiento_id,
    })

    return produccion_id, movimiento_id


def planificar_descargo(receta, produccion):
    """Calcula los ingredientes a descargar.

    Para recetas compuestas usa los INGREDIENTE; para simples usa producto_base.
    Cada item incluye: producto_id, nombre, cantidad_sugerida, peso_variable,
    unidad, es_pesable, almacen.
    """
    es_compuesta = receta.get('tipo') == 'compuesta'
    produccion_cantidad = float(produccion.get('cantidad', 1))
    cantidad_base_receta = float(receta.get('cantidad_producida', 1)) or 1.0
    factor = produccion_cantidad / cantidad_base_receta

    items = []
    if es_compuesta:
        for comp in load_componentes(receta['id']):
            if comp.get('tipo_componente') != 'INGREDIENTE':
                continue
            prod = LocalReplica.get_producto_by_id(comp['producto_id'])
            if not prod:
                continue
            peso_var = bool(comp.get('peso_variable'))
            items.append({
                'producto_id': prod['id'],
                'nombre': prod.get('nombre', f"#{prod['id']}"),
                'cantidad_sugerida': 0.0 if peso_var else float(comp['cantidad'] or 0) * factor,
                'peso_variable': peso_var,
                'unidad': comp.get('unidad') or prod.get('unidad_medida', 'unidad'),
                'es_pesable': bool(prod.get('es_pesable')),
                'almacen': prod.get('almacen_predeterminado', 'principal') or 'principal',
            })
    else:
        if receta.get('producto_base_id'):
            prod = LocalReplica.get_producto_by_id(receta['producto_base_id'])
            if prod:
                pesable = bool(prod.get('es_pesable'))
                items.append({
                    'producto_id': prod['id'],
                    'nombre': prod.get('nombre', f"#{prod['id']}"),
                    # base pesable (ej. pieza de jamón): peso variable, se pide al descargar
                    'cantidad_sugerida': 0.0 if pesable else produccion_cantidad,
                    'peso_variable': pesable,
                    'unidad': 'kg' if pesable else prod.get('unidad_medida', 'unidad'),
                    'es_pesable': pesable,
                    'almacen': prod.get('almacen_predeterminado', 'principal') or 'principal',
                })

    return items


def ejecutar_descargo(page, produccion, receta, items_cantidades):
    """Etapa 2: registra salida_produccion por cada ingrediente y marca completado.

    items_cantidades: lista de {producto_id, cantidad, es_pesable, almacen}
    """
    from usr.views.inventario.movements import registrar_movimiento

    usuario = usuario_actual(page)
    fecha = now_iso()
    errores = []

    for item in items_cantidades:
        cantidad = float(item.get('cantidad', 0) or 0)
        if cantidad <= 0:
            continue
        prod = LocalReplica.get_producto_by_id(item['producto_id'])
        if not prod:
            errores.append(f"Producto {item['producto_id']} no encontrado")
            continue
        es_pesable = bool(item.get('es_pesable') or prod.get('es_pesable'))
        peso_total = cantidad if es_pesable else 0.0
        almacen = item.get('almacen') or prod.get('almacen_predeterminado', 'principal') or 'principal'

        mov_id = registrar_movimiento(
            page,
            prod,
            'salida_produccion',
            cantidad,
            peso_total=peso_total,
            almacen=almacen,
            observaciones=f"Descargo Producción #{produccion['id']} - {receta.get('nombre', '')}",
        )
        if not mov_id:
            errores.append(f"Stock insuficiente para {prod.get('nombre', prod['id'])}")
            continue

        LocalReplica.save_produccion_detalle({
            'produccion_id': produccion['id'],
            'producto_id': prod['id'],
            'tipo': 'salida',
            'cantidad': cantidad,
            'unidad': 'kg' if es_pesable and peso_total > 0 else (item.get('unidad') or prod.get('unidad_medida', 'unidad')),
            'movimiento_id': mov_id,
        })

    if errores:
        return False, errores

    LocalReplica.update_produccion_estado(
        produccion['id'],
        'completado',
        observaciones=f"Descargado por {usuario} el {fecha[:19]}",
    )
    return True, []


def cancelar_produccion(page, produccion, receta):
    """Revierte todas las entradas del lote y marca la producción como cancelada.

    Estrategia: registra una salida_produccion por cada entrada del lote para
    devolver el stock de los productos resultantes (etapa 1 había subido cada uno).
    Mantiene audit trail.
    """
    from usr.views.inventario.movements import registrar_movimiento
    from usr.database.base import get_session
    from usr.models import Movimiento
    from sqlalchemy import select

    detalles = load_detalle(produccion['id'])
    entradas = [d for d in detalles if d.get('tipo') == 'entrada']
    if not entradas:
        LocalReplica.update_produccion_estado(produccion['id'], 'cancelada')
        return True

    for entrada in entradas:
        prod = LocalReplica.get_producto_by_id(entrada['producto_id'])
        if not prod:
            continue

        cantidad = float(entrada.get('cantidad', 0))
        es_pesable = bool(prod.get('es_pesable'))
        unidad = entrada.get('unidad') or prod.get('unidad_medida', 'unidad')
        almacen = prod.get('almacen_predeterminado', 'principal') or 'principal'

        # La entrada original fue pesable (peso_total > 0)? Buscar el movimiento original
        # para conocer el peso.
        peso_total = 0.0
        if entrada.get('movimiento_id'):
            session = get_session()
            try:
                mov = session.execute(
                    select(Movimiento).where(Movimiento.id == entrada['movimiento_id'])
                ).scalar_one_or_none()
                if mov:
                    peso_total = float(getattr(mov, 'peso_total', 0) or 0) if es_pesable else 0.0
                    if mov.almacen:
                        almacen = mov.almacen
            except Exception:
                pass
            finally:
                session.close()

        registrar_movimiento(
            page,
            prod,
            'salida_produccion',
            cantidad,
            peso_total=peso_total,
            almacen=almacen,
            observaciones=f"Cancelación Producción #{produccion['id']} - {receta.get('nombre', '')}",
        )

    LocalReplica.update_produccion_estado(produccion['id'], 'cancelada')
    return True
