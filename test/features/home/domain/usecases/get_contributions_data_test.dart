import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:code_streak/features/home/domain/usecases/get_contributions_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockHomeRepo extends Mock implements HomeRepo {}
class MockContributionsData extends Mock implements ContributionsData {}

void main() {
  late GetContributionsDataUseCase usecase;
  late MockHomeRepo mockHomeRepo;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    usecase = GetContributionsDataUseCase(repo: mockHomeRepo);
  });

  const String testUsername = 'testuser';
  final mockContributions = MockContributionsData();
  final successResponse = ResponseModel<ContributionsData>.success(mockContributions);
  final failureResponse = ResponseModel<ContributionsData>.failed(APIErrorFailure(message: 'Failed to get contributions'));

  group('GetContributionsDataUseCase', () {
    final params = GetContributionsDataUseCaseParams(username: testUsername);

    test('should call HomeRepo.getContributionsData with correct username', () async {
      // Arrange
      when(mockHomeRepo.getContributionsData(username: testUsername))
          .thenAnswer((_) async => successResponse);

      // Act
      final result = await usecase.call(params);

      // Assert
      expect(result, successResponse);
      verify(mockHomeRepo.getContributionsData(username: testUsername)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });

    test('should return failure response when HomeRepo.getContributionsData fails', () async {
      // Arrange
      when(mockHomeRepo.getContributionsData(username: testUsername))
          .thenAnswer((_) async => failureResponse);

      // Act
      final result = await usecase.call(params);

      // Assert
      expect(result, failureResponse);
      verify(mockHomeRepo.getContributionsData(username: testUsername)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });

    group('GetContributionsDataUseCaseParams', () {
      test('props are correct', () {
        expect(params.props, [testUsername]);
      });

      test('instances with same data are equal', () {
        final params1 = GetContributionsDataUseCaseParams(username: testUsername);
        final params2 = GetContributionsDataUseCaseParams(username: testUsername);
        expect(params1, equals(params2));
        expect(params1.hashCode, equals(params2.hashCode));
      });

      test('instances with different data are not equal', () {
         final params1 = GetContributionsDataUseCaseParams(username: testUsername);
        final params2 = GetContributionsDataUseCaseParams(username: 'anotheruser');
        expect(params1, isNot(equals(params2)));
      });
    });
  });
}
