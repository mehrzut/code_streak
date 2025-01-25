import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart';
import 'package:flutter/material.dart';

class UserStreakWidget extends StatelessWidget {
  const UserStreakWidget({super.key, required this.state});
  final ContributionsState state;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${state.data?.currentStreak ?? 0}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: state.data?.hasContributionsToday ?? false
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.inversePrimary,
                fontWeight: FontWeight.bold,
                fontSize: 72),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: state.data?.hasContributionsToday ?? true
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.spaceBetween,
                children: [
                  if (!(state.data?.hasContributionsToday ?? true))
                    Text(
                      (state.data?.currentStreak ?? 0) > 0
                          ? '⚠️ Your streak is in danger!'
                          : 'You can start your streak today.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                    ),
                  Text(
                    'days streak in past year',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ].horizontalPadding(8),
      ),
    );
  }
}
