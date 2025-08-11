// ignore_for_file: strict_top_level_inference
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CaloriesProvider extends ChangeNotifier {
  double _weightKg = 67;
  double get weightKg => _weightKg;

  List<Map<String, dynamic>> _mealNutrients = [];
  List<Map<String, dynamic>> get mealNutrients => _mealNutrients;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  double _goalCalories = 1200;
  double get goalCalories => _goalCalories;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  CaloriesProvider() {
    _init();
    _loadGoal();
    _loadWeight();
    _loadForSelectedDate();
  }
  Future<void> _init() async {
    notifyListeners();
  }

  Future<bool> _requestPermissions() async {
    bool granted = await Permission.camera.isGranted;
    if (!granted) {
      granted = await Permission.camera.request() == PermissionStatus.granted;
    }
    return granted;
  }

  void clearImage() {
    _selectedImage = null;
  }

  Future<void> pickImage() async {
    final permission = await _requestPermissions();
    if (!permission) {
      return;
    }
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      // ignore: avoid_print
      debugPrint('Image picker failed: $e');
    }
  }

  Future<void> takeImage() async {
    final permission = await _requestPermissions();
    if (!permission) {
      return;
    }
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      // ignore: avoid_print
      debugPrint('Image picker failed: $e');
    }
  }

  Future<void> _loadWeight() async {
    final prefs = await SharedPreferences.getInstance();
    _weightKg = prefs.getDouble('weight') ?? 1000.0;
    notifyListeners();
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();

    _goalCalories = (prefs.get('calorie_goal') as num?)?.toDouble() ?? 1200.0;
    notifyListeners();
  }

  Future<void> updateGoal(double newGoal) async {
    _goalCalories = newGoal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('calorie_goal', newGoal);
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  double calculateCalories() {
    return _mealNutrients.fold(
      0.0,
      (sum, item) => sum + (item['calories'] ?? 0.0),
    );
  }

  double calculateProtein() {
    return _mealNutrients.fold(
      0.0,
      (sum, item) => sum + (item['protein'] ?? 0.0),
    );
  }

  double calculateCarbs() {
    return _mealNutrients.fold(
      0.0,
      (sum, item) => sum + (item['carbs'] ?? 0.0),
    );
  }

  double calculateFat() {
    return _mealNutrients.fold(0.0, (sum, item) => sum + (item['fats'] ?? 0.0));
  }

  Future<void> saveMealCalories(
    String date,
    List<Map<String, dynamic>> meals,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = meals.map((meal) => jsonEncode(meal)).toList();
    await prefs.setStringList(date, encoded);
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> loadMealCalories(String date) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(date);

    if (data != null) {
      return data.map((encoded) {
        Map<String, dynamic> decoded = jsonDecode(encoded);
        return decoded;
      }).toList();
    } else {
      return [];
    }
  }

  Future<void> _loadForSelectedDate() async {
    _mealNutrients = await loadMealCalories(_formatDate(_selectedDate));
    notifyListeners();
  }

  Future<void> addMeal(
    DateTime date,
    String foodName,
    List<double> nutrients,
  ) async {
    final uuid = Uuid();
    final mealKey = 'meal_${uuid.v4()}';
    final currentMeals = await loadMealCalories(_formatDate(date));
    final meal = {
      'key': mealKey,
      'name': foodName,
      'calories': nutrients[0],
      'protein': nutrients[1],
      'carbs': nutrients[2],
      'fats': nutrients[3],
      'date': _formatDate(date),
    };
    currentMeals.add(meal);
    _mealNutrients = currentMeals;
    await saveMealCalories(_formatDate(date), currentMeals);
    notifyListeners();
  }

  Future<void> removemeal(String key, String date) async {
    _mealNutrients.removeWhere((item) => item['key'] == key);
    await saveMealCalories(date, _mealNutrients);
    notifyListeners();
  }

  Future<void> updateMeal(
    String name,
    double cal,
    double p,
    double c,
    double f,
    String date,
  ) async {
    int index = _mealNutrients.indexWhere((item) => item['name'] == name);
    _mealNutrients[index]["calories"] = cal;
    _mealNutrients[index]["protein"] = p;
    _mealNutrients[index]["carbs"] = c;
    _mealNutrients[index]["fats"] = f;
    await saveMealCalories(date, _mealNutrients);
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    _selectedDate = DateTime(date.year, date.month, date.day);
    _loadForSelectedDate();
    notifyListeners();
  }

  // Future<List<double>> getTextResponse(String prompt) async {
  //   final query = "https://api.calorieninjas.com/v1/nutrition?query=$prompt";
  //   final headers = {'X-Api-Key': dotenv.env['CALORIE_API_KEY']!};
  //   double calories = 0.0;
  //   double protein = 0.0;
  //   double carbs = 0.0;
  //   double fat = 0.0;
  //   try {
  //     final response = await http.get(Uri.parse(query), headers: headers);
  //     final data = jsonDecode(response.body)['items'];

  //     for (var item in data) {
  //       calories += item['calories'] ?? 0.0;
  //       protein += item['protein_g'] ?? 0.0;
  //       carbs += item['carbohydrates_total_g'] ?? 0.0;
  //       fat += item['fat_total_g'] ?? 0.0;
  //     }
  //     return [calories.roundToDouble(), protein.roundToDouble()*4, carbs.roundToDouble()*4, fat.roundToDouble()*9];
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     return [calories, protein, carbs, fat];
  //   }
  // }
  Future<List<double>> getTextResponse(String prompt) async {
    Future<String?> parseNutrient(String nutrient) async {
      final result = await getNutrientsPropmt(prompt, nutrient);
      return result;
    }

    final results = await Future.wait([
      parseNutrient("calories"),
      parseNutrient("protein"),
      parseNutrient("carbs"),
      parseNutrient("fats"),
    ]);

    return results
        .map((result) => double.tryParse(result ?? '0.0') ?? 0.0)
        .toList();
  }

  Future<List<double>> getImageResponse(File? image) async {
    Future<double> parseNutrient(String nutrient) async {
      final result = await getNutrientsImage(image!, nutrient);
      return double.tryParse(result!) ?? 0.0;
    }

    return Future.wait([
      parseNutrient("calories"),
      parseNutrient("protein"),
      parseNutrient("carbs"),
      parseNutrient("fats"),
    ]);
  }

  Future<String?> getNutrientsPropmt(String prompt, String nutrient) async {
    final query =
        "You are a certified nutritionist and food database expert. Use only reliable nutritional sources, including official food composition databases and verified brand-label data. Estimate the amount of $nutrient in grams (g) in the described food item, based on typical portion sizes, preparation methods, and ingredients. If details are missing, make reasonable, realistic assumptions based on common recipes and serving sizes. Respond with only a single number — no units, no words, no ranges, no breakdowns, and no explanations. If multiple values exist, choose the lowest credible estimate. How much $nutrient is in $prompt?";
    final queryC =
        "You are a certified nutritionist and food database expert. Use only reliable nutritional sources, including official food composition databases and verified brand-label data. Estimate the total calories in kilocalories (Kcal) for the described food item, based on typical portion sizes, preparation methods, and ingredients. If details are missing, make reasonable, realistic assumptions based on common recipes and serving sizes. Respond with only a single number — no units, no words, no ranges, no breakdowns, and no explanations. If multiple values exist, choose the lowest credible estimate. How many kilocalories are in $prompt?";
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: dotenv.env['AI_KEY']!,
      );
      final response = await model.generateContent([
        Content.text(nutrient == "calories" ? queryC : query),
      ]);
      final text = response.text;
      if (text == null || double.tryParse(text) == null) {
        return ('Invalid or missing API response: $text');
      }
      return response.text ?? "No response";
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> getNutrientsImage(File image, String nutrient) async {
    final imageBytes = await image.readAsBytes();
    final queryC =
        "You are a certified nutritionist and food database expert. Use only reliable nutritional sources, including official food composition databases and verified brand-label data. Estimate the total calories in kilocalories (Kcal) for the food item depicted in the image, based on the visible quantity, preparation method, and ingredients. If details are missing, make reasonable, realistic assumptions based on common recipes and serving sizes. Respond with only a single number — no units, no words, no ranges, no breakdowns, and no explanations. If multiple values exist, choose the lowest credible estimate. How many kilocalories are in the following image?";
    final query =
        "You are a certified nutritionist and food database expert. Use only reliable nutritional sources, including official food composition databases and verified brand-label data. Estimate the amount of $nutrient in grams (g) in the food item depicted in the image, based on the visible quantity, preparation method, and ingredients. If details are missing, make reasonable, realistic assumptions based on common recipes and serving sizes. Respond with only a single number — no units, no words, no ranges, no breakdowns, and no explanations. If multiple values exist, choose the lowest credible estimate. How many grams of $nutrient are in the following image?";
    try {
      final model = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: dotenv.env['AI_KEY']!,
      );
      final response = await model.generateContent([
        Content.multi([
          TextPart(nutrient == "calories" ? queryC : query),
          DataPart('image/jpeg', imageBytes),
        ]),
      ]);
      final text = response.text;
      if (text == null || double.tryParse(text) == null) {
        return ('Invalid or missing API response: $text');
      }
      return response.text ?? "No response";
    } catch (e) {
      return "Error: $e";
    }
  }
}
