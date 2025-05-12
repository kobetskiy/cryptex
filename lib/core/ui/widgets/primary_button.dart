import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isExpanded = false,
  }) : variant = ButtonVariant.elevated;

  const PrimaryButton.outlined({
    super.key,
    required this.onPressed,
    required this.child,
    this.isExpanded = false,
  }) : variant = ButtonVariant.outlined;

  /// Controls whether the button expands horizontally.
  final bool isExpanded;

  /// Callback when the button is pressed.
  final void Function()? onPressed;

  /// The content of the button.
  final Widget child;

  /// Button style variant (elevated or outlined).
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final elevatedStyle = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.darkSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    final outlinedStyle = OutlinedButton.styleFrom(
      foregroundColor: colorScheme.white,
      side: BorderSide(color: colorScheme.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    final button = switch (variant) {
      ButtonVariant.elevated => ElevatedButton(
        style: elevatedStyle,
        onPressed: onPressed,
        child: child,
      ),
      ButtonVariant.outlined => OutlinedButton(
        style: outlinedStyle,
        onPressed: onPressed,
        child: child,
      ),
    };

    return isExpanded ? Row(children: [Expanded(child: button)]) : button;
  }
}

/// Enum for selecting the button style.
enum ButtonVariant { elevated, outlined }
