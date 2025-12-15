import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/buy_crypto/models/crypto_coin.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum OrderType { buy, sell }

@RoutePage()
class LimitOrdersScreen extends StatefulWidget {
  const LimitOrdersScreen({super.key});

  @override
  State<LimitOrdersScreen> createState() => _LimitOrdersScreenState();
}

class _LimitOrdersScreenState extends State<LimitOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  OrderType _orderType = OrderType.buy;
  CryptoCoin _selectedCoin = CryptoCoin.bitcoin;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<Map<String, dynamic>> _mockOrders = [
    {
      'coin': 'BTC',
      'type': 'Buy',
      'price': 95000.00,
      'amount': 0.5,
      'status': 'Pending',
      'date': '2025-01-15',
    },
    {
      'coin': 'ETH',
      'type': 'Sell',
      'price': 3200.00,
      'amount': 2.0,
      'status': 'Pending',
      'date': '2025-01-14',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _priceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showCoinSelector() {
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
                final isSelected = _selectedCoin == coin;
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
                  selected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedCoin = coin;
                    });
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

  void _placeOrder() {
    if (_priceController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Limit order placed: ${_orderType == OrderType.buy ? "Buy" : "Sell"} ${_amountController.text} ${_selectedCoin.symbol} at \$${_priceController.text}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
    _priceController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Limit Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Create Order'),
            Tab(text: 'Active Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreateOrderTab(),
          _buildActiveOrdersTab(),
        ],
      ),
    );
  }

  Widget _buildCreateOrderTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _orderType = OrderType.buy),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _orderType == OrderType.buy
                            ? Colors.green.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        'BUY',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _orderType == OrderType.buy
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _orderType = OrderType.sell),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: _orderType == OrderType.sell
                            ? Colors.red.withOpacity(0.2)
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        'SELL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _orderType == OrderType.sell
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Select Coin',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _showCoinSelector,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          _selectedCoin.symbol.substring(0, 1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCoin.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _selectedCoin.symbol,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Limit Price (USD)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
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
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Amount (${_selectedCoin.symbol})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,6}')),
            ],
            decoration: InputDecoration(
              hintText: '0.000000',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(
                _orderType == OrderType.buy ? Icons.add_circle : Icons.remove_circle,
                color: _orderType == OrderType.buy ? Colors.green : Colors.red,
              ),
            ),
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
                  child: Text(
                    'Your order will be executed when the market price reaches your limit price.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          PrimaryButton(
            isExpanded: true,
            onPressed: _placeOrder,
            child: Text(
              'Place ${_orderType == OrderType.buy ? "Buy" : "Sell"} Order',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrdersTab() {
    return _mockOrders.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No active orders',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _mockOrders.length,
            itemBuilder: (context, index) {
              final order = _mockOrders[index];
              final isBuy = order['type'] == 'Buy';
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isBuy ? Colors.green : Colors.red,
                    child: Icon(
                      isBuy ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    '${order['type']} ${order['coin']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Price: \$${order['price']} • Amount: ${order['amount']} ${order['coin']}\n${order['date']}',
                  ),
                  trailing: Chip(
                    label: Text(
                      order['status'],
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.orange.withOpacity(0.2),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
  }
}