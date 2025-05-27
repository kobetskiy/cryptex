import 'package:cryptex/app/app.dart';
import 'package:cryptex/core/localization/localization.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_state.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptexApp extends StatefulWidget {
  const CryptexApp({super.key});

  @override
  State<CryptexApp> createState() => _CryptexAppState();
}

class _CryptexAppState extends State<CryptexApp> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return AppInitializer(
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocalizationBloc, LocalizationState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                title: 'Cryptex',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeState.themeMode,
                debugShowCheckedModeBanner: false,
                locale: localeState.locale,
                supportedLocales: AppLocalization.supportedLocales,
                localizationsDelegates: AppLocalization.localizationsDelegates,
                routerConfig: _router.config(),
              );
            },
          );
        },
      ),
    );
  }
}
