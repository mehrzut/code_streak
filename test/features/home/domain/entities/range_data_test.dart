import 'package:code_streak/features/home/domain/entities/range_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RangeData', () {
    final startDate = DateTime(2023, 1, 1);
    final endDate = DateTime(2023, 1, 5);
    final singleDate = DateTime(2023, 1, 10);

    group('RangeData.range()', () {
      test('creates range with correct start and end', () {
        final range = RangeData.range(from: startDate, till: endDate);
        range.when(
          range: (from, till) {
            expect(from, startDate);
            expect(till, endDate);
          },
          empty: () => fail('Should not be empty'),
        );
        expect(range.start, startDate);
        expect(range.end, endDate);
      });

      test('creates range with single date if from and till are same', () {
        final range = RangeData.range(from: singleDate, till: singleDate);
        range.when(
          range: (from, till) {
            expect(from, singleDate);
            expect(till, singleDate);
          },
          empty: () => fail('Should not be empty'),
        );
         expect(range.start, singleDate);
        expect(range.end, singleDate);
      });

      test('throws assertion error if from is after till', () {
        expect(() => RangeData.range(from: endDate, till: startDate), throwsA(isA<AssertionError>()));
      });
    });

    group('RangeData.empty()', () {
      test('creates an empty range', () {
        final emptyRange = RangeData.empty();
        emptyRange.when(
          range: (from, till) => fail('Should be empty'),
          empty: () {
            // Correct path
          },
        );
        expect(emptyRange.start, isNull);
        expect(emptyRange.end, isNull);
        expect(emptyRange.dates, isEmpty);
      });
    });

    group('dates getter', () {
      test('returns correct list of dates for a multi-day range', () {
        final range = RangeData.range(from: startDate, till: endDate);
        final expectedDates = [
          DateTime(2023, 1, 1),
          DateTime(2023, 1, 2),
          DateTime(2023, 1, 3),
          DateTime(2023, 1, 4),
          DateTime(2023, 1, 5),
        ];
        expect(range.dates, expectedDates);
      });

      test('returns list with single date for a single-day range', () {
        final range = RangeData.range(from: singleDate, till: singleDate);
        expect(range.dates, [singleDate]);
      });

      test('returns empty list for an empty range', () {
        final emptyRange = RangeData.empty();
        expect(emptyRange.dates, isEmpty);
      });
    });

    group('start getter', () {
      test('returns correct start date for a range', () {
        final range = RangeData.range(from: startDate, till: endDate);
        expect(range.start, startDate);
      });
      test('returns null for an empty range', () {
        final emptyRange = RangeData.empty();
        expect(emptyRange.start, isNull);
      });
    });

    group('end getter', () {
      test('returns correct end date for a range', () {
        final range = RangeData.range(from: startDate, till: endDate);
        expect(range.end, endDate);
      });
      test('returns null for an empty range', () {
        final emptyRange = RangeData.empty();
        expect(emptyRange.end, isNull);
      });
    });
  });
}
