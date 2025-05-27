import 'package:code_streak/core/data/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure Classes', () {
    group('Failure', () {
      test('instantiation with message', () {
        const message = 'Test failure message';
        const failure = Failure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = Failure();
        expect(failure.message, 'An unexpected error occurred.');
      });
    });

    group('AuthenticationFailure', () {
      test('instantiation with message', () {
        const message = 'Auth test message';
        const failure = AuthenticationFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = AuthenticationFailure();
        expect(failure.message, 'Authentication Failed');
      });
    });

    group('LocalDataBaseKeyNotFoundFailure', () {
      test('instantiation with message', () {
        const message = 'DB key not found message';
        const failure = LocalDataBaseKeyNotFoundFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = LocalDataBaseKeyNotFoundFailure();
        expect(failure.message, 'Key not found in the local database');
      });
    });

    group('APIErrorFailure', () {
      test('instantiation with message', () {
        const message = 'API error message';
        const failure = APIErrorFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = APIErrorFailure();
        expect(failure.message, 'API Error Occurred');
      });
    });

    group('AppWritePrefFailure', () {
      test('instantiation with message', () {
        const message = 'AppWrite pref message';
        const failure = AppWritePrefFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = AppWritePrefFailure();
        expect(failure.message, 'AppWrite Preference Failed');
      });
    });

    group('AppWriteFailure', () {
      test('instantiation with message', () {
        const message = 'AppWrite general message';
        const failure = AppWriteFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = AppWriteFailure();
        expect(failure.message, 'AppWrite Failed');
      });
    });

    group('FirebaseFailure', () {
      test('instantiation with message', () {
        const message = 'Firebase message';
        const failure = FirebaseFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = FirebaseFailure();
        expect(failure.message, 'Firebase Error Occurred');
      });
    });

    group('PermissionFailure', () {
      test('instantiation with message', () {
        const message = 'Permission denied message';
        const failure = PermissionFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = PermissionFailure();
        expect(failure.message, 'Permission Denied');
      });
    });

    group('GeneralFailure', () {
      test('instantiation with message', () {
        const message = 'General error message';
        const failure = GeneralFailure(message: message);
        expect(failure.message, message);
      });

      test('instantiation without message (default)', () {
        const failure = GeneralFailure();
        // GeneralFailure has no default message in its constructor,
        // so it inherits from Failure's default.
        expect(failure.message, 'An unexpected error occurred.');
      });
    });
  });
}
