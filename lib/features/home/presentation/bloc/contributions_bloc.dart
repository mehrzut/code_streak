import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/usecases/get_contributions_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'contributions_event.dart';
part 'contributions_state.dart';
part 'contributions_bloc.freezed.dart';

@injectable
class ContributionsBloc extends Bloc<ContributionsEvent, ContributionsState> {
  final GetContributionsData _getContributionsData;
  ContributionsBloc(this._getContributionsData) : super(_InitialState()) {
    on<_GetContributionsDataEvent>(_onGetContributionsDataEvent);
  }

  Future<FutureOr<void>> _onGetContributionsDataEvent(
      _GetContributionsDataEvent event,
      Emitter<ContributionsState> emit) async {
    emit(ContributionsState.loading());
    final response =
        await _getContributionsData(Params(username: event.username));
    final newState = response.when(
      failed: (failure) => ContributionsState.failed(failure: failure),
      success: (data) => ContributionsState.success(data: data),
    );
    emit(newState);
  }
}
