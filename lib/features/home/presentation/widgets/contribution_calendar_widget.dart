import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/presentation/cubit/calendar_month_cubit.dart';
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
    super.key,
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
  double get _cellSize => 40;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
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
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () =>
                        context.read<CalendarMonthCubit>().previousMonth(),
                    icon: const Icon(Icons.arrow_back)),
                Text(
                  state.current.monthNameYearString,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                    onPressed: () =>
                        context.read<CalendarMonthCubit>().nextMonth(),
                    icon: const Icon(Icons.arrow_forward)),
              ],
            ),
          );
        },
      );

  Widget get _daysWidget => BlocBuilder<CalendarMonthCubit, CalendarMonthState>(
        builder: (context, state) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Column(
              children: List.generate(
                7,
                (index) => Container(
                  height: _cellSize,
                  width: _cellSize,
                  padding: const EdgeInsets.all(2),
                  child: Center(
                      child: Text(
                    (index + 1).weekdayName(),
                    style: Theme.of(context).textTheme.labelLarge,
                  )),
                ),
              ),
            ),
            ...List.generate(state.current.monthLengthInWeeks, (weekIndex) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(7, (dayIndex) {
                  final index = weekIndex * 7 + dayIndex;
                  final i = index - state.firstWeekday;

                  if (state.firstWeekday > index) {
                    // previous month's days
                    return SizedBox.square(dimension: _cellSize);
                  }
                  if (state.currentDays.length > i) {
                    // current month's days with data
                    return _DayItemWidget(
                      defaultColor: widget.defaultCalendarColor,
                      color: _getColor(state.currentDays, i,
                          state.maxContributeInCurrentPeriod),
                      size: Size.square(_cellSize),
                      data: state.currentDays[i],
                    );
                  }
                  if (i + 1 > state.current.monthLengthInDays) {
                    // next month's days
                    return SizedBox.square(dimension: _cellSize);
                  }
                  // current month's days without data
                  final date = (state.currentDays.isNotEmpty
                          ? state.currentDays.last.date
                          : state.current.previousMonth.lastDayOfMonth)
                      .add(Duration(days: i - state.currentDays.length + 1));
                  return _DayItemWidget(
                    defaultColor: widget.defaultCalendarColor,
                    color: widget.defaultCalendarColor,
                    size: Size.square(_cellSize),
                    data: ContributionDayData(date: date, contributionCount: 0),
                  );
                }),
              );
            }),
          ]);
        },
      );

  Color _getColor(List<ContributionDayData> currentDays, int i,
      int maxContributeInCurrentPeriod) {
    final opacity = maxContributeInCurrentPeriod != 0
        ? currentDays[i].contributionCount / maxContributeInCurrentPeriod
        : 0.0;
    return widget.heatMapColor.withOpacity(opacity);
  }
}

class _DayItemWidget extends StatelessWidget {
  const _DayItemWidget(
      {required this.data,
      required this.color,
      required this.defaultColor,
      required this.size});
  final Color color;
  final Color defaultColor;
  final ContributionDayData data;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          '${data.contributionCount} contribution${data.contributionCount == 1 ? '' : 's'}',
      triggerMode: TooltipTriggerMode.tap,
      child: SizedBox.fromSize(
        size: size,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: defaultColor, borderRadius: BorderRadius.circular(4)),
            ),
            Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: data.date.isToday
                    ? Border.all(
                        color: Theme.of(context).colorScheme.onTertiary,
                        width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  data.date.day.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
