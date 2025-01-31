import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/theme/domain/repositories/theme_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CheckTheme extends UseCase<Brightness, NoParams> {
  final ThemeRepo repo;

  CheckTheme({required this.repo});

  @override
  Future<Brightness> call(NoParams params) {
  return repo.checkTheme();
  }
  
}
