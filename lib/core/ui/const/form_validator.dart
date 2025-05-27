import 'package:flutter/material.dart';

abstract class FormValidator {
  static String? validateUserName(BuildContext context, String? value) {
    final nameRegExp = RegExp(
      r'^[A-Za-zА-Яа-яЁёЄІЇҐєіїґ][a-zа-яёєіїґ]*(?:\s[A-ZА-ЯЁЄІЇҐ][a-zа-яёєіїґ]+)*$',
    );
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a name';
    }
    if (!nameRegExp.hasMatch(value.trim())) {
      return 'Enter a valid name';
    }
    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a password';
    }
    if (value.trim().length < 4) {
      return 'Password must be at least 4 characters long';
    }
    return null;
  }

  static String? validateEmail(BuildContext context, String? value) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }
}
