// ignore_for_file: use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/providers/calories.dart';
import 'package:healthapp/widgets/calorie_calendar.dart';
import 'package:healthapp/widgets/item.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CaloriesScreen extends StatefulWidget {
  const CaloriesScreen({super.key});

  @override
  State<CaloriesScreen> createState() => _CaloriesScreen();
}

class _CaloriesScreen extends State<CaloriesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CaloriesProvider>(context);
    final foodList = provider.mealNutrients;
    double calories = provider.calculateCalories();
    double protein = provider.calculateProtein();
    double carbs = provider.calculateCarbs();
    double fats = provider.calculateFat();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 181, 96),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset('assets/icon/Calories.png', height: 140),
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
                        children: [
                          CaloriesCalender(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_fire_department,
                                  color: Color.fromARGB(255, 255, 181, 96),
                                ),
                                Text(
                                  '${provider.goalCalories - calories} Calories left',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            lineHeight: 20,
                            percent:
                                1 -
                                ((provider.goalCalories - calories) /
                                    provider.goalCalories),
                            barRadius: Radius.circular(10),
                            progressColor: Color.fromARGB(255, 255, 181, 96),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                spacing: 20,
                                children: [
                                  Row(
                                    spacing: 10,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.drumstickBite,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                        size: 18,
                                      ),
                                      Text(
                                        'Protein',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 20,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${(provider.goalCalories * 0.2) - protein}',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            'Kcal',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      CircularPercentIndicator(
                                        radius: 20,
                                        animation: true,
                                        progressColor: Color.fromARGB(
                                          255,
                                          141,
                                          201,
                                          50,
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          208,
                                          208,
                                          208,
                                        ),
                                        startAngle: 200,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        percent:
                                            (protein /
                                                    (provider.goalCalories *
                                                        0.2))
                                                .clamp(0.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 80,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Column(
                                spacing: 20,
                                children: [
                                  Row(
                                    spacing: 20,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.plateWheat,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                        size: 18,
                                      ),
                                      Text(
                                        'Carbs',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 20,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${(provider.goalCalories * 0.6) - carbs}',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            'Kcal',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      CircularPercentIndicator(
                                        radius: 20,
                                        animation: true,
                                        progressColor: Color.fromARGB(
                                          255,
                                          96,
                                          178,
                                          255,
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          208,
                                          208,
                                          208,
                                        ),
                                        startAngle: 200,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        percent:
                                            (carbs /
                                                    (provider.goalCalories *
                                                        0.6))
                                                .clamp(0.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 80,
                                width: 2,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              Column(
                                spacing: 20,
                                children: [
                                  Row(
                                    spacing: 40,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.burger,
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge?.color,
                                        size: 18,
                                      ),
                                      Text(
                                        'Fat',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 20,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            '${(provider.goalCalories * 0.2) - fats}',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodyLarge?.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            'Kcal',
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.color,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 8,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      CircularPercentIndicator(
                                        radius: 20,
                                        animation: true,
                                        progressColor: Color.fromARGB(
                                          255,
                                          255,
                                          181,
                                          96,
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          208,
                                          208,
                                          208,
                                        ),
                                        startAngle: 200,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        percent:
                                            (fats /
                                                    (provider.goalCalories *
                                                        0.2))
                                                .clamp(0.0, 1.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Today's Meals",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.color,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                          Color.fromARGB(255, 255, 181, 96),
                                        ),
                                    shape:
                                        WidgetStateProperty.all<
                                          RoundedRectangleBorder
                                        >(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                  ),
                                  icon: FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: Colors.white,
                                  ),
                                  iconSize: 20,
                                  onPressed: () => _popUp(context, provider),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: foodList.length,
                            itemBuilder: (context, index) {
                              return FoodItem(item: foodList[index]);
                            },
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
    final TextEditingController discController = TextEditingController();
    final TextEditingController foodNameController = TextEditingController();
    final TextEditingController calorieController = TextEditingController();
    final TextEditingController proteinController = TextEditingController();
    final TextEditingController carbController = TextEditingController();
    final TextEditingController fatController = TextEditingController();

    double cal = 0;
    double p = 0;
    double c = 0;
    double f = 0;
    String name = "";
    String disc = "";
    List<Widget> options = [
      SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            TextField(
              controller: foodNameController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Food Name',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  name = value;
                }
              },
            ),
            TextField(
              controller: discController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Food Discription',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  disc = value;
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 181, 96),
                textStyle: Theme.of(context).textTheme.labelLarge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );
                try {
                  List<double> values = await provider.getTextResponse(disc);
                  if (values.length < 4) {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Incomplete data from Gemini"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  await provider.addMeal(provider.selectedDate, name, values);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: Text(e.toString()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            TextField(
              controller: foodNameController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Food Name',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  name = value;
                }
              },
            ),
            TextField(
              controller: calorieController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Total Calories',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  cal = double.parse(value);
                }
              },
            ),
            TextField(
              controller: proteinController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Total Protein',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  p = double.parse(value);
                }
              },
            ),
            TextField(
              controller: carbController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Total Carbs',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  c = double.parse(value);
                }
              },
            ),
            TextField(
              controller: fatController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Total Fats',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  f = double.parse(value);
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 181, 96),
                textStyle: Theme.of(context).textTheme.labelLarge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                List<double> values = [cal, p, c, f];
                await provider.addMeal(provider.selectedDate, name, values);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      SizedBox(
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            TextField(
              controller: foodNameController,
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                labelText: 'Food Name',
                labelStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              onChanged: (value) {
                if (value != "") {
                  name = value;
                }
              },
            ),
            Consumer<CaloriesProvider>(
              builder: (context, provider, _) {
                return SizedBox(
                  width: 300,
                  height: 100,
                  child: provider.selectedImage != null
                      ? Image.file(provider.selectedImage!)
                      : DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: [15, 5],
                            radius: Radius.circular(10),
                            padding: EdgeInsets.all(10),
                            color: Color.fromARGB(255, 255, 181, 96),
                          ),
                          child: SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    provider.pickImage();
                                  },
                                ),
                                Text("Upload Image"),
                              ],
                            ),
                          ),
                        ),
                );
              },
            ),
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 181, 96),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                color: Colors.white,
                onPressed: () {
                  provider.takeImage();
                },
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 181, 96),
                textStyle: Theme.of(context).textTheme.labelLarge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  },
                );

                try {
                  List<double> values = await provider.getImageResponse(
                    provider.selectedImage,
                  );
                  await provider.addMeal(provider.selectedDate, name, values);
                  provider.clearImage();

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Something went wrong: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    ];
    int selected = 0;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 255, 181, 96),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Column(
                    spacing: 10,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 181, 96),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 80,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: selected == 0
                                    ? Theme.of(context).colorScheme.surface
                                    : Color.fromARGB(255, 255, 181, 96),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  selected = 0;
                                },
                                icon: FaIcon(FontAwesomeIcons.robot),
                              ),
                            ),

                            Container(
                              width: 80,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: selected == 1
                                    ? Theme.of(context).colorScheme.surface
                                    : Color.fromARGB(255, 255, 181, 96),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  selected = 1;
                                },
                                icon: Icon(Icons.text_snippet_outlined),
                              ),
                            ),
                            Container(
                              width: 80,
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: selected == 2
                                    ? Theme.of(context).colorScheme.surface
                                    : Color.fromARGB(255, 255, 181, 96),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  selected = 2;
                                },
                                icon: FaIcon(FontAwesomeIcons.image),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.all(15),
                        child: options[selected],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
