// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributions_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContributionsDataImpl _$$ContributionsDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ContributionsDataImpl(
      totalContributions: (json['totalContributions'] as num).toInt(),
      contributionCalendar: (json['contributionCalendar'] as List<dynamic>)
          .map((e) => ContributionWeekData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ContributionsDataImplToJson(
        _$ContributionsDataImpl instance) =>
    <String, dynamic>{
      'totalContributions': instance.totalContributions,
      'contributionCalendar':
          instance.contributionCalendar.map((e) => e.toJson()).toList(),
    };
