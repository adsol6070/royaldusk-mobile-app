import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:royaldusk_mobile_app/theme/styles.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  late SharedPreferences prefs;

  ThemeProvider({bool isDark = false}) {
    _selectedTheme = isDark ? Styles.darkTheme : Styles.lightTheme;
  }

  ThemeData get getTheme => _selectedTheme;

  Future<void> changeTheme() async {
    prefs = await SharedPreferences.getInstance();

    if (_selectedTheme == Styles.darkTheme) {
      _selectedTheme = Styles.lightTheme;
      await prefs.setBool("isDark", false);
    } else {
      _selectedTheme = Styles.darkTheme;
      await prefs.setBool("isDark", true);
    }
//notifying all the listeners(consumers) about the change.
    notifyListeners();
  }
}
