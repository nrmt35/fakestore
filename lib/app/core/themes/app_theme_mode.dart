enum AppThemeMode {
  light('Light'),
  dark('Dark'),
  system('System');

  const AppThemeMode(this.modeName);

  final String modeName;

  bool get isLight => this == AppThemeMode.light;

  bool get isDark => this == AppThemeMode.dark;

  bool get isSystem => this == AppThemeMode.system;

  AppThemeMode next() {
    final nextIndex = (index + 1) % AppThemeMode.values.length;
    return AppThemeMode.values[nextIndex];
  }

  AppThemeMode previous() {
    final previousIndex = (index - 1) % AppThemeMode.values.length;
    return AppThemeMode.values[previousIndex];
  }
}
