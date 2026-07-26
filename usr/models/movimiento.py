from sqlalchemy import Column, Integer, String, Float, Boolean, ForeignKey, DateTime, Text
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from usr.database.base import Base

class Movimiento(Base):
    __tablename__ = "movimientos"
    __table_args__ = {'extend_existing': True}

    id = Column(Integer, primary_key=True, index=True)

    producto_id = Column(Integer, ForeignKey("productos.id"), nullable=False)
    producto = relationship("Producto", back_populates="movimientos")

    factura_id = Column(Integer, ForeignKey("facturas.id"), nullable=True)
    factura = relationship("Factura", back_populates="movimientos")

    requisicion_id = Column(Integer, ForeignKey("requisiciones.id"), nullable=True,
                            comment="Requisición que originó el traslado (tr_salida/tr_entrada)")

    tipo = Column(String(10), nullable=False, comment="entrada, salida, ajuste, tr_salida, tr_entrada")

    cantidad = Column(Float, nullable=False)
    cantidad_anterior = Column(Float, default=0)
    cantidad_nueva = Column(Float, default=0)

    peso_total = Column(Float, default=0.0)

    registrado_por = Column(String(100), nullable=False)

    observaciones = Column(Text, nullable=True)

    almacen = Column(String(50), nullable=True)

    fecha_movimiento = Column(DateTime(timezone=True), server_default=func.now())

    created_at = Column(DateTime(timezone=True), server_default=func.now())

    def __repr__(self):
        return f"<Movimiento(id={self.id}, tipo='{self.tipo}', cantidad={self.cantidad})>"