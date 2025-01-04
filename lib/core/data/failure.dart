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

class AppwritePrefFailure extends Failure {
  AppwritePrefFailure();
}
class FirebaseFailure extends Failure {
  FirebaseFailure();
}

class PermissionFailure extends Failure {
  PermissionFailure();
}
