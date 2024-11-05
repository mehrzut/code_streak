extension DateTimeExt on DateTime {
  bool isSameMonthAs(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool get isThisMonth {
    return isSameMonthAs(DateTime.now());
  }

  int get monthLengthInDays {
    final firstDayOfMonth = DateTime(year, month, 1);
    return firstDayOfMonth.nextMonth.difference(firstDayOfMonth).inDays;
  }

  int get monthLengthInWeeks {
    return (monthLengthInDays + 6) ~/ 7;
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
