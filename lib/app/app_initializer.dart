import 'package:cryptex/features/assets/repositories/repositories.dart';
import 'package:cryptex/features/assets/view/bloc/asset_actions_bloc.dart';
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => AssetActionsBloc(
                  repository: context.read<AssetActionsRepositoryInterface>(),
                ),
          ),
        ],
        child: child,
      ),
    );
  }
}
