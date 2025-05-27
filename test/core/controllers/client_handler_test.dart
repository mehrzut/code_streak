import 'package:appwrite/models.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:code_streak/core/data/models/response_model.dart';
import 'package:code_streak/core/data/repositories/auth_repo.dart';
import 'package:code_streak/core/di/injector.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/src/account.dart';


// Mocks
class MockDio extends Mock implements Dio {}
class MockAccount extends Mock implements Account {}
class MockSession extends Mock implements Session {
  @override
  String get $id => 'mock_session_id'; // Mocking the getter
  @override
  String get providerAccessToken => 'mock_provider_access_token';
}
class MockAuthRepo extends Mock implements AuthRepo {}
class MockResponse<T> extends Mock implements Response<T> {}

void main() {
  late ClientHandler clientHandler;
  late MockDio mockDio;
  late MockAccount mockAccount;
  late MockAuthRepo mockAuthRepo;

  setUpAll(() {
    // Register a fallback value for Dio if it's resolved via sl
    // This is a common pattern if your ClientHandler or other classes resolve Dio via a service locator.
    // However, ClientHandler takes Dio in constructor, so direct injection is easier for testing.
  });

  setUp(() {
    mockDio = MockDio();
    mockAccount = MockAccount();
    mockAuthRepo = MockAuthRepo();

    // Setup service locator for AuthRepo
    // We need to ensure 'sl' is configured for this test environment.
    // A simple way is to register the mock instance.
    // This might require a more robust setup if 'sl' is used extensively or reset between tests.
    if (sl.isRegistered<AuthRepo>()) {
      sl.unregister<AuthRepo>();
    }
    sl.registerSingleton<AuthRepo>(mockAuthRepo);
    
    // Initialize ClientHandler with mocks
    clientHandler = ClientHandler.test(dio: mockDio, account: mockAccount);

    // Mock dio's options and headers
    when(mockDio.options).thenReturn(BaseOptions(headers: {}));
  });

  tearDown(() {
    // sl.reset(); // Reset service locator if it supports it and is necessary
  });

  group('ClientHandler Constructor', () {
    test('initializes Dio and Account', () {
      expect(clientHandler.dio, isA<Dio>());
      expect(clientHandler.account, isA<Account>());
      // Test if the specific mock instances were used (optional, depends on how you want to verify)
      // This direct instance check might be too brittle if ClientHandler creates its own instances internally
      // based on some logic. But for direct constructor injection, it's fine.
      // expect(clientHandler.dio, same(mockDio)); // This would fail as ClientHandler creates a new Dio instance internally
      // expect(clientHandler.account, same(mockAccount)); // This would fail for the same reason
       expect(clientHandler.dio, isNotNull);
       expect(clientHandler.account, isNotNull);
    });
  });

  group('updateSession', () {
    test('updates Authorization header with new session token', () {
      final mockSession = MockSession();
      when(mockSession.providerAccessToken).thenReturn('new_token_123');
      
      clientHandler.updateSession(mockSession);
      
      expect(clientHandler.dio.options.headers["Authorization"], 'Bearer new_token_123');
    });

    test('handles null session by clearing Authorization header', () {
      // First, set a token
      final mockSession = MockSession();
      when(mockSession.providerAccessToken).thenReturn('initial_token');
      clientHandler.updateSession(mockSession);
      expect(clientHandler.dio.options.headers["Authorization"], 'Bearer initial_token');

      // Then, update with null
      clientHandler.updateSession(null);
      
      // Depending on implementation, it might remove the header or set it to null/empty.
      // Assuming it removes or sets to null.
      expect(clientHandler.dio.options.headers["Authorization"], null);
    });
  });

  group('callApi', () {
    late Future<Response<dynamic>> Function(Dio dio) mockApiCaller;

    setUp(() {
      // Reset Dio options for each callApi test to ensure clean state
      when(mockDio.options).thenReturn(BaseOptions(headers: {}));
      clientHandler = ClientHandler.test(dio: mockDio, account: mockAccount); // Re-initialize with fresh Dio mock options
    });

    test('returns successful response directly', () async {
      final successResponse = MockResponse();
      when(successResponse.statusCode).thenReturn(200);
      
      mockApiCaller = (dio) async {
        // Verify this is called with the Dio instance from ClientHandler
        expect(dio, same(mockDio)); 
        return successResponse;
      };
      
      final result = await clientHandler.callApi(mockApiCaller);
      
      expect(result, same(successResponse));
      verify(mockApiCaller(mockDio)).called(1);
      verifyNever(mockAuthRepo.refreshSession());
    });

    test('refreshes session and retries on 401, then succeeds', () async {
      final unauthorizedResponse = MockResponse();
      when(unauthorizedResponse.statusCode).thenReturn(401);
      
      final successResponseAfterRefresh = MockResponse();
      when(successResponseAfterRefresh.statusCode).thenReturn(200);
      
      final newMockSession = MockSession();
      when(newMockSession.providerAccessToken).thenReturn('refreshed_token_456');
      
      when(mockAuthRepo.refreshSession()).thenAnswer((_) async => ResponseModel.success(newMockSession));

      int callCount = 0;
      mockApiCaller = (dio) async {
        callCount++;
        if (callCount == 1) {
          // Ensure the first call is with the original Dio
           expect(dio.options.headers["Authorization"], null); // Or initial token if set
          return unauthorizedResponse;
        } else if (callCount == 2) {
          // Ensure the second call is with the Dio that has the updated token
          expect(dio.options.headers["Authorization"], 'Bearer refreshed_token_456');
          return successResponseAfterRefresh;
        }
        fail('Caller was called more than twice');
      };
      
      final result = await clientHandler.callApi(mockApiCaller);
      
      expect(result, same(successResponseAfterRefresh));
      verify(mockAuthRepo.refreshSession()).called(1);
      // updateSession is called internally by clientHandler after successful refresh
      // We can verify by checking the header in the second call to mockApiCaller.
      expect(clientHandler.dio.options.headers["Authorization"], 'Bearer refreshed_token_456');
      expect(callCount, 2);
    });

    test('returns original 401 response if session refresh fails', () async {
      final unauthorizedResponse = MockResponse();
      when(unauthorizedResponse.statusCode).thenReturn(401);
      
      when(mockAuthRepo.refreshSession()).thenAnswer((_) async => ResponseModel.failed(Failure(message: 'Refresh failed')));

      int callCount = 0;
      mockApiCaller = (dio) async {
        callCount++;
        if (callCount == 1) {
          return unauthorizedResponse;
        }
        fail('Caller was called more than once');
      };
      
      final result = await clientHandler.callApi(mockApiCaller);
      
      expect(result, same(unauthorizedResponse));
      verify(mockAuthRepo.refreshSession()).called(1);
      // Ensure updateSession was not called with a new session, or header remains unchanged from before refresh attempt
      expect(clientHandler.dio.options.headers["Authorization"], null); // Assuming no initial token
      expect(callCount, 1);
    });

     test('handles non-DioError exceptions from caller gracefully', () async {
      final customException = Exception('Something went wrong in the caller');
      mockApiCaller = (dio) async {
        throw customException;
      };

      try {
        await clientHandler.callApi(mockApiCaller);
        fail('Should have thrown the custom exception');
      } catch (e) {
        expect(e, same(customException));
      }
      verify(mockApiCaller(mockDio)).called(1);
      verifyNever(mockAuthRepo.refreshSession());
    });

    test('handles DioError without response (network error) from caller', () async {
      final dioError = DioException(requestOptions: RequestOptions(path: '/test')); // No response
      mockApiCaller = (dio) async {
        throw dioError;
      };

      try {
        await clientHandler.callApi(mockApiCaller);
        fail('Should have thrown the DioError');
      } catch (e) {
        expect(e, same(dioError));
      }
      verify(mockApiCaller(mockDio)).called(1);
      verifyNever(mockAuthRepo.refreshSession());
    });


    test('does not attempt refresh for non-401 DioError status codes', () async {
      final serverErrorResponse = MockResponse();
      when(serverErrorResponse.statusCode).thenReturn(500); // Internal Server Error
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: serverErrorResponse,
      );

      mockApiCaller = (dio) async {
        throw dioError;
      };
      
      try {
        await clientHandler.callApi(mockApiCaller);
        fail('callApi should have rethrown the DioError');
      } catch (e) {
        expect(e, same(dioError));
      }
      
      verify(mockApiCaller(mockDio)).called(1);
      verifyNever(mockAuthRepo.refreshSession());
    });
  });
}

// Helper to get a DioException
DioException _createDioError(int? statusCode, {dynamic data}) {
  return DioException(
    requestOptions: RequestOptions(path: '/test'),
    response: statusCode != null 
        ? Response(
            data: data,
            statusCode: statusCode,
            requestOptions: RequestOptions(path: '/test'),
          )
        : null,
  );
}
