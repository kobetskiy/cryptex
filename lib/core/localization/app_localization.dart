import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

abstract class AppLocalization {
  static Iterable<LocalizationsDelegate> localizationsDelegates = const [
    S.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];
  static Iterable<Locale> supportedLocales = S.delegate.supportedLocales;
}
