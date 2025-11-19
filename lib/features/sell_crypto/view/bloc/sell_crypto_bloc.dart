import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repository.dart';
import 'sell_crypto_event.dart';
import 'sell_crypto_state.dart';

class SellCryptoBloc extends Bloc<SellCryptoEvent, SellCryptoState> {
  final SellCryptoRepositoryInterface repository;

  SellCryptoBloc({required this.repository}) : super(const SellCryptoState()) {
    on<LoadCryptoPrices>(_onLoadCryptoPrices);
    on<LoadUserBalance>(_onLoadUserBalance);
    on<LoadUserCryptoBalances>(_onLoadUserCryptoBalances);
    on<SelectCoin>(_onSelectCoin);
    on<UpdateAmount>(_onUpdateAmount);
    on<SubmitSellOrder>(_onSubmitSellOrder);
  }

  Future<void> _onLoadCryptoPrices(
    LoadCryptoPrices event,
    Emitter<SellCryptoState> emit,
  ) async {
    try {
      emit(state.copyWith(status: SellCryptoStatus.loading));
      
      final prices = await repository.getCryptoPrices();
      
      emit(
        state.copyWith(
          status: SellCryptoStatus.initial,
          cryptoPrices: prices,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SellCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadUserBalance(
    LoadUserBalance event,
    Emitter<SellCryptoState> emit,
  ) async {
    try {
      final balance = await repository.getUserBalance(event.userId);
      
      emit(state.copyWith(userBalance: balance));
      
      print('User USD balance loaded: \$${balance.toStringAsFixed(2)}');
    } catch (e) {
      print('Error loading user balance: $e');
    }
  }

  Future<void> _onLoadUserCryptoBalances(
    LoadUserCryptoBalances event,
    Emitter<SellCryptoState> emit,
  ) async {
    try {
      final cryptoBalances = await repository.getUserCryptoBalances(event.userId);
      
      emit(state.copyWith(cryptoBalances: cryptoBalances));
      
      print('User crypto balances loaded: $cryptoBalances');
    } catch (e) {
      print('Error loading crypto balances: $e');
    }
  }

  void _onSelectCoin(
    SelectCoin event,
    Emitter<SellCryptoState> emit,
  ) {
    emit(state.copyWith(selectedCoin: event.coin, amount: 0.0));
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<SellCryptoState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitSellOrder(
    SubmitSellOrder event,
    Emitter<SellCryptoState> emit,
  ) async {
    // Перевірка чи є достатньо криптовалюти
    if (!state.hasEnoughCrypto) {
      emit(
        state.copyWith(
          status: SellCryptoStatus.error,
          errorMessage: 
              'Insufficient ${state.selectedCoin.symbol}. You have ${state.selectedCoinBalance.toStringAsFixed(6)}, but trying to sell ${state.amount.toStringAsFixed(6)}',
        ),
      );
      return;
    }

    if (state.amount <= 0) {
      emit(
        state.copyWith(
          status: SellCryptoStatus.error,
          errorMessage: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: SellCryptoStatus.loading));

      final response = await repository.sellCrypto(
        userId: event.userId,
        coin: state.selectedCoin.id,
        amount: state.amount,
      );

      if (response.success) {
        // Оновлюємо баланси після успішного продажу
        final newBalance = response.newBalance ?? state.userBalance;
        
        // Перезавантажуємо баланси криптовалют
        final cryptoBalances = await repository.getUserCryptoBalances(event.userId);
        
        emit(
          state.copyWith(
            status: SellCryptoStatus.success,
            newBalance: newBalance,
            userBalance: newBalance,
            cryptoBalances: cryptoBalances,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SellCryptoStatus.error,
            errorMessage: response.message ?? 'Sale failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: SellCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}