import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData data = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121417),
    primaryColor: const Color(0xFF1466B8),
    primaryColorLight: const Color(0xFF1466B8),
    primaryColorDark: const Color(0xFF1466B8),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF1466B8),
        foregroundColor: const Color(0xffffffff),
        textStyle: TextStyle(
          fontSize: 14,
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF1466B8),
        foregroundColor: const Color(0xffffffff),
        textStyle: TextStyle(
          fontSize: 14,
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF1980E8),
        textStyle: TextStyle(
          fontSize: 14,
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF1980E8),
        textStyle: TextStyle(
          fontSize: 14,
          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121417),
      foregroundColor: Color(0xffffffff),
    ),
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xFF1466B8),
      secondary: Color(0xFF1980E8),
      onPrimary: Color(0xffffffff),
      onSecondary: Color(0xffffffff),
      error: Color(0xfff22209),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad4),
      onErrorContainer: Color(0xff400200),
      surface: Color(0xFF1C2126),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xff9EABB8),
      tertiary: Color(0xff293038),
      onTertiary: Color(0xffffffff),
      primaryContainer: Color(0xff98C1EA),
      onPrimaryContainer: Color(0xff053C73),
      surfaceContainerLow: Color(0xff2793FF),
      outline: Color(0xff3D4754),
    ),
  );
}
