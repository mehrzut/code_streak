import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData dark = ThemeData(
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
        onSecondaryFixed: Color(0xff5b636b),
        primaryContainer: Color(0xff98C1EA),
        onPrimaryContainer: Color(0xff053C73),
        surfaceContainerLow: Color(0xff2793FF),
        surfaceContainerHigh: Color(0xff053C73),
        outline: Color(0xff3D4754),
        tertiary: Color(0xff2E8B57),
        onTertiary: Color(0xffffffff),
        inversePrimary: Color(0xffEBC106)),
  );

  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    primaryColor: const Color(0xFF1466B8),
    primaryColorLight: const Color(0xFF1980E8),
    primaryColorDark: const Color(0xFF10549B),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF1466B8),
        foregroundColor: const Color(0xFFFFFFFF),
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
        foregroundColor: const Color(0xFFFFFFFF),
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
        foregroundColor: const Color(0xFF1466B8),
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
        foregroundColor: const Color(0xFF1466B8),
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
      backgroundColor: Color(0xFFFFFFFF),
      foregroundColor: Color(0xFF121417),
      surfaceTintColor: Color(0xffffffff),
    ),
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xFF1466B8),
      secondary: Color(0xFF1980E8),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFE5E2),
      onErrorContainer: Color(0xFF5D000B),
      surface: Color(0xFFF7F9FC),
      onSurface: Color(0xFF121417),
      onSurfaceVariant: Color(0xFF4D5C6B),
      onSecondaryFixed: Color(0xFF73808C),
      primaryContainer: Color(0xFFD6E8F7),
      onPrimaryContainer: Color(0xFF003A70),
      surfaceContainerHigh: Color(0xFFEDF5FF),
      surfaceContainerLow: Color(0xFF003A70),
      outline: Color.fromARGB(255, 216, 221, 227),
      tertiary: Color(0xFF2E8B57),
      onTertiary: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFFFFA726),
    ),
  );
}
