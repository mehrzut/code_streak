import 'dart:convert';
import 'package:code_streak/features/auth/data/models/auth_result_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appwrite/models.dart' as appwrite_models;

void main() {
  group('AuthResultData', () {
    // Create a mock Session object for testing
    final mockSession = appwrite_models.Session(
      $id: 'session_id_123',
      userId: 'user_id_456',
      expire: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      provider: 'github',
      providerUid: 'github_user_id',
      providerAccessToken: 'github_access_token',
      providerAccessTokenExpiry: DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
      providerRefreshToken: 'github_refresh_token',
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
      secret: 'session_secret_key',
      $createdAt: DateTime.now().toIso8601String(),
      $updatedAt: DateTime.now().toIso8601String(),
    );

    final authResultDataWithSession = AuthResultData.session(session: mockSession);
    final authResultDataWithoutSession = AuthResultData.session(session: null);

    test('session() constructor initializes session correctly', () {
      expect(authResultDataWithSession.session, mockSession);
      expect(authResultDataWithoutSession.session, isNull);
    });

    group('fromJson and toJson', () {
      test('correctly serializes and deserializes with session', () {
        final jsonMap = authResultDataWithSession.toJson();
        final jsonString = jsonEncode(jsonMap);
        final decodedJsonMap = jsonDecode(jsonString);
        final deserializedAuthResultData = AuthResultData.fromJson(decodedJsonMap);

        expect(deserializedAuthResultData.session, isNotNull);
        expect(deserializedAuthResultData.session?.$id, mockSession.$id);
        expect(deserializedAuthResultData.session?.userId, mockSession.userId);
        expect(deserializedAuthResultData.session?.provider, mockSession.provider);
        // Compare a few more fields to be reasonably sure
        expect(deserializedAuthResultData.session?.providerUid, mockSession.providerUid);
        expect(deserializedAuthResultData.session?.ip, mockSession.ip);
        expect(deserializedAuthResultData.session?.current, mockSession.current);
        
        // Verify the SessionConverter handles Session (de)serialization via toMap/fromMap
        // The Session object itself should be correctly reconstructed by its fromMap method
        final sessionFromJson = appwrite_models.Session.fromMap(jsonMap['session'] as Map<String, dynamic>);
        expect(sessionFromJson.$id, mockSession.$id);
      });

      test('correctly serializes and deserializes with null session', () {
        final jsonMap = authResultDataWithoutSession.toJson();
        final jsonString = jsonEncode(jsonMap);
        final decodedJsonMap = jsonDecode(jsonString);
        final deserializedAuthResultData = AuthResultData.fromJson(decodedJsonMap);

        expect(deserializedAuthResultData.session, isNull);
      });

      test('fromJson handles missing session key gracefully (defaults to null)', () {
        final jsonMap = <String, dynamic>{}; // No 'session' key
        final deserializedAuthResultData = AuthResultData.fromJson(jsonMap);
        expect(deserializedAuthResultData.session, isNull);
      });
      
      test('toJson produces map with null session if session is null', () {
        final jsonMap = authResultDataWithoutSession.toJson();
        expect(jsonMap.containsKey('session'), isTrue);
        expect(jsonMap['session'], isNull);
      });
    });
  });
}
