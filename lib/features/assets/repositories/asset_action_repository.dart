import 'dart:developer';

import 'package:cryptex/features/assets/repositories/repositories.dart';

class AssetActionsRepository implements AssetActionsRepositoryInterface {
  @override
  Future<void> deposit() async {
    try {
      log('deposit');
    } catch (e) {}
  }

  @override
  Future<void> withdraw() async {
    try {
      log('withdraw');
    } catch (e) {}
  }

  @override
  Future<void> sendCrypto() async {
    try {
      log('sendCrypto');
    } catch (e) {}
  }
}
