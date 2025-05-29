
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/features/home/presentation/bloc/notification_time_bloc.dart';
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationReminderWidget extends StatelessWidget {
  const NotificationReminderWidget({
    super.key,
    required this.reminderState,
    required this.notificationTimeState,
  });

  final ReminderState reminderState;
  final NotificationTimeState notificationTimeState;

  // Reminder state getters
  bool get isReminderEnabled => reminderState.maybeWhen(
        success: () => true,
        orElse: () => false,
      );

  bool get isReminderLoading => reminderState.isLoading;

  Failure? get reminderFailure => reminderState.whenOrNull(
        failed: (failure) => failure,
      );

  // Notification time getters
  bool get isNotificationTimeSet => notificationTimeState.maybeWhen(
        success: (notificationTime, recentlyChanged) => true,
        orElse: () => false,
      );

  bool get isNotificationTimeLoading => notificationTimeState.isLoading;

  Failure? get notificationTimeFailure => notificationTimeState.whenOrNull(
        failed: (failure) => failure,
      );

  TimeOfDay get notificationTime => notificationTimeState.maybeWhen(
        success: (notificationTime, recentlyChanged) => notificationTime,
        orElse: () => const TimeOfDay(hour: 21, minute: 0), // Default time
      );

  bool get isRecentlyChanged => notificationTimeState.maybeWhen(
        success: (notificationTime, recentlyChanged) => recentlyChanged,
        orElse: () => false,
      );

  // Combined state getters
  bool get isLoading => isReminderLoading || isNotificationTimeLoading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      enableSwitchAnimation: true,
      child: AnimatedContainer(
        duration: Durations.medium2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isLoading
              ? Theme.of(context).colorScheme.surface
              : isReminderEnabled
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: AnimatedSize(
          duration: Durations.medium2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Expanded(
                  child: Text(
                    _getDisplayMessage(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isReminderEnabled && isNotificationTimeSet
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onErrorContainer,
                        ),
                  ),
                ),
                if (isReminderEnabled && isNotificationTimeSet)
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _showTimePicker(context),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
              ]),
              if (isRecentlyChanged && isNotificationTimeSet)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Changes will be applied tomorrow. ⏰",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDisplayMessage() {
    // Priority is with ReminderState
    if (isReminderEnabled && isNotificationTimeSet) {
      return "Hooray! 🎉 You'll receive reminders every day at ${_formatTime(notificationTime)}! ✅";
    }

    // Handle reminder failure cases
    if (reminderFailure != null) {
      if (reminderFailure is PermissionFailure) {
        return "Notification permission Denied! 😕 You need to approve it in settings to set reminders. 🚨";
      }
      return "Oops! 😕 Something went wrong setting up reminders. 🔄";
    }

    if (notificationTimeFailure != null) {
      return "Oops! 😕 Something went wrong setting notification time. 🔄";
    }

    // Default message
    return "Oops! 😕 Something went wrong setting up reminders. 🔄";
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: notificationTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).colorScheme.surface,
              hourMinuteTextColor: Theme.of(context).colorScheme.onSurface,
              dayPeriodTextColor: Theme.of(context).colorScheme.onSurface,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              dialTextColor: Theme.of(context).colorScheme.onSurface,
              entryModeIconColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && context.mounted) {
      context.read<NotificationTimeBloc>().add(
            NotificationTimeEvent.set(notificationTime: pickedTime),
          );
    }
  }
}
