import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReminderStatusWidget extends StatelessWidget {
  const ReminderStatusWidget({super.key, required this.state});
  final ReminderState state;

  bool get isReminderEnabled => state.maybeWhen(
        success: () => true,
        orElse: () => false,
      );

  bool get isLoading => state.isLoading;

  Failure? get failure => state.whenOrNull(
        failed: (failure) => failure,
      );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      enableSwitchAnimation: true,
      child: AnimatedContainer(
        duration: Durations.medium2,
        padding: const EdgeInsets.all(12),
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
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              child: Text(
                isReminderEnabled
                    ? "Hooray! 🎉 You'll receive reminders every day! ✅"
                    : failure is PermissionFailure
                        ? "Notification permission Denied! 😕 You need to approve it in settings to set reminders. 🚨"
                        : "Oops! 😕 Something went wrong setting up reminders. 🔄",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isReminderEnabled
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
