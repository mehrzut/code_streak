import 'dart:developer' as developer;

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// This is the function we want to test, extracted or made accessible from main.dart
// For this example, let's assume it's defined here or imported from a test helper.
Future<bool> loadEnvForTest({
  required Future<void> Function({String fileName, Parser parser}) dotEnvLoad,
  void Function(String message, {Object? error, StackTrace? stackTrace})? logFunction,
}) async {
  final log = logFunction ?? developer.log;
  try {
    await dotEnvLoad(fileName: "assets/.env", parser: const Parser());
    log('✅ Dotenv loaded successfully');
    return true;
  } catch (e, s) {
    log('❌ Failed to load dotenv', error: e, stackTrace: s);
    return false;
  }
}

// Mocks
class MockDotEnv extends Mock implements DotEnv {}
// Mock for the log function
class MockLogFunction extends Mock {
  void call(String message, {Object? error, StackTrace? stackTrace});
}


void main() {
  group('loadEnvForTest (simulating _loadEnv from main.dart)', () {
    late MockLogFunction mockLog;

    setUp(() {
      mockLog = MockLogFunction();
    });

    test('calls dotenv.load and logs success when it succeeds', () async {
      // Arrange
      bool dotEnvLoadCalled = false;
      Future<void> mockDotEnvLoad({String fileName = '.env', Parser parser = const Parser()}) async {
        expect(fileName, "assets/.env");
        dotEnvLoadCalled = true;
        // Simulate success
      }

      // Act
      final result = await loadEnvForTest(dotEnvLoad: mockDotEnvLoad, logFunction: mockLog);

      // Assert
      expect(result, isTrue);
      expect(dotEnvLoadCalled, isTrue);
      verify(mockLog.call('✅ Dotenv loaded successfully')).called(1);
      verifyNoMoreInteractions(mockLog); // Ensure no error log
    });

    test('calls dotenv.load and logs error when it throws an exception', () async {
      // Arrange
      bool dotEnvLoadCalled = false;
      final testException = Exception('Dotenv failed to load');
      Future<void> mockDotEnvLoadError({String fileName = '.env', Parser parser = const Parser()}) async {
        expect(fileName, "assets/.env");
        dotEnvLoadCalled = true;
        throw testException;
      }

      // Act
      final result = await loadEnvForTest(dotEnvLoad: mockDotEnvLoadError, logFunction: mockLog);

      // Assert
      expect(result, isFalse);
      expect(dotEnvLoadCalled, isTrue);
      // Capture the arguments passed to the log function
      final captured = verify(mockLog.call(
        captureAny, 
        error: captureAnyNamed('error'), 
        stackTrace: captureAnyNamed('stackTrace')
      )).captured;

      expect(captured[0], '❌ Failed to load dotenv'); // Message
      expect(captured[1], testException); // Error object
      expect(captured[2], isA<StackTrace>()); // StackTrace
    });
  });

  // Note: Testing the actual main() function or MainApp widget is out of scope
  // for this unit test as it involves Flutter framework specifics, runApp, etc.
}
