part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  factory AuthState.initial() = _InitialState;
  factory AuthState.loading() = _LoadingState;
  factory AuthState.success() = _SuccessState;
  factory AuthState.failed({required Failure failure}) = _FailedState;
}
