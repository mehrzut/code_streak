import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/features/theme/data/repositories/theme_repo_impl.dart';
import 'package:flutter/material.dart'; // For Brightness
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockLocalDatabase extends Mock implements LocalDatabase {}

void main() {
  late ThemeRepoImpl themeRepo;
  late MockLocalDatabase mockLocalDatabase;

  setUp(() {
    mockLocalDatabase = MockLocalDatabase();
    themeRepo = ThemeRepoImpl(localDB: mockLocalDatabase);
  });

  group('ThemeRepoImpl', () {
    group('checkTheme', () {
      test('returns Brightness.dark when localDatabase.checkTheme returns dark', () async {
        // Arrange
        when(mockLocalDatabase.checkTheme()).thenAnswer((_) async => Brightness.dark);

        // Act
        final result = await themeRepo.checkTheme();

        // Assert
        expect(result, Brightness.dark);
        verify(mockLocalDatabase.checkTheme()).called(1);
      });

      test('returns Brightness.light when localDatabase.checkTheme returns light', () async {
        // Arrange
        when(mockLocalDatabase.checkTheme()).thenAnswer((_) async => Brightness.light);

        // Act
        final result = await themeRepo.checkTheme();

        // Assert
        expect(result, Brightness.light);
        verify(mockLocalDatabase.checkTheme()).called(1);
      });
    });

    group('saveTheme', () {
      test('calls localDatabase.saveTheme with Brightness.dark', () async {
        // Arrange
        const brightness = Brightness.dark;
        // Mock saveTheme to complete successfully (returns Future<void>)
        when(mockLocalDatabase.saveTheme(brightness)).thenAnswer((_) async => Future.value());


        // Act
        await themeRepo.saveTheme(brightness);

        // Assert
        verify(mockLocalDatabase.saveTheme(brightness)).called(1);
      });

      test('calls localDatabase.saveTheme with Brightness.light', () async {
        // Arrange
        const brightness = Brightness.light;
        when(mockLocalDatabase.saveTheme(brightness)).thenAnswer((_) async => Future.value());

        // Act
        await themeRepo.saveTheme(brightness);

        // Assert
        verify(mockLocalDatabase.saveTheme(brightness)).called(1);
      });
    });
  });
}
