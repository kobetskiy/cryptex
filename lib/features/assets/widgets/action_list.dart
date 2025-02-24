import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/const/const.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionList extends StatelessWidget {
  const ActionList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionItem(
            icon: AppIcons.deposit,
            title: S.of(context).deposit,
            onTap: () => context.router.push(DepositActionRoute()),
          ),
          _ActionItem(
            icon: AppIcons.withdraw,
            title: S.of(context).withdraw,
            onTap: () => context.router.push(WithdrawActionRoute()),
          ),
          _ActionItem(
            icon: AppIcons.send,
            title: S.of(context).send,
            onTap: () => context.router.push(SendCryptoActionRoute()),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final String icon;
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 85,
      child: AspectRatio(
        aspectRatio: 1,
        child: Card(
          child: InkWell(
            onTap: onTap,
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(
                    icon,
                    colorFilter: ColorFilter.mode(
                      theme.colorScheme.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  Text(
                    title,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
