import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotificationService() async {
    if (_isInitialized) return;

    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await notificationsPlugin.initialize(initializationSettings);

    const androidChannel = AndroidNotificationChannel(
      'channel_id',
      'Pinned Notification',
      description: 'Shows ongoing step count',
      importance: Importance.max,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    _isInitialized = true;
  }

  NotificationDetails details({bool ongoing = true}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'Pinned Notification',
        channelDescription: 'Steps walked',
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: false,
        ongoing: ongoing,
        showWhen: false,
        playSound: true,
        enableVibration: false,
      ),
    );
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> showNotification(String steps, {bool ongoing = true}) async {
    await notificationsPlugin.show(
      0,
      'Steps walked',
      '$steps steps',
      details(ongoing: ongoing),
    );
  }

  Future<void> cancelNotification() async {
    await notificationsPlugin.cancel(0);
  }
}
