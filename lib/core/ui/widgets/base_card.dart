import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.darkTernary,
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }
}
