import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/data/datasources/home_data_source.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeDataSource dataSource;

  HomeRepoImpl({required this.dataSource});

  @override
  Future<ResponseModel<UserInfo>> getUserInfo() {
    return dataSource.fetchUserInfo();
  }
}
