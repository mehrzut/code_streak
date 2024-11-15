// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_result_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthResultDataImpl _$$AuthResultDataImplFromJson(Map<String, dynamic> json) =>
    _$AuthResultDataImpl(
      session: const SessionConverter()
          .fromJson(json['session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AuthResultDataImplToJson(
        _$AuthResultDataImpl instance) =>
    <String, dynamic>{
      'session': const SessionConverter().toJson(instance.session),
    };
