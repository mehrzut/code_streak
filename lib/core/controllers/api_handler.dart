import 'dart:io';
import 'package:appwrite/appwrite.dart' hide Response;
import 'package:appwrite/models.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:code_streak/injector.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiHandler {
  final Dio _dio;
  Client client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('code-streak');
  late final account = Account(client);

  ApiHandler() : _dio = Dio(BaseOptions());

  static ApiHandler? _instance;

  static ApiHandler get instance {
    _instance ??= ApiHandler();
    return _instance!;
  }

  // Method to update the token
  void updateSession(Session? newSession) {
    _dio.options.headers["Authorization"] =
        "Bearer ${newSession?.providerAccessToken}";
  }

  Future<Response> callApi(Future<Response> Function(Dio dio) caller) async {
    final response = await caller(_dio);
    if (response.statusCode == HttpStatus.unauthorized) {
      return reauthenticate(response, caller);
    }
    return response;
  }

  Future<Response> reauthenticate(
    Response response,
    Future<Response> Function(Dio dio) caller,
  ) async {
    final result = await sl<AuthRepo>().loginWithGitHub();
    return result.when(
      success: (data) {
        updateSession(data);
        return caller(_dio); // Retry the API call with the new token
      },
      failed: (failure) => response,
    );
  }
}
