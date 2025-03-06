import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContributionsData.getNotExistingRange', () {
    test('returns missing range for last day when all dates exist', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 7);

      // Create a complete list of days.
      final days = List.generate(7, (i) {
        final date = start.add(Duration(days: i));
        return ContributionDayData(date: date, contributionCount: i + 1);
      });
      final week = ContributionWeekData(days: days);
      final contributions = ContributionsData(
          totalContributions:
              days.fold(0, (sum, day) => sum + day.contributionCount),
          contributionCalendar: [week]);

      // Even though every day exists, the last day is treated as incomplete.
      final missingRange = contributions.getNotExistingRange(start, end);
      expect(missingRange.start, DateTime(2022, 1, 7));
      expect(missingRange.end, DateTime(2022, 1, 7));
    });

    test(
        'returns missing range including last day when a single day is missing',
        () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 7);

      // Create days with one missing day (2022-01-04)
      // Note: 2022-01-07 is provided but should be included as missing.
      final days = [
        ContributionDayData(date: DateTime(2022, 1, 1), contributionCount: 1),
        ContributionDayData(date: DateTime(2022, 1, 2), contributionCount: 2),
        ContributionDayData(date: DateTime(2022, 1, 3), contributionCount: 3),
        // Missing 2022-01-04.
        ContributionDayData(date: DateTime(2022, 1, 5), contributionCount: 5),
        ContributionDayData(date: DateTime(2022, 1, 6), contributionCount: 6),
        ContributionDayData(date: DateTime(2022, 1, 7), contributionCount: 7),
      ];
      final week = ContributionWeekData(days: days);
      final contributions = ContributionsData(
          totalContributions:
              days.fold(0, (sum, day) => sum + day.contributionCount),
          contributionCalendar: [week]);

      final missingRange = contributions.getNotExistingRange(start, end);
      // Expected missing dates: 2022-01-04 (gap) and 2022-01-07 (incomplete day).
      expect(missingRange.start, DateTime(2022, 1, 4));
      expect(missingRange.end, DateTime(2022, 1, 7));
    });

    test('returns missing range for multiple gaps including last day', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 10);

      // Create days with gaps:
      // - Missing 2022-01-03.
      // - Missing 2022-01-08 and 2022-01-09.
      // - 2022-01-10 is present but considered incomplete.
      final days = [
        ContributionDayData(date: DateTime(2022, 1, 1), contributionCount: 1),
        ContributionDayData(date: DateTime(2022, 1, 2), contributionCount: 2),
        // Missing 2022-01-03.
        ContributionDayData(date: DateTime(2022, 1, 4), contributionCount: 4),
        ContributionDayData(date: DateTime(2022, 1, 5), contributionCount: 5),
        ContributionDayData(date: DateTime(2022, 1, 6), contributionCount: 6),
        ContributionDayData(date: DateTime(2022, 1, 7), contributionCount: 7),
        // Missing 2022-01-08 and 2022-01-09.
        ContributionDayData(date: DateTime(2022, 1, 10), contributionCount: 10),
      ];
      final week = ContributionWeekData(days: days);
      final contributions = ContributionsData(
          totalContributions:
              days.fold(0, (sum, day) => sum + day.contributionCount),
          contributionCalendar: [week]);

      final missingRange = contributions.getNotExistingRange(start, end);
      // Expected missing range: from first missing (2022-01-03)
      // to last day (2022-01-10) which is included even if present.
      expect(missingRange.start, DateTime(2022, 1, 3));
      expect(missingRange.end, DateTime(2022, 1, 10));
    });

    test('returns full range when no data is available', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 7);

      final contributions = ContributionsData(
        totalContributions: 0,
        contributionCalendar: [],
      );

      final missingRange = contributions.getNotExistingRange(start, end);
      expect(missingRange.start, start);
      expect(missingRange.end, end);
    });

    test('returns only last day missing when all days are present', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 7);

      final days = List.generate(7, (i) {
        final date = start.add(Duration(days: i));
        return ContributionDayData(date: date, contributionCount: i + 1);
      });
      final week = ContributionWeekData(days: days);
      final contributions = ContributionsData(
        totalContributions: days.fold(0, (sum, d) => sum + d.contributionCount),
        contributionCalendar: [week],
      );

      // Even though every day exists, the last day (Jan 7) is considered incomplete.
      final missingRange = contributions.getNotExistingRange(start, end);
      expect(missingRange.start, end);
      expect(missingRange.end, end);
    });

    test('returns missing range from a gap in the middle to the last day', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 7);

      // Create data with a gap on Jan 3.
      final days = [
        ContributionDayData(date: DateTime(2022, 1, 1), contributionCount: 1),
        ContributionDayData(date: DateTime(2022, 1, 2), contributionCount: 2),
        // Missing Jan 3.
        ContributionDayData(date: DateTime(2022, 1, 4), contributionCount: 4),
        ContributionDayData(date: DateTime(2022, 1, 5), contributionCount: 5),
        ContributionDayData(date: DateTime(2022, 1, 6), contributionCount: 6),
        ContributionDayData(
            date: DateTime(2022, 1, 7),
            contributionCount: 7), // present but treated as incomplete
      ];
      final week = ContributionWeekData(days: days);
      final contributions = ContributionsData(
        totalContributions: days.fold(0, (sum, d) => sum + d.contributionCount),
        contributionCalendar: [week],
      );

      final missingRange = contributions.getNotExistingRange(start, end);
      // Expected missing dates: the missing Jan 3 plus Jan 7 (always missing), so range from Jan 3 to Jan 7.
      expect(missingRange.start, DateTime(2022, 1, 3));
      expect(missingRange.end, DateTime(2022, 1, 7));
    });

    test('returns single day missing when start equals end', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 1);

      // Even if the data for the day exists, it is considered incomplete.
      final days = [
        ContributionDayData(date: start, contributionCount: 5),
      ];
      final week = ContributionWeekData(days: days);
      final contributions = ContributionsData(
        totalContributions: 5,
        contributionCalendar: [week],
      );

      final missingRange = contributions.getNotExistingRange(start, end);
      expect(missingRange.start, start);
      expect(missingRange.end, end);
    });

    test('returns continuous missing range over multiple weeks with gaps', () {
      final start = DateTime(2022, 1, 1);
      final end = DateTime(2022, 1, 14);

      // Simulate two weeks of data with gaps:
      // - Week 1 (Jan 1-7): Missing Jan 3.
      // - Week 2 (Jan 8-14): Missing Jan 10; Jan 14 is always considered incomplete.
      final week1Days = [
        ContributionDayData(date: DateTime(2022, 1, 1), contributionCount: 1),
        ContributionDayData(date: DateTime(2022, 1, 2), contributionCount: 2),
        // Missing Jan 3.
        ContributionDayData(date: DateTime(2022, 1, 4), contributionCount: 4),
        ContributionDayData(date: DateTime(2022, 1, 5), contributionCount: 5),
        ContributionDayData(date: DateTime(2022, 1, 6), contributionCount: 6),
        ContributionDayData(date: DateTime(2022, 1, 7), contributionCount: 7),
      ];
      final week2Days = [
        ContributionDayData(date: DateTime(2022, 1, 8), contributionCount: 8),
        ContributionDayData(date: DateTime(2022, 1, 9), contributionCount: 9),
        // Missing Jan 10.
        ContributionDayData(date: DateTime(2022, 1, 11), contributionCount: 11),
        ContributionDayData(date: DateTime(2022, 1, 12), contributionCount: 12),
        ContributionDayData(date: DateTime(2022, 1, 13), contributionCount: 13),
        ContributionDayData(
            date: DateTime(2022, 1, 14),
            contributionCount: 14), // present but considered incomplete
      ];

      final contributions = ContributionsData(
        totalContributions: [...week1Days, ...week2Days]
            .fold(0, (sum, d) => sum + d.contributionCount),
        contributionCalendar: [
          ContributionWeekData(days: week1Days),
          ContributionWeekData(days: week2Days),
        ],
      );

      final missingRange = contributions.getNotExistingRange(start, end);
      // The earliest missing day is Jan 3, and the last is Jan 14 (always missing), so we expect [Jan 3, Jan 14].
      expect(missingRange.start, DateTime(2022, 1, 3));
      expect(missingRange.end, DateTime(2022, 1, 14));
    });
    
  });
}
