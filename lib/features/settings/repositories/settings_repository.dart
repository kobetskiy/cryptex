import 'dart:developer';
import 'dart:ui';

import 'package:cryptex/core/localization/app_localization.dart';
import 'package:cryptex/features/settings/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<void> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('lang', locale.languageCode);
    } catch (e) {}
  }

  @override
  Future<Locale> getLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('lang');

      if (languageCode != null) {
        return Locale(languageCode);
      }
      final systemLocale = PlatformDispatcher.instance.locale;
      final supportedLanguages =
          AppLocalization.supportedLocales
              .map((locale) => locale.languageCode)
              .toList();

      if (supportedLanguages.contains(systemLocale.languageCode)) {
        return systemLocale;
      }

      return const Locale('en');
    } catch (e) {
      return const Locale('en');
    }
  }

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String themeName = '';
      if (themeMode == ThemeMode.dark) {
        themeName = 'dark';
      } else if (themeMode == ThemeMode.light) {
        themeName = 'light';
      } else {
        themeName = 'system';
      }
      prefs.setString('theme', themeName);
    } catch (e) {}
  }

  @override
  Future<ThemeMode> getTheme() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String themeName = prefs.getString('theme') ?? 'dark';
      late ThemeMode result;

      if (themeName == 'dark') {
        result = ThemeMode.dark;
      } else if (themeName == 'light') {
        result = ThemeMode.light;
      } else {
        result = ThemeMode.system;
      }

      return result;
    } catch (e) {
      return ThemeMode.dark;
    }
  }

  @override
  Future<void> setAppLock(passCode) async {
    try {
      log('setAppLock');
    } catch (e) {}
  }
}
