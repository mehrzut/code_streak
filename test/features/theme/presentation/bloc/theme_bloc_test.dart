import 'package:bloc_test/bloc_test.dart';
import 'package:code_streak/core/data/usecase.dart'; // For NoParams
import 'package:code_streak/features/theme/domain/usecases/check_theme.dart';
import 'package:code_streak/features/theme/domain/usecases/save_theme.dart';
import 'package:code_streak/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:flutter/material.dart'; // For Brightness
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockCheckThemeUseCase extends Mock implements CheckThemeUseCase {}
class MockSaveThemeUseCase extends Mock implements SaveThemeUseCase {}

void main() {
  late ThemeBloc themeBloc;
  late MockCheckThemeUseCase mockCheckThemeUseCase;
  late MockSaveThemeUseCase mockSaveThemeUseCase;

  setUp(() {
    mockCheckThemeUseCase = MockCheckThemeUseCase();
    mockSaveThemeUseCase = MockSaveThemeUseCase();

    // Mock default behavior for saveTheme to avoid null pointer exceptions during verify
    when(mockSaveThemeUseCase.call(any)).thenAnswer((_) async => Future.value());

    themeBloc = ThemeBloc(
      checkTheme: mockCheckThemeUseCase,
      saveTheme: mockSaveThemeUseCase,
    );
  });

  tearDown(() {
    themeBloc.close();
  });

  // As per ThemeBloc constructor, initial state is dark.
  test('Initial State is ThemeState.dark()', () {
    expect(themeBloc.state, const ThemeState.dark());
  });

  group('ThemeEvent.check', () {
    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeState.dark()] when checkTheme returns Brightness.dark',
      build: () {
        when(mockCheckThemeUseCase.call(const NoParams()))
            .thenAnswer((_) async => Brightness.dark);
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ThemeEvent.check()),
      expect: () => [const ThemeState.dark()],
      verify: (_) {
        verify(mockCheckThemeUseCase.call(const NoParams())).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeState.light()] when checkTheme returns Brightness.light',
      build: () {
        when(mockCheckThemeUseCase.call(const NoParams()))
            .thenAnswer((_) async => Brightness.light);
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ThemeEvent.check()),
      expect: () => [const ThemeState.light()],
      verify: (_) {
        verify(mockCheckThemeUseCase.call(const NoParams())).called(1);
      },
    );
  });

  group('ThemeEvent.toggle', () {
    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeState.light()] and calls saveTheme with light when current state is dark',
      build: () {
        // Initial state is dark by default in setUp
        return themeBloc;
      },
      act: (bloc) => bloc.add(const ThemeEvent.toggle()),
      expect: () => [const ThemeState.light()],
      verify: (_) {
        verify(mockSaveThemeUseCase.call(const SaveThemeUseCaseParams(brightness: Brightness.light))).called(1);
      },
    );

    blocTest<ThemeBloc, ThemeState>(
      'emits [ThemeState.dark()] and calls saveTheme with dark when current state is light',
      build: () => themeBloc, // Use the bloc from setUp
      seed: () => const ThemeState.light(), // Seed the state to light
      act: (bloc) => bloc.add(const ThemeEvent.toggle()),
      expect: () => [const ThemeState.dark()],
      verify: (_) {
        verify(mockSaveThemeUseCase.call(const SaveThemeUseCaseParams(brightness: Brightness.dark))).called(1);
      },
    );
  });
}
