import 'dart:convert';
import 'dart:developer';

import 'package:code_streak/common/url_helper.dart';
import 'package:code_streak/core/controllers/api_handler.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class HomeDataSource {
  Future<ResponseModel<ContributionsData>> fetchGithubContributions(
      String userName);
  Future<ResponseModel<UserInfo>> fetchUserInfo();
}

@LazySingleton(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<ResponseModel<ContributionsData>> fetchGithubContributions(
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
      var data = response.data;
      if (data is String) {
        data = jsonDecode(response.data);
      }
      final user = data['data']['user'];
      final contributionsCollection = user['contributionsCollection'];
      final contributionCalendar =
          contributionsCollection['contributionCalendar'];

      return ResponseModel.success(
        ContributionsData(
            totlaContributions: contributionCalendar['totalContributions'],
            contributionCalendar: ((contributionCalendar['weeks'] ?? [])
                    as List<Map<String, dynamic>>)
                .map(
                  (e) => ContributionWeekData(
                    count: e['contributionCount'] ?? 0,
                    date: DateTime.tryParse(e['date'] ?? '') ?? DateTime.now(),
                  ),
                )
                .toList()),
      );
    } else {
      log('Failed to load contributions');
    }
    return ResponseModel.failed(APIErrorFailure());
  }

  @override
  Future<ResponseModel<UserInfo>> fetchUserInfo() async {
    const query = '''
      query {
        viewer {
          login
          name
          avatarUrl
          bio
          location
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
      var data = response.data;
      if (data is String) {
        data = jsonDecode(response.data);
      }
      final viewer = data['data']['viewer'];
      return ResponseModel.success(UserInfo(
        username: viewer['login'] ?? '',
        avatarUrl: viewer['avatarUrl'],
        bio: viewer['bio'],
        location: viewer['location'],
        fullName: viewer['name'] ?? '',
      ));
    }
    return ResponseModel.failed(APIErrorFailure());
  }
}
