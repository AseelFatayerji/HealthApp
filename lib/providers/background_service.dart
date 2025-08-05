import 'dart:async';
import 'package:flutter_background/flutter_background.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

StreamSubscription<StepCount>? _stepCountStream;
int _currentSteps = 0;

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
    _stepCountStream = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: true,
    );
  }

  return started;
}

Future<void> stopStepCounter() async {
  await _stepCountStream?.cancel();
  await FlutterBackground.disableBackgroundExecution();
}

void _onStepCount(StepCount event) {
  _currentSteps = event.steps;
 
}

void _onStepCountError(error) {
  print('Step count error: $error');
}
