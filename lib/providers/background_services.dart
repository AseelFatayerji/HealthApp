import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:pedometer/pedometer.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  void onStart(ServiceInstance service) {
    StepCount? latestStep;

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Step Tracker Running",
        content: "Tracking your steps in background",
      );
    }

    final pedometerStream = Pedometer.stepCountStream;
    pedometerStream.listen((StepCount event) {
      latestStep = event;

      service.invoke("updateSteps", {
        "steps": event.steps,
        "time": event.timeStamp.toIso8601String(),
      });
    });

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      if (service is AndroidServiceInstance &&
          !(await (service).isForegroundService())) {
        timer.cancel();
        return;
      }

      service.invoke("update", {"steps": latestStep?.steps});
    });
  }

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'my_foreground',
      initialNotificationTitle: 'Step Tracker Running',
      initialNotificationContent: 'Tracking your steps in background',
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
}
