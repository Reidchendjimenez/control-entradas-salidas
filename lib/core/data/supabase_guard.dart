import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'supabase_providers.dart';

/// Muestra un SnackBar amigable cuando Supabase no esta configurado.
void showSupabaseNotConfigured(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Supabase no configurado. Verifica la conexion.'),
      backgroundColor: Colors.orange,
      duration: Duration(seconds: 3),
    ),
  );
}

/// Provider auxiliar: retorna true si Supabase esta disponible.
final supabaseReadyProvider = Provider<bool>((ref) {
  return ref.watch(supabaseServiceProvider) != null;
});
