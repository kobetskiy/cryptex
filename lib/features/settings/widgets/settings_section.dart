import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key, required this.children, this.title});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headlineTextStyle = theme.textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.w600,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title != null
            ? Text(title!, style: headlineTextStyle)
            : SizedBox.shrink(),
        SizedBox(height: 15),
        BaseCard(child: Column(spacing: 10, children: children)),
      ],
    );
  }
}
