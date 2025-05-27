import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:code_streak/core/data/failure.dart'; // Required for ResponseModel.failed

// Mock Parameters
class MockParams extends NoParams {
  final int id;
  final bool shouldSucceed;

  MockParams({required this.id, this.shouldSucceed = true});

  @override
  List<Object?> get props => [id, shouldSucceed];
}

// Mock UseCase
class MockUseCase extends UseCase<String, MockParams> {
  @override
  Future<ResponseModel<String>> call(MockParams params) async {
    if (params.shouldSucceed) {
      return ResponseModel.success("Success for ID: ${params.id}");
    } else {
      return ResponseModel.failed(GeneralFailure(message: "Failure for ID: ${params.id}"));
    }
  }
}

class MockUseCaseNoParams extends UseCase<String, NoParams> {
  final bool shouldSucceed;

  MockUseCaseNoParams({this.shouldSucceed = true});

  @override
  Future<ResponseModel<String>> call(NoParams params) async {
    if (shouldSucceed) {
      return ResponseModel.success("Success with NoParams");
    } else {
      return ResponseModel.failed(GeneralFailure(message: "Failure with NoParams"));
    }
  }
}

void main() {
  group('NoParams', () {
    test('can be instantiated', () {
      const noParams = NoParams();
      // The main check is that it doesn't throw and can be used.
      // props getter is the primary functionality to test if needed.
      expect(noParams, isA<NoParams>());
      expect(noParams.props, isEmpty); // NoParams has empty props
    });

     test('two instances are equal', () {
      const noParams1 = NoParams();
      const noParams2 = NoParams();
      expect(noParams1, equals(noParams2));
      expect(noParams1.hashCode, equals(noParams2.hashCode));
    });
  });

  group('UseCase', () {
    late MockUseCase mockUseCase;
    late MockUseCaseNoParams mockUseCaseNoParams;

    setUp(() {
      mockUseCase = MockUseCase();
      mockUseCaseNoParams = MockUseCaseNoParams();
    });

    group('MockUseCase with MockParams', () {
      test('returns success when shouldSucceed is true', () async {
        final params = MockParams(id: 1, shouldSucceed: true);
        final response = await mockUseCase.call(params);

        response.when(
          success: (data) {
            expect(data, "Success for ID: 1");
          },
          failed: (failure) {
            fail('Should not have failed for shouldSucceed: true');
          },
        );
        expect(response.isSuccess, isTrue);
        expect(response.data, "Success for ID: 1");
      });

      test('returns failure when shouldSucceed is false', () async {
        final params = MockParams(id: 2, shouldSucceed: false);
        final response = await mockUseCase.call(params);

        response.when(
          success: (data) {
            fail('Should not have succeeded for shouldSucceed: false');
          },
          failed: (failure) {
            expect(failure, isA<GeneralFailure>());
            expect(failure.message, "Failure for ID: 2");
          },
        );
        expect(response.isFailed, isTrue);
        expect(response.failure?.message, "Failure for ID: 2");
      });
    });
    
    group('MockUseCaseNoParams with NoParams', () {
      test('returns success when shouldSucceed is true', () async {
        mockUseCaseNoParams = MockUseCaseNoParams(shouldSucceed: true);
        const params = NoParams();
        final response = await mockUseCaseNoParams.call(params);

        response.when(
          success: (data) {
            expect(data, "Success with NoParams");
          },
          failed: (failure) {
            fail('Should not have failed for shouldSucceed: true');
          },
        );
        expect(response.isSuccess, isTrue);
      });

      test('returns failure when shouldSucceed is false', () async {
        mockUseCaseNoParams = MockUseCaseNoParams(shouldSucceed: false);
        const params = NoParams();
        final response = await mockUseCaseNoParams.call(params);

        response.when(
          success: (data) {
            fail('Should not have succeeded for shouldSucceed: false');
          },
          failed: (failure) {
            expect(failure, isA<GeneralFailure>());
            expect(failure.message, "Failure with NoParams");
          },
        );
        expect(response.isFailed, isTrue);
      });
    });
  });
}
