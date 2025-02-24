part of 'asset_actions_bloc.dart';

sealed class AssetActionsEvent extends Equatable {
  const AssetActionsEvent();

  @override
  List<Object> get props => [];
}

final class Deposit extends AssetActionsEvent {}

final class Withdraw extends AssetActionsEvent {}

final class SendCrypto extends AssetActionsEvent {}
