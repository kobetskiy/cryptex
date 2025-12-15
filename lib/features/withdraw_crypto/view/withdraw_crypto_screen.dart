import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/buy_crypto/models/crypto_coin.dart';
import 'package:cryptex/features/withdraw_crypto/repositories/repositories.dart';
import 'package:cryptex/features/withdraw_crypto/view/bloc/withdraw_crypto_bloc.dart';
import 'package:cryptex/features/withdraw_crypto/view/bloc/withdraw_crypto_event.dart';
import 'package:cryptex/features/withdraw_crypto/view/bloc/withdraw_crypto_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';

@RoutePage()
class WithdrawCryptoScreen extends StatelessWidget {
  const WithdrawCryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawCryptoBloc(
        repository: WithdrawCryptoRepository(),
      )..add(const LoadCryptoPrices()),
      child: const _WithdrawCryptoScreenContent(),
    );
  }
}

class _WithdrawCryptoScreenContent extends StatefulWidget {
  const _WithdrawCryptoScreenContent();

  @override
  State<_WithdrawCryptoScreenContent> createState() => _WithdrawCryptoScreenContentState();
}

class _WithdrawCryptoScreenContentState extends State<_WithdrawCryptoScreenContent> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
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
      final repository = WithdrawCryptoRepository();
      userId = await repository.getSavedUserId();
    }

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<WithdrawCryptoBloc>().add(LoadUserBalance(userId));
      context.read<WithdrawCryptoBloc>().add(LoadUserCryptoBalances(userId));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _showCoinSelector(BuildContext context, WithdrawCryptoState state) {
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
                'Select Cryptocurrency',
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
                          context.read<WithdrawCryptoBloc>().add(SelectCoin(coin));
                          Navigator.pop(modalContext);
                          _amountController.clear();
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
    return BlocConsumer<WithdrawCryptoBloc, WithdrawCryptoState>(
      listener: (context, state) {
        if (state.status == WithdrawCryptoStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Withdrawal successful!'),
              backgroundColor: Colors.green,
            ),
          );
          _amountController.clear();
          _addressController.clear();
        } else if (state.status == WithdrawCryptoStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == WithdrawCryptoStatus.loading;
        final coinPrice = state.cryptoPrices[state.selectedCoin.symbol] ?? 0.0;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Withdraw Crypto"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<WithdrawCryptoBloc>().add(const LoadCryptoPrices());
                  if (_userId != null) {
                    context.read<WithdrawCryptoBloc>().add(LoadUserCryptoBalances(_userId!));
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Індикатор завантаження
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

                // Попередження про недостатність коштів
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

                // Вибір криптовалюти
                ListTile(
                  title: const Text('Select Cryptocurrency'),
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

                // Сума виведення
                ListTile(
                  title: Text('Amount (${state.selectedCoin.symbol})'),
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
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')),
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
                                      _amountController.text = state.selectedCoinBalance.toStringAsFixed(8);
                                      context.read<WithdrawCryptoBloc>().add(UpdateAmount(state.selectedCoinBalance));
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0.0;
                            context.read<WithdrawCryptoBloc>().add(UpdateAmount(amount));
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(state.selectedCoin.symbol),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),

                // USD Value
                if (state.amount > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'USD Value: \$${state.usdValue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Divider(color: Theme.of(context).colorScheme.darkTernary),

                // Адреса зовнішнього гаманця
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'External Wallet Address',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _addressController,
                        enabled: !isLoading,
                        decoration: InputDecoration(
                          hintText: 'Enter destination wallet address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.account_balance_wallet),
                        ),
                        onChanged: (value) {
                          context.read<WithdrawCryptoBloc>().add(UpdateExternalAddress(value));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              isExpanded: true,
              onPressed: isLoading || !state.canWithdraw || _userId == null
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Confirm Withdrawal'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Amount: ${state.amount.toStringAsFixed(8)} ${state.selectedCoin.symbol}'),
                              const SizedBox(height: 8),
                              Text('USD Value: \$${state.usdValue.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              Text('To: ${state.externalAddress.length > 20 ? state.externalAddress.substring(0, 20) + "..." : state.externalAddress}'),
                              const SizedBox(height: 16),
                              const Text(
                                'This action cannot be undone.',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                context.read<WithdrawCryptoBloc>().add(
                                      SubmitWithdrawOrder(userId: _userId!),
                                    );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Withdraw'),
                            ),
                          ],
                        ),
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
                  : const Text("Withdraw"),
            ),
          ),
        );
      },
    );
  }
}