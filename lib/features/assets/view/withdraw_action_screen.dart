import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class WithdrawActionScreen extends StatefulWidget {
  const WithdrawActionScreen({super.key});

  @override
  State<WithdrawActionScreen> createState() => _WithdrawActionScreenState();
}

class _WithdrawActionScreenState extends State<WithdrawActionScreen> {
  String selectedCoin = 'Bitcoin';
  String selectedNetwork = 'Bitcoin';

  final Map<String, String> coinToNetwork = {
    'Bitcoin': 'Bitcoin',
    'Ethereum': 'Ethereum (ERC20)',
    'Tether': 'Tether (TRC20)',
  };

  final TextEditingController addressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

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

  void _sendCrypto() {
    final address = addressController.text.trim();
    final amount = amountController.text.trim();

    if (address.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pleaseFillInAllFields),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
      );
      return;
    }

    // TODO: Send logic here

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sent $amount $selectedCoin to $address'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BaseScaffold(
      appBar: AppBar(title: Text(S.of(context).withdraw)),
      body: ListView(
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
          const SizedBox(height: 24),

          // Address Input
          Text(
            S.of(context).receiveAddress,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: addressController,
            decoration: InputDecoration(
              hintText: S.of(context).enterAddress,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            S.of(context).withdrawAmount,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: S.of(context).enterAmount,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(height: 32),

          PrimaryButton(onPressed: _sendCrypto, child: Text(S.of(context).send)),
        ],
      ),
    );
  }
}
