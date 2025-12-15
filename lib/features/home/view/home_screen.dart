import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cryptex/features/buy_crypto/repositories/buy_crypto_repository.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _userBalance = 0.0;
  bool _isLoadingBalance = true;

  @override
  void initState() {
    super.initState();
    _loadUserBalance();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _loadUserBalance() async {
    if (!mounted) return;
    
    setState(() {
      _isLoadingBalance = true;
    });

    try {
      final authState = context.read<AuthBloc>().state;
      int? userId;

      if (authState is AuthSuccess) {
        userId = authState.userId;
      } else {
        final repository = BuyCryptoRepository();
        userId = await repository.getSavedUserId();
      }

      if (userId != null) {
        final repository = BuyCryptoRepository();
        final balance = await repository.getUserBalance(userId);
        
        if (mounted) {
          setState(() {
            _userBalance = balance;
            _isLoadingBalance = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingBalance = false;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: S.of(context).search,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // 1-й рядок
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FunctionItem(
                          icon: Icons.shopping_bag_outlined,
                          label: S.of(context).buyCrypto,
                          onTap: () async {
                            print('Buy Crypto tapped');
                            context.router.push(BuyCryptoRoute());
                            if (mounted) _loadUserBalance();
                          },
                        ),
                        _FunctionItem(
                          icon: Icons.headset_mic,
                          label: S.of(context).support,
                          onTap: () async {
                            print('Support tapped');
                            context.router.push(SupportRoute());
                            if (mounted) _loadUserBalance();
                          },
                        ),
                        _FunctionItem(
                          icon: Icons.card_giftcard,
                          label: S.of(context).rewards,
                          onTap: () async {
                            print('Rewards tapped');
                            context.router.push(RewardsRoute());
                            if (mounted) _loadUserBalance();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 2-й рядок
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FunctionItem(
                          icon: Icons.account_balance_wallet,
                          label: 'Withdraw',
                          onTap: () async {
                            print('Withdraw tapped');
                            context.router.push(WithdrawFundsRoute());
                            if (mounted) _loadUserBalance();
                          },
                        ),
                        _FunctionItem(
                          icon: Icons.sell,
                          label: 'Sell Crypto',
                          onTap: () {
                            print('Sell crypto tapped');
                            context.router.push(SellCryptoRoute());
                          },
                        ),
                        _FunctionItem(
                          icon: Icons.add_circle,
                          label: 'Deposit Fiat',
                          onTap: () {
                            print('Deposit Fiat tapped');
                            context.router.push(DepositFundsRoute());
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // 3-й рядок
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FunctionItem(
                          icon: Icons.logout,
                          label: 'Withdraw Crypto',
                          onTap: () {
                            print('Withdraw Crypto tapped');
                            context.router.push(WithdrawCryptoRoute());
                          },
                        ),
                        _FunctionItem(
                          icon: Icons.swap_horiz,
                          label: 'Convert Crypto',
                          onTap: () {
                            print('Convert crypto tapped');
                            context.router.push(ConvertCryptoRoute());
                          },
                        ),
                        _FunctionItem(
                          icon: Icons.trending_up,
                          label: 'Limit Orders',
                          onTap: () {
                            print('Limit Orders tapped');
                            context.router.push(LimitOrdersRoute());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),


            // Balance
            Column(
              children: [
                Text(
                  S.of(context).totalBalance,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                _isLoadingBalance
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('\$', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: 4),
                          Text(
                            _userBalance.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text('USD', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('-8.21%', style: TextStyle(color: Colors.redAccent)),
                    SizedBox(width: 10),
                    Text('|', style: TextStyle(color: Colors.grey)),
                    SizedBox(width: 10),
                    Text('-\$42.37', style: TextStyle(color: Colors.redAccent)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FunctionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FunctionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, // Фіксована ширина для однакового вирівнювання
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              icon,
              size: 36,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
