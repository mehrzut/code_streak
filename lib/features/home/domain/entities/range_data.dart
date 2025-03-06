import 'package:code_streak/core/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'range_data.freezed.dart';

@freezed
class RangeData with _$RangeData {
  factory RangeData.range({
    required DateTime start,
    required DateTime end,
  }) = _RangeData;

  factory RangeData.empty() = _EmptyRangeData;

  RangeData._();

  List<DateTime> get dates => when(
        range: (start, end) => List.generate(
          start.zeroHour.difference(end.zeroHour).inDays.abs() + 1,
          (index) => start.zeroHour.add(Duration(days: index)),
        ),
        empty: () => [],
      );

  DateTime? get start => when(range: (start, end) => start, empty: () => null);

  DateTime? get end => when(range: (start, end) => end, empty: () => null);
}
