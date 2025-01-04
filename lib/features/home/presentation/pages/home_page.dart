import 'package:code_streak/core/controllers/overlay_manager.dart';
import 'package:code_streak/features/auth/presentation/bloc/sign_out_bloc.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/presentation/bloc/contributions_bloc.dart';
import 'package:code_streak/features/home/presentation/bloc/reminder_bloc.dart';
import 'package:code_streak/features/home/presentation/bloc/user_info_bloc.dart';
import 'package:code_streak/features/home/presentation/widgets/contribution_calendar_widget.dart';
import 'package:code_streak/features/home/presentation/widgets/reminder_status_widget.dart';
import 'package:code_streak/features/home/presentation/widgets/user_info_widget.dart';
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
  @override
  void initState() {
    _getUserInfo();
    _setUserReminder();
    super.initState();
  }

  double get appbarExpandedHeight => MediaQuery.sizeOf(context).width;
  double get appbarCollapsedHeight => kToolbarHeight;

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (data) => _getContributionsData(data.username),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CodeStreak'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: _signOut,
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // SliverAppBar(
              //   pinned: true,
              //   floating: false,
              //   backgroundColor: Colors.transparent,
              //   expandedHeight: appbarExpandedHeight,
              //   collapsedHeight: appbarCollapsedHeight,
              //   flexibleSpace: BlocBuilder<UserInfoBloc, UserInfoState>(
              //     builder: (context, state) {
              //       return UserInfoAppBar(
              //         state: state,
              //         expandedHeight: appbarExpandedHeight,
              //         collapsedHeight: appbarCollapsedHeight,
              //       );
              //     },
              //   ),
              // ),
              SliverList(
                  delegate: SliverChildListDelegate([
                BlocBuilder<UserInfoBloc, UserInfoState>(
                  builder: (context, state) {
                    return UserInfoWidget(
                      key: ValueKey(state),
                      state: state,
                    );
                  },
                ),
                BlocBuilder<ReminderBloc, ReminderState>(
                  builder: (context, state) {
                    return ReminderStatusWidget(
                      state: state,
                    );
                  },
                ),
                BlocBuilder<ContributionsBloc, ContributionsState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      failed: (failure) => const Center(
                        child: Text(
                          'Something went wrong',
                        ),
                      ),
                      success: (data) => ContributionCalendarWidget(
                        data: data,
                        heatMapColor: Theme.of(context).colorScheme.tertiary,
                        defaultCalendarColor:
                            Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                      orElse: () => Skeletonizer(
                        enabled: true,
                        enableSwitchAnimation: true,
                        child: ContributionCalendarWidget(
                          data: ContributionsData(
                              totlaContributions: 0, contributionCalendar: []),
                          heatMapColor: Theme.of(context).colorScheme.tertiary,
                          defaultCalendarColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh,
                        ),
                      ),
                    );
                  },
                ),
              ]))
            ],
          ),
        ),
      ),
    );
  }

  void _getUserInfo() {
    context.read<UserInfoBloc>().add(UserInfoEvent.getUserInfo());
  }

  void _getContributionsData(String username) {
    context
        .read<ContributionsBloc>()
        .add(ContributionsEvent.get(username: username));
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
}
