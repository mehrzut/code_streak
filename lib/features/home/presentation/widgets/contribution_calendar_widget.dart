import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:flutter/material.dart';

class ContributionCalendarWidget extends StatefulWidget {
  const ContributionCalendarWidget({
    super.key,
    required this.data,
    required this.heatMapColor,
    required this.defaultCalendarColor,
  });
  final ContributionsData data;
  final Color heatMapColor;
  final Color defaultCalendarColor;

  @override
  State<ContributionCalendarWidget> createState() =>
      _ContributionCalendarWidgetState();
}

class _ContributionCalendarWidgetState
    extends State<ContributionCalendarWidget> {
  List<ContributionDayData> allDays = [];
  List<ContributionDayData> currentDays = [];
  int firstWeekday = 0;
  int maxContributeInCurrentPeriod = 0;
  late DateTime current;

  double get _cellSize => 40;

  @override
  void initState() {
    current = DateTime.now();
    allDays = widget.data.contributionCalendar.fold(<ContributionDayData>[],
        (previousValue, element) => [...previousValue, ...element.days]);
    currentDays = getDaysWithSameMonthAs(current);
    firstWeekday = currentDays.first.date.weekday % 7;
    maxContributeInCurrentPeriod = currentDays.fold(
        0,
        (previousValue, element) => element.contributionCount > previousValue
            ? element.contributionCount
            : previousValue);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: List.generate(
            7,
            (index) => SizedBox(
              height: _cellSize,
              child: Center(child: Text((index + 1).weekdayName())),
            ),
          ),
        ),
        ...List.generate(current.monthLengthInWeeks, (weekIndex) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (dayIndex) {
              final index = weekIndex * 7 + dayIndex;
              final i = index - firstWeekday;

              if (firstWeekday > index) {
                // previous month's days
                return SizedBox.square(dimension: _cellSize);
              }
              if (currentDays.length > i) {
                // current month's days with data
                return _DayItemWidget(
                  defaultColor: widget.defaultCalendarColor,
                  color: _getColor(currentDays, i),
                  size: Size.square(_cellSize),
                  data: currentDays[i],
                );
              }
              if (i + 1 > current.monthLengthInDays) {
                // next month's days
                SizedBox.square(dimension: _cellSize);
              }
              // current month's days without data
              final date = currentDays.last.date
                  .add(Duration(days: i - currentDays.length + 1));
              return _DayItemWidget(
                defaultColor: widget.defaultCalendarColor,
                color: widget.defaultCalendarColor,
                size: Size.square(_cellSize),
                data: ContributionDayData(date: date, contributionCount: 0),
              );
            }),
          );
        }),
      ]),
    );
  }

  List<ContributionDayData> getDaysWithSameMonthAs(DateTime other) {
    List<ContributionDayData> temp = [];
    for (int i = allDays.length - 1; i >= 0; i--) {
      if (allDays[i].date.isSameMonthAs(other)) {
        temp.insert(0, allDays[i]);
      }
    }
    return temp;
  }

  Color _getColor(List<ContributionDayData> currentDays, int i) {
    final opacity =
        currentDays[i].contributionCount / maxContributeInCurrentPeriod;
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
    return SizedBox.fromSize(
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
                color: color, borderRadius: BorderRadius.circular(4)),
            child: Center(
              child: Text(data.date.day.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
