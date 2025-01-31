import 'dart:ui';

abstract class ThemeRepo {
  Future<Brightness> checkTheme();

  Future<void> saveTheme(Brightness brightness);
}
