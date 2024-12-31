import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/models.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class LocalDatabase {
  Future<void> saveSession(Session data);
  Future<ResponseModel<Session>> loadSession();

  Future<void> deleteSession();
}

@LazySingleton(as: LocalDatabase)
class LocalDatabaseImpl implements LocalDatabase {
  const LocalDatabaseImpl();
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  static const _sessionKey = 'SESSION_KEY';

  @override
  Future<ResponseModel<Session>> loadSession() async {
    final data = await _storage.read(key: _sessionKey);
    if (data != null) {
      return ResponseModel.success(Session.fromMap(jsonDecode(data)));
    } else {
      log('No Session!');
      return ResponseModel.failed(LocalDataBaseKeyNotFoundFailure());
    }
  }

  @override
  Future<void> saveSession(Session data) {
    return _storage.write(key: _sessionKey, value: jsonEncode(data.toMap()));
  }

  @override
  Future<void> deleteSession() {
    return _storage.delete(key: _sessionKey);
  }
}
