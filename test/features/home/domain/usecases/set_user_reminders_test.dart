import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/repositories/home_repo.dart';
import 'package:code_streak/features/home/domain/usecases/set_user_reminders.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockHomeRepo extends Mock implements HomeRepo {}

void main() {
  late SetUserRemindersUseCase usecase;
  late MockHomeRepo mockHomeRepo;

  setUp(() {
    mockHomeRepo = MockHomeRepo();
    usecase = SetUserRemindersUseCase(repo: mockHomeRepo);
  });

  const bool testEnable = true;
  const String testTime = '10:00';
  const String testUsername = 'testuser';
  
  final successResponse = ResponseModel<bool>.success(true);
  final failureResponse = ResponseModel<bool>.failed(PermissionFailure(message: 'Failed to set reminders'));

  group('SetUserRemindersUseCase', () {
    final params = SetUserRemindersUseCaseParams(enable: testEnable, time: testTime, username: testUsername);

    test('should call HomeRepo.setUserReminders with correct parameters', () async {
      // Arrange
      when(mockHomeRepo.setUserReminders(enable: testEnable, time: testTime, username: testUsername))
          .thenAnswer((_) async => successResponse);

      // Act
      final result = await usecase.call(params);

      // Assert
      expect(result, successResponse);
      verify(mockHomeRepo.setUserReminders(enable: testEnable, time: testTime, username: testUsername)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });

    test('should return failure response when HomeRepo.setUserReminders fails', () async {
      // Arrange
      when(mockHomeRepo.setUserReminders(enable: testEnable, time: testTime, username: testUsername))
          .thenAnswer((_) async => failureResponse);

      // Act
      final result = await usecase.call(params);

      // Assert
      expect(result, failureResponse);
      verify(mockHomeRepo.setUserReminders(enable: testEnable, time: testTime, username: testUsername)).called(1);
      verifyNoMoreInteractions(mockHomeRepo);
    });

    group('SetUserRemindersUseCaseParams', () {
      test('props are correct', () {
        expect(params.props, [testEnable, testTime, testUsername]);
      });

      test('instances with same data are equal', () {
        final params1 = SetUserRemindersUseCaseParams(enable: testEnable, time: testTime, username: testUsername);
        final params2 = SetUserRemindersUseCaseParams(enable: testEnable, time: testTime, username: testUsername);
        expect(params1, equals(params2));
        expect(params1.hashCode, equals(params2.hashCode));
      });
      
      test('instances with different data are not equal', () {
        final params1 = SetUserRemindersUseCaseParams(enable: testEnable, time: testTime, username: testUsername);
        final params2 = SetUserRemindersUseCaseParams(enable: false, time: testTime, username: testUsername);
        final params3 = SetUserRemindersUseCaseParams(enable: testEnable, time: '11:00', username: testUsername);
        final params4 = SetUserRemindersUseCaseParams(enable: testEnable, time: testTime, username: 'anotheruser');
        expect(params1, isNot(equals(params2)));
        expect(params1, isNot(equals(params3)));
        expect(params1, isNot(equals(params4)));
      });
    });
  });
}
