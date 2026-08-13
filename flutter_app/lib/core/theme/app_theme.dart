import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Puerto de `apply_theme_to_*` de usr/theme.py a un ThemeData de Material.
AppThemeData buildAppTheme({required ThemeMode mode}) {
  final isDark = mode == ThemeMode.dark;
  final c = AppColors.of(isDark);

  const inputDecoration = InputDecorationThemeData(
    border: OutlineInputBorder(),
    filled: false,
  );

  return AppThemeData(
    isDark: isDark,
    colors: c,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: Color(int.parse(c['accent']!.replaceFirst('#', '0xFF'))),
        onPrimary: Color(int.parse(c['white']!.replaceFirst('#', '0xFF'))),
        secondary: Color(int.parse(c['accent_dark']!.replaceFirst('#', '0xFF'))),
        onSecondary: Colors.white,
        error: Color(int.parse(c['error']!.replaceFirst('#', '0xFF'))),
        onError: Colors.white,
        surface: Color(int.parse(c['surface']!.replaceFirst('#', '0xFF'))),
        onSurface: Color(int.parse(c['text_primary']!.replaceFirst('#', '0xFF'))),
      ),
      scaffoldBackgroundColor: Color(int.parse(c['bg']!.replaceFirst('#', '0xFF'))),
      cardTheme: CardThemeData(
        color: Color(int.parse(c['card']!.replaceFirst('#', '0xFF'))),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: inputDecoration,
    ),
  );
}

class AppThemeData {
  final bool isDark;
  final Map<String, String> colors;
  final ThemeData theme;

  const AppThemeData({
    required this.isDark,
    required this.colors,
    required this.theme,
  });

  Color color(String key) =>
      Color(int.parse(colors[key]!.replaceFirst('#', '0xFF')));

  ThemeData dark() => buildAppTheme(mode: ThemeMode.dark).theme;
  ThemeData light() => buildAppTheme(mode: ThemeMode.light).theme;
}