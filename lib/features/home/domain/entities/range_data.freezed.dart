// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'range_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RangeData {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime start, DateTime end) range,
    required TResult Function() empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime start, DateTime end)? range,
    TResult? Function()? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime start, DateTime end)? range,
    TResult Function()? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RangeData value) range,
    required TResult Function(_EmptyRangeData value) empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RangeData value)? range,
    TResult? Function(_EmptyRangeData value)? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RangeData value)? range,
    TResult Function(_EmptyRangeData value)? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RangeDataCopyWith<$Res> {
  factory $RangeDataCopyWith(RangeData value, $Res Function(RangeData) then) =
      _$RangeDataCopyWithImpl<$Res, RangeData>;
}

/// @nodoc
class _$RangeDataCopyWithImpl<$Res, $Val extends RangeData>
    implements $RangeDataCopyWith<$Res> {
  _$RangeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$RangeDataImplCopyWith<$Res> {
  factory _$$RangeDataImplCopyWith(
          _$RangeDataImpl value, $Res Function(_$RangeDataImpl) then) =
      __$$RangeDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime start, DateTime end});
}

/// @nodoc
class __$$RangeDataImplCopyWithImpl<$Res>
    extends _$RangeDataCopyWithImpl<$Res, _$RangeDataImpl>
    implements _$$RangeDataImplCopyWith<$Res> {
  __$$RangeDataImplCopyWithImpl(
      _$RangeDataImpl _value, $Res Function(_$RangeDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$RangeDataImpl(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$RangeDataImpl extends _RangeData {
  _$RangeDataImpl({required this.start, required this.end}) : super._();

  @override
  final DateTime start;
  @override
  final DateTime end;

  @override
  String toString() {
    return 'RangeData.range(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RangeDataImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RangeDataImplCopyWith<_$RangeDataImpl> get copyWith =>
      __$$RangeDataImplCopyWithImpl<_$RangeDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime start, DateTime end) range,
    required TResult Function() empty,
  }) {
    return range(start, end);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime start, DateTime end)? range,
    TResult? Function()? empty,
  }) {
    return range?.call(start, end);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime start, DateTime end)? range,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (range != null) {
      return range(start, end);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RangeData value) range,
    required TResult Function(_EmptyRangeData value) empty,
  }) {
    return range(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RangeData value)? range,
    TResult? Function(_EmptyRangeData value)? empty,
  }) {
    return range?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RangeData value)? range,
    TResult Function(_EmptyRangeData value)? empty,
    required TResult orElse(),
  }) {
    if (range != null) {
      return range(this);
    }
    return orElse();
  }
}

abstract class _RangeData extends RangeData {
  factory _RangeData(
      {required final DateTime start,
      required final DateTime end}) = _$RangeDataImpl;
  _RangeData._() : super._();

  DateTime get start;
  DateTime get end;
  @JsonKey(ignore: true)
  _$$RangeDataImplCopyWith<_$RangeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmptyRangeDataImplCopyWith<$Res> {
  factory _$$EmptyRangeDataImplCopyWith(_$EmptyRangeDataImpl value,
          $Res Function(_$EmptyRangeDataImpl) then) =
      __$$EmptyRangeDataImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmptyRangeDataImplCopyWithImpl<$Res>
    extends _$RangeDataCopyWithImpl<$Res, _$EmptyRangeDataImpl>
    implements _$$EmptyRangeDataImplCopyWith<$Res> {
  __$$EmptyRangeDataImplCopyWithImpl(
      _$EmptyRangeDataImpl _value, $Res Function(_$EmptyRangeDataImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$EmptyRangeDataImpl extends _EmptyRangeData {
  _$EmptyRangeDataImpl() : super._();

  @override
  String toString() {
    return 'RangeData.empty()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$EmptyRangeDataImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(DateTime start, DateTime end) range,
    required TResult Function() empty,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(DateTime start, DateTime end)? range,
    TResult? Function()? empty,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(DateTime start, DateTime end)? range,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RangeData value) range,
    required TResult Function(_EmptyRangeData value) empty,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RangeData value)? range,
    TResult? Function(_EmptyRangeData value)? empty,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RangeData value)? range,
    TResult Function(_EmptyRangeData value)? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }
}

abstract class _EmptyRangeData extends RangeData {
  factory _EmptyRangeData() = _$EmptyRangeDataImpl;
  _EmptyRangeData._() : super._();
}
