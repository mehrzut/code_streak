
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contribution_week_data.freezed.dart';

@freezed
class ContributionWeekData with _$ContributionWeekData{
  factory ContributionWeekData({
    required List<ContributionDayData> days
  })=_ContributionWeekData;

ContributionWeekData._();
}