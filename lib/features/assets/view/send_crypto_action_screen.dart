import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class SendCryptoActionScreen extends StatefulWidget {
  const SendCryptoActionScreen({super.key});

  @override
  State<SendCryptoActionScreen> createState() => _SendCryptoActionScreenState();
}

class _SendCryptoActionScreenState extends State<SendCryptoActionScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseScaffold(appBar: AppBar(title: Text(S.of(context).send)));
  }
}
