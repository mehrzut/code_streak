// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_day_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContributionDayDataImpl _$$ContributionDayDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ContributionDayDataImpl(
      contributionCount: (json['contributionCount'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$ContributionDayDataImplToJson(
        _$ContributionDayDataImpl instance) =>
    <String, dynamic>{
      'contributionCount': instance.contributionCount,
      'date': instance.date.toIso8601String(),
    };
