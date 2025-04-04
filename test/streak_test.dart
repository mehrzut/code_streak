import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';

void main() {
  group('ContributionsData', () {
    group('currentDailyStreak', () {
      test('should return 0 when there are no contributions', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [],
          totalContributions: 0,
        );
        expect(contributionsData.currentDailyStreak, 0);
      });

      test('should return correct streak when contributions are consecutive', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [
        ContributionWeekData(days: [
          ContributionDayData(date: DateTime.now(), contributionCount: 1),
          ContributionDayData(
          date: DateTime.now().subtract(const Duration(days: 1)),
          contributionCount: 1),
          ContributionDayData(
          date: DateTime.now().subtract(const Duration(days: 2)),
          contributionCount: 1),
        ])
          ],
          totalContributions: 3,
        );
        expect(contributionsData.currentDailyStreak, 3);
      });

      test('should stop streak when the last day has no contributions', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [
        ContributionWeekData(days: [
          ContributionDayData(date: DateTime.now(), contributionCount: 1),
          ContributionDayData(
          date: DateTime.now().subtract(const Duration(days: 1)),
          contributionCount: 1),
          ContributionDayData(
          date: DateTime.now().subtract(const Duration(days: 2)),
          contributionCount: 0),
        ])
          ],
          totalContributions: 2,
        );
        expect(contributionsData.currentDailyStreak, 2);
      });

      test('should stop streak when a day has no contributions', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [
            ContributionWeekData(days: [
              ContributionDayData(date: DateTime.now(), contributionCount: 1),
              ContributionDayData(
                  date: DateTime.now().subtract(const Duration(days: 1)),
                  contributionCount: 0),
              ContributionDayData(
                  date: DateTime.now().subtract(const Duration(days: 2)),
                  contributionCount: 1),
            ])
          ],
          totalContributions: 2,
        );
        expect(contributionsData.currentDailyStreak, 1);
      });
    });

    group('currentWeeklyStreak', () {
      test('should return 0 when there are no contributions', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [],
          totalContributions: 0,
        );
        expect(contributionsData.currentWeeklyStreak, 0);
      });

      test('should return correct streak when weeks have contributions', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [
            ContributionWeekData(days: [
              ContributionDayData(date: DateTime.now(), contributionCount: 1),
            ]),
            ContributionWeekData(days: [
              ContributionDayData(
                  date: DateTime.now().subtract(const Duration(days: 7)),
                  contributionCount: 1),
            ]),
          ],
          totalContributions: 2,
        );
        expect(contributionsData.currentWeeklyStreak, 2);
      });
      test('should return 1 when there is only one contribution today', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [
        ContributionWeekData(days: [
          ContributionDayData(date: DateTime.now(), contributionCount: 1),
        ]),
          ],
          totalContributions: 1,
        );
        expect(contributionsData.currentWeeklyStreak, 1);
      });
      test('should stop streak when a week has no contributions', () {
        final contributionsData = ContributionsData(
          contributionCalendar: [
            ContributionWeekData(days: [
              ContributionDayData(date: DateTime.now(), contributionCount: 1),
            ]),
            ContributionWeekData(days: [
              ContributionDayData(
                  date: DateTime.now().subtract(const Duration(days: 7)),
                  contributionCount: 0),
            ]),
            ContributionWeekData(days: [
              ContributionDayData(
                  date: DateTime.now().subtract(const Duration(days: 14)),
                  contributionCount: 1),
            ]),
          ],
          totalContributions: 2,
        );
        expect(contributionsData.currentWeeklyStreak, 1);
      });
    });
  });
}