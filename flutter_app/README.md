# Control de Entradas y Salidas — App Flutter

Aplicación Flutter del sistema (inventario + POS). Documentación general en el `README.md` de la raíz del repositorio.

- **Inventario**: `lib/main.dart`
- **POS**: `lib/main_pos.dart`
- **Plan de migración**: `docs/PLAN_MIGRACION_FLUTTER.md`
- **Esquema Supabase**: `supabase/schema.sql`

```bash
flutter pub get
flutter analyze
flutter test
flutter build web --release -o build/web          # inventario
flutter build web --release -t lib/main_pos.dart -o build/pos   # POS
```