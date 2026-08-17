import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/logging/log_bridge.dart';
import 'core/network/supabase_client.dart';
import 'features/pos/presentation/pos_app.dart';

/// Punto de entrada de la aplicación POS (independiente de la app de
/// inventario). Comparte la base de datos remota (Supabase) y mantiene su
/// propia base local. Build: `flutter build web --release -t lib/main_pos.dart`.
void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await LogBridge.instance.start();

      // Configurar Supabase REST (no-op si falta la anon key).
      await initializeSupabase();

      runApp(
        const ProviderScope(
          child: PosApp(),
        ),
      );
    },
    (error, stackTrace) {
      LogBridge.instance.push('$error\n$stackTrace');
    },
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        parent.print(zone, line);
        LogBridge.instance.push(line);
      },
    ),
  );
}
