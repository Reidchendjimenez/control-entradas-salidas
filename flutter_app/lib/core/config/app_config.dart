/// Configuración de la app, equivalente a `config/config.py` + `config/db_config.py`.
///
/// Fuente de valores:
/// - `--dart-define=SUPABASE_URL=...`, `--dart-define=SUPABASE_ANON_KEY=...`
///   (los define de compilación viajan en el bundle como `String.fromEnvironment`).
/// - Fallback a constantes compiladas (como el `db_config.py` empaquetado).
///
/// El ref de Supabase se deriva de `DB_USER` = `postgres.<ref>` del .env actual
/// (`uyyyveojjvbxhuhbnype`). La anon key solo se inyecta en CI (GitHub Secrets),
/// de forma análoga al workflow build_apk.yml que sobreescribe db_config.py.
class AppConfig {
  AppConfig._();

  static String get supabaseUrl {
    const fromEnv = String.fromEnvironment('SUPABASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    // https://<ref>.supabase.co
    return 'https://uyyyveojjvbxhuhbnype.supabase.co';
  }

  static String get supabaseAnonKey {
    return const String.fromEnvironment('SUPABASE_ANON_KEY');
  }

  /// URL del updater (equivalent a UPDATE_URL del .env).
  static String get updateUrl {
    const fromEnv = String.fromEnvironment('UPDATE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    return 'https://raw.githubusercontent.com/reidchend/control-entradas-salidas/main/version.json';
  }

  /// Puerto web para desarrollo (FLET_WEB_PORT legacy = 8502).
  static String get webPort => const String.fromEnvironment('WEB_PORT',
      defaultValue: '8502');

  /// Intervalo del sync background en segundos (sync.py start_background_sync).
  static const int syncIntervalSeconds = 20;

  static bool get hasSupabaseKey => supabaseAnonKey.isNotEmpty;
}