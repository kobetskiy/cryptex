import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                                hintText: 'Search',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _FunctionItem(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Buy Crypto',
                  onTap: () {
                    print('Buy Crypto tapped');
                    context.router.push(BuyCryptoRoute());
                  },
                ),
                _FunctionItem(
                  icon: Icons.headset_mic,
                  label: 'Support',
                  onTap: () {
                    print('Support tapped');
                    context.router.push(SupportRoute());
                  },
                ),
                _FunctionItem(
                  icon: Icons.card_giftcard,
                  label: 'Rewards',
                  onTap: () {
                    print('Rewards tapped');
                    context.router.push(RewardsRoute());
                  },
                ),
              ],
            ),

            const Divider(height: 20, color: Colors.white24),

            // Balance
            Column(
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      '\$',
                      style: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '514.22',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'USD',
                      style: TextStyle(fontSize: 20, color: Colors.white54),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('-8.21%', style: TextStyle(color: Colors.redAccent)),
                    SizedBox(width: 10),
                    Text('|', style: TextStyle(color: Colors.white54)),
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 36, color: Colors.white),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
