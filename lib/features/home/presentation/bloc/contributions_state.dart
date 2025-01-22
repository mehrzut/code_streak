part of 'contributions_bloc.dart';

@freezed
class ContributionsState with _$ContributionsState {
  factory ContributionsState.initial() = _InitialState;
  factory ContributionsState.loading() = _LoadingState;
  factory ContributionsState.success({required ContributionsData data}) =
      _SuccessState;
  factory ContributionsState.failed({required Failure failure}) = _FailedState;

  ContributionsState._();

  bool get isLoading => this is _LoadingState || this is _InitialState;

  ContributionsData? get data =>
      this is _SuccessState ? (this as _SuccessState).data : null;
}
