import 'package:code_streak/common/typedefs.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_week_data.freezed.dart';
part 'contribution_week_data.g.dart';

@freezed
class ContributionWeekData with _$ContributionWeekData {
  @JsonSerializable(explicitToJson: true)
  factory ContributionWeekData({required List<ContributionDayData> days}) =
      _ContributionWeekData;

  ContributionWeekData._();

  bool get isComplete => days.length == 7;

  DateTime get firstDay => days.first.date;

  DateTime get lastDay => days.last.date;

  factory ContributionWeekData.fromJson(Json json) =>
      _$ContributionWeekDataFromJson(json);
}
