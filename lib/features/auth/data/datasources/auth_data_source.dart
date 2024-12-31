import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:code_streak/core/controllers/api_handler.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {
  Future<ResponseModel<Session>> loginWithGitHub();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<ResponseModel<Session>> loginWithGitHub() async {
    try {
      // Request the access token
      await ApiHandler.instance.account.createOAuth2Session(
        provider: OAuthProvider.github,
        scopes: ['read:user', 'user:email'],
      );
      final session =
          await ApiHandler.instance.account.getSession(sessionId: 'current');

      log("Access Token: ${session.providerAccessToken}");
      return ResponseModel.success(session);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return ResponseModel.failed(AuthenticationFailure(message: e.toString()));
    }
  }
}
