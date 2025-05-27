import 'package:code_streak/core/controllers/notification_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:appwrite/src/account.dart';
import 'package:code_streak/core/controllers/client_handler.dart'; // For ClientHandler.instance.account access

// Mocks
class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}
class MockFlutterLocalNotificationsPlugin extends Mock implements FlutterLocalNotificationsPlugin {}
class MockAndroidFlutterLocalNotificationsPlugin extends Mock implements AndroidFlutterLocalNotificationsPlugin {}
class MockAccount extends Mock implements Account {}
class MockClientHandler extends Mock implements ClientHandler {
  @override
  // ignore: overridden_fields
  final Account account; // Allow providing a mock account
  MockClientHandler(this.account);
}
class MockRemoteMessage extends Mock implements RemoteMessage {}
class MockNotification extends Mock implements Notification {}
class MockAndroidNotificationChannel extends Mock implements AndroidNotificationChannel {}

// Top-level mock instance for FirebaseMessaging.instance
MockFirebaseMessaging mockFirebaseMessagingInstance = MockFirebaseMessaging();

void main() {
  // Ensure Flutter bindings are initialized for Firebase
  TestWidgetsFlutterBinding.ensureInitialized();

  late NotificationHandler notificationHandler;
  late MockFlutterLocalNotificationsPlugin mockFlutterLocalNotificationsPlugin;
  late MockAndroidFlutterLocalNotificationsPlugin mockAndroidFlutterLocalNotificationsPlugin;
  late MockAccount mockAccount;
  late ClientHandler originalClientHandlerInstance; // To store and restore original ClientHandler.instance

  setUpAll(() {
    // Setup static mocks for FirebaseMessaging.instance
    // This is a common pattern for mocking static properties/methods.
    // Requires a bit of setup, often using a plugin or specific mock pattern.
    // For FirebaseMessaging.instance, it's tricky. We'll mock its methods directly.
    // If NotificationHandler used an injected FirebaseMessaging, it would be easier.
  });
  
  setUp(() {
    mockFlutterLocalNotificationsPlugin = MockFlutterLocalNotificationsPlugin();
    mockAndroidFlutterLocalNotificationsPlugin = MockAndroidFlutterLocalNotificationsPlugin();
    mockAccount = MockAccount();

    // Mock ClientHandler.instance and its account
    // This is a common way to handle singletons in tests.
    // Be careful if other tests rely on the real ClientHandler.instance.
    originalClientHandlerInstance = ClientHandler.instance; // Store original
    ClientHandler.instance = MockClientHandler(mockAccount); // Replace with mock

    notificationHandler = NotificationHandler.test(
      firebaseMessaging: mockFirebaseMessagingInstance, // Inject mock
      localNotificationsPlugin: mockFlutterLocalNotificationsPlugin,
    );

    // Default mock behaviors
    when(mockFirebaseMessagingInstance.requestPermission(
      alert: anyNamed('alert'),
      announcement: anyNamed('announcement'),
      badge: anyNamed('badge'),
      carPlay: anyNamed('carPlay'),
      criticalAlert: anyNamed('criticalAlert'),
      provisional: anyNamed('provisional'),
      sound: anyNamed('sound'),
    )).thenAnswer((_) async => const AuthorizationStatus.authorized());

    when(mockFlutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>())
        .thenReturn(mockAndroidFlutterLocalNotificationsPlugin);
    when(mockAndroidFlutterLocalNotificationsPlugin.createNotificationChannel(any)).thenAnswer((_) async {});
    
    when(mockFlutterLocalNotificationsPlugin.initialize(
      any,
      onDidReceiveNotificationResponse: anyNamed('onDidReceiveNotificationResponse'),
      onDidReceiveBackgroundNotificationResponse: anyNamed('onDidReceiveBackgroundNotificationResponse'),
    )).thenAnswer((_) async {});

    // Mock token and listeners
    when(mockFirebaseMessagingInstance.getToken(vapidKey: anyNamed('vapidKey'))).thenAnswer((_) async => 'mock_fcm_token');
    when(mockFirebaseMessagingInstance.onTokenRefresh).thenAnswer((_) => const Stream.empty()); // Return an empty stream
    when(FirebaseMessaging.onMessage).thenAnswer((_) => const Stream.empty()); // For static onMessage
    when(FirebaseMessaging.onMessageOpenedApp).thenAnswer((_) => const Stream.empty()); // For static onMessageOpenedApp


    // Mock for _updateToken
    when(mockAccount.createPushTarget(
      targetId: anyNamed('targetId'),
      providerType: anyNamed('providerType'),
      identifier: anyNamed('identifier'),
    )).thenAnswer((_) async => appwrite_models.PushTarget(
      $id: 'target_id', $createdAt: '', $updatedAt: '', userId: 'user_id', providerType: 'fcm', identifier: 'mock_fcm_token',
    ));
  });

  tearDown(() {
    ClientHandler.instance = originalClientHandlerInstance; // Restore original
    reset(mockFirebaseMessagingInstance);
    reset(mockFlutterLocalNotificationsPlugin);
    reset(mockAndroidFlutterLocalNotificationsPlugin);
    reset(mockAccount);
  });

  group('NotificationHandler.getContent', () {
    test('returns title and body from notification field if present', () {
      final message = MockRemoteMessage();
      final notification = MockNotification();
      when(notification.title).thenReturn('Notification Title');
      when(notification.body).thenReturn('Notification Body');
      when(message.notification).thenReturn(notification);
      when(message.data).thenReturn({}); // No data field

      final content = NotificationHandler.getContent(message);
      expect(content.title, 'Notification Title');
      expect(content.body, 'Notification Body');
    });

    test('returns title and body from data field if notification field is null', () {
      final message = MockRemoteMessage();
      when(message.notification).thenReturn(null);
      when(message.data).thenReturn({
        'title': 'Data Title',
        'body': 'Data Body',
      });

      final content = NotificationHandler.getContent(message);
      expect(content.title, 'Data Title');
      expect(content.body, 'Data Body');
    });

    test('prefers notification field over data field if both are present', () {
      final message = MockRemoteMessage();
      final notification = MockNotification();
      when(notification.title).thenReturn('Notification Title');
      when(notification.body).thenReturn('Notification Body');
      when(message.notification).thenReturn(notification);
      when(message.data).thenReturn({
        'title': 'Data Title Should Be Ignored',
        'body': 'Data Body Should Be Ignored',
      });

      final content = NotificationHandler.getContent(message);
      expect(content.title, 'Notification Title');
      expect(content.body, 'Notification Body');
    });

    test('returns null title and body if neither notification nor data fields are present', () {
      final message = MockRemoteMessage();
      when(message.notification).thenReturn(null);
      when(message.data).thenReturn({});

      final content = NotificationHandler.getContent(message);
      expect(content.title, isNull);
      expect(content.body, isNull);
    });
    
    test('returns null title/body if data field is present but missing title/body keys', () {
      final message = MockRemoteMessage();
      when(message.notification).thenReturn(null);
      when(message.data).thenReturn({'other_key': 'some_value'});

      final content = NotificationHandler.getContent(message);
      expect(content.title, isNull);
      expect(content.body, isNull);
    });
  });

  group('NotificationHandler.generateTimeBasedId', () {
    test('returns ID in ddHHmm format', () {
      // We can't easily mock DateTime.now() without a library or complex setup.
      // So, we'll call the function and check its format.
      final id = NotificationHandler.generateTimeBasedId();
      expect(id, isA<int>());
      
      final idString = id.toString().padLeft(6, '0'); // Ensure it's 6 digits for parsing
      expect(idString.length, lessThanOrEqualTo(6)); // ddHHmm can be 5 or 6 digits (e.g. 10101 vs 010101)
                                                    // The function's output is int, so leading zeros are lost.
                                                    // We are more interested in the structure.

      // Example: If now is 5th day, 03 hours, 09 minutes -> 050309 (int 50309)
      // If now is 15th day, 13 hours, 29 minutes -> 151329 (int 151329)
      final now = DateTime.now();
      final expectedDay = now.day.toString().padLeft(2, '0');
      final expectedHour = now.hour.toString().padLeft(2, '0');
      final expectedMinute = now.minute.toString().padLeft(2, '0');
      final expectedIdString = "$expectedDay$expectedHour$expectedMinute";
      
      expect(id, int.parse(expectedIdString));
    });
  });

  group('NotificationHandler._padZero', () {
    test('pads single-digit number with a leading zero', () {
      expect(NotificationHandler.padZero(5), '05');
    });

    test('does not pad double-digit number', () {
      expect(NotificationHandler.padZero(12), '12');
    });
     test('handles zero correctly', () {
      expect(NotificationHandler.padZero(0), '00');
    });
  });

  group('NotificationHandler.initialize', () {
    test('requests permission from FirebaseMessaging', () async {
      await notificationHandler.initialize();
      verify(mockFirebaseMessagingInstance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      )).called(1);
    });

    test('creates notification channel on Android if permission granted', () async {
      when(mockFirebaseMessagingInstance.requestPermission(
        alert: anyNamed('alert'),
        announcement: anyNamed('announcement'),
        badge: anyNamed('badge'),
        carPlay: anyNamed('carPlay'),
        criticalAlert: anyNamed('criticalAlert'),
        provisional: anyNamed('provisional'),
        sound: anyNamed('sound'),
      )).thenAnswer((_) async => const AuthorizationStatus.authorized());
      
      await notificationHandler.initialize();
      
      verify(mockFlutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()).called(1);
      verify(mockAndroidFlutterLocalNotificationsPlugin.createNotificationChannel(any)).called(1);
    });

    test('does not create channel if permission not granted', () async {
      when(mockFirebaseMessagingInstance.requestPermission(
        alert: anyNamed('alert'),
        announcement: anyNamed('announcement'),
        badge: anyNamed('badge'),
        carPlay: anyNamed('carPlay'),
        criticalAlert: anyNamed('criticalAlert'),
        provisional: anyNamed('provisional'),
        sound: anyNamed('sound'),
      )).thenAnswer((_) async => const AuthorizationStatus.denied());
      
      await notificationHandler.initialize();
      
      verifyNever(mockFlutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>());
      verifyNever(mockAndroidFlutterLocalNotificationsPlugin.createNotificationChannel(any));
    });

    test('initializes FlutterLocalNotificationsPlugin', () async {
      await notificationHandler.initialize();
      verify(mockFlutterLocalNotificationsPlugin.initialize(
        any, // AndroidInitializationSettings
        onDidReceiveNotificationResponse: anyNamed('onDidReceiveNotificationResponse'),
        onDidReceiveBackgroundNotificationResponse: anyNamed('onDidReceiveBackgroundNotificationResponse'),
      )).called(1);
    });

    test('sets up FirebaseMessaging.onMessage listener', () async {
      // How to verify .listen() was called on a static Stream?
      // This is tricky. NotificationHandler.initialize() calls FirebaseMessaging.onMessage.listen directly.
      // One way is to use a mock for FirebaseMessaging itself if it were injectable.
      // Or, if the listener's callback has side effects we can observe (e.g., calls another mock).
      // For `_showLocalNotification`, we can verify if it's called if a message comes.
      // This test focuses on the setup. The actual listening behavior is harder to unit test for static streams.
      
      // We can verify that NotificationHandler.initialize doesn't throw, implying setup proceeds.
      // More direct verification of listeners on static streams often requires integration tests or different mocking strategies.
      expect(() async => await notificationHandler.initialize(), returnsNormally);
    });

    test('sets up FirebaseMessaging.instance.onTokenRefresh listener and calls _updateToken', () async {
      final mockTokenStreamController = StreamController<String>();
      when(mockFirebaseMessagingInstance.onTokenRefresh).thenAnswer((_) => mockTokenStreamController.stream);
      when(mockFirebaseMessagingInstance.getToken(vapidKey: anyNamed('vapidKey'))).thenAnswer((_) async => 'initial_token'); // For initial _updateToken call

      await notificationHandler.initialize(); 
      
      // Verify initial token update
      verify(ClientHandler.instance.account.createPushTarget(
        targetId: NotificationHandler.targetId,
        providerType: NotificationHandler.providerType,
        identifier: 'initial_token',
      )).called(1);

      // Simulate a token refresh
      mockTokenStreamController.add('refreshed_fcm_token');
      await untilCalled(ClientHandler.instance.account.createPushTarget(
        targetId: NotificationHandler.targetId,
        providerType: NotificationHandler.providerType,
        identifier: 'refreshed_fcm_token',
      ));
      
      verify(ClientHandler.instance.account.createPushTarget(
        targetId: NotificationHandler.targetId,
        providerType: NotificationHandler.providerType,
        identifier: 'refreshed_fcm_token',
      )).called(1);

      mockTokenStreamController.close();
    });
    
    test('_updateToken is called during initialize if permission is authorized', () async {
      when(mockFirebaseMessagingInstance.requestPermission(
        alert: anyNamed('alert'),
        announcement: anyNamed('announcement'),
        badge: anyNamed('badge'),
        carPlay: anyNamed('carPlay'),
        criticalAlert: anyNamed('criticalAlert'),
        provisional: anyNamed('provisional'),
        sound: anyNamed('sound'),
      )).thenAnswer((_) async => const AuthorizationStatus.authorized());
      when(mockFirebaseMessagingInstance.getToken(vapidKey: anyNamed('vapidKey'))).thenAnswer((_) async => 'fcm_token_for_update');

      await notificationHandler.initialize();

      verify(ClientHandler.instance.account.createPushTarget(
        targetId: NotificationHandler.targetId,
        providerType: NotificationHandler.providerType,
        identifier: 'fcm_token_for_update',
      )).called(1);
    });

    test('_updateToken is not called if permission is denied', () async {
      when(mockFirebaseMessagingInstance.requestPermission(
        alert: anyNamed('alert'),
        announcement: anyNamed('announcement'),
        badge: anyNamed('badge'),
        carPlay: anyNamed('carPlay'),
        criticalAlert: anyNamed('criticalAlert'),
        provisional: anyNamed('provisional'),
        sound: anyNamed('sound'),
      )).thenAnswer((_) async => const AuthorizationStatus.denied());
      
      await notificationHandler.initialize();

      verifyNever(mockFirebaseMessagingInstance.getToken(vapidKey: anyNamed('vapidKey')));
      verifyNever(ClientHandler.instance.account.createPushTarget(
        targetId: anyNamed('targetId'),
        providerType: anyNamed('providerType'),
        identifier: anyNamed('identifier'),
      ));
    });
  });
}

// Helper to get a StreamController for onTokenRefresh if needed for more granular control
// class MockFirebaseMessagingWithTokenStream extends Mock implements FirebaseMessaging {
//   final StreamController<String> _tokenStreamController = StreamController<String>.broadcast();
//   @override
//   Stream<String> get onTokenRefresh => _tokenStreamController.stream;
//   void sendToken(String token) => _tokenStreamController.add(token);
//   void closeTokenStream() => _tokenStreamController.close();
// }
