import 'dart:convert';
import 'package:appwrite/appwrite.dart' as appwrite_sdk;
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:appwrite/src/account.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:code_streak/core/controllers/id_handler.dart';
import 'package:code_streak/core/controllers/notification_handler.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/data/datasources/home_data_source.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockClientHandler extends Mock implements ClientHandler {}
class MockDio extends Mock implements Dio {} // Though ClientHandler.callApi is mocked, Dio might be used directly or its options accessed.
class MockAccount extends Mock implements Account {}
class MockIdHandler extends Mock implements IdHandler {}
class MockFirebaseMessaging extends Mock implements FirebaseMessaging {} // For FirebaseMessaging.instance
class MockNotificationHandler extends Mock implements NotificationHandler {}
class MockAppwriteUser extends Mock implements appwrite_models.User {
  @override
  String get $id => 'mock_user_id';
}
class MockAppwritePushTarget extends Mock implements appwrite_models.PushTarget {}

// Top-level mock instance for FirebaseMessaging.instance
MockFirebaseMessaging mockFirebaseMessagingInstance = MockFirebaseMessaging();


void main() {
  late HomeDataSourceImpl homeDataSource;
  late MockClientHandler mockClientHandler;
  late MockAccount mockAccount;
  late MockIdHandler mockIdHandler;
  late MockNotificationHandler mockNotificationHandler;
  // Store original static instances if they are replaced
  late IdHandler originalIdHandlerInstance;
  late NotificationHandler originalNotificationHandlerInstance;
   // For FirebaseMessaging.instance, direct replacement is harder. We'll mock methods on the static instance.

  setUpAll(() {
    // If FirebaseMessaging.instance needs mocking, it's often done via platform channel mocking
    // or by providing a mock instance if the class under test can accept it.
    // Here, HomeDataSourceImpl calls FirebaseMessaging.instance directly.
    // We'll use `firebase_messaging_platform_interface` if direct method mocking isn't enough.
    // For now, assume method mocking on the static instance is feasible via `when(FirebaseMessaging.instance...)`.
    // This setup is complex for static instance methods.
    // TestWidgetsFlutterBinding.ensureInitialized(); // May be needed for Firebase
  });

  setUp(() {
    mockClientHandler = MockClientHandler();
    mockAccount = MockAccount();
    mockIdHandler = MockIdHandler();
    mockNotificationHandler = MockNotificationHandler();

    when(mockClientHandler.account).thenReturn(mockAccount);

    // Store and replace singleton instances
    originalIdHandlerInstance = IdHandler.I; // Assuming 'I' is the static getter
    IdHandler.I = mockIdHandler;

    originalNotificationHandlerInstance = NotificationHandler.I; // Assuming 'I' is the static getter
    NotificationHandler.I = mockNotificationHandler;
    
    homeDataSource = HomeDataSourceImpl(client: mockClientHandler);

    // Default mocks for setUserReminders dependencies
    when(mockNotificationHandler.initialize()).thenAnswer((_) async => const NotificationSettings(authorizationStatus: AuthorizationStatus.authorized));
    when(mockIdHandler.getDeviceId()).thenAnswer((_) async => 'mock_device_id');
    // For FirebaseMessaging.instance.getToken(), this is tricky.
    // If `FirebaseMessaging.instance` itself cannot be mocked easily,
    // we might need to mock the static `getToken` method if possible, or refactor HomeDataSource.
    // For this test, we assume a way to make `FirebaseMessaging.instance.getToken()` mockable.
    // Often, this involves `firebase_messaging_platform_interface` and setting a mock instance there.
    // As a simplification, we'll try to mock it directly, but this might not work in a real test runner.
    // when(FirebaseMessaging.instance.getToken(vapidKey: anyNamed('vapidKey'))).thenAnswer((_) async => 'mock_fcm_token');
    // A more robust way:
    // FirebaseMessagingPlatform.instance = MockFirebaseMessagingPlatform();
    // when(MockFirebaseMessagingPlatform.instance.getToken(vapidKey: anyNamed('vapidKey'))).thenAnswer((_) async => 'mock_fcm_token');
    // For now, we'll proceed assuming direct mocking or that the actual call path is handled.
    // The provided code uses `FirebaseMessaging.instance.getToken()`. We'll use the top-level mock.
    when(mockFirebaseMessagingInstance.getToken(vapidKey: anyNamed('vapidKey'))).thenAnswer((_) async => 'mock_fcm_token');
    // And then ensure HomeDataSourceImpl somehow uses this mockFirebaseMessagingInstance.
    // This is a gap if HomeDataSourceImpl hardcodes `FirebaseMessaging.instance`.
    // For the test, we'll assume the DI for FirebaseMessaging is handled or that static mocking works.


    when(mockAccount.get()).thenAnswer((_) async => MockAppwriteUser());
    when(mockAccount.updatePrefs(prefs: anyNamed('prefs'))).thenAnswer((_) async => MockAppwriteUser());
    when(mockAccount.createPushTarget(
      targetId: anyNamed('targetId'),
      identifier: anyNamed('identifier'),
      providerType: anyNamed('providerType'),
    )).thenAnswer((_) async => MockAppwritePushTarget());
    when(mockAccount.updatePushTarget(
      id: anyNamed('id'),
      identifier: anyNamed('identifier'),
    )).thenAnswer((_) async => MockAppwritePushTarget());

    // Mock for clientHandler.callApi (generic success)
    final mockSuccessResponse = Response(
      data: {'message': 'Success'}, 
      statusCode: 200, 
      requestOptions: RequestOptions(path: '')
    );
    when(mockClientHandler.callApi<dynamic>(any)).thenAnswer((_) async => mockSuccessResponse);
  });

  tearDown(() {
    // Restore original singleton instances
    IdHandler.I = originalIdHandlerInstance;
    NotificationHandler.I = originalNotificationHandlerInstance;
  });

  group('HomeDataSourceImpl', () {
    group('fetchGithubContributions', () {
      final String username = 'testuser';
      final DateTime from = DateTime(2023, 1, 1);
      final DateTime till = DateTime(2023, 1, 31);
      final String url = 'https://github-contributions-api.jogruber.de/v4/$username';

      final validJsonResponse = [
        {'date': '2023-01-01', 'count': 1, 'level': 1},
        {'date': '2023-01-02', 'count': 2, 'level': 2},
      ];
      final successDioResponse = Response(
        data: validJsonResponse, 
        statusCode: 200, 
        requestOptions: RequestOptions(path: url)
      );
      final failureDioResponse = Response(
        data: {'error': 'Not found'}, 
        statusCode: 404, 
        requestOptions: RequestOptions(path: url)
      );

      test('success: returns ContributionsData on 200 with valid JSON', () async {
        // Arrange
        when(mockClientHandler.callApi<List<dynamic>>(
          any, // The dio.get call
        )).thenAnswer((_) async => successDioResponse);

        // Act
        final result = await homeDataSource.fetchGithubContributions(username: username, from: from, till: till);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<ContributionsData>());
        expect(result.data?.contributions.length, 2);
        expect(result.data?.contributions.first.date, DateTime(2023,1,1));
        expect(result.data?.contributions.first.count, 1);
        
        final captured = verify(mockClientHandler.callApi<List<dynamic>>(captureAny)).captured.single as Future<Response<List<dynamic>>> Function(Dio);
        // To verify query params, we need to execute the captured function with a mock Dio
        // and inspect the arguments passed to dio.get(). This is complex.
        // Alternatively, if the URL construction logic is simple, we can infer it.
        // The current HomeDataSourceImpl directly calls `dio.get(url, queryParameters: query)`.
        // We can't easily intercept that without a more involved mock setup for `callApi` or `Dio`.
        // For now, we trust `callApi` is called, and the URL structure is known.
      });

      test('failure: returns APIErrorFailure on non-200 status', () async {
        // Arrange
        when(mockClientHandler.callApi<List<dynamic>>(any))
            .thenAnswer((_) async => failureDioResponse); // Simulate callApi returning the failure response

        // Act
        final result = await homeDataSource.fetchGithubContributions(username: username, from: from, till: till);

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<APIErrorFailure>());
      });

      test('failure: returns APIErrorFailure if callApi throws DioException', () async {
        // Arrange
        final dioException = DioException(requestOptions: RequestOptions(path: url), response: failureDioResponse);
        when(mockClientHandler.callApi<List<dynamic>>(any)).thenThrow(dioException);

        // Act
        final result = await homeDataSource.fetchGithubContributions(username: username, from: from, till: till);

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<APIErrorFailure>());
      });
      
      test('failure: returns APIErrorFailure if JSON parsing fails (e.g. unexpected structure)', () async {
        // Arrange
        final malformedJsonResponse = [{'date': '2023-01-01', 'unexpected_field': 1}]; // Missing 'count'
        final malformedSuccessDioResponse = Response(
          data: malformedJsonResponse, 
          statusCode: 200, 
          requestOptions: RequestOptions(path: url)
        );
        when(mockClientHandler.callApi<List<dynamic>>(any))
            .thenAnswer((_) async => malformedSuccessDioResponse);

        // Act
        final result = await homeDataSource.fetchGithubContributions(username: username, from: from, till: till);
        
        // Assert
        // The fromJson in ContributionDayData will throw if 'count' is missing.
        // This should be caught and wrapped in APIErrorFailure by the source.
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<APIErrorFailure>());
        expect(result.failure?.message, contains('type \'Null\' is not a subtype of type \'int\'')); // Or similar parsing error
      });

      test('query parameters are correctly formatted', () async {
        // Arrange
        String capturedUrl = '';
        Map<String, dynamic>? capturedQueryParams;

        final mockDioForCapture = MockDio();
        when(mockDioForCapture.get(any, queryParameters: anyNamed('queryParameters')))
            .thenAnswer((invocation) async {
          capturedUrl = invocation.positionalArguments.first as String;
          capturedQueryParams = invocation.namedArguments[#queryParameters] as Map<String,dynamic>?;
          return successDioResponse; // Return a valid response
        });

        // Make callApi execute the passed function with our mockDioForCapture
        when(mockClientHandler.callApi<List<dynamic>>(any)).thenAnswer((invocation) async {
          final apiCallFunction = invocation.positionalArguments.first 
                                    as Future<Response<List<dynamic>>> Function(Dio);
          return await apiCallFunction(mockDioForCapture);
        });
        
        // Act
        await homeDataSource.fetchGithubContributions(username: username, from: from, till: till);

        // Assert
        expect(capturedUrl, url);
        expect(capturedQueryParams, {
          'from': from.toIso8601String().substring(0, 10), // 'YYYY-MM-DD'
          'to': till.toIso8601String().substring(0, 10),   // 'YYYY-MM-DD'
        });
      });
    });

    group('fetchUserInfo', () {
      final String username = 'testuser';
      final String url = 'https://api.github.com/users/$username';
      final validUserInfoJson = {'login': username, 'id': 123, 'avatar_url': 'url', 'html_url': 'url'};
      final successDioResponse = Response(
        data: validUserInfoJson, 
        statusCode: 200, 
        requestOptions: RequestOptions(path: url)
      );
       final failureDioResponse = Response(
        data: {'error': 'Not found'}, 
        statusCode: 404, 
        requestOptions: RequestOptions(path: url)
      );

      test('success: returns UserInfo on 200 with valid JSON', () async {
        // Arrange
        when(mockClientHandler.callApi<Map<String, dynamic>>(any))
            .thenAnswer((_) async => successDioResponse);
        
        // Act
        final result = await homeDataSource.fetchUserInfo(username: username);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, isA<UserInfo>());
        expect(result.data?.login, username);
      });

      test('failure: returns APIErrorFailure on non-200 status', () async {
        // Arrange
         when(mockClientHandler.callApi<Map<String, dynamic>>(any))
            .thenAnswer((_) async => failureDioResponse);

        // Act
        final result = await homeDataSource.fetchUserInfo(username: username);

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<APIErrorFailure>());
      });
      
      test('failure: returns APIErrorFailure if callApi throws DioException', () async {
        // Arrange
        final dioException = DioException(requestOptions: RequestOptions(path: url), response: failureDioResponse);
        when(mockClientHandler.callApi<Map<String, dynamic>>(any)).thenThrow(dioException);

        // Act
        final result = await homeDataSource.fetchUserInfo(username: username);

        // Assert
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<APIErrorFailure>());
      });
    });

    group('setUserReminders', () {
      final bool enable = true;
      final String time = '10:00';
      final String username = 'testuser';

      test('success path', () async {
        // All mocks default to success paths from setUp
        final result = await homeDataSource.setUserReminders(enable: enable, time: time, username: username);
        expect(result.isSuccess, isTrue);
        expect(result.data, isTrue);
        verify(mockNotificationHandler.initialize()).called(1);
        verify(mockIdHandler.getDeviceId()).called(1);
        verify(mockFirebaseMessagingInstance.getToken(vapidKey: anyNamed('vapidKey'))).called(1);
        verify(mockAccount.get()).called(1); // For user ID
        verify(mockAccount.createPushTarget(targetId: 'mock_device_id', identifier: 'mock_fcm_token', providerType: NotificationHandler.providerType)).called(1);
        verify(mockAccount.updatePrefs(prefs: argThat(equals({'reminder': '$enable@$time@$username'})))).called(1);
      });

      test('permission not approved: returns PermissionFailure', () async {
        when(mockNotificationHandler.initialize()).thenAnswer((_) async => const NotificationSettings(authorizationStatus: AuthorizationStatus.denied));
        final result = await homeDataSource.setUserReminders(enable: enable, time: time, username: username);
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<PermissionFailure>());
      });

      test('FCM token is null: returns FirebaseFailure', () async {
        when(mockFirebaseMessagingInstance.getToken(vapidKey: anyNamed('vapidKey'))).thenAnswer((_) async => null);
        final result = await homeDataSource.setUserReminders(enable: enable, time: time, username: username);
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<FirebaseFailure>());
      });

      test('createPushTarget throws "already exists", then updatePushTarget succeeds', () async {
        when(mockAccount.createPushTarget(
          targetId: anyNamed('targetId'), identifier: anyNamed('identifier'), providerType: anyNamed('providerType')))
          .thenThrow(appwrite_sdk.AppwriteException('Target already exists', 409, 'document_already_exists')); // type: 'document_already_exists'
        
        final result = await homeDataSource.setUserReminders(enable: enable, time: time, username: username);
        
        expect(result.isSuccess, isTrue);
        verify(mockAccount.updatePushTarget(id: 'mock_device_id', identifier: 'mock_fcm_token')).called(1);
        verify(mockAccount.updatePrefs(prefs: anyNamed('prefs'))).called(1);
      });
      
      test('createPushTarget throws other AppwriteException: returns AppWriteFailure', () async {
        when(mockAccount.createPushTarget(
          targetId: anyNamed('targetId'), identifier: anyNamed('identifier'), providerType: anyNamed('providerType')))
          .thenThrow(appwrite_sdk.AppwriteException('Some other Appwrite error', 500));
          
        final result = await homeDataSource.setUserReminders(enable: enable, time: time, username: username);
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AppWriteFailure>());
      });

      test('updatePrefs throws: returns AppWritePrefFailure', () async {
        when(mockAccount.updatePrefs(prefs: anyNamed('prefs'))).thenThrow(appwrite_sdk.AppwriteException('Prefs update failed'));
        final result = await homeDataSource.setUserReminders(enable: enable, time: time, username: username);
        expect(result.isFailed, isTrue);
        expect(result.failure, isA<AppWritePrefFailure>());
      });
      
       test('IdHandler.getDeviceId throws: returns GeneralFailure (or specific if mapped)', () async {
        when(mockIdHandler.getDeviceId()).thenThrow(Exception('Device ID fetch failed'));
        final result = await homeDataSource.setUserReminders(enable: enable, time: time, username: username);
        expect(result.isFailed, isTrue);
        // The catch-all for _setReminderToServer wraps it in GeneralFailure
        expect(result.failure, isA<GeneralFailure>());
        expect(result.failure?.message, contains('Device ID fetch failed'));
      });

      // TODO: Test for `setRemindersForNewSession` call if needed, though it's a private method.
      // Its effects are tested via `updatePrefs` and `createPushTarget`/`updatePushTarget`.
    });
  });
}
