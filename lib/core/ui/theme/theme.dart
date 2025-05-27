import 'package:flutter/material.dart';

abstract class AppColors {
  // common
  static const primary = Color(0xFFEAB821);
  static const white = Colors.white;
  static const black = Colors.black;
  static const grey = Colors.grey;
  // dark
  static const darkSurface = Color(0xFF060D27);
  static const darkSecondary = Color(0xFF0C1631);
  static const darkTernary = Color(0xFF131D3C);
  // light
  static const lightSurface = Color(0xFFFFFDF7);
  static const lightSecondary = Color(0xFFDBDBDB);
  static const lightTernary = Color(0xFF9DC5F4);
}

abstract class AppTheme {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.light,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightSecondary,
    ),
    secondaryHeaderColor: AppColors.lightSecondary,
    brightness: Brightness.light,

    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.lightSurface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightSecondary,
      foregroundColor: AppColors.black,
    ),
    iconTheme: IconThemeData(color: AppColors.white),
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: AppColors.black,
      displayColor: AppColors.black,
    ),
    cardTheme: CardThemeData(color: AppColors.lightTernary),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(fontSize: 18, color: AppColors.black),
      subtitleTextStyle: TextStyle(fontSize: 14, color: AppColors.grey),
      leadingAndTrailingTextStyle: TextStyle(
        fontSize: 18,
        color: AppColors.white,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      brightness: Brightness.dark,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkSecondary,
    ),
    secondaryHeaderColor: AppColors.darkSecondary,
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkSurface,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSecondary,
      foregroundColor: AppColors.white,
    ),
    iconTheme: IconThemeData(color: AppColors.white),
    textTheme: Typography.whiteMountainView.apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    ),
    cardTheme: CardThemeData(color: AppColors.darkSecondary),
    listTileTheme: ListTileThemeData(
      titleTextStyle: TextStyle(fontSize: 18, color: AppColors.white),
      subtitleTextStyle: TextStyle(fontSize: 14, color: AppColors.grey),
      leadingAndTrailingTextStyle: TextStyle(
        fontSize: 18,
        color: AppColors.white,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

extension ColorSchemeExtension on ColorScheme {
  Color get white => AppColors.white;
  Color get black => AppColors.black;
  Color get grey => AppColors.grey;
  Color get darkSurface => AppColors.darkSurface;
  Color get darkSecondary => AppColors.darkSecondary;
  Color get darkTernary => AppColors.darkTernary;
  Color get lightSurface => AppColors.lightSurface;
  Color get lightSecondary => AppColors.lightSecondary;
  Color get lightTernary => AppColors.lightTernary;
}
