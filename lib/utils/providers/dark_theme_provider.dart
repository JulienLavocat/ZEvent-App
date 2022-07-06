import 'package:flutter/material.dart';
import 'package:zevent/utils/user_preferences.dart';

class DarkThemeProvider with ChangeNotifier {
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    UserPreferences.setDarkTheme(value);
    notifyListeners();
  }
}
