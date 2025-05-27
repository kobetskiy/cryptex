import 'package:flutter/material.dart';

abstract class LocalizationEvent {
  const LocalizationEvent();
}

class ChangeLocale extends LocalizationEvent {
  final Locale locale;
  const ChangeLocale(this.locale);
}

class LoadLocalization extends LocalizationEvent {
  const LoadLocalization();
}