import 'package:flutter/material.dart';

class LocalizationState {
  final Locale locale;

  const LocalizationState(this.locale);

  factory LocalizationState.initial() => const LocalizationState(Locale('en'));

  LocalizationState copyWith({Locale? locale}) {
    return LocalizationState(locale ?? this.locale);
  }
}