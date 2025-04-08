import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences _prefs;
  ThemeMode _themeMode;

  ThemeProvider(this._prefs)
      : _themeMode = ThemeMode
            .values[_prefs.getInt(_themeKey) ?? ThemeMode.system.index] {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadThemeMode() {
    final savedThemeMode = _prefs.getInt(_themeKey);
    if (savedThemeMode != null) {
      _themeMode = ThemeMode.values[savedThemeMode];
      notifyListeners();
    }
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _prefs.setInt(_themeKey, _themeMode.index);
    notifyListeners();
  }
}
