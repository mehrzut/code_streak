import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/features/auth/data/datasources/auth_data_source.dart';
import 'package:code_streak/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:code_streak/core/extensions.dart'; // For SessionExt .isExpired
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:appwrite/src/account.dart'; // For Account type in ClientHandler mock
import 'package:appwrite/appwrite.dart' as appwrite_sdk; // For AppwriteException

// Mocks
class MockAuthDataSource extends Mock implements AuthDataSource {}
class MockLocalDatabase extends Mock implements LocalDatabase {}
class MockClientHandler extends Mock implements ClientHandler {
  // Mock the 'account' getter if ClientHandler.instance.account is used directly by AuthRepoImpl
  // If AuthRepoImpl gets Account via constructor or method, this might not be needed here.
  // Based on AuthRepoImpl structure, it uses ClientHandler.instance.account.
  @override
  // ignore: overridden_fields
  final Account account;
  MockClientHandler(this.account); // Constructor to set the mock account
}
class MockAppwriteAccount extends Mock implements Account {} // Specific mock for ClientHandler.account
class MockAppwriteSession extends Mock implements appwrite_models.Session {
  // Mocking getters that are accessed
  @override
  String get $id => 'mock_session_id';
  @override
  String get providerAccessTokenExpiry => DateTime.now().add(const Duration(hours: 1)).toIso8601String(); // Default to not expired

  // Allow isExpired to be dynamically controlled
  bool _isExpired = false;
  void setExpired(bool expired) => _isExpired = expired;

  @override
  bool get isExpired => _isExpired; 
}

void main() {
  late AuthRepoImpl authRepo;
  late MockAuthDataSource mockAuthDataSource;
  late MockLocalDatabase mockLocalDatabase;
  late MockClientHandler mockClientHandler;
  late MockAppwriteAccount mockAppwriteAccount; // For ClientHandler.instance.account
  late ClientHandler originalClientHandlerInstance;


  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    mockLocalDatabase = MockLocalDatabase();
    mockAppwriteAccount = MockAppwriteAccount();
    mockClientHandler = MockClientHandler(mockAppwriteAccount); // Pass the account mock

    // Store and replace ClientHandler.instance
    originalClientHandlerInstance = ClientHandler.instance;
    ClientHandler.instance = mockClientHandler;

    authRepo = AuthRepoImpl(
      dataSource: mockAuthDataSource,
      localDB: mockLocalDatabase,
      // ClientHandler is accessed via ClientHandler.instance in the original code
    );
  });

  tearDown(() {
    // Restore original ClientHandler.instance
    ClientHandler.instance = originalClientHandlerInstance;
  });

  final mockSession = MockAppwriteSession();
  final mockExpiredSession = MockAppwriteSession()..setExpired(true);
  final mockRefreshedSession = MockAppwriteSession(); // Assumed not expired by default
  final testFailure = AuthenticationFailure(message: 'Test Auth Failure');

  group('AuthRepoImpl', () {
    group('loginWithGitHub', () {
      test('calls clientHandler.updateSession and localDB.saveSession on success', () async {
        // Arrange
        when(mockAuthDataSource.loginWithGitHub()).thenAnswer((_) async => ResponseModel.success(mockSession));
        
        // Act
        final result = await authRepo.loginWithGitHub();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockSession);
        verify(ClientHandler.instance.updateSession(mockSession)).called(1);
        verify(mockLocalDatabase.saveSession(mockSession)).called(1);
      });

      test('does not call session methods on data source failure', () async {
        // Arrange
        when(mockAuthDataSource.loginWithGitHub()).thenAnswer((_) async => ResponseModel.failed(testFailure));

        // Act
        final result = await authRepo.loginWithGitHub();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, testFailure);
        verifyNever(ClientHandler.instance.updateSession(any));
        verifyNever(mockLocalDatabase.saveSession(any));
      });
    });

    group('loadSession', () {
      test('local success, not expired: updates client handler', () async {
        // Arrange
        mockSession.setExpired(false);
        when(mockLocalDatabase.loadSession()).thenAnswer((_) async => ResponseModel.success(mockSession));
        
        // Act
        final result = await authRepo.loadSession();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockSession);
        verify(ClientHandler.instance.updateSession(mockSession)).called(1);
        verifyNever(mockAuthDataSource.refreshSession());
        verifyNever(mockLocalDatabase.saveSession(any));
      });

      test('local success, expired, refresh success: updates client and saves new session', () async {
        // Arrange
        mockExpiredSession.setExpired(true);
        when(mockLocalDatabase.loadSession()).thenAnswer((_) async => ResponseModel.success(mockExpiredSession));
        when(mockAuthDataSource.refreshSession()).thenAnswer((_) async => ResponseModel.success(mockRefreshedSession));

        // Act
        final result = await authRepo.loadSession();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockRefreshedSession);
        verify(mockAuthDataSource.refreshSession()).called(1);
        verify(ClientHandler.instance.updateSession(mockRefreshedSession)).called(1);
        verify(mockLocalDatabase.saveSession(mockRefreshedSession)).called(1);
      });

      test('local success, expired, refresh fails: returns original expired session', () async {
        // Arrange
        mockExpiredSession.setExpired(true);
        when(mockLocalDatabase.loadSession()).thenAnswer((_) async => ResponseModel.success(mockExpiredSession));
        when(mockAuthDataSource.refreshSession()).thenAnswer((_) async => ResponseModel.failed(testFailure));

        // Act
        final result = await authRepo.loadSession();

        // Assert
        // As per _checkExpiry logic, if refresh fails, it returns the original (potentially expired) session.
        expect(result.isSuccess, isTrue); 
        expect(result.data, mockExpiredSession);
        verify(mockAuthDataSource.refreshSession()).called(1);
        // updateSession should be called with the original expired session in this case
        verify(ClientHandler.instance.updateSession(mockExpiredSession)).called(1);
        verifyNever(mockLocalDatabase.saveSession(any)); 
      });
      
      test('local fail, online session success: returns online session, saves it', () async {
        // Arrange
        final localDbFailure = LocalDataBaseKeyNotFoundFailure();
        when(mockLocalDatabase.loadSession()).thenAnswer((_) async => ResponseModel.failed(localDbFailure));
        when(ClientHandler.instance.account.getSession(sessionId: 'current')).thenAnswer((_) async => mockSession);
        mockSession.setExpired(false); // Ensure it's not expired for this test

        // Act
        final result = await authRepo.loadSession();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockSession);
        verify(ClientHandler.instance.account.getSession(sessionId: 'current')).called(1);
        verify(ClientHandler.instance.updateSession(mockSession)).called(1);
        verify(mockLocalDatabase.saveSession(mockSession)).called(1);
      });

      test('local fail, online session success but expired, refresh success: returns refreshed, saves it', () async {
        // Arrange
        final localDbFailure = LocalDataBaseKeyNotFoundFailure();
        mockExpiredSession.setExpired(true);
        when(mockLocalDatabase.loadSession()).thenAnswer((_) async => ResponseModel.failed(localDbFailure));
        when(ClientHandler.instance.account.getSession(sessionId: 'current')).thenAnswer((_) async => mockExpiredSession);
        when(mockAuthDataSource.refreshSession()).thenAnswer((_) async => ResponseModel.success(mockRefreshedSession));
        
        // Act
        final result = await authRepo.loadSession();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockRefreshedSession);
        verify(ClientHandler.instance.account.getSession(sessionId: 'current')).called(1);
        verify(mockAuthDataSource.refreshSession()).called(1);
        verify(ClientHandler.instance.updateSession(mockRefreshedSession)).called(1);
        verify(mockLocalDatabase.saveSession(mockRefreshedSession)).called(1);
      });


      test('local fail, online session fail: returns original local DB failure', () async {
        // Arrange
        final localDbFailure = LocalDataBaseKeyNotFoundFailure(message: "Local DB Error");
        when(mockLocalDatabase.loadSession()).thenAnswer((_) async => ResponseModel.failed(localDbFailure));
        when(ClientHandler.instance.account.getSession(sessionId: 'current')).thenThrow(appwrite_sdk.AppwriteException('Online session fetch failed'));

        // Act
        final result = await authRepo.loadSession();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, localDbFailure);
        verify(ClientHandler.instance.account.getSession(sessionId: 'current')).called(1);
        verifyNever(ClientHandler.instance.updateSession(any));
        verifyNever(mockLocalDatabase.saveSession(any));
      });
       test('local fail, online session throws generic Exception: returns AppWriteFailure', () async {
        // Arrange
        final localDbFailure = LocalDataBaseKeyNotFoundFailure(message: "Local DB Error");
        when(mockLocalDatabase.loadSession()).thenAnswer((_) async => ResponseModel.failed(localDbFailure));
        when(ClientHandler.instance.account.getSession(sessionId: 'current')).thenThrow(Exception('Generic network error'));

        // Act
        final result = await authRepo.loadSession();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AppWriteFailure>()); // As per catch-all in _getOnlineSession
        expect(result.failure?.message, contains('Generic network error'));
      });
    });

    group('signOut', () {
      test('dataSource success: deletes local session and updates client handler', () async {
        // Arrange
        when(mockAuthDataSource.signOut()).thenAnswer((_) async => ResponseModel.success(true));

        // Act
        final result = await authRepo.signOut();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, true);
        verify(mockLocalDatabase.deleteSession()).called(1);
        verify(ClientHandler.instance.updateSession(null)).called(1);
      });

      test('dataSource failure: no local/client handler calls', () async {
        // Arrange
        when(mockAuthDataSource.signOut()).thenAnswer((_) async => ResponseModel.failed(testFailure));

        // Act
        final result = await authRepo.signOut();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, testFailure);
        verifyNever(mockLocalDatabase.deleteSession());
        verifyNever(ClientHandler.instance.updateSession(any));
      });
    });

    group('refreshSession (direct call)', () {
      test('dataSource success: updates client handler and saves session', () async {
        // Arrange
        when(mockAuthDataSource.refreshSession()).thenAnswer((_) async => ResponseModel.success(mockSession));
        
        // Act
        final result = await authRepo.refreshSession();

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, mockSession);
        verify(ClientHandler.instance.updateSession(mockSession)).called(1);
        verify(mockLocalDatabase.saveSession(mockSession)).called(1);
      });

      test('dataSource failure: no client handler/save calls', () async {
        // Arrange
        when(mockAuthDataSource.refreshSession()).thenAnswer((_) async => ResponseModel.failed(testFailure));

        // Act
        final result = await authRepo.refreshSession();

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, testFailure);
        verifyNever(ClientHandler.instance.updateSession(any));
        verifyNever(mockLocalDatabase.saveSession(any));
      });
    });
  });
}
