import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final prefs = await SharedPreferences.getInstance();
    final isOnBoardingShown = prefs.getBool('isOnBoardingShown');

    if (isOnBoardingShown ?? false) {
      resolver.next(true);
    } else {
      resolver.redirect(const OnBoardingRoute());
    }
  }
}
