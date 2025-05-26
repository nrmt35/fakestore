import 'package:fakestore/app/core/themes/dark_colors.dart';
import 'package:fakestore/app/core/themes/light_colors.dart';
import 'package:flutter/material.dart';

const FONT_FAMILY = 'Urbanist';

class Themes with ChangeNotifier {
  static CustomTheme get light => CustomTheme(
        backgroundPrimary: LightColors.backgroundPrimary,
        background: LightColors.background,
        buttonBackground: LightColors.buttonBackground,
        container: LightColors.container,
        textPrimary: LightColors.textPrimary,
        textSecondary: LightColors.textSecondary,
        textSecondaryDark: LightColors.textSecondaryDark,
        divider: LightColors.divider,
        menuInactive: LightColors.menuInactive,
        menuActive: LightColors.menuActive,
        red: LightColors.red,
        inputField: LightColors.inputField,
        hint: LightColors.hint,
        textStyle: TextStyle(
          fontFamily: FONT_FAMILY,
        ),
        brightness: Brightness.light,
      );

  static CustomTheme get dark => CustomTheme(
        backgroundPrimary: DarkColors.backgroundPrimary,
        background: DarkColors.background,
        buttonBackground: DarkColors.buttonBackground,
        container: DarkColors.container,
        textPrimary: DarkColors.textPrimary,
        textSecondary: DarkColors.textSecondary,
        textSecondaryDark: DarkColors.textSecondaryDark,
        divider: DarkColors.divider,
        menuInactive: DarkColors.menuInactive,
        menuActive: DarkColors.menuActive,
        red: DarkColors.red,
        inputField: DarkColors.inputField,
        hint: DarkColors.hint,
        textStyle: TextStyle(
          fontFamily: FONT_FAMILY,
        ),
        brightness: Brightness.dark,
      );
}

final class CustomTheme {
  CustomTheme({
    required this.backgroundPrimary,
    required this.background,
    required this.buttonBackground,
    required this.container,
    required this.textPrimary,
    required this.textSecondary,
    required this.textSecondaryDark,
    required this.divider,
    required this.menuInactive,
    required this.menuActive,
    required this.red,
    required this.brightness,
    required this.inputField,
    required this.hint,
    required this.textStyle,
  });

  /// Colors
  final Color backgroundPrimary;
  final Color background;
  final Color buttonBackground;
  final Color container;
  final Color textPrimary;
  final Color textSecondary;
  final Color textSecondaryDark;
  final Color divider;
  final Color menuInactive;
  final Color menuActive;
  final Color red;
  final Color inputField;
  final Color hint;
  final TextStyle textStyle;

  final Brightness brightness;
}
