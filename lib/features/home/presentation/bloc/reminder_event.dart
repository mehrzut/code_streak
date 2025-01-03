part of 'reminder_bloc.dart';

@freezed
class ReminderEvent with _$ReminderEvent {
  factory ReminderEvent.set() = _SetReminderEvent;
}