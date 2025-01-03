import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SetUserReminders extends UseCase<ResponseModel<bool>, NoParams> {
  final HomeRepo repo;

  SetUserReminders({required this.repo});

  @override
  Future<ResponseModel<bool>> call(NoParams params) {
    return repo.setUserReminders();
  }
}
