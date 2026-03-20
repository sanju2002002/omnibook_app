import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  /// 🔥 BRAND COLORS
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF8E85FF);
  static const Color backgroundDark = Color(0xFF2E2E5E);

  /// 🌞 LIGHT THEME (Glass Friendly)
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    /// 🔹 COLORS
    primaryColor: primary,
    scaffoldBackgroundColor: Colors.transparent,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),

    /// 🔹 TEXT
    textTheme: GoogleFonts.poppinsTextTheme(),

    /// 🔹 APPBAR
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),

    /// 🔹 ICONS
    iconTheme: const IconThemeData(color: Colors.white),

    /// 🔹 BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),

    /// 🔹 INPUT FIELDS (future use)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white54),
    ),
  );

  /// 🌙 DARK THEME (Future Ready)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    primaryColor: primary,
    scaffoldBackgroundColor: backgroundDark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ),

    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),
  );
}
