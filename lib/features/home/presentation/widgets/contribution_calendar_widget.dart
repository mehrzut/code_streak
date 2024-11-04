import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:flutter/material.dart';

class ContributionCalendarWidget extends StatefulWidget {
  const ContributionCalendarWidget({
    super.key,
    required this.data,
  });
  final ContributionsData data;

  @override
  State<ContributionCalendarWidget> createState() =>
      _ContributionCalendarWidgetState();
}

class _ContributionCalendarWidgetState
    extends State<ContributionCalendarWidget> {
  List<ContributionDayData> allDays = [];
  List<ContributionDayData> currentDays = [];
  int firstWeekday = 0;
  late DateTime current;

  @override
  void initState() {
    allDays = widget.data.contributionCalendar.fold(<ContributionDayData>[],
        (previousValue, element) => [...previousValue, ...element.days]);
    currentDays = getDaysWithSameMonthAs(current);
    firstWeekday = currentDays.first.date.weekday % 7;

    current = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 210,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(current.monthLengthInWeeks, (weekIndex) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (dayIndex) {
              final index = weekIndex * 7 + dayIndex;
              final i = index - firstWeekday;

              if (firstWeekday > index) {
                // previous month's days
                return const Expanded(child: SizedBox());
              }
              if (currentDays.length > i) {
                // current month's days with data
                return _DayItemWidget(data: currentDays[i]);
              }
              if (i + 1 > current.monthLengthInDays) {
                // next month's days
                return const Expanded(child: SizedBox());
              }
              // current month's days without data
              final date = currentDays.last.date
                  .add(Duration(days: i - currentDays.length + 1));
              return _DayItemWidget(
                data: ContributionDayData(date: date, contributionCount: 0),
              );
            }),
          );
        }),
      ),
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
}

class _DayItemWidget extends StatelessWidget {
  const _DayItemWidget({required this.data});

  final ContributionDayData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 30,
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(4)),
        child: Center(
          child: Text(data.date.day.toString()),
        ),
      ),
    );
  }
}
