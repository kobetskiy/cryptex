part of 'asset_actions_bloc.dart';

sealed class AssetActionsState extends Equatable {
  const AssetActionsState();

  @override
  List<Object> get props => [];
}

final class AssetActionsInitial extends AssetActionsState {}

final class AssetActionsLoading extends AssetActionsState {}

final class AssetActionsSuccess extends AssetActionsState {}

final class AssetActionsFailure extends AssetActionsState {
  final Object error;

  const AssetActionsFailure(this.error);
}
