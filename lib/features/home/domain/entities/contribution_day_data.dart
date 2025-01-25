import 'package:code_streak/common/typedefs.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_day_data.freezed.dart';
part 'contribution_day_data.g.dart';

@freezed
class ContributionDayData with _$ContributionDayData {
  factory ContributionDayData({
    required int contributionCount,
    required DateTime date,
  }) = _ContributionDayData;

  ContributionDayData._();

  factory ContributionDayData.fromJson(Json json) =>
      _$ContributionDayDataFromJson(json);
}
