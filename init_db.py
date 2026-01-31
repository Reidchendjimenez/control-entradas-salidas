"""
Script para inicializar la base de datos.
Por defecto solo crea las tablas (SIN datos de muestra).
Si quieres insertar los datos de ejemplo, ejecuta:
    python init_db.py --seed
"""
import os
import sys
import argparse

# Agregar el directorio raíz al path (para poder importar app.*)
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app.database.base import engine, Base, get_db
from app.models import Categoria, Producto  # ajustar si faltan modelos en tu proyecto


def create_schema():
    """Crear todas las tablas definidas en los modelos."""
    print("Creando tablas en la base de datos (si no existen)...")
    Base.metadata.create_all(bind=engine)
    print("✓ Tablas creadas/confirmadas")


def seed_sample_data():
    """Insertar datos de ejemplo (solo usar con --seed)."""
    print("Insertando datos de ejemplo...")
    db = next(get_db())
    try:
        # Evitar duplicados: insertar solo si no hay categorías
        if db.query(Categoria).first():
            print("La base de datos ya contiene datos, no se insertarán datos de ejemplo.")
            return

        categorias = [
            Categoria(nombre="Verduras", descripcion="Vegetales frescos y verdes", color="#4CAF50", activo=True),
            Categoria(nombre="Frutas", descripcion="Frutas frescas de temporada", color="#FF9800", activo=True),
            Categoria(nombre="Granos", descripcion="Arroz, frijoles y legumbres", color="#795548", activo=True),
            Categoria(nombre="Lácteos", descripcion="Leche, queso y derivados", color="#2196F3", activo=True),
            Categoria(nombre="Carnes", descripcion="Carnes frías y embutidos", color="#F44336", activo=True),
            Categoria(nombre="Abarrotes", descripcion="Productos enlatados y secos", color="#9C27B0", activo=True),
        ]
        db.add_all(categorias)
        db.commit()
        print(f"✓ {len(categorias)} categorías insertadas")

        # Productos de ejemplo (ajusta si tu modelo requiere campos distintos)
        productos = [
            Producto(nombre="Lechuga", codigo="VER-001", categoria_id=1, stock_actual=50, stock_minimo=10, unidad_medida="unidades", requiere_foto_peso=False),
            Producto(nombre="Tomate", codigo="VER-002", categoria_id=1, stock_actual=30, stock_minimo=15, unidad_medida="kg", requiere_foto_peso=True),
            Producto(nombre="Manzana", codigo="FRU-001", categoria_id=2, stock_actual=60, stock_minimo=20, unidad_medida="kg", requiere_foto_peso=False),
            # ... puedes ampliar la lista según necesites
        ]
        db.add_all(productos)
        db.commit()
        print(f"✓ {len(productos)} productos insertados")

    finally:
        db.close()


def init_database(seed: bool = False):
    """Inicializa la base de datos. Si seed==True inserta datos de ejemplo."""
    create_schema()
    if seed:
        seed_sample_data()
    else:
        print("No se insertaron datos de ejemplo. La base queda vacía (solo esquema).")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Inicializar la base de datos del proyecto.")
    parser.add_argument("--seed", action="store_true", help="Insertar datos de ejemplo después de crear las tablas.")
    args = parser.parse_args()

    init_database(seed=args.seed)
    print("Inicialización finalizada.")