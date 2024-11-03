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

  late DateTime current;

  @override
  void initState() {
    allDays = widget.data.contributionCalendar.fold(<ContributionDayData>[],
        (previousValue, element) => [...previousValue, ...element.days]);
    current = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 250,
      child: Row(
        children: List.generate(current.monthLengthInWeeks, (weekIndex) {
          return Expanded(
            child: Column(
              children: List.generate(7, (dayIndex) {
                final index = weekIndex * 7 + dayIndex;
                final currentDays = getDaysWithSameMonthAs(current);
                final firstWeekday = currentDays.first.date.weekday % 7;
                final i = index - firstWeekday;

                if (firstWeekday > index) {
                  // previous month's days
                  return const Expanded(child: SizedBox());
                }
                if (currentDays.length > i) {
                  // current month's days with data
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      color: Colors.red,
                      child: Center(
                        child: Text(currentDays[i].date.day.toString()),
                      ),
                    ),
                  );
                }
                if (i + 1 > current.monthLengthInDays) {
                  // next month's days
                  return const Expanded(child: SizedBox());
                }
                // current month's days without data
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    color: Colors.grey,
                    child: Center(
                      child: Text((i + 1).toString()),
                    ),
                  ),
                );
              }),
            ),
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
