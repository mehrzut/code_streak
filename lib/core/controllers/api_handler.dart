import 'dart:io';
import 'package:code_streak/features/auth/data/models/auth_result_data.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:code_streak/injector.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ApiHandler {
  AuthResultData? _authData;
  final Dio _dio;

  ApiHandler() : _dio = Dio(BaseOptions()) {
    // Add the token interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add the token to the headers if it is available
        if (_authData?.session.providerAccessToken != null &&
            _authData!.session.providerAccessToken.isNotEmpty) {
          options.headers[HttpHeaders.authorizationHeader] =
              'Bearer ${_authData!.session.providerAccessToken}';
        }
        handler.next(options); // Continue with the request
      },
    ));
  }

  static ApiHandler? _instance;

  static ApiHandler get instance {
    _instance ??= ApiHandler();
    return _instance!;
  }

  // Method to update the token
  void updateToken(AuthResultData? newToken) {
    _authData = newToken;
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
        return caller(_dio); // Retry the API call with the new token
      },
      failed: (failure) => response,
    );
  }
}
