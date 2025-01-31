import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/theme/domain/usecases/check_theme.dart';
import 'package:code_streak/features/theme/domain/usecases/save_theme.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'theme_event.dart';
part 'theme_state.dart';
part 'theme_bloc.freezed.dart';

@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final CheckTheme checkTheme;
  final SaveTheme saveTheme;
  ThemeBloc(this.checkTheme, this.saveTheme) : super(const _DarkState()) {
    on<_CheckThemeEvent>(_onCheckThemeEvent);
    on<_ToggleThemeEvent>(_onToggleThemeEvent);
  }

  FutureOr<void> _onCheckThemeEvent(
      _CheckThemeEvent event, Emitter<ThemeState> emit) async {
    final brightness = await checkTheme.call(NoParams());
    emit(brightness == Brightness.dark
        ? const _DarkState()
        : const _LightState());
  }

  FutureOr<void> _onToggleThemeEvent(
      _ToggleThemeEvent event, Emitter<ThemeState> emit) {
    if (state is _DarkState) {
      emit(const _LightState());
      saveTheme.call(Params(brightness: Brightness.light));
    } else if (state is _LightState) {
      emit(const _DarkState());
      saveTheme.call(Params(brightness: Brightness.dark));
    }
  }
}
