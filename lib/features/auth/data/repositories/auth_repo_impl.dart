import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/extensions.dart';
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthDataSource dataSource;
  final LocalDatabase localDatabase;

  AuthRepoImpl({required this.dataSource, required this.localDatabase});

  @override
  Future<ResponseModel<void>> loginWithGitHub() async {
    final result = await dataSource.loginWithGitHub();
    result.whenOrNull(
      success: (data) async {
        ClientHandler.instance.updateSession(data as Session);
        localDatabase.saveSession(data);
      },
    );
    return result;
  }

  @override
  Future<ResponseModel<void>> loadSession() async {
    final result = await localDatabase.loadSession();
    return result.when<Future<ResponseModel<Session>>>(
      success: (data) async {
        ClientHandler.instance.updateSession(data as Session);
        final session = await _checkExpiry(data);
        if (session != data) {
          ClientHandler.instance.updateSession(session);
        }
        return result;
      },
      failed: (failure) async {
        try {
          final session = await ClientHandler.instance.account
              .getSession(sessionId: 'current');
          return ResponseModel.success(session);
        } catch (e) {
          log(e.toString());
          return result;
        }
      },
    );
  }

  @override
  Future<ResponseModel<bool>> signOut() async {
    final result = await dataSource.signOut();
    await result.whenOrNull(
      success: (data) async {
        await localDatabase.deleteSession();
        ClientHandler.instance.updateSession(null);
      },
    );
    return result;
  }

  Future<Session> _checkExpiry(Session data) async {
    if (data.isExpired) {
      final result = await refreshSession();
      return result.when(
        success: (newSession) => newSession,
        failed: (failure) => data,
      );
    }
    return data;
  }

  @override
  Future<ResponseModel<Session>> refreshSession() async {
    final result = await dataSource.refreshSession();
    result.whenOrNull(
      success: (data) {
        log("New Session isExpired: ${(data as Session).isExpired}");
        ClientHandler.instance.updateSession(data);
        localDatabase.saveSession(data);
      },
    );
    return result;
  }
}
