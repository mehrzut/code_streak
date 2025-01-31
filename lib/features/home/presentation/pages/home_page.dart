import 'package:code_streak/core/controllers/overlay_manager.dart';
import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/core/widget/pull_to_refresh_widget.dart';
import 'package:code_streak/features/auth/presentation/bloc/sign_out_bloc.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart';
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart';
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:code_streak/features/home/presentation/widgets/contribution_calendar_widget.dart';
import 'package:code_streak/features/home/presentation/widgets/reminder_status_widget.dart';
import 'package:code_streak/features/home/presentation/widgets/user_info_widget.dart';
import 'package:code_streak/features/home/presentation/widgets/user_streak_widget.dart';
import 'package:code_streak/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  static const pageRoute = '/home';
  const HomePage({super.key});

  @override
  createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  DateTime? currentCalendarDate;
  @override
  void initState() {
    _handleInitialization();
    super.initState();
  }

  void _handleInitialization() {
    _getUserInfo();
    _setUserReminder();
  }

  double get appbarExpandedHeight => MediaQuery.sizeOf(context).width;
  double get appbarCollapsedHeight => kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) => _getContributionsData(
              data.username,
              DateTime.now().zeroHour.subtract(const Duration(days: 365)),
              DateTime.now()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CodeStreak'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.logout_outlined),
                onPressed: _signOut,
              ),
            )
          ],
          leadingWidth: 96,
          leading: BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(
                        state.when(
                          dark: () => Icons.light_mode,
                          light: () => Icons.dark_mode,
                        ),
                      ),
                      onPressed: _toggleTheme,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        body: SafeArea(
          child: PullToRefreshWidget(
            onRefresh: () async => _handleInitialization(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        BlocBuilder<UserInfoBloc, UserInfoState>(
                          builder: (context, state) {
                            return UserInfoWidget(
                              key: ValueKey(state),
                              state: state,
                            );
                          },
                        ),
                        BlocBuilder<UserInfoBloc, UserInfoState>(
                            builder: (context, infoState) {
                          return BlocBuilder<ContributionsBloc,
                              ContributionsState>(
                            builder: (context, state) {
                              return Skeletonizer(
                                enableSwitchAnimation: true,
                                enabled:
                                    (state.data == null && state.isLoading) ||
                                        infoState.isLoading,
                                child: UserStreakWidget(
                                  state: state,
                                ),
                              );
                            },
                          );
                        }),
                        BlocBuilder<ReminderBloc, ReminderState>(
                          builder: (context, state) {
                            return ReminderStatusWidget(
                              state: state,
                            );
                          },
                        ),
                        BlocBuilder<UserInfoBloc, UserInfoState>(
                          builder: (context, infoState) {
                            return BlocBuilder<ContributionsBloc,
                                ContributionsState>(
                              builder: (context, state) {
                                if (state.data == null && !state.isLoading) {
                                  return const Text(
                                    'Something went wrong',
                                  );
                                }
                                return Skeletonizer(
                                  enabled:
                                      state.isLoading || infoState.isLoading,
                                  enableSwitchAnimation: true,
                                  child: ContributionCalendarWidget(
                                    current: currentCalendarDate,
                                    data:
                                        state.data ?? ContributionsData.empty(),
                                    heatMapColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerLow,
                                    defaultCalendarColor:
                                        Theme.of(context).colorScheme.surface,
                                    onMonthChanged: _onCalendarMonthChanged,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ].verticalPadding(
                        24,
                        addToStart: true,
                        addToEnd: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _getUserInfo() {
    context.read<UserInfoBloc>().add(UserInfoEvent.getUserInfo());
  }

  void _getContributionsData(String username, DateTime start, DateTime end) {
    context.read<ContributionsBloc>().add(
        ContributionsEvent.get(username: username, start: start, end: end));
  }

  void _setUserReminder() {
    context.read<ReminderBloc>().add(ReminderEvent.set());
  }

  void _signOut() {
    OverlayManager.showSignOutDialog(context).then(
      (value) {
        if ((value ?? false) && mounted) {
          context.read<SignOutBloc>().add(const SignOutEvent.signOut());
        }
      },
    );
  }

  void _onCalendarMonthChanged(DateTime date) {
    currentCalendarDate = date;
    final startOfMonth = date.firstDayOfMonth;
    final endOfMonth = date.lastDayOfMonth;
    final contributionData = context.read<ContributionsBloc>().state.data;
    if (contributionData != null &&
        !startOfMonth.isAfter(DateTime.now()) &&
        !endOfMonth.isAfter(DateTime.now()) &&
        !contributionData.hasRange(startOfMonth, endOfMonth)) {
      context.read<UserInfoBloc>().state.whenOrNull(
        success: (data) {
          _getContributionsData(data.username, startOfMonth, endOfMonth);
        },
      );
    }
  }

  void _toggleTheme() {
    context.read<ThemeBloc>().add(const ThemeEvent.toggle());
  }
}
