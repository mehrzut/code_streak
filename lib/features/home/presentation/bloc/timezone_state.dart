part of 'timezone_bloc.dart';

@freezed
class TimezoneState with _$TimezoneState {
  factory TimezoneState.initial() = _InitialState;
  factory TimezoneState.loading() = _LoadingState;
  factory TimezoneState.success() = _SuccessState;
  factory TimezoneState.failed({required Failure failure}) = _FailedState;
}
