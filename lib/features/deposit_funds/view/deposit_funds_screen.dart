import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/deposit_funds/repositories/repositories.dart';
import 'package:cryptex/features/deposit_funds/view/bloc/deposit_funds_bloc.dart';
import 'package:cryptex/features/deposit_funds/view/bloc/deposit_funds_event.dart';
import 'package:cryptex/features/deposit_funds/view/bloc/deposit_funds_state.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';

@RoutePage()
class DepositFundsScreen extends StatelessWidget {
  const DepositFundsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DepositFundsBloc(
        repository: DepositFundsRepository(),
      ),
      child: const _DepositFundsScreenContent(),
    );
  }
}

class _DepositFundsScreenContent extends StatefulWidget {
  const _DepositFundsScreenContent();

  @override
  State<_DepositFundsScreenContent> createState() => _DepositFundsScreenContentState();
}

class _DepositFundsScreenContentState extends State<_DepositFundsScreenContent> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final List<String> _paymentMethods = [
    'Credit Card',
    'PayPal',
    'Apple Pay',
    'Bank Transfer'
  ];
  String? _selectedPaymentMethod;
  String _externalAddress = '';
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
      final repository = DepositFundsRepository();
      userId = await repository.getSavedUserId();
    }

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<DepositFundsBloc>().add(LoadUserBalance(userId));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  bool get _canDeposit {
    return !(_userId == null ||
        _selectedPaymentMethod == null ||
        _externalAddress.isEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DepositFundsBloc, DepositFundsState>(
      listener: (context, state) {
        if (state.status == DepositFundsStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Deposit successful!'),
              backgroundColor: Colors.green,
            ),
          );
          _amountController.clear();
          _addressController.clear();
          setState(() {
            _selectedPaymentMethod = null;
            _externalAddress = '';
          });
        } else if (state.status == DepositFundsStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == DepositFundsStatus.loading;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Deposit Funds"),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (_userId != null) {
                    context.read<DepositFundsBloc>().add(LoadUserBalance(_userId!));
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

                    // Сума поповнення
                    Text(
                      'Deposit Amount (USD)',
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
                        suffixText: 'USD',
                      ),
                      onChanged: (value) {
                        final amount = double.tryParse(value) ?? 0.0;
                        context.read<DepositFundsBloc>().add(UpdateAmount(amount));
                      },
                    ),

                    const SizedBox(height: 24),

                    // Метод оплати
                    Text(
                      'Payment Method',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPaymentMethod,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.payment),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      hint: const Text('Select payment method'),
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

                    const SizedBox(height: 24),

                    // Зовнішня адреса (банківської картки/рахунку)
                    Text(
                      'Bank Card / Account Number',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Enter your bank card or account number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(Icons.credit_card),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _externalAddress = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),
                    // Кнопка Deposit
                    PrimaryButton(
                      isExpanded: true,
                      onPressed: isLoading || 
                                state.amount <= 0 || 
                                !_canDeposit
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Confirm Deposit'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Amount: \$${state.amount.toStringAsFixed(2)}'),
                                      const SizedBox(height: 8),
                                      Text('Payment Method: $_selectedPaymentMethod'),
                                      const SizedBox(height: 8),
                                      Text('Card/Account: ${_externalAddress.length > 20 ? _externalAddress.substring(0, 20) + "..." : _externalAddress}'),
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
                                        // Дані з _externalAddress не відправляємо на бекенд,
                                        // вони використовуються лише для UI
                                        context.read<DepositFundsBloc>().add(
                                              SubmitDepositOrder(userId: _userId!),
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