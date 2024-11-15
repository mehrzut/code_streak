import 'package:code_streak/core/controllers/api_handler.dart';
import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart';
import 'package:code_streak/features/auth/data/models/auth_result_data.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

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
        ApiHandler.instance.updateToken(data as AuthResultData);
      },
    );
    return result;
  }

  @override
  Future<ResponseModel<void>> loadSession() async {
    final result = await dataSource.loadSession();
    result.whenOrNull(
      success: (data) {
        ApiHandler.instance.updateToken(data as AuthResultData);
      },
    );
    return result;
  }
}
