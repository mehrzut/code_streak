import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/usecases/load_session.dart';
import 'package:code_streak/features/auth/domain/usecases/login_with_github.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithGitHub _loginWithGitHub;
  final LoadSession _loadSession;
  AuthBloc(this._loginWithGitHub, this._loadSession) : super(_InitialState()) {
    on<_LoginWithGitHubEvent>(_onLoginWithGitHubEvent);
    on<_LoadCredentialsEvent>(_onLoadCredentialsEvent);
  }

  Future<FutureOr<void>> _onLoginWithGitHubEvent(
      _LoginWithGitHubEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    final response = await _loginWithGitHub(NoParams());
    final newState = response.when(
      success: (data) => AuthState.success(),
      failed: (failure) => AuthState.failed(failure: failure),
    );
    emit(newState);
  }

  Future<FutureOr<void>> _onLoadCredentialsEvent(
      _LoadCredentialsEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());
    final response = await _loadSession(NoParams());
    final newState = response.when(
      success: (data) => AuthState.success(),
      failed: (failure) => AuthState.failed(failure: failure),
    );
    emit(newState);
  }
}
