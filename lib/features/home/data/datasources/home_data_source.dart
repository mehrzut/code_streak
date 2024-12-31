import 'dart:convert';
import 'dart:developer';

import 'package:code_streak/common/url_helper.dart';
import 'package:code_streak/core/controllers/api_handler.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

abstract class HomeDataSource {
  Future<ResponseModel<ContributionsData>> fetchGithubContributions(
      String username);
  Future<ResponseModel<UserInfo>> fetchUserInfo();
}

@LazySingleton(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<ResponseModel<ContributionsData>> fetchGithubContributions(
      String username) async {
    try {
      final response = await ApiHandler.instance.callApi((dio) => dio.getUri(
            Uri.parse(
              '${UrlHelper.appwriteApiUrl}getGithubContributions?username=$username',
            ),
            options: Options(
              contentType: 'application/json',
            ),
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
              contributionCalendar:
                  ((contributionCalendar['weeks'] ?? []) as List<dynamic>)
                      .map(
                        (element) => ContributionWeekData(
                            days: ((element['contributionDays'] ?? [])
                                    as List<dynamic>)
                                .map((e) => ContributionDayData(
                                      contributionCount:
                                          e['contributionCount'] ?? 0,
                                      date:
                                          DateTime.tryParse(e['date'] ?? '') ??
                                              DateTime.now(),
                                    ))
                                .toList()),
                      )
                      .toList()),
        );
      } else {
        log('Failed to load contributions');
      }
      return ResponseModel.failed(APIErrorFailure());
    } catch (e) {
      log(e.toString());
      return ResponseModel.failed(APIErrorFailure());
    }
  }

  @override
  Future<ResponseModel<UserInfo>> fetchUserInfo() async {
    final response = await ApiHandler.instance.callApi((dio) => dio.getUri(
          Uri.parse('${UrlHelper.appwriteApiUrl}getUserInfo'),
          options: Options(
            contentType: 'application/json',
          ),
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
