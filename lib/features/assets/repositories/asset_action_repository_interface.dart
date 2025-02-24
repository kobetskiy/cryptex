abstract interface class AssetActionsRepositoryInterface {
  Future<void> deposit();
  Future<void> withdraw();
  Future<void> sendCrypto();
}
