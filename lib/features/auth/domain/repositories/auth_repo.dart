import 'package:appwrite/models.dart';
import 'package:code_streak/core/data/response_model.dart';

abstract class AuthRepo {
  Future<ResponseModel<void>> loginWithGitHub();

  Future<ResponseModel<Session>> refreshSession();

  Future<ResponseModel<void>> loadSession();

  Future<ResponseModel<bool>> signOut();
}
