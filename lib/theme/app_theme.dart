import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Editorial-luxury palette inspired by Tomollo Fashions:
/// warm ivory grounds, near-black ink, deep evergreen-teal primary and a
/// terracotta accent pulled from natural imagery. Imagery leads; UI recedes.
class AppColors {
  static const Color primary = Color(0xFF1F3D3A);     // deep evergreen-teal
  static const Color primaryDark = Color(0xFF14302D);
  static const Color accent = Color(0xFFC46A4A);      // terracotta / earth
  static const Color ink = Color(0xFF1A1A1A);         // near-black text
  static const Color surface = Color(0xFFF7F4EF);     // warm ivory ground
  static const Color card = Colors.white;
  static const Color muted = Color(0xFF8A857D);       // warm grey
  static const Color line = Color(0xFFE7E2D9);        // hairline borders
}

class AppTheme {
  /// Serif display family for editorial headlines.
  static TextStyle display(
          {double size = 32, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: weight,
        height: 1.1,
        color: color ?? AppColors.ink,
      );

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.surface,
    );

    final text = GoogleFonts.interTextTheme(base.textTheme).copyWith(
      headlineLarge: display(size: 40, weight: FontWeight.w700),
      headlineSmall: display(size: 26, weight: FontWeight.w600),
      titleLarge: display(size: 20, weight: FontWeight.w600),
    );

    return base.copyWith(
      textTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: AppColors.ink,
        centerTitle: false,
        titleTextStyle: display(size: 22, weight: FontWeight.w600),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.line, thickness: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        labelStyle: const TextStyle(color: AppColors.muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            letterSpacing: 0.3,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    );
  }
}
