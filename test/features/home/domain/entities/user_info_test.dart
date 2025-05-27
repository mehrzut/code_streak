import 'dart:convert';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserInfo', () {
    const String testLogin = 'testuser';
    const String testAvatarUrl = 'https://example.com/avatar.png';
    const String testHtmlUrl = 'https://example.com/testuser';
    const String testName = 'Test User';
    const String testCompany = 'Test Company';
    const String testLocation = 'Test Location';
    const String testBio = 'Test bio description.';
    const int testFollowers = 100;
    const int testFollowing = 50;
    const int testPublicRepos = 10;

    final userInfo = UserInfo(
      login: testLogin,
      avatarUrl: testAvatarUrl,
      htmlUrl: testHtmlUrl,
      name: testName,
      company: testCompany,
      location: testLocation,
      bio: testBio,
      followers: testFollowers,
      following: testFollowing,
      publicRepos: testPublicRepos,
    );

    final userInfoMinimal = UserInfo(
      login: testLogin,
      avatarUrl: testAvatarUrl,
      htmlUrl: testHtmlUrl,
    );
    
    final Map<String, dynamic> jsonMapFull = {
      'login': testLogin,
      'avatar_url': testAvatarUrl,
      'html_url': testHtmlUrl,
      'name': testName,
      'company': testCompany,
      'location': testLocation,
      'bio': testBio,
      'followers': testFollowers,
      'following': testFollowing,
      'public_repos': testPublicRepos,
    };
    
    final Map<String, dynamic> jsonMapMinimal = {
      'login': testLogin,
      'avatar_url': testAvatarUrl,
      'html_url': testHtmlUrl,
      // Optional fields are null or not present
    };


    test('constructor creates correct object with all fields', () {
      expect(userInfo.login, testLogin);
      expect(userInfo.avatarUrl, testAvatarUrl);
      expect(userInfo.htmlUrl, testHtmlUrl);
      expect(userInfo.name, testName);
      expect(userInfo.company, testCompany);
      expect(userInfo.location, testLocation);
      expect(userInfo.bio, testBio);
      expect(userInfo.followers, testFollowers);
      expect(userInfo.following, testFollowing);
      expect(userInfo.publicRepos, testPublicRepos);
    });

    test('constructor creates correct object with minimal fields (others default to null)', () {
      expect(userInfoMinimal.login, testLogin);
      expect(userInfoMinimal.avatarUrl, testAvatarUrl);
      expect(userInfoMinimal.htmlUrl, testHtmlUrl);
      expect(userInfoMinimal.name, isNull);
      expect(userInfoMinimal.company, isNull);
      expect(userInfoMinimal.location, isNull);
      expect(userInfoMinimal.bio, isNull);
      expect(userInfoMinimal.followers, isNull);
      expect(userInfoMinimal.following, isNull);
      expect(userInfoMinimal.publicRepos, isNull);
    });

    test('fromJson creates correct object from full JSON', () {
      final fromJson = UserInfo.fromJson(jsonMapFull);
      expect(fromJson.login, testLogin);
      expect(fromJson.avatarUrl, testAvatarUrl);
      expect(fromJson.htmlUrl, testHtmlUrl);
      expect(fromJson.name, testName);
      expect(fromJson.company, testCompany);
      expect(fromJson.location, testLocation);
      expect(fromJson.bio, testBio);
      expect(fromJson.followers, testFollowers);
      expect(fromJson.following, testFollowing);
      expect(fromJson.publicRepos, testPublicRepos);
    });

    test('fromJson creates correct object from minimal JSON', () {
      final fromJson = UserInfo.fromJson(jsonMapMinimal);
      expect(fromJson.login, testLogin);
      expect(fromJson.avatarUrl, testAvatarUrl);
      expect(fromJson.htmlUrl, testHtmlUrl);
      expect(fromJson.name, isNull);
      expect(fromJson.company, isNull);
      expect(fromJson.location, isNull);
      // ... and so on for other optional fields
    });
    
    test('toJson returns correct map for full object', () {
      final toJsonMap = userInfo.toJson();
      // Freezed toJson might not include nulls, so we only check for present fields
      expect(toJsonMap['login'], testLogin);
      expect(toJsonMap['avatar_url'], testAvatarUrl);
      expect(toJsonMap['html_url'], testHtmlUrl);
      expect(toJsonMap['name'], testName);
      expect(toJsonMap['company'], testCompany);
      expect(toJsonMap['location'], testLocation);
      expect(toJsonMap['bio'], testBio);
      expect(toJsonMap['followers'], testFollowers);
      expect(toJsonMap['following'], testFollowing);
      expect(toJsonMap['public_repos'], testPublicRepos);
    });

    test('toJson returns correct map for minimal object (optional fields might be absent or null)', () {
      final toJsonMap = userInfoMinimal.toJson();
      expect(toJsonMap['login'], testLogin);
      expect(toJsonMap['avatar_url'], testAvatarUrl);
      expect(toJsonMap['html_url'], testHtmlUrl);
      // Optional fields that are null might not be included in the JSON map by Freezed's toJson
      // or they might be included as null. This depends on the Freezed configuration.
      // We'll check that they are not present with non-null values if they were null in the object.
      expect(toJsonMap['name'], isNull); // Or use `isFalse(toJsonMap.containsKey('name'))` if nulls are omitted
      expect(toJsonMap['company'], isNull);
      // ... and so on
    });

    test('instances with same data are equal (due to Freezed)', () {
      final info1 = UserInfo(login: 'a', avatarUrl: 'b', htmlUrl: 'c', name: 'd');
      final info2 = UserInfo(login: 'a', avatarUrl: 'b', htmlUrl: 'c', name: 'd');
      expect(info1, equals(info2));
      expect(info1.hashCode, equals(info2.hashCode));
    });

    test('instances with different data are not equal', () {
      final info1 = UserInfo(login: 'a', avatarUrl: 'b', htmlUrl: 'c');
      final info2 = UserInfo(login: 'x', avatarUrl: 'b', htmlUrl: 'c');
      expect(info1, isNot(equals(info2)));
    });

    test('JSON encoding and decoding round trip (full object)', () {
      final encoded = jsonEncode(userInfo.toJson());
      final decoded = UserInfo.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
      expect(decoded, userInfo);
    });
    
    test('JSON encoding and decoding round trip (minimal object)', () {
      final encoded = jsonEncode(userInfoMinimal.toJson());
      final decoded = UserInfo.fromJson(jsonDecode(encoded) as Map<String, dynamic>);
      expect(decoded, userInfoMinimal);
    });
  });
}
