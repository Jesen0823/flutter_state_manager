import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/settings/settings_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/settings/settings_event.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/settings/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final isDarkMode = state is SettingsTheme ? state.isDarkMode : false;

        return _buildPageContent(context, isDarkMode);
      },
    );
  }

  Widget _buildPageContent(BuildContext context, bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildPageTitle(),
            const SizedBox(height: 40),
            _buildSettingsCard(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return const Text(
      'App Settings',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSettingsCard(BuildContext context, bool isDarkMode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildDarkModeToggle(context, isDarkMode),
            const SizedBox(height: 24),
            _buildThemeDescription(),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeToggle(BuildContext context, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildDarkModeInfo(isDarkMode),
        _buildThemeSwitch(context, isDarkMode),
      ],
    );
  }

  Widget _buildDarkModeInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dark Mode',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          isDarkMode ? 'Enabled' : 'Disabled',
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context, bool isDarkMode) {
    return Switch(
      value: isDarkMode,
      onChanged: (_) => context.read<SettingsBloc>().add(ToggleTheme()),
      activeTrackColor: Theme.of(context).primaryColor,
      thumbColor: MaterialStateProperty.all(
        isDarkMode ? Theme.of(context).primaryColor : Colors.grey.shade400,
      ),
    );
  }

  Widget _buildThemeDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Toggle dark mode to change the app\'s theme',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}
