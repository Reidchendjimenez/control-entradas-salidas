# 📦 Control de Entradas y Salidas - Guía Técnica

Sistema de gestión de inventario **Offline-First** desarrollado con Flet y SQLAlchemy, diseñado para operar en entornos con conexión intermitente y actualizarse dinámicamente sin recompilar el ejecutable.

---

## 🚀 Arquitectura del Sistema

### 1. Smart Launcher & Dynamic Updates
El sistema no carga el código directamente desde el ejecutable, sino que utiliza un mecanismo de **Inyección de Rutas**:
- **Lanzador**: El `.exe` actúa como un contenedor de entorno (Python + Librerías).
- **Carga Dinámica**: Al iniciar, `main.py` verifica la versión en un `version.json` remoto.
- **app_updates/**: Si hay una actualización, descarga un `update.zip`, lo extrae en `app_updates/` e inserta esta carpeta al inicio de `sys.path`.
- **Prioridad**: El código en `app_updates/usr/` tiene prioridad sobre el código empaquetado en el `.exe`.

### 2. Motor de Sincronización (Offline-First)
El sistema utiliza una arquitectura de **Réplica Local**:
- **LocalReplica**: Una base de datos SQLite local que imita el esquema de Supabase.
- **SyncQueue**: Cuando el usuario realiza un cambio offline, la operación se guarda en `pending_operations`.
- **Bidireccionalidad**: 
  - **Subida**: Procesa la cola de pendientes $\rightarrow$ Supabase.
  - **Descarga**: Descarga cambios remotos $\rightarrow$ SQLite $\rightarrow$ Poda de registros huérfanos.

### 3. Flujo de Requisiciones (Audit Workflow)
El módulo de requisiciones implementa un proceso de control de calidad:
- **Pendiente**: Registro inicial de solicitud.
- **Auditoría**: Vista de verificación donde se compara el stock físico vs sistema. Permite realizar **Ajustes de Stock** inmediatos. Incluye botón de **Historial** (🕐) por producto que muestra el detalle de movimientos en cards.
- **Totalización**: Trasladar físicamente el stock (Origen $\rightarrow$ Destino) y marca la requisición como `completada`.

### 4. Módulo de Producciones (Recetas en 2 etapas)
El módulo de producciones permite fabricar productos a partir de ingredientes, separando la entrada del producto final del descargo de ingredientes para soportar **ingredientes de peso variable** (ej.: jamón entero por pieza, donde el peso real solo se conoce al cortar).
- **Receta** (`recetas` + `receta_componentes`):
  - Dos tipos: **Simple** (salida de producto base + entradas de RESULTADO) y **Compuesta** (salidas de INGREDIENTE + entrada de producto final).
  - Cada componente tiene flag `peso_variable`: si está activo, la cantidad se ignora y se ingresa al momento de la descarga.
- **Etapa 1 — Registro de producción (desde Inventario)**:
  - Al hacer una **entrada** de un producto que aparece como `producto_final` de alguna receta, el diálogo ofrece un toggle "Registrar como producción" + dropdown de receta.
  - Al confirmarlo: se registra un movimiento tipo `entrada_produccion` (sube stock), se crea una `produccion` con `estado='pendiente'` y se guarda un `produccion_detalle` tipo `entrada` enlazado al movimiento.
  - **No aparece en la lista de validación** (el filtro `tipo == 'entrada'` la excluye automáticamente).
- **Etapa 2 — Descargo (desde Producciones → En Producción)**:
  - Lista producciones con `estado='pendiente'`.
  - Botón "Descargar" abre diálogo con los ingredientes: los de `peso_variable` muestran campo vacío (autofocus), los fijos aparecen prellenados como sugerencia (editables). Soporta pesables (kg).
  - Al confirmar: registra `salida_produccion` por cada ingrediente (descuenta stock), guarda detalles tipo `salida` y marca la producción como `completado`.
- **Cancelar**: revierte el stock del producto final (registra `salida_produccion` opuesta) y marca la producción como `cancelada`. Mantiene audit trail.
- **Tipos de movimiento nuevos**:
  - `entrada_produccion` (sube stock, como `entrada`).
  - `salida_produccion` (baja stock, como `salida`).
  - Excluidos de la lista de validación automáticamente.
- **Sync**: producciones, `produccion_detalles` y `peso_variable` se sincronizan bidireccionalmente; los movimientos de producción se suben por el mecanismo genérico de `_upload_pending_movimientos`.

### 5. Sistema de Periodos y Archivado
El sistema incluye un mecanismo de **apertura de periodos mensuales** para mantener la base de datos liviana:
- **Apertura**: Un dispositivo apertura el periodo desde Configuración → Periodos. Esto archiva movimientos >3 meses (`movimientos` $\rightarrow$ `movimientos_archivo`) tanto localmente como en Supabase.
- **Checkpoint**: Al archivar, se guarda el stock actual como punto de partida (`stock_checkpoint`). Los demás dispositivos descargan este checkpoint vía sync y no necesitan escanear `movimientos_archivo`.
- **Cálculo optimizado**: `recalculate_existencias()` usa el delta `cantidad_nueva - cantidad_anterior` (corrige productos pesables) y solo escanea `movimientos` si hay checkpoint; si no, escanea `movimientos` + `movimientos_archivo`.
- **Sincronización**: La tabla `periodos` se sincroniza entre dispositivos. La tabla `movimientos_archivo` **no se descarga** a los dispositivos — se consulta directamente en Supabase solo cuando se necesita.

### 6. Módulo POS (Point of Sale) — Independiente
El sistema incluye un **módulo de ventas** que se compila y ejecuta como aplicación **independiente** del sistema principal:
- **Entry point separado**: `main_pos.py` se compila como `Lycoris POS.exe` (mientras `main.py` sigue siendo `Lycoris Control.exe`).
- **BD compartida**: Ambos módulos leen de la **misma BD SQLite** (`lycoris_local.db`), por lo que el POS ve productos, existencias y precios del inventario automáticamente.
- **Login propio**: Tiene su propio sistema de **cajeros** (múltiples por dispositivo, con PIN opcional) registrado en `pos_usuarios` y `pos_sesiones`.
- **Sync separado del inventario**: El POS tiene su propio `POSSyncManager` (`usr/database/pos_sync.py`) que solo sincroniza las 8 tablas POS (`platos_categorias`, `platos`, `plato_ingredientes`, `plato_contornos`, `pos_mesas`, `pos_habitaciones`, `pos_usuarios`, `pos_settings`). El `SyncManager` principal ignora estas tablas.
- **Impresora térmica**: Soporta auto-detección USB/serial/Windows (`win32print`), imprime comandas con membrete configurable (nombre, RIF, dirección, teléfono), correlativo auto-incremental, precio por plato, y pie de página personalizado con imagen QR de pago móvil (todo renderizado como raster ESC/POS).
- **Configuración persistente**: Membrete, correlativo, pie de página y ruta QR se guardan en `pos_settings` y se sincronizan con Supabase para compartir entre dispositivos.

**Compilación**:
```bash
pyinstaller --onefile --windowed --name "Lycoris POS" --icon "assets/icono.ico" --add-data "assets:assets" main_pos.py
```

> En Windows usa `;` en `--add-data`: `--add-data "assets;assets"`.

**Cómo compilar ambos .exe** (ejemplo con PyInstaller):
```bash
pyinstaller --onefile --windowed --name "Lycoris Control" --icon "assets/icono.ico" --add-data "assets:assets" main.py
pyinstaller --onefile --windowed --name "Lycoris POS"    --icon "assets/icono.ico" --add-data "assets:assets" main_pos.py
```

---

## 📂 Mapa del Proyecto

```text
control-entradas-salidas/
├── main.py                        # Entry point: sistema de inventario (redirige a app_updates/)
├── main_pos.py                    # Entry point: módulo POS (compilable como .exe independiente)
├── usr/
│   ├── app_controller.py          # Controlador principal, navegación entre vistas
│   ├── app_launcher.py            # Arranque: login, sync inicial, carga de vistas
│   ├── notifications.py           # Sistema centralizado de snackbars/banners
│   ├── theme.py                   # Paleta de colores (light/dark)
│   ├── logger.py                  # Logger configurado
│   ├── error_handler.py           # Manejo global de errores
│   ├── updater.py                 # Verificación y descarga de updates
│   ├── init_db.py                 # Shim → usr/init_db.py (migración Supabase)
│   ├── ocr_extractor.py           # Extracción de datos de facturas con Gemini API
│   ├── whatsapp_notifier.py       # Envío de mensajes WhatsApp (incluye format_validation_message)
│   │
│   ├── pos/                       # Módulo POS (Point of Sale) — independiente
│   │   ├── launcher.py            # Launcher del POS (app_updates override, sync POS, icono)
│   │   ├── data.py                # Acceso a productos y stock del inventario
│   │   ├── printer.py             # Impresión ESC/POS: membrete, correlativo, prices, QR raster
│   │   ├── comanda_view.py        # Vista de comandas (productos, cantidades, notas)
│   │   └── views/
│   │       ├── login.py           # Selección de cajero (con PIN opcional)
│   │       ├── home.py            # Vista principal del POS (logueado)
│   │       ├── comandas.py        # Gestión de comandas abiertas
│   │       ├── config.py          # Config: usuarios, mesas, habitaciones, platos, impresora
│   │       ├── mesas.py           # Vista de mesas (asignar comandas)
│   │       ├── habitaciones.py    # Vista de habitaciones
│   │       └── platos.py          # Vista de platos
│   │
│   ├── database/
│   │   ├── conn.py                # Conexiones SQLite (local) y cache
│   │   ├── base.py                # Engine SQLAlchemy, is_online(), get_db_adaptive()
│   │   ├── local_replica.py        # Esquema SQLite, CREATE TABLE, recalculate_existencias()
│   │   ├── sync.py                 # Sincronización bidireccional (solo inventario), migraciones
│   │   ├── pos_sync.py             # Sync exclusivo para tablas POS (8 tablas, POSSyncManager)
│   │   ├── sync_queue.py           # Cola de operaciones pendientes (offline)
│   │   ├── sync_callbacks.py       # Callbacks de sync
│   │   ├── archive.py              # Archivado de movimientos (local + Supabase) + checkpoint
│   │   └── cache.py                # Caché local (SQLite)
│   │
│   ├── models/                    # Modelos SQLAlchemy (esquema de datos)
│   │   ├── producto.py             # Producto: es_pesable, tipo, peso_unitario
│   │   ├── categoria.py           # Categoría
│   │   ├── proveedor.py           # Proveedor
│   │   ├── factura.py             # Factura
│   │   ├── factura_pago.py        # Pago de factura
│   │   ├── movimiento.py          # Movimiento (entradas/salidas/ajustes/traslados)
│   │   ├── movimiento_archivo.py  # Movimiento archivado
│   │   ├── existencia.py           # Existencia por producto + almacén
│   │   ├── requisicion.py          # Requisición y Detalle (incluye verificado, order_by id)
│   │   ├── compra_lista.py        # Item de lista de compras
│   │   ├── receta.py               # Receta y componentes (peso_variable)
│   │   └── produccion.py           # Producción y detalles (estado: pendiente/completado/cancelada)
│   │
│   └── views/                     # UI (Flet)
│       ├── configuracion/
│       │   ├── categorias.py      # Tab: CRUD categorías
│       │   ├── productos.py       # Tab: CRUD productos
│       │   ├── proveedores.py     # Tab: CRUD proveedores
│       │   ├── sistema.py          # Tab: conexión, modo offline, operador
│       │   ├── periodos.py         # Tab: apertura de periodos, reintento nube, recalcular
│       │   ├── dialogs.py          # Diálogos compartidos
│       │   └── helpers.py          # Colores y utilidades UI
│       ├── configuracion_view.py  # Contenedor de tabs (Categorías, Productos, etc.)
│       ├── inventario/
│       │   ├── categories.py      # Grid de categorías
│       │   ├── products.py        # Lista de productos
│       │   ├── movements.py       # registrar_movimiento() + ajustar_existencia()
│       │   ├── shopping_list.py   # Lista de compras
│       │   ├── dialogs.py          # Diálogos de cantidad y corrección
│       │   └── helpers.py
│       ├── inventario_view.py     # Vista principal de inventario
│       ├── stock/
│       │   ├── data.py            # get_producto_historial()
│       │   ├── components.py      # Componentes de UI
│       │   ├── dialogs.py          # build_movimiento_card(), build_producto_historial_dialog()
│       │   └── helpers.py
│       ├── stock_view.py         # Vista de stock y existencias
│       ├── validacion/
│       │   ├── ocr_handler.py     # OCR con Gemini, manejo de portapapeles
│       │   ├── fields.py           # Campos de factura
│       │   ├── service.py          # Validación, vinculación factura-movimientos (marca sincronizado=0)
│       │   ├── payments.py         # Gestión de pagos
│       │   └── dialog.py           # Diálogo de validación
│       ├── validacion_view.py     # Vista de validación de facturas (botón Sincronizar refresca)
│       ├── requisiciones/
│       │   ├── data.py            # Lógica de negocio (CRUD + Audit + Historial, ORDER BY id)
│       │   ├── audit_view.py      # Verificación, totalización e historial por producto
│       │   ├── visualize_view.py # Vista de solo lectura
│       │   ├── form.py             # Creación/edición de requisiciones (usa model.order_by id)
│       │   ├── cards.py            # Cards de requisiciones
│       │   ├── components.py       # Componentes reutilizables
│       │   ├── service.py          # Validación de requisiciones
│       │   ├── dialogs.py           # Diálogos
│       │   └── helpers.py
│       ├── requisiciones_view.py  # Vista principal de requisiciones
│       ├── producciones/          # Módulo Producciones (modular, estilo requisiciones)
│       │   ├── view.py           # Orquestador (ProduccionesView + tabs + carga)
│       │   ├── data.py           # Capa de negocio (load_recetas, load_pendientes,
│       │   │                       #  registrar_produccion_pendiente, planificar_descargo,
│       │   │                       #  ejecutar_descargo, cancelar_produccion)
│       │   ├── dialogs.py        # Diálogos (receta_dialog, descargo_dialog, cancelar)
│       │   ├── helpers.py        # Colores, fmt_fecha, now_iso, usuario_actual
│       │   ├── recetas_view.py   # Tab Recetas (cards + FAB)
│       │   ├── pendientes_view.py # Tab En Producción (lista pendientes + Descargar/Cancelar)
│       │   └── historial_view.py # Tab Historial (estado: pendiente/completado/cancelada)
│       ├── producciones_view.py  # Shim re-exporta ProduccionesView desde producciones/
│       ├── historial_facturas_view.py # Historial de facturas
│       ├── login_view.py          # Login y registro de operador (muestra Bienvenido, {nombre})
│       └── whatsapp_bandeja_view.py # Bandeja de mensajes WhatsApp
│
├── config/
│   └── config.py                  # Configuración con Pydantic (DATABASE_URL, etc.)
└── app_updates/                  # Parches descargados (prioridad sobre el .exe)
    └── usr/                       # Código actualizado
```

---

## 🛠️ Guía de Depuración y Mantenimiento

### Problemas Comunes y Soluciones

#### 1. El código actualizado no se refleja en el App
- **Causa**: Windows mantiene caché de bytecode (`.pyc`) en carpetas `__pycache__` que puede tener prioridad sobre los archivos `.py` actualizados.
- **Solución**: Borrar manualmente todas las carpetas `__pycache__` en el directorio de instalación.

#### 2. Fallo en Notificaciones tras Actualización
- **Causa**: Al limpiar `sys.modules` para cargar la nueva versión, se pierde la referencia a la página de Flet (`_page`) en el módulo de notificaciones.
- **Solución**: Se implementó un **Stack Walker** en `usr/notifications.py` que busca la instancia de `ft.Page` recorriendo la pila de llamadas si la referencia directa es `None`.

#### 3. Pantalla gris (overlay) al cerrar un diálogo modal (AlertDialog)
- **Causa**: En Flet, al cerrar un diálogo con `dialog.open = False` y luego llamar `page.overlay.remove(dialog)`, el overlay translúcido del modal puede quedar "fantasma" porque Flet ya lo considera cerrado pero el backdrop persiste.
- **Solución**: **No** remover el diálogo del overlay manualmente. Solo establecer `dialog.open = False` y luego `page.update()`. Flet se encarga internamente del backdrop. Ejemplo:
  ```python
  def _close_dialog(self):
      if self.active_dialog:
          self.active_dialog.open = False
          self.active_dialog = None
          if self.page:
              self.page.update()
  ```
  Si hay múltiples diálogos abiertos, iterar `page.overlay[:]` y cerrarlos todos sin removerlos.

#### 3. Bases de Datos Duplicadas
- **Causa**: Uso de rutas relativas que crean una DB en la raíz y otra en `app_updates/`.
- **Solución**: Siempre utilizar rutas absolutas obtenidas mediante `os.path.abspath` en `usr/database/conn.py`.

---

## 📈 Flujo de Trabajo para Desarrolladores

### Para agregar una nueva funcionalidad:
1. **Modelo**: Definir la tabla en `usr/models/` y agregar el `CREATE TABLE` en `usr/database/local_replica.py`.
2. **Data Layer**: Crear funciones de acceso a datos en `usr/views/[modulo]/data.py`.
3. **UI**: Implementar la vista en `usr/views/` usando componentes reutilizables.
4. **Sync**: Si la tabla debe sincronizarse, agregarla a `tables_to_sync` en `usr/database/sync.py`.

### Para publicar un parche (Hotfix):
1. Subir los cambios a la rama `main` de GitHub.
2. El GitHub Action generará el `update.zip` automáticamente.
3. Actualizar el número de versión en `version.json`.
4. El cliente descargará el parche al reiniciar.

---

## 📦 Compilación del Ejecutable

Si se agregan nuevas dependencias en `requirements.txt`, se debe recompilar:

---

## Guía de Buenas Prácticas y Errores a Evitar

### ❌ Errores Comunes (Ya Corregidos)

#### 1. Variables `snack` sin definir
**Síntoma**: `NameError: name 'snack' is not defined` al mostrar advertencias en requisiciones.
**Causa**: Llamar a `self.page.overlay.append(snack)` y `snack.open = True` después de `show_warning()`/`show_success()`, sin haber creado la variable `snack`.
**Regla**: Las funciones `show_warning()`, `show_success()` y `show_error()` de `usr.notifications` ya muestran su propio `SnackBar`. **No agregues líneas adicionales** de overlay después de llamarlas.

#### 2. Código de depuración en producción
**Síntoma**: Textos como `"PRUEBA DE LISTA"` o `"PRUEBA DE DATOS"` visibles en la UI.
**Regla**: Nunca dejes textos de debug, variables de prueba o asserts en el código de producción. Usa `logger.debug()` para trazas temporales.

#### 3. Métodos duplicados en una misma clase
**Síntoma**: El segundo `_on_file_save` sobrescribe al primero, causando comportamiento inesperado.
**Regla**: En Python, el último método definido con el mismo nombre es el que prevalece. Usa `grep` o `rg` para verificar que no haya duplicados al refactorizar.

#### 4. Bloques de código duplicados
**Síntoma**: El método `_buscar_productos_buscador()` ejecutaba la misma query y renderizado **dos veces**, sobrescribiendo los resultados.
**Regla**: Aplica el principio DRY (Don't Repeat Yourself). Si ves más de ~10 líneas repetidas, extráelas a un método auxiliar o elimina el duplicado.

#### 5. Archivos muertos que importan símbolos inexistentes
**Síntoma**: `usr/database/session.py` importaba `engine` de `base.py`, pero `engine` no existe como variable global en ese módulo.
**Regla**: Antes de eliminar o renombrar un símbolo exportado, verifica con `grep -r "from .*import.*engine"` que ningún otro archivo lo importe. Los archivos que no se importan desde ningún lado deben eliminarse.

#### 6. Hilos modificando la UI de Flet
**Síntoma**: Llamar a `self.page.update()` desde hilos secundarios (`threading.Thread`).
**Regla**: Flet **no es thread-safe**. Para actualizar la UI desde un hilo, usa `self.page.run_task()` con una corutina async o `self.page.add()` desde el hilo principal únicamente.

---

### ✅ Buenas Prácticas Recomendadas

#### Base de Datos
- **No mezcles** `sqlite3` directo con SQLAlchemy ORM. Usa **uno solo** para evitar inconsistencias de datos.
- Cada escritura de movimiento actualiza el stock vía `update_existencia()` (O(1)). El `recalculate_existencias()` **solo se llama** en sincronización (no en cada movimiento manual).
- `recalculate_existencias()` usa `cantidad_nueva - cantidad_anterior` como delta para soportar productos pesables correctos.
- Limpia `page.overlay` selectivamente, no con `.clear()` que borra overlays de otras vistas.

#### Sincronización
- **Solo existe una cola activa**: `sync_queue`. La tabla `pending_operations` fue eliminada porque nunca se procesaba.
- Al eliminar un movimiento via SQLAlchemy, también elimínalo del SQLite local raw si usas ambos sistemas.
- `LocalReplica.save_movimiento()` ya no tiene lógica de sync propia. Delega al llamante (`registrar_movimiento` o `save_movimiento_with_sync`).
- **Tablas que sincroniza el SyncManager (inventario)**: `categorias`, `productos`, `proveedores`, `existencias`, `movimientos`, `facturas`, `factura_pagos`, `requisiciones`, `requisicion_detalles`, `stock_checkpoint`, `periodos`, `recetas`, `receta_componentes`, `producciones`, `produccion_detalles`. Movimientos tipo `entrada_produccion` y `salida_produccion` se suben por el mecanismo genérico.
- **Tablas que sincroniza el POSSyncManager (POS)**: `platos_categorias`, `platos`, `plato_ingredientes`, `plato_contornos`, `pos_mesas`, `pos_habitaciones`, `pos_usuarios`, `pos_settings`. El `SyncManager` principal ignora estas tablas.
- **`movimientos_archivo` NO se descarga** a los dispositivos. Se consulta directamente en Supabase cuando se necesita historial.
- **Migraciones remotas**: Al descargar, `_download_all_from_server()` ejecuta `ALTER TABLE`/`CREATE TABLE` en Supabase para asegurar que las tablas tengan las columnas necesarias (ej: `requisicion_id` en `movimientos_archivo`, tabla `stock_checkpoint`, tabla `periodos`).

#### Archivado y Periodos
- **Un solo dispositivo** apertura el periodo. Esto ejecuta `archivar_movimientos()` que:
  1. En Supabase: guarda checkpoint + archiva movimientos viejos (`movimientos` → `movimientos_archivo`)
  2. En local: guarda checkpoint + archiva localmente
- Si Supabase no está disponible, el archivo procede solo localmente (con warning en consola).
- Los demás dispositivos al sincronizar: descargan `stock_checkpoint` y `periodos`, y `recalculate_existencias()` usa el checkpoint (solo escanea `movimientos`).
- Si los datos se desincronizan, desde Configuración → Periodos se puede **"Recalcular stock desde cero"** (limpia checkpoints y hace escaneo completo).

#### Estructura
- Evita alias redundantes (ej: 4 alias para `get_session()`).
- Unifica los sistemas de notificaciones a un solo módulo.
- Documenta en el `__init__.py` del package qué se exporta realmente.
- No dupliques la lógica de sync en múltiples capas (causa inconsistencias).

---

## Historial de Cambios

### Version 2.6.0 (Agosto 2026)
- ✨ **Módulo de Producciones en 2 etapas**: Flujo completo para fabricar productos con ingredientes de peso variable. Etapa 1 (entrada del producto final) se registra desde Inventario con tipo `entrada_produccion` y queda como `produccion` con `estado='pendiente'`. Etapa 2 (descargo de ingredientes) se hace desde el nuevo tab "En Producción" con tipo `salida_produccion` y marca la producción como `completado`. Las entradas de producción NO aparecen en la lista de validación (filtro `tipo == 'entrada'`).
- ✨ **Ingredientes de peso variable**: Nueva columna `receta_componentes.peso_variable` (local + Supabase + modelo SQLAlchemy). En el editor de recetas, un checkbox por ingrediente deshabilita la cantidad cuando se marca; al descargar, los ingredientes variables piden peso real (autofocus) y los fijos aparecen como sugerencia editable.
- ✨ **Soporte para cancelar producciones pendientes**: registra un movimiento opuesto para revertir el stock del producto final y marca la producción como `cancelada`, conservando el audit trail.
- ✨ **Tipos de movimiento nuevos**: `entrada_produccion` y `salida_produccion` (labels "Ent. Producción" / "Sal. Producción" en cards de historial). Soportan pesables (kg) y se sincronizan por el mecanismo genérico.
- ✨ **Sync bidireccional de recetas y producciones**: `producciones` y `produccion_detalles` agregadas a `tables_to_sync`, con migraciones remotas (`CREATE TABLE IF NOT EXISTS`) y branches de push/pull. `peso_variable` incluido en la subida/descarga. Las operaciones creadas desde la UI (`save_receta`, `save_componentes`, `delete_receta`, `save_produccion`, `save_produccion_detalle`) ahora encolan en `sync_queue` para subir offline-first.
- 🐛 **Corregido**: `save_recetas` / `save_receta_componentes` / `save_producciones` / `save_produccion_detalles` (bulk) hacían `UPDATE` por id sin verificar existencia, fallando en dispositivos nuevos donde la fila no existía. Ahora son upsert real (`SELECT` → UPDATE o `INSERT` con id explícito).
- ⚡ **Modularización de la vista Producciones** (estilo `requisiciones/`): `usr/views/producciones_view.py` pasó de 849 líneas a un orquestador de ~145 líneas + 7 módulos especializados (`view.py`, `data.py`, `dialogs.py`, `helpers.py`, `recetas_view.py`, `pendientes_view.py`, `historial_view.py`). Import externo (`from usr.views import ProduccionesView`) preservado sin cambios.
- ⚡ **Fix Flet thread safety**: handlers que llaman corrutinas reemplazaron `asyncio.create_task()` por `page.run_task()` (corrige `RuntimeError: no running event loop` en `_on_tab_change` de Producciones).
- 🔧 **Validación al cambiar tipo de receta**: advertencia al pasar de Simple ↔ Compuesta porque se vacía la lista de componentes.

### Version 2.5.0 (Julio 2026)
- ✨ **Sync bidireccional de ventas y comandas POS**: `pos_comandas` y `pos_ventas` ahora se sincronizan con Supabase vía `POSSyncManager`. Cada comanda/venta tiene un `sync_uuid` estable (UUID hex) que permite enlazar entre dispositivos sin depender de IDs numéricos locales (`comanda_sync_uuid`, `venta_anula_sync_uuid` en ventas).
- ✨ **`movimientos.venta_sync_uuid` + fix de `venta_id`**: Los movimientos de venta/devolución se suben con su `venta_sync_uuid` (nuevo campo remoto `movimientos.venta_sync_uuid`). Tras cada descarga de movimientos se ejecuta `relink_ventas_movimientos()` que restaura el `venta_id` local, que antes se perdía en el clear+reinsert.
- ✨ **Tombstones de ventas**: Al eliminar una venta no impresa (`eliminar_venta_y_movimientos`) se registra el `sync_uuid` en `pos_sync_tombstones` y se encola el `DELETE` remoto, evitando que la descarga la resucite.
- ✨ **Tasa de cambio oficial BCV**: `tasa_cambio.py` usa `https://bcv.today/api/v1/rate.json` (valor publicado por el BCV). Se descartó Yadio porque devuelve la tasa paralela (836 vs 746 Bs/$ el 31/07/2026). Botón "Actualizar tasa" en la vista de comanda.
- ✨ **Total en Bs en ticket e historial**: La venta congela la tasa (`pos_ventas.tasa_bs`) y el ticket muestra `Tasa: 746,6297 Bs/$` y `TOTAL Bs:`; el historial de ventas muestra el equivalente en Bs bajo el total USD.
- 🐛 **Alineación del ticket a 32 columnas**: Nombre del plato a la izquierda y precio a la derecha con relleno de espacios (sin código de alineación ESC/POS por línea de item); el nombre se trunca si no cabe.
- ⚡ **`POSSyncManager` ampliado**: ahora maneja 10 tablas (`+ pos_comandas`, `pos_ventas`) y sube los movimientos de venta pendientes (`sincronizado=0`, tipo `venta`/`devolucion`) con dedup por `venta_sync_uuid`; `SyncManager` principal ignora estas tablas nuevas.
- ⚡ **Migraciones remotas**: `pos_comandas`, `pos_ventas` (con `sync_uuid`, `comanda_sync_uuid`, `venta_anula_sync_uuid`, `tasa_bs`) e índices en Supabase; `movimientos.venta_sync_uuid` con `ADD COLUMN IF NOT EXISTS`.

### Version 2.4.0 (Julio 2026)
- ✨ **Sync separado POS/Inventario**: Nuevo `POSSyncManager` en `usr/database/pos_sync.py`. Las 8 tablas POS se sincronizan con su propio gestor, el `SyncManager` principal las ignora.
- ✨ **Impresora con membrete y correlativo**: Ticket ESC/POS ahora incluye nombre empresa, RIF, dirección, teléfono (configurable desde pestaña Impresora), número de comanda auto-incremental y precio por plato.
- ✨ **Pie de página + QR en ticket**: Texto configurable (C.I, teléfono, banco) e imagen QR de pago móvil renderizados lado a lado como una sola imagen raster ESC/POS (GS v 0) usando PIL.
- ✨ **Sincronización de pos_settings**: Los settings de impresora (membrete, correlativo, pie, QR) se sincronizan con Supabase para compartir entre dispositivos POS.
- ✨ **Detección de impresoras Windows**: Nuevo `_find_windows_printers()` usando `win32print.OpenPrinter`/`WritePrinter` para detectar colas de impresión del sistema.
- 🔧 **Icono de ventana POS**: `page.assets_allow_override = True` y `page.window.icon` para el ejecutable.
- 📦 **Dependencia**: `pywin32` agregado a `requirements.txt` con marcador `sys_platform == "win32"`.

### Version 2.3.0 (Julio 2026)
- ✨ **Módulo POS (Point of Sale)**: Nuevo entry point `main_pos.py` compilable como `.exe` independiente. Comparte BD local con el inventario pero NO requiere login/sync/updates. Launcher simplificado en `usr/pos/launcher.py`.
- ✨ **Login del POS**: Sistema de cajeros con PIN opcional (`usr/pos/views/login.py`). Tabla `pos_usuarios` y `pos_sesiones` en SQLite local. Barra superior con avatar + botón de cerrar sesión.
- ⚡ **Optimizado**: `_upload_pending_movimientos()` ahora resuelve `factura_id` solo si el movimiento tiene factura asociada, y `requisicion_id` solo para traslados (`tr_salida`/`tr_entrada`). Reduce llamadas a la red innecesarias.
- 🐛 **Corregido**: Form de edición de requisición ahora respeta el orden de productos (mismo `ORDER BY id`) que el audit y visualize, agregando `order_by` en el modelo `Requisicion.detalles` y en `get_requisicion_audit_data`.
- 🐛 **Corregido**: Validación ahora marca movimientos como `sincronizado=0` para que `_upload_pending_movimientos` suba el `factura_id` a Supabase. Antes el UPDATE "remoto" era a la BD local (redundante) y el fallback no se ejecutaba.
- 🔧 **Mejorado**: Mensaje de WhatsApp en validación usa la fecha de la entrada (no la fecha de validación), obtenida como la fecha mínima de los movimientos seleccionados.

### Version 2.2.0 (Julio 2026)
- ✨ **Sistema de Periodos**: Apertura de periodos mensuales desde Configuración → Periodos. Archiva movimientos >3 meses en BD local y Supabase.
- ✨ **Stock Checkpoint**: Punto de partida para cálculo de existencias. `recalculate_existencias()` usa checkpoint si existe (solo escanea `movimientos`), si no, escanea `movimientos` + `movimientos_archivo` (UNION ALL).
- ✨ **Historial de movimientos**: Botón 🕐 en Audit View y Stock View que muestra cards de movimientos por producto y almacén.
- 🐛 **Corregido**: `recalculate_existencias()` ahora usa `cantidad_nueva - cantidad_anterior` como delta (corrige bug con productos pesables donde `cantidad` almacenaba unidades pero `cantidad_nueva` se calculaba en kg).
- 🐛 **Corregido**: `tr_salida` en requisiciones almacena `-det.cantidad` (antes `+det.cantidad` causaba stock inflado en origen).
- 🐛 **Corregido**: Dedup SQL en `save_movimiento` usaba `datetime(?) - 5` inválido, ahora `datetime(?, '-5 seconds')` + filtro por `almacen`.
- 🐛 **Corregido**: `service.py` validación hace UPDATE directo en Supabase para `factura_id` en vez de reset `sincronizado=0` (evita duplicados).
- ⚡ **Optimizado**: Eliminado `recalculate_existencias()` de `registrar_movimiento()` (redundante con `update_existencia()`, O(1)). Solo se llama en sincronización.
- ⚡ **Optimizado**: `movimientos_archivo` ya no se descarga a cada dispositivo. Se consulta directo en Supabase cuando se necesita.
- ⚡ **Optimizado**: Migración de documentos históricos (2 EV-*, 68 V-REF-* + 342 sin-prefijo) a `tipo_documento='Entrada'`.
- 🔧 **Mejorado**: Botones "Reintentar archivo en nube" y "Recalcular stock desde cero" en tab de Periodos.
- 🔧 **Mejorado**: Dialog de progreso visual durante apertura de periodo (ProgressBar con mensaje).
- 🗑️ **Eliminado**: Tabla `kardex_validaciones` en Supabase.
- 🗑️ **Eliminado**: Columnas huérfanas (`peso_registrado`, `foto_peso_url`, `ingrediente`, `origen`, `destino`, `usuario`) de `movimientos` en Supabase.

### Version 2.1.1 (Mayo 2026)
- 🐛 **Corregido**: `NameError: snack is not defined` en 6 ubicaciones de `requisiciones_view.py`
- 🗑️ **Eliminado**: `usr/database/session.py` (archivo muerto que causaba `ImportError`)
- 🧹 **Eliminado**: Código debug "PRUEBA DE LISTA" y "PRUEBA DE DATOS" en requisiciones
- 🔁 **Eliminado**: Bloque duplicado (~50 líneas) en `_buscar_productos_buscador()`
- 🔁 **Eliminado**: Método duplicado `_on_file_save` en `historial_facturas_view.py`
- 🔄 **Corregido**: `registrar_movimiento()` ahora llama a `recalculate_existencias()` después de cada escritura
- 🔄 **Corregido**: Sync Manager reutilizado en `registrar_movimiento()` (ya no crea engine PostgreSQL en cada movimiento)
- 🔄 **Eliminado**: Sync duplicado en `LocalReplica.save_movimiento()` (delegado al llamante)
- 🗑️ **Eliminada**: Tabla `pending_operations` + sus 4 métodos (código muerto - nunca se procesaba)
- 📝 **Añadido**: Guía de buenas prácticas y errores a evitar

### Version 1.2.50 (julio 2026)
- ✨ **OCR con Gemini API**: Extraccion automatica de datos de facturas desde imagenes del portapapeles
- ✨ **Lista de Compras**: Gestion de productos pendientes por ingresar
- 🔧 Correcciones de UI en lista de compras (empty state, actualizacion de stock)
- 🔧 Silenciado de mensajes de debug de asyncio en consola
- 🔧 Modularizacion de inventario_view.py (separacion en helpers, categories, products, dialogs, movements, shopping_list)
