part of 'timezone_bloc.dart';

@freezed
class TimezoneEvent with _$TimezoneEvent {
  factory TimezoneEvent.set() = _SetTimezoneEvent;
}