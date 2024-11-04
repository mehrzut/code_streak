extension DateTimeExt on DateTime {
  bool isSameMonthAs(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool get isThisMonth {
    return isSameMonthAs(DateTime.now());
  }

  int get monthLengthInDays {
    return DateTime(year, month + 1, 1)
        .difference(DateTime(year, month, 1))
        .inDays;
  }

  int get monthLengthInWeeks {
    return (monthLengthInDays + 6) ~/ 7;
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
