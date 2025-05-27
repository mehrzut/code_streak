import 'dart:convert';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/range_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContributionsData', () {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final twoDaysAgo = today.subtract(const Duration(days: 2));
    final tomorrow = today.add(const Duration(days: 1));
    final oneYearAgo = today.subtract(const Duration(days: 365));
    final moreThanOneYearAgo = today.subtract(const Duration(days: 400));

    final day1 = ContributionDayData(date: twoDaysAgo, count: 1);
    final day2 = ContributionDayData(date: yesterday, count: 2);
    final day3 = ContributionDayData(date: today, count: 3);
    final dayOld = ContributionDayData(date: moreThanOneYearAgo, count: 10);
    final dayOneYearAgo = ContributionDayData(date: oneYearAgo, count: 5);


    final contributions = [day1, day2, day3, dayOld, dayOneYearAgo];
    final contributionsData = ContributionsData(contributions: contributions);
    final emptyContributionsData = ContributionsData.empty();

    test('ContributionsData.empty() constructor', () {
      expect(emptyContributionsData.contributions, isEmpty);
      expect(emptyContributionsData.totalContributions, 0);
      expect(emptyContributionsData.streaks.currentStreak, 0);
      expect(emptyContributionsData.streaks.longestStreak, 0);
      expect(emptyContributionsData.lastContributionDate, isNull);
    });

    group('getDay()', () {
      test('returns data when date is present', () {
        expect(contributionsData.getDay(today), day3);
        expect(contributionsData.getDay(yesterday), day2);
      });
      test('returns null when date is absent', () {
        expect(contributionsData.getDay(tomorrow), isNull);
        expect(contributionsData.getDay(DateTime(2000, 1, 1)), isNull);
      });
      test('returns null for empty data', () {
        expect(emptyContributionsData.getDay(today), isNull);
      });
    });

    test('allDaysContributionData getter', () {
      // The getter sorts the contributions by date.
      final sortedContributions = List<ContributionDayData>.from(contributions)..sort((a, b) => a.date.compareTo(b.date));
      expect(contributionsData.allDaysContributionData, equals(sortedContributions));
      expect(emptyContributionsData.allDaysContributionData, isEmpty);
    });

    group('mostContributeInADayInPastYear', () {
      test('with empty data', () {
        expect(emptyContributionsData.mostContributeInADayInPastYear, 0);
      });
      test('with data within year', () {
        // dayOld (10) is more than one year ago.
        // dayOneYearAgo (5) is exactly one year ago (inclusive).
        // day3 (3) is today.
        // day2 (2) is yesterday.
        // day1 (1) is two days ago.
        // Expected max is 5 from dayOneYearAgo.
        expect(contributionsData.mostContributeInADayInPastYear, 5);
      });
      test('with only older data', () {
        final oldDataOnly = ContributionsData(contributions: [dayOld]);
        expect(oldDataOnly.mostContributeInADayInPastYear, 0);
      });
       test('with all data recent', () {
        final recentData = ContributionsData(contributions: [day1, day2, day3]);
        expect(recentData.mostContributeInADayInPastYear, 3);
      });
    });

    group('hasContributionsToday', () {
      test('returns true if contributions exist for today', () {
        expect(contributionsData.hasContributionsToday, isTrue);
      });
      test('returns false if no contributions for today', () {
        final noTodayData = ContributionsData(contributions: [day1, day2]);
        expect(noTodayData.hasContributionsToday, isFalse);
      });
      test('returns false for empty data', () {
        expect(emptyContributionsData.hasContributionsToday, isFalse);
      });
    });

    group('hasContributionsThisWeek', () {
      // This depends on what "this week" means (e.g., Sun-Sat or Mon-Sun)
      // Assuming DateTimeExt.startOfWeek and endOfWeek are correct (tested elsewhere)
      test('returns true if contributions exist within this week', () {
        // If today is Wednesday, and there's a contribution on Monday, it's true.
        // day1, day2, day3 are all recent and likely this week.
        expect(contributionsData.hasContributionsThisWeek, isTrue);
      });
      test('returns false if no contributions this week', () {
        final veryOldData = ContributionsData(contributions: [
          ContributionDayData(date: today.subtract(const Duration(days: 30)), count: 5)
        ]);
        expect(veryOldData.hasContributionsThisWeek, isFalse);
      });
       test('returns false for empty data', () {
        expect(emptyContributionsData.hasContributionsThisWeek, isFalse);
      });
    });

    test('totalContributionsInPastYear', () {
      // dayOld (10) is excluded.
      // dayOneYearAgo (5) is included.
      // day3 (3), day2 (2), day1 (1) are included.
      // Total = 5 + 3 + 2 + 1 = 11
      expect(contributionsData.totalContributionsInPastYear, 11);
      expect(emptyContributionsData.totalContributionsInPastYear, 0);
    });

    group('append()', () {
      final initialData = ContributionsData(contributions: [
        ContributionDayData(date: DateTime(2023, 1, 1), count: 1),
        ContributionDayData(date: DateTime(2023, 1, 2), count: 2),
      ]);

      test('adds new data', () {
        final newData = ContributionsData(contributions: [
          ContributionDayData(date: DateTime(2023, 1, 3), count: 3),
        ]);
        final appended = initialData.append(newData);
        expect(appended.contributions.length, 3);
        expect(appended.getDay(DateTime(2023, 1, 3))?.count, 3);
      });

      test('merges overlapping data (new data overrides count)', () {
        final overlappingNewData = ContributionsData(contributions: [
          ContributionDayData(date: DateTime(2023, 1, 2), count: 5), // Overlaps
          ContributionDayData(date: DateTime(2023, 1, 4), count: 4),
        ]);
        final appended = initialData.append(overlappingNewData);
        expect(appended.contributions.length, 3); // (1,1), (1,2 new), (1,4)
        expect(appended.getDay(DateTime(2023, 1, 1))?.count, 1);
        expect(appended.getDay(DateTime(2023, 1, 2))?.count, 5); // Updated count
        expect(appended.getDay(DateTime(2023, 1, 4))?.count, 4);
      });

      test('with empty new data, returns original', () {
        final appended = initialData.append(ContributionsData.empty());
        expect(appended.contributions.length, 2);
        expect(appended, initialData); // Should be identical or equal
      });
      
      test('appending to empty data', () {
        final newData = ContributionsData(contributions: [
          ContributionDayData(date: DateTime(2023, 1, 5), count: 10)
        ]);
        final appended = emptyContributionsData.append(newData);
        expect(appended.contributions.length, 1);
        expect(appended.getDay(DateTime(2023, 1, 5))?.count, 10);
      });
    });

    group('hasRange()', () {
      final dataForRange = ContributionsData(contributions: [
        ContributionDayData(date: DateTime(2023, 1, 10), count: 1),
        ContributionDayData(date: DateTime(2023, 1, 11), count: 1),
        ContributionDayData(date: DateTime(2023, 1, 12), count: 1),
        ContributionDayData(date: DateTime(2023, 1, 14), count: 1), // Gap on 13th
      ]);

      test('fully present range', () {
        final range = RangeData.range(from: DateTime(2023, 1, 10), till: DateTime(2023, 1, 12));
        expect(dataForRange.hasRange(range), isTrue);
      });
      test('partially present range (gap within)', () {
        final range = RangeData.range(from: DateTime(2023, 1, 10), till: DateTime(2023, 1, 14));
        expect(dataForRange.hasRange(range), isFalse); // Because 13th is missing
      });
      test('partially present range (extends beyond existing data at end)', () {
        final range = RangeData.range(from: DateTime(2023, 1, 11), till: DateTime(2023, 1, 13)); // 13th missing
        expect(dataForRange.hasRange(range), isFalse);
      });
       test('partially present range (extends beyond existing data at start)', () {
        final range = RangeData.range(from: DateTime(2023, 1, 9), till: DateTime(2023, 1, 11)); // 9th missing
        expect(dataForRange.hasRange(range), isFalse);
      });
      test('absent range (completely outside)', () {
        final range = RangeData.range(from: DateTime(2023, 2, 1), till: DateTime(2023, 2, 5));
        expect(dataForRange.hasRange(range), isFalse);
      });
       test('absent range (within a larger gap of existing data)', () {
        final range = RangeData.range(from: DateTime(2023, 1, 13), till: DateTime(2023, 1, 13));
        expect(dataForRange.hasRange(range), isFalse);
      });
      test('empty range', () {
        expect(dataForRange.hasRange(RangeData.empty()), isTrue); // Empty range is always "present"
      });
      test('empty contributions data with non-empty range', () {
        final range = RangeData.range(from: DateTime(2023,1,1), till: DateTime(2023,1,1));
        expect(emptyContributionsData.hasRange(range), isFalse);
      });
       test('empty contributions data with empty range', () {
        expect(emptyContributionsData.hasRange(RangeData.empty()), isTrue);
      });
    });

    group('withoutToday()', () {
      test('removes today contribution if present', () {
        expect(contributionsData.getDay(today), isNotNull);
        final withoutTodayData = contributionsData.withoutToday();
        expect(withoutTodayData.getDay(today), isNull);
        expect(withoutTodayData.contributions.length, contributionsData.contributions.length - 1);
      });
      test('returns same data if today is not present', () {
        final noTodayData = ContributionsData(contributions: [day1, day2]);
        expect(noTodayData.getDay(today), isNull);
        final withoutTodayData = noTodayData.withoutToday();
        expect(withoutTodayData.contributions.length, noTodayData.contributions.length);
        expect(withoutTodayData, noTodayData); // Should be equal or identical
      });
      test('on empty data', () {
        final result = emptyContributionsData.withoutToday();
        expect(result.contributions, isEmpty);
      });
    });

    group('fromJson/toJson', () {
      // Test structure includes Streaks, ActiveDays which have their own fromJson/toJson
      // We rely on those being correct and test the overall ContributionsData structure.
      final fullData = ContributionsData(
        totalContributions: 100,
        streaks: Streaks(
            currentStreak: 10,
            longestStreak: 20,
            currentStreakStartDate: DateTime(2023,1,1),
            longestStreakStartDate: DateTime(2022,12,1),
            longestStreakEndDate: DateTime(2022,12,20),
        ),
        lastContributionDate: DateTime(2023,1,10),
        activeDays: const ActiveDays(monday: true, tuesday: false, wednesday: true, thursday: false, friday: true, saturday: false, sunday: true),
        contributionDays: [
          ContributionDayData(date: DateTime(2023,1,10), count: 5),
          ContributionDayData(date: DateTime(2023,1,9), count: 3),
        ]
      );

      test('full data serialization and deserialization', () {
        final json = fullData.toJson();
        final deserialized = ContributionsData.fromJson(json);

        expect(deserialized.totalContributions, fullData.totalContributions);
        expect(deserialized.streaks.currentStreak, fullData.streaks.currentStreak);
        expect(deserialized.streaks.longestStreak, fullData.streaks.longestStreak);
        expect(deserialized.streaks.currentStreakStartDate, fullData.streaks.currentStreakStartDate);
        expect(deserialized.streaks.longestStreakStartDate, fullData.streaks.longestStreakStartDate);
        expect(deserialized.streaks.longestStreakEndDate, fullData.streaks.longestStreakEndDate);
        expect(deserialized.lastContributionDate, fullData.lastContributionDate);
        expect(deserialized.activeDays, fullData.activeDays);
        expect(deserialized.contributionDays.length, fullData.contributionDays.length);
        // Deep equality check for contributionDays
        for(int i=0; i < deserialized.contributionDays.length; i++){
            expect(deserialized.contributionDays[i], fullData.contributionDays[i]);
        }
        // Check overall equality (if Equatable is correctly implemented for all nested objects)
        // This might require Streaks and ActiveDays to also correctly implement Equatable/Freezed
         expect(deserialized, equals(fullData));
      });

      test('empty data serialization and deserialization', () {
        final json = emptyContributionsData.toJson();
        final deserialized = ContributionsData.fromJson(json);
        expect(deserialized.totalContributions, 0);
        expect(deserialized.streaks.currentStreak, 0);
        expect(deserialized.contributionDays, isEmpty);
        expect(deserialized, equals(emptyContributionsData));
      });
    });
  });
}
