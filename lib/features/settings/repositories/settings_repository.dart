import 'dart:developer';

import 'package:cryptex/features/settings/repositories/repositories.dart';
import 'package:flutter/material.dart';

class SettingsRepository implements SettingsRepositoryInterface {
  @override
  Future<void> changeNickname(String newNickname) async {
    try {
      log('changeNickname');
    } catch (e) {}
  }

  @override
  Future<void> copyId() async {
    try {
      log('copyId');
    } catch (e) {}
  }

  @override
  Future<Locale> getLocale() async {
    try {
      log('getLocale');
      return Locale('en');
    } catch (e) {
      return Locale('en');
    }
  }

  @override
  Future<ThemeMode> getTheme() async {
    try {
      log('getTheme');
      return ThemeMode.dark;
    } catch (e) {
      return ThemeMode.dark;
    }
  }

  @override
  Future<void> saveLocale(Locale locale) async {
    try {
      log('saveLocale');
    } catch (e) {}
  }

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    try {
      log('saveTheme');
    } catch (e) {}
  }

  @override
  Future<void> setAppLock(passCode) async {
    try {
      log('setAppLock');
    } catch (e) {}
  }
}
