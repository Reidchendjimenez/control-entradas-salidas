import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/network/supabase_client.dart';
import 'core/router/app_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar Supabase REST (no-op si falta la anon key).
  await initializeSupabase();

  runApp(
    const ProviderScope(
      child: AppShell(),
    ),
  );
}