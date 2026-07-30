"""
Funciones de acceso a datos para el POS.

Comparte la BD con el sistema de inventario (productos, existencias, clientes).
"""
from usr.database.local_replica import LocalReplica
from usr.database.base import get_db_adaptive
from sqlalchemy.orm import joinedload
from usr.models import Producto


def get_productos_activos():
    """Obtiene todos los productos activos del inventario."""
    db = next(get_db_adaptive())
    try:
        return db.query(Producto).filter(Producto.activo == True).options(
            joinedload(Producto.categoria)
        ).order_by(Producto.nombre).all()
    finally:
        db.close()


def get_existencia_producto(producto_id: int, almacen: str = "restaurante"):
    """Obtiene la existencia actual de un producto en un almacén."""
    return LocalReplica.get_existencias_by_producto_almacen(producto_id, almacen)
