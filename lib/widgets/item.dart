// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthapp/providers/calories.dart';
import 'package:provider/provider.dart';

class FoodItem extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables, strict_top_level_inference
  final item;
  const FoodItem({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CaloriesProvider>(context);
    final name = item['name'];
    final protein = item['protein'];
    final carbs = item['carbs'];
    final fats = item['fats'];
    final date = item['date'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 255, 181, 96),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.restaurant, size: 40, color: Colors.white),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$name",
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: [
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.drumstickBite,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '$protein',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.plateWheat,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '$carbs',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.burger,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '$fats',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    _popUp(context, provider, item);
                  },
                  icon: Icon(Icons.edit, color: Colors.white),
                ),
              ),
              SizedBox(
                width: 30,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: () {
                    provider.removemeal(item['key'], date);
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _popUp(BuildContext context, provider, item) {
  final TextEditingController calorieController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController fatController = TextEditingController();
  double cal = item['calories'];
  double p = item['protein'];
  double c = item['carbs'];
  double f = item['fats'];
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: Color.fromARGB(255, 255, 181, 96),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      '${item['name']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Text(
                            "Calories",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: calorieController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 4,
                              ),
                              border: OutlineInputBorder(),
                              hintText: '${item['calories']} Kcal',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != "") {
                                cal = double.parse(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Text(
                            "Protein",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: proteinController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 4,
                              ),
                              border: OutlineInputBorder(),
                              hintText: '${item['protein']} g',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != "") {
                                p = double.parse(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Text("Carbs", style: TextStyle(fontSize: 20)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: carbController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 4,
                              ),
                              border: OutlineInputBorder(),
                              hintText: '${item['carbs']} g',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != "") {
                                c = double.parse(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      spacing: 20,
                      children: [
                        Expanded(
                          child: Text("Fat", style: TextStyle(fontSize: 20)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: fatController,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 4,
                              ),
                              border: OutlineInputBorder(),
                              hintText: '${item['fats']} g',
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color,
                              ),
                            ),
                            onChanged: (value) {
                              if (value != "") {
                                f = double.parse(value);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 181, 96),
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      provider.updateMeal(
                        item['name'],
                        cal,
                        p,
                        c,
                        f,
                        item['date'],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
