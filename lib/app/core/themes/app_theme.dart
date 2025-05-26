import 'package:flutter/material.dart';
import 'package:fakestore/app/core/themes/app_theme_manager.dart';
import 'package:fakestore/app/core/themes/app_theme_mode.dart';
import 'package:fakestore/app/core/themes/inherited_app_theme.dart';
import 'package:fakestore/app/core/themes/theme_preferences.dart';
import 'package:fakestore/app/core/themes/themes.dart';

/// Widget that allows to switch themes dynamically. This is intended to be
/// used above [MaterialApp].
/// Example:
///
/// AdaptiveTheme(
///   light: lightTheme,
///   dark: darkTheme,
///   initial: AdaptiveThemeMode.light,
///   builder: (theme, darkTheme) => MaterialApp(
///     theme: theme,
///     darkTheme: darkTheme,
///     home: MyHomePage(),
///   ),
/// );
class AppTheme extends StatefulWidget {
  /// Primary constructor which allows to configure themes initially.
  const AppTheme({
    required this.initial,
    required this.builder,
    super.key,
  });

  /// Indicates which [AdaptiveThemeMode] to use initially.
  final AppThemeMode initial;

  /// Provides a builder with access of light and dark theme. Intended to
  /// be used to return [MaterialApp].
  final WidgetBuilder builder;

  @override
  State<AppTheme> createState() => _AppThemeState();

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  static AppThemeManager<CustomTheme> of(BuildContext context) {
    context
        .dependOnInheritedWidgetOfExactType<InheritedAppTheme<CustomTheme>>()!;

    return context.findAncestorStateOfType<State<AppTheme>>()!
        as AppThemeManager<CustomTheme>;
  }

  /// Returns reference of the [AdaptiveThemeManager] which allows access of
  /// the state object of [AdaptiveTheme] in a restrictive way.
  /// This returns null if the state instance of [AdaptiveTheme] is not found.
  static AppThemeManager<CustomTheme>? maybeOf(BuildContext context) {
    context.dependOnInheritedWidgetOfExactType<InheritedAppTheme<ThemeData>>();
    final state = context.findAncestorStateOfType<State<AppTheme>>();
    if (state == null) {
      return null;
    }

    return state as AppThemeManager<CustomTheme>;
  }

  /// returns most recent theme mode. This can be used to eagerly get previous
  /// theme mode inside main method before calling [runApp].
  static Future<AppThemeMode> getThemeMode() async =>
      (await ThemePreferences.fromPrefs())?.mode ?? AppThemeMode.system;
}

class _AppThemeState extends State<AppTheme>
    with WidgetsBindingObserver, AppThemeManager<CustomTheme> {
  @override
  void initState() {
    super.initState();
    initialize(
      light: Themes.light,
      dark: Themes.dark,
      initial: widget.initial,
    );

    WidgetsBinding.instance.addObserver(this);
  }

  // When device theme mode is changed, Flutter does not rebuild
  /// [CupertinoApp] and Because of that, if theme is set to
  /// [AdaptiveThemeMode.system]. it doesn't take effect. This check mitigates
  /// that and refreshes the UI to use new theme if needed.
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (mode.isSystem && mounted) {
      setState(() {});
    }
  }

  @override
  Brightness get brightness => theme.brightness;

  @override
  Widget build(BuildContext context) => InheritedAppTheme<CustomTheme>(
        manager: this,
        child: Builder(
          builder: widget.builder,
        ),
      );

  @override
  void updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    modeChangeNotifier.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
