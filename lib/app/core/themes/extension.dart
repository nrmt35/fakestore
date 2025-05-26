import 'package:flutter/material.dart';
import 'package:fakestore/app/core/themes/themes.dart';

extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  CustomTheme get themeC => Themes.dark;
}
