import 'package:flutter/material.dart';

abstract interface class SettingsRepositoryInterface {
  Future<void> changeNickname(String newNickname);
  Future<void> copyId();
  Future<void> setAppLock(String passCode);
  Future<void> saveLocale(Locale locale);
  Future<Locale> getLocale();
  Future<void> saveTheme(ThemeMode themeMode);
  Future<ThemeMode> getTheme();
}
