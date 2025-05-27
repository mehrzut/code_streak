import 'dart:convert';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:code_streak/core/controllers/local_database.dart';
import 'package:code_streak/features/contributions/data/models/contributions_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late LocalDatabaseImpl localDatabase;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    localDatabase = LocalDatabaseImpl(storage: mockStorage);
  });

  group('LocalDatabaseImpl', () {
    group('Session Data', () {
      final mockSession = appwrite_models.Session(
        $id: 'session_id_123',
        userId: 'user_id_456',
        expire: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        provider: 'email',
        providerUid: 'test@example.com',
        providerAccessToken: 'access_token_789',
        providerAccessTokenExpiry: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
        providerRefreshToken: 'refresh_token_abc',
        ip: '127.0.0.1',
        osCode: 'iOS',
        osName: 'iOS',
        osVersion: '15.0',
        clientType: 'app',
        clientCode: 'com.example.app',
        clientName: 'Example App',
        clientVersion: '1.0.0',
        clientEngine: 'Flutter',
        clientEngineVersion: '3.0.0',
        deviceName: 'Test Device',
        deviceBrand: 'Apple',
        deviceModel: 'iPhone13,3',
        countryCode: 'US',
        countryName: 'United States',
        current: true,
        factors: [],
        secret: 'session_secret',
        $createdAt: DateTime.now().toIso8601String(),
        $updatedAt: DateTime.now().toIso8601String(),
      );
      final sessionJson = jsonEncode(mockSession.toMap());

      test('saveSession correctly writes session to storage', () async {
        await localDatabase.saveSession(mockSession);
        verify(mockStorage.write(key: LocalDatabaseKeys.session, value: sessionJson)).called(1);
      });

      test('loadSession returns session when data exists', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.session)).thenAnswer((_) async => sessionJson);
        final loadedSession = await localDatabase.loadSession();
        expect(loadedSession, isA<appwrite_models.Session>());
        expect(loadedSession?.$id, mockSession.$id);
      });

      test('loadSession returns null when no data exists', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.session)).thenAnswer((_) async => null);
        final loadedSession = await localDatabase.loadSession();
        expect(loadedSession, isNull);
      });

      test('loadSession returns null when data is invalid JSON', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.session)).thenAnswer((_) async => 'invalid_json');
        final loadedSession = await localDatabase.loadSession();
        expect(loadedSession, isNull);
      });
      
      test('deleteSession calls storage.delete with correct key', () async {
        await localDatabase.deleteSession();
        verify(mockStorage.delete(key: LocalDatabaseKeys.session)).called(1);
      });
    });

    group('Contributions Data', () {
      final contributionsData = ContributionsData(
        totalContributions: 100,
        streaks: Streaks(currentStreak: 10, longestStreak: 20, currentStreakStartDate: DateTime.now(), longestStreakStartDate: DateTime.now().subtract(const Duration(days:10)), longestStreakEndDate: DateTime.now()),
        lastContributionDate: DateTime.now(),
        activeDays: const ActiveDays(monday: true, tuesday: false, wednesday: true, thursday: false, friday: true, saturday: false, sunday: true),
        contributionDays: [DateTime.now(), DateTime.now().subtract(const Duration(days:1))],
      );
      final contributionsJson = jsonEncode(contributionsData.toMap());

      test('saveContributions correctly writes contributions to storage', () async {
        await localDatabase.saveContributions(contributionsData);
        verify(mockStorage.write(key: LocalDatabaseKeys.contributions, value: contributionsJson)).called(1);
      });

      test('getContributions returns contributions when data exists', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.contributions)).thenAnswer((_) async => contributionsJson);
        final loadedContributions = await localDatabase.getContributions();
        expect(loadedContributions, isA<ContributionsData>());
        expect(loadedContributions?.totalContributions, contributionsData.totalContributions);
      });

      test('getContributions returns null when no data exists', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.contributions)).thenAnswer((_) async => null);
        final loadedContributions = await localDatabase.getContributions();
        expect(loadedContributions, isNull);
      });

      test('getContributions returns null when data is invalid JSON', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.contributions)).thenAnswer((_) async => 'invalid_json');
        final loadedContributions = await localDatabase.getContributions();
        expect(loadedContributions, isNull);
      });
      
      test('deleteContributions calls storage.delete with correct key', () async {
        await localDatabase.deleteContributions();
        verify(mockStorage.delete(key: LocalDatabaseKeys.contributions)).called(1);
      });
    });

    group('Theme Data', () {
      test('saveTheme correctly writes Brightness.dark to storage', () async {
        await localDatabase.saveTheme(Brightness.dark);
        verify(mockStorage.write(key: LocalDatabaseKeys.theme, value: jsonEncode({'isDark': true}))).called(1);
      });

      test('saveTheme correctly writes Brightness.light to storage', () async {
        await localDatabase.saveTheme(Brightness.light);
        verify(mockStorage.write(key: LocalDatabaseKeys.theme, value: jsonEncode({'isDark': false}))).called(1);
      });

      test('checkTheme returns Brightness.dark when stored value is true', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.theme)).thenAnswer((_) async => jsonEncode({'isDark': true}));
        final theme = await localDatabase.checkTheme();
        expect(theme, Brightness.dark);
      });

      test('checkTheme returns Brightness.light when stored value is false', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.theme)).thenAnswer((_) async => jsonEncode({'isDark': false}));
        final theme = await localDatabase.checkTheme();
        expect(theme, Brightness.light);
      });

      test('checkTheme returns Brightness.light when no data exists', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.theme)).thenAnswer((_) async => null);
        final theme = await localDatabase.checkTheme();
        expect(theme, Brightness.light); // Default behavior
      });
      
      test('checkTheme returns Brightness.light when data is invalid JSON', () async {
        when(mockStorage.read(key: LocalDatabaseKeys.theme)).thenAnswer((_) async => 'invalid_json');
        final theme = await localDatabase.checkTheme();
        expect(theme, Brightness.light); // Default behavior on error
      });
    });
  });
}
