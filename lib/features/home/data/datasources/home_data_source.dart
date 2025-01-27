import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:code_streak/common/url_helper.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:code_streak/core/controllers/id_handler.dart';
import 'package:code_streak/core/controllers/notification_handler.dart';
import 'package:code_streak/core/data/failure.dart';
import 'package:code_streak/core/data/response_model.dart';
import 'package:code_streak/features/home/domain/entities/contribution_day_data.dart';
import 'package:code_streak/features/home/domain/entities/contribution_week_data.dart';
import 'package:code_streak/features/home/domain/entities/contributions_data.dart';
import 'package:code_streak/features/home/domain/entities/user_info.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

abstract class HomeDataSource {
  Future<ResponseModel<ContributionsData>> fetchGithubContributions(
    String username,
    DateTime? start,
    DateTime? end,
  );
  Future<ResponseModel<UserInfo>> fetchUserInfo();

  Future<ResponseModel<bool>> setUserReminders();
}

@LazySingleton(as: HomeDataSource)
class HomeDataSourceImpl implements HomeDataSource {
  @override
  Future<ResponseModel<ContributionsData>> fetchGithubContributions(
    String username,
    DateTime? start,
    DateTime? end,
  ) async {
    try {
      final response = await ClientHandler.instance.callApi((dio) => dio.getUri(
            Uri.parse('${UrlHelper.appwriteApiUrl}getGithubContributions')
                .replace(queryParameters: {
              'username': username,
              if (start != null) 'from': start.toIso8601String(),
              if (end != null) 'until': end.toIso8601String(),
            }),
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
              totalContributions: contributionCalendar['totalContributions'],
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
    try {
      final response = await ClientHandler.instance.callApi((dio) => dio.getUri(
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
    } catch (e) {
      log(e.toString());
      return ResponseModel.failed(APIErrorFailure());
    }
  }

  @override
  Future<ResponseModel<bool>> setUserReminders() async {
    try {
      /// get the user time zone offset
      final currentTimeZone = DateTime.now().timeZoneOffset.toString();
      final permissionApproved = await NotificationHandler.initialize();
      await ClientHandler.instance.account
          .updatePrefs(prefs: {'timezone': currentTimeZone});
      final token = await FirebaseMessaging.instance.getToken();
      log('fcm token: $token');
      final targetId = await IdHandler.getDeviceId();
      if (token != null && permissionApproved) {
        try {
          await ClientHandler.instance.account.createPushTarget(
              identifier: token,
              targetId: targetId,
              providerId: dotenv.get('APPWRITE_FCM_PROVIDER_ID', fallback: ''));
        } on AppwriteException catch (e) {
          log(e.toString());
          if (e.type == 'user_target_already_exists') {
            try {
              await ClientHandler.instance.account.updatePushTarget(
                identifier: token,
                targetId: targetId,
              );
            } catch (e) {
              log(e.toString());
            }
          } else {
            return ResponseModel.failed(AppWriteFailure(message: e.message));
          }
        } catch (e) {
          log(e.toString());
          return ResponseModel.failed(GeneralFailure(message: e.toString()));
        }
        final user = await ClientHandler.instance.account.get();
        try {
          final response =
              await ClientHandler.instance.callApi((dio) => dio.postUri(
                    Uri.parse(
                        '${UrlHelper.appwriteApiUrl}setRemindersForNewSession'),
                    options: Options(
                      contentType: 'application/json',
                    ),
                    data: jsonEncode({'userId': user.$id}),
                  ));
          log(response.data.toString());
        } catch (e) {
          log(e.toString());
        }
        return ResponseModel.success(true);
      } else if (!permissionApproved) {
        return ResponseModel.failed(PermissionFailure());
      } else {
        return ResponseModel.failed(FirebaseFailure());
      }
    } catch (e) {
      log(e.toString());
      return ResponseModel.failed(AppWritePrefFailure());
    }
  }
}
