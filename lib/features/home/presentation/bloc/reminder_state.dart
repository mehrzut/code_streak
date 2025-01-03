part of 'reminder_bloc.dart';

@freezed
class ReminderState with _$ReminderState {
  factory ReminderState.initial() = _InitialState;
  factory ReminderState.loading() = _LoadingState;
  factory ReminderState.success() = _SuccessState;
  factory ReminderState.failed({required Failure failure}) = _FailedState;
}
