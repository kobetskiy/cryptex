// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My Assets`
  String get myAssets {
    return Intl.message(
      'My Assets',
      name: 'myAssets',
      desc: '',
      args: [],
    );
  }

  /// `Total Assets`
  String get totalAssets {
    return Intl.message(
      'Total Assets',
      name: 'totalAssets',
      desc: '',
      args: [],
    );
  }

  /// `Deposit`
  String get deposit {
    return Intl.message(
      'Deposit',
      name: 'deposit',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message(
      'Withdraw',
      name: 'withdraw',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Send Crypto`
  String get sendCrypto {
    return Intl.message(
      'Send Crypto',
      name: 'sendCrypto',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Account Info`
  String get accountInfo {
    return Intl.message(
      'Account Info',
      name: 'accountInfo',
      desc: '',
      args: [],
    );
  }

  /// `Nickname`
  String get nickname {
    return Intl.message(
      'Nickname',
      name: 'nickname',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get id {
    return Intl.message(
      'ID',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message(
      'Security',
      name: 'security',
      desc: '',
      args: [],
    );
  }

  /// `App Lock`
  String get appLock {
    return Intl.message(
      'App Lock',
      name: 'appLock',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Color Theme`
  String get colorTheme {
    return Intl.message(
      'Color Theme',
      name: 'colorTheme',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Change Nickname`
  String get changeNickname {
    return Intl.message(
      'Change Nickname',
      name: 'changeNickname',
      desc: '',
      args: [],
    );
  }

  /// `New nickname`
  String get newNickname {
    return Intl.message(
      'New nickname',
      name: 'newNickname',
      desc: '',
      args: [],
    );
  }

  /// `Notification Settings`
  String get notificationSettings {
    return Intl.message(
      'Notification Settings',
      name: 'notificationSettings',
      desc: '',
      args: [],
    );
  }

  /// `Security Settings`
  String get securitySettings {
    return Intl.message(
      'Security Settings',
      name: 'securitySettings',
      desc: '',
      args: [],
    );
  }

  /// `ID copied successfully`
  String get idCopiedSuccessfully {
    return Intl.message(
      'ID copied successfully',
      name: 'idCopiedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error copying ID`
  String get errorCopyingId {
    return Intl.message(
      'Error copying ID',
      name: 'errorCopyingId',
      desc: '',
      args: [],
    );
  }

  /// `Buy Crypto`
  String get buyCrypto {
    return Intl.message(
      'Buy Crypto',
      name: 'buyCrypto',
      desc: '',
      args: [],
    );
  }

  /// `Coin`
  String get coin {
    return Intl.message(
      'Coin',
      name: 'coin',
      desc: '',
      args: [],
    );
  }

  /// `Cost`
  String get cost {
    return Intl.message(
      'Cost',
      name: 'cost',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Here you can explain your problem. After sending, new ticket will be created. We will write you a solution as soon as posible. So check the notifications and ticket status.`
  String get hereYouCanExplainYourProblemAfterSendingNewTicket {
    return Intl.message(
      'Here you can explain your problem. After sending, new ticket will be created. We will write you a solution as soon as posible. So check the notifications and ticket status.',
      name: 'hereYouCanExplainYourProblemAfterSendingNewTicket',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to send this ticket`
  String get areYouSureYouWantToSendThisTicket {
    return Intl.message(
      'Are you sure you want to send this ticket',
      name: 'areYouSureYouWantToSendThisTicket',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `My Achievements`
  String get myAchievements {
    return Intl.message(
      'My Achievements',
      name: 'myAchievements',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get welcomeTo {
    return Intl.message(
      'Welcome to',
      name: 'welcomeTo',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? Log In!`
  String get alreadyHaveAnAccountLogIn {
    return Intl.message(
      'Already have an account? Log In!',
      name: 'alreadyHaveAnAccountLogIn',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account yet? Sign Up`
  String get dontHaveAnAccountYetSignUp {
    return Intl.message(
      'Don\'t have an account yet? Sign Up',
      name: 'dontHaveAnAccountYetSignUp',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Address copied to clipboard`
  String get addressCopiedToClipboard {
    return Intl.message(
      'Address copied to clipboard',
      name: 'addressCopiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `Some rules and confidentiality laws... Some rules and confidentiality laws... Some rules and confidentiality laws... Some rules and confidentiality laws...`
  String get someRulesAndConfidentialityLawsSomeRulesAndConfidentialityLaws {
    return Intl.message(
      'Some rules and confidentiality laws... Some rules and confidentiality laws... Some rules and confidentiality laws... Some rules and confidentiality laws...',
      name: 'someRulesAndConfidentialityLawsSomeRulesAndConfidentialityLaws',
      desc: '',
      args: [],
    );
  }

  /// `Network`
  String get network {
    return Intl.message(
      'Network',
      name: 'network',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get pleaseFillInAllFields {
    return Intl.message(
      'Please fill in all fields',
      name: 'pleaseFillInAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Receive Address`
  String get receiveAddress {
    return Intl.message(
      'Receive Address',
      name: 'receiveAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter address`
  String get enterAddress {
    return Intl.message(
      'Enter address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Amount`
  String get withdrawAmount {
    return Intl.message(
      'Withdraw Amount',
      name: 'withdrawAmount',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount`
  String get enterAmount {
    return Intl.message(
      'Enter amount',
      name: 'enterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Or continue with`
  String get orContinueWith {
    return Intl.message(
      'Or continue with',
      name: 'orContinueWith',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Pay Using`
  String get payUsing {
    return Intl.message(
      'Pay Using',
      name: 'payUsing',
      desc: '',
      args: [],
    );
  }

  /// `Select payment method`
  String get selectPaymentMethod {
    return Intl.message(
      'Select payment method',
      name: 'selectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Rewards`
  String get rewards {
    return Intl.message(
      'Rewards',
      name: 'rewards',
      desc: '',
      args: [],
    );
  }

  /// `Total Balance`
  String get totalBalance {
    return Intl.message(
      'Total Balance',
      name: 'totalBalance',
      desc: '',
      args: [],
    );
  }

  /// `Market`
  String get market {
    return Intl.message(
      'Market',
      name: 'market',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `News`
  String get news {
    return Intl.message(
      'News',
      name: 'news',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Phone/Email`
  String get phoneemail {
    return Intl.message(
      'Phone/Email',
      name: 'phoneemail',
      desc: '',
      args: [],
    );
  }

  /// `Ticket sent successfully`
  String get ticketSentSuccessfully {
    return Intl.message(
      'Ticket sent successfully',
      name: 'ticketSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Enter your problem`
  String get enterYourProblem {
    return Intl.message(
      'Enter your problem',
      name: 'enterYourProblem',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'uk'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
