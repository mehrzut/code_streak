part of 'contributions_bloc.dart';

@freezed
class ContributionsState with _$ContributionsState {
  factory ContributionsState.initial() = _InitialState;
  factory ContributionsState.loading() = _LoadingState;
  factory ContributionsState.success({required ContributionsData data}) =
      _SuccessState;
  factory ContributionsState.failed({required Failure failure}) = _FailedState;
}
