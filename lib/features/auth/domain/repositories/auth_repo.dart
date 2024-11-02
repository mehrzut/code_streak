import 'package:code_streak/core/data/response_model.dart';
import 'package:oauth2_client/access_token_response.dart';

abstract class AuthRepo {
  Future<ResponseModel<AccessTokenResponse>> loginWithGitHub();
}
