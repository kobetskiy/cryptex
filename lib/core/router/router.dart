import 'package:auto_route/auto_route.dart';
import 'package:cryptex/app/app_screen.dart';
import 'package:cryptex/features/assets/view/assets_screen.dart';
import 'package:cryptex/features/assets/view/view.dart';
import 'package:cryptex/features/home/view/view.dart';
import 'package:cryptex/features/market/view/view.dart';
import 'package:cryptex/features/settings/view/nick_name_settings_screen.dart';
import 'package:cryptex/features/settings/view/view.dart';

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
    AutoRoute(page: DepositActionRoute.page, path: '/deposit_action'),
    AutoRoute(page: WithdrawActionRoute.page, path: '/withdraw_action'),
    AutoRoute(page: SendCryptoActionRoute.page, path: '/send_crypto_action'),
    AutoRoute(page: SettingsRoute.page, path: '/settings'),
    AutoRoute(page: NickNameSettingsRoute.page, path: '/nick_name_settings'),
    AutoRoute(page: SecuritySettingsRoute.page, path: '/security_settings'),
    AutoRoute(page: NotificationsSettingsRoute.page, path: '/notifications_settings'),
  ];
}
