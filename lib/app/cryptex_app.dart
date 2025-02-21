import 'package:cryptex/core/localization/localization.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class CryptexApp extends StatefulWidget {
  const CryptexApp({super.key});

  @override
  State<CryptexApp> createState() => _CryptexAppState();
}

class _CryptexAppState extends State<CryptexApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cryptex',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalization.supportedLocales,
      localizationsDelegates: AppLocalization.localizationsDelegates,
      routerConfig: _router.config(),
    );
  }
}
