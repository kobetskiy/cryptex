import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.trailingText,
    required this.trailingIcon,
  });

  final String title;
  final Function() onTap;
  final String trailingText;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trailingTextStyle = TextStyle().copyWith(
      color:
          theme.brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.4)
              : Colors.black.withValues(alpha: 0.4),
    );
    return ListTile(
      title: Text(title),
      onTap: onTap,
      trailing: Row(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(trailingText, style: trailingTextStyle),
          Icon(
            trailingIcon,
            color:
                theme.brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.4)
                    : Colors.black.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
