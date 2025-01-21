import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:flutter/material.dart';

class CalendarMonthWidget extends StatelessWidget {
  const CalendarMonthWidget(
      {super.key,
      required this.allDaysContributionData,
      required this.month,
      required this.heatMapColor,
      required this.defaultCalendarColor,
      required this.cellSize});
  final List<ContributionDayData> allDaysContributionData;
  final DateTime month;
  final Color heatMapColor;
  final Color defaultCalendarColor;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            7,
            (index) => Container(
              height: cellSize,
              width: cellSize,
              padding: const EdgeInsets.all(2),
              child: RotatedBox(
                quarterTurns: 3,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      (index + 1).weekdayName(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSecondaryFixed,
                          ),
                    )),
              ),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (weekIndex) {
            final thisMonthContributionDays =
                month.getContributionDaysOfMonth(allDaysContributionData);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(7, (dayIndex) {
                final index = weekIndex * 7 + dayIndex;
                final i = index - month.firstWeekdayOfMonth;

                if (month.firstWeekdayOfMonth > index) {
                  // previous month's days
                  return SizedBox.square(
                      dimension: cellSize,
                      child: Center(
                        child: Text(
                          month.firstDayOfMonth
                              .subtract(Duration(
                                  days: month.firstWeekdayOfMonth - index))
                              .day
                              .toString(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryFixed,
                                  ),
                        ),
                      ));
                }
                if (thisMonthContributionDays.length > i) {
                  // current month's days with data
                  return _DayItemWidget(
                    defaultColor: defaultCalendarColor,
                    color: _getColor(thisMonthContributionDays, i,
                        month.maxContributeInMonth(allDaysContributionData)),
                    size: Size.square(cellSize),
                    data: thisMonthContributionDays[i],
                  );
                }
                if (i + 1 > month.monthLengthInDays) {
                  // next month's days
                  return SizedBox.square(
                      dimension: cellSize,
                      child: Center(
                        child: Text(
                          month.lastDayOfMonth
                              .add(Duration(
                                  days: index -
                                      month.monthLengthInDays -
                                      month.firstWeekdayOfMonth +
                                      1))
                              .day
                              .toString(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondaryFixed,
                                  ),
                        ),
                      ));
                }
                // current month's days without data
                final date = (thisMonthContributionDays.isNotEmpty
                        ? thisMonthContributionDays.last.date
                        : month.previousMonth.lastDayOfMonth)
                    .add(Duration(
                        days: i - thisMonthContributionDays.length + 1));
                return _DayItemWidget(
                  defaultColor: defaultCalendarColor,
                  color: defaultCalendarColor,
                  size: Size.square(cellSize),
                  data: ContributionDayData(date: date, contributionCount: 0),
                );
              }),
            );
          }),
        ),
      ],
    );
  }

  Color _getColor(List<ContributionDayData> currentDays, int i,
      int maxContributeInCurrentPeriod) {
    final opacity = maxContributeInCurrentPeriod != 0
        ? currentDays[i].contributionCount / maxContributeInCurrentPeriod
        : 0.0;
    return heatMapColor.withOpacity(opacity);
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
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: defaultColor, borderRadius: BorderRadius.circular(4)),
            ),
            Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
                border: data.date.isToday
                    ? Border.all(
                        color: Theme.of(context).colorScheme.onPrimary,
                        width: 1)
                    : null,
              ),
              child: Center(
                child: Text(
                  data.date.day.toString(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
