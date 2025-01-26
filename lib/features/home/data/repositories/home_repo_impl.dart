import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/data/datasources/home_data_source.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/range_data.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeDataSource dataSource;
  final LocalDatabase localDatabase;

  HomeRepoImpl({
    required this.dataSource,
    required this.localDatabase,
  });

  @override
  Future<ResponseModel<UserInfo>> getUserInfo() {
    return dataSource.fetchUserInfo();
  }

  @override
  Future<ResponseModel<ContributionsData>> getContributionsData({
    required String username,
    required DateTime start,
    required DateTime end,
  }) async {
    late RangeData range;
    final localData = await localDatabase.getContributions();
    if (localData != null) {
      range = localData.getNotExistingRange(start, end);
    } else {
      range = RangeData.range(start: start, end: end);
    }
    return range.when(
      range: (from, till) async {
        // should fetch all or part of contributions from server
        final result =
            await dataSource.fetchGithubContributions(username, from, till);
        return result.when(
          success: (data) {
            final fullData = data.append(localData);
            localDatabase.saveContributions(fullData.withoutToday);
            return ResponseModel.success(fullData);
          },
          failed: (failure) => result,
        );
      },
      empty: () {
        // all data are available in local database
        return ResponseModel.success(localData!);
      },
    );
  }

  @override
  Future<ResponseModel<bool>> setUserReminders() {
    return dataSource.setUserReminders();
  }
}
