# Plan de Migración: Flet (Python) → Flutter (Dart)

**Proyecto:** Control de Entradas y Salidas + Módulo POS (usuario real, multi-dispositivo, sincronización con Supabase).
**Objetivo:** Reemplazar por completo la app Flet (`flet==0.86.5`) por una app Flutter nativa que conserve TODAS las funcionalidades actuales, elimine los errores de render del framework Flet y mejore la estabilidad en Android/desktop.

> Este documento es la especificación de referencia para que un agente implemente la migración paso a paso. Cada módulo indica: qué hacer, de qué módulos Python migrar (fuente), y qué dependencias Flutter usar.

---

## 0. Inventario de lo que existe hoy (auditoría)

### Backend / datos
- **BD local:** SQLite (`./control_entradas_salidas.db`, vía `SQLALCHEMY` con `SQLITE_PATH`) en los clientes.
- **BD remota:** PostgreSQL en **Supabase** (pooler `aws-1-us-east-2.pooler.supabase.com:6543`, usuario `postgres.<ref>`), cableada en `.env`.
  - Vars: `DB_TYPE`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `SECRET_KEY`, `DEBUG`.
- **ORM:** SQLAlchemy 2.x, modelos en `usr/models/` (14 modelos + POS local).
- **Sincronización:** `usr/database/sync.py` (bidireccional, cola `sync_queue`, descarga masiva de 15 tablas, `full_sync`, background cada 20 seg), `usr/database/pos_sync.py` y `usr/database/local_replica.py` (réplicas POS locales).
- **Migraciones remotas de esquema:** DDL idempotente que se aplica vía `information_schema` en cada sync (ver `_download_all_from_server`).

### Tablas sincronizadas (sync.py `tables_to_sync`)
`categorias`, `productos`, `proveedores`, `existencias`, `movimientos`, `facturas`, `factura_pagos`, `requisiciones`, `requisicion_detalles`, `stock_checkpoint`, `periodos`, `recetas`, `receta_componentes`, `producciones`, `produccion_detalles`.

### Tablas POS locales (local_replica.py)
`pos_usuarios`, `pos_mesas`, `pos_habitaciones`, `pos_sesiones`, `pos_comandas`, `pos_settings`, `pos_ventas`, `pos_categorias`, `pos_sync_tombstones` (+ envío a Supabase vía `pos_sync.py`).

### Módulos de negocio (carpeta `usr/`)
| Módulo | Archivos | Funcionalidad |
|---|---|---|
| Login | `views/login_view.py`, `app_launcher.py:251 after_login` | Autenticación, compañía (Darwin/Lycoris) |
| Splash | `views/splash.py` | Pantalla de carga |
| Inventario | `views/inventario_view.py`, `views/inventario/*` | Categorías, productos, movimientos, lista de compra |
| Stock | `views/stock_view.py`, `views/stock/*` | Toma de inventario / conteo |
| Requisiciones | `views/requisiciones_view.py`, `views/requisiciones/*` | Formulario, cards, visualizar, auditoría |
| Producciones | `views/producciones/*` | Recetas, editor, pendientes, historial |
| Validación | `views/validacion/*` | Validar entradas de facturas con **OCR** (`ocr_extractor.py`) y pagos |
| Historial facturas | `views/historial_facturas_view.py` | Facturas y estados de pago |
| Configuración | `views/configuracion/*` | Categorías, periodos, productos, proveedores, sistema |
| WhatsApp | `views/whatsapp_bandeja_view.py`, `whatsapp_notifier.py` | Cola de mensajes, envío vía bot `WHATSAPP_BOT_URL` + `WHATSAPP_BOT_TOKEN` |
| OCR | `ocr_extractor.py` | OCRSpace + EasyOCR + preprocesado, parser de factura |
| Updater | `updater.py` | Check `UPDATE_URL`, version.json, descarga zip |
| POS | `main_pos.py`, `usr/pos/*` | Login con PIN, mesas, habitaciones, comandas, ventas, tasas, impresión térmica |

### Librerías externas críticas a portar
- `pyserial`, `pyusb`, `pywin32` → **impresión ESC/POS** (`pos/printer.py`).
- `Pillow`, `openpyxl` → imágenes y exportación Excel.
- `requests` → bot WhatsApp y OCRSpace.
- `SQLAlchemy` + `pg8000` → conexión Supabase (reemplazable por REST de Supabase).

---

## 1. Arquitectura objetivo (Flutter)

```
control-entradas-salidas-flutter/
├── lib/
│   ├── main.dart                 # entrada, MaterialApp, tema
│   ├── core/
│   │   ├── theme/                # colores (portar usr/theme.py)
│   │   ├── network/              # SupabaseClient, HTTP wrapper, conectividad
│   │   ├── db/                   # drift (SQLite local), migraciones
│   │   ├── sync/                 # motor de sincronización bidireccional
│   │   ├── auth/                 # login, PIN, sesión
│   │   ├── update/               # updater (UPDATE_URL, zip, version.json)
│   │   └── pdf_excel/            # exportación
│   ├── features/
│   │   ├── inventario/
│   │   ├── stock/
│   │   ├── requisiciones/
│   │   ├── producciones/
│   │   ├── validacion/          # + OCR
│   │   ├── facturas/
│   │   ├── configuracion/
│   │   └── whatsapp/
│   ├── pos/                     # módulo POS completo
│   │   ├── login, mesas, habitaciones, comandas, ventas, config
│   │   ├── printing/            # ESC/POS (esc_pos_printer)
│   │   └── data/
│   └── widgets/                 # footer, drawer, appbar reutilizables
├── android/  ios/  windows/  linux/   # proyectos de plataforma
├── supabase/                     # SQL de esquema (migraciones)
└── pubspec.yaml
```

### Stack de dependencias Flutter
| Necesidad | Paquete |
|---|---|
| Supabase (auth + Postgres + storage + realtime) | `supabase_flutter` |
| SQLite local offline-first | `drift` (+ `sqlite3_flutter_libs`) |
| Estado | `flutter_riverpod` (o `provider`) |
| Navegación | `go_router` |
| Impresión térmica ESC/POS | `esc_pos_printer` o `esc_pos_utils` + `usb_serial` (`usb_serial` / `serial_port_win32`) |
| OCR | `mlkit_ocr` (Android/iOS) + fallback a OCRSpace REST (como hoy) |
| Excel export | `excel` / `syncfusion_flutter_xlsio` |
| QR/escaneo (si se usa) | `qr_code_scanner` |
| HTTP | `http` / `dio` |
| Almacenamiento seguro de credenciales | `flutter_secure_storage` |
| Conectividad | `connectivity_plus` |
| Actualizaciones | `ota_update` / `updater` / descarga zip a mano |
| Notificaciones | `flutter_local_notifications` + `whatsapp_unilink` (deep link a WhatsApp) |

---

## 2. Capa de datos

### 2.1 Esquema
- Mantener los **mismos nombres de tablas y columnas** que hoy (compatibilidad con Supabase). Los nombres se listan en las tablas `__tablename__` de `usr/models/*.py`.
- Modelos fuente a portar: `categoria.py`, `compra_lista.py`, `existencia.py`, `factura.py`, `factura_pago.py`, `movimiento.py`, `movimiento_archivo.py`, `produccion.py`, `producto.py`, `proveedor.py`, `receta.py`, `requisicion.py` (con sus `detalles` y `receta_componentes`).
- POS local: replicar `local_replica.py` (tablas `pos_*`).

### 2.2 Cliente Supabase
- Configurar con las mismas credenciales del `.env` (URL `https://<ref>.supabase.co`, key `anon`). Ver `config/db_config.py` y `config/config.py`.
- **Decisión clave:** sincronizar vía **REST de Supabase** (tables API) en lugar de `pg8000`. Ventaja: sin drivers de Postgres nativos en móvil. Se mantiene la misma semántica (upsert por `id`, dedupe por código/nombre).

### 2.3 Repositorios
- Cada feature tendrá un repositorio (`ProductosRepo`, `MovimientosRepo`, `RequisicionesRepo`, …) que lee de drift y sincroniza con Supabase, clonando la lógica de `sync.py`.

---

## 3. Motor de sincronización

Portar `usr/database/sync.py` y `usr/database/pos_sync.py` manteniendo la lógica exacta:

1. **Cola local** `sync_queue` (tabla drift `outbox`): inserts/updates/deletes pendientes con operación y timestamp.
   - Regla importante del flet (sync.py:666): los `movimientos` con operación `!= delete` **no** se suben (se regeneran por checkpoint). Replicar.
   - Tablas POS (`pos_*`) se **excluyen** de la cola general (sync.py:668).
2. **Descarga masiva** de las 15 tablas sincronizadas (mismo orden y dedupe por clave natural como hoy, p.ej. `categorias.nombre`, `productos.codigo`, `facturas.numero_factura`, `requisiciones.numero`).
3. **Aplicación de DDL idempotente** remota: consultar `information_schema` y aplicar `ALTER/CREATE IF NOT EXISTS` ignorando lo ya aplicado (portar bloque 436-585 de sync.py).
4. **Background**: timer cada 20 s (equivalente a `start_background_sync`).
5. **Estados en UI**: barra de progreso del sync (portar `app_controller._on_sync_progress`).
6. `local_replica.py`: replicar tombstones y réplica local POS.

---

## 4. Módulos feature por feature

> Cada feature = carpeta en `lib/features/<feature>/`. Regla general: datos en `data/`, UI en `presentation/`, lógica de dominio en `domain/`.

### 4.1 Login (portar `app_launcher.py`, `login_view.py`)
- Pantalla de login con compaía (selección Darwin/Lycoris si aplica).
- Guardar sesión (token Supabase / PIN) en `flutter_secure_storage`.
- Flujo `after_login` → arrancar shell principal.

### 4.2 Inventario (portar `views/inventario/*`)
- Productos (CRUD, campo `codigo`, `precio_venta`), categorías, movimientos (entrada/salida con cantidad_anterior/nueva), lista de compra (`compra_lista`).
- Pantallas: lista, detalle, formulario, diálogos (portar `dialogs.py`).

### 4.3 Stock / Toma de inventario (`views/stock/*`)
- Conteo por producto/almacén → `stock_checkpoint`.
- Pantalla de captura + lista de existencias.

### 4.4 Requisiciones (`views/requisiciones/*`)
- **Mucha lógica de UI**: cards, formulario maestro-detalle, visualizar (pdf/print si aplica), **auditoría** (`audit_view`).
- Flujo de surtido con `cantidad_surtida`, `verificado`, estados (`pendiente`, otros en `requisiciones.py`).
- Portar `data.py`, `service.py`, `form.py`, `cards.py`, `visualize_view.py`.

### 4.5 Producciones (`views/producciones/*`)
- Recetas (`recetas` + `receta_componentes`, tipos de componente, `peso_variable`), editor de recetas, pendientes, historial, producción con `produccion_detalles` y generación de `movimientos`.
- Portar `receta_editor.py`, `recetas_view.py`, `pendientes_view.py`, `historial_view.py`, `data.py`.

### 4.6 Validación de facturas + OCR (`views/validacion/*`, `ocr_extractor.py`)
- Carga de imagen de factura → preprocesado → **OCRSpace** (API key configurable) o **ML Kit** local → `parse_factura_text` (parser del texto a datos).
- Crear/confirmar proveedor (`check_proveedor_exists`), registrar movimientos de entrada (validación), **pagos** (`payments.py`).
- Portar `ocr_handler.py`, `fields.py`, `service.py`.

### 4.7 Historial de facturas (`historial_facturas_view.py`)
- Lista `facturas` + `factura_pagos`, estados de pago, filtros por período (`periodos`).

### 4.8 Configuración (`views/configuracion/*`)
- Categorías, períodos, productos (maestro), proveedores, sistema (ajustes de la app, `dialogs`/`helpers`).

### 4.9 WhatsApp (`whatsapp_bandeja_view.py`, `whatsapp_notifier.py`)
- Tabla/cola `whatsapp_queue` local (función `save_to_queue`).
- Envío a bot HTTP `WHATSAPP_BOT_URL` + header/bearer `WHATSAPP_BOT_TOKEN` (texto `send_whatsapp_message`, imagen `send_whatsapp_image`, a jid `send_whatsapp_to`).
- Reintentos en background (`_start_retry_thread`), estados, grupos disponibles, formato de mensaje de validación (`format_validation_message`).
- UI de bandeja con pendientes, reenvíos, borrar (`delete_from_queue`).

### 4.10 Updater (`updater.py`)
- Leer `UPDATE_URL` del `.env`/secure storage (inyectar siempre, crítico en Android).
- `version.json` local con `version` y `zip_url`; comparar con remoto; si hay nueva versión → diálogo de confirmación → descargar zip → aplicar → reiniciar. Portar toda la lógica de `comprobar_y_aplicar_actualizaciones`.

---

## 5. Módulo POS (portar `usr/pos/*` + `main_pos.py`)

- **Login por PIN** (`views/login.py`): tarjetas de usuarios, PIN dialog (`_verify_pin_and_login`), alta de usuario, seed admin.
- **Mesas** (`views/mesas.py`), **Habitaciones** (`views/habitaciones.py`): estado, ocupación, apertura de comanda.
- **Comandas** (`views/comandas.py`, `comanda_view.py`): línea de venta con items, totales.
- **Ventas** (`views/ventas.py`): caja en tiempo real por usuario, cierres, corte.
- **Config** (`views/config.py`): ajustes POS (encabezado comanda, correlativo, tasas).
- **Tasa de cambio** (`tasa_cambio.py`).
- **Home** (`views/home.py`) + `data.py` (gestión de datos en memoria/estado).

### Impresión térmica (`pos/printer.py`) — crítico
Conservar 1:1:
- Detección de impresoras USB (vid/pid), serie y Windows (`_find_usb_printers`, `_find_serial_printers`, `_find_windows_printers`, `_find_printer_device_auto`).
- `_escpos_ticket(lines, total, comanda_id, ...)` → generación de bytes ESC/POS del ticket (ancho, encabezado, correlativo).
- `imprimir_comanda(items, total, comanda_id)`.
- Configuración de dispositivo persistido (`_get_configured_device` ⊂ settings), encabezado y correlativo.

En Flutter:
- Android: `usb_serial` (USB OTG) o `esc_pos_printer` (bluetooth/UDP).
- Windows/Linux: `serial_port_win32` / `dart:ffi` para COM; buscar VID/PID como hoy.
- Mantener el **mismo contenido de ticket** (replica del byte-stuffing con `esc_pos_utils`).

---

## 6. Integraciones externas

| Integración | Hoy | En Flutter |
|---|---|---|
| Supabase Postgres | `SQLAlchemy`+`pg8000` | REST `supabase_flutter` |
| Bot WhatsApp | HTTP + token | HTTP `dio` (mismo endpoint) |
| OCRSpace | `requests` REST | HTTP `dio` (misma API) |
| EasyOCR local | Python | **ML Kit** (`mlkit_ocr`) o eliminar (mantener OCRSpace) |
| Impresión | `pyserial`/`pyusb`/`pywin32` | `esc_pos_printer`/`usb_serial`/`serial_port_win32` |
| Export Excel | `openpyxl` | `syncfusion_flutter_xlsio` |

---

## 7. Plan de implementación por fases (para el agente)

> Cada fase debe dejar la app compilable y testeable. Orden sugerido para reducir riesgo.

**Fase 0 — Scaffolding** *(✅ HECHO — `flutter_app/`)*
1. `flutter create` con plataformas android/ios/windows/linux (según objetivo: Android primero).
2. `pubspec.yaml` con las dependencias del §1.
3. Carpeta `supabase/`: SQL de esquema (producto de los `__tablename__` y del DDL de sync). ✅ `supabase/schema.sql` generado e idempotente.
4. `core/theme` portado de `usr/theme.py`; `MaterialApp` + `go_router` + Riverpod bootstrap. ✅ `lib/core/theme/app_colors.dart`, `app_theme.dart`, `app_shell.dart`, `main.dart`.
   - ✅ Drift inicial: `lib/core/db/schema/app_database.dart` (categorias/productos/movimientos).
   - Pendiente: ejecutar `flutter create .` + `flutter pub get` en un entorno con SDK (el esqueleto se creó a mano aquí).

**Fase 1 — Capa de datos + Supabase (sin UI)** *(✅ HECHO — `flutter_app/lib/core`)*
5. Definir modelos drift (esquema local) y clientes Supabase.
   - ✅ `lib/core/db/schema/app_database.dart` — 19 tablas drift (15 sincronizadas + movimientos_archivo, compras_lista, sync_queue, sync_metadata).
   - ✅ `lib/core/config/app_config.dart` — URL Supabase derivada del ref, anon key vía `--dart-define=SUPABASE_ANON_KEY`.
   - ✅ `lib/core/network/supabase_client.dart` — inicialización `supabase_flutter` (REST) con `publishableKey`.
   - ✅ `lib/core/db/database_provider.dart` — provider singleton de drift.
6. Repositorios de las 15 tablas sincronizadas (CRUD + upsert).
   - ✅ `lib/core/sync/sync_tables.dart` — descriptor de tablas con clave natural de dedupe.
   - ✅ `lib/core/sync/sync_engine.dart` — upsert tipado por tabla (descarga masiva) + outbox + subida de movimientos con resolución de FK.
   - ✅ `lib/core/sync/sync_service.dart` — `addPending()` (outbox) + provider del motor.
7. Motor de sync `outbox` + descarga masiva + DDL idempotente + timer 20 s.
   - ✅ Flujo `fullSync`: outbox → movimientos pendientes (con reglas especiales: no-eliminado no se sube, `pos_*` excluida) → descarga de 15 tablas → `last_sync_full`.
   - ⏳ El DDL idempotente remoto se aplica una sola vez vía `supabase/schema.sql` (en REST no se ejecuta DDL por request).
   - ⏳ Timer 20 s: `startBackgroundSync()` implementado; falta conectarlo a un widget de vida larga en la UI.
8. Prueba: sincronizar contra Supabase real y verificar recuento de filas por tabla contra la app Flet.
   - ✅ Tests unitarios de drift/outbox (3 pasando).
   - ⏳ Falta probar sync real: requiere `flutter run --dart-define=SUPABASE_ANON_KEY=...`.

**Fase 2 — Login + shell + Inventario**
9. Login + splash + shell (drawer/appbar), portar `app_controller`.
10. Inventario: productos/movimientos/categorías/lista compra completo.

**Fase 3 — Requisiciones + Stock**
11. Módulo requisiciones completo (form, cards, visualizar, auditoría).
12. Módulo stock (checkpoint).

**Fase 4 — Producciones + Validación + OCR**
13. Producciones (recetas, editor, pendientes, historial).
14. Validación con OCR (OCRSpace + ML Kit fallback) + pagos.

**Fase 5 — Facturas + Configuración + WhatsApp**
15. Historial facturas, períodos.
16. Configuración completa.
17. WhatsApp notifier + bandeja.

**Fase 6 — POS**
18. POS: login PIN, mesas, habitaciones, comandas, ventas, config, tasas.
19. Impresión térmica multipantalla (USB/serie/Bluetooth).

**Fase 7 — Updater + pulido**
20. Updater (version.json, zip, aplicar, reiniciar).
21. Estados de sync en UI, responsive, off-line-first, logs/errores.
22. Test E2E en dispositivo Android real contra la BD de producción (modo lectura) antes del corte.

---

## 8. Criterios de aceptación (no romper funcionalidad)

- [ ] Las 15 tablas sincronizadas quedan idénticas tras las 3 descargas consecutivas (sin duplicados, dedupe por clave natural).
- [ ] El outbox cumple las reglas especiales: movimientos no-eliminados no se suben; `pos_*` excluidas.
- [ ] Requisición: crear → surtir → verificar → auditar funciona sin pérdida de datos.
- [ ] Producción: registrar producción genera `movimientos` de insumo/producto correctamente.
- [ ] Validación OCR: leer factura → proveedor → movimientos entrada; pagos registrados.
- [ ] POS: apertura de comanda → ticket impreso con encabezado/correlativo → venta reflejada en caja y en Supabase (vía `pos_sync`).
- [ ] WhatsApp: mensajes salen de la cola con reintentos y son visibles en la bandeja.
- [ ] Updater: detecta versión remota, descarga e instala el zip.
- [ ] La app funciona offline (drift) y se sincroniza al recuperar conectividad.

---

## 9. Riesgos y decisiones abiertas

1. **OCR:** EasyOCR (Python) no existe en Flutter → usar ML Kit local + OCRSpace remoto como fallback. Confirmar si OCRSpace key está en producción.
2. **Impresión Windows/Linux:** `pywin32` y `pyusb` no existen en Dart; se usará FFI + `esc_pos_printer`. El 90% de riesgo está aquí: probar pronto con la impresora real.
3. **Sincronización:** el REST de Supabase es más lento que pg8000 para la descarga masiva; mitigar con `offset/limit` y batching. Mantener la cola local como fuente de verdad.
4. **Updater en Android:** el reinicio tras aplicar el zip requiere selector de versión del APK (`ota_update`). Evaluar limitar updater a desktop.
5. **No cambiar los nombres de tablas/columnas** de Supabase: el backend ya es el productivo y otras instancias dependen del esquema.