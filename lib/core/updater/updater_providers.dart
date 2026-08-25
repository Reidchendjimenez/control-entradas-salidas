import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_updater.dart';

/// Updater compartido (POS e inventario). Solo actúa en Windows/Android;
/// en web `canRun` es false y las llamadas devuelven null/fallan sin efecto.
final appUpdaterProvider = Provider<AppUpdater>((ref) => AppUpdater());