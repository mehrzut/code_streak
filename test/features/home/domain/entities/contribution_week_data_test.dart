import 'dart:convert';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContributionWeekData', () {
    final today = DateTime.now();
    final day1 = ContributionDayData(date: today.subtract(Duration(days: today.weekday % 7)), count: 1); // Sunday
    final day2 = ContributionDayData(date: day1.date.add(const Duration(days: 1)), count: 2); // Monday
    final day3 = ContributionDayData(date: day1.date.add(const Duration(days: 2)), count: 3); // Tuesday
    final day4 = ContributionDayData(date: day1.date.add(const Duration(days: 3)), count: 0); // Wednesday (incomplete)
    final day5 = ContributionDayData(date: day1.date.add(const Duration(days: 4)), count: 5); // Thursday
    final day6 = ContributionDayData(date: day1.date.add(const Duration(days: 5)), count: 6); // Friday
    final day7 = ContributionDayData(date: day1.date.add(const Duration(days: 6)), count: 7); // Saturday

    final completeWeekDays = [day1, day2, day3, day5, day6, day7, ContributionDayData(date: day4.date, count: 4)]; // day4 now complete
    final incompleteWeekDays = [day1, day2, day3, day4, day5, day6, day7]; // day4 has 0 count

    final completeWeek = ContributionWeekData(days: completeWeekDays);
    final incompleteWeekByCount = ContributionWeekData(days: incompleteWeekDays);
    final incompleteWeekByMissingDays = ContributionWeekData(days: [day1, day2, day3]); // Missing days

    final Map<String, dynamic> jsonMapComplete = {
      'days': completeWeekDays.map((d) => d.toJson()).toList(),
    };

    test('fromJson creates correct object', () {
      final fromJson = ContributionWeekData.fromJson(jsonMapComplete);
      expect(fromJson.days.length, 7);
      expect(fromJson.days.first.date, completeWeekDays.first.date);
      expect(fromJson.days.first.count, completeWeekDays.first.count);
      expect(fromJson.days.last.date, completeWeekDays.last.date);
      expect(fromJson.days.last.count, completeWeekDays.last.count);
    });

    test('toJson returns correct map', () {
      final toJsonMap = completeWeek.toJson();
      expect(toJsonMap['days'], isA<List>());
      expect((toJsonMap['days'] as List).length, 7);
      expect((toJsonMap['days'] as List).first, completeWeekDays.first.toJson());
    });

    group('isComplete getter', () {
      test('returns true if all 7 days are present AND have count > 0', () {
        expect(completeWeek.isComplete, isTrue);
      });
      test('returns false if any day has count == 0', () {
        expect(incompleteWeekByCount.isComplete, isFalse);
      });
      test('returns false if not all 7 days are present', () {
        expect(incompleteWeekByMissingDays.isComplete, isFalse);
      });
      test('returns false for empty days list', () {
        expect(ContributionWeekData(days: []).isComplete, isFalse);
      });
    });

    group('firstDay getter', () {
      test('returns first day if days list is not empty', () {
        expect(completeWeek.firstDay, day1);
      });
      test('throws StateError if days list is empty', () {
        expect(() => ContributionWeekData(days: []).firstDay, throwsStateError);
      });
    });

    group('lastDay getter', () {
      test('returns last day if days list is not empty', () {
        expect(completeWeek.lastDay, completeWeekDays.last);
      });
      test('throws StateError if days list is empty', () {
        expect(() => ContributionWeekData(days: []).lastDay, throwsStateError);
      });
    });
    
    test('props are correct', () {
      expect(completeWeek.props, [completeWeekDays]);
    });

    test('instances with same data are equal', () {
      final week1 = ContributionWeekData(days: List.from(completeWeekDays));
      final week2 = ContributionWeekData(days: List.from(completeWeekDays));
      expect(week1, equals(week2));
      expect(week1.hashCode, equals(week2.hashCode));
    });

    test('instances with different data are not equal', () {
      final week1 = ContributionWeekData(days: completeWeekDays);
      final week2 = ContributionWeekData(days: incompleteWeekDays);
      expect(week1, isNot(equals(week2)));
    });

    test('JSON encoding and decoding round trip', () {
      final encoded = jsonEncode(completeWeek.toJson());
      final decoded = ContributionWeekData.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
      expect(decoded.days.length, completeWeek.days.length);
      for(int i=0; i<decoded.days.length; i++){
        expect(decoded.days[i], completeWeek.days[i]);
      }
      expect(decoded, completeWeek);
    });
  });
}
