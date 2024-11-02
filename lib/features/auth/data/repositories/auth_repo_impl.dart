import 'package:code_streak/core/controllers/api_handler.dart';
import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';
import 'package:oauth2_client/access_token_response.dart';

@LazySingleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthDataSource dataSource;
  final LocalDatabase localDatabase;

  AuthRepoImpl({required this.dataSource, required this.localDatabase});

  @override
  Future<ResponseModel<void>> loginWithGitHub() async {
    final result = await dataSource.loginWithGitHub();
    result.whenOrNull(
      success: (data) {
        localDatabase.saveCredentials(data);
        ApiHandler.instance.updateToken(data as AccessTokenResponse);
      },
    );
    return result;
  }

  @override
  Future<ResponseModel<void>> loadCredentials() async {
    final result = await localDatabase.loadCredentials();
    result.whenOrNull(
      success: (data) {
        ApiHandler.instance.updateToken(data as AccessTokenResponse);
      },
    );
    return result;
  }
}
