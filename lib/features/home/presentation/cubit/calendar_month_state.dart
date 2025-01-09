part of 'calendar_month_cubit.dart';

@freezed
class CalendarMonthState with _$CalendarMonthState {
  factory CalendarMonthState({
    required DateTime current,
    required List<ContributionDayData> allDaysContributionData,
  }) = _CalendarMonthState;

  CalendarMonthState._();


}
