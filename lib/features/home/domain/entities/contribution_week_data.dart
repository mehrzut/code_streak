
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_week_data.freezed.dart';

@freezed
class ContributionWeekData with _$ContributionWeekData{
  factory ContributionWeekData({
    required DateTime date,
    required int count,
  })=_ContributionWeekData;

ContributionWeekData._();
}