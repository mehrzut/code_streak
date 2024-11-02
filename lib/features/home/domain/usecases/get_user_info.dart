import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetUserInfo extends UseCase<ResponseModel<UserInfo>, NoParams> {
  final HomeRepo repo;

  GetUserInfo({required this.repo});
  @override
  Future<ResponseModel<UserInfo>> call(NoParams params) {
    return repo.getUserInfo();
  }
}
