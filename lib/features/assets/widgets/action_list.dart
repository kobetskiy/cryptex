import 'package:cryptex/core/ui/const/const.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionList extends StatelessWidget {
  const ActionList({super.key});

  @override
  Widget build(BuildContext context) {
    final iconsList = [AppIcons.deposit, AppIcons.withdraw, AppIcons.send];
    final titlesList = [
      S.of(context).deposit,
      S.of(context).withdraw,
      S.of(context).send,
    ];

    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          3,
          (index) => SizedBox(
            width: 85,
            child: AspectRatio(
              aspectRatio: 1,
              child: Card(
                color: theme.colorScheme.darkSecondary,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          iconsList[index],
                          colorFilter: ColorFilter.mode(
                            theme.colorScheme.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        Text(
                          titlesList[index],
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
          ),
        ),
      ),
    );
  }
}
