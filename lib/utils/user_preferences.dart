import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const appTheme = "application_theme";

  static late SharedPreferences prefs;

  static initialize() async {
    prefs = await SharedPreferences.getInstance();
  }

  static setDarkTheme(bool value) {
    prefs.setBool(appTheme, value);
  }

  static bool isDarkTheme() {
    return prefs.getBool(appTheme) ?? false;
  }
}
