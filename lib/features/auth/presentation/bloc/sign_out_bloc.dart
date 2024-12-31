import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/sign_out.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';
part 'sign_out_bloc.freezed.dart';

@injectable
class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOut _signOut;
  SignOutBloc(this._signOut) : super(_InitialState()) {
    on<_SignOutEvent>(_onSignOutEvent);
  }

  Future<FutureOr<void>> _onSignOutEvent(
      _SignOutEvent event, Emitter<SignOutState> emit) async {
    emit(_LoadingState());
    final response = await _signOut(NoParams());
    final newState = response.when(
      success: (data) => _SuccessState(),
      failed: (failure) => _FailedState(failure: failure),
    );
    emit(newState);
  }
}
