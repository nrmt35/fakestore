import 'package:flutter/material.dart';
import 'package:fakestore/app/core/themes/app_theme_mode.dart';
import 'package:fakestore/app/core/themes/theme_preferences.dart';

mixin AppThemeManager<T extends Object> {
  late T _theme;
  late T _darkTheme;

  late ThemePreferences _preferences;

  late ValueNotifier<AppThemeMode> _modeChangeNotifier;

  /// provides current theme
  T get theme {
    if (_preferences.mode.isSystem) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      return brightness == Brightness.light ? _theme : _darkTheme;
    }

    return _preferences.mode.isDark ? _darkTheme : _theme;
  }

  /// provides the light theme
  T get lightTheme => _theme;

  /// provides the dark theme
  T get darkTheme => _darkTheme;

  /// Returns current theme mode
  AppThemeMode get mode => _preferences.mode;

  /// Returns the default(initial) theme mode
  AppThemeMode get defaultMode => _preferences.defaultMode;

  /// Allows to listen to changes in them mode.
  ValueNotifier<AppThemeMode> get modeChangeNotifier => _modeChangeNotifier;

  /// provides brightness of the current theme
  Brightness? get brightness;

  void initialize({
    required T light,
    required T dark,
    required AppThemeMode initial,
  }) {
    _theme = light;
    _modeChangeNotifier = ValueNotifier(initial);
    _darkTheme = dark;
    _preferences = ThemePreferences.initial(mode: initial);

    ThemePreferences.fromPrefs().then((pref) {
      if (pref == null) {
        _preferences.save();
      } else {
        _preferences = pref;
        updateState();
      }
    });
  }

  /// Sets light theme as current
  /// Uses [AppThemeMode.light].
  void setLight() => setThemeMode(AppThemeMode.light);

  /// Sets dark theme as current
  /// Uses [AppThemeMode.dark].
  void setDark() => setThemeMode(AppThemeMode.dark);

  /// Sets theme based on the theme of the underlying OS.
  /// Uses [AppThemeMode.system].
  void setSystem() => setThemeMode(AppThemeMode.system);

  /// Allows to set/change theme mode.
  void setThemeMode(AppThemeMode mode) {
    _preferences.mode = mode;
    updateState();
    _modeChangeNotifier.value = mode;
    _preferences.save();
  }

  /// Allows to toggle between theme modes [AppThemeMode.light],
  /// [AppThemeMode.dark] and [AppThemeMode.system].
  void toggleThemeMode({bool useSystem = false}) {
    AppThemeMode nextMode = mode.next();
    if (!useSystem && nextMode.isSystem) {
      // Skip system mode.
      nextMode = nextMode.next();
    }

    setThemeMode(nextMode);
  }

  /// Saves the configuration to the shared-preferences. This can be useful
  /// when you want to persist theme settings after clearing
  /// shared-preferences. e.g. when user logs out, usually, preferences
  /// are cleared. Call this method after clearing preferences to
  /// persist theme mode.
  Future<bool> persist() async => _preferences.save();

  /// Resets configuration to default configuration which has been provided
  /// while initializing [MaterialApp].
  /// If [setTheme] method has been called with [isDefault] to true, Calling
  /// this method afterwards will use theme provided by [setTheme] as default
  /// themes.
  /// Implementations of this method should end with a call to the inherited
  /// method, as in `super.reset()`.
  @mustCallSuper
  Future<bool> reset() async {
    _preferences.reset();
    updateState();
    modeChangeNotifier.value = mode;
    return _preferences.save();
  }

  void updateState();
}
