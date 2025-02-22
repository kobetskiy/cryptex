import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        MarketRoute(),
        AssetsRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) => Theme(
        data: ThemeData(splashColor: Colors.transparent),
        child: BottomNavigationBarWidget(
          tabIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
        ),
      ),
    );
  }
}