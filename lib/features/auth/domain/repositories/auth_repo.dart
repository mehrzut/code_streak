import 'package:code_streak/core/data/response_model.dart';

abstract class AuthRepo {
  Future<ResponseModel<void>> loginWithGitHub();

  Future<ResponseModel<void>> loadSession();
}
