// ignore_for_file: strict_top_level_inference
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:healthapp/providers/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PedometerProvider extends ChangeNotifier {
  String _steps = '0';
  String get steps => _steps;

  int _goalSteps = 10000;
  int get goalSteps => _goalSteps;

  double _burned = 0;
  double get burned => _burned;

  String _weightUnit = "Kg";
  String get weightUnit => _weightUnit;

  double _weightKg = 67;
  double get weightKg => _weightUnit == "Kg" ? _weightKg : _weightKg / 2.205;

  String _heightUnit = "Kg";
  String get heightUnit => _heightUnit;

  double _height = 1;

  String _gender = "Female";
  String get gender => _gender;

  int _water = 0;
  int get water => _water;

  Stream<StepCount>? _stepCountStream;
  Map<DateTime, int> dailySteps = {};
  DateTime? _lastUpdatedDate;
  DateTime _selectedDate = DateTime.now();

  PedometerProvider() {
    _init();
    _loadGoal();
    _loadHeight();
    _loadWeight();
    _loadGender();
    _loadWater();
    loadDailySteps();
    getCurrentTemperature();
  }

  Future<void> getCurrentTemperature() async {
    try {
      final url =
          'https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/lebanon?unitGroup=metric&elements=temp&include=current&key=2FNMHGKU7AR2D7X8HQDFE2KDM&contentType=json';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temp = data['currentConditions']?['temp'];
        caloriesBurned(temp);
      } else {
        print('Failed to fetch temperature');
      }
    } catch (e) {
      print('Error getting temperature: $e');
    }
  }

  Future<void> _init() async {
    if (!await _checkActivityRecognitionPermission()) {
      _steps = 'Unable to access step count';
      notifyListeners();
      return;
    }
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
  }

  Future<void> _loadWeight() async {
    final prefs = await SharedPreferences.getInstance();
    _weightKg = prefs.getDouble('weight') ?? 100.0;
    notifyListeners();
  }

  Future<void> updateWeight(double newWeight) async {
    _weightKg = newWeight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', newWeight.toDouble());
    notifyListeners();
  }

  Future<void> updateWeightUnit(String newUnit) async {
    _weightUnit = newUnit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weightUnit', newUnit);
    notifyListeners();
  }

  Future<void> _loadHeight() async {
    final prefs = await SharedPreferences.getInstance();
    _height = prefs.getDouble('height') ?? 130.0;
    notifyListeners();
  }

  Future<void> updateHeight(double newHeight) async {
    _height = newHeight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('height', newHeight.toDouble());
    notifyListeners();
  }

  Future<void> updateHeightUnit(String newUnit) async {
    _heightUnit = newUnit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('heighttUnit', newUnit);
    notifyListeners();
  }

  Future<void> _loadGender() async {
    final prefs = await SharedPreferences.getInstance();
    _gender = prefs.getString('gender') ?? "Female";
    notifyListeners();
  }

  Future<void> updateGender(String newGender) async {
    _gender = newGender;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gender', newGender);
    notifyListeners();
  }

  Future<void> _loadWater() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey =
        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";

    _water = prefs.getInt(dateKey) ?? 0;
    notifyListeners();
  }

  Future<void> updateWater(int newWater) async {
    _water += newWater;
    final prefs = await SharedPreferences.getInstance();
    final dateKey =
        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";
    await prefs.setInt(dateKey, _water);
    notifyListeners();
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    _goalSteps = prefs.getInt('step_goal') ?? 10000;
    notifyListeners();
  }

  Future<void> updateGoal(int newGoal) async {
    _goalSteps = newGoal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('step_goal', newGoal);
    notifyListeners();
  }

  Future<void> updateSelectedDate(DateTime date) async {
    _selectedDate = DateTime(date.year, date.month, date.day);
    await _loadWater();
    notifyListeners();
  }

  void onStepCountUpdated(int stepCount) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_lastUpdatedDate == null || _lastUpdatedDate!.isBefore(today)) {
      if (_lastUpdatedDate != null) {
        dailySteps[_lastUpdatedDate!] = int.parse(_steps);
      }
      _steps = '0';
    }
    _lastUpdatedDate = today;
    _steps = stepCount.toString();
    NotificationService().showNotification(_steps, ongoing: true);
    notifyListeners();
  }

  Future<void> loadDailySteps() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString('dailySteps');
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

      dailySteps = jsonMap.map(
        (key, value) => MapEntry(DateTime.parse(key), value as int),
      );
    }
  }

  Future<void> saveDailySteps(Map<DateTime, int> dailySteps) async {
    final prefs = await SharedPreferences.getInstance();
    final stringMap = dailySteps.map(
      (key, value) => MapEntry(key.toIso8601String(), value),
    );

    prefs.setString('dailySteps', jsonEncode(stringMap));
  }

  Future<void> addDailySteps(int steps) async {
    dailySteps[_selectedDate] = steps;
    saveDailySteps(dailySteps);
    _steps = steps.toString();
    notifyListeners();
  }

  void _onStepCount(StepCount event) {
    final currentSteps = event.steps;

    final today = DateTime.now();
    final normalizedDate = DateTime(today.year, today.month, today.day);
    dailySteps[normalizedDate] = currentSteps;
    saveDailySteps(dailySteps);
    _steps = currentSteps.toString();
    notifyListeners();
  }

  void _onStepCountError(error) {
    _steps = 'Step Count not available';
    notifyListeners();
  }

  Future<bool> _checkActivityRecognitionPermission() async {
    bool granted = await Permission.activityRecognition.isGranted;
    if (!granted) {
      granted =
          await Permission.activityRecognition.request() ==
          PermissionStatus.granted;
    }
    return granted;
  }

  int get selectedSteps {
    final date = _selectedDate;
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return dailySteps[normalizedDate] ?? 0;
  }

  DateTime get selectedDate {
    return _selectedDate;
  }

  double get height {
    if (_heightUnit == "cm") {
      return _height / 100;
    } else if (_heightUnit == "feet") {
      return _height / 3.281;
    } else {
      return _height;
    }
  }

  double get strideLength {
    double k = _gender == 'Female' ? 0.413 : 0.415;
    return height * k;
  }

  double get distanceKm {
    final stepCount = selectedSteps;
    final totalDistance = (stepCount * strideLength) / 1000;
    return totalDistance.roundToDouble();
  }

  double get progress {
    if (goalSteps == 0) return 0.0;
    final current = selectedSteps;
    return (current / goalSteps).clamp(0.0, 1.0);
  }

  void caloriesBurned(double temperature) {
    double baseCalories = distanceKm * weightKg * 1.036;

    double tempFactor = 1.0;
    if (temperature > 25 || temperature < 10) {
      tempFactor = 1.1;
    }
    _burned = baseCalories * tempFactor;
  }

  double get durationMinutes {
    return ((distanceKm * 12) / 60);
  }
}
