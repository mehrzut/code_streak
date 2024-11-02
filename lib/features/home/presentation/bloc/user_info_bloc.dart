import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:code_streak/features/home/domain/usecases/get_user_info.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'user_info_event.dart';
part 'user_info_state.dart';
part 'user_info_bloc.freezed.dart';

@injectable
class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final GetUserInfo _getUserInfo;
  UserInfoBloc(this._getUserInfo) : super(_InitialState()) {
    on<_GetUserInfoEvent>(_onGetUserInfoEvent);
  }

  Future<FutureOr<void>> _onGetUserInfoEvent(
      _GetUserInfoEvent event, Emitter<UserInfoState> emit) async {
    emit(UserInfoState.loading());
    final response = await _getUserInfo(NoParams());
    final newState = response.when(
      failed: (failure) => UserInfoState.failed(failure: failure),
      success: (data) => UserInfoState.success(data: data),
    );
    emit(newState);
  }
}
