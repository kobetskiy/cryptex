import 'package:bloc/bloc.dart';
import 'package:cryptex/features/assets/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'asset_actions_event.dart';
part 'asset_actions_state.dart';

class AssetActionsBloc extends Bloc<AssetActionsEvent, AssetActionsState> {
  final AssetActionsRepositoryInterface _assetActionsRepository;
  AssetActionsBloc({required AssetActionsRepositoryInterface repository})
    : _assetActionsRepository = repository,
      super(AssetActionsInitial()) {
    on<DepositEvent>(_depositEvent);
    on<WithdrawEvent>(_withdrawEvent);
    on<SendCryptoEvent>(_sendCryptoEvent);
  }

  Future<void> _depositEvent(
    AssetActionsEvent event,
    Emitter<AssetActionsState> emit,
  ) async {
    try {
      emit(AssetActionsLoading());
      await _assetActionsRepository.deposit();
      emit(AssetActionsSuccess());
    } catch (e) {
      emit(AssetActionsFailure(e));
    }
  }

  Future<void> _withdrawEvent(
    AssetActionsEvent event,
    Emitter<AssetActionsState> emit,
  ) async {
    try {
      emit(AssetActionsLoading());
      await _assetActionsRepository.withdraw();
      emit(AssetActionsSuccess());
    } catch (e) {
      emit(AssetActionsFailure(e));
    }
  }

  Future<void> _sendCryptoEvent(
    AssetActionsEvent event,
    Emitter<AssetActionsState> emit,
  ) async {
    try {
      emit(AssetActionsLoading());
      await _assetActionsRepository.sendCrypto();
      emit(AssetActionsSuccess());
    } catch (e) {
      emit(AssetActionsFailure(e));
    }
  }
}
