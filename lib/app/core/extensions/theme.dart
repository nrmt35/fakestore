part of 'extensions.dart';

/// Темы
extension ThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  CustomTheme get themeC => AppTheme.of(this).theme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  TextTheme get accentTextTheme {
    final ThemeData theme = Theme.of(this);
    theme.textTheme.headlineLarge?.copyWith(
      color: theme.colorScheme.onSecondary,
    );
    return theme.textTheme;
  }
}
