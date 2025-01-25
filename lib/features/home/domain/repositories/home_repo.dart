import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';

abstract class HomeRepo {
  Future<ResponseModel<UserInfo>> getUserInfo();

  Future<ResponseModel<ContributionsData>> getContributionsData({
    required String username,
    required DateTime start,
    required DateTime end,
  });

  Future<ResponseModel<bool>> setUserReminders();
}
