import 'package:flutter/material.dart';
import 'package:fakestore/app/core/themes/app_theme_manager.dart';
import 'package:fakestore/app/core/themes/app_theme_mode.dart';

class InheritedAppTheme<T extends Object> extends InheritedWidget {
  InheritedAppTheme({
    required AppThemeManager<T> manager,
    required super.child,
    super.key,
  })  : mode = manager.mode,
        theme = manager.theme,
        darkTheme = manager.darkTheme,
        brightness = manager.brightness;

  final AppThemeMode mode;
  final T theme;
  final T darkTheme;
  final Brightness? brightness;

  @override
  bool updateShouldNotify(covariant InheritedAppTheme<T> oldWidget) =>
      oldWidget.mode != mode ||
      oldWidget.theme != theme ||
      oldWidget.darkTheme != darkTheme ||
      oldWidget.brightness != brightness;
}
