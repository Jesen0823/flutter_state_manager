class SettingsRepository {
  bool _darkMode = false;

  bool get isDarkMode => _darkMode;

  void toggleDarkMode() => _darkMode = !_darkMode;
}
