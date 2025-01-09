import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/presentation/cubit/calendar_month_cubit.dart';
import 'package:code_streak/features/home/presentation/widgets/calendar_month_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContributionCalendarWidget extends StatelessWidget {
  const ContributionCalendarWidget(
      {super.key,
      required this.data,
      required this.heatMapColor,
      required this.defaultCalendarColor});
  final ContributionsData data;
  final Color heatMapColor;
  final Color defaultCalendarColor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarMonthCubit(data.contributionCalendar.fold(
          <ContributionDayData>[],
          (previousValue, element) => [...previousValue, ...element.days])),
      child: _ContributionCalendarWidget(
        data: data,
        defaultCalendarColor: defaultCalendarColor,
        heatMapColor: heatMapColor,
      ),
    );
  }
}

class _ContributionCalendarWidget extends StatefulWidget {
  const _ContributionCalendarWidget({
    required this.data,
    required this.heatMapColor,
    required this.defaultCalendarColor,
  });
  final ContributionsData data;
  final Color heatMapColor;
  final Color defaultCalendarColor;

  @override
  State<_ContributionCalendarWidget> createState() =>
      _ContributionCalendarWidgetState();
}

class _ContributionCalendarWidgetState
    extends State<_ContributionCalendarWidget> {
  static const _initIndex = 50;
  final _pageController = PageController(initialPage: _initIndex);

  @override
  void initState() {
    _pageController.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _monthControllerWidget,
          _daysWidget,
        ],
      ),
    );
  }

  Widget get _monthControllerWidget =>
      BlocBuilder<CalendarMonthCubit, CalendarMonthState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () =>
                        context.read<CalendarMonthCubit>().previousMonth(),
                    icon: const Icon(Icons.chevron_left)),
                AnimatedSwitcher(
                  duration: Durations.medium2,
                  child: Text(
                    state.current.monthNameYearString,
                    key: ValueKey(state.current),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                    onPressed: () =>
                        context.read<CalendarMonthCubit>().nextMonth(),
                    icon: const Icon(Icons.chevron_right)),
              ],
            ),
          );
        },
      );

  Widget get _daysWidget => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: LayoutBuilder(builder: (context, constraints) {
          return BlocBuilder<CalendarMonthCubit, CalendarMonthState>(
            builder: (context, state) {
              final cellSize = constraints.biggest.width / 7;
              return SizedBox(
                height: cellSize * 7,
                child: Row(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          return CalendarMonthWidget(
                            allDaysContributionData:
                                state.allDaysContributionData,
                            month: state.current
                                .goMonthsForwardOrBackward(_initIndex - index),
                            defaultCalendarColor: widget.defaultCalendarColor,
                            heatMapColor: widget.heatMapColor,
                          );
                        },
                        onPageChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      );

  void _pageListener() {
    if (_pageController.page != null &&
        _pageController.page == _pageController.page?.toInt().toDouble()) {
      context.read<CalendarMonthCubit>().goMonthsForwardOrBackward(
          _initIndex - _pageController.page!.toInt());
      _pageController.jumpToPage(_initIndex);
    }
  }
}
