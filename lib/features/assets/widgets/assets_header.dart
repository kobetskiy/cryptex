import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';

class AssetsHeader extends StatelessWidget {
  const AssetsHeader({
    super.key,
    required this.onTap,
    required this.isAssetsShown,
  });

  final Function()? onTap;
  final bool isAssetsShown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(S.of(context).totalAssets),
              SizedBox(width: 5),
              InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    isAssetsShown
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          Text(
            isAssetsShown ? '200.000 USD' : "******",
            style: theme.textTheme.headlineLarge,
          ),
          Text(isAssetsShown ? '≈ 2,06749 BTC' : "******"),
        ],
      ),
    );
  }
}
