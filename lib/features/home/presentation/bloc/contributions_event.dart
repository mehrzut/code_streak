part of 'contributions_bloc.dart';

@freezed
class ContributionsEvent with _$ContributionsEvent {
  factory ContributionsEvent.get(
      {required String username,
      required DateTime start,
      required DateTime end}) = _GetContributionsDataEvent;
}
