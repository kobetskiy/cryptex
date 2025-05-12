import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({
    super.key,
    required this.tabIndex,
    this.onTap,
  });

  final int tabIndex;
  final void Function(int)? onTap;

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor: theme.colorScheme.darkSecondary,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey[600],
      selectedItemColor: Color(0xFFEAB821),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.wallet_outlined), label: ''),
      ],
      currentIndex: widget.tabIndex,
      onTap: widget.onTap,
    );
  }
}
