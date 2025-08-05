import 'dart:async';
import 'package:flutter_background/flutter_background.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:healthapp/providers/pedometer.dart';

final PedometerProvider provider = PedometerProvider();

StreamSubscription<StepCount>? _stepCountStream;

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

Future<bool> startStepCounter() async {
  bool started = await FlutterBackground.enableBackgroundExecution();

  if (started) {
    await provider.init();
    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  return started;
}

void _onStepCount(StepCount event) {
  provider.onStepCount(event);
}

void _onStepCountError(error) {
  print('Step count error: $error');
}
