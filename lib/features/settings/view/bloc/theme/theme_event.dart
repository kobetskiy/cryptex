import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ChangeTheme extends ThemeEvent {
  final ThemeMode themeMode;
  ChangeTheme({required this.themeMode});
}

class LoadTheme extends ThemeEvent {}