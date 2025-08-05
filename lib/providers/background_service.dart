import 'dart:async';
import 'package:flutter_background/flutter_background.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> initializeBackgroundService() async {
  final androidConfig = FlutterBackgroundAndroidConfig(
    notificationTitle: "Burn Bites",
    notificationText: "Monitoring your steps...",
    notificationImportance: AndroidNotificationImportance.high,
    enableWifiLock: false,
  );

  bool permission = await FlutterBackground.initialize(androidConfig: androidConfig);

  if (permission) {
    var status = await Permission.activityRecognition.request();
    if (!status.isGranted) return false;
  }

  return permission;
}


