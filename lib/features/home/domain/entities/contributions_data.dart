import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contributions_data.freezed.dart';

@freezed
class ContributionsData with _$ContributionsData {
  factory ContributionsData({
    required int totalContributions,
    required List<ContributionWeekData> contributionCalendar,
  }) = _ContributionsData;

  ContributionsData._();

  factory ContributionsData.empty() =>
      ContributionsData(totalContributions: 0, contributionCalendar: []);

  ContributionDayData getDay(DateTime date) {
    /// check first day of each week and decide if the date is in that week
    /// then return the contribution day data
    for (var week in contributionCalendar) {
      if (date.difference(week.days.first.date) <= const Duration(days: 7)) {
        return week.days.firstWhere(
          (element) => element.date.isSameDayAs(date),
          orElse: () => ContributionDayData(date: date, contributionCount: 0),
        );
      }
    }
    return ContributionDayData(date: date, contributionCount: 0);
  }

  List<ContributionDayData> get allDaysContributionData =>
      contributionCalendar.expand((element) => element.days).toList();

  int get currentStreak {
    final sorted = allDaysContributionData
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );
    return sorted
        .sublist(hasContributionsToday ? 0 : 1)
        .fromStartUntil(
          (element) => element.contributionCount == 0,
        )
        .length;
  }

  bool get hasContributionsToday {
    final sorted = allDaysContributionData
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );
    final today = sorted.firstWhereOrNull(
        (element) => element.date.isSameDayAs(DateTime.now()));
    return (today?.contributionCount ?? 0) > 0;
  }
}
