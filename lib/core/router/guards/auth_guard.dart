import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final isLoggedIn = token != null && token.isNotEmpty;

    if (isLoggedIn) {
      resolver.next(true);
    } else {
      resolver.redirect(const LogInRoute());
    }
  }
}