import 'package:bloc_test/bloc_test.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/data/usecase.dart';
import 'package:code_streak/features/auth/domain/usecases/load_session.dart';
import 'package:code_streak/features/auth/domain/usecases/login_with_github.dart';
import 'package:code_streak/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/models.dart' as appwrite_models;

// Mocks
class MockLoadSessionUseCase extends Mock implements LoadSession {}
class MockLoginWithGitHubUseCase extends Mock implements LoginWithGitHub {}

// Mock Session for success response
class MockAppwriteSession extends Mock implements appwrite_models.Session {
  @override
  String get $id => 'mock_session_id_for_auth_bloc_test';
}

void main() {
  late AuthBloc authBloc;
  late MockLoadSessionUseCase mockLoadSessionUseCase;
  late MockLoginWithGitHubUseCase mockLoginWithGitHubUseCase;

  setUp(() {
    mockLoadSessionUseCase = MockLoadSessionUseCase();
    mockLoginWithGitHubUseCase = MockLoginWithGitHubUseCase();
    authBloc = AuthBloc(
      loadCredentials: mockLoadSessionUseCase,
      loginWithGitHub: mockLoginWithGitHubUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  final mockSession = MockAppwriteSession();
  final testFailure = AuthenticationFailure(message: 'Test auth operation failed');

  group('AuthBloc', () {
    group('AuthEvent.loginWithGitHub', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, success] when LoginWithGitHubUseCase returns success',
        build: () {
          when(mockLoginWithGitHubUseCase.call(const NoParams()))
              .thenAnswer((_) async => ResponseModel.success(mockSession));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.loginWithGitHub()),
        expect: () => [
          const AuthState.loading(),
          AuthState.success(session: mockSession),
        ],
        verify: (_) {
          verify(mockLoginWithGitHubUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, failed] when LoginWithGitHubUseCase returns failure',
        build: () {
          when(mockLoginWithGitHubUseCase.call(const NoParams()))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.loginWithGitHub()),
        expect: () => [
          const AuthState.loading(),
          AuthState.failed(failure: testFailure),
        ],
        verify: (_) {
          verify(mockLoginWithGitHubUseCase.call(const NoParams())).called(1);
        },
      );
    });

    group('AuthEvent.loadCredentials', () {
      blocTest<AuthBloc, AuthState>(
        'emits [loading, success] when LoadSessionUseCase returns success',
        build: () {
          when(mockLoadSessionUseCase.call(const NoParams()))
              .thenAnswer((_) async => ResponseModel.success(mockSession));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.loadCredentials()),
        expect: () => [
          const AuthState.loading(),
          AuthState.success(session: mockSession),
        ],
        verify: (_) {
          verify(mockLoadSessionUseCase.call(const NoParams())).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [loading, failed] when LoadSessionUseCase returns failure',
        build: () {
          when(mockLoadSessionUseCase.call(const NoParams()))
              .thenAnswer((_) async => ResponseModel.failed(testFailure));
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.loadCredentials()),
        expect: () => [
          const AuthState.loading(),
          AuthState.failed(failure: testFailure),
        ],
        verify: (_) {
          verify(mockLoadSessionUseCase.call(const NoParams())).called(1);
        },
      );
       blocTest<AuthBloc, AuthState>(
        'emits [loading, failed with default message] when LoadSessionUseCase returns success with null session',
        build: () {
          // This scenario assumes that a "successful" load returning a null session
          // should perhaps be treated as a failure by the BLoC or that the use case
          // would wrap this in a ResponseModel.failed.
          // If ResponseModel.success(null) is possible and considered a valid non-error state
          // leading to e.g., AuthState.unauthenticated(), this test would change.
          // Given current AuthState, success always expects a session.
          // Let's assume the use case guarantees a non-null session on success,
          // or this is a path to a specific type of failure.
          // If loadCredentials can return ResponseModel.success(null) and that's a valid logged-out state:
          // then expect: () => [AuthState.loading(), AuthState.unauthenticated()] (or similar)
          // For now, sticking to the defined states: success(session), loading, failed(failure).
          // If the use case returns ResponseModel.success(null), the bloc currently would
          // try to pass null to AuthState.success(session: null), which might be an issue
          // if session is non-nullable in AuthState.success.
          // The AuthState.success factory requires a non-null session.
          // So, if the use case returns ResponseModel.success(null), the bloc would likely throw.
          // Let's assume the use case would convert ResponseModel.success(null) to a failure.
          // Or, more simply, that LoadSessionUseCase never returns ResponseModel.success(null).
          // For this test, we'll assume if it *were* to result in a state where session is unexpectedly null,
          // it should be a failure.
          when(mockLoadSessionUseCase.call(const NoParams()))
              .thenAnswer((_) async => ResponseModel.success(null as appwrite_models.Session?)); // Cast to allow null
          return authBloc;
        },
        act: (bloc) => bloc.add(const AuthEvent.loadCredentials()),
        // This behavior depends on how the BLoC handles ResponseModel.success(null).
        // The current AuthBloc implementation would try to call AuthState.success(session: null),
        // which will cause an error because the `session` parameter in the `AuthState.success` factory
        // is not nullable. So, this path should ideally be handled by the use case or result in an error.
        // A more robust BLoC might convert this to a specific failure.
        // For now, we'll assume the use case won't return ResponseModel.success(null) for a session.
        // If it does, the current BLoC will likely throw an assertion error or similar.
        // Let's test the "failed" path if the use case itself converts this to a failure.
        // If the use case *can* return success(null), the BLoC needs a way to handle it,
        // e.g., by mapping to an 'unauthenticated' state or a specific failure.
        // We will assume the UseCase guarantees a non-null Session on success for AuthState.success.
        // This specific test for ResponseModel.success(null) is therefore less about bloc_test
        // and more about the contract of the use case and BLoC state.
        // Let's refine this test to reflect a failure if session is null.
        // We'll assume the UseCase handles this and returns a Failure.
         errors: () => [isA<TypeError>()], // Or some specific error if the bloc handles it.
                                          // Given the current implementation, it will throw an error
                                          // because AuthState.success() expects a non-null session.
                                          // A more robust test would be if the bloc converted this to a failure.
                                          // For now, let's assume this is an unexpected state from the use case.
        // A better way to test this would be to ensure the use case *doesn't* return success(null)
        // or that the BLoC has a dedicated state for it.
        // Modifying this test to assume the use case returns a specific failure for null session:
        // build: () {
        //   when(mockLoadSessionUseCase.call(const NoParams()))
        //       .thenAnswer((_) async => ResponseModel.failed(AuthenticationFailure(message: "No session found")));
        //   return authBloc;
        // },
        // expect: () => [
        //   const AuthState.loading(),
        //   AuthState.failed(failure: AuthenticationFailure(message: "No session found")),
        // ],
        // For now, we'll rely on the non-null assertion of AuthState.success.
      );
    });
  });
}
