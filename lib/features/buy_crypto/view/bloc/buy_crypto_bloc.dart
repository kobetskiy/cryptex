import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/buy_crypto_repository.dart';
import 'buy_crypto_event.dart';
import 'buy_crypto_state.dart';

class BuyCryptoBloc extends Bloc<BuyCryptoEvent, BuyCryptoState> {
  final BuyCryptoRepositoryInterface repository;

  BuyCryptoBloc({required this.repository}) : super(const BuyCryptoState()) {
    on<LoadCryptoPrices>(_onLoadCryptoPrices);
    on<SelectCoin>(_onSelectCoin);
    on<UpdateAmount>(_onUpdateAmount);
    on<SubmitBuyOrder>(_onSubmitBuyOrder);
    on<LoadUserBalance>(_onLoadUserBalance); 
  }

  Future<void> _onLoadCryptoPrices(
    LoadCryptoPrices event,
    Emitter<BuyCryptoState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BuyCryptoStatus.loading));
      
      final prices = await repository.getCryptoPrices();
      
      emit(
        state.copyWith(
          status: BuyCryptoStatus.initial,
          cryptoPrices: prices,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: BuyCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
  Future<void> _onLoadUserBalance(
    LoadUserBalance event,
    Emitter<BuyCryptoState> emit,
  ) async {
    try {
      final balance = await repository.getUserBalance(event.userId);
      
      emit(state.copyWith(userBalance: balance));
    } catch (e) {
      print('Error loading user balance: $e');
    }
  }
  void _onSelectCoin(
    SelectCoin event,
    Emitter<BuyCryptoState> emit,
  ) {
    emit(state.copyWith(selectedCoin: event.coin));
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<BuyCryptoState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitBuyOrder(
    SubmitBuyOrder event,
    Emitter<BuyCryptoState> emit,
  ) async {
    if (state.amount <= 0) {
      emit(
        state.copyWith(
          status: BuyCryptoStatus.error,
          errorMessage: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: BuyCryptoStatus.loading));

      final response = await repository.buyCrypto(
        userId: event.userId,
        coin: state.selectedCoin.id,
        amount: state.amount,
      );

      if (response.success) {
        emit(
          state.copyWith(
            status: BuyCryptoStatus.success,
            newBalance: response.newBalance,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: BuyCryptoStatus.error,
            errorMessage: response.message ?? 'Purchase failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: BuyCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}