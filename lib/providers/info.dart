import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthapp/theme.dart';

class InfoProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  bool get isDarkMode => _isDarkMode;

  bool _isPinned = false;
  bool get isPinned => _isPinned;

  ThemeData _themeData = lightTheme;
  ThemeData get themeData => _themeData;
  void pin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_isPinned) {
      _isPinned = false;
    } else {
      _isPinned = true;
    }
    prefs.setBool('isPinned', _isPinned);
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
      _isDarkMode = true;
    } else {
      _themeData = lightTheme;
      _isDarkMode = false;
    }
    saveTheme();
    notifyListeners();
  }

  void saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  void load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _isPinned = prefs.getBool('isPinned') ?? false;
    _themeData = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }
}
