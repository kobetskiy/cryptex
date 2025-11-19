import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/tr_repository.dart';
import 'transfer_crypto_event.dart';
import 'transfer_crypto_state.dart';

class TransferCryptoBloc extends Bloc<TransferCryptoEvent, TransferCryptoState> {
  final TransferCryptoRepositoryInterface repository;

  TransferCryptoBloc({required this.repository}) : super(const TransferCryptoState()) {
    on<LoadCryptoPrices>(_onLoadCryptoPrices);
    on<LoadUserBalance>(_onLoadUserBalance);
    on<LoadUserCryptoBalances>(_onLoadUserCryptoBalances);
    on<SelectFromCoin>(_onSelectFromCoin);
    on<SelectToCoin>(_onSelectToCoin);
    on<UpdateAmount>(_onUpdateAmount);
    on<SubmitTransferOrder>(_onSubmitTransferOrder);
  }

  Future<void> _onLoadCryptoPrices(
    LoadCryptoPrices event,
    Emitter<TransferCryptoState> emit,
  ) async {
    try {
      emit(state.copyWith(status: TransferCryptoStatus.loading));
      
      final prices = await repository.getCryptoPrices();
      
      emit(
        state.copyWith(
          status: TransferCryptoStatus.initial,
          cryptoPrices: prices,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransferCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadUserBalance(
    LoadUserBalance event,
    Emitter<TransferCryptoState> emit,
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
    Emitter<TransferCryptoState> emit,
  ) async {
    try {
      final cryptoBalances = await repository.getUserCryptoBalances(event.userId);
      
      emit(state.copyWith(cryptoBalances: cryptoBalances));
      
      print('User crypto balances loaded: $cryptoBalances');
    } catch (e) {
      print('Error loading crypto balances: $e');
    }
  }

  void _onSelectFromCoin(
    SelectFromCoin event,
    Emitter<TransferCryptoState> emit,
  ) {
    emit(state.copyWith(fromCoin: event.coin, amount: 0.0));
  }

  void _onSelectToCoin(
    SelectToCoin event,
    Emitter<TransferCryptoState> emit,
  ) {
    emit(state.copyWith(toCoin: event.coin));
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<TransferCryptoState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitTransferOrder(
    SubmitTransferOrder event,
    Emitter<TransferCryptoState> emit,
  ) async {
    // Перевірка чи монети різні
    if (!state.coinsAreDifferent) {
      emit(
        state.copyWith(
          status: TransferCryptoStatus.error,
          errorMessage: 'Cannot convert to the same coin. Please select different coins.',
        ),
      );
      return;
    }

    // Перевірка чи є достатньо криптовалюти
    if (!state.hasEnoughCrypto) {
      emit(
        state.copyWith(
          status: TransferCryptoStatus.error,
          errorMessage: 
              'Insufficient ${state.fromCoin.symbol}. You have ${state.fromCoinBalance.toStringAsFixed(6)}, but trying to convert ${state.amount.toStringAsFixed(6)}',
        ),
      );
      return;
    }

    if (state.amount <= 0) {
      emit(
        state.copyWith(
          status: TransferCryptoStatus.error,
          errorMessage: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: TransferCryptoStatus.loading));

      final response = await repository.transferCrypto(
        userId: event.userId,
        coinForConvert: state.fromCoin.id,
        convertToCoin: state.toCoin.id,
        amount: state.amount,
      );

      if (response.success) {
        // Оновлюємо баланси після успішної конвертації
        final newBalance = response.newBalance ?? state.userBalance;
        final cryptoBalances = response.cryptoBalances ?? state.cryptoBalances;
        
        emit(
          state.copyWith(
            status: TransferCryptoStatus.success,
            newBalance: newBalance,
            userBalance: newBalance,
            cryptoBalances: cryptoBalances,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: TransferCryptoStatus.error,
            errorMessage: response.message ?? 'Transfer failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: TransferCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}