import 'package:code_streak/common/typedefs.dart';
import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:code_streak/features/home/domain/entities/range_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:math' as math;
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

  int get currentDailyStreak {
    final sorted = allDaysContributionData
      ..sort(
        (a, b) => b.date.compareTo(a.date),
      );
    final startIndex = hasContributionsToday ? 0 : 1;
    return sorted
        .sublist(startIndex, startIndex + math.min(sorted.length - 1, 365))
        .fromStartUntil(
          (element) => element.contributionCount == 0,
        )
        .length;
  }

  int get mostContributeInADayInPastYear {
    // Ensure the list is sorted by date (ascending)
    final sorted = allDaysContributionData
      ..sort((a, b) => a.date.compareTo(b.date));

    // If the list is empty, return 0
    if (sorted.isEmpty) {
      return 0;
    }

    // Calculate the index to start searching from (364 days ago)
    final startIndex = math.max(0, sorted.length - 365);

    // Extract the last 365 days (or fewer if the list is shorter)
    final lastYearContributions = sorted.sublist(startIndex);

    // Find the maximum contribution count in the past year
    return lastYearContributions
        .map((day) => day.contributionCount)
        .reduce((a, b) => math.max(a, b));
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

  bool get hasContributionsThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.startOfWeek;
    final endOfWeek = now.endOfWeek;
    return allDaysContributionData.any((day) =>
        day.date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        day.date.isBefore(endOfWeek.add(const Duration(days: 1))) &&
        day.contributionCount > 0);
  }

  int get currentWeeklyStreak {
    final sortedWeeks = [...contributionCalendar]
      ..sort((a, b) => b.days.first.date.compareTo(a.days.first.date));
    int streak = 0;
    for (var week in sortedWeeks) {
      if (week.days.any((day) => day.contributionCount > 0)) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  int get totalContributionsInPastYear {
    final now = DateTime.now();
    final oneYearAgo = now.subtract(const Duration(days: 365)).zeroHour;
    return allDaysContributionData
        .where((day) => day.date.isAfter(oneYearAgo) && day.date.isBefore(now))
        .fold<int>(0, (sum, day) => sum + day.contributionCount);
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
      (element) =>
          element.isSameDayAs(start) || element.isSameDayAs(end.tomorrow),
    );
    final range = split.length == 3 ? split[1] : [];
    final actualRangeInDays = start.difference(end).inDays.abs() + 1;
    return range.length == actualRangeInDays;
  }

  RangeData getNotExistingRange(DateTime start, DateTime end) {
    final expectedDates = RangeData.range(start: start, end: end).dates;
    final actualDates = allDaysContributionData.map((e) => e.date).toList();
    actualDates.sort((a, b) => a.compareTo(b));
    // Remove the end date to consider it incomplete.
    if (actualDates.contains(end)) {
      actualDates.remove(end);
    }
    final missingDates =
        expectedDates.where((date) => !actualDates.contains(date)).toList();
    if (missingDates.isEmpty) {
      return RangeData.empty();
    } else {
      return RangeData.range(start: missingDates.first, end: missingDates.last);
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
