// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contributions_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContributionsData _$ContributionsDataFromJson(Map<String, dynamic> json) {
  return _ContributionsData.fromJson(json);
}

/// @nodoc
mixin _$ContributionsData {
  int get totalContributions => throw _privateConstructorUsedError;
  List<ContributionWeekData> get contributionCalendar =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContributionsDataCopyWith<ContributionsData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContributionsDataCopyWith<$Res> {
  factory $ContributionsDataCopyWith(
          ContributionsData value, $Res Function(ContributionsData) then) =
      _$ContributionsDataCopyWithImpl<$Res, ContributionsData>;
  @useResult
  $Res call(
      {int totalContributions,
      List<ContributionWeekData> contributionCalendar});
}

/// @nodoc
class _$ContributionsDataCopyWithImpl<$Res, $Val extends ContributionsData>
    implements $ContributionsDataCopyWith<$Res> {
  _$ContributionsDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalContributions = null,
    Object? contributionCalendar = null,
  }) {
    return _then(_value.copyWith(
      totalContributions: null == totalContributions
          ? _value.totalContributions
          : totalContributions // ignore: cast_nullable_to_non_nullable
              as int,
      contributionCalendar: null == contributionCalendar
          ? _value.contributionCalendar
          : contributionCalendar // ignore: cast_nullable_to_non_nullable
              as List<ContributionWeekData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContributionsDataImplCopyWith<$Res>
    implements $ContributionsDataCopyWith<$Res> {
  factory _$$ContributionsDataImplCopyWith(_$ContributionsDataImpl value,
          $Res Function(_$ContributionsDataImpl) then) =
      __$$ContributionsDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalContributions,
      List<ContributionWeekData> contributionCalendar});
}

/// @nodoc
class __$$ContributionsDataImplCopyWithImpl<$Res>
    extends _$ContributionsDataCopyWithImpl<$Res, _$ContributionsDataImpl>
    implements _$$ContributionsDataImplCopyWith<$Res> {
  __$$ContributionsDataImplCopyWithImpl(_$ContributionsDataImpl _value,
      $Res Function(_$ContributionsDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalContributions = null,
    Object? contributionCalendar = null,
  }) {
    return _then(_$ContributionsDataImpl(
      totalContributions: null == totalContributions
          ? _value.totalContributions
          : totalContributions // ignore: cast_nullable_to_non_nullable
              as int,
      contributionCalendar: null == contributionCalendar
          ? _value._contributionCalendar
          : contributionCalendar // ignore: cast_nullable_to_non_nullable
              as List<ContributionWeekData>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ContributionsDataImpl extends _ContributionsData {
  _$ContributionsDataImpl(
      {required this.totalContributions,
      required final List<ContributionWeekData> contributionCalendar})
      : _contributionCalendar = contributionCalendar,
        super._();

  factory _$ContributionsDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContributionsDataImplFromJson(json);

  @override
  final int totalContributions;
  final List<ContributionWeekData> _contributionCalendar;
  @override
  List<ContributionWeekData> get contributionCalendar {
    if (_contributionCalendar is EqualUnmodifiableListView)
      return _contributionCalendar;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contributionCalendar);
  }

  @override
  String toString() {
    return 'ContributionsData(totalContributions: $totalContributions, contributionCalendar: $contributionCalendar)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionsDataImpl &&
            (identical(other.totalContributions, totalContributions) ||
                other.totalContributions == totalContributions) &&
            const DeepCollectionEquality()
                .equals(other._contributionCalendar, _contributionCalendar));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, totalContributions,
      const DeepCollectionEquality().hash(_contributionCalendar));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionsDataImplCopyWith<_$ContributionsDataImpl> get copyWith =>
      __$$ContributionsDataImplCopyWithImpl<_$ContributionsDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContributionsDataImplToJson(
      this,
    );
  }
}

abstract class _ContributionsData extends ContributionsData {
  factory _ContributionsData(
          {required final int totalContributions,
          required final List<ContributionWeekData> contributionCalendar}) =
      _$ContributionsDataImpl;
  _ContributionsData._() : super._();

  factory _ContributionsData.fromJson(Map<String, dynamic> json) =
      _$ContributionsDataImpl.fromJson;

  @override
  int get totalContributions;
  @override
  List<ContributionWeekData> get contributionCalendar;
  @override
  @JsonKey(ignore: true)
  _$$ContributionsDataImplCopyWith<_$ContributionsDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
