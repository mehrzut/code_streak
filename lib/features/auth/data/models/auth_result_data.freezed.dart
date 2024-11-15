// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_result_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AuthResultData _$AuthResultDataFromJson(Map<String, dynamic> json) {
  return _AuthResultData.fromJson(json);
}

/// @nodoc
mixin _$AuthResultData {
  @SessionConverter()
  Session get session => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@SessionConverter() Session session) session,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@SessionConverter() Session session)? session,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@SessionConverter() Session session)? session,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthResultData value) session,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthResultData value)? session,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthResultData value)? session,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthResultDataCopyWith<AuthResultData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthResultDataCopyWith<$Res> {
  factory $AuthResultDataCopyWith(
          AuthResultData value, $Res Function(AuthResultData) then) =
      _$AuthResultDataCopyWithImpl<$Res, AuthResultData>;
  @useResult
  $Res call({@SessionConverter() Session session});
}

/// @nodoc
class _$AuthResultDataCopyWithImpl<$Res, $Val extends AuthResultData>
    implements $AuthResultDataCopyWith<$Res> {
  _$AuthResultDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
  }) {
    return _then(_value.copyWith(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthResultDataImplCopyWith<$Res>
    implements $AuthResultDataCopyWith<$Res> {
  factory _$$AuthResultDataImplCopyWith(_$AuthResultDataImpl value,
          $Res Function(_$AuthResultDataImpl) then) =
      __$$AuthResultDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@SessionConverter() Session session});
}

/// @nodoc
class __$$AuthResultDataImplCopyWithImpl<$Res>
    extends _$AuthResultDataCopyWithImpl<$Res, _$AuthResultDataImpl>
    implements _$$AuthResultDataImplCopyWith<$Res> {
  __$$AuthResultDataImplCopyWithImpl(
      _$AuthResultDataImpl _value, $Res Function(_$AuthResultDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
  }) {
    return _then(_$AuthResultDataImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthResultDataImpl extends _AuthResultData {
  _$AuthResultDataImpl({@SessionConverter() required this.session}) : super._();

  factory _$AuthResultDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthResultDataImplFromJson(json);

  @override
  @SessionConverter()
  final Session session;

  @override
  String toString() {
    return 'AuthResultData.session(session: $session)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthResultDataImpl &&
            (identical(other.session, session) || other.session == session));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, session);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthResultDataImplCopyWith<_$AuthResultDataImpl> get copyWith =>
      __$$AuthResultDataImplCopyWithImpl<_$AuthResultDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(@SessionConverter() Session session) session,
  }) {
    return session(this.session);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(@SessionConverter() Session session)? session,
  }) {
    return session?.call(this.session);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(@SessionConverter() Session session)? session,
    required TResult orElse(),
  }) {
    if (session != null) {
      return session(this.session);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_AuthResultData value) session,
  }) {
    return session(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_AuthResultData value)? session,
  }) {
    return session?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_AuthResultData value)? session,
    required TResult orElse(),
  }) {
    if (session != null) {
      return session(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthResultDataImplToJson(
      this,
    );
  }
}

abstract class _AuthResultData extends AuthResultData {
  factory _AuthResultData(
          {@SessionConverter() required final Session session}) =
      _$AuthResultDataImpl;
  _AuthResultData._() : super._();

  factory _AuthResultData.fromJson(Map<String, dynamic> json) =
      _$AuthResultDataImpl.fromJson;

  @override
  @SessionConverter()
  Session get session;
  @override
  @JsonKey(ignore: true)
  _$$AuthResultDataImplCopyWith<_$AuthResultDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
