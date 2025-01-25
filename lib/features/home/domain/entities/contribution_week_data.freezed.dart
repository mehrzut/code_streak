// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contribution_week_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ContributionWeekData _$ContributionWeekDataFromJson(Map<String, dynamic> json) {
  return _ContributionWeekData.fromJson(json);
}

/// @nodoc
mixin _$ContributionWeekData {
  List<ContributionDayData> get days => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContributionWeekDataCopyWith<ContributionWeekData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContributionWeekDataCopyWith<$Res> {
  factory $ContributionWeekDataCopyWith(ContributionWeekData value,
          $Res Function(ContributionWeekData) then) =
      _$ContributionWeekDataCopyWithImpl<$Res, ContributionWeekData>;
  @useResult
  $Res call({List<ContributionDayData> days});
}

/// @nodoc
class _$ContributionWeekDataCopyWithImpl<$Res,
        $Val extends ContributionWeekData>
    implements $ContributionWeekDataCopyWith<$Res> {
  _$ContributionWeekDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
  }) {
    return _then(_value.copyWith(
      days: null == days
          ? _value.days
          : days // ignore: cast_nullable_to_non_nullable
              as List<ContributionDayData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ContributionWeekDataImplCopyWith<$Res>
    implements $ContributionWeekDataCopyWith<$Res> {
  factory _$$ContributionWeekDataImplCopyWith(_$ContributionWeekDataImpl value,
          $Res Function(_$ContributionWeekDataImpl) then) =
      __$$ContributionWeekDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<ContributionDayData> days});
}

/// @nodoc
class __$$ContributionWeekDataImplCopyWithImpl<$Res>
    extends _$ContributionWeekDataCopyWithImpl<$Res, _$ContributionWeekDataImpl>
    implements _$$ContributionWeekDataImplCopyWith<$Res> {
  __$$ContributionWeekDataImplCopyWithImpl(_$ContributionWeekDataImpl _value,
      $Res Function(_$ContributionWeekDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
  }) {
    return _then(_$ContributionWeekDataImpl(
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<ContributionDayData>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ContributionWeekDataImpl extends _ContributionWeekData {
  _$ContributionWeekDataImpl({required final List<ContributionDayData> days})
      : _days = days,
        super._();

  factory _$ContributionWeekDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ContributionWeekDataImplFromJson(json);

  final List<ContributionDayData> _days;
  @override
  List<ContributionDayData> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  String toString() {
    return 'ContributionWeekData(days: $days)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionWeekDataImpl &&
            const DeepCollectionEquality().equals(other._days, _days));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_days));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionWeekDataImplCopyWith<_$ContributionWeekDataImpl>
      get copyWith =>
          __$$ContributionWeekDataImplCopyWithImpl<_$ContributionWeekDataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ContributionWeekDataImplToJson(
      this,
    );
  }
}

abstract class _ContributionWeekData extends ContributionWeekData {
  factory _ContributionWeekData(
          {required final List<ContributionDayData> days}) =
      _$ContributionWeekDataImpl;
  _ContributionWeekData._() : super._();

  factory _ContributionWeekData.fromJson(Map<String, dynamic> json) =
      _$ContributionWeekDataImpl.fromJson;

  @override
  List<ContributionDayData> get days;
  @override
  @JsonKey(ignore: true)
  _$$ContributionWeekDataImplCopyWith<_$ContributionWeekDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
