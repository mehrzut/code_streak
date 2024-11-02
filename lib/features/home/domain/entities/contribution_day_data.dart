import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_day_data.freezed.dart';

@freezed
class ContributionDayData with _$ContributionDayData {
  factory ContributionDayData({
    required int contributionCount,
    required DateTime date,
  }) = _ContributionDayData;

  ContributionDayData._();
}
