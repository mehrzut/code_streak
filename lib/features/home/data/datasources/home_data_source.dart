import 'dart:convert';
import 'dart:developer';

import 'package:code_streak/common/url_helper.dart';
import 'package:code_streak/core/api/api_handler.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class HomeDataSource {
  Future<Map<String, dynamic>?> fetchGithubContributions(String userName);
}

@LazySingleton(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<Map<String, dynamic>?> fetchGithubContributions(
      String userName) async {
    final query = '''
      query {
        user(login: "$userName") {
          contributionsCollection {
            contributionCalendar {
              totalContributions
              weeks {
                contributionDays {
                  date
                  contributionCount
                }
              }
            }
          }
        }
      }
    ''';

    final response = await ApiHandler.instance.callApi((dio) => dio.postUri(
          Uri.parse(UrlHelper.githubApiUrl),
          options: Options(
            contentType: 'application/json',
          ),
          data: jsonEncode({'query': query}),
        ));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.data);
      final user = data['data']['user'];
      final contributionsCollection = user['contributionsCollection'];
      final contributionCalendar =
          contributionsCollection['contributionCalendar'];
      final result = {
        'totalContributions': contributionCalendar['totalContributions'],
        'weeks': contributionCalendar['weeks'],
      };
      log(result.toString());
      return result;
    } else {
      log('Failed to load contributions');
    }
    return null;
  }
}
