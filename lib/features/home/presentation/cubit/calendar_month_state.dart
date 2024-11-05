part of 'calendar_month_cubit.dart';

@freezed
class CalendarMonthState with _$CalendarMonthState {
  factory CalendarMonthState({
    required DateTime current,
    required List<ContributionDayData> allDaysContributionData,
  }) = _CalendarMonthState;

  CalendarMonthState._();

  List<ContributionDayData> get currentDays => getDaysWithSameMonthAs(current);
  int get firstWeekday => (current.firstDayOfMonth.weekday - 1) % 7;
  int get maxContributeInCurrentPeriod => currentDays.fold(
      0,
      (previousValue, element) => element.contributionCount > previousValue
          ? element.contributionCount
          : previousValue);

  List<ContributionDayData> getDaysWithSameMonthAs(DateTime other) {
    List<ContributionDayData> temp = [];
    for (int i = allDaysContributionData.length - 1; i >= 0; i--) {
      if (allDaysContributionData[i].date.isSameMonthAs(other)) {
        temp.insert(0, allDaysContributionData[i]);
      }
    }
    return temp;
  }
}
