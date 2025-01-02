import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/usecases/load_credentials.dart';
import 'package:code_streak/features/auth/domain/usecases/login_with_github.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoadCredentials _loadCredentials;
  final LoginWithGitHub _loginWithGitHub;
  AuthBloc(this._loginWithGitHub, this._loadCredentials)
      : super(_InitialState()) {
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
    final response = await _loadCredentials(NoParams());
    final newState = response.when(
      success: (data) => AuthState.success(),
      failed: (failure) => AuthState.failed(failure: failure),
    );
    emit(newState);
  }
}
