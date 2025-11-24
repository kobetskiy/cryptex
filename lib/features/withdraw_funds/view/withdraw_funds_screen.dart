import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/withdraw_funds/repositories/repositories.dart';
import 'package:cryptex/features/withdraw_funds/view/bloc/withdraw_funds_bloc.dart';
import 'package:cryptex/features/withdraw_funds/view/bloc/withdraw_funds_event.dart';
import 'package:cryptex/features/withdraw_funds/view/bloc/withdraw_funds_state.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';

@RoutePage()
class WithdrawFundsScreen extends StatelessWidget {
  const WithdrawFundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WithdrawFundsBloc(
        repository: WithdrawFundsRepository(),
      ),
      child: const _WithdrawFundsScreenContent(),
    );
  }
}

class _WithdrawFundsScreenContent extends StatefulWidget {
  const _WithdrawFundsScreenContent();

  @override
  State<_WithdrawFundsScreenContent> createState() => _WithdrawFundsScreenContentState();
}

class _WithdrawFundsScreenContentState extends State<_WithdrawFundsScreenContent> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletAddressController = TextEditingController();
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
      final repository = WithdrawFundsRepository();
      userId = await repository.getSavedUserId();
    }

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<WithdrawFundsBloc>().add(LoadUserBalance(userId));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _walletAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WithdrawFundsBloc, WithdrawFundsState>(
      listener: (context, state) {
        if (state.status == WithdrawFundsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Withdrawal successful!'),
              backgroundColor: Colors.green,
            ),
          );
          _amountController.clear();
          _walletAddressController.clear();
          
          // Баланс вже оновлений в BLoC - не треба додатково викликати LoadUserBalance!
          // Це створювало безкінечний цикл
          
        } else if (state.status == WithdrawFundsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == WithdrawFundsStatus.loading;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Withdraw Funds"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (_userId != null) {
                    context.read<WithdrawFundsBloc>().add(LoadUserBalance(_userId!));
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
                            'Available Balance:',
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

                    const SizedBox(height: 24),
                    if (state.amount > 0 && !state.hasEnoughBalance)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
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
                                'Insufficient balance! You only have \$${state.userBalance.toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Text(
                      'Withdrawal Address',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _walletAddressController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Enter your wallet address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Amount (USD)',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      enabled: !isLoading,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      decoration: InputDecoration(
                        hintText: '0.00',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.attach_money),
                        suffixIcon: state.userBalance > 0
                            ? IconButton(
                                icon: const Text(
                                  'MAX',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                onPressed: () {
                                  _amountController.text = state.userBalance.toStringAsFixed(2);
                                  context.read<WithdrawFundsBloc>().add(UpdateAmount(state.userBalance));
                                },
                              )
                            : null,
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        context.read<WithdrawFundsBloc>().add(UpdateAmount(amount));
                      },
                    ),

                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Important Information:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '• Minimum withdrawal: \$10.00\n'
                                  '• Processing time: 1-3 business days\n'
                                  '• Make sure your wallet address is correct',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    PrimaryButton(
                      isExpanded: true,
                      onPressed: isLoading || 
                                state.amount <= 0 || 
                                !state.hasEnoughBalance ||
                                _walletAddressController.text.isEmpty ||
                                _userId == null
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Confirm Withdrawal'),
                                  content: Text(
                                    'Are you sure you want to withdraw \$${state.amount.toStringAsFixed(2)} to:\n\n${_walletAddressController.text}',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        context.read<WithdrawFundsBloc>().add(
                                              SubmitWithdrawOrder(userId: _userId!),
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
                          : const Text("Withdraw"),
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