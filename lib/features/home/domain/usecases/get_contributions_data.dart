import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetContributionsData
    extends UseCase<ResponseModel<ContributionsData>, Params> {
      final HomeRepo repo;

  GetContributionsData({required this.repo});
      @override
      Future<ResponseModel<ContributionsData>> call(Params params) {
    return repo.getContributionsData(username:params.username);
      }
      
    }

class Params extends NoParams {
  final String username;

  Params({required this.username});
}
