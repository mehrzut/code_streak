import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/usecases/set_user_timezone.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'timezone_event.dart';
part 'timezone_state.dart';
part 'timezone_bloc.freezed.dart';

@injectable
class TimezoneBloc extends Bloc<TimezoneEvent, TimezoneState> {
  final SetUserTimezone _setUserTimezone;
  TimezoneBloc(this._setUserTimezone) : super(_InitialState()) {
    on<_SetTimezoneEvent>(_onSetTimezoneEvent);
  }

  Future<void> _onSetTimezoneEvent(
      _SetTimezoneEvent event, Emitter<TimezoneState> emit) async {
    emit(TimezoneState.loading());
    final response = await _setUserTimezone(NoParams());
    final newState = response.when(
      failed: (failure) => TimezoneState.failed(failure: failure),
      success: (data) => TimezoneState.success(),
    );
    emit(newState);
  }
}
