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

class APIErrorFailure extends Failure {
  APIErrorFailure({super.message});
}

class AppWritePrefFailure extends Failure {
  AppWritePrefFailure();
}

class AppWriteFailure extends Failure {
  AppWriteFailure({super.message});
}

class FirebaseFailure extends Failure {
  FirebaseFailure();
}

class PermissionFailure extends Failure {
  PermissionFailure();
}

class GeneralFailure extends Failure {
  GeneralFailure({super.message});
}
