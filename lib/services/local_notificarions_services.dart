import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificarionsServices {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static bool notificationsEnabled = false;

  static Future<void> requestPermission() async {
    
    if (Platform.isIOS || Platform.isMacOS) {
      
      

      notificationsEnabled = await _localNotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;

      
      
      await _localNotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      
      
      final androidImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      
      final bool? grantedScheduledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();
      
      notificationsEnabled = grantedNotificationPermission ?? false;
      notificationsEnabled = grantedScheduledNotificationPermission ?? false;
    }
  }

  static Future<void> start() async {
    
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    
    const androidInit = AndroidInitializationSettings("mipmap/ic_launcher");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: [
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    
    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    
    
    await _localNotification.initialize(notificationInit);
  }

  static void showNotification() async {
    
    
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      
      actions: [
        AndroidNotificationAction('id_1', 'Action 1'),
        AndroidNotificationAction('id_2', 'Action 2'),
        AndroidNotificationAction('id_3', 'Action 3'),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
      categoryIdentifier: "demoCategory",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    
    await _localNotification.show(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      notificationDetails,
    );
  }

  static void showScheduledNotification() async {
    
    
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    
    await _localNotification.zonedSchedule(
      0,
      "FIRST NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Salom",
    );
  }

  static void showPeriodicNotification(String time) async {
    
    
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    
    await _localNotification.periodicallyShowWithDuration(
      0,
      "Mativation time...",
      "Mativatsiya olish vahti bo'ldi ):",
      Duration(minutes: int.parse(time)),
      notificationDetails,
      payload: "Mativatsiya  (:",
    );
  }

  static void pamidorShowPeriodicNotification(String timePamidor) async {
    
    
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      actions: [
        AndroidNotificationAction('id_1', 'Yo\'qol'),
        AndroidNotificationAction('id_2', 'Hop'),
      ],
      sound: RawResourceAndroidNotificationSound("notification"),
      ticker: "Ticker",
    );

    const iosDetails = DarwinNotificationDetails(
      sound: "notification.aiff",
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    
    await _localNotification.periodicallyShowWithDuration(
      0,
      "Dam olish vaqti...):",
      Duration(minutes: int.parse(timePamidor)),
      notificationDetails,
      payload: "Dam ol",
    );
  }
}
