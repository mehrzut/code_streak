import 'dart:convert';
import 'dart:developer';

import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:oauth2_client/access_token_response.dart';

abstract class LocalDatabase {
  Future<void> saveCredentials(AccessTokenResponse data);
  Future<ResponseModel<AccessTokenResponse>> loadCredentials();
}

@LazySingleton(as: LocalDatabase)
class LocalDatabaseImpl implements LocalDatabase {
  const LocalDatabaseImpl();
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  static const _credentialsKey = 'CREDENTIALS_KEY';

  @override
  Future<ResponseModel<AccessTokenResponse>> loadCredentials() async {
    final data = await _storage.read(key: _credentialsKey);
    if (data != null) {
      return ResponseModel.success(
          AccessTokenResponse.fromMap(jsonDecode(data)));
    } else {
      log('No Credentials!');
      return ResponseModel.failed(LocalDataBaseKeyNotFoundFailure());
    }
  }

  @override
  Future<void> saveCredentials(AccessTokenResponse data) {
    return _storage.write(
        key: _credentialsKey, value: jsonEncode(data.toMap()));
  }
}
