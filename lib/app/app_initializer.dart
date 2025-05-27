import 'package:cryptex/features/assets/repositories/repositories.dart';
import 'package:cryptex/features/assets/view/bloc/asset_actions_bloc.dart';
import 'package:cryptex/features/settings/repositories/repositories.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_event.dart';
import 'package:cryptex/features/settings/view/bloc/settings_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/repository/auth_repository.dart';
import '../features/auth/view/bloc/auth_bloc.dart';

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AssetActionsRepositoryInterface>(
          create: (context) => AssetActionsRepository(),
        ),
        RepositoryProvider<SettingsRepositoryInterface>(
          create: (context) => SettingsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => AssetActionsBloc(
                  repository: context.read<AssetActionsRepositoryInterface>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => SettingsBloc(
                  repository: context.read<SettingsRepositoryInterface>(),
                ),
          ),
          BlocProvider(
            create:
                (context) => LocalizationBloc(
                  repository: context.read<SettingsRepositoryInterface>(),
                )..add(const LoadLocalization()),
          ),
          BlocProvider(
            create:
                (context) => ThemeBloc(
                  repository: context.read<SettingsRepositoryInterface>(),
                )..add(LoadTheme()),
          ),
          BlocProvider(
            create: (_) => AuthBloc(authRepository: AuthRepository()),
          ),
        ],
        child: child,
      ),
    );
  }
}
