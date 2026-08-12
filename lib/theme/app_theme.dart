import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // BRAND COLORS
  // ============================================================

  static const Color primaryRed = Color(0xFFC62828);
  static const Color primaryRedDark = Color(0xFFB71C1C);
  static const Color primaryRedLight = Color(0xFFFFEBEE);
  static const Color redLight = Color(0xFFFFEBEE);

  // ============================================================
  // BACKGROUND
  // ============================================================

  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;

  // ============================================================
  // TEXT
  // ============================================================

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // ============================================================
  // BORDER
  // ============================================================

  static const Color border = Color(0xFFE5E7EB);

  // ============================================================
  // STATUS COLORS
  // ============================================================

  static const Color running = Color(0xFF16A34A);
  static const Color runningLight = Color(0xFFDCFCE7);

  static const Color waiting = Color(0xFFF59E0B);
  static const Color waitingLight = Color(0xFFFEF3C7);

  static const Color scheduled = Color(0xFF2563EB);
  static const Color scheduledLight = Color(0xFFDBEAFE);

  // ============================================================
  // THEME
  // ============================================================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: background,

    // ==========================================================
    // COLOR SCHEME
    // ==========================================================

    colorScheme: const ColorScheme.light(
      primary: primaryRed,
      onPrimary: Colors.white,
      surface: surface,
      onSurface: textPrimary,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
    ),

    // ==========================================================
    // APP BAR
    // ==========================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryRed,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,

      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 19,
        fontWeight: FontWeight.w700,
      ),
    ),

    // ==========================================================
    // CARD
    // ==========================================================

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        side: BorderSide(
          color: border,
          width: 0.8,
        ),
      ),
    ),

    // ==========================================================
    // INPUT FIELDS
    // ==========================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: border,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: primaryRed,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: Color(0xFFD32F2F),
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: Color(0xFFD32F2F),
          width: 1.5,
        ),
      ),

      hintStyle: const TextStyle(
        color: textMuted,
        fontSize: 14,
      ),

      labelStyle: const TextStyle(
        color: textSecondary,
        fontSize: 14,
      ),
    ),

    // ==========================================================
    // BUTTON
    // ==========================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,

        minimumSize: const Size(
          double.infinity,
          50,
        ),

        elevation: 0,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),

        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // ==========================================================
    // TEXT BUTTON
    // ==========================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryRed,

        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ==========================================================
    // DIVIDER
    // ==========================================================

    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
      space: 1,
    ),

    // ==========================================================
    // ICON
    // ==========================================================

    iconTheme: const IconThemeData(
      color: textSecondary,
    ),
  );
}