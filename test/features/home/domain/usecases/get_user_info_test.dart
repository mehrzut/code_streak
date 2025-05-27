import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:code_streak/features/home/domain/usecases/get_user_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockHomeRepo extends Mock implements HomeRepo {}
class MockUserInfo extends Mock implements UserInfo {}

void main() {
  late GetUserInfoUseCase usecase;
  late MockHomeRepo mockHomeRepo;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    usecase = GetUserInfoUseCase(repo: mockHomeRepo);
  });

  const String testUsername = 'testuser';
  final mockUserInfo = MockUserInfo(); // Using the mock for UserInfo
  final successResponse = ResponseModel<UserInfo>.success(mockUserInfo);
  final failureResponse = ResponseModel<UserInfo>.failed(APIErrorFailure(message: 'Failed to get user info'));

  group('GetUserInfoUseCase', () {
    final params = GetUserInfoUseCaseParams(username: testUsername);

    test('should call HomeRepo.getUserInfo with correct username', () async {
      // Arrange
      when(mockHomeRepo.getUserInfo(username: testUsername))
          .thenAnswer((_) async => successResponse);

      // Act
      final result = await usecase.call(params);

      // Assert
      expect(result, successResponse);
      verify(mockHomeRepo.getUserInfo(username: testUsername)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });

    test('should return failure response when HomeRepo.getUserInfo fails', () async {
      // Arrange
      when(mockHomeRepo.getUserInfo(username: testUsername))
          .thenAnswer((_) async => failureResponse);

      // Act
      final result = await usecase.call(params);

      // Assert
      expect(result, failureResponse);
      verify(mockHomeRepo.getUserInfo(username: testUsername)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });

    group('GetUserInfoUseCaseParams', () {
      test('props are correct', () {
        expect(params.props, [testUsername]);
      });

      test('instances with same data are equal', () {
        final params1 = GetUserInfoUseCaseParams(username: testUsername);
        final params2 = GetUserInfoUseCaseParams(username: testUsername);
        expect(params1, equals(params2));
        expect(params1.hashCode, equals(params2.hashCode));
      });
      
      test('instances with different data are not equal', () {
        final params1 = GetUserInfoUseCaseParams(username: testUsername);
        final params2 = GetUserInfoUseCaseParams(username: 'anotheruser');
        expect(params1, isNot(equals(params2)));
      });
    });
  });
}
