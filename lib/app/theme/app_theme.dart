import 'package:flutter/material.dart';

ThemeData buildLightTheme() => _buildTheme(Brightness.light);
ThemeData buildDarkTheme() => _buildTheme(Brightness.dark);

ThemeData _buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final foreground = Color(dark ? 0xFFEDEAE7 : 0xFF1C1917);
  final secondary = Color(dark ? 0xFFA8A29E : 0xFF57534E);
  final background = Color(dark ? 0xFF12100F : 0xFFFAFAF9);
  final accent = Color(dark ? 0xFF2DD4BF : 0xFF0F766E);
  final border = Color(dark ? 0xFF2E2A29 : 0xFFE7E5E4);
  final scheme = ColorScheme.fromSeed(seedColor: accent, brightness: brightness)
      .copyWith(
        primary: accent,
        onPrimary: dark ? const Color(0xFF12100F) : Colors.white,
        surface: background,
        onSurface: foreground,
        onSurfaceVariant: secondary,
        outline: border,
        outlineVariant: border,
        surfaceContainerLow: Color(dark ? 0xFF1A1817 : 0xFFFFFFFF),
        surfaceContainerHighest: Color(dark ? 0xFF221F1E : 0xFFF5F5F4),
        primaryContainer: Color(dark ? 0xFF16302D : 0xFFE6F4F1),
      );
  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    fontFamily: 'Inter',
  );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      displayLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 72,
        height: 1.06,
        letterSpacing: -2.5,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 32,
        height: 1.2,
        letterSpacing: -1.2,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 24,
        height: 1.3,
        letterSpacing: -.5,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      titleLarge: TextStyle(
        fontFamily: 'SpaceGrotesk',
        fontSize: 20,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      bodyLarge: TextStyle(fontSize: 18, height: 1.7, color: secondary),
      bodyMedium: TextStyle(fontSize: 16, height: 1.7, color: secondary),
      bodySmall: TextStyle(fontSize: 13, height: 1.6, color: secondary),
      labelSmall: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 12,
        height: 1.7,
        letterSpacing: 1.6,
        color: secondary,
      ),
    ),
    dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: foreground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: foreground,
        foregroundColor: background,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foreground,
        minimumSize: const Size(48, 48),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        side: BorderSide(color: border),
        textStyle: const TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accent,
        minimumSize: const Size(48, 48),
        textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 14),
      ),
    ),
    splashFactory: NoSplash.splashFactory,
  );
}
