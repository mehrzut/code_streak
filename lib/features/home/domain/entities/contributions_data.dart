import 'package:code_streak/common/typedefs.dart';
import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:code_streak/features/home/domain/entities/range_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contributions_data.freezed.dart';
part 'contributions_data.g.dart';

@freezed
class ContributionsData with _$ContributionsData {
  @JsonSerializable(explicitToJson: true)
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

  factory ContributionsData.fromJson(Json json) =>
      _$ContributionsDataFromJson(json);

  ContributionsData append(ContributionsData? newData) {
    if (newData == null) return this;
    // Combine all days from current and new data
    final allDays = [
      ...allDaysContributionData,
      ...newData.allDaysContributionData
    ];

    // Use a map to remove duplicates, keeping the highest contribution count
    final dayMap = <DateTime, ContributionDayData>{};
    for (var day in allDays) {
      final existing = dayMap[day.date];
      if (existing == null ||
          day.contributionCount > existing.contributionCount) {
        dayMap[day.date] = day;
      }
    }

    // Sort days by date
    final sortedDays = dayMap.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    // Group days into weeks
    final weeks = <ContributionWeekData>[];
    var currentWeek = <ContributionDayData>[];
    DateTime? currentWeekStart;

    for (var day in sortedDays) {
      final weekStart = day.date.startOfWeek;
      if (currentWeekStart == null || weekStart != currentWeekStart) {
        if (currentWeek.isNotEmpty) {
          weeks.add(ContributionWeekData(days: currentWeek));
        }
        currentWeek = [];
        currentWeekStart = weekStart;
      }
      currentWeek.add(day);
    }

    if (currentWeek.isNotEmpty) {
      weeks.add(ContributionWeekData(days: currentWeek));
    }

    // Calculate total contributions
    final totalContributions = sortedDays.fold<int>(
      0,
      (sum, day) => sum + day.contributionCount,
    );

    return ContributionsData(
      totalContributions: totalContributions,
      contributionCalendar: weeks,
    );
  }

  bool hasRange(DateTime start, DateTime end) {
    final dates = allDaysContributionData.map((e) => e.date).toList();
    dates.sort(
      (a, b) => a.compareTo(b),
    );
    final split = dates.splitWhere(
      (element) => element.isSameDayAs(start) || element.isSameDayAs(end),
    );
    final range = split.length == 3 ? split[1] : [];
    final actualRangeInDays = start.difference(end).inDays;
    return range.length == actualRangeInDays;
  }

  RangeData getNotExistingRange(DateTime start, DateTime end) {
    final dates = allDaysContributionData.map((e) => e.date).toList();
    dates.sort(
      (a, b) => a.compareTo(b),
    );
    final startDate =
        RangeData.range(start: start.tomorrow, end: end).dates.firstWhereOrNull(
              (element) => !dates.contains(element),
            );
    final endDate =
        RangeData.range(start: start.tomorrow, end: end).dates.lastWhereOrNull(
              (element) => !dates.contains(element),
            );
    if (startDate == null || endDate == null) {
      return RangeData.empty();
    } else {
      return RangeData.range(start: startDate, end: endDate);
    }
  }

  ContributionsData get withoutToday {
    final today = allDaysContributionData.lastWhereOrNull(
      (element) => element.date.isSameDayAs(DateTime.now()),
    );
    if (today == null) {
      return this;
    } else {
      return copyWith(
          totalContributions: totalContributions - today.contributionCount,
          contributionCalendar: [
            ...contributionCalendar.sublist(0, contributionCalendar.length - 1),
            contributionCalendar.last.copyWith(days: [
              ...contributionCalendar.last.days
                  .sublist(0, contributionCalendar.last.days.length - 1)
            ]),
          ]);
    }
  }
}
