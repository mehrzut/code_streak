part of 'theme_bloc.dart';

@freezed
class ThemeEvent with _$ThemeEvent {
  const factory ThemeEvent.check() = _CheckThemeEvent;
  const factory ThemeEvent.toggle() = _ToggleThemeEvent;
}