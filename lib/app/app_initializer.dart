import 'package:cryptex/features/assets/repositories/repositories.dart';
import 'package:cryptex/features/assets/view/bloc/asset_actions_bloc.dart';
import 'package:cryptex/features/settings/repositories/repositories.dart';
import 'package:cryptex/features/settings/view/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        ],
        child: child,
      ),
    );
  }
}
