import 'package:cryptex/features/settings/repositories/settings_repository_interface.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_event.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SettingsRepositoryInterface _settingsRepository;
  ThemeBloc({
    required SettingsRepositoryInterface repository,
  })  : _settingsRepository = repository,
        super(ThemeState.initial()) {
    on<LoadTheme>((event, emit) async {
      final themeName = await _settingsRepository.getTheme();
      emit(ThemeState(themeName));
    });

    on<ChangeTheme>((event, emit) async {
      if (event.themeMode == state.themeMode) return;
      await _settingsRepository.saveTheme(event.themeMode);
      emit(ThemeState(event.themeMode));
    });
  }
}
