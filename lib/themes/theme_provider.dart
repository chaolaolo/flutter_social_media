import 'package:flutter/material.dart';
import 'package:flutter_social_media/themes/dark_mode.dart';
import 'package:flutter_social_media/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //init, light mode
  ThemeData _themeData = lightMode;

  //get theme
  ThemeData get themeData => _themeData;

  // is dark mode
  bool get isDarkMode => _themeData == darkMode;

  // set theme
  set themData(ThemeData themeData) {
    _themeData = themeData;
    // update UI
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themData = darkMode;
    } else {
      themData = lightMode;
    }
  }
}
