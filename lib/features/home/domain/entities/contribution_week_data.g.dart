// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contribution_week_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ContributionWeekDataImpl _$$ContributionWeekDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ContributionWeekDataImpl(
      days: (json['days'] as List<dynamic>)
          .map((e) => ContributionDayData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ContributionWeekDataImplToJson(
        _$ContributionWeekDataImpl instance) =>
    <String, dynamic>{
      'days': instance.days.map((e) => e.toJson()).toList(),
    };
