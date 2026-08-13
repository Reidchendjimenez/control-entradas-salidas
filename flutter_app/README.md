# Control de Entradas y Salidas — App Flutter

Migración de la app Flet (Python) a Flutter. Ver `docs/PLAN_MIGRACION_FLUTTER.md`
para el plan completo y `supabase/schema.sql` para el esquema PostgreSQL.

## Estado actual del esqueleto (Fase 0)

- [x] `pubspec.yaml` con dependencias base (supabase_flutter, drift, riverpod, go_router)
- [x] `lib/core/theme/` — portado de `usr/theme.py` (paleta oscura/clara)
- [x] `lib/core/state/theme_controller.dart` — toggle de tema (equivalente a `app_controller._toggle_theme`)
- [x] `lib/core/router/app_shell.dart` — MaterialApp.router + ProviderScope bootstrap
- [x] `lib/core/db/schema/app_database.dart` — drift (SQLite) con categorias/productos/movimientos
- [x] `supabase/schema.sql` — esquema PostgreSQL definitivo (idempotente)

## Pendientes (Fase 1 y siguientes)

1. Configurar `supabase_flutter` con credenciales del `.env` (ver config/config.py).
2. Motor de sincronización (portar `usr/database/sync.py`): outbox + descarga masiva + DDL idempotente.
3. Login + resto de features (inventario->stock->requisiciones->producciones->validacion->facturas->config->whatsapp->POS).
4. POS + impresión ESC/POS, updater, OCR.

## Instrucciones

```bash
# Con Flutter SDK instalado, dentro de flutter_app/:
flutter create --project-name control_entradas_salidas --platforms=android,ios,windows,linux .
flutter pub get
flutter analyze
```

> Nota: `supabase_flutter.dart_placeholder.dart` es un stub para que compile sin
> red; reemplazar por `Supabase.initialize(...)` en la Fase 1.