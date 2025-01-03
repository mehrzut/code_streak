import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/usecases/set_user_reminders.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';
part 'reminder_bloc.freezed.dart';

@injectable
class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final SetUserReminders _setUserReminders;
  ReminderBloc(this._setUserReminders) : super(_InitialState()) {
    on<_SetReminderEvent>(_onSetTimezoneEvent);
  }

  Future<void> _onSetTimezoneEvent(
      _SetReminderEvent event, Emitter<ReminderState> emit) async {
    emit(ReminderState.loading());
    final response = await _setUserReminders(NoParams());
    final newState = response.when(
      failed: (failure) => ReminderState.failed(failure: failure),
      success: (data) => ReminderState.success(),
    );
    emit(newState);
  }
}
