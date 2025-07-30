import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthapp/providers/info.dart';
import 'package:healthapp/widgets/menu.dart';
import 'package:provider/provider.dart';
import '../providers/pedometer.dart';
import '../providers/calories.dart';
import '../providers/notification_service.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  void _onToggleChanged(bool value) async {
    final provider = context.read<PedometerProvider>();
    final providerI = context.read<InfoProvider>();
    final steps = provider.steps;
    final notificationService = NotificationService();
    providerI.pin();
    if (value) {
      await notificationService.showNotification(steps, ongoing: true);
    } else {
      await notificationService.cancelNotification();
    }
  }

  void _onToggleDark(bool value) async {
    final providerI = context.read<InfoProvider>();
    providerI.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final providerP = context.watch<PedometerProvider>();
    final providerC = context.watch<CaloriesProvider>();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 77, 46, 129),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Image.asset('assets/icon/Settings.png', height: 140),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                margin: EdgeInsets.only(top: 120),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                  child: Column(
                    spacing: 20,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Prefrences',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.push_pin_outlined,
                                size: 24,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                'Pin Notification',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          FlutterSwitch(
                            width: 50.0,
                            height: 25.0,
                            activeColor: Colors.deepPurple,
                            onToggle: _onToggleChanged,
                            value: context.watch<InfoProvider>().isPinned,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.dark_mode_outlined,
                                size: 24,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                'Dark Mode',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          FlutterSwitch(
                            width: 50.0,
                            height: 25.0,
                            activeColor: Colors.deepPurple,
                            onToggle: _onToggleDark,
                            value: context.watch<InfoProvider>().isDarkMode,
                          ),
                        ],
                      ),
                      Text(
                        'User Info',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.marsAndVenus,
                                size: 24,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                'Gender',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            width: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IntrinsicWidth(
                              child: Row(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    providerP.gender,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  selectionmenu(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.scale_outlined,
                                size: 24,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                'Weight',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _weightController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),

                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: '${providerP.weightKg} Kg',
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed != null && parsed > 0) {
                                    providerP.updateWeight(parsed);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.height_outlined,
                                size: 24,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                'Height',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _heightController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),

                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: '${providerP.height} m',
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed != null && parsed > 0) {
                                    providerP.updateHeight(parsed);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.local_fire_department_outlined,
                                size: 28,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                'Daily Calories',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                            child: IntrinsicWidth(
                              child: TextField(
                                controller: _calorieController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                  border: OutlineInputBorder(),
                                  hintText: '${providerC.goalCalories} Kcal',
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                                ),
                                onSubmitted: (value) {
                                  final parsed = double.tryParse(value);
                                  if (parsed != null && parsed > 0) {
                                    providerC.updateGoal(parsed);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              Icon(
                                Icons.directions_walk_outlined,
                                size: 24,
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                              Text(
                                'Daily Steps',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 120,
                            child: IntrinsicWidth(
                              child: TextField(
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                                controller: _goalController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 4,
                                  ),
                                  border: const OutlineInputBorder(),
                                  hintText: '${providerP.goalSteps} Steps',
                                  hintStyle: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                  ),
                                ),
                                onChanged: (value) {
                                  final parsed = int.tryParse(value);
                                  if (parsed != null && parsed > 0) {
                                    providerP.updateGoal(parsed);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
