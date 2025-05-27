import 'package:flutter/material.dart';

class ThemeState {
  final ThemeMode themeMode;

  const ThemeState(this.themeMode);

  factory ThemeState.initial() => const ThemeState(ThemeMode.dark);

  ThemeState copyWith({ThemeMode? themeMode}) {
    return ThemeState(themeMode ?? this.themeMode);
  }
}