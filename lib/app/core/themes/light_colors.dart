import 'package:flutter/services.dart';

abstract class LightColors {
  static const transparent = Color(0x00000000);
  static const backgroundPrimary = Color(0xFFFFE8B2);
  static const background = Color(0xFFFFFFFF);
  static const buttonBackground = Color(0xFF1E1E1E);
  static const container = Color(0xFFF2F2F2);
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFFA6A6AA);
  static const textSecondaryDark = Color(0xFF404040);
  static const divider = Color(0xFFE8ECF4);
  static const menuInactive = Color(0xFFCBCBD4);
  static const menuActive = Color(0xFF1E1E1E);
  static const inputField = Color(0xFFF7F8F9);
  static const hint = Color(0xFF8391A1);
  static const red = Color(0xFFCC474E);

  static const lightStatusBar = SystemUiOverlayStyle(
    statusBarColor: LightColors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static const darkStatusBar = SystemUiOverlayStyle(
    statusBarColor: LightColors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
}
