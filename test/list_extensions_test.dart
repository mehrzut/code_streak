import 'package:flutter_test/flutter_test.dart';
import 'package:code_streak/core/extensions.dart';

void main() {
  group('splitAt', () {
    test('splits the list at the given index', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitAt(2);
      expect(result, [
        [1, 2],
        [3, 4, 5]
      ]);
    });

    test('splits at the start of the list', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitAt(0);
      expect(result, [
        [],
        [1, 2, 3, 4, 5]
      ]);
    });

    test('splits at the end of the list', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitAt(5);
      expect(result, [
        [1, 2, 3, 4, 5],
        []
      ]);
    });

    test('throws an error for an invalid index', () {
      final list = [1, 2, 3, 4, 5];
      expect(() => list.splitAt(-1), throwsRangeError);
      expect(() => list.splitAt(6), throwsRangeError);
    });
  });

  group('splitAtNotContaining', () {
    test('splits the list excluding the element at index', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitAtNotContaining(2);
      expect(result, [
        [1, 2],
        [4, 5]
      ]);
    });

    test('splits at the start of the list', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitAtNotContaining(0);
      expect(result, [
        [],
        [2, 3, 4, 5]
      ]);
    });

    test('splits at the end of the list', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitAtNotContaining(4);
      expect(result, [
        [1, 2, 3, 4],
        []
      ]);
    });

    test('throws an error for an invalid index', () {
      final list = [1, 2, 3, 4, 5];
      expect(() => list.splitAtNotContaining(-1), throwsRangeError);
      expect(() => list.splitAtNotContaining(5), throwsRangeError);
    });
  });

  group('splitWhere', () {
    test('splits the list where the condition is met', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitWhere((e) => e == 3);
      expect(result, [
        [1, 2],
        [3, 4, 5]
      ]);
    });

    test('splits when the condition is met at the start', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitWhere((e) => e == 1);
      expect(result, [
        [],
        [1, 2, 3, 4, 5]
      ]);
    });

    test('splits when the condition is met at the end', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitWhere((e) => e == 5);
      expect(result, [
        [1, 2, 3, 4],
        [5]
      ]);
    });

    test('returns the entire list if the condition is never met', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.splitWhere((e) => e == 6);
      expect(result, [
        [1, 2, 3, 4, 5]
      ]);
    });
  });

  group('fromStartUntil', () {
    test('returns sublist until condition is met', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.fromStartUntil((e) => e == 3);
      expect(result, [1, 2]);
    });

    test('returns empty list if condition is met at the start', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.fromStartUntil((e) => e == 1);
      expect(result, []);
    });

    test('returns the entire list if condition is never met', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.fromStartUntil((e) => e == 6);
      expect(result, [1, 2, 3, 4, 5]);
    });

    test('returns the entire list if condition is met at the end', () {
      final list = [1, 2, 3, 4, 5];
      final result = list.fromStartUntil((e) => e == 5);
      expect(result, [1, 2, 3, 4]);
    });

    test('handles an empty list gracefully', () {
      final list = <int>[];
      final result = list.fromStartUntil((e) => e == 1);
      expect(result, []);
    });
  });
}
