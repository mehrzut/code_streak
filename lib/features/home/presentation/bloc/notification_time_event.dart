part of 'notification_time_bloc.dart';

@freezed
class NotificationTimeEvent with _$NotificationTimeEvent {
  factory NotificationTimeEvent.set({required TimeOfDay notificationTime}) = _SetNotificationTimeEvent;
  factory NotificationTimeEvent.get() = _GetNotificationTimeEvent;
}