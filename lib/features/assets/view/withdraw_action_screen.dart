import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WithdrawActionScreen extends StatelessWidget {
  const WithdrawActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: Text(S.of(context).withdraw)),
      body: Container(),
    );
  }
}
