abstract class SettingsState{}

class SettingsInitial extends SettingsState{}

class SettingsTheme extends SettingsState{
  final bool isDarkMode;

  SettingsTheme(this.isDarkMode);
}