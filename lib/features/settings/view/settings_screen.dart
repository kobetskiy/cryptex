import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/const/const.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/auth/view/bloc/auth_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/localization/localization_event.dart';
import 'package:cryptex/features/settings/view/bloc/settings_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_bloc.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_event.dart';
import 'package:cryptex/features/settings/view/bloc/theme/theme_state.dart';
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
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthLoggedOut) {
                        context.router.replaceAll([LogInRoute()]);
                      }

                      if (state is AuthFailure) {
                        Constants.showSnackBar(
                          context,
                          state.error,
                          Constants.failureIcon(),
                        );
                      }
                    },
                    builder:
                        (context, state) => PrimaryButton.outlined(
                          isExpanded: true,
                          onPressed:
                              state is AuthLoading
                                  ? null 
                                  : () => context.read<AuthBloc>().add(LogOut()),
                          child:
                              state is AuthLoading
                                  ? CircularProgressIndicator.adaptive()
                                  : Text(S.of(context).logOut),
                        ),
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

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('English'),
              onTap: () {
                context.read<LocalizationBloc>().add(
                  ChangeLocale(const Locale('en')),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Українська'),
              onTap: () {
                context.read<LocalizationBloc>().add(
                  ChangeLocale(const Locale('uk')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showThemeSelector(BuildContext context, ThemeMode currentTheme) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.light_mode),
              title: const Text('Light'),
              onTap: () {
                context.read<ThemeBloc>().add(
                  ChangeTheme(themeMode: ThemeMode.light),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Dark'),
              onTap: () {
                context.read<ThemeBloc>().add(
                  ChangeTheme(themeMode: ThemeMode.dark),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_auto),
              title: const Text('System'),
              onTap: () {
                context.read<ThemeBloc>().add(
                  ChangeTheme(themeMode: ThemeMode.system),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  String _themeModeToText(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return S.of(context).dark;
      case ThemeMode.system:
      default:
        return 'System';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context).languageCode;
    final languageText = currentLocale == 'uk' ? 'Українська' : 'English';

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final themeText = _themeModeToText(context, themeState.themeMode);

        return SettingsSection(
          title: S.of(context).general,
          children: [
            SettingsListTile(
              title: S.of(context).language,
              trailingText: languageText,
              trailingIcon: Icons.arrow_forward_ios_rounded,
              onTap: () => _showLanguageSelector(context),
            ),
            SettingsListTile(
              title: S.of(context).colorTheme,
              trailingText: themeText,
              trailingIcon: Icons.arrow_forward_ios_rounded,
              onTap: () => _showThemeSelector(context, themeState.themeMode),
            ),
            SettingsListTile(
              title: S.of(context).notifications,
              trailingText: S.of(context).phoneemail,
              trailingIcon: Icons.arrow_forward_ios_rounded,
              onTap: () => context.router.push(NotificationsSettingsRoute()),
            ),
          ],
        );
      },
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
