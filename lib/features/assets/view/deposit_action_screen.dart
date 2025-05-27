import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class DepositActionScreen extends StatefulWidget {
  const DepositActionScreen({super.key});

  @override
  State<DepositActionScreen> createState() => _DepositActionScreenState();
}

class _DepositActionScreenState extends State<DepositActionScreen> {
  String selectedCoin = 'Bitcoin';
  String selectedNetwork = 'Bitcoin';

  final String walletAddress = '0xa9198374701d9008f3fhh8291jdj28921ea';

  final Map<String, String> coinToNetwork = {
    'Bitcoin': 'Bitcoin',
    'Ethereum': 'Ethereum (ERC20)',
    'Tether': 'Tether (TRC20)',
  };

  void _showCoinSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return ListView(
          children:
              coinToNetwork.keys.map((coin) {
                return ListTile(
                  title: Text(coin),
                  trailing:
                      coin == selectedCoin
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                  onTap: () {
                    setState(() {
                      selectedCoin = coin;
                      selectedNetwork = coinToNetwork[coin]!;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
        );
      },
    );
  }

  void _copyAddressToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: walletAddress));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:  Text(S.of(context).addressCopiedToClipboard),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseScaffold(
      appBar: AppBar(title: Text(S.of(context).deposit)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            S.of(context).someRulesAndConfidentialityLawsSomeRulesAndConfidentialityLaws,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 24),

          // Coin Selector
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              S.of(context).coin,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedCoin,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: () => _showCoinSelector(context),
          ),
          const Divider(height: 0, thickness: 1),
          const SizedBox(height: 15),

          // Network
          Text(
            S.of(context).network,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            selectedNetwork,
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
          const Divider(height: 32, thickness: 1),

          // Address
          Text(
            S.of(context).address,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  walletAddress,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: () => _copyAddressToClipboard(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
