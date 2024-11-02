import 'dart:io';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:code_streak/injector.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:oauth2_client/access_token_response.dart';

@lazySingleton
class ApiHandler {
  AccessTokenResponse? _token;
  final Dio _dio;

  ApiHandler() : _dio = Dio(BaseOptions()) {
    // Add the token interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add the token to the headers if it is available
        if (_token?.accessToken != null && _token!.accessToken!.isNotEmpty) {
          options.headers[HttpHeaders.authorizationHeader] =
              'Bearer ${_token!.accessToken}';
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
  void updateToken(AccessTokenResponse? newToken) {
    _token = newToken;
  }

  Future<Response> callApi(Future<Response> Function(Dio dio) caller) async {
    final response = await caller(_dio);
    if (response.statusCode == HttpStatus.unauthorized) {
      return _refreshToken(response, caller);
    }
    return response;
  }

  Future<Response> _refreshToken(
    Response response,
    Future<Response> Function(Dio dio) caller,
  ) async {
    final result = await sl<AuthRepo>().loginWithGitHub();
    return result.when(
      success: (data) {
        updateToken(data);
        return caller(_dio); // Retry the API call with the new token
      },
      failed: (failure) => response,
    );
  }
}
