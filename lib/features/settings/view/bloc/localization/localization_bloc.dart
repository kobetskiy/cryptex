import 'dart:ui';

import 'package:cryptex/features/settings/repositories/settings_repository_interface.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_event.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  final SettingsRepositoryInterface _settingsRepository;
  LocalizationBloc({
    required SettingsRepositoryInterface repository,
  })  : _settingsRepository = repository,
        super(LocalizationState.initial()) {
    on<LoadLocalization>((event, emit) async {
      Locale locale = await _settingsRepository.getLocale();
      emit(LocalizationState(locale));
    });

    on<ChangeLocale>((event, emit) async {
      if (event.locale == state.locale) return;
      await _settingsRepository.saveLocale(event.locale);
      emit(LocalizationState(event.locale));
    });
  }
}
