// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ThemeEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() check,
    required TResult Function() toggle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? check,
    TResult? Function()? toggle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? check,
    TResult Function()? toggle,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CheckThemeEvent value) check,
    required TResult Function(_ToggleThemeEvent value) toggle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CheckThemeEvent value)? check,
    TResult? Function(_ToggleThemeEvent value)? toggle,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CheckThemeEvent value)? check,
    TResult Function(_ToggleThemeEvent value)? toggle,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeEventCopyWith<$Res> {
  factory $ThemeEventCopyWith(
          ThemeEvent value, $Res Function(ThemeEvent) then) =
      _$ThemeEventCopyWithImpl<$Res, ThemeEvent>;
}

/// @nodoc
class _$ThemeEventCopyWithImpl<$Res, $Val extends ThemeEvent>
    implements $ThemeEventCopyWith<$Res> {
  _$ThemeEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$CheckThemeEventImplCopyWith<$Res> {
  factory _$$CheckThemeEventImplCopyWith(_$CheckThemeEventImpl value,
          $Res Function(_$CheckThemeEventImpl) then) =
      __$$CheckThemeEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckThemeEventImplCopyWithImpl<$Res>
    extends _$ThemeEventCopyWithImpl<$Res, _$CheckThemeEventImpl>
    implements _$$CheckThemeEventImplCopyWith<$Res> {
  __$$CheckThemeEventImplCopyWithImpl(
      _$CheckThemeEventImpl _value, $Res Function(_$CheckThemeEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CheckThemeEventImpl implements _CheckThemeEvent {
  const _$CheckThemeEventImpl();

  @override
  String toString() {
    return 'ThemeEvent.check()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckThemeEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() check,
    required TResult Function() toggle,
  }) {
    return check();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? check,
    TResult? Function()? toggle,
  }) {
    return check?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? check,
    TResult Function()? toggle,
    required TResult orElse(),
  }) {
    if (check != null) {
      return check();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CheckThemeEvent value) check,
    required TResult Function(_ToggleThemeEvent value) toggle,
  }) {
    return check(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CheckThemeEvent value)? check,
    TResult? Function(_ToggleThemeEvent value)? toggle,
  }) {
    return check?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CheckThemeEvent value)? check,
    TResult Function(_ToggleThemeEvent value)? toggle,
    required TResult orElse(),
  }) {
    if (check != null) {
      return check(this);
    }
    return orElse();
  }
}

abstract class _CheckThemeEvent implements ThemeEvent {
  const factory _CheckThemeEvent() = _$CheckThemeEventImpl;
}

/// @nodoc
abstract class _$$ToggleThemeEventImplCopyWith<$Res> {
  factory _$$ToggleThemeEventImplCopyWith(_$ToggleThemeEventImpl value,
          $Res Function(_$ToggleThemeEventImpl) then) =
      __$$ToggleThemeEventImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ToggleThemeEventImplCopyWithImpl<$Res>
    extends _$ThemeEventCopyWithImpl<$Res, _$ToggleThemeEventImpl>
    implements _$$ToggleThemeEventImplCopyWith<$Res> {
  __$$ToggleThemeEventImplCopyWithImpl(_$ToggleThemeEventImpl _value,
      $Res Function(_$ToggleThemeEventImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ToggleThemeEventImpl implements _ToggleThemeEvent {
  const _$ToggleThemeEventImpl();

  @override
  String toString() {
    return 'ThemeEvent.toggle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ToggleThemeEventImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() check,
    required TResult Function() toggle,
  }) {
    return toggle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? check,
    TResult? Function()? toggle,
  }) {
    return toggle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? check,
    TResult Function()? toggle,
    required TResult orElse(),
  }) {
    if (toggle != null) {
      return toggle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_CheckThemeEvent value) check,
    required TResult Function(_ToggleThemeEvent value) toggle,
  }) {
    return toggle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_CheckThemeEvent value)? check,
    TResult? Function(_ToggleThemeEvent value)? toggle,
  }) {
    return toggle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_CheckThemeEvent value)? check,
    TResult Function(_ToggleThemeEvent value)? toggle,
    required TResult orElse(),
  }) {
    if (toggle != null) {
      return toggle(this);
    }
    return orElse();
  }
}

abstract class _ToggleThemeEvent implements ThemeEvent {
  const factory _ToggleThemeEvent() = _$ToggleThemeEventImpl;
}

/// @nodoc
mixin _$ThemeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() dark,
    required TResult Function() light,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? dark,
    TResult? Function()? light,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? dark,
    TResult Function()? light,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DarkState value) dark,
    required TResult Function(_LightState value) light,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DarkState value)? dark,
    TResult? Function(_LightState value)? light,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DarkState value)? dark,
    TResult Function(_LightState value)? light,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeStateCopyWith<$Res> {
  factory $ThemeStateCopyWith(
          ThemeState value, $Res Function(ThemeState) then) =
      _$ThemeStateCopyWithImpl<$Res, ThemeState>;
}

/// @nodoc
class _$ThemeStateCopyWithImpl<$Res, $Val extends ThemeState>
    implements $ThemeStateCopyWith<$Res> {
  _$ThemeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DarkStateImplCopyWith<$Res> {
  factory _$$DarkStateImplCopyWith(
          _$DarkStateImpl value, $Res Function(_$DarkStateImpl) then) =
      __$$DarkStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DarkStateImplCopyWithImpl<$Res>
    extends _$ThemeStateCopyWithImpl<$Res, _$DarkStateImpl>
    implements _$$DarkStateImplCopyWith<$Res> {
  __$$DarkStateImplCopyWithImpl(
      _$DarkStateImpl _value, $Res Function(_$DarkStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DarkStateImpl implements _DarkState {
  const _$DarkStateImpl();

  @override
  String toString() {
    return 'ThemeState.dark()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DarkStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() dark,
    required TResult Function() light,
  }) {
    return dark();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? dark,
    TResult? Function()? light,
  }) {
    return dark?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? dark,
    TResult Function()? light,
    required TResult orElse(),
  }) {
    if (dark != null) {
      return dark();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DarkState value) dark,
    required TResult Function(_LightState value) light,
  }) {
    return dark(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DarkState value)? dark,
    TResult? Function(_LightState value)? light,
  }) {
    return dark?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DarkState value)? dark,
    TResult Function(_LightState value)? light,
    required TResult orElse(),
  }) {
    if (dark != null) {
      return dark(this);
    }
    return orElse();
  }
}

abstract class _DarkState implements ThemeState {
  const factory _DarkState() = _$DarkStateImpl;
}

/// @nodoc
abstract class _$$LightStateImplCopyWith<$Res> {
  factory _$$LightStateImplCopyWith(
          _$LightStateImpl value, $Res Function(_$LightStateImpl) then) =
      __$$LightStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LightStateImplCopyWithImpl<$Res>
    extends _$ThemeStateCopyWithImpl<$Res, _$LightStateImpl>
    implements _$$LightStateImplCopyWith<$Res> {
  __$$LightStateImplCopyWithImpl(
      _$LightStateImpl _value, $Res Function(_$LightStateImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LightStateImpl implements _LightState {
  const _$LightStateImpl();

  @override
  String toString() {
    return 'ThemeState.light()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LightStateImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() dark,
    required TResult Function() light,
  }) {
    return light();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? dark,
    TResult? Function()? light,
  }) {
    return light?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? dark,
    TResult Function()? light,
    required TResult orElse(),
  }) {
    if (light != null) {
      return light();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DarkState value) dark,
    required TResult Function(_LightState value) light,
  }) {
    return light(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DarkState value)? dark,
    TResult? Function(_LightState value)? light,
  }) {
    return light?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DarkState value)? dark,
    TResult Function(_LightState value)? light,
    required TResult orElse(),
  }) {
    if (light != null) {
      return light(this);
    }
    return orElse();
  }
}

abstract class _LightState implements ThemeState {
  const factory _LightState() = _$LightStateImpl;
}
