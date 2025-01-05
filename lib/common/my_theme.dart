import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData data = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121417),
    primaryColor: const Color(0xFF1466B8),
    primaryColorLight: const Color(0xFF1466B8),
    primaryColorDark: const Color(0xFF1466B8),
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
    ),
  );
}
