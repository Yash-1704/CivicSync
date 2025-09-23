import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';
  AppThemeMode _currentTheme = AppThemeMode.dark;

  AppThemeMode get currentTheme => _currentTheme;

  // Dark theme colors (existing)
  static const Color darkA = Color(0xFF0F172A);
  static const Color darkB = Color(0xFF312E81);
  static const Color accent = Color(0xFF3B82F6);
  static const Color accent2 = Color(0xFF6D28D9);

  // Light theme colors (inverted/complementary to dark theme)
  static const Color lightA = Color(0xFFF8FAFC);
  static const Color lightB = Color(0xFFE2E8F0);
  static const Color lightAccent = Color(0xFF1E40AF);
  static const Color lightAccent2 = Color(0xFF7C3AED);

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkA,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkB,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.03),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent2,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        headlineLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      dividerColor: Colors.white24,
      colorScheme: ColorScheme.dark(
        primary: accent,
        secondary: accent2,
        surface: darkA,
        background: darkA,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
    );
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightA,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightB,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.03),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightAccent2,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black54),
        headlineLarge: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black54),
      dividerColor: Colors.black12,
      colorScheme: ColorScheme.light(
        primary: lightAccent,
        secondary: lightAccent2,
        surface: lightA,
        background: lightA,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
      ),
    );
  }

  ThemeMode get themeMode {
    switch (_currentTheme) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  String get themeName {
    switch (_currentTheme) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System Default';
    }
  }

  Future<void> setTheme(AppThemeMode theme) async {
    _currentTheme = theme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme.toString());
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    if (themeString != null) {
      switch (themeString) {
        case 'AppThemeMode.light':
          _currentTheme = AppThemeMode.light;
          break;
        case 'AppThemeMode.dark':
          _currentTheme = AppThemeMode.dark;
          break;
        case 'AppThemeMode.system':
          _currentTheme = AppThemeMode.system;
          break;
      }
    }
    notifyListeners();
  }

  // Helper methods for getting theme-aware colors
  Color getPrimaryBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkA : lightA;
  }

  Color getSecondaryBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkB : lightB;
  }

  Color getPrimaryAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? accent
        : lightAccent;
  }

  Color getSecondaryAccentColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? accent2
        : lightAccent2;
  }

  Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
  }

  LinearGradient getBackgroundGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? LinearGradient(
            colors: [darkA, darkB],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [lightA, lightB],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  LinearGradient getAccentGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? LinearGradient(colors: [accent2, accent])
        : LinearGradient(colors: [lightAccent2, lightAccent]);
  }
}
