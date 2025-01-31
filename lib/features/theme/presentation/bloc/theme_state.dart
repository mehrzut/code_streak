part of 'theme_bloc.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState.dark() = _DarkState;
  const factory ThemeState.light() = _LightState;
}
