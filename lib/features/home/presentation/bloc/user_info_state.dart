part of 'user_info_bloc.dart';

@freezed
class UserInfoState with _$UserInfoState {
  factory UserInfoState.initial() = _InitialState;
  factory UserInfoState.loading() = _LoadingState;
  factory UserInfoState.success({required UserInfo data}) = _SuccessState;
  factory UserInfoState.failed({required Failure failure}) = _FailedState;

  UserInfoState._();

  bool get isLoading => this is _LoadingState || this is _InitialState;
}
