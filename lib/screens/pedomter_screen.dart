import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../providers/pedometer.dart';
import '../widgets/step_calendar.dart';

class PedometerScreen extends StatelessWidget {
  final TextEditingController _goalController = TextEditingController();

  PedometerScreen({super.key});

  void dispose() {
    _goalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PedometerProvider>(context);
    _goalController.text = provider.goalSteps.toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color.fromARGB(255, 126, 217, 87),
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            Image.asset('assets/icon/Pedometer.png', height: 140),
            Container(
              margin: EdgeInsets.only(top: 120),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 10,
                        children: <Widget>[
                          StepsCalendar(),
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.all(10),
                                child: CircularPercentIndicator(
                                  animation: true,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  lineWidth: 15,
                                  percent: provider.progress,
                                  startAngle: 190,
                                  radius: 90,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        provider.selectedSteps.toString(),
                                        style: TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Steps out of \n${provider.goalSteps}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.color,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  progressColor: Colors.lightGreen,
                                ),
                              ),

                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      padding: EdgeInsets.only(top: 2),
                                      onPressed: () => {
                                        _stepPopUp(context, provider),
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all<Color>(
                                              Colors.lightGreen,
                                            ),
                                        shape:
                                            WidgetStateProperty.all<
                                              RoundedRectangleBorder
                                            >(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                      ),
                                      icon: FaIcon(
                                        FontAwesomeIcons.plus,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.directions_walk,
                                          color: Colors.pink,
                                          size: 24,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${provider.distanceKm}',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      provider.distanceUnit,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 3,

                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          color: Colors.yellow[700],
                                          size: 24,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${provider.burned.round()}',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Kcal',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 3,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.timer_rounded,
                                          color: Color.fromARGB(
                                            255,
                                            141,
                                            201,
                                            50,
                                          ),
                                          size: 24,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${provider.durationMinutes}',
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Hrs',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: 20,
                            children: [
                              Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 20,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      spacing: 10,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.bottleWater,
                                          color: Colors.lightBlue,
                                        ),
                                        Text(
                                          '${(((30 * provider.weightKg) - provider.water) / 1000)}L Water left',
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        onPressed: () => {
                                          _popUp(context, provider),
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                                Colors.lightBlue,
                                              ),
                                          shape:
                                              WidgetStateProperty.all<
                                                RoundedRectangleBorder
                                              >(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                        ),
                                        icon: FaIcon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  horizontal: 10,
                                ),
                                child: LinearPercentIndicator(
                                  animation: true,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  lineHeight: 20,
                                  percent:
                                      (provider.water /
                                              (30 * provider.weightKg))
                                          .clamp(0.0, 1.0),
                                  barRadius: Radius.circular(10),
                                  progressColor: Colors.lightBlue,
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
          ],
        ),
      ),
    );
  }

  Future<void> _popUp(BuildContext context, provider) {
    final TextEditingController waterController = TextEditingController();
    String water = "";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: waterController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter water in mL',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          onChanged: (value) {
                            water = value;
                          },
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (water.isNotEmpty) {
                            provider.updateWater(int.parse(water));
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _stepPopUp(BuildContext context, provider) {
    final TextEditingController stepController = TextEditingController();
    String step = "";

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightGreen, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: stepController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter number of step',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),
                          ),
                          onChanged: (value) {
                            step = value;
                          },
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (step.isNotEmpty) {
                            provider.addDailySteps(int.parse(step));
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
