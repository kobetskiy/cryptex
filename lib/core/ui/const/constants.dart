import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:flutter/material.dart';

abstract class Constants {
  static showSnackBar(BuildContext context, String text, Icon icon) {
    final theme = Theme.of(context);
    final snackBar = SnackBar(
      elevation: 7,
      showCloseIcon: true,
      closeIconColor: theme.colorScheme.white,
      backgroundColor: theme.colorScheme.darkTernary,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      content: Row(
        children: [
          icon,
          const SizedBox(width: 10),
          Flexible(
            child: Text(text, style: TextStyle(color: theme.colorScheme.white)),
          ),
        ],
      ),
    );
    return ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Icon failureIcon() =>
      Icon(Icons.error_outline_rounded, color: Colors.red);

  static Icon successIcon() =>
      Icon(Icons.check_circle_outline_rounded, color: Colors.green);
}
