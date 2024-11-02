import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';

abstract class HomeRepo {
  Future<ResponseModel<UserInfo>> getUserInfo();
}
