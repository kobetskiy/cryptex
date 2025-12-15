import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/deposit_crypto/repositories/repositories.dart';
import 'package:cryptex/features/deposit_crypto/view/bloc/deposit_crypto_bloc.dart';
import 'package:cryptex/features/deposit_crypto/view/bloc/deposit_crypto_event.dart';
import 'package:cryptex/features/deposit_crypto/view/bloc/deposit_crypto_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';

@RoutePage()
class DepositCryptoScreen extends StatelessWidget {
  const DepositCryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DepositCryptoBloc(
        repository: DepositCryptoRepository(),
      ),
      child: const _DepositCryptoScreenContent(),
    );
  }
}

class _DepositCryptoScreenContent extends StatefulWidget {
  const _DepositCryptoScreenContent();

  @override
  State<_DepositCryptoScreenContent> createState() => _DepositCryptoScreenContentState();
}

class _DepositCryptoScreenContentState extends State<_DepositCryptoScreenContent> {
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
      final repository = DepositCryptoRepository();
      userId = await repository.getSavedUserId();
    }

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<DepositCryptoBloc>().add(LoadUserCryptoBalance(userId));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepositCryptoBloc, DepositCryptoState>(
      listener: (context, state) {
        if (state.status == DepositCryptoStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Crypto deposit successful!'),
              backgroundColor: Colors.green,
            ),
          );
          _amountController.clear();
          _addressController.clear();
        } else if (state.status == DepositCryptoStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == DepositCryptoStatus.loading;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Deposit Crypto"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (_userId != null) {
                    context.read<DepositCryptoBloc>().add(LoadUserCryptoBalance(_userId!));
                  }
                },
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Поточний баланс
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Balance:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${state.userCryptoBalance.toStringAsFixed(8)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Сума поповнення
                    Text(
                      'Deposit Amount',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      enabled: !isLoading,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,8}')),
                      ],
                      decoration: InputDecoration(
                        hintText: '0.00000000',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.currency_bitcoin),
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        context.read<DepositCryptoBloc>().add(UpdateAmount(amount));
                      },
                    ),

                    const SizedBox(height: 24),

                    // Адреса для депозиту
                    Text(
                      'Deposit Address',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Enter wallet address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                      ),
                      onChanged: (value) {
                        context.read<DepositCryptoBloc>().add(UpdateDepositAddress(value));
                      },
                    ),

                    const SizedBox(height: 24),

                    // Інформаційний блок
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Deposit Information:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '• Verify wallet address carefully\n'
                                  '• Network confirmations required\n'
                                  '• Processing time: 10-30 minutes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Кнопка Deposit
                    PrimaryButton(
                      isExpanded: true,
                      onPressed: isLoading || 
                                state.amount <= 0 || 
                                state.depositAddress.isEmpty ||
                                _userId == null
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Confirm Crypto Deposit'),
                                  content: Text(
                                    'Deposit ${state.amount.toStringAsFixed(8)}\n'
                                    'To address: ${state.depositAddress}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        context.read<DepositCryptoBloc>().add(
                                              SubmitDepositCrypto(userId: _userId!),
                                            );
                                      },
                                      child: const Text('Confirm'),
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
                          : const Text("Deposit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}