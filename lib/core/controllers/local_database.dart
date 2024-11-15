import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

abstract class LocalDatabase {}

@LazySingleton(as: LocalDatabase)
class LocalDatabaseImpl implements LocalDatabase {
  const LocalDatabaseImpl();
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));
}
