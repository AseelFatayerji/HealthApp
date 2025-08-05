import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:healthapp/providers/background_services.dart';
import 'package:healthapp/providers/info.dart';
import 'package:healthapp/widgets/splash.dart';
import 'package:provider/provider.dart';
import 'providers/pedometer.dart';
import 'providers/calories.dart';
import 'providers/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeService();
  await NotificationService().initNotificationService();
  await NotificationService().requestNotificationPermission();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CaloriesProvider()),
        ChangeNotifierProvider(create: (_) => PedometerProvider()),
        ChangeNotifierProvider(create: (_) => InfoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    context.watch<InfoProvider>().load();
    return MaterialApp(
      theme: context.watch<InfoProvider>().themeData,
      home: SplashScreen(),
    );
  }
}
