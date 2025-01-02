import 'package:appwrite/models.dart';
import 'package:code_streak/core/controllers/api_handler.dart';
import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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
      success: (data) async {
        ApiHandler.instance.updateSession(data as Session);
        localDatabase.saveSession(data);
        await _setTimezone();
      },
    );
    return result;
  }

  Future<void> _setTimezone() async {
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    final result = await ApiHandler.instance.account
        .updatePrefs(prefs: {'timezone': currentTimeZone});
  }

  @override
  Future<ResponseModel<void>> loadSession() async {
    final result = await localDatabase.loadSession();
    result.whenOrNull(
      success: (data) async {
        ApiHandler.instance.updateSession(data as Session);
        await _setTimezone();
      },
    );
    return result;
  }
}
