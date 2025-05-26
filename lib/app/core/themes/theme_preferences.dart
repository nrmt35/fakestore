import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:fakestore/app/core/themes/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _THEME_KEY = 'app_theme_key';
const _THEME_MODE_KEY = 'theme_mode';
const _DEFAULT_THEME_MODE_KEY = 'default_theme_mode';

/// Utility for storing theme info in SharedPreferences
class ThemePreferences {
  ThemePreferences._(this.mode, this.defaultMode);

  ThemePreferences.initial({AppThemeMode mode = AppThemeMode.light})
      : this._(mode, mode);

  ThemePreferences.fromJson(Map<String, dynamic> json) {
    if (json[_THEME_MODE_KEY] != null) {
      mode = AppThemeMode.values[json[_THEME_MODE_KEY]];
    } else {
      mode = AppThemeMode.light;
    }

    if (json[_DEFAULT_THEME_MODE_KEY] != null) {
      defaultMode = AppThemeMode.values[json[_DEFAULT_THEME_MODE_KEY]];
    } else {
      defaultMode = mode;
    }
  }

  late AppThemeMode mode;
  late AppThemeMode defaultMode;

  void reset() => mode = defaultMode;

  Map<String, dynamic> toJson() => {
        _THEME_MODE_KEY: mode.index,
        _DEFAULT_THEME_MODE_KEY: defaultMode.index,
      };

  /// saves the current theme preferences to the shared-preferences
  Future<bool> save() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_THEME_KEY, json.encode(toJson()));
  }

  /// retrieves preferences from the shared-preferences
  static Future<ThemePreferences?> fromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeDataString = prefs.getString(_THEME_KEY);
      if (themeDataString == null || themeDataString.isEmpty) {
        return null;
      }

      return ThemePreferences.fromJson(json.decode(themeDataString));
    } on Exception catch (error, stacktrace) {
      if (kDebugMode) {
        print(error);
        print(stacktrace);
      }
      return null;
    }
  }
}
