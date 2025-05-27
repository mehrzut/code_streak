import 'dart:convert';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContributionDayData', () {
    final testDate = DateTime(2023, 1, 15);
    final contributionDayData = ContributionDayData(date: testDate, count: 5);
    final contributionDayDataZeroCount = ContributionDayData(date: testDate, count: 0);

    final Map<String, dynamic> jsonMap = {
      'date': testDate.toIso8601String(),
      'count': 5,
    };
    final Map<String, dynamic> jsonMapZeroCount = {
      'date': testDate.toIso8601String(),
      'count': 0,
    };

    test('fromJson creates correct object', () {
      final fromJson = ContributionDayData.fromJson(jsonMap);
      expect(fromJson.date, testDate);
      expect(fromJson.count, 5);

      final fromJsonZero = ContributionDayData.fromJson(jsonMapZeroCount);
      expect(fromJsonZero.date, testDate);
      expect(fromJsonZero.count, 0);
    });

    test('toJson returns correct map', () {
      final toJsonMap = contributionDayData.toJson();
      expect(toJsonMap['date'], testDate.toIso8601String());
      expect(toJsonMap['count'], 5);

      final toJsonMapZero = contributionDayDataZeroCount.toJson();
      expect(toJsonMapZero['date'], testDate.toIso8601String());
      expect(toJsonMapZero['count'], 0);
    });

    test('props are correct', () {
      expect(contributionDayData.props, [testDate, 5]);
    });

    test('instances with same data are equal', () {
      final data1 = ContributionDayData(date: testDate, count: 5);
      final data2 = ContributionDayData(date: testDate, count: 5);
      expect(data1, equals(data2));
      expect(data1.hashCode, equals(data2.hashCode));
    });

    test('instances with different data are not equal', () {
      final data1 = ContributionDayData(date: testDate, count: 5);
      final data2 = ContributionDayData(date: testDate, count: 10);
      final data3 = ContributionDayData(date: DateTime(2023, 1, 16), count: 5);
      expect(data1, isNot(equals(data2)));
      expect(data1, isNot(equals(data3)));
    });

    // Test JSON encoding/decoding for completeness
    test('JSON encoding and decoding round trip', () {
      final encoded = jsonEncode(contributionDayData.toJson());
      final decoded = ContributionDayData.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
      expect(decoded, contributionDayData);
    });
  });
}
