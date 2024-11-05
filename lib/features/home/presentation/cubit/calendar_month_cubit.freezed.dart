// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_month_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CalendarMonthState {
  DateTime get current => throw _privateConstructorUsedError;
  List<ContributionDayData> get allDaysContributionData =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CalendarMonthStateCopyWith<CalendarMonthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarMonthStateCopyWith<$Res> {
  factory $CalendarMonthStateCopyWith(
          CalendarMonthState value, $Res Function(CalendarMonthState) then) =
      _$CalendarMonthStateCopyWithImpl<$Res, CalendarMonthState>;
  @useResult
  $Res call(
      {DateTime current, List<ContributionDayData> allDaysContributionData});
}

/// @nodoc
class _$CalendarMonthStateCopyWithImpl<$Res, $Val extends CalendarMonthState>
    implements $CalendarMonthStateCopyWith<$Res> {
  _$CalendarMonthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? allDaysContributionData = null,
  }) {
    return _then(_value.copyWith(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as DateTime,
      allDaysContributionData: null == allDaysContributionData
          ? _value.allDaysContributionData
          : allDaysContributionData // ignore: cast_nullable_to_non_nullable
              as List<ContributionDayData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarMonthStateImplCopyWith<$Res>
    implements $CalendarMonthStateCopyWith<$Res> {
  factory _$$CalendarMonthStateImplCopyWith(_$CalendarMonthStateImpl value,
          $Res Function(_$CalendarMonthStateImpl) then) =
      __$$CalendarMonthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime current, List<ContributionDayData> allDaysContributionData});
}

/// @nodoc
class __$$CalendarMonthStateImplCopyWithImpl<$Res>
    extends _$CalendarMonthStateCopyWithImpl<$Res, _$CalendarMonthStateImpl>
    implements _$$CalendarMonthStateImplCopyWith<$Res> {
  __$$CalendarMonthStateImplCopyWithImpl(_$CalendarMonthStateImpl _value,
      $Res Function(_$CalendarMonthStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? current = null,
    Object? allDaysContributionData = null,
  }) {
    return _then(_$CalendarMonthStateImpl(
      current: null == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as DateTime,
      allDaysContributionData: null == allDaysContributionData
          ? _value._allDaysContributionData
          : allDaysContributionData // ignore: cast_nullable_to_non_nullable
              as List<ContributionDayData>,
    ));
  }
}

/// @nodoc

class _$CalendarMonthStateImpl extends _CalendarMonthState {
  _$CalendarMonthStateImpl(
      {required this.current,
      required final List<ContributionDayData> allDaysContributionData})
      : _allDaysContributionData = allDaysContributionData,
        super._();

  @override
  final DateTime current;
  final List<ContributionDayData> _allDaysContributionData;
  @override
  List<ContributionDayData> get allDaysContributionData {
    if (_allDaysContributionData is EqualUnmodifiableListView)
      return _allDaysContributionData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allDaysContributionData);
  }

  @override
  String toString() {
    return 'CalendarMonthState(current: $current, allDaysContributionData: $allDaysContributionData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarMonthStateImpl &&
            (identical(other.current, current) || other.current == current) &&
            const DeepCollectionEquality().equals(
                other._allDaysContributionData, _allDaysContributionData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, current,
      const DeepCollectionEquality().hash(_allDaysContributionData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarMonthStateImplCopyWith<_$CalendarMonthStateImpl> get copyWith =>
      __$$CalendarMonthStateImplCopyWithImpl<_$CalendarMonthStateImpl>(
          this, _$identity);
}

abstract class _CalendarMonthState extends CalendarMonthState {
  factory _CalendarMonthState(
          {required final DateTime current,
          required final List<ContributionDayData> allDaysContributionData}) =
      _$CalendarMonthStateImpl;
  _CalendarMonthState._() : super._();

  @override
  DateTime get current;
  @override
  List<ContributionDayData> get allDaysContributionData;
  @override
  @JsonKey(ignore: true)
  _$$CalendarMonthStateImplCopyWith<_$CalendarMonthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
