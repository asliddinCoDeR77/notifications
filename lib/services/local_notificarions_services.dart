import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificarionsServices {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static bool notificationsEnabled = false;

  static Future<void> requestPermission() async {
    //Birinchi dasturimiz qaysi qurilmada run bo'layatganini tekshiramiz
    if (Platform.isIOS || Platform.isMacOS) {
      //Agar IOS bo'lsa unda
      //shu kod orqali notification' ga ruxsat so'raymiz

      notificationsEnabled = await _localNotification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;

      //Agar MacOS bo'lsa unda
      //shu kod orqali notification' ga ruxsat so'raymiz
      await _localNotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      //Agar MacOS bo'lsa unda
      //shu kod orqali notification' ga ruxsat so'raymiz
      final androidImplementation =
          _localNotification.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      //va bu yerda darhol xabarnaomasiga ruxsat so'raymiz
      final bool? grantedNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();

      //bu yerda esa rejali xabarnomage ruxsat so'raymiz
      final bool? grantedScheduledNotificationPermission =
          await androidImplementation?.requestExactAlarmsPermission();
      //bu yerda o'zgaruvchiga belgilab qo'yapmiz foydalanuvchi ruxsat berdimi
      notificationsEnabled = grantedNotificationPermission ?? false;
      notificationsEnabled = grantedScheduledNotificationPermission ?? false;
    }
  }

  static Future<void> start() async {
    //hozirgi joylashuv (timesone) bilan vaqtni oladi.
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    //android va IOS uchun sozlamalarni to'g'irlaymiz
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

    //umumiy sozlamalarga elon qilaman
    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    //va FlutterLocalNotification klasiga sozlamalarni yuboraman
    // u esa kerakli qurilma sozlamalarini to'g'irlaydi
    await _localNotification.initialize(notificationInit);
  }

  static void showNotification() async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
    const androidDetails = AndroidNotificationDetails(
      "goodChannelId",
      "goodChannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound("notification"),
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

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotification.show(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      notificationDetails,
    );
  }

  static void showScheduledNotification() async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
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

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotification.zonedSchedule(
      0,
      "Birinchi NOTIFICATION",
      "Salom sizga \$1,000,000 pul tushdi. SMS kodni ayting!",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Salom",
    );
  }

  static void showPeriodicNotification(String time) async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
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

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotification.periodicallyShowWithDuration(
      0,
      "Mativation time...",
      "Mativatsiya olish vahti bo'ldi ):",
      Duration(minutes: int.parse(time)),
      notificationDetails,
      payload: "Mativatsiya bu bekorchilik (:",
    );
  }

  static void pamidorShowPeriodicNotification(String timePamidor) async {
    // android va ios uchun qanday
    // turdagi xabarlarni ko'rsatish kerakligni aytamiz
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

    // show funksiyasi orqali darhol xabarnoma ko'rsatamiz
    await _localNotification.periodicallyShowWithDuration(
      0,
      "Dam olish vaqti...):",
      "Sen ham bir odamga o'xshab dam ol (:",
      Duration(minutes: int.parse(timePamidor)),
      notificationDetails,
      payload: "Miyya temirdan emas bolakay (:",
    );
  }
}
