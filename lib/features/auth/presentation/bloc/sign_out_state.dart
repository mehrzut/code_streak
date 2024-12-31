part of 'sign_out_bloc.dart';

@freezed
class SignOutState with _$SignOutState {
  factory SignOutState.initial() = _InitialState;
  factory SignOutState.loading() = _LoadingState;
  factory SignOutState.success() = _SuccessState;
  factory SignOutState.failed({required Failure failure}) = _FailedState;

  SignOutState._();

  bool get isLoading => maybeWhen(
        loading: () => true,
        orElse: () => false,
  );
}
