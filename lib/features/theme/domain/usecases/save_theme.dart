import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/theme/domain/repositories/theme_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveTheme extends UseCase<void, Params> {
  final ThemeRepo repo;

  SaveTheme({required this.repo});

  @override
  Future<void> call(Params params) {
    return repo.saveTheme(params.brightness);
  }
}

class Params extends NoParams {
  final Brightness brightness;

  Params({required this.brightness});
}
