# Control de Entradas y Salidas — App Flutter

Sistema de gestión de inventario **Offline-First** con módulo POS, desarrollado en **Flutter** (web, Windows y Android). Reemplaza la versión anterior hecha con Flet/Python.

## Aplicaciones

| App | Entry point | Descripción |
|---|---|---|
| Inventario | `flutter_app/lib/main.dart` | Inventario, validación, stock, producciones, requisiciones, historial, WhatsApp, configuración |
| POS | `flutter_app/lib/main_pos.dart` | Mesas, habitaciones, comandas, ventas, turnos/cajas, tasa BCV, impresión ESC/POS |

Ambas apps se construyen para **web** (se sirven con `tool/server.py`) y como binarios **nativos** (Windows/Android) con actualización remota vía GitHub Releases.

## Despliegue web (desarrollo)

```bash
cd flutter_app

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

El servidor (`tool/server.py`) además expone `/proxy-bcv` para la tasa del BCV (con caché y *stale-while-revalidate*) y recibe los logs de Flutter web (`POST /log`).

> Los builds web requieren que `web/` (inventario) y `web_pos/` (POS) contengan `sqlite3.wasm` y `drift_worker.js` del motor SQLite de drift. Verificar que se copien al output tras cada build.

## Configuración

- URL y anon key de Supabase: `--dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...` (con fallback a constantes compiladas en `lib/core/config/app_config.dart`).
- Repo de releases para el updater: `--dart-define=UPDATE_REPO=reidchend/control-entradas-salidas`.

## Esquema de datos

- Local: SQLite vía drift (`flutter_app/lib/core/db/schema/`), migraciones por `schemaVersion`.
- Remoto: Supabase PostgreSQL — `supabase/schema.sql` (idempotente).

## Tests

```bash
cd flutter_app
flutter test
```

## Documentación

- `docs/PLAN_MIGRACION_FLUTTER.md` — plan completo de la migración Flet → Flutter y fases implementadas.
- `flutter_app/lib/` — código organizado por feature (core, features/inventario, features/pos, etc.).
- `flutter_app/AGENTS.md` (raíz) — convenciones de estructura modular del código.