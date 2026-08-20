# Control de Entradas y Salidas

Sistema de gestión de inventario **Offline-First** con módulo **POS**, desarrollado en **Flutter** (web, Windows y Android). Reemplaza la versión anterior hecha con Flet/Python.

---

## Aplicaciones

| App | Entry point | Descripción | Binarios nativos |
|---|---|---|---|
| **Inventario** | `lib/main.dart` | Inventario, stock, producciones, requisiciones, validación de facturas, historial, WhatsApp, configuración | Windows (`LycorisControl.exe`) + Android (APK) |
| **POS** | `lib/main_pos.dart` | Mesas, habitaciones, comandas, ventas, turnos/cajas, tasa BCV, impresión ESC/POS | Windows (`LycorisPOS.exe`) |

**Arquitectura**: 3 plataformas desde un solo código base — **web** (desarrollo/uso en navegador) y **nativos** (Windows/Android) con actualización remota vía GitHub Releases.

---

## Funcionalidades

### Inventario (`lib/features/`)
- **Inventario**: categorías, productos (con stock), movimientos y lista de compra.
- **Stock / Toma de inventario**: conteo y checkpoint por periodos.
- **Producciones**: recetas, editor de recetas, pendientes e historial.
- **Requisiciones**: formulario, cards, visualización y auditoría.
- **Validación de facturas**: validación de entradas con OCR y registro de pagos.
- **Historial de facturas**: facturas y estados de pago.
- **Configuración**: categorías, periodos, productos, proveedores y sistema.
- **WhatsApp**: bandeja de mensajes con cola y envío vía bot.

### POS (`lib/features/pos/`)
- Login con PIN, mesas, habitaciones, comandas activas, ventas y cierre de turnos/cajas.
- Tasa del día del **BCV** (proxy con *stale-while-revalidate*).
- Impresión de tickets **ESC/POS** (impresora térmica).
- Configuración: categorías, platos, mesas, habitaciones, impresora, tasa, usuarios.

---

## Stack tecnológico

| Necesidad | Paquete |
|---|---|
| Supabase (auth + Postgres REST + realtime) | `supabase_flutter ^2.8` |
| SQLite local offline-first | `drift ^2.20` + `sqlite3_flutter_libs` |
| Estado | `flutter_riverpod ^2.5` |
| Navegación | `go_router ^14` |
| Almacenamiento seguro (credenciales/tokens) | `flutter_secure_storage ^9` |
| Exportación Excel | `excel ^4` |
| HTTP / conectividad | `http ^1.2` + `connectivity_plus ^6` |
| Versión de la app (updater) | `package_info_plus ^9` |

Ver `pubspec.yaml` (versión actual: **2.0.0**).

---

## Arquitectura

**Offline-First**: todo escribe a SQLite local (drift) y sincroniza con Supabase en segundo plano. Los cambios de otros dispositivos llegan en tiempo real vía WebSocket.

```
lib/
├── main.dart / main_pos.dart        # entry points (inventario / POS)
├── core/
│   ├── auth/                        # login, PIN, sesión
│   ├── config/                      # app_config.dart (URL/key Supabase, appId, repo releases)
│   ├── db/schema/                   # esquema drift + migraciones
│   ├── network/                     # cliente Supabase, HTTP, conectividad
│   ├── sync/                        # motor de sincronización bidireccional + barra global
│   │   └── realtime/                # interfaz abstracta RealtimeSource + implementación Supabase
│   ├── theme/  state/  logging/  router/
│   └── updater/                     # actualización remota Windows/Android
├── features/                        # inventario, stock, producciones, requisiciones,
│                                    # validacion, historial, configuracion, whatsapp, pos
└── widgets/
```

**Datos**:
- **Local**: SQLite vía drift (`lib/core/db/schema/`), migraciones por `schemaVersion`.
- **Remoto**: Supabase PostgreSQL — `supabase/schema.sql` (idempotente).

**Sync** (capa `lib/core/sync/`):
1. Cola local `sync_queue` (outbox) con inserts/updates/deletes pendientes.
2. Descarga masiva de las 15 tablas sincronizadas (dedupe por clave natural).
3. Aplicación de DDL idempotente remota.
4. Background: timer cada ~20 s; barra de progreso del sync en la UI.
5. Tablas POS (`pos_*`) se replican localmente y se envían a Supabase por separado.
6. **Realtime** (WebSocket): suscripciones a Supabase Realtime para visibilidad inmediata entre dispositivos. Cuando el teléfono 1 crea una requisición, el teléfono 2 la ve sin esperar el timer.

**Realtime** (capa `lib/core/sync/realtime/`):
- Interfaz abstracta `RealtimeSource` — permite cambiar el proveedor sin tocar la lógica de sync.
- Implementación concreta: `SupabaseRealtimeSource` (WebSocket nativo de Supabase).
- Para migrar a otro backend (servidor propio, Firebase, etc.): implementar `RealtimeSource` y cambiar `realtimeSourceProvider`.

---

## Compilación y despliegue

### Web (desarrollo)

```bash
# Inventario (puerto 8501)
flutter build web --release -o build/web
python3 tool/server.py 8501 build/web

# POS (puerto 8502)
flutter build web --release -t lib/main_pos.dart -o build/pos
cp web_pos/favicon.png web_pos/manifest.json build/pos/
cp -r web_pos/icons build/pos/
cp web_pos/index.html build/pos/index.html
python3 tool/server.py 8502 build/pos
```

`tool/server.py` además expone `/proxy-bcv` (tasa del BCV con caché y *stale-while-revalidate*) y recibe los logs de Flutter web (`POST /log`).

> **Importante**: los builds web requieren `sqlite3.wasm` y `drift_worker.js` del motor SQLite de drift en el output (`web/` para inventario, `web_pos/` para POS). Copiarlos al build si no se generan automáticamente.

### Nativos (CI / GitHub Actions)

Flutter no puede compilar Windows desde Linux, así que los binarios nativos se generan en **CI** con `.github/workflows/release.yml`:

| Job | Producto | Assets publicados en la release |
|---|---|---|
| `windows-pos` | `LycorisPOS.exe` (icono azul) | `app-pos-windows.zip` |
| `windows-inventario` | `LycorisControl.exe` (icono normal) | `app-inventario-windows.zip` |
| `android` | APK inventario (icono normal) | `app-inventario-android.apk` |
| `release` | Publica la release `vX.Y.Z` | — |

**Cómo generar una release**:
1. Push a `main`.
2. Agregar los secrets `SUPABASE_URL` y `SUPABASE_ANON_KEY` en *Settings → Secrets and variables → Actions* (sin ellos se usan los fallback compilados).
3. *Actions → "Build & Release nativa" → Run workflow* con la versión deseada (ej. `2.0.0`).
4. Descargar los binarios desde la página de la release; las apps nativas detectan la actualización al arrancar.

> El workflow también dispara con un tag `v*` pusheado.

---

## Configuración (dart-define)

| Define | Default | Descripción |
|---|---|---|
| `SUPABASE_URL` / `SUPABASE_ANON_KEY` | constantes compiladas | Credenciales de Supabase |
| `APP_ID` | `inventario` | `pos` o `inventario` — define icono, binario y asset del updater |
| `APP_LABEL` | según `APP_ID` | Nombre mostrado en diálogos y títulos |
| `UPDATE_REPO` | `reidchend/control-entradas-salidas` | Repo de releases para el updater |

---

## Tests

```bash
flutter test
```

---

## Documentación

- `docs/PLAN_MIGRACION_FLUTTER.md` — plan completo de la migración Flet → Flutter y fases implementadas.
- `lib/` — código organizado por feature (core, features/…), siguiendo la estructura modular de `AGENTS.md`.
- `supabase/schema.sql` — esquema remoto (idempotente).