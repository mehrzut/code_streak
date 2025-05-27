import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/repositories/auth_repo.dart';
import 'package:code_streak/features/auth/domain/usecases/load_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/models.dart' as appwrite_models;

// Mock AuthRepo
class MockAuthRepo extends Mock implements AuthRepo {}

// Mock Session for success response
class MockAppwriteSession extends Mock implements appwrite_models.Session {
  @override
  String get $id => 'mock_session_id_for_usecase_test';
}

void main() {
  late LoadSession usecase;
  late MockAuthRepo mockAuthRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepo();
    usecase = LoadSession(repo: mockAuthRepo);
  });

  final mockSession = MockAppwriteSession();
  final successResponse = ResponseModel<appwrite_models.Session>.success(mockSession);
  final failureResponse = ResponseModel<appwrite_models.Session>.failed(AuthenticationFailure(message: 'Load session failed'));

  test('should call AuthRepo.loadSession and return its response', () async {
    // Arrange
    when(mockAuthRepo.loadSession()).thenAnswer((_) async => successResponse);

    // Act
    final result = await usecase.call(const NoParams());

    // Assert
    expect(result, successResponse);
    verify(mockAuthRepo.loadSession()).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });

  test('should return failure response when AuthRepo.loadSession fails', () async {
    // Arrange
    when(mockAuthRepo.loadSession()).thenAnswer((_) async => failureResponse);

    // Act
    final result = await usecase.call(const NoParams());

    // Assert
    expect(result, failureResponse);
    verify(mockAuthRepo.loadSession()).called(1);
    verifyNoMoreInteractions(mockAuthRepo);
  });
}
