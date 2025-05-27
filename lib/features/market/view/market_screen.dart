import 'package:auto_route/auto_route.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(S.of(context).market),
      ),
    );
  }
}
