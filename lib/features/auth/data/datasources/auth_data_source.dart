import 'package:appwrite/appwrite.dart';
import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/auth/data/models/auth_result_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class AuthDataSource {
  Future<ResponseModel<AuthResultData>> loginWithGitHub();
  Future<ResponseModel<AuthResultData>> loadSession();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  Client client = Client()
      .setSelfSigned(status: true)
      .setEndpoint(dotenv.get('APPWRITE_ENDPOINT', fallback: ''))
      .setProject(dotenv.get('APPWRITE_PROJECT_ID', fallback: ''));

  @override
  Future<ResponseModel<AuthResultData>> loginWithGitHub() async {
    Account account = Account(client);
    try {
      await account.createOAuth2Session(
        provider: OAuthProvider.github,
        scopes: ['read:user', 'user:email'],
      );
      return loadSession();
    } catch (error) {
      return ResponseModel.failed(
          AuthenticationFailure(message: "OAuth2 login failed: $error"));
    }
  }

  @override
  Future<ResponseModel<AuthResultData>> loadSession() async {
    try {
      Account account = Account(client);
      Session session = await account.getSession(sessionId: 'current');
      if (session.current) {
        return ResponseModel.success(AuthResultData.session(session: session));
      } else {
        return ResponseModel.failed(
            AuthenticationFailure(message: "OAuth2 session not available!"));
      }
    } catch (e) {
      return ResponseModel.failed(
          AuthenticationFailure(message: "OAuth2 session not available!"));
    }
  }
}
