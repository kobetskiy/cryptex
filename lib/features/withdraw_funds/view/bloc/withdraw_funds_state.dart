import 'package:equatable/equatable.dart';
enum WithdrawFundsStatus { initial, loading, success, error }

class WithdrawFundsState {
  final WithdrawFundsStatus status;
  final double amount;
  final String? errorMessage;
  final double? newBalance;
  final double userBalance;

  const WithdrawFundsState({
    this.status = WithdrawFundsStatus.initial,
    this.amount = 0.0,
    this.errorMessage,
    this.newBalance,
    this.userBalance = 0.0,
  });

  bool get hasEnoughBalance => amount <= userBalance && amount > 0;

  WithdrawFundsState copyWith({
    WithdrawFundsStatus? status,
    double? amount,
    String? errorMessage,
    double? newBalance,
    double? userBalance,
  }) {
    return WithdrawFundsState(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      errorMessage: errorMessage,
      newBalance: newBalance ?? this.newBalance,
      userBalance: userBalance ?? this.userBalance,
    );
  }
}