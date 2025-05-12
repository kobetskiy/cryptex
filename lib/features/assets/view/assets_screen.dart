import 'package:auto_route/auto_route.dart';
import 'package:cryptex/core/router/router.dart';
import 'package:cryptex/core/ui/widgets/widgets.dart';
import 'package:cryptex/features/assets/widgets/widgets.dart';
import 'package:cryptex/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class AssetsScreen extends StatefulWidget {
  const AssetsScreen({super.key});

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  bool _isAssetsShown = true;

  @override
  void initState() {
    super.initState();
    _loadAssetsShownState();
  }

  Future<void> _loadAssetsShownState() async {
    final prefs = await SharedPreferences.getInstance();
    _isAssetsShown = prefs.getBool('isAssetsShown') ?? true;
    setState(() {});
  }

  Future<void> switchTotalAssets() async {
    _isAssetsShown = !_isAssetsShown;
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAssetsShown', _isAssetsShown);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: AppBar(
        title: Text(S.of(context).myAssets),
        actions: [
          IconButton(
            onPressed: () => context.router.push(SettingsRoute()),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          AssetsHeader(isAssetsShown: _isAssetsShown, onTap: switchTotalAssets),
          SliverToBoxAdapter(child: SizedBox(height: 15)),
          ActionList(),
          SliverToBoxAdapter(child: SizedBox(height: 5)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            sliver: SliverList.separated(
              itemCount: 10,
              itemBuilder:
                  (context, index) => CryptoTile(isAssetsShown: _isAssetsShown),
              separatorBuilder: (_, __) => const SizedBox(height: 10),
            ),
          ),
        ],
      ),
    );
  }
}
