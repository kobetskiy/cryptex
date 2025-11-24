import 'package:auto_route/auto_route.dart';
import 'package:cryptex/app/app_screen.dart';
import 'package:cryptex/core/router/guards/auth_guard.dart';
import 'package:cryptex/core/router/guards/on_boarding_guard.dart';
import 'package:cryptex/features/assets/view/view.dart';
import 'package:cryptex/features/auth/view/log_in_screen.dart';
import 'package:cryptex/features/auth/view/on_boarding_screen.dart';
import 'package:cryptex/features/auth/view/sign_up_screen.dart';
import 'package:cryptex/features/buy_crypto/view/buy_crypto.dart';
import 'package:cryptex/features/home/view/view.dart';
import 'package:cryptex/features/market/view/view.dart';
import 'package:cryptex/features/rewards/view/rewards_screen.dart';
import 'package:cryptex/features/settings/view/view.dart';
import 'package:cryptex/features/support/view/support_screen.dart';
import 'package:cryptex/features/sell_crypto/view/sell_crypto_screen.dart';
import 'package:cryptex/features/transfer_crypto/view/transfer_crypto.dart';
import 'package:cryptex/features/withdraw_funds/view/withdraw_funds_screen.dart';
import 'package:cryptex/features/limit_orders/view/limit_orders_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: AppRoute.page,
      path: '/',
      guards: [AuthGuard()],
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
    AutoRoute(
      page: NotificationsSettingsRoute.page,
      path: '/notifications_settings',
    ),
    AutoRoute(page: BuyCryptoRoute.page),
    AutoRoute(page: SupportRoute.page),
    AutoRoute(page: RewardsRoute.page),
    AutoRoute(page: LogInRoute.page, guards: [OnBoardingGuard()]),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: OnBoardingRoute.page),
    AutoRoute(page: SellCryptoRoute.page),
    AutoRoute(page: ConvertCryptoRoute.page),
    AutoRoute(page: WithdrawFundsRoute.page),
    AutoRoute(page: LimitOrdersRoute.page),
  ];
}
