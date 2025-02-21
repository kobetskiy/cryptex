import 'package:flutter/material.dart';

abstract class _AppColors {
  // common
  static const primary = Color(0xFFEAB821);
  // dark
  static const darkSurface = Color(0xFF111B3C);
}

abstract class AppTheme {
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _AppColors.primary,
      primary: _AppColors.primary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: _AppColors.darkSurface,
  );
}

extension ColorSchemeExtension on ColorScheme {
  Color get darkSurface => _AppColors.darkSurface;
}