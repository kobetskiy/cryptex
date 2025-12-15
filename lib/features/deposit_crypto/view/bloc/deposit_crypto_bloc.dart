import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'deposit_crypto_event.dart';
import 'deposit_crypto_state.dart';

class DepositCryptoBloc extends Bloc<DepositCryptoEvent, DepositCryptoState> {
  final DepositCryptoRepositoryInterface repository;

  DepositCryptoBloc({required this.repository}) : super(const DepositCryptoState()) {
    on<LoadUserCryptoBalance>(_onLoadUserCryptoBalance);
    on<UpdateAmount>(_onUpdateAmount);
    on<UpdateDepositAddress>(_onUpdateDepositAddress);
    on<SubmitDepositCrypto>(_onSubmitDepositCrypto);
  }

  Future<void> _onLoadUserCryptoBalance(
    LoadUserCryptoBalance event,
    Emitter<DepositCryptoState> emit,
  ) async {
    try {
      final balance = await repository.getUserCryptoBalance(event.userId);
      emit(state.copyWith(userCryptoBalance: balance));
      print('User crypto balance loaded: ${balance.toStringAsFixed(8)}');
    } catch (e) {
      print('Error loading user crypto balance: $e');
    }
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<DepositCryptoState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  void _onUpdateDepositAddress(
    UpdateDepositAddress event,
    Emitter<DepositCryptoState> emit,
  ) {
    emit(state.copyWith(depositAddress: event.depositAddress));
  }

  Future<void> _onSubmitDepositCrypto(
    SubmitDepositCrypto event,
    Emitter<DepositCryptoState> emit,
  ) async {
    if (state.amount <= 0) {
      emit(
        state.copyWith(
          status: DepositCryptoStatus.error,
          errorMessage: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    if (state.depositAddress.isEmpty) {
      emit(
        state.copyWith(
          status: DepositCryptoStatus.error,
          errorMessage: 'Please enter a deposit address',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: DepositCryptoStatus.loading));

      final response = await repository.depositCrypto(
        userId: event.userId,
        depositAddress: state.depositAddress,
        amount: state.amount,
      );

      if (response.success) {
        final newBalance = response.newBalance ?? state.userCryptoBalance + state.amount;
        
        emit(
          state.copyWith(
            status: DepositCryptoStatus.success,
            newBalance: newBalance,
            userCryptoBalance: newBalance,
            amount: 0.0,
            depositAddress: '',
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DepositCryptoStatus.error,
            errorMessage: response.message ?? 'Crypto deposit failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: DepositCryptoStatus.error,
          errorMessage: 'Error: ${e.toString()}',
        ),
      );
    }
  }
}