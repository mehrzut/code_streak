import 'package:appwrite/models.dart';

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
