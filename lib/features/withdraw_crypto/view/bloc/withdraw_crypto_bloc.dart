import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'withdraw_crypto_event.dart';
import 'withdraw_crypto_state.dart';

class WithdrawCryptoBloc extends Bloc<WithdrawCryptoEvent, WithdrawCryptoState> {
  final WithdrawCryptoRepositoryInterface repository;

  WithdrawCryptoBloc({required this.repository}) : super(const WithdrawCryptoState()) {
    on<LoadCryptoPrices>(_onLoadCryptoPrices);
    on<LoadUserBalance>(_onLoadUserBalance);
    on<LoadUserCryptoBalances>(_onLoadUserCryptoBalances);
    on<SelectCoin>(_onSelectCoin);
    on<UpdateAmount>(_onUpdateAmount);
    on<UpdateExternalAddress>(_onUpdateExternalAddress);
    on<SubmitWithdrawOrder>(_onSubmitWithdrawOrder);
  }

  Future<void> _onLoadCryptoPrices(
    LoadCryptoPrices event,
    Emitter<WithdrawCryptoState> emit,
  ) async {
    try {
      // Встановлюємо loading тільки якщо це перше завантаження
      if (state.cryptoPrices.isEmpty) {
        emit(state.copyWith(status: WithdrawCryptoStatus.loading));
      }
      
      final prices = await repository.getCryptoPrices();
      
      emit(
        state.copyWith(
          status: WithdrawCryptoStatus.initial,
          cryptoPrices: prices,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: WithdrawCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLoadUserBalance(
    LoadUserBalance event,
    Emitter<WithdrawCryptoState> emit,
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
    Emitter<WithdrawCryptoState> emit,
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
    Emitter<WithdrawCryptoState> emit,
  ) {
    emit(state.copyWith(selectedCoin: event.coin, amount: 0.0));
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<WithdrawCryptoState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onUpdateExternalAddress(
    UpdateExternalAddress event,
    Emitter<WithdrawCryptoState> emit,
  ) {
    emit(state.copyWith(externalAddress: event.address));
  }

  Future<void> _onSubmitWithdrawOrder(
    SubmitWithdrawOrder event,
    Emitter<WithdrawCryptoState> emit,
  ) async {
    if (!state.hasEnoughCrypto) {
      emit(
        state.copyWith(
          status: WithdrawCryptoStatus.error,
          errorMessage: 
              'Insufficient ${state.selectedCoin.symbol}. You have ${state.selectedCoinBalance.toStringAsFixed(8)}, but trying to withdraw ${state.amount.toStringAsFixed(8)}',
        ),
      );
      return;
    }

    if (state.amount <= 0) {
      emit(
        state.copyWith(
          status: WithdrawCryptoStatus.error,
          errorMessage: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    if (state.externalAddress.isEmpty) {
      emit(
        state.copyWith(
          status: WithdrawCryptoStatus.error,
          errorMessage: 'Please enter an external wallet address',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: WithdrawCryptoStatus.loading));

      final response = await repository.withdrawCrypto(
        userId: event.userId,
        coinName: state.selectedCoin.id,
        amount: state.amount,
        externalAddress: state.externalAddress,
      );

      if (response.success) {
        final newBalance = response.newBalance ?? state.userBalance;
        final cryptoBalances = response.cryptoBalances ?? state.cryptoBalances;
        
        emit(
          state.copyWith(
            status: WithdrawCryptoStatus.success,
            newBalance: newBalance,
            userBalance: newBalance,
            cryptoBalances: cryptoBalances,
            amount: 0.0,
            externalAddress: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: WithdrawCryptoStatus.error,
            errorMessage: response.message ?? 'Withdrawal failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: WithdrawCryptoStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}