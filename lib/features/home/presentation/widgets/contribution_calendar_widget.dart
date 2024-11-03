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
    current = DateTime(2024, 10, 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 250,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: current.monthLengthInWeeks * 7,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemBuilder: (context, index) {
          final currentDays = getDaysWithSameMonthAs(current);
          final firstWeekday = currentDays.first.date.weekday % 7;
          final i = index - firstWeekday;
          if (firstWeekday > index) {
            // previous month's days
            return const SizedBox();
          }
          if (currentDays.length > i) {
            // current month's days with data
            return Container(
              margin: const EdgeInsets.all(2),
              color: Colors.red,
              child: Text(currentDays[i].date.day.toString()),
            );
          }
          if (i + 1 > currentDays.length) {
            // next month's days
            return const SizedBox();
          }
          // current month's days without data
          return Container(
            margin: const EdgeInsets.all(2),
            color: Colors.grey,
            child: Text((i + 1).toString()),
          );
        },
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
