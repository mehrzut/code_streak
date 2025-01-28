import 'package:appwrite/models.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:flutter/material.dart';

extension DateTimeExt on DateTime {
  bool isSameMonthAs(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool get isThisMonth {
    return isSameMonthAs(DateTime.now());
  }

  int get monthLengthInDays {
    return firstDayOfMonth.nextMonth.difference(firstDayOfMonth).inDays;
  }

  DateTime get firstDayOfMonth => DateTime(year, month, 1);

  DateTime get lastDayOfMonth => DateTime(year, month, monthLengthInDays);

  int get monthLengthInWeeks {
    return ((monthLengthInDays + firstDayOfMonth.weekday - 1) ~/ 7) + 1;
  }

  bool isSameDayAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isToday {
    return isSameDayAs(DateTime.now());
  }

  DateTime get nextMonth {
    if (month <= 11) {
      return DateTime(year, month + 1, day);
    } else {
      return DateTime(year + 1, 1, day);
    }
  }

  DateTime get previousMonth {
    if (month > 1) {
      return DateTime(year, month - 1, day);
    } else {
      return DateTime(year - 1, 12, day);
    }
  }

  DateTime monthsBefore(int n) {
    DateTime t = this;
    for (int i = 0; i < n; i++) {
      t = t.previousMonth;
    }
    return t;
  }

  DateTime goMonthsForwardOrBackward(int n) {
    if (n == 0) {
      return this;
    } else if (n < 0) {
      return monthsBefore(n.abs());
    } else {
      return monthsAfter(n);
    }
  }

  DateTime monthsAfter(int n) {
    DateTime t = this;
    for (int i = 0; i < n; i++) {
      t = t.nextMonth;
    }
    return t;
  }

  String get monthNameYearString {
    return '$monthName $year';
  }

  String get monthName {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  int get firstWeekdayOfMonth => (firstDayOfMonth.weekday - 1) % 7;
  int maxContributeInMonth(List<ContributionDayData> allDaysContributionData) =>
      getContributionDaysOfMonth(allDaysContributionData).fold(
          0,
          (previousValue, element) => element.contributionCount > previousValue
              ? element.contributionCount
              : previousValue);

  List<ContributionDayData> getContributionDaysOfMonth(
      List<ContributionDayData> allDaysContributionData) {
    List<ContributionDayData> temp = [];
    for (int i = allDaysContributionData.length - 1; i >= 0; i--) {
      if (allDaysContributionData[i].date.isSameMonthAs(this)) {
        temp.insert(0, allDaysContributionData[i]);
      }
    }
    return temp;
  }

  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime get endOfWeek {
    return add(Duration(days: DateTime.daysPerWeek - weekday));
  }

  DateTime get zeroHour => DateTime(year, month, day, 0, 0, 0, 0, 0);

  DateTime get yesterday => subtract(const Duration(days: 1)).zeroHour;

  DateTime get tomorrow => add(const Duration(days: 1)).zeroHour;
}

extension IntExt on int {
  String weekdayName() {
    switch (this) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}

extension SessionExt on Session {
  bool get isExpired {
    var currentTime = DateTime.now().toUtc();
    var expiryTime = DateTime.parse(providerAccessTokenExpiry);
    return currentTime.isAfter(expiryTime);
  }
}

extension IterableWidgetExt on Iterable<Widget> {
  List<Widget> verticalPadding(
    double px, {
    bool addToEnd = false,
    bool addToStart = false,
  }) {
    return putSeparator(
      SizedBox(
        height: px,
      ),
      addToStart: addToStart,
      addToEnd: addToEnd,
    );
  }

  List<Widget> horizontalPadding(
    double px, {
    bool addToEnd = false,
    bool addToStart = false,
  }) {
    return putSeparator(
      SizedBox(
        width: px,
      ),
      addToStart: addToStart,
      addToEnd: addToEnd,
    );
  }

  List<Widget> putSeparator(Widget separator,
      {bool addToEnd = false, bool addToStart = false}) {
    final List<Widget> items = [];
    for (int i = 0; i < length; i++) {
      if (addToStart && i == 0) {
        items.add(separator);
      }
      items.add(elementAt(i));
      if (addToEnd || i < length - 1) {
        items.add(separator);
      }
    }
    return items;
  }
}

extension NullableListExt<T> on List<T>? {
  bool get isNullOrEmpty {
    if (this == null) return true;
    return this!.isEmpty;
  }

  bool get isNotNullOrEmpty {
    return !isNullOrEmpty;
  }
}

extension ListExt<T> on List<T> {
  List<List<T>> splitAt(int index) {
    return [sublist(0, index), sublist(index)];
  }

  List<List<T>> splitAtNotContaining(int index) {
    return [sublist(0, index), sublist(index + 1)];
  }

  List<List<T>> splitWhere(bool Function(T element) condition) {
    List<List<T>> list = [];
    int previousItemIndex = 0;
    for (int i = 0; i < length; i++) {
      if (condition(elementAt(i))) {
        list.add(sublist(previousItemIndex, i));
        previousItemIndex = i;
      }
    }
    list.add(sublist(previousItemIndex));
    return list;
  }

  List<T> fromStartUntil(bool Function(T element) condition) {
    for (int i = 0; i < length; i++) {
      if (condition(elementAt(i))) {
        return sublist(0, i);
      }
    }
    return this;
  }

  List<T> addOrUpdateWhere(
    bool Function(T e) condition,
    T Function(T? e) updatedItemGenerator,
  ) {
    if (any((e) => condition(e))) {
      return map((e) => condition(e) ? updatedItemGenerator(e) : e).toList();
    } else {
      return [...this, updatedItemGenerator(null)];
    }
  }

  T? firstWhereOrNull(bool Function(T element) condition) {
    try {
      return firstWhere(condition);
    } catch (e) {
      return null;
    }
  }

  T? lastWhereOrNull(bool Function(T element) condition) {
    try {
      return lastWhere(condition);
    } catch (e) {
      return null;
    }
  }
}

extension NullableString on String? {
  bool get isNullOrEmpty {
    if (this == null) return true;
    return this!.isEmpty;
  }

  bool get isNotNullOrEmpty {
    return !isNullOrEmpty;
  }

  String? get nullOnEmpty => isNullOrEmpty ? null : this;
}
