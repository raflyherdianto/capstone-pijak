import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF1A1A1A);
  static const Color accentLight = Color(0xFF10B981); // Emerald Green
  static const Color bgLight = Color(0xFFF8F9FA);
  static const Color cardLight = Colors.white;

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFFF8F9FA);
  static const Color accentDark = Color(0xFF34D399); // Light Emerald
  static const Color bgDark = Color(0xFF0F0F0F);
  static const Color cardDark = Color(0xFF1C1C1E);

  static ThemeData lightTheme = _buildTheme(
    brightness: Brightness.light,
    primary: primaryLight,
    background: bgLight,
    card: cardLight,
  );

  static ThemeData darkTheme = _buildTheme(
    brightness: Brightness.dark,
    primary: primaryDark,
    background: bgDark,
    card: cardDark,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primary,
    required Color background,
    required Color card,
  }) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background, // We'll keep this as fallback
      fontFamily: 'Outfit',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        surface: card,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : primary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : primary,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: isDark ? Colors.white70 : primary.withValues(alpha: 0.8),
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white54 : primary.withValues(alpha: 0.6),
        ),
      ).apply(
        fontFamily: 'Outfit',
      ),
      cardTheme: CardThemeData(
        color: isDark
            ? card.withValues(alpha: 0.7)
            : card.withValues(alpha: 0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.04),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? card.withValues(alpha: 0.5)
            : card.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.06),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF34D399) : const Color(0xFF10B981),
            width: 1.5,
          ),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Outfit',
          color: isDark ? Colors.white38 : Colors.black38,
          fontSize: 14,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark, // Android
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light, // iOS
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : primary),
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : primary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        indicatorColor: isDark
            ? const Color(0xFFE8C766).withValues(alpha: 0.18)
            : const Color(0xFF16C7B7).withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE8C766) : const Color(0xFF0B9F91),
            );
          }
          return TextStyle(
            fontFamily: 'Outfit',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? Colors.white60 : Colors.black54,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: isDark ? const Color(0xFFE8C766) : const Color(0xFF0B9F91),
            );
          }
          return IconThemeData(color: isDark ? Colors.white60 : Colors.black54);
        }),
      ),
    );
  }
}
