# Control de Entradas y Salidas

Sistema de gestion de inventario con modulo **POS**, desarrollado en **Flutter** (web, Windows y Android). Reemplaza la version anterior hecha con Flet/Python.

---

## Aplicaciones

| App | Entry point | Descripcion | Binarios nativos |
|---|---|---|---|
| **Inventario** | `lib/main.dart` | Inventario, stock, producciones, requisiciones, validacion de facturas, historial, WhatsApp, configuracion | Windows (`LycorisControl.exe`) + Android (APK) |
| **POS** | `lib/main_pos.dart` | Mesas, habitaciones, comandas, ventas, turnos/cajas, tasa BCV, impresion ESC/POS | Windows (`LycorisPOS.exe`) |

**Arquitectura**: 3 plataformas desde un solo codigo base — **web** (desarrollo/uso en navegador) y **nativos** (Windows/Android) con actualizacion remota via GitHub Releases.

---

## Funcionalidades

### Inventario (`lib/features/`)
- **Inventario**: categorias, productos (con stock), movimientos y lista de compra.
- **Stock / Toma de inventario**: conteo y checkpoint por periodos.
- **Producciones**: recetas, editor de recetas, pendientes e historial.
- **Requisiciones**: formulario, cards, visualizacion y auditoria.
- **Validacion de facturas**: validacion de entradas con OCR y registro de pagos.
- **Historial de facturas**: facturas y estados de pago.
- **Configuracion**: categorias, periodos, productos, proveedores y sistema.
- **WhatsApp**: bandeja de mensajes con cola y envio via bot.

### POS (`lib/features/pos/`)
- Login con PIN, mesas, habitaciones, comandas activas, ventas y cierre de turnos/cajas.
- Tasa del dia del **BCV** (proxy con *stale-while-revalidate*).
- Impresion de tickets **ESC/POS** (impresora termica).
- Configuracion: categorias, platos, mesas, habitaciones, impresora, tasa, usuarios.

---

## Stack tecnologico

| Necesidad | Paquete |
|---|---|
| Supabase (Postgres REST + Realtime) | `supabase_flutter ^2.8` |
| Estado | `flutter_riverpod ^2.5` |
| Cache local (stale-while-revalidate) | `shared_preferences ^2.2` |
| Almacenamiento seguro (credenciales/tokens) | `flutter_secure_storage ^9` |
| Exportacion Excel | `excel ^4` |
| HTTP | `http ^1.2` |
| Impresion termica (Windows) | `windows_printer ^0.2` |
| Version de la app (updater) | `package_info_plus ^9` |

Ver `pubspec.yaml` (version actual: **2.0.1**).

---

## Arquitectura

**Directo a Supabase**: toda consulta y escritura va directamente a Supabase via REST. No hay base de datos local ni capa de sincronizacion.

```
lib/
├── main.dart / main_pos.dart        # entry points (inventario / POS)
├── core/
│   ├── auth/                        # login, PIN, sesion
│   ├── config/                      # app_config.dart (URL/key Supabase, appId, repo releases)
│   ├── data/
│   │   ├── supabase_service.dart    # servicio CRUD generico
│   │   ├── supabase_providers.dart  # providers de Supabase, cache, realtime
│   │   ├── cache_service.dart       # cache local con SharedPreferences + TTL
│   │   └── realtime_service.dart    # suscripciones Realtime generico
│   ├── models/                      # modelos de dominio (Producto, Categoria, etc.)
│   ├── network/                     # cliente Supabase, HTTP
│   ├── theme/  state/  logging/
│   └── updater/                     # actualizacion remota Windows/Android
├── features/                        # inventario, stock, producciones, requisiciones,
│                                    # validacion, historial, configuracion, whatsapp, pos
│   └── <feature>/
│       ├── data/                    # repository + providers
│       └── presentation/            # screens, widgets, dialogs
└── widgets/
```

### Modelo de datos

- **Supabase** es la unica fuente de verdad (PostgreSQL).
- Los repos consultan Supabase directamente via `supabase_flutter`.
- **Modelos de dominio** en `lib/core/models/` desacoplan la UI de Supabase.
- Los repos convierten `Map<String, dynamic>` a modelos de dominio.

### Cache local (stale-while-revalidate)

Los catalogos (categorias, productos, proveedores, periodos, settings) se cachean localmente con **SharedPreferences**:

1. Primera carga: consulta Supabase → guarda en cache con timestamp.
2. Siguientes cargas: sirve desde cache si no expiro (TTL 5 min).
3. Si expiro: sirve cache stale → refresca en background.
4. Sin red: muestra datos cacheados (con "ultima actualizacion").
5. Al escribir (create/update/delete): invalida cache de esa tabla.

**Tablas con cache**: categorias, productos, proveedores, periodos, pos_settings.
**Tablas sin cache** (Realtime): existencias, movimientos, ventas, comandas, whatsapp_queue.

### Supabase Realtime

Suscripciones WebSocket en tiempo real para sync entre dispositivos:

| Tabla | Ubicacion | Efecto |
|-------|-----------|--------|
| `pos_sesiones` | AppShell centralizado | Invalida turno activo |
| `pos_comandas` | AppShell centralizado | Invalida comandas/mesas |
| `pos_venta_detalle` | AppShell centralizado | Invalida ventas |
| `categorias` | AppShell centralizado | Invalida config categorias |
| `productos` | AppShell centralizado | Invalida config productos |
| `proveedores` | AppShell centralizado | Invalida config proveedores |
| `facturas` | AppShell centralizado | Invalida historial facturas |
| `existencias` | StockScreen interno | Reload automatico |
| `movimientos` | StockScreen interno | Reload automatico |
| `whatsapp_queue` | BandejaScreen interno | Refresh automatico |

---

## Base de datos Supabase

### Tabla requerida: `dispositivo_usuario`

Ejecutar en Supabase SQL Editor el archivo:

```sql
supabase/migrations/20250101000000_add_dispositivo_usuario.sql
```

O copiar y pegar:

```sql
CREATE TABLE IF NOT EXISTS dispositivo_usuario (
  id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre        TEXT NOT NULL,
  pin_hash      TEXT NOT NULL,
  configurado_en TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE dispositivo_usuario ENABLE ROW LEVEL SECURITY;

CREATE POLICY "dispositivo_usuario_all" ON dispositivo_usuario
  FOR ALL USING (true) WITH CHECK (true);
```

### Otras tablas requeridas en Supabase

 Todas las tablas usadas por los repos deben existir en Supabase:

| Tabla | Usada por |
|-------|-----------|
| `categorias` | Inventario, Stock, Configuracion |
| `productos` | Inventario, Stock, Configuracion, Producciones |
| `existencias` | Stock, Configuracion |
| `movimientos` | Stock, Historial |
| `proveedores` | Configuracion, Validacion |
| `facturas` | Historial, Validacion |
| `periodos` | Configuracion |
| `requisiciones` | Requisiciones |
| `pos_settings` | Configuracion, POS |
| `dispositivo_usuario` | Auth (login PIN) |
| `pos_sesiones` | POS (turnos/cajas) |
| `pos_mesas` | POS |
| `pos_habitaciones` | POS |
| `pos_platos` | POS |
| `pos_usuarios` | POS |
| `pos_comandas` | POS |
| `pos_venta_detalle` | POS |
| `whatsapp_queue` | WhatsApp |

Ver `supabase/schema.sql` para el esquema completo (idempotente).

---

## Compilacion y despliegue

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

`tool/server.py` expone `/proxy-bcv` (tasa del BCV con cache y *stale-while-revalidate*) y recibe los logs de Flutter web (`POST /log`).

### Nativos (CI / GitHub Actions)

Flutter no puede compilar Windows desde Linux, asi que los binarios nativos se generan en **CI** con `.github/workflows/release.yml`:

| Job | Producto | Assets publicados en la release |
|---|---|---|
| `windows-pos` | `LycorisPOS.exe` (icono azul) | `app-pos-windows.zip` |
| `windows-inventario` | `LycorisControl.exe` (icono normal) | `app-inventario-windows.zip` |
| `android` | APK inventario (icono normal) | `app-inventario-android.apk` |
| `release` | Publica la release `vX.Y.Z` | — |

**Como generar una release**:
1. Push a `main`.
2. Agregar los secrets `SUPABASE_URL` y `SUPABASE_ANON_KEY` en *Settings → Secrets and variables → Actions*.
3. *Actions → "Build & Release nativa" → Run workflow* con la version deseada (ej. `2.0.1`).
4. Descargar los binarios desde la pagina de la release.

> El workflow tambien dispara con un tag `v*` pusheado.

---

## Configuracion (dart-define)

| Define | Default | Descripcion |
|---|---|---|
| `SUPABASE_URL` / `SUPABASE_ANON_KEY` | constantes compiladas | Credenciales de Supabase |
| `APP_ID` | `inventario` | `pos` o `inventario` — define icono, binario y asset del updater |
| `APP_LABEL` | segun `APP_ID` | Nombre mostrado en dialogos y titulos |
| `UPDATE_REPO` | `reidchend/control-entradas-salidas` | Repo de releases para el updater |

---

## Tests

```bash
flutter test
```

Tests actuales (29):
- Modelos de dominio: Producto, Categoria, Existencia, Movimiento, MensajeWhatsapp
- TemporalesRepository (in-memory)
- CacheService (SharedPreferences)
- POS: login, catalogo, comanda, ventas, tasa BCV, ticket ESC/POS
- Widget: AppShell boots

---

## Cambios recientes (migracion Drift → Supabase)

### Fase 0 — Modelos de dominio (12+ archivos)
`lib/core/models/` — modelos puros sin dependencia de Drift.

### Fase 1 — Servicio base Supabase
`supabase_service.dart` + `supabase_providers.dart`.

### Fase 2 — Repositorios migrados (10 features)
Configuracion, Inventario, Requisiciones, Validacion, Historial, Producciones, POS (repo + ventas), Stock, WhatsApp, Temporales.

### Fase 3 — Limpieza Drift
- Eliminado `lib/core/db/` completo (database_provider, schema, app_database).
- Eliminado `lib/core/sync/` completo (sync_engine, sync_service, sync_status, global_sync_bar).
- Eliminado dependencias: `drift`, `drift_flutter`, `sqlite3_flutter_libs`, `drift_dev`, `build_runner`, `go_router`, `connectivity_plus`.
- Tests huérfanos eliminados.
- Providers migrados a `Provider<Repo?>` (nullable para Supabase no configurado).
- Login screen con error handling (try/catch + mensajes amigables).

### Fase 4 — Supabase Realtime
- `realtime_service.dart` — servicio generico de suscripciones.
- `realtime_providers.dart` — bindings POS + admin centralizados.
- Suscripciones internas en StockScreen y BandejaScreen.

### Fase 5 — Cache local
- `cache_service.dart` — SharedPreferences + TTL + stale-while-revalidate.
- Integrado en `configuracion_repository.dart` (categorias, productos, proveedores, periodos, settings).
- Invalidacion automatica en writes.

### Fase 6 — Seguridad null
- Todos los repos aceptan `SupabaseService?` y retornan vacio si es null.
- Todos los providers retornan `Provider<Repo?>`.
- `supabase_guard.dart` — helper para UI.

---

## Documentacion

- `lib/` — codigo organizado por feature (core, features/...), siguiendo la estructura modular de `AGENTS.md`.
- `supabase/schema.sql` — esquema remoto (idempotente).
- `supabase/migrations/` — migraciones SQL.
