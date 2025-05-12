import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/ui/theme/theme.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/settings/view/bloc/settings_bloc.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class NickNameSettingsScreen extends StatefulWidget {
  const NickNameSettingsScreen({super.key});

  @override
  State<NickNameSettingsScreen> createState() => _NickNameSettingsScreenState();
}

class _NickNameSettingsScreenState extends State<NickNameSettingsScreen> {
  final _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  void _changeNickname() {
    context.read<SettingsBloc>().add(
      ChangeNickname(newNickname: _nicknameController.text.trim()),
    );
  }

  @override
  void dispose() {
    _nicknameController.removeListener(_onTextChanged);
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BaseScaffold(
      appBar: AppBar(title: Text(S.of(context).changeNickname)),
      body: Column(
        children: [
          const SizedBox(height: 25),
          TextField(
            controller: _nicknameController,
            maxLength: 15,
            cursorHeight: 20,
            autofocus: true,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              hintText: S.of(context).newNickname,
              hintStyle: TextStyle(color: theme.colorScheme.grey),
              counter: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${_nicknameController.text.length}/15',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          PrimaryButton(
            isExpanded: true,
            onPressed: _changeNickname,
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
