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
  bool get isLoading => state.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isReminderEnabled
                ? Theme.of(context).colorScheme.primaryFixed
                : Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Expanded(
              child: Text(
                isReminderEnabled
                    ? "Hooray! 🎉 You'll receive reminders every day! ✅"
                    : "Oops! 😕 Something went wrong setting up reminders. 🔄",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isReminderEnabled
                          ? Theme.of(context).colorScheme.onPrimaryFixed
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
