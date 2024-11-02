abstract class Failure {
  final String? message;

  Failure({this.message});
}

class AuthenticationFailure extends Failure {
  AuthenticationFailure({super.message});
}

class LocalDataBaseKeyNotFoundFailure extends Failure {
  LocalDataBaseKeyNotFoundFailure({super.message});
}
