import 'package:auto_route/auto_route.dart';
import 'package:cryptex/app/app_screen.dart';
import 'package:cryptex/features/home/view/view.dart';
import 'package:cryptex/features/market/view/view.dart';
import 'package:cryptex/features/assets/view/assets_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AppRoute.page,
      path: '/',
      children: [
        AutoRoute(page: HomeRoute.page, path: 'home'),
        AutoRoute(page: MarketRoute.page, path: 'market'),
        AutoRoute(page: AssetsRoute.page, path: 'assets'),
      ],
    ),
  ];
}
