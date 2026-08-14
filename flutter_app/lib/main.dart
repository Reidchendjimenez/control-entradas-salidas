import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/logging/log_bridge.dart';
import 'core/network/supabase_client.dart';
import 'core/router/app_shell.dart';
import 'features/calculadora/presentation/calculadora.dart' as _calc;

// Force reference to prevent tree-shaking
void _forceIncludeCalculadora() {
  _calc.showCalculadoraDialog;
  _calc.CalculadoraButton;
  _calc.CalculadoraSuffixIcon;
}

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await LogBridge.instance.start();

      // Configurar Supabase REST (no-op si falta la anon key).
      await initializeSupabase();

      runApp(
        const ProviderScope(
          child: AppShell(),
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