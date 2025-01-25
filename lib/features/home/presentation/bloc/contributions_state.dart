part of 'contributions_bloc.dart';

@freezed
class ContributionsState with _$ContributionsState {
  factory ContributionsState.initial() = _InitialState;
  factory ContributionsState.loading({required ContributionsData? data}) =
      _LoadingState;
  factory ContributionsState.success({required ContributionsData data}) =
      _SuccessState;
  factory ContributionsState.failed(
      {required Failure failure,
      required ContributionsData? data}) = _FailedState;

  ContributionsState._();

  bool get isLoading => this is _LoadingState || this is _InitialState;

  ContributionsData? get data => whenOrNull(
        failed: (failure, data) => data,
        loading: (data) => data,
        success: (data) => data,
      );
}
