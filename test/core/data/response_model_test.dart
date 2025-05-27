import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock data class for testing
class MockData {
  final int id;
  final String value;

  MockData({required this.id, required this.value});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MockData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          value == other.value;

  @override
  int get hashCode => id.hashCode ^ value.hashCode;
}

void main() {
  group('ResponseModel', () {
    group('ResponseModel.success', () {
      test('with int data', () {
        const data = 123;
        final response = ResponseModel.success(data);

        // Verify using 'when'
        response.when(
          success: (d) {
            expect(d, data);
          },
          failed: (f) {
            fail('Should not call failed callback for success response');
          },
        );

        // Verify direct access if possible (depends on Freezed implementation)
        // Assuming a 'data' getter or similar pattern for success state
        expect((response as SuccessResponseModel).data, data);
        expect(response.isSuccess, isTrue);
        expect(response.isFailed, isFalse);
        expect(response.failure, isNull);
        expect(response.data, data);

      });

      test('with custom class data', () {
        final data = MockData(id: 1, value: 'test');
        final response = ResponseModel.success(data);

        response.when(
          success: (d) {
            expect(d, data);
            expect(d.id, data.id);
            expect(d.value, data.value);
          },
          failed: (f) {
            fail('Should not call failed callback for success response');
          },
        );
        
        expect((response as SuccessResponseModel).data, data);
        expect(response.isSuccess, isTrue);
        expect(response.isFailed, isFalse);
        expect(response.failure, isNull);
        expect(response.data, data);
      });
    });

    group('ResponseModel.failed', () {
      test('with GeneralFailure', () {
        final failure = GeneralFailure(message: 'Test error message');
        final response = ResponseModel.failed(failure);

        // Verify using 'when'
        response.when(
          success: (d) {
            fail('Should not call success callback for failed response');
          },
          failed: (f) {
            expect(f, failure);
            expect(f.message, failure.message);
          },
        );

        // Verify direct access if possible
        expect((response as FailedResponseModel).failure, failure);
        expect(response.isSuccess, isFalse);
        expect(response.isFailed, isTrue);
        expect(response.failure, failure);
        expect(response.data, isNull);
      });

      test('with AuthenticationFailure', () {
        final failure = AuthenticationFailure(message: 'Auth error');
        final response = ResponseModel.failed(failure);

        response.when(
          success: (d) {
            fail('Should not call success callback for failed response');
          },
          failed: (f) {
            expect(f, failure);
            expect(f.message, failure.message);
            expect(f, isA<AuthenticationFailure>());
          },
        );

        expect((response as FailedResponseModel).failure, failure);
        expect(response.isSuccess, isFalse);
        expect(response.isFailed, isTrue);
        expect(response.failure, failure);
        expect(response.data, isNull);
      });
    });
  });
}
