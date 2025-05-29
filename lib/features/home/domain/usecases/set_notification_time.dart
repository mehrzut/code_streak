import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SetNotificationTime extends UseCase<ResponseModel<bool>, Params> {
  final HomeRepo repo;

  SetNotificationTime({required this.repo});

  @override
  Future<ResponseModel<bool>> call(Params params) {
    return repo.setNotificationTime(params.notificationTime);
  }
}

class Params extends NoParams{
  final TimeOfDay notificationTime;

  Params({required this.notificationTime});
}