import 'dart:ui';

import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/features/theme/domain/repositories/theme_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ThemeRepo)
class ThemeRepoImpl implements ThemeRepo {
  final LocalDatabase localDatabase;

  ThemeRepoImpl({required this.localDatabase});

  @override
  Future<Brightness> checkTheme() {
    return localDatabase.checkTheme();
  }

  @override
  Future<void> saveTheme(Brightness brightness) {
    return localDatabase.saveTheme(brightness);
  }
}
