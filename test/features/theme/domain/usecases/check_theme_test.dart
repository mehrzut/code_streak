import 'package:code_streak/core/data/usecase.dart'; // For NoParams
import 'package:code_streak/features/theme/domain/repositories/theme_repo.dart';
import 'package:code_streak/features/theme/domain/usecases/check_theme.dart';
import 'package:flutter/material.dart'; // For Brightness
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock ThemeRepo
class MockThemeRepo extends Mock implements ThemeRepo {}

void main() {
  late CheckThemeUseCase usecase;
  late MockThemeRepo mockThemeRepo;

  setUp(() {
    mockThemeRepo = MockThemeRepo();
    usecase = CheckThemeUseCase(repo: mockThemeRepo);
  });

  group('CheckThemeUseCase', () {
    test('should call ThemeRepo.checkTheme and return its Brightness value', () async {
      // Arrange
      when(mockThemeRepo.checkTheme()).thenAnswer((_) async => Brightness.dark);

      // Act
      final result = await usecase.call(const NoParams());

      // Assert
      expect(result, Brightness.dark);
      verify(mockThemeRepo.checkTheme()).called(1);
      verifyNoMoreInteractions(mockThemeRepo);
    });

    test('should return Brightness.light when ThemeRepo.checkTheme returns light', () async {
      // Arrange
      when(mockThemeRepo.checkTheme()).thenAnswer((_) async => Brightness.light);

      // Act
      final result = await usecase.call(const NoParams());

      // Assert
      expect(result, Brightness.light);
      verify(mockThemeRepo.checkTheme()).called(1);
      verifyNoMoreInteractions(mockThemeRepo);
    });
  });
}
