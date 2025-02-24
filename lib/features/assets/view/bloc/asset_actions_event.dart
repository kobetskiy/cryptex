part of 'asset_actions_bloc.dart';

sealed class AssetActionsEvent extends Equatable {
  const AssetActionsEvent();

  @override
  List<Object> get props => [];
}

final class DepositEvent extends AssetActionsEvent {}

final class WithdrawEvent extends AssetActionsEvent {}

final class SendCryptoEvent extends AssetActionsEvent {}
