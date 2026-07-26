from sqlalchemy import func
from sqlalchemy.orm import joinedload
from usr.database.base import get_db_adaptive
from usr.models import Producto, Movimiento, Categoria, Existencia, Factura

def load_categories():
    db = next(get_db_adaptive())
    try:
        return db.query(Categoria).filter(Categoria.activo == True).all()
    finally:
        db.close()

def load_warehouses():
    db = next(get_db_adaptive())
    try:
        return db.query(Existencia.almacen).distinct().all()
    finally:
        db.close()

def load_products(limit=50):
    db = next(get_db_adaptive())
    try:
        return db.query(Producto).options(joinedload(Producto.categoria)).filter(Producto.activo == True).order_by(Producto.nombre).limit(limit).all()
    finally:
        db.close()


def get_stock_stats(search="", categoria=None, almacen=None, stock_status="all"):
    db = next(get_db_adaptive())
    try:
        query = db.query(
            Producto.id,
            Producto.stock_minimo,
            func.coalesce(func.sum(Existencia.cantidad), 0).label('total_stock')
        ).outerjoin(
            Existencia, Existencia.producto_id == Producto.id
        ).filter(
            Producto.activo == True
        )
        if categoria and categoria.isdigit():
            query = query.filter(Producto.categoria_id == int(categoria))
        if search:
            query = query.filter(
                (Producto.nombre.ilike(f"%{search}%")) | (Producto.codigo.ilike(f"%{search}%"))
            )
        rows = query.group_by(Producto.id, Producto.stock_minimo).all()

        def _filter_almacen(r):
            if not almacen:
                return True
            return False  # TODO: implement warehouse-level stock check

        total = len(rows)
        sin_stock = 0
        bajo_stock = 0
        for r in rows:
            stock = r.total_stock or 0
            if stock <= 0:
                sin_stock += 1
            elif stock <= (r.stock_minimo or 0):
                bajo_stock += 1

        if stock_status == "low":
            total = bajo_stock
        elif stock_status == "out":
            total = sin_stock
            bajo_stock = 0

        return total, bajo_stock, sin_stock
    finally:
        db.close()

def get_existencias_map(producto_ids):
    if not producto_ids:
        return {}
    db = next(get_db_adaptive())
    existencias_map = {}
    try:
        existencias = db.query(Existencia.producto_id, Existencia.almacen, Existencia.cantidad).filter(Existencia.producto_id.in_(producto_ids)).all()
        for e in existencias:
            if e.producto_id not in existencias_map:
                existencias_map[e.producto_id] = {}
            existencias_map[e.producto_id][e.almacen] = e.cantidad
    finally:
        db.close()
    return existencias_map

def filter_products_db(search="", categoria=None, almacen=None, stock_status="all", limit=50):
    db = next(get_db_adaptive())
    try:
        query = db.query(Producto).options(joinedload(Producto.categoria)).filter(Producto.activo == True)
        if categoria and categoria.isdigit():
            query = query.filter(Producto.categoria_id == int(categoria))
        if search:
            query = query.filter((Producto.nombre.ilike(f"%{search}%")) | (Producto.codigo.ilike(f"%{search}%")))
        
        productos = query.order_by(Producto.nombre).all() if stock_status != "all" else query.order_by(Producto.nombre).limit(limit).all()
        producto_ids = [p.id for p in productos]
        existencias_map = get_existencias_map(producto_ids)
        
        # Filtrar por almacén si aplica (usa el stock real por almacén)
        if almacen:
            productos = [p for p in productos if (existencias_map.get(p.id, {}).get(almacen) or 0) > 0]
        
        # Filtrar por estado de stock usando el stock CALCULADO (suma de existencias),
        # que es exactamente lo que se muestra en la tarjeta.
        if stock_status != "all":
            def _stock_calc(p):
                return sum(existencias_map.get(p.id, {}).values()) or 0
            if stock_status == "low":
                productos = [p for p in productos if 0 < _stock_calc(p) <= (p.stock_minimo or 0)]
            elif stock_status == "out":
                productos = [p for p in productos if _stock_calc(p) <= 0]
        
        return productos, existencias_map
    finally:
        db.close()

def get_existencias_producto(producto_id):
    db = next(get_db_adaptive())
    try:
        existencias = db.query(Existencia).filter(
            Existencia.producto_id == producto_id
        ).order_by(Existencia.almacen).all()
        return existencias
    finally:
        db.close()

def get_producto_historial(producto_id, limit=100):
    db = next(get_db_adaptive())
    try:
        movimientos = db.query(Movimiento).options(joinedload(Movimiento.factura)).filter(Movimiento.producto_id == producto_id).order_by(Movimiento.fecha_movimiento.desc()).limit(limit).all()
        return movimientos
    finally:
        db.close()
