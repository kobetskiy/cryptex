import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CryptoTile extends StatelessWidget {
  const CryptoTile({super.key, required this.isAssetsShown});

  final bool isAssetsShown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseCard(
      child: ListTile(
        title: const Text("BTC"),
        subtitle: const Text("Bitcoin"),
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Bitcoin.svg/300px-Bitcoin.svg.png',
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            Text(isAssetsShown ? '0.89241' : "******"),
            Text(
              isAssetsShown ? '84.778,95 USD' : "******",
              style: TextStyle(fontSize: 14, color: theme.colorScheme.grey),
            ),
          ],
        ),
      ),
    );
  }
}
