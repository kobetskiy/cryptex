import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/buy_crypto/models/crypto_coin.dart';
import 'package:cryptex/features/buy_crypto/repositories/buy_crypto_repository.dart';
import 'package:cryptex/features/buy_crypto/view/bloc/buy_crypto_bloc.dart';
import 'package:cryptex/features/buy_crypto/view/bloc/buy_crypto_event.dart';
import 'package:cryptex/features/buy_crypto/view/bloc/buy_crypto_state.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';

@RoutePage()
class BuyCryptoScreen extends StatelessWidget {
  const BuyCryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyCryptoBloc(
        repository: BuyCryptoRepository(),
      )..add(const LoadCryptoPrices()),
      child: const _BuyCryptoScreenContent(),
    );
  }
}

class _BuyCryptoScreenContent extends StatefulWidget {
  const _BuyCryptoScreenContent();

  @override
  State<_BuyCryptoScreenContent> createState() => _BuyCryptoScreenContentState();
}

class _BuyCryptoScreenContentState extends State<_BuyCryptoScreenContent> {
  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Apple Pay'];
  String? _selectedPaymentMethod;
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
      final repository = BuyCryptoRepository();
      userId = await repository.getSavedUserId();
    }

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<BuyCryptoBloc>().add(LoadUserBalance(userId));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showCoinSelector(BuildContext context, BuyCryptoState state) {
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
                'Select Coin',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...CryptoCoin.values.map((coin) {
                final price = state.cryptoPrices[coin.symbol] ?? 0.0;
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
                  subtitle: Text(coin.symbol),
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
                  onTap: () {
                    context.read<BuyCryptoBloc>().add(SelectCoin(coin));
                    Navigator.pop(modalContext);
                  },
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
    return BlocConsumer<BuyCryptoBloc, BuyCryptoState>(
      listener: (context, state) {
        if (state.status == BuyCryptoStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Purchase successful!'),
              backgroundColor: Colors.green,
            ),
          );
          _amountController.clear();
          setState(() {
            _selectedPaymentMethod = null;
          });
          context.read<BuyCryptoBloc>().add(UpdateAmount(0));
          if (_userId != null) {
            context.read<BuyCryptoBloc>().add(LoadUserBalance(_userId!));
          }
        } else if (state.status == BuyCryptoStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == BuyCryptoStatus.loading;
        final currentPrice = state.cryptoPrices[state.selectedCoin.symbol] ?? 0.0;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(S.of(context).buyCrypto),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<BuyCryptoBloc>().add(const LoadCryptoPrices());
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
                        'Your Balance:',
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
                if (state.amount > 0 && !state.hasEnoughBalance)
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
                            'Insufficient balance! Need \$${state.amount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red),
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
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Prices not loaded. Tap refresh button.'),
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
                          if (currentPrice > 0)
                            Text(
                              '\$${currentPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            )
                          else
                            const Text(
                              'Price: N/A',
                              style: TextStyle(
                                color: Colors.red,
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
                  title: Text(S.of(context).amount),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: _amountController,
                          enabled: !isLoading,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
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
                          ),
                          onChanged: (value) {
                            final amount = double.tryParse(value) ?? 0.0;
                            context.read<BuyCryptoBloc>().add(UpdateAmount(amount));
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text('USD'),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),

                ListTile(
                  title: Text(S.of(context).cost),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.cost.toStringAsFixed(6),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: state.cost > 0 ? Colors.green : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(state.selectedCoin.symbol),
                    ],
                  ),
                ),
                Divider(color: Theme.of(context).colorScheme.darkTernary),
                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S.of(context).payUsing,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        hint: Text(S.of(context).selectPaymentMethod),
                        items: _paymentMethods
                            .map(
                              (method) => DropdownMenuItem<String>(
                                value: method,
                                child: Text(method),
                              ),
                            )
                            .toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedPaymentMethod = value;
                                });
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
              onPressed: isLoading || 
              state.amount <= 0 || 
              _selectedPaymentMethod == null ||
              !state.hasEnoughBalance ||
              _userId == null
              ? null
              : () {
                  context.read<BuyCryptoBloc>().add(
                    SubmitBuyOrder(
                      userId: _userId!,
                      paymentMethod: _selectedPaymentMethod!,
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
                  : Text(S.of(context).buy),
                ),
          ),
        );
      },
    );
  }
}