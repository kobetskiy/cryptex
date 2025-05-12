import 'package:flutter/material.dart';

abstract class _AppColors {
  // common
  static const primary = Color(0xFFEAB821);
  static const white = Colors.white;
  static const grey = Colors.grey;
  // dark
  static const darkSurface = Color(0xFF060D27);
  static const darkSecondary = Color(0xFF0C1631);
  static const darkTernary = Color(0xFF131D3C);
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
    appBarTheme: AppBarTheme(
      backgroundColor: _AppColors.darkSecondary,
      foregroundColor: _AppColors.white,
    ),
    iconTheme: IconThemeData(color: _AppColors.white),
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: _AppColors.white,
      displayColor: _AppColors.white,
    ),
    cardTheme: CardThemeData(color: _AppColors.darkSecondary),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(fontSize: 18, color: _AppColors.white),
      subtitleTextStyle: TextStyle(fontSize: 14, color: _AppColors.grey),
      leadingAndTrailingTextStyle: TextStyle(
        fontSize: 18,
        color: _AppColors.white,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

extension ColorSchemeExtension on ColorScheme {
  Color get white => _AppColors.white;
  Color get grey => _AppColors.grey;
  Color get darkSurface => _AppColors.darkSurface;
  Color get darkSecondary => _AppColors.darkSecondary;
  Color get darkTernary => _AppColors.darkTernary;
}
