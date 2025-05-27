import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:code_streak/features/auth/domain/usecases/sign_out.dart'; // Correct import
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock AuthRepo
class MockAuthRepo extends Mock implements AuthRepo {}

void main() {
  late SignOut usecase; // Corrected type
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    usecase = SignOut(repo: mockAuthRepo); // Corrected instantiation
  });

  final successResponse = ResponseModel<bool>.success(true);
  final failureResponse = ResponseModel<bool>.failed(AuthenticationFailure(message: 'Sign out failed'));

  test('should call AuthRepo.signOut and return its response', () async {
    // Arrange
    when(mockAuthRepo.signOut()).thenAnswer((_) async => successResponse);

    // Act
    final result = await usecase.call(const NoParams());

    // Assert
    expect(result, successResponse);
    verify(mockAuthRepo.signOut()).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });

  test('should return failure response when AuthRepo.signOut fails', () async {
    // Arrange
    when(mockAuthRepo.signOut()).thenAnswer((_) async => failureResponse);

    // Act
    final result = await usecase.call(const NoParams());

    // Assert
    expect(result, failureResponse);
    verify(mockAuthRepo.signOut()).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
