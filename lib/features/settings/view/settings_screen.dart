import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/const/const.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/settings/view/bloc/settings_bloc.dart';
import 'package:cryptex/features/settings/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(title: Text(S.of(context).settings)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              spacing: 15,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.shrink(),
                _AccountInfoSection(),
                _GeneralSection(),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: PrimaryButton.outlined(
                    isExpanded: true,
                    onPressed: () {},
                    child: Text(S.of(context).logOut),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneralSection extends StatelessWidget {
  const _GeneralSection();

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).general,
      children: [
        SettingsListTile(
          title: S.of(context).language,
          trailingText: 'English',
          trailingIcon: Icons.arrow_forward_ios_rounded,
          onTap: () {},
        ),
        SettingsListTile(
          title: S.of(context).colorTheme,
          trailingText: 'Dark',
          trailingIcon: Icons.arrow_forward_ios_rounded,
          onTap: () {},
        ),
        SettingsListTile(
          title: S.of(context).notifications,
          trailingText: 'Phone/Email',
          trailingIcon: Icons.arrow_forward_ios_rounded,
          onTap: () => context.router.push(NotificationsSettingsRoute()),
        ),
      ],
    );
  }
}

class _AccountInfoSection extends StatelessWidget {
  const _AccountInfoSection();

  @override
  Widget build(BuildContext context) {
    void showSnackBar(context, state) {
      if (state is SettingsSuccess) {
        Constants.showSnackBar(
          context,
          S.of(context).idCopiedSuccessfully,
          Constants.successIcon(),
        );
      } else if (state is SettingsFailure) {
        Constants.showSnackBar(
          context,
          S.of(context).errorCopyingId,
          Constants.failureIcon(),
        );
      }
    }

    return SettingsSection(
      title: S.of(context).accountInfo,
      children: [
        SettingsListTile(
          title: S.of(context).nickname,
          trailingText: 'Artem',
          trailingIcon: Icons.arrow_forward_ios_rounded,
          onTap: () => context.router.push(NickNameSettingsRoute()),
        ),
        BlocListener<SettingsBloc, SettingsState>(
          listener: showSnackBar,
          child: SettingsListTile(
            title: S.of(context).id,
            trailingText: '1234567890',
            trailingIcon: Icons.copy_rounded,
            onTap: () => context.read<SettingsBloc>().add(CopyId()),
          ),
        ),
        SettingsListTile(
          title: S.of(context).security,
          trailingText: S.of(context).appLock,
          trailingIcon: Icons.arrow_forward_ios_rounded,
          onTap: () => context.router.push(SecuritySettingsRoute()),
        ),
      ],
    );
  }
}
