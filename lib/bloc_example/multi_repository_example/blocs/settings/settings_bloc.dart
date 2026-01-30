import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/settings/settings_event.dart';
import 'package:state_manager/bloc_example/multi_repository_example/blocs/settings/settings_state.dart';
import 'package:state_manager/bloc_example/multi_repository_example/repositories/settings_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc(this.settingsRepository) : super(SettingsInitial()) {
    on<ToggleTheme>((event, emit) async {
      settingsRepository.toggleDarkMode();
      final isDark = settingsRepository.isDarkMode;
      emit(SettingsTheme(isDark));
    });
  }
}
