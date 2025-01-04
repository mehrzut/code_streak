import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:code_streak/core/controllers/client_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      "com.code_streak.app.push.notif.channel",
      'Reminder Notifications',
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      importance: Importance.max,
      priority: Priority.max,
      visibility: NotificationVisibility.public,
    ),
    iOS: DarwinNotificationDetails(),
  );

  static const AndroidNotificationChannel reminderChannel =
      AndroidNotificationChannel(
    "com.code_streak.app.push.notif.channel",
    'Reminder Notifications',
    importance: Importance.max,
  );
  static Future<bool> initialize() async {
    try {
      final result = await FirebaseMessaging.instance.requestPermission();
      if (Platform.isAndroid) {
        await localNotifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(reminderChannel);
      }
      await localNotifications.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      _addOnReceiveMessageListener();
      _addTokenRefreshListener();
      return result.authorizationStatus == AuthorizationStatus.authorized;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  static void _addOnReceiveMessageListener() {
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        _showLocalNotification(
            title: message.notification!.title ?? '',
            message: message.notification!.body ?? '',
            data: jsonEncode(message.data));
      }
    });
  }

  static void _showLocalNotification(
      {required String title, required String message, String? data}) {
    FlutterLocalNotificationsPlugin()
        .show(generateTimeBasedId(), title, message,
            _details.supportLongContent(message),
            payload: data)
        .then((_) {});
  }

  static int generateTimeBasedId() {
    DateTime now = DateTime.now();
    String day = _padZero(now.day);
    String hour = _padZero(now.hour);
    String minute = _padZero(now.minute);
    String second = _padZero(now.second);

    return int.parse(day + hour + minute + second);
  }

  static String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  static void _addTokenRefreshListener() {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      final currentSession =
          await ClientHandler.instance.account.getSession(sessionId: 'current');
      try {
        await ClientHandler.instance.account.createPushTarget(
            identifier: token,
            targetId: currentSession.userId,
            providerId: dotenv.get('APPWRITE_FCM_PROVIDER_ID', fallback: ''));
      } on AppwriteException catch (e) {
        log(e.toString());
        if (e.type == 'user_target_already_exists') {
          await ClientHandler.instance.account.updatePushTarget(
            identifier: token,
            targetId: currentSession.userId,
          );
        }
      }
    });
  }
}

extension NotificationDetailsExt on NotificationDetails {
  NotificationDetails supportLongContent(String content) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        android!.channelId,
        android!.channelName,
        actions: android!.actions,
        additionalFlags: android!.additionalFlags,
        audioAttributesUsage: android!.audioAttributesUsage,
        autoCancel: android!.autoCancel,
        category: android!.category,
        channelAction: android!.channelAction,
        channelDescription: android!.channelDescription,
        channelShowBadge: android!.channelShowBadge,
        chronometerCountDown: android!.chronometerCountDown,
        color: android!.color,
        colorized: android!.colorized,
        enableLights: android!.enableLights,
        enableVibration: android!.enableVibration,
        fullScreenIntent: android!.fullScreenIntent,
        groupAlertBehavior: android!.groupAlertBehavior,
        groupKey: android!.groupKey,
        icon: android!.icon,
        importance: android!.importance,
        indeterminate: android!.indeterminate,
        largeIcon: android!.largeIcon,
        ledColor: android!.ledColor,
        ledOffMs: android!.ledOffMs,
        ledOnMs: android!.ledOnMs,
        maxProgress: android!.maxProgress,
        number: android!.number,
        ongoing: android!.ongoing,
        onlyAlertOnce: android!.onlyAlertOnce,
        playSound: android!.playSound,
        priority: android!.priority,
        progress: android!.progress,
        setAsGroupSummary: android!.setAsGroupSummary,
        shortcutId: android!.shortcutId,
        showProgress: android!.showProgress,
        showWhen: android!.showWhen,
        silent: android!.silent,
        sound: android!.sound,
        subText: android!.subText,
        tag: android!.tag,
        ticker: android!.ticker,
        timeoutAfter: android!.timeoutAfter,
        usesChronometer: android!.usesChronometer,
        vibrationPattern: android!.vibrationPattern,
        visibility: android!.visibility,
        when: android!.when,
        styleInformation: BigTextStyleInformation(content),
      ),
      iOS: iOS,
      linux: linux,
      macOS: macOS,
    );
  }
}
