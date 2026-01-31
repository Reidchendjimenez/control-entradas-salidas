# Control de Entradas y Salidas

Aplicacion de escritorio/web para gestion de inventario desarrollada con Flet y SQLAlchemy.

## Caracteristicas

- **Registro de Entradas**: Agregar productos al inventario por categoria
- **Validacion de Facturas**: Verificar y aprobar facturas de proveedores
- **Consulta de Stock**: Visualizar niveles de inventario en tiempo real
- **Configuracion**: Gestionar categorias, productos y base de datos

## Requisitos

- Python 3.11 o superior
- pip (gestor de paquetes de Python)
- Navegador web moderno (Chrome, Firefox, Edge)

## Instalacion

1. **Clonar o descargar el proyecto**

2. **Crear entorno virtual (recomendado)**
```bash
python -m venv venv
source venv/bin/activate  # En Linux/Mac
venv\Scripts\activate     # En Windows
```

3. **Instalar dependencias**
```bash
pip install -r requirements.txt
```

4. **Inicializar la base de datos**
```bash
python init_db.py
```

Esto creara:
- La base de datos SQLite (`control_entradas_salidas.db`)
- 6 categorias de ejemplo
- 20 productos de ejemplo

## Ejecucion

```bash
python main.py
```

La aplicacion se abrira automaticamente en tu navegador web en:
- `http://localhost:8501`

## Configuracion

Edita el archivo `.env` para personalizar:

```env
# Tipo de base de datos: sqlite o postgresql
DB_TYPE=sqlite

# SQLite (desarrollo)
SQLITE_PATH=./control_entradas_salidas.db

# PostgreSQL (produccion)
DB_HOST=localhost
DB_PORT=5432
DB_NAME=control_entradas_salidas
DB_USER=postgres
DB_PASSWORD=tu_contrasena

# Configuracion de Flet
FLET_WEB_PORT=8501
FLET_WEB_HOST=0.0.0.0
```

## Estructura del Proyecto

```
proyecto_control/
├── main.py                    # Punto de entrada
├── init_db.py                 # Script de inicializacion
├── requirements.txt           # Dependencias
├── .env                       # Configuracion (no incluir en git)
├── .env.example               # Plantilla de configuracion
├── app/
│   ├── __init__.py
│   ├── database/
│   │   ├── base.py            # Configuracion SQLAlchemy
│   │   └── __init__.py
│   ├── models/
│   │   ├── categoria.py       # Modelo Categoria
│   │   ├── producto.py        # Modelo Producto
│   │   ├── factura.py         # Modelo Factura
│   │   ├── movimiento.py      # Modelo Movimiento
│   │   └── __init__.py
│   ├── views/
│   │   ├── inventario_view.py # Vista de entradas
│   │   ├── validacion_view.py # Vista de facturas
│   │   ├── stock_view.py      # Vista de stock
│   │   ├── configuracion_view.py # Vista de configuracion
│   │   └── __init__.py
│   └── views.py
├── config/
│   ├── config.py              # Configuracion con Pydantic
│   └── __init__.py
├── uploads/
│   └── categorias/            # Imagenes de categorias
└── control_entradas_salidas.db # Base de datos SQLite
```

## Base de Datos

### Modelos

- **Categoria**: Clasificacion de productos (Verduras, Frutas, Granos, etc.)
- **Producto**: Articulos del inventario con stock y umbrales
- **Factura**: Documentos de proveedores para validar
- **Movimiento**: Historial de entradas y salidas

### Datos de Ejemplo

El script `init_db.py` crea automaticamente:
- 6 categorias
- 20 productos
- Stock inicial para cada producto

## Uso

### 1. Inventario (Entradas)
1. Selecciona una categoria
2. Elige un producto
3. Ingresa la cantidad
4. Guarda la entrada

### 2. Validacion de Facturas
1. Ve a la seccion "Validacion"
2. Busca facturas pendientes
3. Revisa los productos
4. Valida o anula la factura

### 3. Consulta de Stock
1. Ve a "Stock"
2. Filtra por categoria o busca
3. Revisa niveles y alertas

### 4. Configuracion
- Gestiona categorias (agregar/editar/eliminar)
- Gestiona productos
- Configura base de datos

## Produccion

Para usar PostgreSQL en produccion:

1. Instala PostgreSQL
2. Crea la base de datos
3. Actualiza `.env` con las credenciales
4. Ejecuta `python init_db.py` para crear las tablas

## Licencia

Libre uso.
