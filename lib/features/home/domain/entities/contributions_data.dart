import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contributions_data.freezed.dart';

@freezed
class ContributionsData with _$ContributionsData {
  factory ContributionsData({
    required int totalContributions,
    required List<ContributionWeekData> contributionCalendar,
  }) = _ContributionsData;

  ContributionsData._();

  factory ContributionsData.empty() =>
      ContributionsData(totalContributions: 0, contributionCalendar: []);
}
