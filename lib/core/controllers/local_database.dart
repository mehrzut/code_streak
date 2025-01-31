import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:appwrite/models.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class LocalDatabase {
  Future<void> saveSession(Session data);
  Future<ResponseModel<Session>> loadSession();

  Future<void> deleteSession();

  Future<void> saveContributions(ContributionsData data);

  Future<void> deleteContributions();
  Future<ContributionsData?> getContributions();

  Future<Brightness> checkTheme();
  Future<void> saveTheme(Brightness brightness);
}

@LazySingleton(as: LocalDatabase)
class LocalDatabaseImpl implements LocalDatabase {
  const LocalDatabaseImpl();
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  static const _sessionKey = 'SESSION_KEY';
  static const _contributionsKey = 'CONTRIBUTIONS_KEY';
  static const _themeKey = 'THEME_KEY';

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

  @override
  Future<void> saveContributions(ContributionsData data) {
    return _storage.write(
        key: _contributionsKey, value: jsonEncode(data.toJson()));
  }

  @override
  Future<void> deleteContributions() {
    return _storage.delete(key: _contributionsKey);
  }

  @override
  Future<ContributionsData?> getContributions() async {
    final data = await _storage.read(key: _contributionsKey);
    if (data != null) {
      return ContributionsData.fromJson(jsonDecode(data));
    } else {
      return null;
    }
  }

  @override
  Future<Brightness> checkTheme() async {
    final data = await _storage.read(key: _themeKey);
    if (data != null) {
      return data == 'dark' ? Brightness.dark : Brightness.light;
    } else {
      return Brightness.dark;
    }
  }

  @override
  Future<void> saveTheme(Brightness brightness) {
    return _storage.write(
        key: _themeKey,
        value: brightness == Brightness.dark ? 'dark' : 'light');
  }
}
