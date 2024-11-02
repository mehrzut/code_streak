// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contribution_day_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ContributionDayData {
  int get contributionCount => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ContributionDayDataCopyWith<ContributionDayData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContributionDayDataCopyWith<$Res> {
  factory $ContributionDayDataCopyWith(
          ContributionDayData value, $Res Function(ContributionDayData) then) =
      _$ContributionDayDataCopyWithImpl<$Res, ContributionDayData>;
  @useResult
  $Res call({int contributionCount, DateTime date});
}

/// @nodoc
class _$ContributionDayDataCopyWithImpl<$Res, $Val extends ContributionDayData>
    implements $ContributionDayDataCopyWith<$Res> {
  _$ContributionDayDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contributionCount = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      contributionCount: null == contributionCount
          ? _value.contributionCount
          : contributionCount // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContributionDayDataImplCopyWith<$Res>
    implements $ContributionDayDataCopyWith<$Res> {
  factory _$$ContributionDayDataImplCopyWith(_$ContributionDayDataImpl value,
          $Res Function(_$ContributionDayDataImpl) then) =
      __$$ContributionDayDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int contributionCount, DateTime date});
}

/// @nodoc
class __$$ContributionDayDataImplCopyWithImpl<$Res>
    extends _$ContributionDayDataCopyWithImpl<$Res, _$ContributionDayDataImpl>
    implements _$$ContributionDayDataImplCopyWith<$Res> {
  __$$ContributionDayDataImplCopyWithImpl(_$ContributionDayDataImpl _value,
      $Res Function(_$ContributionDayDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contributionCount = null,
    Object? date = null,
  }) {
    return _then(_$ContributionDayDataImpl(
      contributionCount: null == contributionCount
          ? _value.contributionCount
          : contributionCount // ignore: cast_nullable_to_non_nullable
              as int,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ContributionDayDataImpl extends _ContributionDayData {
  _$ContributionDayDataImpl(
      {required this.contributionCount, required this.date})
      : super._();

  @override
  final int contributionCount;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'ContributionDayData(contributionCount: $contributionCount, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionDayDataImpl &&
            (identical(other.contributionCount, contributionCount) ||
                other.contributionCount == contributionCount) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, contributionCount, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionDayDataImplCopyWith<_$ContributionDayDataImpl> get copyWith =>
      __$$ContributionDayDataImplCopyWithImpl<_$ContributionDayDataImpl>(
          this, _$identity);
}

abstract class _ContributionDayData extends ContributionDayData {
  factory _ContributionDayData(
      {required final int contributionCount,
      required final DateTime date}) = _$ContributionDayDataImpl;
  _ContributionDayData._() : super._();

  @override
  int get contributionCount;
  @override
  DateTime get date;
  @override
  @JsonKey(ignore: true)
  _$$ContributionDayDataImplCopyWith<_$ContributionDayDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
