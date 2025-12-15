import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'deposit_funds_event.dart';
import 'deposit_funds_state.dart';

class DepositFundsBloc extends Bloc<DepositFundsEvent, DepositFundsState> {
  final DepositFundsRepositoryInterface repository;

  DepositFundsBloc({required this.repository}) : super(const DepositFundsState()) {
    on<LoadUserBalance>(_onLoadUserBalance);
    on<UpdateAmount>(_onUpdateAmount);
    on<SubmitDepositOrder>(_onSubmitDepositOrder);
  }

  Future<void> _onLoadUserBalance(
    LoadUserBalance event,
    Emitter<DepositFundsState> emit,
  ) async {
    try {
      final balance = await repository.getUserBalance(event.userId);
      emit(state.copyWith(userBalance: balance));
      print('User balance loaded: \$${balance.toStringAsFixed(2)}');
    } catch (e) {
      print('Error loading user balance: $e');
    }
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<DepositFundsState> emit,
  ) {
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitDepositOrder(
    SubmitDepositOrder event,
    Emitter<DepositFundsState> emit,
  ) async {
    if (state.amount <= 0) {
      emit(
        state.copyWith(
          status: DepositFundsStatus.error,
          errorMessage: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    try {
      emit(state.copyWith(status: DepositFundsStatus.loading));

      final response = await repository.depositFunds(
        userId: event.userId,
        amount: state.amount,
      );

      if (response.success) {
        final newBalance = response.newBalance ?? state.userBalance + state.amount;
        
        emit(
          state.copyWith(
            status: DepositFundsStatus.success,
            newBalance: newBalance,
            userBalance: newBalance,
            amount: 0.0,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: DepositFundsStatus.error,
            errorMessage: response.message ?? 'Deposit failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: DepositFundsStatus.error,
          errorMessage: 'Error: ${e.toString()}',
        ),
      );
    }
  }
}