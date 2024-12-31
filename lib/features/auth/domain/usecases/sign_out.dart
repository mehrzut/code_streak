import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SignOut extends UseCase<ResponseModel<bool>, NoParams> {
  final AuthRepo repo;

  SignOut({required this.repo});

  @override
  Future<ResponseModel<bool>> call(NoParams params) {
    return repo.signOut();
  }
}
