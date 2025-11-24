import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/buy_crypto/models/crypto_coin.dart';
import 'package:cryptex/features/sell_crypto/repositories/repository.dart';
import 'package:cryptex/features/sell_crypto/view/bloc/sell_crypto_bloc.dart';
import 'package:cryptex/features/sell_crypto/view/bloc/sell_crypto_event.dart';
import 'package:cryptex/features/sell_crypto/view/bloc/sell_crypto_state.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';

@RoutePage()
class SellCryptoPage  extends StatelessWidget {
  const SellCryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SellCryptoBloc(
        repository: SellCryptoRepository(),
      )..add(const LoadCryptoPrices()),
      child: const _SellCryptoScreenContent(),
    );
  }
}

class _SellCryptoScreenContent extends StatefulWidget {
  const _SellCryptoScreenContent();

  @override
  State<_SellCryptoScreenContent> createState() => _SellCryptoScreenContentState();
}

class _SellCryptoScreenContentState extends State<_SellCryptoScreenContent> {
  final TextEditingController _amountController = TextEditingController();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final authState = context.read<AuthBloc>().state;
    int? userId;
    
    if (authState is AuthSuccess) {
      userId = authState.userId;
    } else {
      final repository = SellCryptoRepository();
      userId = await repository.getSavedUserId();
    }

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<SellCryptoBloc>().add(LoadUserBalance(userId));
      context.read<SellCryptoBloc>().add(LoadUserCryptoBalances(userId));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showCoinSelector(BuildContext context, SellCryptoState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (modalContext) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Coin to Sell',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...CryptoCoin.values.map((coin) {
                final price = state.cryptoPrices[coin.symbol] ?? 0.0;
                final balance = state.cryptoBalances[coin.id] ?? 0.0;
                final isSelected = state.selectedCoin == coin;
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected ? Colors.blue : Colors.grey,
                    child: Text(
                      coin.symbol.substring(0, 1),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(coin.name),
                  subtitle: Text('${coin.symbol} • Balance: ${balance.toStringAsFixed(6)}'),
                  trailing: price > 0
                      ? Text(
                          '\$${price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      : const Text(
                          'Loading...',
                          style: TextStyle(color: Colors.grey),
                        ),
                  selected: isSelected,
                  enabled: balance > 0,
                  onTap: balance > 0
                      ? () {
                          context.read<SellCryptoBloc>().add(SelectCoin(coin));
                          Navigator.pop(modalContext);
                        }
                      : null,
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SellCryptoBloc, SellCryptoState>(
      listener: (context, state) {
        if (state.status == SellCryptoStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sale successful!'),
              backgroundColor: Colors.green,
            ),
          );
          _amountController.clear();
          context.read<SellCryptoBloc>().add(UpdateAmount(0));
        } else if (state.status == SellCryptoStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SellCryptoStatus.loading;
        final currentPrice = state.cryptoPrices[state.selectedCoin.symbol] ?? 0.0;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Sell crypto"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<SellCryptoBloc>().add(const LoadCryptoPrices());
                  if (_userId != null) {
                    context.read<SellCryptoBloc>().add(LoadUserCryptoBalances(_userId!));
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'USD Balance:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '\$${state.userBalance.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ),

                if (isLoading)
                  const LinearProgressIndicator()
                else if (state.cryptoPrices.isEmpty)
                  Container(
                    color: Colors.orange.withOpacity(0.2),
                    padding: const EdgeInsets.all(8),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('Prices not loaded. Tap refresh button.'),
                        ),
                      ],
                    ),
                  ),
                if (state.amount > 0 && !state.hasEnoughCrypto)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Insufficient ${state.selectedCoin.symbol}! You have ${state.selectedCoinBalance.toStringAsFixed(6)}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  title: Text(S.of(context).coin),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(state.selectedCoin.name),
                          Text(
                            'Balance: ${state.selectedCoinBalance.toStringAsFixed(6)}',
                            style: TextStyle(
                              color: state.selectedCoinBalance > 0 ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  onTap: isLoading ? null : () => _showCoinSelector(context, state),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
                ListTile(
                  title: Text('${S.of(context).amount} (${state.selectedCoin.symbol})'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: _amountController,
                          enabled: !isLoading && state.selectedCoinBalance > 0,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,6}')),
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isCollapsed: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            suffixIcon: state.selectedCoinBalance > 0
                                ? IconButton(
                                    icon: const Icon(Icons.all_inclusive, size: 16),
                                    onPressed: () {
                                      _amountController.text = state.selectedCoinBalance.toStringAsFixed(6);
                                      context.read<SellCryptoBloc>().add(UpdateAmount(state.selectedCoinBalance));
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0.0;
                            context.read<SellCryptoBloc>().add(UpdateAmount(amount));
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(state.selectedCoin.symbol),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
                ListTile(
                  title: const Text('You will receive'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${state.usdValue.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: state.usdValue > 0 ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('USD'),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              isExpanded: true,
              onPressed: isLoading || 
                        state.amount <= 0 || 
                        !state.hasEnoughCrypto ||
                        _userId == null
                  ? null
                  : () {
                      context.read<SellCryptoBloc>().add(
                            SubmitSellOrder(userId: _userId!),
                          );
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text("Sell"),
            ),
          ),
        );
      },
    );
  }
}