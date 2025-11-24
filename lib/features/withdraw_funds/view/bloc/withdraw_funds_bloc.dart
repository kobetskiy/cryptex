import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/repositories.dart';
import 'withdraw_funds_event.dart';
import 'withdraw_funds_state.dart';

class WithdrawFundsBloc extends Bloc<WithdrawFundsEvent, WithdrawFundsState> {
  final WithdrawFundsRepositoryInterface repository;

  WithdrawFundsBloc({required this.repository}) : super(const WithdrawFundsState()) {
    on<LoadUserBalance>(_onLoadUserBalance);
    on<UpdateAmount>(_onUpdateAmount);
    on<SubmitWithdrawOrder>(_onSubmitWithdrawOrder);
    
    print('✅ WithdrawFundsBloc initialized');
  }

  Future<void> _onLoadUserBalance(
    LoadUserBalance event,
    Emitter<WithdrawFundsState> emit,
  ) async {
    print('🔵 LoadUserBalance event received for userId: ${event.userId}');
    
    try {
      final balance = await repository.getUserBalance(event.userId);
      
      emit(state.copyWith(userBalance: balance));
      
      print('✅ User balance loaded: \$${balance.toStringAsFixed(2)}');
    } catch (e, stackTrace) {
      print('❌ Error loading user balance: $e');
      print('Stack trace: $stackTrace');
    }
  }

  void _onUpdateAmount(
    UpdateAmount event,
    Emitter<WithdrawFundsState> emit,
  ) {
    print('🔵 UpdateAmount: ${event.amount}');
    emit(state.copyWith(amount: event.amount));
  }

  Future<void> _onSubmitWithdrawOrder(
    SubmitWithdrawOrder event,
    Emitter<WithdrawFundsState> emit,
  ) async {
    print('');
    print('═══════════════════════════════════════════');
    print('🔵 SUBMIT WITHDRAW ORDER EVENT');
    print('═══════════════════════════════════════════');
    print('UserId: ${event.userId}');
    print('Amount: \$${state.amount}');
    print('Current Balance: \$${state.userBalance}');
    print('Has Enough Balance: ${state.hasEnoughBalance}');
    
    // Валідація
    if (!state.hasEnoughBalance) {
      print('❌ Insufficient balance');
      emit(
        state.copyWith(
          status: WithdrawFundsStatus.error,
          errorMessage: 
              'Insufficient balance. You have \$${state.userBalance.toStringAsFixed(2)}, but trying to withdraw \$${state.amount.toStringAsFixed(2)}',
        ),
      );
      return;
    }

    if (state.amount <= 0) {
      print('❌ Amount is 0 or negative');
      emit(
        state.copyWith(
          status: WithdrawFundsStatus.error,
          errorMessage: 'Amount must be greater than 0',
        ),
      );
      return;
    }

    try {
      print('⏳ Setting loading state...');
      emit(state.copyWith(status: WithdrawFundsStatus.loading));
      print('✅ Loading state set');

      print('');
      print('📞 Calling repository.withdrawFunds...');
      final response = await repository.withdrawFunds(
        userId: event.userId,
        amount: state.amount,
      );

      print('');
      print('📥 Response received:');
      print('  - Success: ${response.success}');
      print('  - Message: ${response.message}');
      print('  - New Balance: ${response.newBalance}');

      if (response.success) {
        final newBalance = response.newBalance ?? state.userBalance - state.amount;
        
        print('');
        print('✅ Setting SUCCESS state');
        print('  - New Balance: \$$newBalance');
        
        emit(
          state.copyWith(
            status: WithdrawFundsStatus.success,
            newBalance: newBalance,
            userBalance: newBalance,
            amount: 0.0,
          ),
        );
        
        print('✅ Success state emitted');
        print('═══════════════════════════════════════════');
      } else {
        print('');
        print('❌ Withdrawal failed: ${response.message}');
        emit(
          state.copyWith(
            status: WithdrawFundsStatus.error,
            errorMessage: response.message ?? 'Withdrawal failed',
          ),
        );
        print('═══════════════════════════════════════════');
      }
    } catch (e, stackTrace) {
      print('');
      print('═══════════════════════════════════════════');
      print('💥 EXCEPTION IN BLOC');
      print('═══════════════════════════════════════════');
      print('Error: $e');
      print('Type: ${e.runtimeType}');
      print('Stack trace:');
      print(stackTrace);
      print('═══════════════════════════════════════════');
      
      emit(
        state.copyWith(
          status: WithdrawFundsStatus.error,
          errorMessage: 'Error: ${e.toString()}',
        ),
      );
    }
  }
}