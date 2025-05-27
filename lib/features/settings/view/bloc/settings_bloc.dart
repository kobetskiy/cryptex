import 'package:bloc/bloc.dart';
import 'package:cryptex/features/settings/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepositoryInterface _settingsRepository;
  SettingsBloc({required SettingsRepositoryInterface repository})
    : _settingsRepository = repository,
      super(SettingsInitial()) {
    on<ChangeNickname>(_changeNickname);
    on<CopyId>(_copyId);
    on<SetAppLock>(_setAppLock);
  }

  Future<void> _changeNickname(
    ChangeNickname event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsLoading());
      await _settingsRepository.changeNickname(event.newNickname);
      emit(SettingsSuccess());
    } on Exception catch (e) {
      emit(SettingsFailure(e));
    }
  }

  Future<void> _copyId(CopyId event, Emitter<SettingsState> emit) async {
    try {
      emit(SettingsLoading());
      await _settingsRepository.copyId();
      emit(SettingsSuccess());
    } on Exception catch (e) {
      emit(SettingsFailure(e));
    }
  }

  Future<void> _setAppLock(
    SetAppLock event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsLoading());
      await _settingsRepository.setAppLock(event.passCode);
      emit(SettingsSuccess());
    } on Exception catch (e) {
      emit(SettingsFailure(e));
    }
  }
}
