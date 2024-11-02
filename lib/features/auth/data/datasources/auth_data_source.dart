import 'dart:developer';

import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/github_oauth2_client.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/oauth2_helper.dart';

abstract class AuthDataSource {
  Future<ResponseModel<AccessTokenResponse>> loginWithGitHub();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  @override
  Future<ResponseModel<AccessTokenResponse>> loginWithGitHub() async {
    var githubClient = GitHubOAuth2Client(
      redirectUri: 'codestreak://oauth2redirect',
      customUriScheme: 'codestreak',
    );
    var oauth2Helper = OAuth2Helper(
      githubClient,
      grantType: OAuth2Helper.authorizationCode,
      clientId: dotenv.get('GITHUB_CLIENT_ID', fallback: ''),
      clientSecret: dotenv.get('GITHUB_CLIENT_SECRET', fallback: ''),
      scopes: ['read:user', 'user:email'],
    );

    try {
      // Request the access token
      final token = await oauth2Helper.getToken();
      if (token != null) {
        log("Access Token: ${token.accessToken}");
        return ResponseModel.success(token);
      }
    } catch (e) {
      return ResponseModel.failed(AuthenticationFailure(message: e.toString()));
    }
    return ResponseModel.failed(AuthenticationFailure());
  }
}
