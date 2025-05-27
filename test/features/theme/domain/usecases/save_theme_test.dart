import 'package:code_streak/features/theme/domain/repositories/theme_repo.dart';
import 'package:code_streak/features/theme/domain/usecases/save_theme.dart';
import 'package:flutter/material.dart'; // For Brightness
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock ThemeRepo
class MockThemeRepo extends Mock implements ThemeRepo {}

void main() {
  late SaveThemeUseCase usecase;
  late MockThemeRepo mockThemeRepo;

  setUp(() {
    mockThemeRepo = MockThemeRepo();
    usecase = SaveThemeUseCase(repo: mockThemeRepo);
    // Mock the saveTheme method to return a completed Future<void>
    when(mockThemeRepo.saveTheme(any)).thenAnswer((_) async => Future.value());
  });

  group('SaveThemeUseCase', () {
    group('Params', () {
      test('Params can be instantiated and props are correct', () {
        const paramsDark = SaveThemeUseCaseParams(brightness: Brightness.dark);
        const paramsLight = SaveThemeUseCaseParams(brightness: Brightness.light);
        
        expect(paramsDark.brightness, Brightness.dark);
        expect(paramsDark.props, [Brightness.dark]);

        expect(paramsLight.brightness, Brightness.light);
        expect(paramsLight.props, [Brightness.light]);
      });

      test('Params instances with same data are equal', () {
        const paramsDark1 = SaveThemeUseCaseParams(brightness: Brightness.dark);
        const paramsDark2 = SaveThemeUseCaseParams(brightness: Brightness.dark);
        expect(paramsDark1, equals(paramsDark2));
        expect(paramsDark1.hashCode, equals(paramsDark2.hashCode));
      });
      
      test('Params instances with different data are not equal', () {
        const paramsDark = SaveThemeUseCaseParams(brightness: Brightness.dark);
        const paramsLight = SaveThemeUseCaseParams(brightness: Brightness.light);
        expect(paramsDark, isNot(equals(paramsLight)));
      });
    });

    test('should call ThemeRepo.saveTheme with Brightness.dark', () async {
      // Arrange
      const params = SaveThemeUseCaseParams(brightness: Brightness.dark);

      // Act
      await usecase.call(params);

      // Assert
      verify(mockThemeRepo.saveTheme(Brightness.dark)).called(1);
      verifyNoMoreInteractions(mockThemeRepo);
    });

    test('should call ThemeRepo.saveTheme with Brightness.light', () async {
      // Arrange
      const params = SaveThemeUseCaseParams(brightness: Brightness.light);

      // Act
      await usecase.call(params);

      // Assert
      verify(mockThemeRepo.saveTheme(Brightness.light)).called(1);
      verifyNoMoreInteractions(mockThemeRepo);
    });
  });
}
