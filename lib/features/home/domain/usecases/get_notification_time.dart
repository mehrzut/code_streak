import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetNotificationTime extends UseCase<ResponseModel<TimeOfDay>, NoParams> {
  final HomeRepo repo;

  GetNotificationTime({required this.repo});

  @override
  Future<ResponseModel<TimeOfDay>> call(NoParams params) {
    return repo.getNotificationTime();
  }
}