import 'dart:developer';

import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {
  Future<ResponseModel<Session>> loginWithGitHub();

  Future<ResponseModel<bool>> signOut();

  Future<ResponseModel<Session>> refreshSession();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<ResponseModel<Session>> loginWithGitHub() async {
    try {
      // Request the access token
      await ClientHandler.instance.account.createOAuth2Session(
        provider: OAuthProvider.github,
        scopes: ['read:user', 'user:email', 'offline_access'],
      );
      await ClientHandler.instance.account.get();
      final session =
          await ClientHandler.instance.account.getSession(sessionId: 'current');

      log("Access Token: ${session.providerAccessToken}");
      return ResponseModel.success(session);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return ResponseModel.failed(AuthenticationFailure(message: e.toString()));
    }
  }

  @override
  Future<ResponseModel<bool>> signOut() async {
    try {
      final account = await ClientHandler.instance.account.get();
      await ClientHandler.instance.account
          .deleteIdentity(identityId: account.$id);
      await ClientHandler.instance.account.deleteSession(sessionId: 'current');
      return ResponseModel.success(true);
    } catch (e) {
      log(e.toString());
      return ResponseModel.failed(AuthenticationFailure(message: e.toString()));
    }
  }

  @override
  Future<ResponseModel<Session>> refreshSession() async {
    try {
      await ClientHandler.instance.account.updateSession(sessionId: 'current');
      final refreshedSession =
          await ClientHandler.instance.account.getSession(sessionId: 'current');
      return ResponseModel.success(refreshedSession);
    } catch (e) {
      log(e.toString());
      return ResponseModel.failed(AuthenticationFailure(message: e.toString()));
    }
  }
}
