import 'package:code_streak/common/url_helper.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/interfaces.dart';
import 'package:oauth2_client/oauth2_client.dart';

class GitHubOAuth2Client extends OAuth2Client {
  GitHubOAuth2Client(
      {required super.redirectUri, required super.customUriScheme})
      : super(
            authorizeUrl: UrlHelper.githubAuthorizeUrl,
            tokenUrl: UrlHelper.githubTokenUrl);

  @override
  Future<AccessTokenResponse> getTokenWithAuthCodeFlow(
      {required String clientId,
      List<String>? scopes,
      String? clientSecret,
      bool enablePKCE = true,
      bool enableState = true,
      String? state,
      String? codeVerifier,
      Function? afterAuthorizationCodeCb,
      Map<String, dynamic>? authCodeParams,
      Map<String, dynamic>? accessTokenParams,
      Map<String, String>? accessTokenHeaders,
      httpClient,
      BaseWebAuth? webAuthClient,
      Map<String, dynamic>? webAuthOpts}) async {
    return super.getTokenWithAuthCodeFlow(
        clientId: clientId,
        scopes: scopes,
        clientSecret: clientSecret,
        enablePKCE: enablePKCE,
        enableState: enableState,
        state: state,
        codeVerifier: codeVerifier,
        afterAuthorizationCodeCb: afterAuthorizationCodeCb,
        authCodeParams: authCodeParams,
        accessTokenParams: accessTokenParams,
        accessTokenHeaders: {
          ...?accessTokenHeaders,
          ...{'Accept': 'application/json'}
        },
        httpClient: httpClient,
        webAuthClient: webAuthClient,
        webAuthOpts: webAuthOpts);
  }
}
