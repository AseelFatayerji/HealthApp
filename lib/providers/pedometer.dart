// ignore_for_file: strict_top_level_inference, non_constant_identifier_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:units_converter/units_converter.dart';

class PedometerProvider extends ChangeNotifier {
  int? _initialStepCount;

  String _steps = '0';
  String get steps => _steps;

  int _goalSteps = 10000;
  int get goalSteps => _goalSteps;

  double _burned = 0;
  double get burned => _burned;

  double _temp = 20;
  double get temp => _temp;

  String _weightUnit = "Kg";
  String get weightUnit => _weightUnit;

  double _weightKg = 67;
  double get weightKg => _weightKg;

  String _heightUnit = "m";
  String get heightUnit => _heightUnit;

  String _distanceUnit = "Km";
  String get distanceUnit => _distanceUnit;

  bool _UsMetric = false;
  bool get UsMetric => _UsMetric;

  double _height = 1;
  double get height => _height;

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
    _loadBurned();
    _loadWater();
    _loadDailySteps();
    _loadInitialData();
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
        _temp = temp;
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

  Future<void> _loadBurned() async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey =
        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}-burned";
    _burned = prefs.getDouble(dateKey) ?? 0;
    notifyListeners();
  }

  Future<void> updateDistancetUnit() async {
    if (_distanceUnit == "miles") {
      _distanceUnit = "Km";
      _UsMetric = false;
    } else {
      _distanceUnit = "miles";
      _UsMetric = true;
    }
    savePreference();
    notifyListeners();
  }

  void savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('UsMetric', _UsMetric);
  }

  Future<void> updateBurned(double newBurned) async {
    _burned = newBurned;
    final prefs = await SharedPreferences.getInstance();
    final dateKey =
        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}-burned";
    await prefs.setDouble(dateKey, _burned);
    notifyListeners();
  }

  Future<void> updateWeight(double newWeight) async {
    _weightKg = newWeight;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('weight', newWeight.toDouble());
    notifyListeners();
  }

  Future<void> updateWeightUnit(String newUnit) async {
    if (newUnit == "Kg" && _weightUnit == "Lb") {
      _weightKg = _weightKg.convertFromTo(MASS.pounds, MASS.kilograms)!;
      _weightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('weightUnit', newUnit);
      updateWeight(double.parse(_weightKg.toStringAsFixed(2)));
      notifyListeners();
    } else {
      _weightKg = _weightKg.convertFromTo(MASS.kilograms, MASS.pounds)!;
      _weightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('weightUnit', newUnit);
      updateWeight(double.parse(_weightKg.toStringAsFixed(2)));
      notifyListeners();
    }
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
    if (newUnit == "cm" && _heightUnit == "m") {
      _height = _height.convertFromTo(LENGTH.meters, LENGTH.centimeters)!;
      _heightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('heightUnit', newUnit);
      updateHeight(double.parse(_height.toStringAsFixed(2)));
      notifyListeners();
    } else if (newUnit == "cm" && _heightUnit == "feet") {
      _height = _height.convertFromTo(LENGTH.feetUs, LENGTH.centimeters)!;
      _heightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('heightUnit', newUnit);
      updateHeight(double.parse(_height.toStringAsFixed(2)));
      notifyListeners();
    } else if (newUnit == "m" && _heightUnit == "cm") {
      _height = _height.convertFromTo(LENGTH.centimeters, LENGTH.meters)!;
      _heightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('heightUnit', newUnit);
      updateHeight(double.parse(_height.toStringAsFixed(2)));
      notifyListeners();
    } else if (newUnit == "m" && _heightUnit == "feet") {
      _height = _height.convertFromTo(LENGTH.feetUs, LENGTH.centimeters)!;
      _heightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('heightUnit', newUnit);
      updateHeight(double.parse(_height.toStringAsFixed(2)));
      notifyListeners();
    } else if (newUnit == "feet" && _heightUnit == "cm") {
      _height = _height.convertFromTo(LENGTH.centimeters, LENGTH.feetUs)!;
      _heightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('heightUnit', newUnit);
      updateHeight(double.parse(_height.toStringAsFixed(2)));
      notifyListeners();
    } else {
      _height = _height.convertFromTo(LENGTH.meters, LENGTH.feetUs)!;
      _heightUnit = newUnit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('heightUnit', newUnit);
      updateHeight(double.parse(_height.toStringAsFixed(2)));
      notifyListeners();
    }
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
    caloriesBurned(_temp);
    await _loadWater();
    notifyListeners();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final formatter = DateFormat('yyyy-MM-dd');

    final savedDateStr = prefs.getString('lastUpdatedDate');
    if (savedDateStr != null) {
      _lastUpdatedDate = formatter.parse(savedDateStr);
    }

    final todayKey = formatter.format(DateTime.now());
    final savedInitialStepCount = prefs.getInt('initialStepCount-$todayKey');
    if (savedInitialStepCount != null) {
      _initialStepCount = savedInitialStepCount;
    }
  }

  Future<void> _loadDailySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('dailySteps');

    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      dailySteps = jsonMap.map(
        (key, value) =>
            MapEntry(DateFormat('yyyy-MM-dd').parse(key), value as int),
      );
    }
  }

  Future<void> saveDailySteps(Map<DateTime, int> dailySteps) async {
    final prefs = await SharedPreferences.getInstance();
    final formatter = DateFormat('yyyy-MM-dd');

    final stringMap = dailySteps.map(
      (key, value) => MapEntry(formatter.format(key), value),
    );
    prefs.setString('dailySteps', jsonEncode(stringMap));
  }

  Future<void> addDailySteps(int steps) async {
    dailySteps[_selectedDate] = (dailySteps[_selectedDate] ?? 0) + steps;
    _steps = steps.toString();
    saveDailySteps(dailySteps);
    caloriesBurned(_temp);
    notifyListeners();
  }

  Future<void> _onStepCount(StepCount event) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStepCount = event.steps;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final formatter = DateFormat('yyyy-MM-dd');
    final todayKey = formatter.format(today);

    if (_lastUpdatedDate == null || _lastUpdatedDate!.isBefore(today)) {
      _initialStepCount = currentStepCount;
      _lastUpdatedDate = today;
      await prefs.setString('lastUpdatedDate', todayKey);
      await prefs.setInt('initialStepCount-$todayKey', _initialStepCount!);
    } else if (_initialStepCount == null) {
      final saved = prefs.getInt('initialStepCount-$todayKey');
      _initialStepCount = saved ?? currentStepCount;
    }

    final todaySteps =
        currentStepCount - (_initialStepCount ?? currentStepCount);
    dailySteps[today] = todaySteps;
    _steps = todaySteps.toString();

    await saveDailySteps(dailySteps);
    caloriesBurned(_temp);
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

  double get strideLength {
    double k = _gender == 'Female' ? 0.413 : 0.415;
    if (_heightUnit == "cm") {
      return (height / 100) * k;
    } else if (_heightUnit == "feet") {
      return (height / 3.281) * k;
    } else {
      return height * k;
    }
  }

  double get distanceKm {
    final stepCount = selectedSteps;
    final totalDistance = (stepCount * strideLength.round()) / 1000;
    if (_distanceUnit == "Km") {
      return double.parse(totalDistance.toStringAsFixed(2));
    } else {
      return double.parse((totalDistance / 1.609).toStringAsFixed(2));
    }
  }

  double get progress {
    if (goalSteps == 0) return 0.0;
    final current = selectedSteps;
    return (current / goalSteps).clamp(0.0, 1.0);
  }

  void caloriesBurned(double temperature) {
    if (_weightUnit == "Kg") {
      double baseCalories = distanceKm * weightKg * 1.036;
      double tempFactor = 1.0;
      if (temperature > 25 || temperature < 10) {
        tempFactor = 1.1;
      }
      updateBurned(baseCalories * tempFactor);
    } else {
      double baseCalories = distanceKm * (weightKg / 3.281) * 1.036;
      double tempFactor = 1.0;
      if (temperature > 25 || temperature < 10) {
        tempFactor = 1.1;
      }
      updateBurned(baseCalories * tempFactor);
    }
  }

  double get durationMinutes {
    return double.parse(((distanceKm * 12) / 60).toStringAsFixed(2));
  }
}
