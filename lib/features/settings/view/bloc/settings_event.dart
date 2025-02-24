part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

final class ChangeNickname extends SettingsEvent {
  final String newNickname;

  const ChangeNickname({required this.newNickname});
}

final class CopyId extends SettingsEvent {}

final class SetAppLock extends SettingsEvent {
  final String passCode;

  const SetAppLock({required this.passCode});
}
