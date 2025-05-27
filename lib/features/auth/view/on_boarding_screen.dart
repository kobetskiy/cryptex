import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/const/app_images.dart';
import 'package:cryptex/core/ui/widgets/primary_button.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  Future<void> _signUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnBoardingShown', true);
    if (mounted) {
      context.router.replaceAll([const SignUpRoute()]);
    }
  }

  Future<void> _logIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnBoardingShown', true);
    if (mounted) {
      context.router.replaceAll([const LogInRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).welcomeTo,
                style: TextStyle(fontSize: 62, fontWeight: FontWeight.bold),
              ),
              Image.asset(AppImages.splashLogo),
              SizedBox(height: 70),
              PrimaryButton(
                isExpanded: true,
                onPressed: _logIn,
                child: Text(S.of(context).logIn),
              ),
              PrimaryButton.outlined(
                isExpanded: true,
                onPressed: _signUp,
                child: Text(S.of(context).signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
