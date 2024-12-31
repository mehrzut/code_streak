import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
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
    final client = Client();
    final account = Account(client);
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('code-streak');

    try {
      // Request the access token
      await account.createOAuth2Session(
        provider: OAuthProvider.github,
        scopes: ['read:user', 'user:email'],
      );
      final session = await account.getSession(sessionId: 'current');

      log("Access Token: ${session.providerAccessToken}");
      return ResponseModel.success(session);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      return ResponseModel.failed(AuthenticationFailure(message: e.toString()));
    }
  }
}
