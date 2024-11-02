import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoginWithGitHub extends UseCase<ResponseModel<void>, NoParams> {
  final AuthRepo repo;

  LoginWithGitHub({required this.repo});
  @override
  Future<ResponseModel<void>> call(NoParams params) {
    return repo.loginWithGitHub();
  }
}
