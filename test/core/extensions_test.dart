import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/contributions/data/models/contributions_model.dart'; // For ContributionDayData
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appwrite/models.dart' as appwrite_models;

void main() {
  group('DateTimeExt', () {
    final refDate = DateTime(2023, 10, 15, 12, 30, 0); // Sunday

    group('isSameMonthAs', () {
      test('returns true for same month and year', () {
        expect(refDate.isSameMonthAs(DateTime(2023, 10, 1)), isTrue);
      });
      test('returns false for different month, same year', () {
        expect(refDate.isSameMonthAs(DateTime(2023, 11, 15)), isFalse);
      });
      test('returns false for same month, different year', () {
        expect(refDate.isSameMonthAs(DateTime(2022, 10, 15)), isFalse);
      });
    });

    group('isThisMonth', () {
      // Requires mocking DateTime.now() or careful test setup.
      // For simplicity, we'll test its logic against a known "now".
      final now = DateTime.now();
      test('returns true if date is in current month', () {
        expect(now.isThisMonth, isTrue);
        expect(DateTime(now.year, now.month, 1).isThisMonth, isTrue);
      });
      test('returns false if date is not in current month', () {
        expect(now.nextMonth.isThisMonth, isFalse);
        expect(now.previousMonth.isThisMonth, isFalse);
      });
    });

    group('isSameDayAs', () {
      test('returns true for same day, month, and year', () {
        expect(refDate.isSameDayAs(DateTime(2023, 10, 15, 0, 0, 0)), isTrue);
      });
      test('returns false for different day', () {
        expect(refDate.isSameDayAs(DateTime(2023, 10, 16)), isFalse);
      });
      test('returns false for different month', () {
        expect(refDate.isSameDayAs(DateTime(2023, 11, 15)), isFalse);
      });
      test('returns false for different year', () {
        expect(refDate.isSameDayAs(DateTime(2022, 10, 15)), isFalse);
      });
    });

    group('isToday', () {
      // Similar to isThisMonth, relies on DateTime.now()
      final now = DateTime.now();
      test('returns true if date is today', () {
        expect(now.isToday, isTrue);
      });
      test('returns false if date is not today', () {
        expect(refDate.isToday, refDate.isSameDayAs(now)); // Check against a fixed date
        expect(now.add(const Duration(days: 1)).isToday, isFalse);
        expect(now.subtract(const Duration(days: 1)).isToday, isFalse);
      });
    });

    group('monthLengthInDays', () {
      test('February non-leap year', () {
        expect(DateTime(2023, 2, 1).monthLengthInDays, 28);
      });
      test('February leap year', () {
        expect(DateTime(2024, 2, 1).monthLengthInDays, 29);
      });
      test('30-day month (April)', () {
        expect(DateTime(2023, 4, 1).monthLengthInDays, 30);
      });
      test('31-day month (January)', () {
        expect(DateTime(2023, 1, 1).monthLengthInDays, 31);
      });
    });

    group('firstDayOfMonth', () {
      test('returns correct first day', () {
        expect(refDate.firstDayOfMonth, DateTime(2023, 10, 1));
      });
    });

    group('lastDayOfMonth', () {
      test('returns correct last day for October (31 days)', () {
        expect(refDate.lastDayOfMonth, DateTime(2023, 10, 31));
      });
      test('returns correct last day for February non-leap (28 days)', () {
        expect(DateTime(2023, 2, 15).lastDayOfMonth, DateTime(2023, 2, 28));
      });
       test('returns correct last day for February leap (29 days)', () {
        expect(DateTime(2024, 2, 15).lastDayOfMonth, DateTime(2024, 2, 29));
      });
    });
    
    group('monthLengthInWeeks', () {
      // October 2023 starts on Sunday (day 7), ends on Tuesday.
      // Sun Mon Tue Wed Thu Fri Sat
      // 1   2   3   4   5   6   7   -> Week 1
      // 8   9  10  11  12  13  14  -> Week 2
      // 15 16  17  18  19  20  21  -> Week 3
      // 22 23  24  25  26  27  28  -> Week 4
      // 29 30  31                  -> Week 5
      test('October 2023 should be 5 weeks', () {
        expect(DateTime(2023, 10, 1).monthLengthInWeeks, 5);
      });
      // February 2023 starts on Wednesday (day 3), 28 days.
      // Sun Mon Tue Wed Thu Fri Sat
      //           1   2   3   4   -> Week 1
      // 5   6   7   8   9  10  11  -> Week 2
      // 12 13  14  15  16  17  18  -> Week 3
      // 19 20  21  22  23  24  25  -> Week 4
      // 26 27  28                  -> Week 5
      test('February 2023 should be 5 weeks', () {
        expect(DateTime(2023, 2, 1).monthLengthInWeeks, 5);
      });
      // May 2023 starts on Monday (day 1), 31 days.
      // Sun Mon Tue Wed Thu Fri Sat
      //     1   2   3   4   5   6   -> Week 1
      // ...
      // 28 29  30  31              -> Week 5
      test('May 2023 should be 5 weeks', () {
        expect(DateTime(2023, 5, 1).monthLengthInWeeks, 5);
      });
      // September 2023 starts on Friday (day 5), 30 days.
      // Sun Mon Tue Wed Thu Fri Sat
      //                   1   2   -> Week 1
      // ...
      // 24 25  26  27  28  29  30  -> Week 5
      test('September 2023 should be 5 weeks', () {
        expect(DateTime(2023, 9, 1).monthLengthInWeeks, 5);
      });
       // April 2023 starts on Saturday (day 6), 30 days
       // It will take 6 weeks in a calendar view where Sunday is the first day of the week
      test('April 2023 should be 6 weeks', () {
        expect(DateTime(2023, 4, 1).monthLengthInWeeks, 6);
      });
    });

    group('nextMonth', () {
      test('normal case', () {
        expect(refDate.nextMonth, DateTime(2023, 11, 15));
      });
      test('year boundary (December to January)', () {
        expect(DateTime(2023, 12, 15).nextMonth, DateTime(2024, 1, 15));
      });
    });

    group('previousMonth', () {
      test('normal case', () {
        expect(refDate.previousMonth, DateTime(2023, 9, 15));
      });
      test('year boundary (January to December)', () {
        expect(DateTime(2023, 1, 15).previousMonth, DateTime(2022, 12, 15));
      });
    });
    
    group('monthsBefore', () {
      test('positive n', () {
        expect(refDate.monthsBefore(2), DateTime(2023, 8, 15));
      });
      test('zero n', () {
        expect(refDate.monthsBefore(0), refDate);
      });
      test('negative n (should behave like monthsAfter)', () {
        expect(refDate.monthsBefore(-2), DateTime(2023, 12, 15));
      });
      test('year boundary', () {
        expect(DateTime(2023, 2, 15).monthsBefore(3), DateTime(2022, 11, 15));
      });
    });

    group('monthsAfter', () {
      test('positive n', () {
        expect(refDate.monthsAfter(2), DateTime(2023, 12, 15));
      });
      test('zero n', () {
        expect(refDate.monthsAfter(0), refDate);
      });
      test('negative n (should behave like monthsBefore)', () {
        expect(refDate.monthsAfter(-2), DateTime(2023, 8, 15));
      });
      test('year boundary', () {
        expect(DateTime(2023, 11, 15).monthsAfter(3), DateTime(2024, 2, 15));
      });
    });

    group('goMonthsForwardOrBackward', () {
      test('positive months', () {
        expect(refDate.goMonthsForwardOrBackward(3), DateTime(2024, 1, 15));
      });
      test('negative months', () {
        expect(refDate.goMonthsForwardOrBackward(-3), DateTime(2023, 7, 15));
      });
      test('zero months', () {
        expect(refDate.goMonthsForwardOrBackward(0), refDate);
      });
    });

    group('monthNameYearString', () {
      test('October 2023', () {
        expect(refDate.monthNameYearString, 'October 2023');
      });
      test('January 2022', () {
        expect(DateTime(2022, 1, 5).monthNameYearString, 'January 2022');
      });
    });

    group('monthName', () {
      test('October', () {
        expect(refDate.monthName, 'October');
      });
      test('January', () {
        expect(DateTime(2023, 1, 5).monthName, 'January');
      });
    });

    group('firstWeekdayOfMonth', () {
      test('October 2023 starts on Sunday (7)', () {
        expect(DateTime(2023, 10, 1).firstWeekdayOfMonth, 7); // Sunday
      });
      test('November 2023 starts on Wednesday (3)', () {
        expect(DateTime(2023, 11, 1).firstWeekdayOfMonth, 3); // Wednesday
      });
      test('May 2023 starts on Monday (1)', () {
        expect(DateTime(2023, 5, 1).firstWeekdayOfMonth, 1); // Monday
      });
    });

    group('Contribution related extensions', () {
      final contribList = [
        ContributionDayData(date: DateTime(2023, 10, 1), count: 1),
        ContributionDayData(date: DateTime(2023, 10, 15), count: 5),
        ContributionDayData(date: DateTime(2023, 10, 16), count: 3),
        ContributionDayData(date: DateTime(2023, 9, 30), count: 2), // Different month
        ContributionDayData(date: DateTime(2023, 10, 31), count: 10),
      ];

      group('maxContributeInMonth', () {
        test('with contributions in month', () {
          expect(refDate.maxContributeInMonth(contribList), 10);
        });
        test('with no contributions in month', () {
          final emptyMonthList = [
            ContributionDayData(date: DateTime(2023, 9, 1), count: 5),
          ];
          expect(refDate.maxContributeInMonth(emptyMonthList), 0);
        });
        test('with empty contribution list', () {
          expect(refDate.maxContributeInMonth([]), 0);
        });
         test('with null contribution list', () {
          expect(refDate.maxContributeInMonth(null), 0);
        });
      });

      group('getContributionDaysOfMonth', () {
        test('with contributions in month', () {
          final result = refDate.getContributionDaysOfMonth(contribList);
          expect(result.length, 4);
          expect(result.any((c) => c.date.isSameDayAs(DateTime(2023, 10, 1))), isTrue);
          expect(result.any((c) => c.date.isSameDayAs(DateTime(2023, 10, 15))), isTrue);
          expect(result.any((c) => c.date.isSameDayAs(DateTime(2023, 10, 16))), isTrue);
          expect(result.any((c) => c.date.isSameDayAs(DateTime(2023, 10, 31))), isTrue);
        });
        test('with no contributions in month', () {
           final emptyMonthList = [
            ContributionDayData(date: DateTime(2023, 9, 1), count: 5),
          ];
          expect(refDate.getContributionDaysOfMonth(emptyMonthList), isEmpty);
        });
        test('with empty contribution list', () {
          expect(refDate.getContributionDaysOfMonth([]), isEmpty);
        });
         test('with null contribution list', () {
          expect(refDate.getContributionDaysOfMonth(null), isEmpty);
        });
      });
    });

    group('startOfWeek', () {
      test('date is Sunday', () {
        expect(DateTime(2023, 10, 15).startOfWeek, DateTime(2023, 10, 15)); // Sunday
      });
      test('date is Monday', () {
        expect(DateTime(2023, 10, 16).startOfWeek, DateTime(2023, 10, 15)); // Prev Sunday
      });
      test('date is Saturday', () {
        expect(DateTime(2023, 10, 21).startOfWeek, DateTime(2023, 10, 15)); // Prev Sunday
      });
       test('date at beginning of month, different week', () {
        expect(DateTime(2023, 10, 1).startOfWeek, DateTime(2023, 10, 1)); // Sunday
        expect(DateTime(2023, 11, 1).startOfWeek, DateTime(2023, 10, 29)); // Nov 1 is Wed, start of week is Oct 29 (Sun)
      });
    });

    group('endOfWeek', () {
      test('date is Sunday', () {
        expect(DateTime(2023, 10, 15).endOfWeek, DateTime(2023, 10, 21)); // Saturday
      });
      test('date is Monday', () {
        expect(DateTime(2023, 10, 16).endOfWeek, DateTime(2023, 10, 21)); // Saturday
      });
      test('date is Saturday', () {
        expect(DateTime(2023, 10, 21).endOfWeek, DateTime(2023, 10, 21)); // Saturday
      });
      test('date at end of month, different week', () {
        expect(DateTime(2023, 10, 31).endOfWeek, DateTime(2023, 11, 4)); // Oct 31 is Tue, end of week is Nov 4 (Sat)
      });
    });

    group('zeroHour', () {
      test('sets time components to zero', () {
        final dt = DateTime(2023, 10, 15, 12, 30, 45, 123, 456);
        final zeroed = dt.zeroHour;
        expect(zeroed.year, 2023);
        expect(zeroed.month, 10);
        expect(zeroed.day, 15);
        expect(zeroed.hour, 0);
        expect(zeroed.minute, 0);
        expect(zeroed.second, 0);
        expect(zeroed.millisecond, 0);
        expect(zeroed.microsecond, 0);
      });
    });

    group('yesterday', () {
      test('normal case', () {
        expect(refDate.yesterday, DateTime(2023, 10, 14, 12, 30, 0));
      });
      test('start of month', () {
        expect(DateTime(2023, 10, 1).yesterday, DateTime(2023, 9, 30));
      });
      test('start of year', () {
        expect(DateTime(2023, 1, 1).yesterday, DateTime(2022, 12, 31));
      });
    });

    group('tomorrow', () {
      test('normal case', () {
        expect(refDate.tomorrow, DateTime(2023, 10, 16, 12, 30, 0));
      });
      test('end of month', () {
        expect(DateTime(2023, 10, 31).tomorrow, DateTime(2023, 11, 1));
      });
      test('end of year', () {
        expect(DateTime(2023, 12, 31).tomorrow, DateTime(2024, 1, 1));
      });
    });
  });

  group('IntExt', () {
    group('weekdayName', () {
      test('valid weekdays', () {
        expect(1.weekdayName(), 'Mon');
        expect(2.weekdayName(), 'Tue');
        expect(3.weekdayName(), 'Wed');
        expect(4.weekdayName(), 'Thu');
        expect(5.weekdayName(), 'Fri');
        expect(6.weekdayName(), 'Sat');
        expect(7.weekdayName(), 'Sun');
      });
      test('invalid weekdays', () {
        expect(0.weekdayName(), '');
        expect(8.weekdayName(), '');
        expect((-1).weekdayName(), '');
      });
    });
  });

  group('SessionExt', () {
    // Helper to create a Session object
    appwrite_models.Session createSession(String expiryIsoString) {
      return appwrite_models.Session(
        $id: 'test_session_id',
        userId: 'test_user_id',
        expire: DateTime.now().toIso8601String(), // This is 'current' time, not used by isExpired
        provider: 'email',
        providerUid: 'test@example.com',
        providerAccessToken: 'test_access_token',
        providerAccessTokenExpiry: expiryIsoString, // The crucial field
        providerRefreshToken: 'test_refresh_token',
        ip: '127.0.0.1',
        osCode: 'TestOS',
        osName: 'TestOS',
        osVersion: '1.0',
        clientType: 'app',
        clientCode: 'com.test',
        clientName: 'TestApp',
        clientVersion: '1.0.0',
        clientEngine: 'TestEngine',
        clientEngineVersion: '1.0',
        deviceName: 'TestDevice',
        deviceBrand: 'TestBrand',
        deviceModel: 'TestModel',
        countryCode: 'XX',
        countryName: 'Testland',
        current: true,
        factors: [],
        secret: 'secret',
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
      );
    }

    group('isExpired', () {
      test('returns false for future expiry date', () {
        final futureExpiry = DateTime.now().add(const Duration(hours: 1)).toIso8601String();
        final session = createSession(futureExpiry);
        expect(session.isExpired, isFalse);
      });

      test('returns true for past expiry date', () {
        final pastExpiry = DateTime.now().subtract(const Duration(hours: 1)).toIso8601String();
        final session = createSession(pastExpiry);
        expect(session.isExpired, isTrue);
      });

      test('returns true for expiry date very close to now (just passed)', () {
        final veryRecentPastExpiry = DateTime.now().subtract(const Duration(seconds: 1)).toIso8601String();
        final session = createSession(veryRecentPastExpiry);
        expect(session.isExpired, isTrue);
      });
      
      test('returns false for expiry date very close to now (just future)', () {
        final veryNearFutureExpiry = DateTime.now().add(const Duration(seconds: 5)).toIso8601String();
        final session = createSession(veryNearFutureExpiry);
        expect(session.isExpired, isFalse);
      });
    });
  });

  group('IterableWidgetExt', () {
    final List<Widget> testWidgets = [
      const Text('Item 1'),
      const Text('Item 2'),
      const Text('Item 3'),
    ];
    final emptyWidgets = <Widget>[];

    group('verticalPadding', () {
      test('with empty list', () {
        expect(emptyWidgets.verticalPadding(10), isEmpty);
      });
      test('with non-empty list, addToStart=false, addToEnd=false', () {
        final result = testWidgets.verticalPadding(10);
        expect(result.length, 5); // 3 items + 2 SizedBox
        expect(result[0], isA<Text>());
        expect(result[1], isA<SizedBox>());
        expect((result[1] as SizedBox).height, 10);
        expect(result[2], isA<Text>());
        expect(result[3], isA<SizedBox>());
        expect((result[3] as SizedBox).height, 10);
        expect(result[4], isA<Text>());
      });
      test('with non-empty list, addToStart=true, addToEnd=true', () {
        final result = testWidgets.verticalPadding(10, addToStart: true, addToEnd: true);
        expect(result.length, 7); // 2 SizedBox (ends) + 3 items + 2 SizedBox (internal)
        expect(result[0], isA<SizedBox>());
        expect((result[0] as SizedBox).height, 10);
        expect(result[1], isA<Text>());
        expect(result[2], isA<SizedBox>());
        expect(result[6], isA<SizedBox>());
        expect((result[6] as SizedBox).height, 10);
      });
    });

    group('horizontalPadding', () {
       test('with empty list', () {
        expect(emptyWidgets.horizontalPadding(5), isEmpty);
      });
      test('with non-empty list, addToStart=false, addToEnd=false', () {
        final result = testWidgets.horizontalPadding(5);
        expect(result.length, 5); // 3 items + 2 SizedBox
        expect(result[0], isA<Text>());
        expect(result[1], isA<SizedBox>());
        expect((result[1] as SizedBox).width, 5);
      });
      test('with non-empty list, addToStart=true, addToEnd=true', () {
        final result = testWidgets.horizontalPadding(5, addToStart: true, addToEnd: true);
        expect(result.length, 7); 
        expect(result[0], isA<SizedBox>());
        expect((result[0] as SizedBox).width, 5);
        expect(result[6], isA<SizedBox>());
        expect((result[6] as SizedBox).width, 5);
      });
    });

    group('putSeparator', () {
      const separator = Divider();
       test('with empty list', () {
        expect(emptyWidgets.putSeparator(separator), isEmpty);
      });
      test('with non-empty list, addToStart=false, addToEnd=false', () {
        final result = testWidgets.putSeparator(separator);
        expect(result.length, 5); // 3 items + 2 Dividers
        expect(result[0], isA<Text>());
        expect(result[1], isA<Divider>());
      });
       test('with non-empty list, addToStart=true, addToEnd=true', () {
        final result = testWidgets.putSeparator(separator, addToStart: true, addToEnd: true);
        expect(result.length, 7); 
        expect(result[0], isA<Divider>());
        expect(result[6], isA<Divider>());
      });
    });
  });

  group('NullableListExt', () {
    group('isNullOrEmpty', () {
      test('returns true for null list', () {
        List<int>? list;
        expect(list.isNullOrEmpty, isTrue);
      });
      test('returns true for empty list', () {
        final List<int> list = [];
        expect(list.isNullOrEmpty, isTrue);
      });
      test('returns false for non-empty list', () {
        final List<int> list = [1];
        expect(list.isNullOrEmpty, isFalse);
      });
    });
    group('isNotNullOrEmpty', () {
      test('returns false for null list', () {
        List<int>? list;
        expect(list.isNotNullOrEmpty, isFalse);
      });
      test('returns false for empty list', () {
        final List<int> list = [];
        expect(list.isNotNullOrEmpty, isFalse);
      });
      test('returns true for non-empty list', () {
        final List<int> list = [1];
        expect(list.isNotNullOrEmpty, isTrue);
      });
    });
  });

  group('ListExt', () {
    group('addOrUpdateWhere', () {
      test('updates existing element', () {
        final list = [MockItem(1, 'A'), MockItem(2, 'B')];
        list.addOrUpdateWhere((item) => item.id == 1, MockItem(1, 'Updated A'));
        expect(list.length, 2);
        expect(list.firstWhere((e) => e.id == 1).value, 'Updated A');
      });
      test('adds new element if not found', () {
        final list = [MockItem(1, 'A'), MockItem(2, 'B')];
        list.addOrUpdateWhere((item) => item.id == 3, MockItem(3, 'C'));
        expect(list.length, 3);
        expect(list.firstWhere((e) => e.id == 3).value, 'C');
      });
      test('adds to empty list', () {
        final list = <MockItem>[];
        list.addOrUpdateWhere((item) => item.id == 1, MockItem(1, 'A'));
        expect(list.length, 1);
        expect(list.first.value, 'A');
      });
    });

    group('firstWhereOrNull', () {
      final list = [1, 2, 3, 4, 2];
      test('element found', () {
        expect(list.firstWhereOrNull((e) => e == 2), 2);
      });
      test('element not found', () {
        expect(list.firstWhereOrNull((e) => e == 5), isNull);
      });
      test('empty list', () {
        expect(<int>[].firstWhereOrNull((e) => e == 1), isNull);
      });
    });
    
    group('lastWhereOrNull', () {
      final list = [1, 2, 3, 4, 2, 5];
      test('element found (last one)', () {
        // To ensure it's the last one, we can check its position or use a more complex object
        final objList = [MockItem(1,'a'), MockItem(2,'b1'), MockItem(2,'b2')];
        expect(objList.lastWhereOrNull((e) => e.id == 2)?.value, 'b2');
      });
      test('element not found', () {
        expect(list.lastWhereOrNull((e) => e == 6), isNull);
      });
      test('empty list', () {
        expect(<int>[].lastWhereOrNull((e) => e == 1), isNull);
      });
    });
  });

  group('NullableString', () {
    group('isNullOrEmpty', () {
      test('returns true for null string', () {
        String? str;
        expect(str.isNullOrEmpty, isTrue);
      });
      test('returns true for empty string', () {
        String str = "";
        expect(str.isNullOrEmpty, isTrue);
      });
      test('returns false for non-empty string', () {
        String str = "test";
        expect(str.isNullOrEmpty, isFalse);
      });
    });

    group('isNotNullOrEmpty', () {
      test('returns false for null string', () {
        String? str;
        expect(str.isNotNullOrEmpty, isFalse);
      });
      test('returns false for empty string', () {
        String str = "";
        expect(str.isNotNullOrEmpty, isFalse);
      });
      test('returns true for non-empty string', () {
        String str = "test";
        expect(str.isNotNullOrEmpty, isTrue);
      });
    });

    group('nullOnEmpty', () {
      test('returns null for null string', () {
        String? str;
        expect(str.nullOnEmpty, isNull);
      });
      test('returns null for empty string', () {
        String str = "";
        expect(str.nullOnEmpty, isNull);
      });
      test('returns string for non-empty string', () {
        String str = "test";
        expect(str.nullOnEmpty, "test");
      });
    });
  });
}

class MockItem {
  final int id;
  String value;
  MockItem(this.id, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockItem && runtimeType == other.runtimeType && id == other.id && value == other.value;

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}
