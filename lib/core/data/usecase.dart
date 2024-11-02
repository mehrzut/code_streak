abstract class UseCase<T, Params extends NoParams> {
  Future<T> call(Params params);
}

class NoParams {}
