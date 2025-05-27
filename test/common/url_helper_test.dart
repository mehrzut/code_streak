import 'package:flutter_test/flutter_test.dart';
import 'package:code_streak/common/url_helper.dart';

void main() {
  group('UrlHelper', () {
    test('githubAuthorizeUrl is correct', () {
      expect(UrlHelper.githubAuthorizeUrl, 'https://github.com/login/oauth/authorize');
    });

    test('githubTokenUrl is correct', () {
      expect(UrlHelper.githubTokenUrl, 'https://github.com/login/oauth/access_token');
    });

    test('githubApiUrl is correct', () {
      expect(UrlHelper.githubApiUrl, 'https://api.github.com');
    });

    test('appwriteApiUrl is correct', () {
      expect(UrlHelper.appwriteApiUrl, 'https://cloud.appwrite.io/v1');
    });
  });
}
