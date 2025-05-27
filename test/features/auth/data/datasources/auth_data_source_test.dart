import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:appwrite/src/account.dart';
import 'package:appwrite/appwrite.dart'; // For AppwriteException

// Mocks
class MockClientHandler extends Mock implements ClientHandler {}
class MockAccount extends Mock implements Account {}
class MockAppwriteUser extends Mock implements appwrite_models.User {}
class MockAppwriteSession extends Mock implements appwrite_models.Session {
  @override
  String get $id => 'mock_session_id'; // Mocking the getter
}

void main() {
  late AuthDataSourceImpl authDataSource;
  late MockClientHandler mockClientHandler;
  late MockAccount mockAccount;

  setUp(() {
    mockClientHandler = MockClientHandler();
    mockAccount = MockAccount();
    when(mockClientHandler.account).thenReturn(mockAccount);
    authDataSource = AuthDataSourceImpl(client: mockClientHandler);
  });

  group('AuthDataSourceImpl', () {
    group('loginWithGitHub', () {
      final mockUser = MockAppwriteUser();
      final mockSession = MockAppwriteSession();

      test('returns ResponseModel.success when Appwrite calls succeed', () async {
        // Arrange
        when(mockAccount.createOAuth2Session(provider: 'github', success: anyNamed('success'), failure: anyNamed('failure')))
            .thenAnswer((_) async => null); // Simulate successful redirection, no direct return
        when(mockAccount.get()).thenAnswer((_) async => mockUser);
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => mockSession);

        // Act
        final result = await authDataSource.loginWithGitHub();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockSession);
        verify(mockAccount.createOAuth2Session(provider: 'github', success: anyNamed('success'), failure: anyNamed('failure'))).called(1);
        // verify(mockAccount.get()).called(1); // get() is not called in the original code
        verify(mockAccount.getSession(sessionId: 'current')).called(1);
      });

      test('returns ResponseModel.failed when createOAuth2Session throws', () async {
        // Arrange
        when(mockAccount.createOAuth2Session(provider: 'github', success: anyNamed('success'), failure: anyNamed('failure')))
            .thenThrow(AppwriteException('OAuth failed', 500));

        // Act
        final result = await authDataSource.loginWithGitHub();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        expect(result.failure?.message, contains('OAuth failed'));
        verify(mockAccount.createOAuth2Session(provider: 'github', success: anyNamed('success'), failure: anyNamed('failure'))).called(1);
        verifyNever(mockAccount.get());
        verifyNever(mockAccount.getSession(sessionId: 'current'));
      });

      test('returns ResponseModel.failed when getSession throws', () async {
        // Arrange
        when(mockAccount.createOAuth2Session(provider: 'github', success: anyNamed('success'), failure: anyNamed('failure')))
            .thenAnswer((_) async => null);
        when(mockAccount.get()).thenAnswer((_) async => mockUser); // Though not called, good to have
        when(mockAccount.getSession(sessionId: 'current')).thenThrow(AppwriteException('Get session failed', 500));
        
        // Act
        final result = await authDataSource.loginWithGitHub();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        expect(result.failure?.message, contains('Get session failed'));
        verify(mockAccount.getSession(sessionId: 'current')).called(1);
      });
    });

    group('signOut', () {
      final mockSession = MockAppwriteSession();

      test('returns ResponseModel.success when all calls succeed', () async {
        // Arrange
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => mockSession);
        when(mockAccount.deletePushTarget(id: anyNamed('id'))).thenAnswer((_) async => null); // Assuming targetId is 'current'
        when(mockAccount.deleteSession(sessionId: 'current')).thenAnswer((_) async => null);
        
        // Act
        final result = await authDataSource.signOut();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, isTrue);
        verify(mockAccount.getSession(sessionId: 'current')).called(1);
        // The targetId in deletePushTarget is hardcoded as "current" in the source.
        verify(mockAccount.deletePushTarget(id: 'current')).called(1);
        verify(mockAccount.deleteSession(sessionId: 'current')).called(1);
      });

      test('returns ResponseModel.failed when getSession throws', () async {
        // Arrange
        when(mockAccount.getSession(sessionId: 'current')).thenThrow(AppwriteException('Get session failed'));

        // Act
        final result = await authDataSource.signOut();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        verifyNever(mockAccount.deletePushTarget(id: anyNamed('id')));
        verifyNever(mockAccount.deleteSession(sessionId: 'current'));
      });
      
      test('returns ResponseModel.failed when deleteSession throws', () async {
        // Arrange
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => mockSession);
        when(mockAccount.deletePushTarget(id: 'current')).thenAnswer((_) async => null);
        when(mockAccount.deleteSession(sessionId: 'current')).thenThrow(AppwriteException('Delete session failed', 500));

        // Act
        final result = await authDataSource.signOut();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        expect(result.failure?.message, contains('Delete session failed'));
        verify(mockAccount.deletePushTarget(id: 'current')).called(1); // This is called before deleteSession
        verify(mockAccount.deleteSession(sessionId: 'current')).called(1);
      });

      test('returns ResponseModel.success even if deletePushTarget throws (as per current implementation)', () async {
        // Arrange
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => mockSession);
        when(mockAccount.deletePushTarget(id: 'current')).thenThrow(AppwriteException('Delete target failed', 500));
        when(mockAccount.deleteSession(sessionId: 'current')).thenAnswer((_) async => null);

        // Act
        final result = await authDataSource.signOut();

        // Assert
        // The original code catches the error from deletePushTarget and logs it but proceeds.
        // It will then attempt deleteSession. If that succeeds, the overall result is success.
        expect(result.isSuccess, isTrue);
        expect(result.data, isTrue);
        verify(mockAccount.deletePushTarget(id: 'current')).called(1);
        verify(mockAccount.deleteSession(sessionId: 'current')).called(1);
      });
       test('returns ResponseModel.failed if getSession returns null (no active session)', () async {
        // Arrange
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => null); // No active session

        // Act
        final result = await authDataSource.signOut();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        expect(result.failure?.message, 'Failed to sign out: No active session found.');
        verifyNever(mockAccount.deletePushTarget(id: anyNamed('id')));
        verifyNever(mockAccount.deleteSession(sessionId: 'current'));
      });

    });

    group('refreshSession', () {
      final mockSession = MockAppwriteSession();
      final mockRefreshedSession = MockAppwriteSession(); // Different instance for clarity

      test('returns ResponseModel.success with refreshed session when calls succeed', () async {
        // Arrange
        // updateSession needs a session ID. Let's assume 'current' is used or obtained.
        // The code calls updateSession with the current session's ID.
        // First, we need a "current" session to get its ID.
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => mockSession);
        // Then, updateSession is called with this session's ID
        when(mockAccount.updateSession(sessionId: mockSession.$id, secret: anyNamed('secret'))) // The code uses empty secret
            .thenAnswer((_) async => mockRefreshedSession); // This should be the new session after update
        
        // The original code then calls getSession again, which seems redundant if updateSession returns the new session.
        // Let's assume it's to confirm or get the latest state.
        // when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => mockRefreshedSession); 
        // Based on the code, updateSession is called, then getSession('current') is called.
        // Let's make sure the final getSession returns the refreshed one.

        // Act
        final result = await authDataSource.refreshSession();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockRefreshedSession); // Should be the session from the *final* getSession call
        verify(mockAccount.getSession(sessionId: 'current')).called(1); // First call to get current session ID
        // The original code does:
        // 1. account.getSession(sessionId: 'current') -> oldSession
        // 2. account.updateSession(sessionId: oldSession.$id, secret: '') -> newSessionFromUpdate
        // 3. account.getSession(sessionId: 'current') -> finalSession
        // So, the second getSession call is what's returned.
        // We need to adjust the mock for the second getSession call.
        
        // Corrected mocking sequence for refreshSession based on code logic:
        reset(mockAccount); // Reset previous mocks for this specific test
        final oldSession = MockAppwriteSession();
        final newUpdatedSession = MockAppwriteSession(); // This is what updateSession returns
        final finalSessionAfterGet = MockAppwriteSession(); // This is what the *second* getSession returns

        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((invocation) async {
          // This will be called twice. First time return old, second time return final.
          if (invocation.positionalArguments.isEmpty && invocation.namedArguments.isEmpty && invocation.memberName == #getSession && mockAccount.getSession(sessionId: 'current').calls.length <=1) {
             //This is a bit of hacky way to simulate multiple calls returning different values without complex setup
             //It's better to rely on sequential `thenAnswer` if the mockito version supports it well for the same method.
             //For now, let's assume first call gets an "old" session, second gets the "final" one.
             //Actually, the code is:
             // 1. s = account.getSession('current')
             // 2. account.updateSession(s.$id, '')
             // 3. sNew = account.getSession('current')
             // return sNew
            return oldSession; // First call
          }
          return finalSessionAfterGet; // Second call
        });
        when(mockAccount.updateSession(sessionId: oldSession.$id, secret: '')).thenAnswer((_) async => newUpdatedSession);
        // The final getSession call is what matters for the return value
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => finalSessionAfterGet);


        final resultCorrected = await authDataSource.refreshSession();
        expect(resultCorrected.isSuccess, isTrue);
        expect(resultCorrected.data, finalSessionAfterGet);
        verify(mockAccount.getSession(sessionId: 'current')).called(2); // Called twice
        verify(mockAccount.updateSession(sessionId: oldSession.$id, secret: '')).called(1);

      });

      test('returns ResponseModel.failed if initial getSession fails', () async {
        // Arrange
        when(mockAccount.getSession(sessionId: 'current')).thenThrow(AppwriteException('Get session failed'));

        // Act
        final result = await authDataSource.refreshSession();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        verifyNever(mockAccount.updateSession(sessionId: anyNamed('sessionId'), secret: anyNamed('secret')));
      });
      
      test('returns ResponseModel.failed if updateSession fails', () async {
        // Arrange
        final currentSession = MockAppwriteSession();
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((_) async => currentSession);
        when(mockAccount.updateSession(sessionId: currentSession.$id, secret: ''))
            .thenThrow(AppwriteException('Update session failed'));

        // Act
        final result = await authDataSource.refreshSession();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        verify(mockAccount.updateSession(sessionId: currentSession.$id, secret: '')).called(1);
      });
      
      test('returns ResponseModel.failed if second getSession fails after successful update', () async {
        // Arrange
        final currentSession = MockAppwriteSession();
        final updatedSession = MockAppwriteSession();
        when(mockAccount.getSession(sessionId: 'current')).thenAnswer((invocation) async {
           // First call returns currentSession, subsequent (second) call will throw
           if (mockAccount.getSession(sessionId: 'current').calls.length <= 1) {
             return currentSession;
           }
           throw AppwriteException('Second getSession failed');
        });
        when(mockAccount.updateSession(sessionId: currentSession.$id, secret: ''))
            .thenAnswer((_) async => updatedSession);

        // Act
        final result = await authDataSource.refreshSession();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AuthenticationFailure>());
        expect(result.failure?.message, contains('Second getSession failed'));
        verify(mockAccount.getSession(sessionId: 'current')).called(2); // Called twice
        verify(mockAccount.updateSession(sessionId: currentSession.$id, secret: '')).called(1);
      });
    });
  });
}
