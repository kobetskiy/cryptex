import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/buy_crypto/models/crypto_coin.dart';
import 'package:cryptex/features/transfer_crypto/repositories/tr_repository.dart';
import 'package:cryptex/features/transfer_crypto/view/bloc/transfer_crypto_bloc.dart';
import 'package:cryptex/features/transfer_crypto/view/bloc/transfer_crypto_event.dart';
import 'package:cryptex/features/transfer_crypto/view/bloc/transfer_crypto_state.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';

@RoutePage()
class ConvertCryptoScreen extends StatelessWidget {
  const ConvertCryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransferCryptoBloc(
        repository: TransferCryptoRepository(),
      )..add(const LoadCryptoPrices()),
      child: const _TransferCryptoScreenContent(),
    );
  }
}

class _TransferCryptoScreenContent extends StatefulWidget {
  const _TransferCryptoScreenContent();

  @override
  State<_TransferCryptoScreenContent> createState() => _TransferCryptoScreenContentState();
}

class _TransferCryptoScreenContentState extends State<_TransferCryptoScreenContent> {
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
      final repository = TransferCryptoRepository();
      userId = await repository.getSavedUserId();
    }

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<TransferCryptoBloc>().add(LoadUserBalance(userId));
      context.read<TransferCryptoBloc>().add(LoadUserCryptoBalances(userId));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showFromCoinSelector(BuildContext context, TransferCryptoState state) {
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
                'Select Coin to Convert From',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...CryptoCoin.values.map((coin) {
                final price = state.cryptoPrices[coin.symbol] ?? 0.0;
                final balance = state.cryptoBalances[coin.id] ?? 0.0;
                final isSelected = state.fromCoin == coin;
                
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
                          context.read<TransferCryptoBloc>().add(SelectFromCoin(coin));
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

  void _showToCoinSelector(BuildContext context, TransferCryptoState state) {
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
                'Select Coin to Convert To',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...CryptoCoin.values.map((coin) {
                final price = state.cryptoPrices[coin.symbol] ?? 0.0;
                final balance = state.cryptoBalances[coin.id] ?? 0.0;
                final isSelected = state.toCoin == coin;
                final isSameAsFrom = state.fromCoin == coin;
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected 
                        ? Colors.blue 
                        : isSameAsFrom 
                            ? Colors.red.withOpacity(0.3)
                            : Colors.grey,
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
                  enabled: !isSameAsFrom,
                  onTap: !isSameAsFrom
                      ? () {
                          context.read<TransferCryptoBloc>().add(SelectToCoin(coin));
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
    return BlocConsumer<TransferCryptoBloc, TransferCryptoState>(
      listener: (context, state) {
        if (state.status == TransferCryptoStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Conversion successful!'),
              backgroundColor: Colors.green,
            ),
          );
          _amountController.clear();
          context.read<TransferCryptoBloc>().add(UpdateAmount(0));
        } else if (state.status == TransferCryptoStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == TransferCryptoStatus.loading;
        final fromPrice = state.cryptoPrices[state.fromCoin.symbol] ?? 0.0;
        final toPrice = state.cryptoPrices[state.toCoin.symbol] ?? 0.0;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Convert crypto"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<TransferCryptoBloc>().add(const LoadCryptoPrices());
                  if (_userId != null) {
                    context.read<TransferCryptoBloc>().add(LoadUserCryptoBalances(_userId!));
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
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
                            'Insufficient ${state.fromCoin.symbol}! You have ${state.fromCoinBalance.toStringAsFixed(6)}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!state.coinsAreDifferent)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info, color: Colors.orange),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Please select different coins to convert',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ListTile(
                  title: const Text('From'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(state.fromCoin.name),
                          Text(
                            'Balance: ${state.fromCoinBalance.toStringAsFixed(6)}',
                            style: TextStyle(
                              color: state.fromCoinBalance > 0 ? Colors.green : Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  onTap: isLoading ? null : () => _showFromCoinSelector(context, state),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
                ListTile(
                  title: Text('${S.of(context).amount} (${state.fromCoin.symbol})'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 120,
                        child: TextField(
                          controller: _amountController,
                          enabled: !isLoading && state.fromCoinBalance > 0,
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
                            suffixIcon: state.fromCoinBalance > 0
                                ? IconButton(
                                    icon: const Icon(Icons.all_inclusive, size: 16),
                                    onPressed: () {
                                      _amountController.text = state.fromCoinBalance.toStringAsFixed(6);
                                      context.read<TransferCryptoBloc>().add(UpdateAmount(state.fromCoinBalance));
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0.0;
                            context.read<TransferCryptoBloc>().add(UpdateAmount(amount));
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(state.fromCoin.symbol),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Icon(
                    Icons.swap_vert,
                    size: 32,
                    color: Colors.blue,
                  ),
                ),

                Divider(color: Theme.of(context).colorScheme.darkTernary),
                ListTile(
                  title: const Text('To'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(state.toCoin.name),
                          Text(
                            'Balance: ${state.toCoinBalance.toStringAsFixed(6)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  onTap: isLoading ? null : () => _showToCoinSelector(context, state),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
                ListTile(
                  title: const Text('You will receive'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.convertedAmount.toStringAsFixed(6),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: state.convertedAmount > 0 ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(state.toCoin.symbol),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
                if (state.amount > 0)
                  Padding(
                    padding: const EdgeInsets.all(16),
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
                        !state.coinsAreDifferent ||
                        _userId == null
                  ? null
                  : () {
                      context.read<TransferCryptoBloc>().add(
                            SubmitTransferOrder(userId: _userId!),
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
                  : Text("Convert"),
            ),
          ),
        );
      },
    );
  }
}