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

/// @nodoc
mixin _$ContributionWeekData {
  DateTime get date => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;

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
  $Res call({DateTime date, int count});
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
    Object? date = null,
    Object? count = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
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
  $Res call({DateTime date, int count});
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
    Object? date = null,
    Object? count = null,
  }) {
    return _then(_$ContributionWeekDataImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ContributionWeekDataImpl extends _ContributionWeekData {
  _$ContributionWeekDataImpl({required this.date, required this.count})
      : super._();

  @override
  final DateTime date;
  @override
  final int count;

  @override
  String toString() {
    return 'ContributionWeekData(date: $date, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContributionWeekDataImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.count, count) || other.count == count));
  }

  @override
  int get hashCode => Object.hash(runtimeType, date, count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ContributionWeekDataImplCopyWith<_$ContributionWeekDataImpl>
      get copyWith =>
          __$$ContributionWeekDataImplCopyWithImpl<_$ContributionWeekDataImpl>(
              this, _$identity);
}

abstract class _ContributionWeekData extends ContributionWeekData {
  factory _ContributionWeekData(
      {required final DateTime date,
      required final int count}) = _$ContributionWeekDataImpl;
  _ContributionWeekData._() : super._();

  @override
  DateTime get date;
  @override
  int get count;
  @override
  @JsonKey(ignore: true)
  _$$ContributionWeekDataImplCopyWith<_$ContributionWeekDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
