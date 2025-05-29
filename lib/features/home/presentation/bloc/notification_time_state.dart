part of 'notification_time_bloc.dart';

@freezed
class NotificationTimeState with _$NotificationTimeState {
  factory NotificationTimeState.initial() = _InitialState;
  factory NotificationTimeState.loading() = _LoadingState;
  factory NotificationTimeState.success({
    required TimeOfDay notificationTime,
    @Default(false) bool recentlyChanged,
  }) = _SuccessState;
  factory NotificationTimeState.failed({required Failure failure}) = _FailedState;

  NotificationTimeState._();

  bool get isLoading => this is _LoadingState || this is _InitialState;
}