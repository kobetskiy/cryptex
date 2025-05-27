import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';

@RoutePage()
class BuyCryptoScreen extends StatefulWidget {
  const BuyCryptoScreen({super.key});

  @override
  State<BuyCryptoScreen> createState() => _BuyCryptoScreenState();
}

class _BuyCryptoScreenState extends State<BuyCryptoScreen> {
  final List<String> _paymentMethods = ['Credit Card', 'PayPal', 'Apple Pay'];
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(S.of(context).buyCrypto)),
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(S.of(context).coin),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Bitcoin"),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios_rounded),
                ],
              ),
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('USD'),
                ],
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.darkTernary),
            ListTile(
              title: Text(S.of(context).cost),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text("0.00"), SizedBox(width: 10), Text('USD')],
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.darkTernary),
            SizedBox(height: 40),
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
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedPaymentMethod,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    hint: Text(S.of(context).selectPaymentMethod),
                    items:
                        _paymentMethods
                            .map(
                              (method) => DropdownMenuItem<String>(
                                value: method,
                                child: Text(method),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
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
          onPressed: () {},
          child: Text(S.of(context).buy),
        ),
      ),
    );
  }
}
