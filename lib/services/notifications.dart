import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize the notifications
  Future<void> initialize() async {
    if (_isInitialized) return;


    const  initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const  initializationSettingsIOS =DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // group both of them together
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // initialize the plugin
    await notificationsPlugin.initialize(initializationSettings);
  }

  // notifications detial setup
  NotificationDetails _notificationDetails() {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'Busybee_android_channel_id',
      'Busybee_android_channel_name',
      channelDescription: 'Busybee_android_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      // presentAlert: true,
      // presentBadge: true,
      // presentSound: true,
    );

    return NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
  }
  Future<void> scheduleNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledDate,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      await _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

}