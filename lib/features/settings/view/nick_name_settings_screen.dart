import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NickNameSettingsScreen extends StatefulWidget {
  const NickNameSettingsScreen({super.key});

  @override
  State<NickNameSettingsScreen> createState() => _NickNameSettingsScreenState();
}

class _NickNameSettingsScreenState extends State<NickNameSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: Text(S.of(context).changeNickname)),
    );
  }
}
