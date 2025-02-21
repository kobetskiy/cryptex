import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isExpanded,
  });

  final bool? isExpanded;
  final void Function()? onPressed;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final elevatedStyle = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    final button = ElevatedButton(
      style: elevatedStyle,
      onPressed: onPressed,
      child: child,
    );

    return isExpanded ?? false
        ? Row(children: [Expanded(child: button)])
        : button;
  }
}
