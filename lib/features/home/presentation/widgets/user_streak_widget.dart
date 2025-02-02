import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/core/widget/glowing_text.dart';
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart';
import 'package:flutter/material.dart';

class UserStreakWidget extends StatelessWidget {
  const UserStreakWidget({super.key, required this.state});
  final ContributionsState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'In past year...',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    (state.data?.hasContributionsToday ?? false)
                        ? GlowingText(
                            '${state.data?.currentDailyStreak ?? 0}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 72,
                                ),
                            shadowColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                          )
                        : Text(
                            '${state.data?.currentDailyStreak ?? 0}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 72,
                                ),
                          ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                          state.data?.hasContributionsToday ?? true
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.spaceBetween,
                      children: [
                        if (!(state.data?.hasContributionsToday ?? true))
                          Text(
                            (state.data?.currentDailyStreak ?? 0) > 0
                                ? '⚠️ Your streak is in danger!'
                                : 'You can start your streak today.',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                          ),
                        Text(
                          'day${(state.data?.currentDailyStreak ?? 0) == 1 ? '' : 's'} streak',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ].horizontalPadding(8),
            ),
          ),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: '${state.data?.currentWeeklyStreak ?? 0}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
            TextSpan(
              text:
                  ' week${(state.data?.currentWeeklyStreak ?? 0) == 1 ? '' : 's'} streak',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ])),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: '${state.data?.totalContributionsInPastYear ?? 0}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
            TextSpan(
              text:
                  ' contribution${(state.data?.totalContributionsInPastYear ?? 0) == 1 ? '' : 's'}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ])),
          Text.rich(TextSpan(children: [
            TextSpan(
              text: '${state.data?.mostContributeInADayInPastYear ?? 0}',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
            TextSpan(
              text:
                  ' most contribution${(state.data?.mostContributeInADayInPastYear ?? 0) == 1 ? '' : 's'} in one day',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ])),
        ],
      ),
    );
  }
}
